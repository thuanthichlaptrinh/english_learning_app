# Redis Services - Quick Start Guide 🚀

## 📋 Table of Contents
1. [Setup Redis](#setup-redis)
2. [Service Overview](#service-overview)
3. [Usage Examples](#usage-examples)
4. [Best Practices](#best-practices)
5. [Troubleshooting](#troubleshooting)

---

## 🔧 Setup Redis

### Option 1: Docker (Recommended)
```bash
# Start Redis container
docker run -d \
  --name redis-cardwords \
  -p 6379:6379 \
  -e REDIS_PASSWORD=yourpassword \
  redis:7-alpine redis-server --requirepass yourpassword

# Check status
docker ps | grep redis
```

### Option 2: Local Installation
```bash
# Windows (via Chocolatey)
choco install redis-64

# macOS (via Homebrew)
brew install redis
brew services start redis

# Linux (Ubuntu/Debian)
sudo apt-get install redis-server
sudo systemctl start redis
```

### Verify Connection
```bash
redis-cli ping
# Response: PONG
```

---

## 📦 Service Overview

### 1. BaseRedisService
**Purpose**: Low-level Redis operations wrapper  
**When to use**: Directly trong services khác, không inject trực tiếp vào controllers

### 2. GameSessionCacheService
**Purpose**: Cache game sessions (Quick Quiz, Image Matching, Word Definition)  
**When to use**: Game controllers và services

### 3. LeaderboardCacheService
**Purpose**: Real-time leaderboards với Redis Sorted Sets  
**When to use**: Leaderboard controllers, Game completion handlers

### 4. VocabularyCacheService
**Purpose**: Cache vocabulary, topics, types  
**When to use**: Vocabulary controllers, Game question generators

### 5. UserStatsCacheService
**Purpose**: User statistics và progress tracking  
**When to use**: Profile controllers, Stats dashboard

### 6. AuthenticationCacheService
**Purpose**: JWT blacklist, refresh tokens, login security  
**When to use**: Authentication filters, Auth controllers

### 7. RateLimitingService
**Purpose**: Rate limiting cho API endpoints  
**When to use**: Request interceptors, Controller methods

---

## 💡 Usage Examples

### Example 1: Cache Game Session (QuickQuizService)

**Before (ConcurrentHashMap):**
```java
private final Map<Long, List<QuestionData>> sessionQuestionsCache = new ConcurrentHashMap<>();

public void startGame(Long sessionId) {
    List<QuestionData> questions = generateQuestions();
    sessionQuestionsCache.put(sessionId, questions); // ❌ Lost on restart
}

public List<QuestionData> getQuestions(Long sessionId) {
    return sessionQuestionsCache.get(sessionId);
}
```

**After (Redis):**
```java
@Autowired
private GameSessionCacheService gameSessionCache;

public void startGame(Long sessionId) {
    List<QuestionData> questions = generateQuestions();
    gameSessionCache.cacheQuizQuestions(sessionId, questions); // ✅ Persistent, distributed
}

public List<QuestionData> getQuestions(Long sessionId) {
    // Try Redis first
    List<QuestionData> cached = gameSessionCache.getQuizQuestions(sessionId);
    if (cached != null) {
        return cached;
    }
    
    // Fallback to DB
    List<QuestionData> questions = loadFromDatabase(sessionId);
    gameSessionCache.cacheQuizQuestions(sessionId, questions);
    return questions;
}
```

---

### Example 2: Rate Limiting (API Controller)

```java
@RestController
@RequestMapping("/api/v1/games")
public class QuickQuizController {
    
    @Autowired
    private RateLimitingService rateLimitService;
    
    @PostMapping("/quick-quiz/start")
    public ResponseEntity<StartGameResponse> startGame(@AuthenticationPrincipal User user) {
        // Check rate limit
        RateLimitResult rateLimit = rateLimitService.checkGameRateLimit(
            user.getId(), 
            "quickquiz", 
            10,  // max 10 games
            Duration.ofMinutes(5)  // per 5 minutes
        );
        
        if (!rateLimit.isAllowed()) {
            return ResponseEntity.status(429)
                .header("X-RateLimit-Limit", String.valueOf(rateLimit.getLimit()))
                .header("X-RateLimit-Remaining", "0")
                .header("X-RateLimit-Reset", String.valueOf(rateLimit.getResetInSeconds()))
                .body(new ErrorResponse(
                    "Too many games started. Try again in " + 
                    rateLimit.getResetInSeconds() + " seconds"
                ));
        }
        
        // Start game...
        return ResponseEntity.ok(response);
    }
}
```

---

### Example 3: Leaderboard Updates (Game Service)

```java
@Service
public class QuickQuizService {
    
    @Autowired
    private LeaderboardCacheService leaderboardCache;
    
    @Transactional
    public void completeGame(Long sessionId, UUID userId, int score) {
        // Save to database
        Game game = gameRepository.findById(sessionId)
            .orElseThrow(() -> new GameNotFoundException(sessionId));
        game.setScore(score);
        game.setStatus(GameStatus.COMPLETED);
        gameRepository.save(game);
        
        // Update leaderboards in Redis
        leaderboardCache.updateQuizGlobalScore(userId, score);
        leaderboardCache.updateQuizDailyScore(userId, score);
        leaderboardCache.updateQuizWeeklyScore(userId, score);
        
        log.info("✅ Updated leaderboards for user {} with score {}", userId, score);
    }
}
```

---

### Example 4: JWT Blacklist (Logout)

```java
@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {
    
    @Autowired
    private AuthenticationCacheService authCache;
    
    @Autowired
    private JwtUtil jwtUtil;
    
    @PostMapping("/logout")
    public ResponseEntity<Void> logout(@RequestHeader("Authorization") String authHeader) {
        String token = authHeader.substring(7); // Remove "Bearer "
        
        // Extract user ID
        UUID userId = jwtUtil.getUserIdFromToken(token);
        
        // Blacklist JWT token
        long expirationSeconds = jwtUtil.getExpirationSeconds(token);
        authCache.blacklistToken(token, expirationSeconds);
        
        // Delete refresh token
        authCache.deleteRefreshToken(userId);
        
        log.info("✅ User {} logged out successfully", userId);
        return ResponseEntity.noContent().build();
    }
}
```

**JWT Filter Integration:**
```java
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    
    @Autowired
    private AuthenticationCacheService authCache;
    
    @Override
    protected void doFilterInternal(HttpServletRequest request, 
                                    HttpServletResponse response, 
                                    FilterChain chain) throws ServletException, IOException {
        String token = extractToken(request);
        
        if (token != null) {
            // Check blacklist
            if (authCache.isTokenBlacklisted(token)) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"Token has been revoked\"}");
                return;
            }
            
            // Continue with JWT validation...
        }
        
        chain.doFilter(request, response);
    }
}
```

---

### Example 5: Vocabulary Caching (VocabularyService)

```java
@Service
public class VocabularyService {
    
    @Autowired
    private VocabularyCacheService vocabCache;
    
    @Autowired
    private VocabRepository vocabRepository;
    
    public List<VocabularyDto> getVocabsByTopic(Long topicId) {
        // Try cache first
        List<VocabularyDto> cached = vocabCache.getVocabsByTopic(
            topicId, 
            new TypeReference<List<VocabularyDto>>() {}
        );
        
        if (cached != null) {
            log.info("✅ Cache HIT: vocabs by topic {}", topicId);
            return cached;
        }
        
        // Cache MISS: load from database
        log.info("⚠️ Cache MISS: loading vocabs by topic {} from DB", topicId);
        List<Vocabulary> entities = vocabRepository.findByTopicId(topicId);
        List<VocabularyDto> dtos = entities.stream()
            .map(this::toDto)
            .collect(Collectors.toList());
        
        // Cache for next time
        vocabCache.cacheVocabsByTopic(topicId, dtos);
        
        return dtos;
    }
    
    @Transactional
    public VocabularyDto updateVocabulary(Long vocabId, VocabularyDto dto) {
        // Update in database
        Vocabulary entity = vocabRepository.findById(vocabId)
            .orElseThrow(() -> new VocabularyNotFoundException(vocabId));
        entity.setWord(dto.getWord());
        entity.setDefinition(dto.getDefinition());
        vocabRepository.save(entity);
        
        // Invalidate cache
        vocabCache.invalidateVocabDetail(vocabId);
        if (entity.getTopicId() != null) {
            vocabCache.invalidateTopicVocabCaches(entity.getTopicId());
        }
        
        log.info("✅ Updated vocabulary {} and invalidated cache", vocabId);
        return toDto(entity);
    }
}
```

---

### Example 6: User Stats Dashboard (ProfileService)

```java
@Service
public class ProfileService {
    
    @Autowired
    private UserStatsCacheService statsCache;
    
    public UserStatsDto getUserStats(UUID userId) {
        // Try cache first
        UserStatsDto cached = statsCache.getUserStats(userId, UserStatsDto.class);
        if (cached != null) {
            return cached;
        }
        
        // Build stats from database
        UserStatsDto stats = UserStatsDto.builder()
            .userId(userId)
            .totalGames(gameRepository.countByUserId(userId))
            .totalScore(gameRepository.sumScoreByUserId(userId))
            .learnedVocabs(userVocabRepository.countLearnedByUserId(userId))
            .currentStreak(streakRepository.getCurrentStreak(userId))
            .build();
        
        // Cache for 10 minutes
        statsCache.cacheUserStats(userId, stats);
        
        return stats;
    }
}
```

---

## 🎯 Best Practices

### 1. Cache-Aside Pattern (Recommended)
```java
// ✅ GOOD: Try cache first, fallback to DB
public Data getData(Long id) {
    Data cached = cache.get(id);
    if (cached != null) return cached;
    
    Data fromDb = repository.findById(id);
    cache.set(id, fromDb);
    return fromDb;
}
```

### 2. Write-Through Pattern
```java
// ✅ GOOD: Update DB and cache together
@Transactional
public void updateData(Long id, Data data) {
    repository.save(data);
    cache.set(id, data);  // Immediately update cache
}
```

### 3. Cache Invalidation
```java
// ✅ GOOD: Invalidate cache after update/delete
@Transactional
public void deleteData(Long id) {
    repository.deleteById(id);
    cache.delete(id);  // Remove from cache
}
```

### 4. TTL Strategy
```java
// ✅ GOOD: Set appropriate TTL based on data volatility
cache.set(key, value, Duration.ofHours(24));  // Stable data: 24h
cache.set(key, value, Duration.ofMinutes(10));  // Volatile data: 10min
cache.set(key, value, Duration.ofMinutes(5));  // Real-time data: 5min
```

### 5. Error Handling
```java
// ✅ GOOD: Graceful fallback if Redis is down
public Data getData(Long id) {
    try {
        Data cached = cache.get(id);
        if (cached != null) return cached;
    } catch (Exception e) {
        log.warn("Redis error, falling back to DB: {}", e.getMessage());
    }
    
    return repository.findById(id);  // Always have DB fallback
}
```

---

## 🚨 Troubleshooting

### Issue 1: Redis Connection Failed
**Error**: `Unable to connect to Redis at localhost:6379`

**Solution**:
```bash
# Check if Redis is running
redis-cli ping

# Check Docker container
docker ps | grep redis

# Check logs
docker logs redis-cardwords

# Restart Redis
docker restart redis-cardwords
```

### Issue 2: Serialization Error
**Error**: `Cannot serialize/deserialize object`

**Solution**: Ensure your DTOs are serializable:
```java
@Data
@NoArgsConstructor
@AllArgsConstructor
public class MyDto implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Long id;
    private String name;
    // ... fields
}
```

### Issue 3: Memory Issues
**Error**: Redis memory usage too high

**Solution**:
```bash
# Check memory usage
redis-cli info memory

# Clear all cache (CAUTION!)
redis-cli FLUSHDB

# Set max memory policy
redis-cli CONFIG SET maxmemory-policy allkeys-lru
```

### Issue 4: TTL Not Working
**Error**: Keys not expiring automatically

**Check**:
```bash
# Check TTL of a key
redis-cli TTL card-words:game:quickquiz:session:123:questions

# -2: key doesn't exist
# -1: key has no expiry
# positive number: seconds until expiry
```

---

## 📊 Monitoring

### Redis CLI Commands
```bash
# Connect to Redis
redis-cli -h localhost -p 6379 -a yourpassword

# Check all keys
KEYS card-words:*

# Get key value
GET card-words:user:123:stats

# Check key TTL
TTL card-words:game:quickquiz:session:456:questions

# Monitor all commands
MONITOR

# Get server info
INFO
INFO memory
INFO stats

# Clear database (CAUTION!)
FLUSHDB
```

### Application Logs
```java
// All Redis services log operations:
log.debug("✅ Redis SET: key={}", key);  // Success
log.warn("⚠️ Cache miss: user stats for {}", userId);  // Cache miss
log.error("❌ Redis GET failed: key={}, error={}", key, e.getMessage());  // Error
```

---

## 🔗 Related Files

- `RedisConfig.java` - Configuration
- `RedisKeyConstants.java` - Key naming constants
- `REDIS_IMPLEMENTATION_PLAN.md` - Complete 6-phase plan
- `REDIS_PHASE_1_COMPLETE.md` - Phase 1 summary

---

## 📞 Support

If you encounter issues:
1. Check Redis connection: `redis-cli ping`
2. Check application logs for error messages
3. Verify key naming với `redis-cli KEYS card-words:*`
4. Check TTL với `redis-cli TTL <key>`
5. Monitor commands với `redis-cli MONITOR`

---

**Next Steps**: Refactor existing services to use Redis cache (Phase 2)
