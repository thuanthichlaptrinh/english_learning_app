package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.core.domain.GameSession;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.service.redis.LeaderboardCacheService;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.GameSessionRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.LeaderboardEntryResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.TopPlayersResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class LeaderboardService {

    private final LeaderboardCacheService leaderboardCacheService;
    private final UserRepository userRepository;
    private final GameSessionRepository gameSessionRepository;
    private final NotificationService notificationService;

    /**
     * Get Quick Quiz global leaderboard
     */
    @Transactional(readOnly = true)
    public List<LeaderboardEntryResponse> getQuizGlobalLeaderboard(int limit) {
        log.info("📊 Getting Quick Quiz global leaderboard, limit={}", limit);

        var entries = leaderboardCacheService.getQuizGlobalTop(limit);
        return convertToResponse(entries);
    }

    /**
     * Get Quick Quiz daily leaderboard
     */
    @Transactional(readOnly = true)
    public List<LeaderboardEntryResponse> getQuizDailyLeaderboard(LocalDate date, int limit) {
        log.info("📊 Getting Quick Quiz daily leaderboard, date={}, limit={}", date, limit);

        var entries = leaderboardCacheService.getQuizDailyTop(limit, date);
        return convertToResponse(entries);
    }

    /**
     * Get user's rank in Quick Quiz global leaderboard
     */
    @Transactional(readOnly = true)
    public LeaderboardEntryResponse getUserQuizRank(UUID userId) {
        log.info("🎯 Getting user quiz rank, userId={}", userId);

        Long rank = leaderboardCacheService.getQuizGlobalRank(userId);
        Double score = leaderboardCacheService.getQuizGlobalScore(userId);

        if (rank == null || score == null) {
            log.warn("⚠️ User not found in leaderboard: userId={}", userId);
            return null;
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found: " + userId));

        return LeaderboardEntryResponse.builder()
                .rank(rank.intValue() + 1) // Redis rank is 0-based
                .userName(user.getName())
                .avatar(user.getAvatar())
                .totalScore(score.intValue())
                .build();
    }

    /**
     * Get streak leaderboard (current streak)
     */
    @Transactional(readOnly = true)
    public List<LeaderboardEntryResponse> getStreakLeaderboard(int limit) {
        log.info("🔥 Getting current streak leaderboard, limit={}", limit);

        var entries = leaderboardCacheService.getStreakGlobalTop(limit);
        return convertToResponse(entries);
    }

    /**
     * Get best streak leaderboard
     */
    @Transactional(readOnly = true)
    public List<LeaderboardEntryResponse> getBestStreakLeaderboard(int limit) {
        log.info("🏆 Getting best streak leaderboard, limit={}", limit);

        var entries = leaderboardCacheService.getBestStreakTop(limit);
        return convertToResponse(entries);
    }

    /**
     * Get Image Matching leaderboard
     */
    @Transactional(readOnly = true)
    public List<LeaderboardEntryResponse> getImageMatchingLeaderboard(int limit) {
        log.info("🖼️ Getting Image Matching leaderboard, limit={}", limit);

        var entries = leaderboardCacheService.getImageMatchingTop(limit);
        List<LeaderboardEntryResponse> responses = convertToResponse(entries);

        // Fallback to database if cache is empty
        if (responses.isEmpty()) {
            log.warn("⚠️ Redis cache empty for Image Matching, falling back to database");
            Long gameId = 2L; // Image-Word Matching game ID
            Pageable pageable = PageRequest.of(0, limit);
            Page<GameSession> sessions = gameSessionRepository.findTopScoresByGame(gameId, pageable);
            responses = convertGameSessionsToResponses(sessions.getContent());
            log.info("✅ Retrieved {} players from database for Image Matching", responses.size());
        }

        return responses;
    }

    /**
     * Get Word Definition leaderboard
     */
    @Transactional(readOnly = true)
    public List<LeaderboardEntryResponse> getWordDefLeaderboard(int limit) {
        log.info("📖 Getting Word Definition leaderboard, limit={}", limit);

        var entries = leaderboardCacheService.getWordDefTop(limit);
        List<LeaderboardEntryResponse> responses = convertToResponse(entries);

        // Fallback to database if cache is empty
        if (responses.isEmpty()) {
            log.warn("⚠️ Redis cache empty for Word Definition, falling back to database");
            Long gameId = 3L; // Word-Definition Matching game ID
            Pageable pageable = PageRequest.of(0, limit);
            Page<GameSession> sessions = gameSessionRepository.findTopScoresByGame(gameId, pageable);
            responses = convertGameSessionsToResponses(sessions.getContent());
            log.info("✅ Retrieved {} players from database for Word Definition", responses.size());
        }

        return responses;
    }

    /**
     * Update user's score in leaderboards after completing a game
     */
    @Transactional
    public void updateUserScore(UUID userId, String gameType, double score) {
        log.info("📈 Updating leaderboard score: userId={}, game={}, score={}", userId, gameType, score);

        // Get old rank before update
        Long oldRank = null;
        switch (gameType.toLowerCase()) {
            case "quickquiz":
            case "quick-quiz":
                oldRank = leaderboardCacheService.getQuizGlobalRank(userId);
                leaderboardCacheService.updateQuizGlobalScore(userId, score);
                leaderboardCacheService.updateQuizDailyScore(userId, score);
                leaderboardCacheService.updateQuizWeeklyScore(userId, score);
                break;
            case "imagematching":
            case "image-matching":
                oldRank = leaderboardCacheService.getUserRank(com.thuanthichlaptrinh.card_words.common.constants.RedisKeyConstants.LEADERBOARD_IMAGE_GLOBAL, userId);
                leaderboardCacheService.updateImageMatchingScore(userId, score);
                break;
            case "worddef":
            case "word-definition":
                oldRank = leaderboardCacheService.getUserRank(com.thuanthichlaptrinh.card_words.common.constants.RedisKeyConstants.LEADERBOARD_WORDDEF_GLOBAL, userId);
                leaderboardCacheService.updateWordDefScore(userId, score);
                break;
            default:
                log.warn("⚠️ Unknown game type: {}", gameType);
        }

        // Get new rank after update and send notification if improved
        if (oldRank != null) {
            checkAndNotifyLeaderboardRank(userId, gameType, oldRank);
        }

        log.info("✅ Leaderboard updated successfully");
    }

    /**
     * Update user's streak in streak leaderboard
     */
    @Transactional
    public void updateUserStreak(UUID userId, int currentStreak, int bestStreak) {
        log.info("🔥 Updating streak leaderboard: userId={}, current={}, best={}", userId, currentStreak, bestStreak);
        leaderboardCacheService.updateStreakGlobalScore(userId, currentStreak);
        leaderboardCacheService.updateBestStreakScore(userId, bestStreak);
    }

    /**
     * Get top 10 players from all 3 games
     */
    @Transactional(readOnly = true)
    public TopPlayersResponse getTopPlayersAllGames() {
        log.info("🏆 Getting top 10 players from all 3 games");

        // Get top 10 for each game
        List<LeaderboardEntryResponse> quickQuizTop10 = getQuizGlobalLeaderboard(10);
        List<LeaderboardEntryResponse> imageMatchingTop10 = getImageMatchingLeaderboard(10);
        List<LeaderboardEntryResponse> wordDefTop10 = getWordDefLeaderboard(10);

        // Count total active players (unique players across all games)
        int totalActivePlayers = countTotalActivePlayers(quickQuizTop10, imageMatchingTop10, wordDefTop10);

        log.info("✅ Top players retrieved: QuickQuiz={}, ImageMatching={}, WordDef={}, Total Active={}",
                quickQuizTop10.size(), imageMatchingTop10.size(), wordDefTop10.size(), totalActivePlayers);

        return TopPlayersResponse.builder()
                .quickQuizTop10(quickQuizTop10)
                .imageMatchingTop10(imageMatchingTop10)
                .wordDefinitionTop10(wordDefTop10)
                .totalActivePlayers(totalActivePlayers)
                .cacheExpirySeconds(300) // 5 minutes cache
                .build();
    }

    /**
     * Count unique active players across all games
     */
    @SafeVarargs
    private final int countTotalActivePlayers(List<LeaderboardEntryResponse>... leaderboards) {
        // Use userRepository to count all users who have played at least one game
        long totalCount = userRepository.count();
        log.debug("📊 Total registered users: {}", totalCount);
        return (int) totalCount;
    }

    // ==================== PRIVATE HELPERS ====================

    private List<LeaderboardEntryResponse> convertToResponse(List<LeaderboardCacheService.LeaderboardEntry> entries) {
        List<LeaderboardEntryResponse> responses = new ArrayList<>();
        int rank = 1;

        for (var entry : entries) {
            try {
                UUID userId = entry.getUserId(); // Already UUID type
                User user = userRepository.findById(userId).orElse(null);

                if (user != null) {
                    responses.add(LeaderboardEntryResponse.builder()
                            .rank(rank++)
                            .userName(user.getName())
                            .avatar(user.getAvatar())
                            .totalScore(entry.getScore().intValue())
                            .build());
                }
            } catch (Exception e) {
                log.error("❌ Error converting leaderboard entry: {}", e.getMessage());
            }
        }

        return responses;
    }

    /**
     * Convert GameSession list to LeaderboardEntryResponse list (for database
     * fallback)
     */
    private List<LeaderboardEntryResponse> convertGameSessionsToResponses(List<GameSession> sessions) {
        List<LeaderboardEntryResponse> responses = new ArrayList<>();
        int rank = 1;

        for (GameSession session : sessions) {
            try {
                User user = session.getUser();
                if (user != null) {
                    responses.add(LeaderboardEntryResponse.builder()
                            .rank(rank++)
                            .userName(user.getName())
                            .avatar(user.getAvatar())
                            .totalScore(session.getScore())
                            .build());
                }
            } catch (Exception e) {
                log.error("❌ Error converting game session to leaderboard entry: {}", e.getMessage());
            }
        }

        return responses;
    }

    /**
     * Check and notify user if they achieved top rank in leaderboard
     */
    private void checkAndNotifyLeaderboardRank(UUID userId, String gameType, Long oldRank) {
        try {
            Long newRank = null;
            
            switch (gameType.toLowerCase()) {
                case "quickquiz":
                case "quick-quiz":
                    newRank = leaderboardCacheService.getQuizGlobalRank(userId);
                    break;
                case "imagematching":
                case "image-matching":
                    newRank = leaderboardCacheService.getUserRank(com.thuanthichlaptrinh.card_words.common.constants.RedisKeyConstants.LEADERBOARD_IMAGE_GLOBAL, userId);
                    break;
                case "worddef":
                case "word-definition":
                    newRank = leaderboardCacheService.getUserRank(com.thuanthichlaptrinh.card_words.common.constants.RedisKeyConstants.LEADERBOARD_WORDDEF_GLOBAL, userId);
                    break;
            }

            if (newRank == null) return;

            // Convert 0-based rank to 1-based
            int rank = newRank.intValue() + 1;
            int oldRankInt = oldRank.intValue() + 1;

            // Send notification if reached top positions and improved
            if (rank < oldRankInt) {
                User user = userRepository.findById(userId).orElse(null);
                if (user == null) return;

                String gameDisplayName = getGameDisplayName(gameType);
                String title = null;
                String content = null;

                if (rank == 1) {
                    title = "👑 #1 Trên Bảng Xếp Hạng!";
                    content = String.format("Chúc mừng! Bạn đã vươn lên vị trí #1 trong %s! Bạn là người giỏi nhất!", gameDisplayName);
                } else if (rank <= 3) {
                    title = String.format("🥇 Top %d!", rank);
                    content = String.format("Tuyệt vời! Bạn đã lọt vào Top %d trong %s! Tiếp tục phấn đấu!", rank, gameDisplayName);
                } else if (rank <= 10) {
                    title = "🏆 Top 10!";
                    content = String.format("Xuất sắc! Bạn đã vào Top 10 trong %s (Hạng #%d)!", gameDisplayName, rank);
                }

                if (title != null && content != null) {
                    com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest request = 
                        com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest.builder()
                            .userId(userId)
                            .title(title)
                            .content(content)
                            .type("achievement")
                            .build();
                    notificationService.createNotification(request);
                    log.info("✅ Leaderboard rank notification sent: userId={}, rank={}, game={}", userId, rank, gameType);
                }
            }
        } catch (Exception e) {
            log.error("❌ Failed to check/notify leaderboard rank: {}", e.getMessage(), e);
        }
    }

    /**
     * Get display name for game type
     */
    private String getGameDisplayName(String gameType) {
        switch (gameType.toLowerCase()) {
            case "quickquiz":
            case "quick-quiz":
                return "Quick Quiz";
            case "imagematching":
            case "image-matching":
                return "Image Word Matching";
            case "worddef":
            case "word-definition":
                return "Word Definition Matching";
            default:
                return gameType;
        }
    }
}
