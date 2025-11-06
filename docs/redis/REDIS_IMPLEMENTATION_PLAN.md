# 🚀 Kế hoạch Áp dụng Redis cho Toàn bộ Project

## 📊 Phân tích Hiện tại

### Các vấn đề cần giải quyết:

1. ❌ **In-memory caching** (ConcurrentHashMap, Caffeine) - không persist, không scale
2. ❌ **Rate limiting** - chỉ work trên 1 server instance
3. ❌ **Session management** - mất data khi restart
4. ❌ **Leaderboard queries** - slow với large dataset
5. ❌ **Vocab caching** - query DB mỗi request
6. ❌ **User statistics** - tính toán lại mỗi lần
7. ❌ **Authentication tokens** - không có token blacklist

---

## 🎯 Redis Use Cases cho Project

### 1️⃣ **GAME SESSIONS** (Priority: ⭐⭐⭐⭐⭐ CRITICAL)

#### A. Quick Quiz Service

**Hiện tại**:

```java
private final Map<Long, List<QuestionData>> sessionQuestionsCache = new ConcurrentHashMap<>();
private final Map<Long, Map<Integer, LocalDateTime>> questionStartTimes = new ConcurrentHashMap<>();
private final Map<Long, Integer> sessionTimeLimits = new ConcurrentHashMap<>();
private final Map<UUID, List<LocalDateTime>> userGameStarts = new ConcurrentHashMap<>();
```

**Redis Design**:

```redis
# Session Questions
KEY: game:quickquiz:session:{sessionId}:questions
TYPE: String (JSON)
VALUE: List<QuestionData>
TTL: 30 minutes

# Question Start Times
KEY: game:quickquiz:session:{sessionId}:q:{questionNumber}:start
TYPE: String
VALUE: timestamp (Long)
TTL: 30 minutes

# Session Time Limit
KEY: game:quickquiz:session:{sessionId}:timelimit
TYPE: String
VALUE: Integer (milliseconds)
TTL: 30 minutes

# Rate Limiting
KEY: game:quickquiz:ratelimit:{userId}
TYPE: String
VALUE: Counter
TTL: 5 minutes
COMMANDS: INCR, EXPIRE

# Active Sessions per User
KEY: game:quickquiz:user:{userId}:sessions
TYPE: Set
VALUE: sessionIds
TTL: 1 hour
```

**Benefits**:

-   ✅ Persist across restarts
-   ✅ Scale horizontally
-   ✅ Auto cleanup với TTL
-   ✅ Consistent rate limiting

---

#### B. Image Word Matching Service

**Hiện tại**:

```java
private final Cache<Long, SessionData> sessionCache = Caffeine.newBuilder()
```

**Redis Design**:

```redis
# Session Cache
KEY: game:imagematching:session:{sessionId}
TYPE: Hash
FIELDS:
  userId: UUID
  totalQuestions: Integer
  currentQuestionIndex: Integer
  correctCount: Integer
  score: Integer
  startedAt: Timestamp
  pairs: JSON
TTL: 30 minutes

# User Active Game
KEY: game:imagematching:user:{userId}:active
TYPE: String
VALUE: sessionId
TTL: 30 minutes
```

---

#### C. Word Definition Matching Service

**Hiện tại**:

```java
private final Cache<Long, SessionData> sessionCache = Caffeine.newBuilder()
```

**Redis Design**:

```redis
# Session Cache (tương tự Image Matching)
KEY: game:worddef:session:{sessionId}
TYPE: Hash
TTL: 30 minutes
```

---

### 2️⃣ **LEADERBOARD** (Priority: ⭐⭐⭐⭐⭐ CRITICAL)

**Hiện tại**: Query PostgreSQL mỗi request (SLOW)

**Redis Design**:

```redis
# Global Leaderboard
KEY: leaderboard:quickquiz:global
TYPE: Sorted Set
SCORE: user's highest score
MEMBER: userId
COMMANDS: ZADD, ZREVRANGE (top N), ZRANK (user rank)

# Daily Leaderboard
KEY: leaderboard:quickquiz:daily:{date}
TYPE: Sorted Set
TTL: 48 hours

# Weekly Leaderboard
KEY: leaderboard:quickquiz:weekly:{week}
TYPE: Sorted Set
TTL: 14 days

# Per-Game Leaderboards
KEY: leaderboard:{gameName}:global
TYPE: Sorted Set

# User's Rank Cache
KEY: leaderboard:user:{userId}:rank:{gameName}
TYPE: Hash
FIELDS:
  rank: Integer
  score: Integer
  lastUpdated: Timestamp
TTL: 5 minutes
```

