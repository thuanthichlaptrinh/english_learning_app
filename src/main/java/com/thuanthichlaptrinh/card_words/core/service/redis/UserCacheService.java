package com.thuanthichlaptrinh.card_words.core.service.redis;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.thuanthichlaptrinh.card_words.common.constants.RedisKeyConstants;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

/**
 * User Cache Service
 * Manages caching for user data using Redis Hash for efficient storage
 * 
 * Cache Strategy:
 * - User profile: Hash (field-level access)
 * - User lookup: String (email -> userId mapping)
 * - User active status: Set (active user IDs)
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class UserCacheService {

    private final BaseRedisService redisService;
    private final ObjectMapper objectMapper;

    // TTL Constants
    private static final long USER_PROFILE_TTL = TimeUnit.HOURS.toSeconds(24); // 24 hours
    private static final long USER_EMAIL_LOOKUP_TTL = TimeUnit.HOURS.toSeconds(12); // 12 hours
    private static final long USER_STATS_TTL = TimeUnit.MINUTES.toSeconds(15); // 15 minutes

    // ==================== USER PROFILE (HASH) ====================

    /**
     * Cache user profile using Hash structure
     * Hash allows field-level updates without re-caching entire object
     * 
     * Key: card-words:user:profile:{userId}
     * Structure: Hash {email, name, avatar, currentLevel, activated, banned, ...}
     */
    public void cacheUserProfile(UUID userId, Map<String, String> userFields) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_PROFILE, userId);

            // Store as hash for efficient field access
            redisService.hSetAll(key, userFields, USER_PROFILE_TTL);

            log.debug("✅ Cached user profile: userId={}", userId);
        } catch (Exception e) {
            log.error("❌ Failed to cache user profile: userId={}, error={}", userId, e.getMessage());
        }
    }

    /**
     * Get specific field from user profile
     */
    public String getUserProfileField(UUID userId, String field) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_PROFILE, userId);
            return (String) redisService.hGet(key, field);
        } catch (Exception e) {
            log.error("❌ Failed to get user profile field: userId={}, field={}", userId, field);
            return null;
        }
    }

    /**
     * Get entire user profile
     */
    public Map<Object, Object> getUserProfile(UUID userId) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_PROFILE, userId);
            Map<Object, Object> profile = redisService.hGetAll(key);

            if (profile.isEmpty()) {
                log.debug("⚠️ Cache miss: user profile userId={}", userId);
                return null;
            }

            return profile;
        } catch (Exception e) {
            log.error("❌ Failed to get user profile: userId={}", userId);
            return null;
        }
    }

    /**
     * Update specific fields in user profile
     */
    public void updateUserProfileFields(UUID userId, Map<String, String> fields) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_PROFILE, userId);

            for (Map.Entry<String, String> entry : fields.entrySet()) {
                redisService.hSet(key, entry.getKey(), entry.getValue());
            }

            // Refresh TTL
            redisService.expire(key, USER_PROFILE_TTL);

            log.debug("✅ Updated user profile fields: userId={}, fields={}", userId, fields.keySet());
        } catch (Exception e) {
            log.error("❌ Failed to update user profile: userId={}", userId);
        }
    }

    /**
     * Invalidate user profile cache
     */
    public void invalidateUserProfile(UUID userId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_PROFILE, userId);
        redisService.delete(key);
        log.debug("🗑️ Invalidated user profile: userId={}", userId);
    }

    // ==================== EMAIL -> USER ID LOOKUP (STRING) ====================

    /**
     * Cache email to userId mapping for fast authentication lookup
     * 
     * Key: card-words:user:email:{email}
     * Value: userId (String)
     */
    public void cacheEmailToUserId(String email, UUID userId) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_EMAIL_LOOKUP, email.toLowerCase());
            redisService.set(key, userId.toString(), USER_EMAIL_LOOKUP_TTL);
            log.debug("✅ Cached email lookup: email={} -> userId={}", email, userId);
        } catch (Exception e) {
            log.error("❌ Failed to cache email lookup: email={}", email);
        }
    }

    /**
     * Get userId by email
     */
    public UUID getUserIdByEmail(String email) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_EMAIL_LOOKUP, email.toLowerCase());
            String userIdStr = redisService.getAsString(key);

            if (userIdStr == null) {
                log.debug("⚠️ Cache miss: email lookup email={}", email);
                return null;
            }

            return UUID.fromString(userIdStr);
        } catch (Exception e) {
            log.error("❌ Failed to get userId by email: email={}", email);
            return null;
        }
    }

    /**
     * Invalidate email lookup cache
     */
    public void invalidateEmailLookup(String email) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_EMAIL_LOOKUP, email.toLowerCase());
        redisService.delete(key);
        log.debug("🗑️ Invalidated email lookup: email={}", email);
    }

    // ==================== USER STATS (HASH) ====================

    /**
     * Cache user statistics (vocab progress counts, game stats, etc.)
     * 
     * Key: card-words:user:stats:{userId}
     * Structure: Hash {learnedVocabs, newVocabs, knownVocabs, totalGames, ...}
     */
    public void cacheUserStats(UUID userId, Map<String, String> stats) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_STATS, userId);
            redisService.hSetAll(key, stats, USER_STATS_TTL);
            log.debug("✅ Cached user stats: userId={}", userId);
        } catch (Exception e) {
            log.error("❌ Failed to cache user stats: userId={}", userId);
        }
    }

    /**
     * Get user stats
     */
    public Map<Object, Object> getUserStats(UUID userId) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_STATS, userId);
            Map<Object, Object> stats = redisService.hGetAll(key);

            if (stats.isEmpty()) {
                log.debug("⚠️ Cache miss: user stats userId={}", userId);
                return null;
            }

            return stats;
        } catch (Exception e) {
            log.error("❌ Failed to get user stats: userId={}", userId);
            return null;
        }
    }

    /**
     * Invalidate user stats cache
     */
    public void invalidateUserStats(UUID userId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_STATS, userId);
        redisService.delete(key);
        log.debug("🗑️ Invalidated user stats: userId={}", userId);
    }

    // ==================== USER GAME SETTINGS (HASH) ====================

    /**
     * Cache user game settings
     * 
     * Key: card-words:user:game:settings:{userId}:{gameName}
     * Structure: Hash {cefr, timelimit, totalQuestions, ...}
     */
    public void cacheUserGameSettings(UUID userId, String gameName, Map<String, String> settings) {
        try {
            String key = RedisKeyConstants.buildKey("card-words:user:game:settings", userId, gameName);
            redisService.hSetAll(key, settings, TimeUnit.DAYS.toSeconds(7)); // 7 days
            log.debug("✅ Cached game settings: userId={}, game={}", userId, gameName);
        } catch (Exception e) {
            log.error("❌ Failed to cache game settings: userId={}, game={}", userId, gameName);
        }
    }

    /**
     * Get user game settings
     */
    public Map<Object, Object> getUserGameSettings(UUID userId, String gameName) {
        try {
            String key = RedisKeyConstants.buildKey("card-words:user:game:settings", userId, gameName);
            Map<Object, Object> settings = redisService.hGetAll(key);

            if (settings.isEmpty()) {
                log.debug("⚠️ Cache miss: game settings userId={}, game={}", userId, gameName);
                return null;
            }

            return settings;
        } catch (Exception e) {
            log.error("❌ Failed to get game settings: userId={}, game={}", userId, gameName);
            return null;
        }
    }

    // ==================== ONLINE USERS (SET) ====================

    /**
     * Add user to online users set
     * 
     * Key: card-words:users:online
     * Structure: Set<userId>
     */
    public void markUserOnline(UUID userId) {
        try {
            String key = "card-words:users:online";
            redisService.sAdd(key, userId.toString());
            // Set TTL on the key itself (will expire if no users online)
            redisService.expire(key, TimeUnit.HOURS.toSeconds(1));
            log.debug("✅ Marked user online: userId={}", userId);
        } catch (Exception e) {
            log.error("❌ Failed to mark user online: userId={}", userId);
        }
    }

    /**
     * Remove user from online users set
     */
    public void markUserOffline(UUID userId) {
        try {
            String key = "card-words:users:online";
            redisService.sRemove(key, userId.toString());
            log.debug("✅ Marked user offline: userId={}", userId);
        } catch (Exception e) {
            log.error("❌ Failed to mark user offline: userId={}", userId);
        }
    }

    /**
     * Check if user is online
     */
    public boolean isUserOnline(UUID userId) {
        try {
            String key = "card-words:users:online";
            return redisService.sIsMember(key, userId.toString());
        } catch (Exception e) {
            log.error("❌ Failed to check user online status: userId={}", userId);
            return false;
        }
    }

    /**
     * Get all online users count
     */
    public long getOnlineUsersCount() {
        try {
            String key = "card-words:users:online";
            return redisService.sSize(key);
        } catch (Exception e) {
            log.error("❌ Failed to get online users count");
            return 0;
        }
    }

    /**
     * Get all online user IDs
     */
    public Set<Object> getOnlineUsers() {
        try {
            String key = "card-words:users:online";
            return redisService.sMembers(key);
        } catch (Exception e) {
            log.error("❌ Failed to get online users");
            return Set.of();
        }
    }
}
