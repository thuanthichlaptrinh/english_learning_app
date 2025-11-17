package com.thuanthichlaptrinh.card_words.common.constants;

public class RedisKeyConstants {

    // Prefix
    public static final String PREFIX = "card-words";

    // ==================== USER KEYS ====================
    public static final String USER_PROFILE = PREFIX + ":user:profile"; // Hash
    public static final String USER_EMAIL_LOOKUP = PREFIX + ":user:email"; // String
    public static final String USER_STATS = PREFIX + ":user:stats"; // Hash
    public static final String USER_ACTIVE = PREFIX + ":user:active"; // String (TTL marker)
    public static final String USERS_ONLINE = PREFIX + ":users:online"; // Set

    // ==================== VOCAB KEYS ====================
    public static final String VOCAB_DETAIL = PREFIX + ":vocab:detail"; // String (JSON)
    public static final String VOCAB_BY_TOPIC = PREFIX + ":vocab:topic"; // String (JSON list)
    public static final String VOCAB_BY_CEFR = PREFIX + ":vocab:cefr"; // String (JSON list)
    public static final String VOCAB_RANDOM = PREFIX + ":vocab:random"; // String (JSON list)

    // Topic & Type
    public static final String TOPIC_DETAIL = PREFIX + ":topic:detail";
    public static final String TOPIC_LIST = PREFIX + ":topic:list";
    public static final String TYPE_DETAIL = PREFIX + ":type:detail";
    public static final String TYPE_LIST = PREFIX + ":type:list";

    // Vocab Stats
    public static final String VOCAB_STATS_TOTAL = PREFIX + ":vocab:stats:total";
    public static final String VOCAB_STATS_BY_TOPIC = PREFIX + ":vocab:stats:topic";

    // ==================== GAME KEYS ====================
    public static final String GAME_SESSION = PREFIX + ":game:session"; // Hash
    public static final String GAME_LEADERBOARD = PREFIX + ":game:leaderboard"; // Sorted Set

    // Quick Quiz
    public static final String QUIZ_SESSION_QUESTIONS = PREFIX + ":game:quickquiz:session:questions";
    public static final String QUIZ_SESSION_QUESTION_START = PREFIX + ":game:quickquiz:session:q";
    public static final String QUIZ_SESSION_TIMELIMIT = PREFIX + ":game:quickquiz:session:timelimit";
    public static final String QUIZ_SESSION_META = PREFIX + ":game:quickquiz:session:meta";

    // Image Word Matching
    public static final String IMAGE_MATCHING_SESSION = PREFIX + ":game:imagematching:session";
    public static final String IMAGE_MATCHING_USER_ACTIVE = PREFIX + ":game:imagematching:user";

    // Word Definition Matching
    public static final String WORD_DEF_SESSION = PREFIX + ":game:worddef:session";
    public static final String WORD_DEF_USER_ACTIVE = PREFIX + ":game:worddef:user";

    // ==================== RATE LIMITING ====================
    public static final String RATE_LIMIT_QUIZ = PREFIX + ":ratelimit:game:quickquiz";
    public static final String RATE_LIMIT_IMAGE_MATCHING = PREFIX + ":ratelimit:game:imagematching";
    public static final String RATE_LIMIT_WORD_DEF = PREFIX + ":ratelimit:game:worddef";
    public static final String RATE_LIMIT_API = PREFIX + ":ratelimit:api";
    public static final String RATE_LIMIT_EMAIL = PREFIX + ":ratelimit:email";
    public static final String RATE_LIMIT_GLOBAL = PREFIX + ":ratelimit:global";

