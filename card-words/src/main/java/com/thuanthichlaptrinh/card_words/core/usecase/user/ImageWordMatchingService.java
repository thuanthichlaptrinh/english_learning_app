package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.common.helper.UserLeaderboardData;
import com.thuanthichlaptrinh.card_words.core.domain.*;
import com.thuanthichlaptrinh.card_words.core.service.redis.GameSessionCacheService;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.*;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game.ImageWordMatchingAnswerRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game.ImageWordMatchingStartRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.LeaderboardEntryResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameHistoryResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameStatsResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.ImageWordMatchingResultResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.ImageWordMatchingSessionResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.SessionData;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.vocab.VocabResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class ImageWordMatchingService {

        private final GameRepository gameRepository;
        private final GameSessionRepository gameSessionRepository;
        private final GameSessionDetailRepository gameSessionDetailRepository;
        private final VocabRepository vocabRepository;
        private final UserRepository userRepository;
        private final UserVocabProgressRepository userVocabProgressRepository;
        private final StreakService streakService;

        // Redis cache service for distributed caching
        private final GameSessionCacheService gameSessionCacheService;

        private static final String GAME_NAME = "Image-Word Matching";
        private static final int DEFAULT_PAIRS = 5;

        @Transactional
        public ImageWordMatchingSessionResponse startGame(ImageWordMatchingStartRequest request) {
                log.info("Starting Image-Word Matching game: cefr={}, pairs={}",
                                request.getCefr(), request.getTotalPairs());

                User user = getAuthenticatedUser();

                // Determine number of pairs
                int totalPairs = request.getTotalPairs() != null && request.getTotalPairs() > 0
                                ? request.getTotalPairs()
                                : DEFAULT_PAIRS;

                // ⭐ Validate totalPairs range
                if (totalPairs < 2 || totalPairs > 5) {
                        throw new ErrorException("Số cặp phải trong khoảng 2-5");
                }

                // Get or create game
                Game game = getOrCreateGame();

                // Get random vocabs with images (no topic filter, always random)
                List<Vocab> vocabs = getRandomVocabsWithImages(totalPairs, request.getCefr());

                if (vocabs.size() < totalPairs) {
                        throw new ErrorException(
                                        "Không đủ từ vựng có hình ảnh. Cần " + totalPairs + " từ, chỉ tìm thấy "
                                                        + vocabs.size());
                }

                // Create game session
                GameSession session = GameSession.builder()
                                .game(game)
                                .user(user)
                                .totalQuestions(totalPairs)
                                .correctCount(0)
                                .score(0)
                                .startedAt(LocalDateTime.now())
                                .build();
                session = gameSessionRepository.save(session);

                // Store session data in Redis cache
                SessionData sessionData = new SessionData(session.getId(), vocabs);
                gameSessionCacheService.cacheImageMatchingSession(session.getId(), sessionData);

                List<VocabResponse> vocabResponses = vocabs.stream()
                                .map(this::mapToVocabResponse)
                                .collect(Collectors.toList());

                log.info("Image-Word Matching game started: sessionId={}, pairs={}", session.getId(), totalPairs);

                return ImageWordMatchingSessionResponse.builder()
                                .sessionId(session.getId())
                                .totalPairs(totalPairs)
                                .vocabs(vocabResponses)
                                .status("IN_PROGRESS")
                                .build();
        }

        @Transactional
        public ImageWordMatchingResultResponse submitAnswer(ImageWordMatchingAnswerRequest request) {
                log.info("Submitting Image-Word Matching answer: sessionId={}", request.getSessionId());

                // Get session from Redis cache
                SessionData sessionData = gameSessionCacheService.getImageMatchingSession(request.getSessionId(),
                                SessionData.class);
                if (sessionData == null) {
                        throw new ErrorException("Session không tồn tại hoặc đã hết hạn");
                }

                // Get session from database
                GameSession session = gameSessionRepository.findById(request.getSessionId())
                                .orElseThrow(() -> new ErrorException("Không tìm thấy game session"));

                if (session.getFinishedAt() != null) {
                        throw new ErrorException("Game session đã kết thúc");
                }

                // Convert matched vocab IDs to set for quick lookup
                Set<String> matchedIds = new HashSet<>(request.getMatchedVocabIds());

                // Calculate base score based on CEFR levels
                List<ImageWordMatchingResultResponse.VocabScore> vocabScores = new ArrayList<>();
                int cefrScore = 0;
                int correctMatches = 0;

                for (Vocab vocab : sessionData.getVocabs()) {
                        String vocabId = vocab.getId().toString();
                        boolean isCorrect = matchedIds.contains(vocabId);

                        if (isCorrect) {
                                correctMatches++;
                        }

                        // Calculate points based on CEFR level
                        int points = isCorrect ? getCefrPoints(vocab.getCefr()) : 0;
                        cefrScore += points;

                        vocabScores.add(ImageWordMatchingResultResponse.VocabScore.builder()
                                        .vocabId(vocabId)
                                        .word(vocab.getWord())
                                        .cefr(vocab.getCefr())
                                        .points(points)
                                        .correct(isCorrect)
                                        .build());

                        // Update user vocab progress
                        updateUserVocabProgress(session.getUser(), vocab, isCorrect);

                        // Save game session detail
                        saveGameSessionDetail(session, vocab, isCorrect);
                }

                // Calculate accuracy
                double accuracy = sessionData.getVocabs().size() > 0
                                ? (correctMatches * 100.0 / sessionData.getVocabs().size())
                                : 0;

                // Calculate duration
                LocalDateTime startedAt = session.getStartedAt();
                LocalDateTime endTime = LocalDateTime.now();
                int durationSeconds = (int) java.time.Duration.between(startedAt, endTime).getSeconds();

                // Calculate time bonus
                // Fast completion bonus: < 10s = +50%, < 20s = +30%, < 30s = +20%, < 60s = +10%
                Long timeTakenMs = request.getTimeTaken();
                int timeBonus = 0;
                if (timeTakenMs != null) {
                        long seconds = timeTakenMs / 1000;
                        if (seconds < 10) {
                                timeBonus = (int) (cefrScore * 0.5); // +50%
                        } else if (seconds < 20) {
                                timeBonus = (int) (cefrScore * 0.3); // +30%
                        } else if (seconds < 30) {
                                timeBonus = (int) (cefrScore * 0.2); // +20%
                        } else if (seconds < 60) {
                                timeBonus = (int) (cefrScore * 0.1); // +10%
                        }
                }

                // Total score = CEFR score + time bonus
                int totalScore = cefrScore + timeBonus;

                // Update session
                session.setCorrectCount(correctMatches);
                session.setAccuracy(accuracy);
                session.setScore(totalScore);
                session.setDuration(durationSeconds);
                session.setFinishedAt(endTime);
                gameSessionRepository.save(session);

                // Remove from Redis cache
                gameSessionCacheService.deleteImageMatchingSession(request.getSessionId());

                // Record streak activity AFTER transaction completes
                recordStreakActivitySafely(session.getUser());

                log.info("Image-Word Matching completed: sessionId={}, score={}, accuracy={}%",
                                session.getId(), totalScore, String.format("%.2f", accuracy));

                return ImageWordMatchingResultResponse.builder()
                                .sessionId(session.getId())
                                .totalPairs(sessionData.getVocabs().size())
                                .correctMatches(correctMatches)
                                .accuracy(accuracy)
                                .timeTaken(request.getTimeTaken())
                                .score(totalScore)
                                .vocabScores(vocabScores)
                                .build();
        }

        /**
         * Calculate points based on CEFR level
         * A1=1, A2=2, B1=3, B2=4, C1=5, C2=6
         */
        private int getCefrPoints(String cefr) {
                if (cefr == null)
                        return 1;
                return switch (cefr.toUpperCase()) {
                        case "A1" -> 1;
                        case "A2" -> 2;
                        case "B1" -> 3;
                        case "B2" -> 4;
                        case "C1" -> 5;
                        case "C2" -> 6;
                        default -> 1;
                };
        }

        private User getAuthenticatedUser() {
                Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
                if (authentication == null || !authentication.isAuthenticated()) {
                        throw new ErrorException("Người dùng chưa đăng nhập");
                }
                String userEmail = authentication.getName();
                return userRepository.findByEmail(userEmail)
                                .orElseThrow(() -> new ErrorException("Không tìm thấy người dùng"));
        }

        private Game getOrCreateGame() {
                return gameRepository.findByName(GAME_NAME)
                                .orElseGet(() -> {
                                        Game game = Game.builder()
                                                        .name(GAME_NAME)
                                                        .description("Ghép thẻ hình ảnh với từ vựng")
                                                        .build();
                                        return gameRepository.save(game);
                                });
        }

        private List<Vocab> getRandomVocabsWithImages(int count, String cefr) {
                List<Vocab> vocabs;

                if (cefr != null && !cefr.isBlank()) {
                        // Filter by CEFR only
                        vocabs = vocabRepository.findByCefr(cefr);
                } else {
                        // Get all vocabs (random all)
                        vocabs = vocabRepository.findAll();
                }

                // Filter vocabs that have images
                List<Vocab> vocabsWithImages = vocabs.stream()
                                .filter(v -> v.getImg() != null && !v.getImg().isBlank())
                                .collect(Collectors.toList());

                // Shuffle and limit
                Collections.shuffle(vocabsWithImages);
                return vocabsWithImages.stream()
                                .limit(count)
                                .collect(Collectors.toList());
        }

        private void updateUserVocabProgress(User user, Vocab vocab, boolean isCorrect) {
                Optional<UserVocabProgress> progressOpt = userVocabProgressRepository
                                .findByUserIdAndVocabId(user.getId(), vocab.getId());

                UserVocabProgress progress;
                com.thuanthichlaptrinh.card_words.common.enums.VocabStatus oldStatus;

                if (progressOpt.isPresent()) {
                        // Record đã tồn tại
                        progress = progressOpt.get();
                        oldStatus = progress.getStatus();

                        if (isCorrect) {
                                progress.setTimesCorrect(progress.getTimesCorrect() + 1);
                        } else {
                                progress.setTimesWrong(progress.getTimesWrong() + 1);
                        }
                } else {
                        // Record mới - set status = NEW
                        oldStatus = null;
                        progress = UserVocabProgress.builder()
                                        .user(user)
                                        .vocab(vocab)
                                        .status(com.thuanthichlaptrinh.card_words.common.enums.VocabStatus.NEW)
                                        .timesCorrect(isCorrect ? 1 : 0)
                                        .timesWrong(isCorrect ? 0 : 1)
                                        .efFactor(2.5)
                                        .intervalDays(1)
                                        .repetition(0)
                                        .build();
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
                        log.info("Image-Word Matching - Vocab status updated: userId={}, vocabId={}, {} -> {}, accuracy={}",
                                        user.getId(), vocab.getId(), oldStatus, newStatus,
                                        com.thuanthichlaptrinh.card_words.common.utils.VocabStatusCalculator
                                                        .formatAccuracy(
                                                                        progress.getTimesCorrect(),
                                                                        progress.getTimesWrong()));
                }
        }

        private void saveGameSessionDetail(GameSession session, Vocab vocab, boolean isCorrect) {
                GameSessionDetail detail = GameSessionDetail.builder()
                                .session(session)
                                .vocab(vocab)
                                .isCorrect(isCorrect)
                                .build();
                gameSessionDetailRepository.save(detail);
        }

        // Get session by ID
        public ImageWordMatchingSessionResponse getSession(Long sessionId) {
                log.info("Getting session: {}", sessionId);

                GameSession session = gameSessionRepository.findById(sessionId)
                                .orElseThrow(() -> new ErrorException("Session not found: " + sessionId));

                // Get session data from Redis cache
                SessionData sessionData = gameSessionCacheService.getImageMatchingSession(sessionId, SessionData.class);
                if (sessionData == null) {
                        throw new ErrorException("Session không tồn tại hoặc đã hết hạn. Vui lòng bắt đầu game mới.");
                }

                // Determine status
                String status = session.getFinishedAt() != null ? "COMPLETED" : "IN_PROGRESS";

                // Convert vocabs to VocabResponse
                List<VocabResponse> vocabResponses = sessionData.getVocabs().stream()
                                .map(this::mapToVocabResponse)
                                .collect(Collectors.toList());

                // Build response with data from both session and cache
                return ImageWordMatchingSessionResponse.builder()
                                .sessionId(session.getId())
                                .totalPairs(sessionData.getVocabs().size())
                                .vocabs(vocabResponses)
                                .status(status)
                                .build();
        }

        // Get user's game history
        public List<GameHistoryResponse> getHistory(
                        int page, int size) {
                log.info("Getting game history: page={}, size={}", page, size);

                User user = getAuthenticatedUser();
                Game game = getOrCreateGame();

                // Get all sessions of this user for this game
                List<GameSession> sessions = gameSessionRepository.findByUserIdAndGameIdOrderByCreatedAtDesc(
                                user.getId(), game.getId());

                // Paginate manually
                int start = page * size;
                int end = Math.min(start + size, sessions.size());

                if (start >= sessions.size()) {
                        return Collections.emptyList();
                }

                return sessions.subList(start, end).stream()
                                .map(session -> {
                                        List<GameSessionDetail> details = gameSessionDetailRepository
                                                        .findBySessionIdOrderById(session.getId());

                                        int totalPairs = session.getTotalQuestions() != null
                                                        ? session.getTotalQuestions()
                                                        : details.size();
                                        int correctPairs = session.getCorrectCount() != null ? session.getCorrectCount()
                                                        : 0;
                                        double accuracy = session.getAccuracy() != null ? session.getAccuracy() : 0.0;

                                        // Determine status
                                        String status = session.getFinishedAt() != null ? "COMPLETED" : "IN_PROGRESS";

                                        return GameHistoryResponse
                                                        .builder()
                                                        .sessionId(session.getId())
                                                        .gameMode("SINGLE_MODE")
                                                        .totalPairs(totalPairs)
                                                        .correctPairs(correctPairs)
                                                        .accuracy(Math.round(accuracy * 100.0) / 100.0)
                                                        .totalScore(session.getScore())
                                                        .timeElapsed(session.getDuration())
                                                        .status(status)
                                                        .playedAt(session.getStartedAt())
                                                        .build();
                                })
                                .collect(Collectors.toList());
        }

        // Get leaderboard - shows top players by total score across all games
        public List<LeaderboardEntryResponse> getLeaderboard(
                        String gameMode, int limit) {
                log.info("Getting leaderboard: mode={}, limit={}", gameMode, limit);

                // Get global leaderboard using existing repository method with Pageable
                Pageable pageable = PageRequest.of(0, limit * 10); // Get more to ensure we have enough after grouping
                Page<GameSession> sessionsPage = gameSessionRepository.findGlobalLeaderboard(pageable);

                List<GameSession> sessions = sessionsPage.getContent();

                // Group by user and calculate stats
                Map<UUID, UserLeaderboardData> userStatsMap = new HashMap<>();

                for (GameSession session : sessions) {
                        UUID userId = session.getUser().getId();
                        UserLeaderboardData data = userStatsMap.computeIfAbsent(userId,
                                        k -> new UserLeaderboardData(session.getUser()));

                        data.addSession(session);
                }

                // Sort by total score and get top N
                List<LeaderboardEntryResponse> leaderboard = userStatsMap
                                .values().stream()
                                .sorted((a, b) -> Integer.compare(b.getTotalScore(), a.getTotalScore()))
                                .limit(limit)
                                .collect(Collectors.toList()).stream()
                                .map(data -> LeaderboardEntryResponse
                                                .builder()
                                                .rank(0) // Will be updated below
                                                .userName(data.getUser().getName())
                                                .avatar(data.getUser().getAvatar())
                                                .totalScore(data.getTotalScore())
                                                .accuracy(data.getAverageAccuracy())
                                                .gamesPlayed(data.getGamesPlayed())
                                                .lastPlayedAt(data.getLastPlayedAt())
                                                .build())
                                .collect(Collectors.toList());

                // Update ranks
                for (int i = 0; i < leaderboard.size(); i++) {
                        leaderboard.get(i).setRank(i + 1);
                }

                return leaderboard;
        }

        // Get user's game statistics
        public GameStatsResponse getStats() {
                log.info("Getting user game statistics");

                User user = getAuthenticatedUser();
                Game game = getOrCreateGame();

                List<GameSession> sessions = gameSessionRepository.findByUserIdAndGameId(user.getId(), game.getId());

                int totalGames = sessions.size();
                int completedGames = (int) sessions.stream()
                                .filter(s -> s.getFinishedAt() != null)
                                .count();

                double avgScore = sessions.stream()
                                .filter(s -> s.getFinishedAt() != null)
                                .mapToInt(GameSession::getScore)
                                .average()
                                .orElse(0.0);

                int highestScore = sessions.stream()
                                .filter(s -> s.getFinishedAt() != null)
                                .mapToInt(GameSession::getScore)
                                .max()
                                .orElse(0);

                // Calculate accuracy
                int totalCorrect = 0;
                int totalWrong = 0;
                for (GameSession session : sessions) {
                        List<GameSessionDetail> details = gameSessionDetailRepository
                                        .findBySessionIdOrderById(session.getId());
                        totalCorrect += (int) details.stream().filter(GameSessionDetail::getIsCorrect).count();
                        totalWrong += (int) details.stream().filter(d -> !d.getIsCorrect()).count();
                }

                double avgAccuracy = (totalCorrect + totalWrong) > 0
                                ? (totalCorrect * 100.0 / (totalCorrect + totalWrong))
                                : 0.0;

                // For now, without gameMode in GameSession, we can't separate stats by mode
                // So we'll provide overall stats for all modes
                GameStatsResponse.ModeStats overallStats = GameStatsResponse.ModeStats
                                .builder()
                                .gamesPlayed(totalGames)
                                .gamesCompleted(completedGames)
                                .averageScore(Math.round(avgScore * 100.0) / 100.0)
                                .averageAccuracy(Math.round(avgAccuracy * 100.0) / 100.0)
                                .highestScore(highestScore)
                                .build();

                return GameStatsResponse.builder()
                                .totalGamesPlayed(totalGames)
                                .totalGamesCompleted(completedGames)
                                .averageScore(Math.round(avgScore * 100.0) / 100.0)
                                .averageAccuracy(Math.round(avgAccuracy * 100.0) / 100.0)
                                .highestScore(highestScore)
                                .totalCorrectPairs(totalCorrect)
                                .totalWrongPairs(totalWrong)
                                .classicStats(overallStats)
                                .speedMatchStats(overallStats)
                                .progressiveStats(overallStats)
                                .build();
        }

        // Map Vocab entity to VocabResponse DTO
        private VocabResponse mapToVocabResponse(Vocab vocab) {
                Set<VocabResponse.TypeInfo> typeInfos = vocab.getTypes().stream()
                                .map(type -> VocabResponse.TypeInfo.builder()
                                                .id(type.getId())
                                                .name(type.getName())
                                                .build())
                                .collect(Collectors.toSet());

                VocabResponse.TopicInfo topicInfo = vocab.getTopic() != null
                                ? VocabResponse.TopicInfo.builder()
                                                .id(vocab.getTopic().getId())
                                                .name(vocab.getTopic().getName())
                                                .build()
                                : null;

                return VocabResponse.builder()
                                .id(vocab.getId())
                                .word(vocab.getWord())
                                .transcription(vocab.getTranscription())
                                .meaningVi(vocab.getMeaningVi())
                                .interpret(vocab.getInterpret())
                                .exampleSentence(vocab.getExampleSentence())
                                .cefr(vocab.getCefr())
                                .img(vocab.getImg())
                                .audio(vocab.getAudio())
                                .credit(vocab.getCredit())
                                .createdAt(vocab.getCreatedAt())
                                .updatedAt(vocab.getUpdatedAt())
                                .types(typeInfos)
                                .topic(topicInfo)
                                .build();
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
}
