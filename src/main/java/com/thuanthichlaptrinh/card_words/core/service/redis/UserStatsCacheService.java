package com.thuanthichlaptrinh.card_words.core.service.redis;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.thuanthichlaptrinh.card_words.configuration.redis.RedisKeyConstants;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;

/**
 * User Statistics Cache Service
 * Manages caching for user statistics and progress
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class UserStatsCacheService {

    private final BaseRedisService redisService;
    private final ObjectMapper objectMapper;

    private static final Duration USER_STATS_TTL = Duration.ofMinutes(10);
    private static final Duration USER_PROGRESS_TTL = Duration.ofHours(1);
    private static final Duration USER_STREAK_TTL = Duration.ofMinutes(30);

    // ==================== USER OVERALL STATS ====================

    /**
     * Cache user overall statistics
     */
    public <T> void cacheUserStats(UUID userId, T stats) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_STATS, userId);
            String json = objectMapper.writeValueAsString(stats);
            redisService.set(key, json, USER_STATS_TTL);
            log.debug("✅ Cached user stats: userId={}", userId);
        } catch (JsonProcessingException e) {
            log.error("❌ Failed to cache user stats: userId={}, error={}", userId, e.getMessage());
        }
    }

    /**
     * Get cached user statistics
     */
    public <T> T getUserStats(UUID userId, Class<T> clazz) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_STATS, userId);
            String json = (String) redisService.get(key);
            
            if (json == null) {
                log.debug("⚠️ Cache miss: user stats for {}", userId);
                return null;
            }
            
            return objectMapper.readValue(json, clazz);
        } catch (Exception e) {
            log.error("❌ Failed to get user stats: userId={}, error={}", userId, e.getMessage());
            return null;
        }
    }

    /**
     * Invalidate user statistics cache
     */
    public void invalidateUserStats(UUID userId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_STATS, userId);
        redisService.delete(key);
        log.info("✅ Invalidated user stats cache: userId={}", userId);
    }

    // ==================== USER GAME STATS ====================

    /**
     * Cache user Quick Quiz statistics
     */
    public <T> void cacheUserQuizStats(UUID userId, T quizStats) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_QUIZ_STATS, userId);
            String json = objectMapper.writeValueAsString(quizStats);
            redisService.set(key, json, USER_STATS_TTL);
            log.debug("✅ Cached quiz stats: userId={}", userId);
        } catch (JsonProcessingException e) {
            log.error("❌ Failed to cache quiz stats: userId={}", userId);
        }
    }

    /**
     * Get cached user Quick Quiz statistics
     */
    public <T> T getUserQuizStats(UUID userId, Class<T> clazz) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_QUIZ_STATS, userId);
            String json = (String) redisService.get(key);
            return json != null ? objectMapper.readValue(json, clazz) : null;
        } catch (Exception e) {
            log.error("❌ Failed to get quiz stats: userId={}", userId);
            return null;
        }
    }

    /**
     * Cache user Image Matching statistics
     */
    public <T> void cacheUserImageMatchingStats(UUID userId, T stats) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_IMAGE_MATCHING_STATS, userId);
            String json = objectMapper.writeValueAsString(stats);
            redisService.set(key, json, USER_STATS_TTL);
            log.debug("✅ Cached image matching stats: userId={}", userId);
        } catch (JsonProcessingException e) {
            log.error("❌ Failed to cache image matching stats: userId={}", userId);
        }
    }

    /**
     * Cache user Word Definition statistics
     */
    public <T> void cacheUserWordDefStats(UUID userId, T stats) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_WORD_DEF_STATS, userId);
            String json = objectMapper.writeValueAsString(stats);
            redisService.set(key, json, USER_STATS_TTL);
            log.debug("✅ Cached word definition stats: userId={}", userId);
        } catch (JsonProcessingException e) {
            log.error("❌ Failed to cache word definition stats: userId={}", userId);
        }
    }

    // ==================== USER PROGRESS ====================

    /**
     * Cache user vocabulary progress
     */
    public void cacheUserVocabProgress(UUID userId, Map<String, Object> progress) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_VOCAB_PROGRESS, userId);
            String json = objectMapper.writeValueAsString(progress);
            redisService.set(key, json, USER_PROGRESS_TTL);
            log.debug("✅ Cached vocab progress: userId={}", userId);
        } catch (JsonProcessingException e) {
            log.error("❌ Failed to cache vocab progress: userId={}", userId);
        }
    }

    /**
     * Get cached user vocabulary progress
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> getUserVocabProgress(UUID userId) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_VOCAB_PROGRESS, userId);
            String json = (String) redisService.get(key);
            
            if (json == null) {
                return null;
            }
            
            return objectMapper.readValue(json, Map.class);
        } catch (Exception e) {
            log.error("❌ Failed to get vocab progress: userId={}", userId);
            return null;
        }
    }

    /**
     * Cache learned vocabulary count
     */
    public void cacheLearnedVocabCount(UUID userId, long count) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_LEARNED_COUNT, userId);
        redisService.set(key, count, USER_PROGRESS_TTL);
        log.debug("✅ Cached learned vocab count: userId={}, count={}", userId, count);
    }

    /**
     * Get cached learned vocabulary count
     */
    public Long getLearnedVocabCount(UUID userId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_LEARNED_COUNT, userId);
        return redisService.get(key, Long.class);
    }

    /**
     * Increment learned vocabulary count
     */
    public Long incrementLearnedVocabCount(UUID userId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_LEARNED_COUNT, userId);
        Long newCount = redisService.increment(key);
        
        if (newCount != null && newCount == 1) {
            redisService.expire(key, USER_PROGRESS_TTL);
        }
        
        return newCount;
    }

    // ==================== USER STREAK ====================

    /**
     * Cache user streak data
     */
    public <T> void cacheUserStreak(UUID userId, T streakData) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_STREAK, userId);
            String json = objectMapper.writeValueAsString(streakData);
            redisService.set(key, json, USER_STREAK_TTL);
            log.debug("✅ Cached user streak: userId={}", userId);
        } catch (JsonProcessingException e) {
            log.error("❌ Failed to cache user streak: userId={}", userId);
        }
    }

    /**
     * Get cached user streak data
     */
    public <T> T getUserStreak(UUID userId, Class<T> clazz) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_STREAK, userId);
            String json = (String) redisService.get(key);
            
            if (json == null) {
                return null;
            }
            
            return objectMapper.readValue(json, clazz);
        } catch (Exception e) {
            log.error("❌ Failed to get user streak: userId={}", userId);
            return null;
        }
    }

    /**
     * Cache last learning date
     */
    public void cacheLastLearningDate(UUID userId, LocalDateTime lastDate) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_LAST_LEARNING, userId);
        redisService.set(key, lastDate, Duration.ofDays(7));
        log.debug("✅ Cached last learning date: userId={}, date={}", userId, lastDate);
    }

    /**
     * Get cached last learning date
     */
    public LocalDateTime getLastLearningDate(UUID userId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_LAST_LEARNING, userId);
        return redisService.get(key, LocalDateTime.class);
    }

    /**
     * Invalidate user streak cache
     */
    public void invalidateUserStreak(UUID userId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_STREAK, userId);
        redisService.delete(key);
        log.info("✅ Invalidated user streak cache: userId={}", userId);
    }

    // ==================== USER ACHIEVEMENTS ====================

    /**
     * Cache user achievements
     */
    public <T> void cacheUserAchievements(UUID userId, List<T> achievements) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_ACHIEVEMENTS, userId);
            String json = objectMapper.writeValueAsString(achievements);
            redisService.set(key, json, Duration.ofHours(1));
            log.debug("✅ Cached {} achievements for user {}", achievements.size(), userId);
        } catch (JsonProcessingException e) {
            log.error("❌ Failed to cache achievements: userId={}", userId);
        }
    }

    /**
     * Add achievement to user's set
     */
    public void addAchievement(UUID userId, String achievementId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_ACHIEVEMENTS, userId);
        redisService.sAdd(key, achievementId);
        log.info("✅ Added achievement {} to user {}", achievementId, userId);
    }

    /**
     * Check if user has achievement
     */
    public boolean hasAchievement(UUID userId, String achievementId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_ACHIEVEMENTS, userId);
        return redisService.sIsMember(key, achievementId);
    }

    // ==================== DAILY/WEEKLY STATS ====================

    /**
     * Increment user's daily game count
     */
    public Long incrementDailyGameCount(UUID userId, String date) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_DAILY_GAMES, userId, date);
        Long count = redisService.increment(key);
        
        if (count != null && count == 1) {
            redisService.expire(key, Duration.ofHours(26)); // 24h + 2h buffer
        }
        
        return count;
    }

    /**
     * Get user's daily game count
     */
    public Long getDailyGameCount(UUID userId, String date) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_DAILY_GAMES, userId, date);
        String countStr = redisService.getString(key);
        return countStr != null ? Long.parseLong(countStr) : 0L;
    }

    /**
     * Increment user's daily XP
     */
    public Long incrementDailyXP(UUID userId, String date, long xpAmount) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_DAILY_XP, userId, date);
        
        // Redis increment only works with 1, so we add the amount
        Long currentXP = redisService.get(key, Long.class);
        long newXP = (currentXP != null ? currentXP : 0) + xpAmount;
        
        redisService.set(key, newXP, Duration.ofHours(26));
        log.debug("✅ Added {} XP to user {} for date {}: total={}", xpAmount, userId, date, newXP);
        
        return newXP;
    }

    /**
     * Get user's daily XP
     */
    public Long getDailyXP(UUID userId, String date) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_DAILY_XP, userId, date);
        return redisService.get(key, Long.class);
    }

    // ==================== BULK OPERATIONS ====================

    /**
     * Invalidate all user caches
     */
    public void invalidateAllUserCaches(UUID userId) {
        List<String> patterns = Arrays.asList(
            RedisKeyConstants.buildKey(RedisKeyConstants.USER_STATS, userId),
            RedisKeyConstants.buildKey(RedisKeyConstants.USER_QUIZ_STATS, userId),
            RedisKeyConstants.buildKey(RedisKeyConstants.USER_IMAGE_MATCHING_STATS, userId),
            RedisKeyConstants.buildKey(RedisKeyConstants.USER_WORD_DEF_STATS, userId),
            RedisKeyConstants.buildKey(RedisKeyConstants.USER_VOCAB_PROGRESS, userId),
            RedisKeyConstants.buildKey(RedisKeyConstants.USER_STREAK, userId),
            RedisKeyConstants.buildKey(RedisKeyConstants.USER_ACHIEVEMENTS, userId)
        );
        
        redisService.delete(patterns);
        log.info("✅ Invalidated all caches for user {}", userId);
    }

    /**
     * Check if Redis is available
     */
    public boolean isRedisAvailable() {
        return redisService.ping();
    }
}
