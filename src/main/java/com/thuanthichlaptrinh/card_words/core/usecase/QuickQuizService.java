package com.thuanthichlaptrinh.card_words.core.usecase;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.*;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.*;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.QuickQuizAnswerRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.QuickQuizStartRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.*;
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
    private final TopicRepository topicRepository;

    // Cache to store generated questions per session
    private final Map<Long, List<QuestionData>> sessionQuestionsCache = new ConcurrentHashMap<>();

    private static final String GAME_NAME = "Quick Reflex Quiz";
    private static final int BASE_POINTS = 10;
    private static final int STREAK_BONUS = 5;
    private static final int SPEED_BONUS_THRESHOLD = 1500; // 1.5 seconds

    // Inner class to store question data
    @lombok.Data
    @lombok.AllArgsConstructor
    private static class QuestionData {
        private UUID vocabId;
        private String word;
        private String correctMeaning;
        private String displayedMeaning;
        private boolean isCorrectPair;
    }

    private List<Vocab> getRandomVocabs(QuickQuizStartRequest request) {
        List<Vocab> vocabs;

        String topicName = request.getTopicName();
        String cefr = request.getCefr();

        // Apply filters based on request
        if (topicName != null && !topicName.trim().isEmpty() && cefr != null && !cefr.trim().isEmpty()) {
            // Both topic and CEFR filter
            vocabs = vocabRepository.findByTopicNameAndCefr(topicName.trim(), cefr.trim().toUpperCase());
        } else if (topicName != null && !topicName.trim().isEmpty()) {
            // Only topic filter
            vocabs = vocabRepository.findByTopicNameIgnoreCase(topicName.trim());
        } else if (cefr != null && !cefr.trim().isEmpty()) {
            // Only CEFR filter
            vocabs = vocabRepository.findByCefr(cefr.trim().toUpperCase());
        } else {
            // No filter - get all vocabs
            vocabs = vocabRepository.findAll();
        }

        if (vocabs.isEmpty()) {
            String filterInfo = "";
            if (topicName != null && !topicName.trim().isEmpty()) {
                filterInfo += " topic='" + topicName + "'";
            }
            if (cefr != null && !cefr.trim().isEmpty()) {
                filterInfo += " cefr='" + cefr + "'";
            }
            throw new ErrorException(
                    "No vocabularies found" + (filterInfo.isEmpty() ? "" : " with filters:" + filterInfo));
        }

        // Shuffle for randomness
        Collections.shuffle(vocabs);

        return vocabs.stream()
                .limit(request.getTotalQuestions() * 2)
                .collect(Collectors.toList());
    }

    @Transactional
    public QuickQuizSessionResponse startGame(QuickQuizStartRequest request, UUID userId) {
        log.info("Starting Quick Quiz game for user: {}, totalQuestions: {}", userId, request.getTotalQuestions());

        // Find or create game
        Game game = gameRepository.findByName(GAME_NAME)
                .orElseThrow(
                        () -> new ErrorException("Game 'Quick Reflex Quiz' not found. Please initialize game data."));

        // Get random vocabularies based on filters
        List<Vocab> vocabs = getRandomVocabs(request);

        if (vocabs.size() < request.getTotalQuestions()) {
            throw new ErrorException("Not enough vocabularies. Found: " + vocabs.size()
                    + ", Required: " + request.getTotalQuestions());
        }

        // Create game session
        User user = new User();
        user.setId(userId);

        Topic topic = null;
        if (request.getTopicName() != null && !request.getTopicName().trim().isEmpty()) {
            topic = topicRepository.findByNameIgnoreCase(request.getTopicName().trim())
                    .orElseThrow(() -> new ErrorException("Topic '" + request.getTopicName() + "' not found"));
        }

        GameSession session = GameSession.builder()
                .user(user)
                .game(game)
                .topic(topic)
                .startedAt(LocalDateTime.now())
                .totalQuestions(request.getTotalQuestions())
                .correctCount(0)
                .score(0)
                .build();

        session = gameSessionRepository.save(session);
        log.info("Created game session ID: {}", session.getId());

        // Generate and cache all questions at start
        List<QuestionData> allQuestions = new ArrayList<>();
        Random random = new Random();

        for (int i = 0; i < request.getTotalQuestions(); i++) {
            Vocab vocab = vocabs.get(i);
            boolean showCorrectMeaning = random.nextBoolean();

            String displayedMeaning;
            if (showCorrectMeaning) {
                displayedMeaning = vocab.getMeaningVi();
            } else {
                // Get wrong meaning from another vocab
                Vocab wrongVocab = vocabs.stream()
                        .filter(v -> !v.getId().equals(vocab.getId()))
                        .findFirst()
                        .orElse(vocabs.get((i + 1) % vocabs.size()));
                displayedMeaning = wrongVocab.getMeaningVi();
            }

            allQuestions.add(new QuestionData(
                    vocab.getId(),
                    vocab.getWord(),
                    vocab.getMeaningVi(),
                    displayedMeaning,
                    showCorrectMeaning));
        }

        // Cache questions for this session
        sessionQuestionsCache.put(session.getId(), allQuestions);

        // Generate first question from cached data
        QuestionData firstQuestionData = allQuestions.get(0);
        Vocab firstVocab = vocabs.get(0);

        QuickQuizQuestionResponse firstQuestion = QuickQuizQuestionResponse.builder()
                .sessionId(session.getId())
                .questionNumber(1)
                .vocabId(firstQuestionData.getVocabId())
                .word(firstQuestionData.getWord())
                .transcription(firstVocab.getTranscription())
                .displayedMeaning(firstQuestionData.getDisplayedMeaning())
                .isCorrectPair(firstQuestionData.isCorrectPair())
                .timeLimit(request.getTimePerQuestion() * 1000)
                .cefr(firstVocab.getCefr())
                .img(firstVocab.getImg())
                .audio(firstVocab.getAudio())
                .build();

        return QuickQuizSessionResponse.builder()
                .sessionId(session.getId())
                .gameType(GAME_NAME)
                .status("IN_PROGRESS")
                .totalQuestions(request.getTotalQuestions())
                .timePerQuestion(request.getTimePerQuestion())
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

    /**
     * Submit an answer and get next question or final results
     */
    @Transactional
    public QuickQuizAnswerResponse submitAnswer(QuickQuizAnswerRequest request, UUID userId) {
        log.info("Submitting answer for session: {}, question: {}", request.getSessionId(),
                request.getQuestionNumber());

        // Load session
        GameSession session = gameSessionRepository.findById(request.getSessionId())
                .orElseThrow(() -> new ErrorException("Game session not found"));

        if (!session.getUser().getId().equals(userId)) {
            throw new ErrorException("Unauthorized: This session belongs to another user");
        }

        if (session.getFinishedAt() != null) {
            throw new ErrorException("Game session already finished");
        }

        // Get cached questions
        List<QuestionData> cachedQuestions = sessionQuestionsCache.get(request.getSessionId());
        if (cachedQuestions == null || cachedQuestions.isEmpty()) {
            throw new ErrorException("Session questions not found. Please start a new game.");
        }

        if (request.getQuestionNumber() > cachedQuestions.size()) {
            throw new ErrorException("Invalid question number");
        }

        // Get current question data
        QuestionData currentQuestionData = cachedQuestions.get(request.getQuestionNumber() - 1);

        // Load vocab for spaced repetition update
        Vocab currentVocab = vocabRepository.findById(currentQuestionData.getVocabId())
                .orElseThrow(() -> new ErrorException("Vocabulary not found"));

        // Check if answer is correct
        Boolean isUserCorrect = request.getUserAnswer().equals(currentQuestionData.isCorrectPair());

        // Get current session details
        List<GameSessionDetail> details = new ArrayList<>(session.getDetails());

        // Calculate points
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

        // Update spaced repetition progress
        updateVocabProgress(userId, currentVocab.getId(), isUserCorrect);

        // Check if game is finished
        boolean hasNextQuestion = request.getQuestionNumber() < session.getTotalQuestions();
        QuickQuizQuestionResponse nextQuestion = null;

        if (hasNextQuestion) {
            // Get next question from cache
            QuestionData nextQuestionData = cachedQuestions.get(request.getQuestionNumber());
            Vocab nextVocab = vocabRepository.findById(nextQuestionData.getVocabId())
                    .orElseThrow(() -> new ErrorException("Next vocabulary not found"));

            nextQuestion = QuickQuizQuestionResponse.builder()
                    .sessionId(session.getId())
                    .questionNumber(request.getQuestionNumber() + 1)
                    .vocabId(nextQuestionData.getVocabId())
                    .word(nextQuestionData.getWord())
                    .transcription(nextVocab.getTranscription())
                    .displayedMeaning(nextQuestionData.getDisplayedMeaning())
                    .isCorrectPair(nextQuestionData.isCorrectPair())
                    .timeLimit(3000) // 3 seconds
                    .cefr(nextVocab.getCefr())
                    .img(nextVocab.getImg())
                    .audio(nextVocab.getAudio())
                    .build();
        } else {
            // Game finished - clear cache
            finishGame(session, details);
            sessionQuestionsCache.remove(session.getId());
        }

        gameSessionRepository.save(session);

        return QuickQuizAnswerResponse.builder()
                .sessionId(session.getId())
                .questionNumber(request.getQuestionNumber())
                .isCorrect(isUserCorrect)
                .correctAnswer(currentQuestionData.isCorrectPair())
                .currentScore(session.getScore())
                .currentStreak(currentStreak)
                .comboBonus(currentStreak >= 3 ? STREAK_BONUS * (currentStreak / 3) : 0)
                .explanation(buildExplanation(currentVocab, currentQuestionData.isCorrectPair()))
                .hasNextQuestion(hasNextQuestion)
                .nextQuestion(nextQuestion)
                .build();
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
                    .displayedMeaning("Meaning shown") // TODO: Store this
                    .isCorrectPair(true) // TODO: Store this
                    .userAnswer(detail.getIsCorrect()) // TODO: Store actual answer
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

    /**
     * Calculate current streak
     */
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

    /**
     * Calculate longest streak in session
     */
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

    /**
     * Finish game and calculate final stats
     */
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

    /**
     * Update user vocabulary progress (Spaced Repetition)
     */
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

    /**
     * Build explanation for answer
     */
    private String buildExplanation(Vocab vocab, boolean isCorrectPair) {
        if (isCorrectPair) {
            return String.format("✓ Correct! '%s' means '%s'", vocab.getWord(), vocab.getMeaningVi());
        } else {
            return String.format("✗ Wrong! This is not the correct meaning. '%s' actually means '%s'",
                    vocab.getWord(), vocab.getMeaningVi());
        }
    }

}
