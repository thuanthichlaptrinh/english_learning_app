package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.*;
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
import java.util.concurrent.ConcurrentHashMap;
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

    // Cache cho questions và timestamps
    private final Map<Long, List<QuestionData>> sessionQuestionsCache = new ConcurrentHashMap<>();
    private final Map<Long, Map<Integer, LocalDateTime>> questionStartTimes = new ConcurrentHashMap<>();
    private final Map<Long, Integer> sessionTimeLimits = new ConcurrentHashMap<>();

    // Cache để track user game sessions cho rate limiting
    private final Map<UUID, List<LocalDateTime>> userGameStarts = new ConcurrentHashMap<>();

    private static final String GAME_NAME = "Quick Reflex Quiz";
    private static final int BASE_POINTS = 10;
    private static final int STREAK_BONUS = 5;
    private static final int SPEED_BONUS_THRESHOLD = 1500; // 1.5 seconds
    private static final int MIN_ANSWER_TIME = 100; // Minimum 100ms - chống gian lận
    private static final int MAX_GAMES_PER_5_MIN = 10; // Rate limit
    private static final int TIME_TOLERANCE_MS = 500; // Cho phép chênh lệch 500ms

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
                    "No vocabularies found" + (filterInfo.isEmpty() ? "" : " with filters:" + filterInfo));
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

    @Transactional(readOnly = true)
    public QuickQuizSessionResponse getSessionResults(Long sessionId, UUID userId) {
        log.info("Getting results for session: {}", sessionId);

        GameSession session = gameSessionRepository.findById(sessionId)
                .orElseThrow(() -> new ErrorException("Game session not found"));

        if (!session.getUser().getId().equals(userId)) {
            throw new ErrorException("Unauthorized: This session belongs to another user");
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

    // 1. Load Quick Quiz game entity
    private Game loadQuickQuizGame() {
        return gameRepository.findByName(GAME_NAME)
                .orElseThrow(() -> new ErrorException(
                        "Game 'Quick Reflex Quiz' not found. Please initialize game data."));
    }

    // 2. Get and validate vocabularies
    private List<Vocab> getAndValidateVocabs(QuickQuizStartRequest request) {
        List<Vocab> vocabs = getRandomVocabs(request);
        int requiredCount = request.getTotalQuestions() * 4;

        if (vocabs.size() < requiredCount) {
            throw new ErrorException(
                    "Not enough vocabularies. Found: " + vocabs.size() + ", Required: " + requiredCount);
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
    private void initializeSessionCaches(Long sessionId, List<QuestionData> allQuestions, int timePerQuestion) {
        // Cache questions for this session
        sessionQuestionsCache.put(sessionId, allQuestions);

        // Cache time limit for this session (convert seconds to milliseconds)
        sessionTimeLimits.put(sessionId, timePerQuestion * 1000);

        // Initialize question start times map
        questionStartTimes.put(sessionId, new ConcurrentHashMap<>());

        // Record start time for question 1
        questionStartTimes.get(sessionId).put(1, LocalDateTime.now());
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
    private GameSession validateAndLoadSession(Long sessionId, UUID userId) {
        GameSession session = gameSessionRepository.findById(sessionId)
                .orElseThrow(() -> new ErrorException("Game session not found"));

        if (!session.getUser().getId().equals(userId)) {
            throw new ErrorException("Unauthorized: This session belongs to another user");
        }

        if (session.getFinishedAt() != null) {
            throw new ErrorException("Game session already finished");
        }

        return session;
    }

    // 2. Get cached questions
    private List<QuestionData> getCachedQuestions(Long sessionId) {
        List<QuestionData> cachedQuestions = sessionQuestionsCache.get(sessionId);
        if (cachedQuestions == null || cachedQuestions.isEmpty()) {
            throw new ErrorException("Session questions not found. Please start a new game.");
        }
        return cachedQuestions;
    }

    // 3. Validate question number
    private void validateQuestionNumber(int questionNumber, int totalQuestions) {
        if (questionNumber > totalQuestions) {
            throw new ErrorException("Invalid question number");
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
            throw new ErrorException("Question already answered. Cannot submit again.");
        }
    }

    // 5. Validate answer request (option index + time)
    private void validateAnswerRequest(QuickQuizAnswerRequest request, QuestionData questionData) {
        // Validate option index
        if (request.getSelectedOptionIndex() < 0 ||
                request.getSelectedOptionIndex() >= questionData.getOptionVocabs().size()) {
            throw new ErrorException(
                    "Invalid option index: " + request.getSelectedOptionIndex() +
                            ". Valid range: 0-" + (questionData.getOptionVocabs().size() - 1));
        }

        // Validate time taken
        validateTimeTaken(request);
    }

    // 6. Validate time taken (min, max, server-side check)
    private void validateTimeTaken(QuickQuizAnswerRequest request) {
        // Check minimum time
        if (request.getTimeTaken() < MIN_ANSWER_TIME) {
            throw new ErrorException(
                    "Invalid time taken: " + request.getTimeTaken() + "ms. Minimum: " + MIN_ANSWER_TIME + "ms");
        }

        // Check timeout
        Integer timeLimit = sessionTimeLimits.get(request.getSessionId());
        if (timeLimit == null) {
            timeLimit = 3000; // Default 3 seconds
        }

        if (request.getTimeTaken() > timeLimit) {
            throw new ErrorException(
                    "Answer timeout. Time limit: " + timeLimit + "ms, but took: " + request.getTimeTaken() + "ms");
        }

        // Validate server-side timestamp
        validateServerTimestamp(request, timeLimit);
    }

    // 7. Validate server-side timestamp (anti-cheat)
    private void validateServerTimestamp(QuickQuizAnswerRequest request, int timeLimit) {
        Map<Integer, LocalDateTime> sessionTimes = questionStartTimes.get(request.getSessionId());
        if (sessionTimes != null && sessionTimes.containsKey(request.getQuestionNumber())) {
            LocalDateTime startTime = sessionTimes.get(request.getQuestionNumber());
            long actualTimeTaken = Duration.between(startTime, LocalDateTime.now()).toMillis();

            if (Math.abs(actualTimeTaken - request.getTimeTaken()) > TIME_TOLERANCE_MS) {
                log.warn("Time mismatch detected. Client: {}ms, Server: {}ms",
                        request.getTimeTaken(), actualTimeTaken);
                throw new ErrorException(
                        "Time mismatch. Possible manipulation detected. " +
                                "Client reported: " + request.getTimeTaken() + "ms, " +
                                "Server measured: " + actualTimeTaken + "ms");
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

        // Record start time for next question
        Map<Integer, LocalDateTime> sessionTimes = questionStartTimes.get(request.getSessionId());
        if (sessionTimes != null) {
            sessionTimes.put(request.getQuestionNumber() + 1, LocalDateTime.now());
        }

        Integer timeLimit = sessionTimeLimits.get(request.getSessionId());
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
        sessionQuestionsCache.remove(session.getId());
        questionStartTimes.remove(session.getId());
        sessionTimeLimits.remove(session.getId());
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

    // Rate limiting check
    private void checkRateLimit(UUID userId) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime fiveMinutesAgo = now.minusMinutes(5);

        // Get or create user's game start history
        List<LocalDateTime> gameStarts = userGameStarts.computeIfAbsent(
                userId,
                k -> new ArrayList<>());

        // Remove old entries (older than 5 minutes)
        gameStarts.removeIf(time -> time.isBefore(fiveMinutesAgo));

        // Check if exceeded limit
        if (gameStarts.size() >= MAX_GAMES_PER_5_MIN) {
            throw new ErrorException(
                    "Too many game sessions. Maximum " + MAX_GAMES_PER_5_MIN +
                            " games per 5 minutes. Please wait before starting a new game.");
        }

        // Add current game start time
        gameStarts.add(now);

        log.debug("User {} has started {} games in last 5 minutes", userId, gameStarts.size());
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
                        .timesCorrect(0)
                        .timesWrong(0)
                        .efFactor(2.5)
                        .intervalDays(1)
                        .repetition(0)
                        .build());

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

        userVocabProgressRepository.save(progress);
    }

    // Build explanation for answer
    private String buildExplanation(Vocab vocab, int correctAnswerIndex) {
        return String.format("✓ Đáp án đúng: '%s' nghĩa là '%s'", vocab.getWord(), vocab.getMeaningVi());
    }

}
