package com.thuanthichlaptrinh.card_words.core.service.redis;

import com.thuanthichlaptrinh.card_words.configuration.redis.RedisKeyConstants;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.Set;
import java.util.UUID;

/**
 * Authentication Cache Service
 * Manages JWT token blacklist, refresh tokens, and authentication-related
 * caching
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AuthenticationCacheService {

    private final BaseRedisService redisService;

    private static final Duration JWT_BLACKLIST_TTL = Duration.ofDays(7);
    private static final Duration REFRESH_TOKEN_TTL = Duration.ofDays(30);
    private static final Duration LOGIN_ATTEMPT_TTL = Duration.ofMinutes(15);
    private static final Duration SESSION_TTL = Duration.ofHours(24);
    private static final int MAX_LOGIN_ATTEMPTS = 5;

    // ==================== JWT TOKEN BLACKLIST ====================

    /**
     * Add JWT token to blacklist (for logout)
     */
    public void blacklistToken(String token, long expirationSeconds) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.JWT_BLACKLIST, token);
        Duration ttl = Duration.ofSeconds(expirationSeconds);

        redisService.set(key, "blacklisted", ttl);
        log.info("✅ Blacklisted JWT token (expires in {} seconds)", expirationSeconds);
    }

    /**
     * Check if JWT token is blacklisted
     */
    public boolean isTokenBlacklisted(String token) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.JWT_BLACKLIST, token);
        boolean blacklisted = redisService.exists(key);

        if (blacklisted) {
            log.warn("⚠️ Attempted to use blacklisted token");
        }

        return blacklisted;
    }

    /**
     * Remove token from blacklist (rare use case)
     */
    public void unblacklistToken(String token) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.JWT_BLACKLIST, token);
        redisService.delete(key);
        log.info("✅ Removed token from blacklist");
    }

    // ==================== REFRESH TOKENS ====================

    /**
     * Store refresh token for user
     */
    public void storeRefreshToken(UUID userId, String refreshToken) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.REFRESH_TOKEN, userId);
        redisService.set(key, refreshToken, REFRESH_TOKEN_TTL);
        log.info("✅ Stored refresh token for user {}", userId);
    }

    /**
     * Get refresh token for user
     */
    public String getRefreshToken(UUID userId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.REFRESH_TOKEN, userId);
        return redisService.getString(key);
    }

    /**
     * Validate refresh token
     */
    public boolean validateRefreshToken(UUID userId, String refreshToken) {
        String storedToken = getRefreshToken(userId);
        boolean valid = storedToken != null && storedToken.equals(refreshToken);

        if (!valid) {
            log.warn("⚠️ Invalid refresh token for user {}", userId);
        }

        return valid;
    }

    /**
     * Delete refresh token (on logout)
     */
    public void deleteRefreshToken(UUID userId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.REFRESH_TOKEN, userId);
        redisService.delete(key);
        log.info("✅ Deleted refresh token for user {}", userId);
    }

    // ==================== LOGIN ATTEMPTS ====================

    /**
     * Increment failed login attempts for email
     */
    public long incrementLoginAttempts(String email) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.LOGIN_ATTEMPTS, email);
        Long attempts = redisService.increment(key);

        if (attempts == null) {
            return 0;
        }

        // Set TTL on first attempt
        if (attempts == 1) {
            redisService.expire(key, LOGIN_ATTEMPT_TTL);
        }

        if (attempts >= MAX_LOGIN_ATTEMPTS) {
            log.warn("⚠️ Max login attempts reached for email: {}", email);
        }

        return attempts;
    }

    /**
     * Get current login attempt count
     */
    public long getLoginAttempts(String email) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.LOGIN_ATTEMPTS, email);
        String attemptsStr = redisService.getString(key);
        return attemptsStr != null ? Long.parseLong(attemptsStr) : 0;
    }

    /**
     * Check if account is locked due to failed attempts
     */
    public boolean isAccountLocked(String email) {
        long attempts = getLoginAttempts(email);
        return attempts >= MAX_LOGIN_ATTEMPTS;
    }

    /**
     * Reset login attempts after successful login
     */
    public void resetLoginAttempts(String email) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.LOGIN_ATTEMPTS, email);
        redisService.delete(key);
        log.info("✅ Reset login attempts for email: {}", email);
    }

    /**
     * Get remaining time until unlock (in seconds)
     */
    public Long getTimeUntilUnlock(String email) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.LOGIN_ATTEMPTS, email);
        Long ttl = redisService.getTTL(key);
        return ttl != null && ttl > 0 ? ttl : 0;
    }

    // ==================== USER SESSIONS ====================

    /**
     * Store user session data
     */
    public void storeUserSession(UUID userId, String sessionId, String sessionData) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_SESSION, userId, sessionId);
        redisService.set(key, sessionData, SESSION_TTL);
        log.debug("✅ Stored session for user {}: {}", userId, sessionId);
    }

    /**
     * Get user session data
     */
    public String getUserSession(UUID userId, String sessionId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_SESSION, userId, sessionId);
        return redisService.getString(key);
    }

    /**
     * Delete user session
     */
    public void deleteUserSession(UUID userId, String sessionId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_SESSION, userId, sessionId);
        redisService.delete(key);
        log.info("✅ Deleted session {} for user {}", sessionId, userId);
    }

    /**
     * Delete all sessions for user (force logout from all devices)
     */
    public void deleteAllUserSessions(UUID userId) {
        String pattern = RedisKeyConstants.buildKey(RedisKeyConstants.USER_SESSION, userId) + "*";
        Set<String> sessionKeys = redisService.keys(pattern);

        if (!sessionKeys.isEmpty()) {
            redisService.delete(sessionKeys.stream().toList());
            log.info("✅ Deleted {} sessions for user {}", sessionKeys.size(), userId);
        }
    }

    /**
     * Extend user session TTL (activity-based)
     */
    public void extendUserSession(UUID userId, String sessionId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_SESSION, userId, sessionId);
        redisService.expire(key, SESSION_TTL);
        log.debug("✅ Extended session {} for user {}", sessionId, userId);
    }

    // ==================== ACTIVE USERS ====================

    /**
     * Mark user as active (online)
     */
    public void markUserActive(UUID userId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_ACTIVE, userId);
        redisService.set(key, System.currentTimeMillis(), Duration.ofMinutes(5));
        log.debug("✅ Marked user {} as active", userId);
    }

    /**
     * Check if user is active
     */
    public boolean isUserActive(UUID userId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.USER_ACTIVE, userId);
        return redisService.exists(key);
    }

    /**
     * Get all active users count
     */
    public long getActiveUsersCount() {
        String pattern = RedisKeyConstants.USER_ACTIVE + "*";
        Set<String> activeUserKeys = redisService.keys(pattern);
        return activeUserKeys.size();
    }

    // ==================== PASSWORD RESET ====================

    /**
     * Store password reset token
     */
    public void storePasswordResetToken(String email, String resetToken) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.PASSWORD_RESET_TOKEN, email);
        redisService.set(key, resetToken, Duration.ofHours(1));
        log.info("✅ Stored password reset token for email: {}", email);
    }

    /**
     * Validate password reset token
     */
    public boolean validatePasswordResetToken(String email, String resetToken) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.PASSWORD_RESET_TOKEN, email);
        String storedToken = redisService.getString(key);

        boolean valid = storedToken != null && storedToken.equals(resetToken);

        if (valid) {
            // Delete token after validation (one-time use)
            redisService.delete(key);
            log.info("✅ Password reset token validated and consumed for: {}", email);
        } else {
            log.warn("⚠️ Invalid password reset token for: {}", email);
        }

        return valid;
    }

    /**
     * Delete password reset token
     */
    public void deletePasswordResetToken(String email) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.PASSWORD_RESET_TOKEN, email);
        redisService.delete(key);
        log.info("✅ Deleted password reset token for: {}", email);
    }

    // ==================== EMAIL VERIFICATION ====================

    /**
     * Store email verification token
     */
    public void storeEmailVerificationToken(String email, String verificationToken) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.EMAIL_VERIFICATION_TOKEN, email);
        redisService.set(key, verificationToken, Duration.ofHours(24));
        log.info("✅ Stored email verification token for: {}", email);
    }

    /**
     * Validate email verification token
     */
    public boolean validateEmailVerificationToken(String email, String verificationToken) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.EMAIL_VERIFICATION_TOKEN, email);
        String storedToken = redisService.getString(key);

        boolean valid = storedToken != null && storedToken.equals(verificationToken);

        if (valid) {
            redisService.delete(key);
            log.info("✅ Email verification token validated and consumed for: {}", email);
        } else {
            log.warn("⚠️ Invalid email verification token for: {}", email);
        }

        return valid;
    }

    // ==================== TWO-FACTOR AUTHENTICATION ====================

    /**
     * Store 2FA code
     */
    public void store2FACode(UUID userId, String code) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.TWO_FA_CODE, userId);
        redisService.set(key, code, Duration.ofMinutes(5));
        log.info("✅ Stored 2FA code for user {}", userId);
    }

    /**
     * Validate 2FA code
     */
    public boolean validate2FACode(UUID userId, String code) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.TWO_FA_CODE, userId);
        String storedCode = redisService.getString(key);

        boolean valid = storedCode != null && storedCode.equals(code);

        if (valid) {
            redisService.delete(key);
            log.info("✅ 2FA code validated for user {}", userId);
        } else {
            log.warn("⚠️ Invalid 2FA code for user {}", userId);
        }

        return valid;
    }

    // ==================== UTILITY ====================

    /**
     * Check if Redis is available
     */
    public boolean isRedisAvailable() {
        return redisService.ping();
    }

    /**
     * Clean up expired authentication data (maintenance task)
     */
    public void cleanupExpiredData() {
        log.info("🧹 Starting authentication data cleanup...");

        // Redis automatically removes expired keys, but we can log the cleanup
        int blacklistedTokens = redisService.keys(RedisKeyConstants.JWT_BLACKLIST + "*").size();
        int loginAttempts = redisService.keys(RedisKeyConstants.LOGIN_ATTEMPTS + "*").size();
        int activeSessions = redisService.keys(RedisKeyConstants.USER_SESSION + "*").size();

        log.info("✅ Cleanup completed: {} blacklisted tokens, {} login attempts tracked, {} active sessions",
                blacklistedTokens, loginAttempts, activeSessions);
    }
}
