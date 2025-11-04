package com.thuanthichlaptrinh.card_words.configuration.redis;

/**
 * Redis Key Constants
 * Centralized key naming for all Redis operations
 */
public final class RedisKeyConstants {

    private RedisKeyConstants() {
        // Prevent instantiation
    }

    // Base prefix
    public static final String BASE_PREFIX = "card-words:";

    // ==================== GAME SESSIONS ====================
    
    // Quick Quiz
    public static final String QUIZ_SESSION_QUESTIONS = BASE_PREFIX + "game:quickquiz:session:{sessionId}:questions";
    public static final String QUIZ_SESSION_QUESTION_START = BASE_PREFIX + "game:quickquiz:session:{sessionId}:q:{questionNumber}:start";
    public static final String QUIZ_SESSION_TIMELIMIT = BASE_PREFIX + "game:quickquiz:session:{sessionId}:timelimit";
    public static final String QUIZ_SESSION_META = BASE_PREFIX + "game:quickquiz:session:{sessionId}:meta";
    
    // Image Word Matching
    public static final String IMAGE_MATCHING_SESSION = BASE_PREFIX + "game:imagematching:session:{sessionId}";
    public static final String IMAGE_MATCHING_USER_ACTIVE = BASE_PREFIX + "game:imagematching:user:{userId}:active";
    
    // Word Definition Matching
    public static final String WORD_DEF_SESSION = BASE_PREFIX + "game:worddef:session:{sessionId}";
    public static final String WORD_DEF_USER_ACTIVE = BASE_PREFIX + "game:worddef:user:{userId}:active";
    
    // ==================== RATE LIMITING ====================
    
    public static final String RATE_LIMIT_QUIZ = BASE_PREFIX + "ratelimit:game:quickquiz:{userId}";
    public static final String RATE_LIMIT_IMAGE_MATCHING = BASE_PREFIX + "ratelimit:game:imagematching:{userId}";
    public static final String RATE_LIMIT_WORD_DEF = BASE_PREFIX + "ratelimit:game:worddef:{userId}";
    public static final String RATE_LIMIT_API = BASE_PREFIX + "ratelimit:api:{endpoint}:{userId}";
    public static final String RATE_LIMIT_EMAIL = BASE_PREFIX + "ratelimit:email:{email}";
    public static final String RATE_LIMIT_GLOBAL = BASE_PREFIX + "ratelimit:global:{userId}";
    
    // ==================== LEADERBOARDS ====================
    
    // Global Leaderboards
    public static final String LEADERBOARD_QUIZ_GLOBAL = BASE_PREFIX + "leaderboard:quickquiz:global";
    public static final String LEADERBOARD_IMAGE_GLOBAL = BASE_PREFIX + "leaderboard:imagematching:global";
    public static final String LEADERBOARD_WORDDEF_GLOBAL = BASE_PREFIX + "leaderboard:worddef:global";
    
    // Daily Leaderboards
    public static final String LEADERBOARD_QUIZ_DAILY = BASE_PREFIX + "leaderboard:quickquiz:daily:{date}";
    public static final String LEADERBOARD_IMAGE_DAILY = BASE_PREFIX + "leaderboard:imagematching:daily:{date}";
    public static final String LEADERBOARD_WORDDEF_DAILY = BASE_PREFIX + "leaderboard:worddef:daily:{date}";
    
    // Weekly Leaderboards
    public static final String LEADERBOARD_QUIZ_WEEKLY = BASE_PREFIX + "leaderboard:quickquiz:weekly:{week}";
    
    // Streak Leaderboard
    public static final String LEADERBOARD_STREAK_GLOBAL = BASE_PREFIX + "leaderboard:streak:global";
    public static final String LEADERBOARD_STREAK_BEST = BASE_PREFIX + "leaderboard:streak:best";
    
    // Game-specific Leaderboards
    public static final String LEADERBOARD_IMAGE_MATCHING_GLOBAL = BASE_PREFIX + "leaderboard:imagematching:global";
    public static final String LEADERBOARD_WORD_DEF_GLOBAL = BASE_PREFIX + "leaderboard:worddef:global";
    public static final String LEADERBOARD_VOCAB_MASTERY = BASE_PREFIX + "leaderboard:vocab:mastery";
    
    // User Rank Cache
    public static final String USER_RANK = BASE_PREFIX + "leaderboard:user:{userId}:rank:{gameName}";
    
    // ==================== VOCABULARY ====================
    
    public static final String VOCAB_DETAIL = BASE_PREFIX + "vocab:{vocabId}";
    public static final String VOCAB_BY_TOPIC = BASE_PREFIX + "vocab:topic:{topicId}";
    public static final String VOCAB_BY_CEFR = BASE_PREFIX + "vocab:cefr:{cefr}";
    public static final String VOCAB_RANDOM = BASE_PREFIX + "vocab:random:{cefr}:{count}:{seed}";
    public static final String VOCAB_POPULAR_DAILY = BASE_PREFIX + "vocab:popular:daily";
    public static final String VOCAB_LIST_ALL = BASE_PREFIX + "vocab:all";
    
    // Topics and Types
    public static final String TOPIC_DETAIL = BASE_PREFIX + "topic:{topicId}";
    public static final String TOPIC_LIST = BASE_PREFIX + "topics:all";
    public static final String TYPE_DETAIL = BASE_PREFIX + "type:{typeId}";
    public static final String TYPE_LIST = BASE_PREFIX + "types:all";
    