    // ==================== LEADERBOARDS ====================
    public static final String LEADERBOARD_QUIZ_GLOBAL = PREFIX + ":leaderboard:quickquiz:global";
    public static final String LEADERBOARD_IMAGE_GLOBAL = PREFIX + ":leaderboard:imagematching:global";
    public static final String LEADERBOARD_WORDDEF_GLOBAL = PREFIX + ":leaderboard:worddef:global";
    public static final String LEADERBOARD_QUIZ_DAILY = PREFIX + ":leaderboard:quickquiz:daily";
    public static final String LEADERBOARD_IMAGE_DAILY = PREFIX + ":leaderboard:imagematching:daily";
    public static final String LEADERBOARD_WORDDEF_DAILY = PREFIX + ":leaderboard:worddef:daily";
    public static final String LEADERBOARD_QUIZ_WEEKLY = PREFIX + ":leaderboard:quickquiz:weekly";
    public static final String LEADERBOARD_IMAGE_WEEKLY = PREFIX + ":leaderboard:imagematching:weekly";
    public static final String LEADERBOARD_WORDDEF_WEEKLY = PREFIX + ":leaderboard:worddef:weekly";
    public static final String LEADERBOARD_QUIZ_MONTHLY = PREFIX + ":leaderboard:quickquiz:monthly";
    public static final String LEADERBOARD_IMAGE_MONTHLY = PREFIX + ":leaderboard:imagematching:monthly";
    public static final String LEADERBOARD_WORDDEF_MONTHLY = PREFIX + ":leaderboard:worddef:monthly";

    // Additional Leaderboards
    public static final String LEADERBOARD_STREAK_GLOBAL = PREFIX + ":leaderboard:streak:global";
    public static final String LEADERBOARD_STREAK_BEST = PREFIX + ":leaderboard:streak:best";
    public static final String LEADERBOARD_IMAGE_MATCHING_GLOBAL = PREFIX + ":leaderboard:imagematching:global";
    public static final String LEADERBOARD_WORD_DEF_GLOBAL = PREFIX + ":leaderboard:worddef:global";
    public static final String LEADERBOARD_VOCAB_MASTERY = PREFIX + ":leaderboard:vocab:mastery";

    // ==================== USER STATS ====================
    public static final String USER_QUIZ_STATS = PREFIX + ":user:stats:quiz";
    public static final String USER_IMAGE_MATCHING_STATS = PREFIX + ":user:stats:imagematching";
    public static final String USER_WORD_DEF_STATS = PREFIX + ":user:stats:worddef";
    public static final String USER_VOCAB_PROGRESS = PREFIX + ":user:vocab:progress";
    public static final String USER_LEARNED_COUNT = PREFIX + ":user:learned:count";
    public static final String USER_STREAK = PREFIX + ":user:streak";
    public static final String USER_LAST_LEARNING = PREFIX + ":user:lastlearning";
    public static final String USER_ACHIEVEMENTS = PREFIX + ":user:achievements";
    public static final String USER_DAILY_GAMES = PREFIX + ":user:daily:games";
    public static final String USER_DAILY_XP = PREFIX + ":user:daily:xp";

    // ==================== ADDITIONAL RATE LIMITING ====================
    public static final String RATE_LIMIT_SEARCH = PREFIX + ":ratelimit:search";
    public static final String RATE_LIMIT_EXPORT = PREFIX + ":ratelimit:export";
    public static final String RATE_LIMIT_CUSTOM = PREFIX + ":ratelimit:custom";

    // ==================== AUTH KEYS ====================
    public static final String TOKEN_BLACKLIST = PREFIX + ":auth:blacklist";
    public static final String REFRESH_TOKEN = PREFIX + ":auth:refresh";
    public static final String USER_SESSION = PREFIX + ":auth:session";
    public static final String PASSWORD_RESET_TOKEN = PREFIX + ":auth:passwordreset";
    public static final String EMAIL_VERIFICATION_TOKEN = PREFIX + ":auth:emailverify";
    public static final String TWO_FA_CODE = PREFIX + ":auth:2fa";
    public static final String JWT_BLACKLIST = PREFIX + ":auth:jwt:blacklist";
    public static final String LOGIN_ATTEMPTS = PREFIX + ":auth:loginattempts";

    /**
     * Build Redis key with variable parts
     * Example: buildKey("user:profile", userId) -> "card-words:user:profile:123"
     */
    public static String buildKey(String baseKey, Object... parts) {
        StringBuilder sb = new StringBuilder(baseKey);
        for (Object part : parts) {
            sb.append(":").append(part);
        }
        return sb.toString();
    }
}
