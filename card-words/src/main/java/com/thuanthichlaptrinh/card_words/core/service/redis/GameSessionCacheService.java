package com.thuanthichlaptrinh.card_words.core.service.redis;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.thuanthichlaptrinh.card_words.common.constants.RedisKeyConstants;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.QuestionData;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class GameSessionCacheService {

    private final BaseRedisService redisService;
    private final ObjectMapper objectMapper;

    private static final Duration SESSION_TTL = Duration.ofMinutes(30);
    private static final Duration RATE_LIMIT_TTL = Duration.ofMinutes(5);
    private static final int MAX_GAMES_PER_5_MIN = 10;

    // ==================== QUICK QUIZ ====================

    // Cache questions for Quick Quiz session
    public void cacheQuizQuestions(UUID sessionId, List<QuestionData> questions) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.QUIZ_SESSION_QUESTIONS, sessionId);
            log.info("🔑 Attempting to cache questions with key: {}", key);
            String json = objectMapper.writeValueAsString(questions);
            log.info("📝 JSON serialized successfully, length: {} chars", json.length());
            redisService.set(key, json, SESSION_TTL);
            log.info("✅ Cached {} questions for quiz session {}", questions.size(), sessionId);
        } catch (JsonProcessingException e) {
            log.error("❌ Failed to cache quiz questions (JSON): sessionId={}, error={}", sessionId, e.getMessage(), e);
        } catch (Exception e) {
            log.error("❌ Failed to cache quiz questions (Redis): sessionId={}, error={}", sessionId, e.getMessage(), e);
        }
    }

    // Get cached questions for Quick Quiz session
    public List<QuestionData> getQuizQuestions(UUID sessionId) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.QUIZ_SESSION_QUESTIONS, sessionId);
            String json = redisService.getAsString(key);

            if (json == null) {
                log.warn("⚠️ No cached questions found for session {}", sessionId);
                return null;
            }

            List<QuestionData> questions = objectMapper.readValue(json, new TypeReference<List<QuestionData>>() {
            });
            log.info("✅ Retrieved {} cached questions for session {}", questions.size(), sessionId);
            return questions;
        } catch (Exception e) {
            log.error("❌ Failed to get quiz questions: sessionId={}, error={}", sessionId, e.getMessage());
            return null;
        }
    }

    public void cacheQuestionStartTime(UUID sessionId, int questionNumber, LocalDateTime startTime) {
        String key = RedisKeyConstants.buildKey(
                RedisKeyConstants.QUIZ_SESSION_QUESTION_START,
                sessionId,
                questionNumber);
        redisService.set(key, startTime, SESSION_TTL);
        log.debug("✅ Cached start time for session {} question {}", sessionId, questionNumber);
    }

    public LocalDateTime getQuestionStartTime(UUID sessionId, int questionNumber) {
        String key = RedisKeyConstants.buildKey(
                RedisKeyConstants.QUIZ_SESSION_QUESTION_START,
                sessionId,
                questionNumber);
        return redisService.get(key, LocalDateTime.class);
    }

    public void cacheSessionTimeLimit(UUID sessionId, int timeLimitMs) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.QUIZ_SESSION_TIMELIMIT, sessionId);
            log.info("🔑 Attempting to cache time limit with key: {}, value: {}", key, timeLimitMs);
            redisService.set(key, timeLimitMs, SESSION_TTL);
            log.info("✅ Cached time limit {} ms for session {}", timeLimitMs, sessionId);
        } catch (Exception e) {
            log.error("❌ Failed to cache time limit: sessionId={}, error={}", sessionId, e.getMessage(), e);
        }
    }

    public Integer getSessionTimeLimit(UUID sessionId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.QUIZ_SESSION_TIMELIMIT, sessionId);
        return redisService.get(key, Integer.class);
    }

    public void deleteQuizSessionCache(UUID sessionId) {
        List<String> keys = new ArrayList<>();
        keys.add(RedisKeyConstants.buildKey(RedisKeyConstants.QUIZ_SESSION_QUESTIONS, sessionId));
        keys.add(RedisKeyConstants.buildKey(RedisKeyConstants.QUIZ_SESSION_TIMELIMIT, sessionId));
        keys.add(RedisKeyConstants.buildKey(RedisKeyConstants.QUIZ_SESSION_META, sessionId));

        // Also delete all question start times (1-10 questions)
        for (int i = 1; i <= 20; i++) {
            keys.add(RedisKeyConstants.buildKey(
                    RedisKeyConstants.QUIZ_SESSION_QUESTION_START,
                    sessionId,
                    i));
        }

        long deleted = redisService.delete(keys);
        log.info("✅ Deleted {} cache keys for quiz session {}", deleted, sessionId);
    }

    // ==================== IMAGE WORD MATCHING ====================

    public void cacheImageMatchingSession(UUID sessionId, Object sessionData) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.IMAGE_MATCHING_SESSION, sessionId);
            log.info("🔑 Attempting to cache image-matching session with key: {}", key);
            String json = objectMapper.writeValueAsString(sessionData);
            log.info("📝 JSON serialized successfully, length: {} chars", json.length());
            redisService.set(key, json, SESSION_TTL);
            log.info("✅ Cached image matching session {}", sessionId);
        } catch (JsonProcessingException e) {
            log.error("❌ Failed to cache image matching session (JSON): sessionId={}, error={}", sessionId,
                    e.getMessage(), e);
        } catch (Exception e) {
            log.error("❌ Failed to cache image matching session (Redis): sessionId={}, error={}", sessionId,
                    e.getMessage(), e);
        }
    }

    public <T> T getImageMatchingSession(UUID sessionId, Class<T> clazz) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.IMAGE_MATCHING_SESSION, sessionId);
            String json = redisService.getAsString(key);

            if (json == null) {
                return null;
            }

            return objectMapper.readValue(json, clazz);
        } catch (Exception e) {
            log.error("❌ Failed to get image matching session: {}", e.getMessage());
            return null;
        }
    }

    public void deleteImageMatchingSession(UUID sessionId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.IMAGE_MATCHING_SESSION, sessionId);
        redisService.delete(key);
        log.info("✅ Deleted image matching session cache: {}", sessionId);
    }

    public void setUserActiveImageMatching(UUID userId, UUID sessionId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.IMAGE_MATCHING_USER_ACTIVE, userId);
        redisService.set(key, sessionId, SESSION_TTL);
    }

    public UUID getUserActiveImageMatching(UUID userId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.IMAGE_MATCHING_USER_ACTIVE, userId);
        return redisService.get(key, UUID.class);
    }

    // ==================== WORD DEFINITION MATCHING ====================

    public void cacheWordDefSession(UUID sessionId, Object sessionData) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.WORD_DEF_SESSION, sessionId);
            log.info("🔑 Attempting to cache word-def session with key: {}", key);
            String json = objectMapper.writeValueAsString(sessionData);
            log.info("📝 JSON serialized successfully, length: {} chars", json.length());
            redisService.set(key, json, SESSION_TTL);
            log.info("✅ Cached word definition session {}", sessionId);
        } catch (JsonProcessingException e) {
            log.error("❌ Failed to cache word definition session (JSON): sessionId={}, error={}", sessionId,
                    e.getMessage(), e);
        } catch (Exception e) {
            log.error("❌ Failed to cache word definition session (Redis): sessionId={}, error={}", sessionId,
                    e.getMessage(), e);
        }
    }

    public <T> T getWordDefSession(UUID sessionId, Class<T> clazz) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.WORD_DEF_SESSION, sessionId);
            String json = redisService.getAsString(key);

            if (json == null) {
                return null;
            }

            return objectMapper.readValue(json, clazz);
        } catch (Exception e) {
            log.error("❌ Failed to get word definition session: {}", e.getMessage());
            return null;
        }
    }

    public void deleteWordDefSession(UUID sessionId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.WORD_DEF_SESSION, sessionId);
        redisService.delete(key);
        log.info("✅ Deleted word definition session cache: {}", sessionId);
    }

    public void setUserActiveWordDef(UUID userId, UUID sessionId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.WORD_DEF_USER_ACTIVE, userId);
        redisService.set(key, sessionId, SESSION_TTL);
    }

    public UUID getUserActiveWordDef(UUID userId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.WORD_DEF_USER_ACTIVE, userId);
        return redisService.get(key, UUID.class);
    }

    // ==================== RATE LIMITING ====================

    /**
     * Check and increment rate limit for Quick Quiz
     * 
     * @return true if allowed, false if rate limit exceeded
     */
    public boolean checkQuizRateLimit(UUID userId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.RATE_LIMIT_QUIZ, userId);

        Long count = redisService.increment(key);
        if (count == null) {
            return false;
        }

        // Set expiry on first increment
        if (count == 1) {
            redisService.expire(key, RATE_LIMIT_TTL);
        }

        boolean allowed = count <= MAX_GAMES_PER_5_MIN;
        if (!allowed) {
            log.warn("⚠️ Rate limit exceeded for user {}: {} games in 5 minutes", userId, count);
        }

        return allowed;
    }

    // Check and increment rate limit for Image Matching
    public boolean checkImageMatchingRateLimit(UUID userId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.RATE_LIMIT_IMAGE_MATCHING, userId);

        Long count = redisService.increment(key);
        if (count == null) {
            return false;
        }

        if (count == 1) {
            redisService.expire(key, RATE_LIMIT_TTL);
        }

        return count <= MAX_GAMES_PER_5_MIN;
    }

    // Check and increment rate limit for Word Definition
    public boolean checkWordDefRateLimit(UUID userId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.RATE_LIMIT_WORD_DEF, userId);

        Long count = redisService.increment(key);
        if (count == null) {
            return false;
        }

        if (count == 1) {
            redisService.expire(key, RATE_LIMIT_TTL);
        }

        return count <= MAX_GAMES_PER_5_MIN;
    }

    // Get current rate limit count
    public int getRateLimitCount(UUID userId, String gameType) {
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
                return 0;
        }

        String countStr = redisService.getString(key);
        return countStr != null ? Integer.parseInt(countStr) : 0;
    }

    // ==================== UTILITY ====================

    // Check if Redis is connected
    public boolean isRedisAvailable() {
        return redisService.ping();
    }
}