    // Vocabulary Stats
    public static final String VOCAB_STATS_TOTAL = BASE_PREFIX + "vocab:stats:total";
    public static final String VOCAB_STATS_BY_TOPIC = BASE_PREFIX + "vocab:stats:topic:{topicId}";
    
    // ==================== USER STATS ====================
    
    public static final String USER_STATS = BASE_PREFIX + "user:{userId}:stats";
    public static final String USER_STREAK = BASE_PREFIX + "user:{userId}:streak";
    public static final String USER_VOCAB_SUMMARY = BASE_PREFIX + "user:{userId}:vocab:summary";
    public static final String USER_GAME_HISTORY = BASE_PREFIX + "user:{userId}:games:history";
    public static final String USER_ACTIVE_SESSIONS = BASE_PREFIX + "user:{userId}:sessions:active";
    
    // User Game Stats
    public static final String USER_QUIZ_STATS = BASE_PREFIX + "user:{userId}:stats:quickquiz";
    public static final String USER_IMAGE_MATCHING_STATS = BASE_PREFIX + "user:{userId}:stats:imagematching";
    public static final String USER_WORD_DEF_STATS = BASE_PREFIX + "user:{userId}:stats:worddef";
    
    // User Progress
    public static final String USER_VOCAB_PROGRESS = BASE_PREFIX + "user:{userId}:vocab:progress";
    public static final String USER_LEARNED_COUNT = BASE_PREFIX + "user:{userId}:vocab:learned:count";
    public static final String USER_LAST_LEARNING = BASE_PREFIX + "user:{userId}:last:learning";
    public static final String USER_ACHIEVEMENTS = BASE_PREFIX + "user:{userId}:achievements";
    
    // Daily Stats
    public static final String USER_DAILY_GAMES = BASE_PREFIX + "user:{userId}:daily:{date}:games";
    public static final String USER_DAILY_XP = BASE_PREFIX + "user:{userId}:daily:{date}:xp";
    
    // ==================== AUTHENTICATION ====================
    
    public static final String JWT_BLACKLIST = BASE_PREFIX + "auth:jwt:blacklist:{token}";
    public static final String REFRESH_TOKEN = BASE_PREFIX + "auth:refresh:{userId}";
    public static final String LOGIN_ATTEMPTS = BASE_PREFIX + "auth:attempts:{email}";
    public static final String USER_SESSION = BASE_PREFIX + "auth:session:{userId}:{sessionId}";
    public static final String USER_ACTIVE = BASE_PREFIX + "auth:active:{userId}";
    public static final String PASSWORD_RESET_TOKEN = BASE_PREFIX + "auth:reset:{email}";
    public static final String EMAIL_VERIFICATION_TOKEN = BASE_PREFIX + "auth:verify:{email}";
    public static final String TWO_FA_CODE = BASE_PREFIX + "auth:2fa:{userId}";
    
    // Legacy auth keys (keep for backward compatibility)
    public static final String AUTH_BLACKLIST = BASE_PREFIX + "auth:blacklist:{tokenId}";
    public static final String AUTH_REFRESH_TOKEN = BASE_PREFIX + "auth:refresh:{userId}:{tokenId}";
    public static final String AUTH_USER_SESSIONS = BASE_PREFIX + "auth:user:{userId}:sessions";
    public static final String AUTH_LOGIN_ATTEMPTS = BASE_PREFIX + "auth:attempts:{email}";
    public static final String AUTH_PASSWORD_RESET = BASE_PREFIX + "auth:reset:{token}";
    public static final String AUTH_EMAIL_VERIFICATION = BASE_PREFIX + "auth:verify:{token}";
    
    // ==================== RATE LIMITING (Additional) ====================
    
    public static final String RATE_LIMIT_SEARCH = BASE_PREFIX + "ratelimit:search:{userId}";
    public static final String RATE_LIMIT_EXPORT = BASE_PREFIX + "ratelimit:export:{userId}";
    public static final String RATE_LIMIT_CUSTOM = BASE_PREFIX + "ratelimit:custom:{identifier}:{action}";
    
    // ==================== CACHE QUERIES ====================
    
    public static final String CACHE_TOPICS_ALL = BASE_PREFIX + "cache:topics:all";
    public static final String CACHE_TYPES_ALL = BASE_PREFIX + "cache:types:all";
    public static final String CACHE_GAMES_ALL = BASE_PREFIX + "cache:games:all";
    public static final String CACHE_USER_PROFILE = BASE_PREFIX + "cache:user:{userId}:profile";
    public static final String CACHE_REVIEW_VOCABS = BASE_PREFIX + "cache:user:{userId}:review:pending";
    
    // ==================== STATISTICS ====================
    
    public static final String STATS_ONLINE_USERS = BASE_PREFIX + "stats:online:users";
    public static final String STATS_ACTIVE_GAMES = BASE_PREFIX + "stats:active:games:{gameName}";
    public static final String STATS_TODAY = BASE_PREFIX + "stats:today:{date}";
    public static final String STATS_DAILY_ACTIVE_USERS = BASE_PREFIX + "users:active:daily:{date}";
    
    // ==================== HELPER METHODS ====================
    
    public static String buildKey(String template, Object... params) {
        String key = template;
        for (Object param : params) {
            key = key.replaceFirst("\\{[^}]+\\}", String.valueOf(param));
        }
        return key;
    }
    
    // Examples:
    // buildKey(QUIZ_SESSION_QUESTIONS, sessionId)
    // buildKey(USER_STATS, userId)
    // buildKey(LEADERBOARD_QUIZ_DAILY, "2025-11-04")
}