**Benefits**:

-   ✅ O(log N) queries (vs O(N) in DB)
-   ✅ Real-time updates
-   ✅ Efficient top N queries
-   ✅ Fast user rank lookup

---

### 3️⃣ **VOCABULARY CACHING** (Priority: ⭐⭐⭐⭐ HIGH)

**Hiện tại**: Query DB mỗi request

**Redis Design**:

```redis
# Single Vocab
KEY: vocab:{vocabId}
TYPE: Hash
FIELDS:
  word: String
  meaningVi: String
  transcription: String
  cefr: String
  img: String
  audio: String
  exampleSentence: String
  ...
TTL: 24 hours

# Vocab by Topic
KEY: vocab:topic:{topicId}
TYPE: Set
VALUE: vocabIds
TTL: 12 hours

# Vocab by CEFR
KEY: vocab:cefr:{cefr}
TYPE: Set
VALUE: vocabIds
TTL: 12 hours

# Random Vocab Cache (for games)
KEY: vocab:random:{cefr}:{count}:{seed}
TYPE: List
VALUE: vocabIds
TTL: 5 minutes

# Popular Vocabs (most searched/learned)
KEY: vocab:popular:daily
TYPE: Sorted Set
SCORE: access count
MEMBER: vocabId
TTL: 24 hours
```

**Benefits**:

-   ✅ Reduce DB load by 80-90%
-   ✅ Sub-millisecond response time
-   ✅ Better user experience

---

### 4️⃣ **USER PROGRESS & STATISTICS** (Priority: ⭐⭐⭐⭐ HIGH)

**Hiện tại**: Tính toán từ DB mỗi request

**Redis Design**:

```redis
# User Stats Cache
KEY: user:{userId}:stats
TYPE: Hash
FIELDS:
  totalVocabsLearned: Integer
  currentStreak: Integer
  longestStreak: Integer
  totalGamesPlayed: Integer
  averageAccuracy: Double
  lastActive: Timestamp
TTL: 10 minutes

# User Streak
KEY: user:{userId}:streak
TYPE: Hash
FIELDS:
  currentStreak: Integer
  longestStreak: Integer
  lastActivityDate: Date
  isActiveToday: Boolean
TTL: 25 hours

# Streak Leaderboard
KEY: leaderboard:streak:global
TYPE: Sorted Set
SCORE: currentStreak
MEMBER: userId

# Daily Active Users
KEY: users:active:daily:{date}
TYPE: Set
VALUE: userIds
TTL: 7 days

# User Vocab Progress Summary
KEY: user:{userId}:vocab:summary
TYPE: Hash
FIELDS:
  new: Integer
  learning: Integer
  reviewing: Integer
  mastered: Integer
TTL: 5 minutes
```

---

### 5️⃣ **AUTHENTICATION & SESSION** (Priority: ⭐⭐⭐⭐ HIGH)

**Redis Design**:

```redis
# JWT Token Blacklist
KEY: auth:blacklist:{tokenId}
TYPE: String
VALUE: "revoked"
TTL: token expiration time

# Refresh Token Storage
KEY: auth:refresh:{userId}:{tokenId}
TYPE: Hash
FIELDS:
  token: String
  deviceInfo: String
  ipAddress: String
  createdAt: Timestamp
TTL: 7 days

# User Sessions (multiple devices)
KEY: auth:user:{userId}:sessions
TYPE: Set
VALUE: sessionIds
TTL: 7 days

# Login Attempts (Brute Force Protection)
KEY: auth:attempts:{email}
TYPE: String
VALUE: Counter
TTL: 15 minutes
RULE: Lock account after 5 failed attempts

# Password Reset Tokens
KEY: auth:reset:{token}
TYPE: Hash
FIELDS:
  userId: UUID
  email: String
  createdAt: Timestamp
TTL: 1 hour
```

---

### 6️⃣ **RATE LIMITING** (Priority: ⭐⭐⭐⭐⭐ CRITICAL)

**Redis Design**:

