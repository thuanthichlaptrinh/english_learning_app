package com.thuanthichlaptrinh.card_words.core.service.redis;

import com.thuanthichlaptrinh.card_words.configuration.redis.RedisKeyConstants;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.UUID;

/**
 * Rate Limiting Service
 * Implements various rate limiting strategies using Redis
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class RateLimitingService {

    private final BaseRedisService redisService;

    // Rate limit configurations
    private static final int API_RATE_LIMIT = 100; // 100 requests per minute
    private static final Duration API_RATE_WINDOW = Duration.ofMinutes(1);

    private static final int EMAIL_RATE_LIMIT = 5; // 5 emails per hour
    private static final Duration EMAIL_RATE_WINDOW = Duration.ofHours(1);

    private static final int SEARCH_RATE_LIMIT = 50; // 50 searches per minute
    private static final Duration SEARCH_RATE_WINDOW = Duration.ofMinutes(1);

    private static final int EXPORT_RATE_LIMIT = 10; // 10 exports per hour
    private static final Duration EXPORT_RATE_WINDOW = Duration.ofHours(1);

    // ==================== API RATE LIMITING ====================

    /**
     * Check API rate limit for user
     * @return RateLimitResult with allowed status and remaining requests
     */
    public RateLimitResult checkApiRateLimit(UUID userId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.RATE_LIMIT_API, userId);
        return checkRateLimit(key, API_RATE_LIMIT, API_RATE_WINDOW, "API");
    }

    /**
     * Check API rate limit for IP address (for anonymous users)
     */
    public RateLimitResult checkApiRateLimitByIp(String ipAddress) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.RATE_LIMIT_API, "ip", ipAddress);
        return checkRateLimit(key, API_RATE_LIMIT, API_RATE_WINDOW, "API");
    }

    // ==================== EMAIL RATE LIMITING ====================

    /**
     * Check email rate limit
     */
    public RateLimitResult checkEmailRateLimit(String email) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.RATE_LIMIT_EMAIL, email);
        return checkRateLimit(key, EMAIL_RATE_LIMIT, EMAIL_RATE_WINDOW, "Email");
    }

    /**
     * Check email rate limit by user ID
     */
    public RateLimitResult checkEmailRateLimitByUser(UUID userId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.RATE_LIMIT_EMAIL, userId);
        return checkRateLimit(key, EMAIL_RATE_LIMIT, EMAIL_RATE_WINDOW, "Email");
    }

    // ==================== SEARCH RATE LIMITING ====================

    /**
     * Check search rate limit
     */
    public RateLimitResult checkSearchRateLimit(UUID userId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.RATE_LIMIT_SEARCH, userId);
        return checkRateLimit(key, SEARCH_RATE_LIMIT, SEARCH_RATE_WINDOW, "Search");
    }

    // ==================== EXPORT RATE LIMITING ====================

    /**
     * Check export rate limit
     */
    public RateLimitResult checkExportRateLimit(UUID userId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.RATE_LIMIT_EXPORT, userId);
        return checkRateLimit(key, EXPORT_RATE_LIMIT, EXPORT_RATE_WINDOW, "Export");
    }

    // ==================== GAME RATE LIMITING ====================
    // Note: Game-specific rate limiting is handled in GameSessionCacheService

    /**
     * Check generic game rate limit
     */
    public RateLimitResult checkGameRateLimit(UUID userId, String gameType, int maxGames, Duration window) {
        String key;
        switch (gameType.toLowerCase()) {
            case "quickquiz":
                key = RedisKeyConstants.buildKey(RedisKeyConstants.RATE_LIMIT_QUIZ, userId);
                break;
            case "imagematching":
                key = RedisKeyConstants.buildKey(RedisKeyConstants.RATE_LIMIT_IMAGE_MATCHING, userId);
                break;
            case "worddef":
                key = RedisKeyConstants.buildKey(RedisKeyConstants.RATE_LIMIT_WORD_DEF, userId);
                break;
            default:
                log.warn("⚠️ Unknown game type: {}", gameType);
                return RateLimitResult.allowed(maxGames);
        }
        
        return checkRateLimit(key, maxGames, window, gameType);
    }

    // ==================== CORE RATE LIMITING LOGIC ====================

    /**
     * Generic rate limit checker using sliding window counter
     */
    private RateLimitResult checkRateLimit(String key, int maxRequests, Duration window, String limitType) {
        try {
            // Increment counter
            Long currentCount = redisService.increment(key);
            
            if (currentCount == null) {
                log.error("❌ Failed to increment rate limit counter: {}", key);
                return RateLimitResult.error();
            }
            
            // Set TTL on first request
            if (currentCount == 1) {
                redisService.expire(key, window);
            }
            
            // Calculate remaining requests
            long remaining = Math.max(0, maxRequests - currentCount);
            boolean allowed = currentCount <= maxRequests;
            
            if (!allowed) {
                Long ttl = redisService.getTTL(key);
                log.warn("⚠️ {} rate limit exceeded: key={}, count={}/{}, reset in {} seconds", 
                        limitType, key, currentCount, maxRequests, ttl);
                
                return RateLimitResult.builder()
                        .allowed(false)
                        .currentCount(currentCount)
                        .limit(maxRequests)
                        .remaining(0)
                        .resetInSeconds(ttl != null ? ttl : 0)
                        .build();
            }
            
            log.debug("✅ {} rate limit check passed: {}/{}", limitType, currentCount, maxRequests);
            
            return RateLimitResult.builder()
                    .allowed(true)
                    .currentCount(currentCount)
                    .limit(maxRequests)
                    .remaining(remaining)
                    .resetInSeconds(window.getSeconds())
                    .build();
                    
        } catch (Exception e) {
            log.error("❌ Rate limit check failed: key={}, error={}", key, e.getMessage());
            // Fail open: allow request on error
            return RateLimitResult.error();
        }
    }

    // ==================== CUSTOM RATE LIMITING ====================

    /**
     * Check custom rate limit with configurable parameters
     */
    public RateLimitResult checkCustomRateLimit(String identifier, String action, int maxRequests, Duration window) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.RATE_LIMIT_CUSTOM, identifier, action);
        return checkRateLimit(key, maxRequests, window, "Custom-" + action);
    }

    // ==================== UTILITY METHODS ====================

    /**
     * Get current rate limit count
     */
    public long getRateLimitCount(String key) {
        String countStr = redisService.getString(key);
        return countStr != null ? Long.parseLong(countStr) : 0;
    }

    /**
     * Reset rate limit for a key
     */
    public void resetRateLimit(String key) {
        redisService.delete(key);
        log.info("✅ Reset rate limit: {}", key);
    }

    /**
     * Get time until rate limit resets
     */
    public Long getTimeUntilReset(String key) {
        Long ttl = redisService.getTTL(key);
        return ttl != null && ttl > 0 ? ttl : 0;
    }

    /**
     * Check if key is rate limited
     */
    public boolean isRateLimited(String key, int maxRequests) {
        long count = getRateLimitCount(key);
        return count >= maxRequests;
    }

    // ==================== ADVANCED: TOKEN BUCKET ====================

    /**
     * Token bucket rate limiter (more flexible than simple counter)
     * Allows burst traffic up to bucket capacity
     */
    public boolean checkTokenBucket(String identifier, int bucketCapacity, int refillRate, Duration refillInterval) {
        String bucketKey = RedisKeyConstants.buildKey("rate_limit:token_bucket", identifier);
        String lastRefillKey = bucketKey + ":last_refill";
        
        // Get current tokens
        Long currentTokens = redisService.get(bucketKey, Long.class);
        Long lastRefill = redisService.get(lastRefillKey, Long.class);
        
        long now = System.currentTimeMillis();
        
        // Initialize bucket if not exists
        if (currentTokens == null) {
            currentTokens = (long) bucketCapacity;
            redisService.set(bucketKey, currentTokens, Duration.ofHours(1));
        }
        
        if (lastRefill == null) {
            lastRefill = now;
            redisService.set(lastRefillKey, lastRefill, Duration.ofHours(1));
        }
        
        // Calculate tokens to add based on time elapsed
        long timeSinceLastRefill = now - lastRefill;
        long intervalsElapsed = timeSinceLastRefill / refillInterval.toMillis();
        
        if (intervalsElapsed > 0) {
            long tokensToAdd = intervalsElapsed * refillRate;
            currentTokens = Math.min(bucketCapacity, currentTokens + tokensToAdd);
            
            redisService.set(bucketKey, currentTokens, Duration.ofHours(1));
            redisService.set(lastRefillKey, now, Duration.ofHours(1));
        }
        
        // Check if we have tokens available
        if (currentTokens > 0) {
            redisService.decrement(bucketKey);
            log.debug("✅ Token bucket: consumed token, {} remaining", currentTokens - 1);
            return true;
        }
        
        log.warn("⚠️ Token bucket empty: {}", identifier);
        return false;
    }

    // ==================== MONITORING ====================

    /**
     * Get rate limit statistics
     */
    public RateLimitStats getStats() {
        long apiLimits = redisService.keys(RedisKeyConstants.RATE_LIMIT_API + "*").size();
        long emailLimits = redisService.keys(RedisKeyConstants.RATE_LIMIT_EMAIL + "*").size();
        long searchLimits = redisService.keys(RedisKeyConstants.RATE_LIMIT_SEARCH + "*").size();
        long gameLimits = redisService.keys(RedisKeyConstants.RATE_LIMIT_QUIZ + "*").size() +
                          redisService.keys(RedisKeyConstants.RATE_LIMIT_IMAGE_MATCHING + "*").size() +
                          redisService.keys(RedisKeyConstants.RATE_LIMIT_WORD_DEF + "*").size();
        
        return RateLimitStats.builder()
                .activeApiLimits(apiLimits)
                .activeEmailLimits(emailLimits)
                .activeSearchLimits(searchLimits)
                .activeGameLimits(gameLimits)
                .totalActiveLimits(apiLimits + emailLimits + searchLimits + gameLimits)
                .build();
    }

    // ==================== DTOs ====================

    @lombok.Data
    @lombok.Builder
    @lombok.NoArgsConstructor
    @lombok.AllArgsConstructor
    public static class RateLimitResult {
        private boolean allowed;
        private long currentCount;
        private int limit;
        private long remaining;
        private long resetInSeconds;
        
        public static RateLimitResult allowed(int limit) {
            return RateLimitResult.builder()
                    .allowed(true)
                    .currentCount(0)
                    .limit(limit)
                    .remaining(limit)
                    .resetInSeconds(0)
                    .build();
        }
        
        public static RateLimitResult error() {
            // Fail open: allow request on error
            return RateLimitResult.builder()
                    .allowed(true)
                    .currentCount(0)
                    .limit(Integer.MAX_VALUE)
                    .remaining(Integer.MAX_VALUE)
                    .resetInSeconds(0)
                    .build();
        }
    }

    @lombok.Data
    @lombok.Builder
    @lombok.NoArgsConstructor
    @lombok.AllArgsConstructor
    public static class RateLimitStats {
        private long activeApiLimits;
        private long activeEmailLimits;
        private long activeSearchLimits;
        private long activeGameLimits;
        private long totalActiveLimits;
    }
}
