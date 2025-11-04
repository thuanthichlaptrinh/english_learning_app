package com.thuanthichlaptrinh.card_words.core.service.redis;

import com.thuanthichlaptrinh.card_words.configuration.redis.RedisKeyConstants;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Leaderboard Cache Service
 * Manages Redis Sorted Sets for real-time leaderboards
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class LeaderboardCacheService {

    private final BaseRedisService redisService;

    private static final Duration DAILY_LEADERBOARD_TTL = Duration.ofHours(26); // 24h + 2h buffer
    private static final Duration WEEKLY_LEADERBOARD_TTL = Duration.ofDays(8); // 7 days + 1 day buffer

    // ==================== QUICK QUIZ LEADERBOARDS ====================

    /**
     * Update user score in global Quick Quiz leaderboard
     */
    public void updateQuizGlobalScore(UUID userId, double totalScore) {
        String key = RedisKeyConstants.LEADERBOARD_QUIZ_GLOBAL;
        redisService.zAdd(key, userId.toString(), totalScore);
        log.debug("✅ Updated global quiz score: user={}, score={}", userId, totalScore);
    }

    /**
     * Update user score in daily Quick Quiz leaderboard
     */
    public void updateQuizDailyScore(UUID userId, double totalScore) {
        String today = LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE);
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.LEADERBOARD_QUIZ_DAILY, today);

        redisService.zAdd(key, userId.toString(), totalScore);
        redisService.expire(key, DAILY_LEADERBOARD_TTL);

        log.debug("✅ Updated daily quiz score: user={}, score={}, date={}", userId, totalScore, today);
    }

    /**
     * Update user score in weekly Quick Quiz leaderboard
     */
    public void updateQuizWeeklyScore(UUID userId, double totalScore) {
        String weekKey = getWeekKey();
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.LEADERBOARD_QUIZ_WEEKLY, weekKey);

        redisService.zAdd(key, userId.toString(), totalScore);
        redisService.expire(key, WEEKLY_LEADERBOARD_TTL);

        log.debug("✅ Updated weekly quiz score: user={}, score={}, week={}", userId, totalScore, weekKey);
    }

    /**
     * Get top N users from global Quick Quiz leaderboard
     */
    public List<LeaderboardEntry> getQuizGlobalTop(int topN) {
        String key = RedisKeyConstants.LEADERBOARD_QUIZ_GLOBAL;
        Set<Object> topUsers = redisService.zRevRange(key, 0, topN - 1);

        return convertToLeaderboardEntries(key, topUsers);
    }

    /**
     * Get top N users from daily Quick Quiz leaderboard
     */
    public List<LeaderboardEntry> getQuizDailyTop(int topN, LocalDate date) {
        String dateStr = date.format(DateTimeFormatter.ISO_LOCAL_DATE);
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.LEADERBOARD_QUIZ_DAILY, dateStr);
        Set<Object> topUsers = redisService.zRevRange(key, 0, topN - 1);

        return convertToLeaderboardEntries(key, topUsers);
    }

    /**
     * Get user rank in global Quick Quiz leaderboard
     */
    public Long getQuizGlobalRank(UUID userId) {
        String key = RedisKeyConstants.LEADERBOARD_QUIZ_GLOBAL;
        return redisService.zRank(key, userId.toString());
    }

    /**
     * Get user score in global Quick Quiz leaderboard
     */
    public Double getQuizGlobalScore(UUID userId) {
        String key = RedisKeyConstants.LEADERBOARD_QUIZ_GLOBAL;
        return redisService.zScore(key, userId.toString());
    }

    // ==================== STREAK LEADERBOARDS ====================

    /**
     * Update user streak in global leaderboard
     */
    public void updateStreakGlobalScore(UUID userId, int currentStreak) {
        String key = RedisKeyConstants.LEADERBOARD_STREAK_GLOBAL;
        redisService.zAdd(key, userId.toString(), currentStreak);
        log.debug("✅ Updated global streak: user={}, streak={}", userId, currentStreak);
    }

    /**
     * Update user best streak in leaderboard
     */
    public void updateBestStreakScore(UUID userId, int bestStreak) {
        String key = RedisKeyConstants.LEADERBOARD_STREAK_BEST;
        redisService.zAdd(key, userId.toString(), bestStreak);
        log.debug("✅ Updated best streak: user={}, bestStreak={}", userId, bestStreak);
    }

    /**
     * Get top N users by current streak
     */
    public List<LeaderboardEntry> getStreakGlobalTop(int topN) {
        String key = RedisKeyConstants.LEADERBOARD_STREAK_GLOBAL;
        Set<Object> topUsers = redisService.zRevRange(key, 0, topN - 1);

        return convertToLeaderboardEntries(key, topUsers);
    }

    /**
     * Get top N users by best streak
     */
    public List<LeaderboardEntry> getBestStreakTop(int topN) {
        String key = RedisKeyConstants.LEADERBOARD_STREAK_BEST;
        Set<Object> topUsers = redisService.zRevRange(key, 0, topN - 1);

        return convertToLeaderboardEntries(key, topUsers);
    }

    // ==================== IMAGE WORD MATCHING LEADERBOARDS ====================

    /**
     * Update user score in Image Matching global leaderboard
     */
    public void updateImageMatchingScore(UUID userId, double totalScore) {
        String key = RedisKeyConstants.LEADERBOARD_IMAGE_MATCHING_GLOBAL;
        redisService.zAdd(key, userId.toString(), totalScore);
        log.debug("✅ Updated image matching score: user={}, score={}", userId, totalScore);
    }

    /**
     * Get top N users from Image Matching leaderboard
     */
    public List<LeaderboardEntry> getImageMatchingTop(int topN) {
        String key = RedisKeyConstants.LEADERBOARD_IMAGE_MATCHING_GLOBAL;
        Set<Object> topUsers = redisService.zRevRange(key, 0, topN - 1);

        return convertToLeaderboardEntries(key, topUsers);
    }

    // ==================== WORD DEFINITION MATCHING LEADERBOARDS
    // ====================

    /**
     * Update user score in Word Definition global leaderboard
     */
    public void updateWordDefScore(UUID userId, double totalScore) {
        String key = RedisKeyConstants.LEADERBOARD_WORD_DEF_GLOBAL;
        redisService.zAdd(key, userId.toString(), totalScore);
        log.debug("✅ Updated word definition score: user={}, score={}", userId, totalScore);
    }

    /**
     * Get top N users from Word Definition leaderboard
     */
    public List<LeaderboardEntry> getWordDefTop(int topN) {
        String key = RedisKeyConstants.LEADERBOARD_WORD_DEF_GLOBAL;
        Set<Object> topUsers = redisService.zRevRange(key, 0, topN - 1);

        return convertToLeaderboardEntries(key, topUsers);
    }

    // ==================== VOCAB MASTERY LEADERBOARDS ====================

    /**
     * Update user's learned vocab count
     */
    public void updateVocabMasteryScore(UUID userId, int learnedCount) {
        String key = RedisKeyConstants.LEADERBOARD_VOCAB_MASTERY;
        redisService.zAdd(key, userId.toString(), learnedCount);
        log.debug("✅ Updated vocab mastery: user={}, learned={}", userId, learnedCount);
    }

    /**
     * Get top N users by learned vocab count
     */
    public List<LeaderboardEntry> getVocabMasteryTop(int topN) {
        String key = RedisKeyConstants.LEADERBOARD_VOCAB_MASTERY;
        Set<Object> topUsers = redisService.zRevRange(key, 0, topN - 1);

        return convertToLeaderboardEntries(key, topUsers);
    }

    // ==================== UTILITY METHODS ====================

    /**
     * Get leaderboard size
     */
    public Long getLeaderboardSize(String leaderboardKey) {
        return redisService.zCard(leaderboardKey);
    }

    /**
     * Get user rank in any leaderboard (1-based, null if not found)
     */
    public Long getUserRank(String leaderboardKey, UUID userId) {
        Long rank = redisService.zRank(leaderboardKey, userId.toString());
        return rank != null ? rank + 1 : null; // Convert to 1-based ranking
    }

    /**
     * Get user score in any leaderboard
     */
    public Double getUserScore(String leaderboardKey, UUID userId) {
        return redisService.zScore(leaderboardKey, userId.toString());
    }

    /**
     * Remove user from leaderboard
     */
    public void removeUserFromLeaderboard(String leaderboardKey, UUID userId) {
        redisService.zRem(leaderboardKey, userId.toString());
        log.info("✅ Removed user {} from leaderboard {}", userId, leaderboardKey);
    }

    /**
     * Clear entire leaderboard (use with caution!)
     */
    public void clearLeaderboard(String leaderboardKey) {
        redisService.delete(leaderboardKey);
        log.warn("⚠️ Cleared leaderboard: {}", leaderboardKey);
    }

    /**
     * Get users in rank range (e.g., ranks 10-20)
     */
    public List<LeaderboardEntry> getUsersInRankRange(String leaderboardKey, long startRank, long endRank) {
        // Convert 1-based ranks to 0-based indices
        Set<Object> users = redisService.zRevRange(leaderboardKey, startRank - 1, endRank - 1);
        return convertToLeaderboardEntries(leaderboardKey, users);
    }

    /**
     * Increment user score in leaderboard
     */
    public void incrementScore(String leaderboardKey, UUID userId, double incrementBy) {
        redisService.zAdd(leaderboardKey, userId.toString(), incrementBy);
        log.debug("✅ Incremented score: user={}, increment={}, leaderboard={}",
                userId, incrementBy, leaderboardKey);
    }

    // ==================== HELPER METHODS ====================

    /**
     * Convert Redis sorted set to LeaderboardEntry list
     */
    private List<LeaderboardEntry> convertToLeaderboardEntries(String key, Set<Object> userIds) {
        if (userIds == null || userIds.isEmpty()) {
            return Collections.emptyList();
        }

        return userIds.stream()
                .map(userId -> {
                    String userIdStr = userId.toString();
                    Double score = redisService.zScore(key, userIdStr);
                    Long rank = redisService.zRank(key, userIdStr);

                    return LeaderboardEntry.builder()
                            .userId(UUID.fromString(userIdStr))
                            .score(score != null ? score : 0.0)
                            .rank(rank != null ? rank + 1 : null) // 1-based ranking
                            .build();
                })
                .collect(Collectors.toList());
    }

    /**
     * Get week key in format "YYYY-Www" (e.g., "2024-W15")
     */
    private String getWeekKey() {
        LocalDate now = LocalDate.now();
        int year = now.getYear();
        int weekOfYear = now.getDayOfYear() / 7 + 1;
        return String.format("%d-W%02d", year, weekOfYear);
    }

    // ==================== DTO ====================

    @lombok.Data
    @lombok.Builder
    @lombok.NoArgsConstructor
    @lombok.AllArgsConstructor
    public static class LeaderboardEntry {
        private UUID userId;
        private Double score;
        private Long rank; // 1-based ranking
    }
}