```redis
# API Rate Limiting (per endpoint)
KEY: ratelimit:api:{endpoint}:{userId}
TYPE: String
VALUE: Counter
TTL: 1 minute
LIMIT: 60 requests/minute

# Game Start Rate Limiting
KEY: ratelimit:game:{gameName}:{userId}
TYPE: String
VALUE: Counter
TTL: 5 minutes
LIMIT: 10 games/5 minutes (already exists)

# Email Send Rate Limiting
KEY: ratelimit:email:{email}
TYPE: String
VALUE: Counter
TTL: 1 hour
LIMIT: 5 emails/hour

# Global Rate Limiting
KEY: ratelimit:global:{userId}
TYPE: String
VALUE: Counter
TTL: 1 second
LIMIT: 100 requests/second
```

---

### 7️⃣ **CACHING QUERIES** (Priority: ⭐⭐⭐ MEDIUM)

**Redis Design**:

```redis
# Topics List
KEY: cache:topics:all
TYPE: List (JSON)
VALUE: List<Topic>
TTL: 1 hour

# Types List
KEY: cache:types:all
TYPE: List (JSON)
VALUE: List<Type>
TTL: 1 hour

# Games List
KEY: cache:games:all
TYPE: List (JSON)
VALUE: List<Game>
TTL: 1 hour

# User Profile
KEY: cache:user:{userId}:profile
TYPE: Hash
TTL: 10 minutes

# Review Vocabs (for spaced repetition)
KEY: cache:user:{userId}:review:pending
TYPE: Sorted Set
SCORE: nextReviewDate (timestamp)
MEMBER: vocabId
TTL: 1 hour
```

---

### 8️⃣ **REAL-TIME FEATURES** (Priority: ⭐⭐⭐ MEDIUM)

**Redis Design**:

```redis
# Online Users Count
KEY: stats:online:users
TYPE: Set
VALUE: userIds
TTL: 5 minutes (refresh on activity)

# Active Games Count
KEY: stats:active:games:{gameName}
TYPE: String
VALUE: Counter
NO TTL (persistent counter)

# Today's Statistics
KEY: stats:today:{date}
TYPE: Hash
FIELDS:
  totalGames: Integer
  totalUsers: Integer
  totalVocabsLearned: Integer
  avgSessionTime: Integer
TTL: 48 hours
```

---

### 9️⃣ **PUB/SUB** (Priority: ⭐⭐ LOW - Future Feature)

**Redis Design**:

```redis
# Real-time Leaderboard Updates
CHANNEL: leaderboard:updates
MESSAGE: {"userId": "...", "score": 100, "rank": 5}

# User Achievements
CHANNEL: user:{userId}:achievements
MESSAGE: {"achievementId": "...", "title": "..."}

# Streak Notifications
CHANNEL: streak:notifications
MESSAGE: {"userId": "...", "streak": 7, "milestone": true}
```

---

## 🏗️ Architecture Design

```
┌─────────────────────────────────────────────────────────────┐
│                        Frontend                              │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌──────────────────────────────────────────────────────────────┐
│                    Load Balancer (Nginx)                      │
└──────────────────────────────┬──────────────────────────────┘
                               │
                ┌──────────────┴──────────────┐
                ▼                             ▼
┌───────────────────────┐         ┌───────────────────────┐
│   Spring Boot App 1   │         │   Spring Boot App 2   │
│  (Multiple Instances) │         │  (Multiple Instances) │
└───────┬───────────────┘         └───────────┬───────────┘
        │                                     │
        └──────────────┬──────────────────────┘
                       │
        ┌──────────────┴──────────────┐
        ▼                             ▼
┌───────────────────┐         ┌───────────────────┐
│   Redis Cluster   │         │    PostgreSQL     │
│   (Cache, Session,│         │   (Persistent     │
│    Leaderboard)   │         │     Storage)      │
└───────────────────┘         └───────────────────┘
```

---

## 📦 Implementation Steps

### Phase 1: Setup & Configuration (Week 1)

-   [ ] Add Redis dependencies (Spring Data Redis, Lettuce)
-   [ ] Configure Redis connection (RedisConfig.java)
-   [ ] Create Redis Template beans
-   [ ] Setup Redis key naming strategy
-   [ ] Create base Redis service abstractions

### Phase 2: Game Sessions (Week 2)

-   [ ] Refactor QuickQuizService to use Redis
-   [ ] Refactor ImageWordMatchingService to use Redis
-   [ ] Refactor WordDefinitionMatchingService to use Redis
-   [ ] Add session cleanup scheduled tasks
-   [ ] Add comprehensive tests

### Phase 3: Leaderboard & Stats (Week 3)

