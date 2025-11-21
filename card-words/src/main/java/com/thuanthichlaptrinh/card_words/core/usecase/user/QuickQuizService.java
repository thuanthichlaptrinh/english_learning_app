package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.*;
import com.thuanthichlaptrinh.card_words.core.service.redis.GameSessionCacheService;
import com.thuanthichlaptrinh.card_words.core.service.redis.RateLimitingService;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.*;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game.QuickQuizAnswerRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game.QuickQuizStartRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.QuestionData;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.QuickQuizAnswerResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.QuickQuizQuestionResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.QuickQuizResultDetail;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.QuickQuizSessionResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.vocab.VocabOptionResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class QuickQuizService {
    private final GameRepository gameRepository;
    private final GameSessionRepository gameSessionRepository;
    private final GameSessionDetailRepository gameSessionDetailRepository;
    private final VocabRepository vocabRepository;
    private final UserVocabProgressRepository userVocabProgressRepository;
    private final StreakService streakService;
    private final LeaderboardService leaderboardService;
    private final NotificationService notificationService;

    // Redis services for distributed caching
    private final GameSessionCacheService gameSessionCacheService;
    private final RateLimitingService rateLimitingService;

    private static final String GAME_NAME = "Quick Reflex Quiz";
    private static final int BASE_POINTS = 10;
    private static final int STREAK_BONUS = 5;
    private static final int SPEED_BONUS_THRESHOLD = 1500; // 1.5 seconds
    private static final int MIN_ANSWER_TIME = 100; // Minimum 100ms - chống gian lận
    private static final int MAX_GAMES_PER_5_MIN = 10; // Rate limit
    private static final int TIME_TOLERANCE_MS = 3000; // Cho phép chênh lệch 3000ms (3 giây) để tránh network latency

    private List<Vocab> getRandomVocabs(QuickQuizStartRequest request) {
        List<Vocab> vocabs;

        String cefr = request.getCefr();

        // Apply filters based on request
        if (cefr != null && !cefr.trim().isEmpty()) {
            // Only CEFR filter
            vocabs = vocabRepository.findByCefr(cefr.trim().toUpperCase());
        } else {
            // No filter - get all vocabs (random topic)
            vocabs = vocabRepository.findAll();
        }

        if (vocabs.isEmpty()) {
            String filterInfo = "";
            if (cefr != null && !cefr.trim().isEmpty()) {
                filterInfo += " cefr='" + cefr + "'";
            }
            throw new ErrorException(
                    "Không tìm thấy từ vựng" + (filterInfo.isEmpty() ? "" : " với bộ lọc:" + filterInfo));
        }

        // Shuffle for randomness
        Collections.shuffle(vocabs);

        // Need totalQuestions * 4 vocabs (1 for question + 3 for wrong options)
        return vocabs.stream()
                .limit(request.getTotalQuestions() * 4)
                .collect(Collectors.toList());
    }

    @Transactional
    public QuickQuizSessionResponse startGame(QuickQuizStartRequest request, UUID userId) {
        log.info("Starting Quick Quiz game for user: {}, totalQuestions: {}", userId, request.getTotalQuestions());

        // ⭐ Validate request parameters
        validateQuickQuizRequest(request);

        // 1. Check rate limit
        checkRateLimit(userId);
        // 2. Load game entity
        Game game = loadQuickQuizGame();
        // 3. Get and validate vocabularies
        List<Vocab> vocabs = getAndValidateVocabs(request);
        // 4. Create game session
        GameSession session = createGameSession(userId, game, request.getTotalQuestions());
        // 5. Generate and cache all questions
        List<QuestionData> allQuestions = generateAllQuestions(vocabs, request.getTotalQuestions());
        // 6. Initialize session caches
        initializeSessionCaches(session.getId(), allQuestions, request.getTimePerQuestion());
        // 7. Build first question
        QuickQuizQuestionResponse firstQuestion = buildFirstQuestion(allQuestions.get(0), request.getTimePerQuestion());
        // 8. Build and return session response
        return buildSessionResponse(session, request.getTimePerQuestion(), firstQuestion);
    }

    // Submit an answer and get next question or final results
    @Transactional
    public QuickQuizAnswerResponse submitAnswer(QuickQuizAnswerRequest request, UUID userId) {
        log.info("Submitting answer for session: {}, question: {}", request.getSessionId(),
                request.getQuestionNumber());

        // 1. Validate and load session
        GameSession session = validateAndLoadSession(request.getSessionId(), userId);

        // 2. Get cached questions and validate
        List<QuestionData> cachedQuestions = getCachedQuestions(request.getSessionId());
        validateQuestionNumber(request.getQuestionNumber(), cachedQuestions.size());

        // 3. Check duplicate answer
        checkDuplicateAnswer(session, cachedQuestions, request.getQuestionNumber());

        // 4. Get current question data
        QuestionData currentQuestionData = cachedQuestions.get(request.getQuestionNumber() - 1);

        // 5. Validate answer request
        validateAnswerRequest(request, currentQuestionData);

        // 6. Process answer and calculate score
        AnswerResult answerResult = processAnswer(request, session, currentQuestionData);

        // 7. Update spaced repetition progress
        updateVocabProgress(userId, currentQuestionData.getMainVocab().getId(), answerResult.isCorrect());

        // 8. Prepare next question or finish game
        QuickQuizQuestionResponse nextQuestion = prepareNextQuestionOrFinish(
                request, session, cachedQuestions, answerResult.getDetails());

        // 9. Save session
        gameSessionRepository.save(session);

        // 10. Build and return response
        return buildAnswerResponse(request, session, currentQuestionData, answerResult, nextQuestion);
    }

    // Skip question (timeout or user chooses to skip)
    @Transactional
    public QuickQuizAnswerResponse skipQuestion(QuickQuizAnswerRequest request, UUID userId) {
        log.info("Skipping question for session: {}, question: {}", request.getSessionId(),
                request.getQuestionNumber());

        // 1. Validate and load session
        GameSession session = validateAndLoadSession(request.getSessionId(), userId);

        // 2. Get cached questions and validate
        List<QuestionData> cachedQuestions = getCachedQuestions(request.getSessionId());
        validateQuestionNumber(request.getQuestionNumber(), cachedQuestions.size());

        // 3. Check duplicate answer
        checkDuplicateAnswer(session, cachedQuestions, request.getQuestionNumber());

        // 4. Get current question data
        QuestionData currentQuestionData = cachedQuestions.get(request.getQuestionNumber() - 1);

        // 5. Process as wrong answer (timeout/skip = wrong)
        AnswerResult answerResult = processSkippedAnswer(session, currentQuestionData, request.getTimeTaken());

        // 6. Update spaced repetition progress (mark as wrong)
        updateVocabProgress(userId, currentQuestionData.getMainVocab().getId(), false);

        // 7. Prepare next question or finish game
        QuickQuizQuestionResponse nextQuestion = prepareNextQuestionOrFinish(
                request, session, cachedQuestions, answerResult.getDetails());

        // 8. Save session
        gameSessionRepository.save(session);

        // 9. Build and return response for skipped question
        return QuickQuizAnswerResponse.builder()
                .sessionId(session.getId())
                .questionNumber(request.getQuestionNumber())
                .isCorrect(false)
                .correctAnswerIndex(currentQuestionData.getCorrectAnswerIndex())
                .currentScore(session.getScore())
                .currentStreak(0)
                .comboBonus(0)
                .explanation("⏱ Hết giờ! Đáp án đúng: " +
                        currentQuestionData.getOptionVocabs().get(currentQuestionData.getCorrectAnswerIndex())
                                .getMeaningVi())
                .hasNextQuestion(nextQuestion != null)
                .nextQuestion(nextQuestion)
                .build();
    }

    @Transactional(readOnly = true)
    public QuickQuizSessionResponse getSessionResults(UUID sessionId, UUID userId) {
        log.info("Getting results for session: {}", sessionId);

        GameSession session = gameSessionRepository.findById(sessionId)
                .orElseThrow(() -> new ErrorException("Không tìm thấy session game"));

        if (!session.getUser().getId().equals(userId)) {
            throw new ErrorException("Không có quyền: Session này thuộc về người dùng khác");
        }

        List<GameSessionDetail> details = new ArrayList<>(session.getDetails());

        // Build results
        List<QuickQuizResultDetail> results = new ArrayList<>();
        for (int i = 0; i < details.size(); i++) {
            GameSessionDetail detail = details.get(i);
            results.add(QuickQuizResultDetail.builder()
                    .questionNumber(i + 1)
                    .word(detail.getVocab().getWord())
                    .correctMeaning(detail.getVocab().getMeaningVi())
                    .displayedMeaning("Meaning shown")
                    .isCorrectPair(true)
                    .userAnswer(detail.getIsCorrect())
                    .isCorrect(detail.getIsCorrect())
                    .timeTaken(detail.getTimeTaken())
                    .pointsEarned(detail.getIsCorrect() ? BASE_POINTS : 0)
                    .build());
        }

        int totalTime = details.stream().mapToInt(GameSessionDetail::getTimeTaken).sum();
        int avgTime = details.isEmpty() ? 0 : totalTime / details.size();

        return QuickQuizSessionResponse.builder()
                .sessionId(session.getId())
                .gameType(GAME_NAME)
                .status(session.getFinishedAt() != null ? "COMPLETED" : "IN_PROGRESS")
                .totalQuestions(session.getTotalQuestions())
                .timePerQuestion(3) // default
                .currentQuestionNumber(details.size())
                .correctCount(session.getCorrectCount())
                .wrongCount(details.size() - session.getCorrectCount())
                .currentStreak(0)
                .longestStreak(calculateLongestStreak(details))
                .totalScore(session.getScore())
                .accuracy(session.getAccuracy())
                .averageTimePerQuestion(avgTime)
                .startedAt(session.getStartedAt())
                .finishedAt(session.getFinishedAt())
                .totalDuration(session.getDuration())
                .results(results)
                .build();
    }

    // ==================== PRIVATE HELPER METHODS ====================

    // ===== Helper methods for startGame() =====

    // Validate QuickQuiz request parameters
    private void validateQuickQuizRequest(QuickQuizStartRequest request) {
        Integer totalQuestions = request.getTotalQuestions();
        Integer timePerQuestion = request.getTimePerQuestion();

        if (totalQuestions != null && (totalQuestions < 2 || totalQuestions > 40)) {
            throw new ErrorException("Số câu hỏi phải trong khoảng 2-40");
        }

        if (timePerQuestion != null && (timePerQuestion < 3 || timePerQuestion > 60)) {
            throw new ErrorException("Thời gian mỗi câu phải trong khoảng 3-60 giây");
        }
    }

    // 1. Load Quick Quiz game entity
    private Game loadQuickQuizGame() {
        return gameRepository.findByName(GAME_NAME)
                .orElseThrow(() -> new ErrorException(
                        "Không tìm thấy game 'Quick Reflex Quiz'. Vui lòng khởi tạo dữ liệu game."));
    }

    // 2. Get and validate vocabularies
    private List<Vocab> getAndValidateVocabs(QuickQuizStartRequest request) {
        List<Vocab> vocabs = getRandomVocabs(request);
        int requiredCount = request.getTotalQuestions() * 4;

        if (vocabs.size() < requiredCount) {
            throw new ErrorException(
                    "Không đủ từ vựng. Đã tìm thấy: " + vocabs.size() + ", Yêu cầu: " + requiredCount);
        }

        return vocabs;
    }

    // 3. Create game session
    private GameSession createGameSession(UUID userId, Game game, int totalQuestions) {
        User user = new User();
        user.setId(userId);

        GameSession session = GameSession.builder()
                .user(user)
                .game(game)
                .topic(null) // No topic filter - random
                .startedAt(LocalDateTime.now())
                .totalQuestions(totalQuestions)
                .correctCount(0)
                .score(0)
                .build();

        session = gameSessionRepository.save(session);
        log.info("Created game session ID: {}", session.getId());

        return session;
    }

    // 4. Generate all questions for the game
    private List<QuestionData> generateAllQuestions(List<Vocab> vocabs, int totalQuestions) {
        List<QuestionData> allQuestions = new ArrayList<>();

        for (int i = 0; i < totalQuestions; i++) {
            QuestionData questionData = generateSingleQuestion(vocabs, i);
            allQuestions.add(questionData);
        }

        return allQuestions;
    }

    // 5. Generate single question with 4 options
    private QuestionData generateSingleQuestion(List<Vocab> vocabs, int questionIndex) {
        Vocab correctVocab = vocabs.get(questionIndex * 4); // Main vocab
        Vocab wrongVocab1 = vocabs.get(questionIndex * 4 + 1); // Wrong option 1
        Vocab wrongVocab2 = vocabs.get(questionIndex * 4 + 2); // Wrong option 2
        Vocab wrongVocab3 = vocabs.get(questionIndex * 4 + 3); // Wrong option 3

        List<Vocab> optionVocabs = new ArrayList<>();
        optionVocabs.add(correctVocab); // Correct answer
        optionVocabs.add(wrongVocab1); // Wrong answer 1
        optionVocabs.add(wrongVocab2); // Wrong answer 2
        optionVocabs.add(wrongVocab3); // Wrong answer 3

        // Shuffle options to randomize position
        Collections.shuffle(optionVocabs);

        // Find correct answer index after shuffle
        int correctIndex = optionVocabs.indexOf(correctVocab);

        return new QuestionData(correctVocab, optionVocabs, correctIndex);
    }

    // 6. Initialize session caches (questions, time limits, timestamps)
    private void initializeSessionCaches(UUID sessionId, List<QuestionData> allQuestions, int timePerQuestion) {
        log.info("🚀 Initializing caches for session {}: {} questions, {} sec per question",
                sessionId, allQuestions.size(), timePerQuestion);

        // Cache questions for this session in Redis (30 min TTL)
        log.info("📝 Step 1: Caching questions...");
        gameSessionCacheService.cacheQuizQuestions(sessionId, allQuestions);

        // Cache time limit for this session in Redis (convert seconds to milliseconds)
        log.info("⏱️ Step 2: Caching time limit...");
        gameSessionCacheService.cacheSessionTimeLimit(sessionId, timePerQuestion * 1000);

        // Record start time for question 1
        log.info("🕐 Step 3: Caching question start time...");
        gameSessionCacheService.cacheQuestionStartTime(sessionId, 1, LocalDateTime.now());

        log.info("✅ All caches initialized for session {}", sessionId);
    }

    // 7. Build first question response
    private QuickQuizQuestionResponse buildFirstQuestion(QuestionData firstQuestionData, int timePerQuestion) {
        QuickQuizQuestionResponse firstQuestion = buildQuestionResponse(
                firstQuestionData,
                timePerQuestion * 1000);
        firstQuestion.setQuestionNumber(1);
        return firstQuestion;
    }

    // 8. Build session response
    private QuickQuizSessionResponse buildSessionResponse(
            GameSession session,
            int timePerQuestion,
            QuickQuizQuestionResponse firstQuestion) {

        return QuickQuizSessionResponse.builder()
                .sessionId(session.getId())
                .gameType(GAME_NAME)
                .status("IN_PROGRESS")
                .totalQuestions(session.getTotalQuestions())
                .timePerQuestion(timePerQuestion)
                .currentQuestionNumber(1)
                .correctCount(0)
                .wrongCount(0)
                .currentStreak(0)
                .longestStreak(0)
                .totalScore(0)
                .accuracy(0.0)
                .averageTimePerQuestion(0)
                .startedAt(session.getStartedAt())
                .currentQuestion(firstQuestion)
                .build();
    }

    // ===== Helper methods for submitAnswer() =====

    // Inner class to hold answer processing result
    @lombok.Data
    @lombok.AllArgsConstructor
    private static class AnswerResult {
        private boolean isCorrect;
        private int pointsEarned;
        private int currentStreak;
        private List<GameSessionDetail> details;
    }

    // 1. Validate and load session
    private GameSession validateAndLoadSession(UUID sessionId, UUID userId) {
        GameSession session = gameSessionRepository.findById(sessionId)
                .orElseThrow(() -> new ErrorException("Không tìm thấy session game"));

        if (!session.getUser().getId().equals(userId)) {
            throw new ErrorException("Không có quyền: Session này thuộc về người dùng khác");
        }

        if (session.getFinishedAt() != null) {
            throw new ErrorException("Session game đã kết thúc");
        }

        return session;
    }

    // 2. Get cached questions from Redis
    private List<QuestionData> getCachedQuestions(UUID sessionId) {
        List<QuestionData> cachedQuestions = gameSessionCacheService.getQuizQuestions(sessionId);
        if (cachedQuestions == null || cachedQuestions.isEmpty()) {
            throw new ErrorException("Không tìm thấy câu hỏi của session. Vui lòng bắt đầu game mới.");
        }
        return cachedQuestions;
    }

    // 3. Validate question number
    private void validateQuestionNumber(int questionNumber, int totalQuestions) {
        if (questionNumber > totalQuestions) {
            throw new ErrorException("Số câu hỏi không hợp lệ");
        }
    }

    // 4. Check duplicate answer
    private void checkDuplicateAnswer(GameSession session, List<QuestionData> cachedQuestions, int questionNumber) {
        List<GameSessionDetail> existingDetails = new ArrayList<>(session.getDetails());
        long answeredCount = existingDetails.stream()
                .filter(d -> d.getVocab().getId().equals(
                        cachedQuestions.get(questionNumber - 1).getMainVocab().getId()))
                .count();

        if (answeredCount > 0) {
            throw new ErrorException("Câu hỏi đã được trả lời. Không thể gửi lại.");
        }
    }

    // 5. Validate answer request (option index + time)
    private void validateAnswerRequest(QuickQuizAnswerRequest request, QuestionData questionData) {
        // Validate option index
        if (request.getSelectedOptionIndex() < 0 ||
                request.getSelectedOptionIndex() >= questionData.getOptionVocabs().size()) {
            throw new ErrorException(
                    "Chỉ số tùy chọn không hợp lệ: " + request.getSelectedOptionIndex() +
                            ". Khoảng hợp lệ: 0-" + (questionData.getOptionVocabs().size() - 1));
        }

        // Validate time taken
        validateTimeTaken(request);
    }

    // 6. Validate time taken (min, max, server-side check)
    private void validateTimeTaken(QuickQuizAnswerRequest request) {
        // Check minimum time
        if (request.getTimeTaken() < MIN_ANSWER_TIME) {
            throw new ErrorException(
                    "Thời gian trả lời không hợp lệ: " + request.getTimeTaken() + "ms. Tối thiểu: " + MIN_ANSWER_TIME
                            + "ms");
        }

        // Check timeout
        Integer timeLimit = gameSessionCacheService.getSessionTimeLimit(request.getSessionId());
        if (timeLimit == null) {
            timeLimit = 3000; // Default 3 seconds
        }

        if (request.getTimeTaken() > timeLimit) {
            throw new ErrorException(
                    "Hết thời gian trả lời. Giới hạn: " + timeLimit + "ms, nhưng mất: " + request.getTimeTaken()
                            + "ms");
        }

        // Validate server-side timestamp
        validateServerTimestamp(request, timeLimit);
    }

    // 7. Validate server-side timestamp (anti-cheat)
    private void validateServerTimestamp(QuickQuizAnswerRequest request, int timeLimit) {
        LocalDateTime startTime = gameSessionCacheService.getQuestionStartTime(
                request.getSessionId(),
                request.getQuestionNumber());

        if (startTime != null) {
            long actualTimeTaken = Duration.between(startTime, LocalDateTime.now()).toMillis();

            // Cho phép client báo cáo thời gian nhỏ hơn server (do network delay)
            // Nhưng không cho phép quá nhanh (< MIN_ANSWER_TIME) hoặc quá lâu (> timeLimit
            // + tolerance)
            if (actualTimeTaken > timeLimit + TIME_TOLERANCE_MS) {
                log.warn("Time exceeded. Client: {}ms, Server: {}ms, Limit: {}ms",
                        request.getTimeTaken(), actualTimeTaken, timeLimit);
                throw new ErrorException(
                        "Hết thời gian. Máy chủ đo: " + actualTimeTaken + "ms, " +
                                "Giới hạn: " + timeLimit + "ms");
            }

            // Warning nếu chênh lệch quá lớn nhưng không throw error
            if (Math.abs(actualTimeTaken - request.getTimeTaken()) > TIME_TOLERANCE_MS) {
                log.warn("Large time mismatch (acceptable). Client: {}ms, Server: {}ms, Diff: {}ms",
                        request.getTimeTaken(), actualTimeTaken,
                        Math.abs(actualTimeTaken - request.getTimeTaken()));
            }
        }
    }

    // 8. Process answer and calculate score
    private AnswerResult processAnswer(QuickQuizAnswerRequest request, GameSession session,
            QuestionData questionData) {
        Vocab currentVocab = questionData.getMainVocab();
        Boolean isUserCorrect = request.getSelectedOptionIndex().equals(questionData.getCorrectAnswerIndex());

        List<GameSessionDetail> details = new ArrayList<>(session.getDetails());

        // Calculate points and streak
        int pointsEarned = 0;
        int currentStreak = calculateCurrentStreak(details);

        if (isUserCorrect) {
            pointsEarned = BASE_POINTS;
            currentStreak++;

            // Streak bonus
            if (currentStreak >= 3) {
                pointsEarned += STREAK_BONUS * (currentStreak / 3);
            }

            // Speed bonus
            if (request.getTimeTaken() < SPEED_BONUS_THRESHOLD) {
                pointsEarned += 5;
            }

            session.setCorrectCount(session.getCorrectCount() + 1);
        } else {
            currentStreak = 0;
        }

        // Save answer detail
        GameSessionDetail detail = GameSessionDetail.builder()
                .session(session)
                .vocab(currentVocab)
                .isCorrect(isUserCorrect)
                .timeTaken(request.getTimeTaken())
                .build();

        details.add(detail);
        gameSessionDetailRepository.save(detail);

        // Update session score
        session.setScore(session.getScore() + pointsEarned);

        return new AnswerResult(isUserCorrect, pointsEarned, currentStreak, details);
    }

    // Process skipped answer (timeout or user skip)
    private AnswerResult processSkippedAnswer(GameSession session, QuestionData questionData, Integer timeTaken) {
        Vocab currentVocab = questionData.getMainVocab();
        List<GameSessionDetail> details = new ArrayList<>(session.getDetails());

        // Skipped = wrong answer, no points, reset streak
        int pointsEarned = 0;
        int currentStreak = 0;

        // Save answer detail as wrong
        GameSessionDetail detail = GameSessionDetail.builder()
                .session(session)
                .vocab(currentVocab)
                .isCorrect(false) // Skipped = wrong
                .timeTaken(timeTaken != null ? timeTaken : 0)
                .build();

        details.add(detail);
        gameSessionDetailRepository.save(detail);

        // No score update for skipped questions
        log.info("Question skipped. Session: {}, Vocab: {}", session.getId(), currentVocab.getWord());

        return new AnswerResult(false, pointsEarned, currentStreak, details);
    }

    // 9. Prepare next question or finish game
    private QuickQuizQuestionResponse prepareNextQuestionOrFinish(
            QuickQuizAnswerRequest request,
            GameSession session,
            List<QuestionData> cachedQuestions,
            List<GameSessionDetail> details) {

        boolean hasNextQuestion = request.getQuestionNumber() < session.getTotalQuestions();

        if (hasNextQuestion) {
            return prepareNextQuestion(request, cachedQuestions);
        } else {
            finishGameAndCleanup(session, details);
            return null;
        }
    }

    // 10. Prepare next question
    private QuickQuizQuestionResponse prepareNextQuestion(QuickQuizAnswerRequest request,
            List<QuestionData> cachedQuestions) {
        QuestionData nextQuestionData = cachedQuestions.get(request.getQuestionNumber());

        // Record start time for next question in Redis
        gameSessionCacheService.cacheQuestionStartTime(
                request.getSessionId(),
                request.getQuestionNumber() + 1,
                LocalDateTime.now());

        Integer timeLimit = gameSessionCacheService.getSessionTimeLimit(request.getSessionId());
        if (timeLimit == null) {
            timeLimit = 3000;
        }

        QuickQuizQuestionResponse nextQuestion = buildQuestionResponse(nextQuestionData, timeLimit);
        nextQuestion.setQuestionNumber(request.getQuestionNumber() + 1);

        return nextQuestion;
    }

    // 11. Finish game and cleanup caches
    private void finishGameAndCleanup(GameSession session, List<GameSessionDetail> details) {
        finishGame(session, details);

        // Record streak AFTER finishing game (outside main transaction)
        recordStreakActivitySafely(session.getUser());

        // Cleanup Redis caches
        gameSessionCacheService.deleteQuizSessionCache(session.getId());
    }

    // 12. Build answer response
    private QuickQuizAnswerResponse buildAnswerResponse(
            QuickQuizAnswerRequest request,
            GameSession session,
            QuestionData questionData,
            AnswerResult result,
            QuickQuizQuestionResponse nextQuestion) {

        return QuickQuizAnswerResponse.builder()
                .sessionId(session.getId())
                .questionNumber(request.getQuestionNumber())
                .isCorrect(result.isCorrect())
                .correctAnswerIndex(questionData.getCorrectAnswerIndex())
                .currentScore(session.getScore())
                .currentStreak(result.getCurrentStreak())
                .comboBonus(result.getCurrentStreak() >= 3 ? STREAK_BONUS * (result.getCurrentStreak() / 3) : 0)
                .explanation(buildExplanation(questionData.getMainVocab(), questionData.getCorrectAnswerIndex()))
                .hasNextQuestion(nextQuestion != null)
                .nextQuestion(nextQuestion)
                .build();
    }

    // Convert Vocab to VocabOptionResponse
    private VocabOptionResponse toVocabOptionResponse(Vocab vocab) {
        return VocabOptionResponse.builder()
                .word(vocab.getWord())
                .transcription(vocab.getTranscription())
                .meaningVi(vocab.getMeaningVi())
                .interpret(vocab.getInterpret())
                .exampleSentence(vocab.getExampleSentence())
                .cefr(vocab.getCefr())
                .img(vocab.getImg())
                .audio(vocab.getAudio())
                .credit(vocab.getCredit())
                .build();
    }

    // Build QuickQuizQuestionResponse from QuestionData
    private QuickQuizQuestionResponse buildQuestionResponse(QuestionData questionData, int timeLimit) {
        Vocab mainVocab = questionData.getMainVocab();

        // Convert option vocabs to VocabOptionResponse
        List<VocabOptionResponse> optionResponses = questionData.getOptionVocabs()
                .stream()
                .map(this::toVocabOptionResponse)
                .collect(Collectors.toList());

        return QuickQuizQuestionResponse.builder()
                .questionNumber(null) // Will be set by caller
                .vocabId(mainVocab.getId())
                .word(mainVocab.getWord())
                .transcription(mainVocab.getTranscription())
                .meaningVi(mainVocab.getMeaningVi())
                .interpret(mainVocab.getInterpret())
                .exampleSentence(mainVocab.getExampleSentence())
                .cefr(mainVocab.getCefr())
                .img(mainVocab.getImg())
                .audio(mainVocab.getAudio())
                .credit(mainVocab.getCredit())
                .options(optionResponses)
                .correctAnswerIndex(null) // Don't send to client
                .timeLimit(timeLimit)
                .build();
    }

    // Rate limiting check using Redis
    private void checkRateLimit(UUID userId) {
        RateLimitingService.RateLimitResult result = rateLimitingService.checkGameRateLimit(
                userId,
                "quickquiz",
                MAX_GAMES_PER_5_MIN,
                Duration.ofMinutes(5));

        if (!result.isAllowed()) {
            throw new ErrorException(
                    "Quá nhiều phiên chơi. Tối đa " + MAX_GAMES_PER_5_MIN +
                            " game mỗi 5 phút. Vui lòng đợi " + result.getResetInSeconds() +
                            " giây trước khi bắt đầu game mới.");
        }

        log.debug("User {} passed rate limit check: {}/{} games",
                userId, result.getCurrentCount(), MAX_GAMES_PER_5_MIN);
    }

    // Calculate current streak
    private int calculateCurrentStreak(List<GameSessionDetail> details) {
        int streak = 0;
        for (int i = details.size() - 1; i >= 0; i--) {
            if (details.get(i).getIsCorrect()) {
                streak++;
            } else {
                break;
            }
        }
        return streak;
    }

    // Calculate longest streak in session
    private int calculateLongestStreak(List<GameSessionDetail> details) {
        int longest = 0;
        int current = 0;

        for (GameSessionDetail detail : details) {
            if (detail.getIsCorrect()) {
                current++;
                longest = Math.max(longest, current);
            } else {
                current = 0;
            }
        }

        return longest;
    }

    // Finish game and calculate final stats
    private void finishGame(GameSession session, List<GameSessionDetail> details) {
        session.setFinishedAt(LocalDateTime.now());

        // Calculate duration in seconds
        long duration = Duration.between(session.getStartedAt(), session.getFinishedAt()).getSeconds();
        session.setDuration((int) duration);

        // Calculate accuracy
        double accuracy = details.isEmpty() ? 0.0 : (session.getCorrectCount() * 100.0) / details.size();
        session.setAccuracy(accuracy);

        log.info("Game finished. Score: {}, Accuracy: {}%, Duration: {}s",
                session.getScore(), String.format("%.1f", accuracy), duration);

        // ✨ UPDATE LEADERBOARD after game finished
        try {
            leaderboardService.updateUserScore(session.getUser().getId(), "quick-quiz", session.getScore());
            log.info("📊 Leaderboard updated for user: {}, score: {}", session.getUser().getId(), session.getScore());
        } catch (Exception e) {
            log.error("❌ Failed to update leaderboard: {}", e.getMessage(), e);
        }

        // 🔔 CREATE ACHIEVEMENT NOTIFICATIONS
        createGameAchievementNotifications(session, accuracy);
    }

    // Create achievement notifications based on game performance
    private void createGameAchievementNotifications(GameSession session, double accuracy) {
        try {
            User user = session.getUser();
            int score = session.getScore();
            int correctCount = session.getCorrectCount();
            int totalQuestions = session.getTotalQuestions();

            // 🏆 High Score Achievement (score >= 80)
            if (score >= 80) {
                com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest request = com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest
                        .builder()
                        .userId(user.getId())
                        .title("🏆 High Score Achievement!")
                        .content(String.format(
                                "Congratulations! You scored %d points in Quick Quiz. Keep up the excellent work!",
                                score))
                        .type("achievement")
                        .build();
                notificationService.createNotification(request);
            }

            // 🎯 Perfect Accuracy (100%)
            if (accuracy >= 100.0) {
                com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest request = com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest
                        .builder()
                        .userId(user.getId())
                        .title("🎯 Perfect Score!")
                        .content(String.format("Amazing! You answered all %d questions correctly with 100%% accuracy!",
                                totalQuestions))
                        .type("achievement")
                        .build();
                notificationService.createNotification(request);
            }
            // 📈 Excellent Accuracy (90-99%)
            else if (accuracy >= 90.0) {
                com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest request = com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest
                        .builder()
                        .userId(user.getId())
                        .title("📈 Excellent Performance!")
                        .content(String.format(
                                "Great job! You achieved %.1f%% accuracy with %d out of %d correct answers!",
                                accuracy, correctCount, totalQuestions))
                        .type("achievement")
                        .build();
                notificationService.createNotification(request);
            }

            log.info("✅ Achievement notifications created for user: {}", user.getId());
        } catch (Exception e) {
            log.error("❌ Failed to create achievement notifications: {}", e.getMessage(), e);
        }
    }

    // Record streak in separate method to avoid transaction issues
    private void recordStreakActivitySafely(User user) {
        try {
            streakService.recordActivity(user);
            log.info("Streak activity recorded for user: {}", user.getId());
        } catch (Exception e) {
            log.error("Failed to record streak activity: {}", e.getMessage(), e);
        }
    }

    // Update user vocabulary progress (Spaced Repetition)
    private void updateVocabProgress(UUID userId, UUID vocabId, boolean isCorrect) {
        User user = new User();
        user.setId(userId);

        Vocab vocab = new Vocab();
        vocab.setId(vocabId);

        UserVocabProgress progress = userVocabProgressRepository
                .findByUserIdAndVocabId(userId, vocabId)
                .orElse(UserVocabProgress.builder()
                        .user(user)
                        .vocab(vocab)
                        .status(com.thuanthichlaptrinh.card_words.common.enums.VocabStatus.NEW) // Set NEW for first
                                                                                                // time
                        .timesCorrect(0)
                        .timesWrong(0)
                        .efFactor(2.5)
                        .intervalDays(1)
                        .repetition(0)
                        .build());

        // Save current status for logging
        com.thuanthichlaptrinh.card_words.common.enums.VocabStatus oldStatus = progress.getStatus();

        if (isCorrect) {
            progress.setTimesCorrect(progress.getTimesCorrect() + 1);
            progress.setRepetition(progress.getRepetition() + 1);

            // SM-2 algorithm: increase interval
            if (progress.getRepetition() == 1) {
                progress.setIntervalDays(1);
            } else if (progress.getRepetition() == 2) {
                progress.setIntervalDays(6);
            } else {
                progress.setIntervalDays((int) (progress.getIntervalDays() * progress.getEfFactor()));
            }
        } else {
            progress.setTimesWrong(progress.getTimesWrong() + 1);
            progress.setRepetition(0); // Reset
            progress.setIntervalDays(1);
        }

        // Calculate and update status using VocabStatusCalculator
        com.thuanthichlaptrinh.card_words.common.enums.VocabStatus newStatus = com.thuanthichlaptrinh.card_words.common.utils.VocabStatusCalculator
                .calculateStatus(
                        oldStatus,
                        progress.getTimesCorrect(),
                        progress.getTimesWrong());
        progress.setStatus(newStatus);

        // Update review dates
        progress.setLastReviewed(java.time.LocalDate.now());
        if (progress.getIntervalDays() != null && progress.getIntervalDays() > 0) {
            progress.setNextReviewDate(java.time.LocalDate.now().plusDays(progress.getIntervalDays()));
        }

        userVocabProgressRepository.save(progress);

        // Log status change
        if (oldStatus != newStatus) {
            log.info("Quick Quiz - Vocab status updated: userId={}, vocabId={}, {} -> {}, accuracy={}",
                    userId, vocabId, oldStatus, newStatus,
                    com.thuanthichlaptrinh.card_words.common.utils.VocabStatusCalculator.formatAccuracy(
                            progress.getTimesCorrect(), progress.getTimesWrong()));
        }
    }

    // Build explanation for answer
    private String buildExplanation(Vocab vocab, int correctAnswerIndex) {
        return String.format("✓ Đáp án đúng: '%s' nghĩa là '%s'", vocab.getWord(), vocab.getMeaningVi());
    }

}