-   [ ] Implement Redis-based leaderboard
-   [ ] Add real-time rank updates
-   [ ] Cache user statistics
-   [ ] Add streak management with Redis
-   [ ] Create leaderboard APIs

### Phase 4: Vocabulary Caching (Week 4)

-   [ ] Cache vocabulary data
-   [ ] Implement cache warming strategies
-   [ ] Add cache invalidation logic
-   [ ] Cache topics, types, games
-   [ ] Monitor cache hit rates

### Phase 5: Auth & Rate Limiting (Week 5)

-   [ ] JWT token blacklist
-   [ ] Refresh token storage
-   [ ] API rate limiting
-   [ ] Login attempt tracking
-   [ ] Email rate limiting

### Phase 6: Optimization & Monitoring (Week 6)

-   [ ] Add Redis metrics monitoring
-   [ ] Optimize cache TTL values
-   [ ] Add cache warming on startup
-   [ ] Performance testing
-   [ ] Documentation

---

## 🔧 Technical Stack

### Dependencies (pom.xml)

```xml
<!-- Redis -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>

<!-- Lettuce (Redis client) -->
<dependency>
    <groupId>io.lettuce</groupId>
    <artifactId>lettuce-core</artifactId>
</dependency>

<!-- Jackson for JSON serialization -->
<dependency>
    <groupId>com.fasterxml.jackson.datatype</groupId>
    <artifactId>jackson-datatype-jsr310</artifactId>
</dependency>

<!-- Optional: Redis Cache Metrics -->
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-registry-prometheus</artifactId>
</dependency>
```

### Configuration (application.yml)

```yaml
spring:
    data:
        redis:
            host: ${REDIS_HOST:localhost}
            port: ${REDIS_PORT:6379}
            password: ${REDIS_PASSWORD:}
            database: 0
            timeout: 2000ms
            lettuce:
                pool:
                    max-active: 20
                    max-idle: 10
                    min-idle: 5
                    max-wait: 2000ms
                shutdown-timeout: 100ms

    cache:
        type: redis
        redis:
            time-to-live: 600000 # 10 minutes default
            cache-null-values: false
            key-prefix: 'card-words:'
            use-key-prefix: true
```

---

## 📊 Expected Performance Improvements

| Metric                | Before (Without Redis)     | After (With Redis) | Improvement                |
| --------------------- | -------------------------- | ------------------ | -------------------------- |
| **Game Session Load** | 50-100ms (DB)              | 1-5ms (Redis)      | **10-50x faster**          |
| **Leaderboard Query** | 200-500ms                  | 2-10ms             | **20-100x faster**         |
| **Vocab Lookup**      | 10-30ms                    | 0.5-2ms            | **5-20x faster**           |
| **Rate Limiting**     | In-memory (not scalable)   | Redis (scalable)   | **Horizontal scaling**     |
| **Cache Hit Rate**    | N/A                        | 85-95%             | **Huge DB load reduction** |
| **Server Restarts**   | Lose all sessions          | Sessions persist   | **Better UX**              |
| **Concurrent Users**  | Limited by single instance | Scale to millions  | **Unlimited scaling**      |

---

## 💰 Cost Estimation

### Development Time: **6 weeks** (1 developer)

### AWS ElastiCache Pricing:

-   **cache.t3.micro** (0.5 GB): $0.017/hour = ~$12/month (dev/test)
-   **cache.t3.small** (1.37 GB): $0.034/hour = ~$25/month (production start)
-   **cache.m5.large** (6.38 GB): $0.147/hour = ~$107/month (production scale)

### ROI:

-   ✅ 10-100x performance improvement
-   ✅ Better user experience
-   ✅ Horizontal scalability
-   ✅ Reduced PostgreSQL load
-   ✅ Lower hosting costs (can use cheaper DB tier)

---

## 🚀 Next Steps

Bạn muốn bắt đầu với phase nào?

1. **Phase 1** (Setup) - Cài đặt dependencies và configuration
2. **Phase 2** (Game Sessions) - Refactor game services
3. **Phase 3** (Leaderboard) - Real-time leaderboards
4. **Phase 4** (Vocab Cache) - Cache vocabularies
5. **Phase 5** (Auth) - JWT blacklist & rate limiting

Hoặc tôi có thể:

-   ✅ Bắt đầu implement ngay Phase 1
-   ✅ Tạo prototype cho một use case cụ thể
-   ✅ Tạo Redis service abstractions trước

Cho tôi biết bạn muốn bắt đầu từ đâu! 🎯
