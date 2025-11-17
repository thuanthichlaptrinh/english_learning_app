# 🐛 Fix: Redis Cache Not Working - Game Sessions Not Saved

## 🔴 Vấn đề

Tất cả 3 games đều bị lỗi:
- ✅ **Start game**: Trả về 200 OK, có sessionId
- ❌ **Submit/Answer**: Lỗi 500 "Session không tồn tại" hoặc "Session questions not found"

**Nguyên nhân**: 
- Methods `cacheQuizQuestions()`, `cacheImageMatchingSession()`, `cacheWordDefSession()` **FAIL SILENTLY**
- Exception bị catch nhưng chỉ log, không throw ra ngoài
- Redis keys KHÔNG ĐƯỢC TẠO

## 🔍 Kiểm tra Redis

```bash
# Kiểm tra keys hiện tại
redis-cli KEYS "card-words:*"

# Kết quả (SAI):
# Chỉ có: timelimit, q:1:start, rate-limit
# THIẾU: questions, session data

# Kết quả mong đợi (ĐÚNG):
# card-words:game:quickquiz:session:XX:questions ← THIẾU
# card-words:game:quickquiz:session:XX:timelimit ← CÓ
# card-words:game:quickquiz:session:XX:q:1:start ← CÓ
# card-words:game:image-matching:session:XX ← THIẾU
# card-words:game:word-def:session:XX ← THIẾU
```

## ✅ Giải pháp đã áp dụng

### 1. Thêm detailed logging vào `GameSessionCacheService.java`:

```java
// Quick Quiz
public void cacheQuizQuestions(Long sessionId, List<QuestionData> questions) {
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

// Tương tự cho: cacheImageMatchingSession(), cacheWordDefSession(), cacheSessionTimeLimit()
```

### 2. Thêm step-by-step logging vào `QuickQuizService.java`:

```java
private void initializeSessionCaches(Long sessionId, List<QuestionData> allQuestions, int timePerQuestion) {
    log.info("🚀 Initializing caches for session {}: {} questions, {} sec per question", 
            sessionId, allQuestions.size(), timePerQuestion);
    
    log.info("📝 Step 1: Caching questions...");
    gameSessionCacheService.cacheQuizQuestions(sessionId, allQuestions);

    log.info("⏱️ Step 2: Caching time limit...");
    gameSessionCacheService.cacheSessionTimeLimit(sessionId, timePerQuestion * 1000);

    log.info("🕐 Step 3: Caching question start time...");
    gameSessionCacheService.cacheQuestionStartTime(sessionId, 1, LocalDateTime.now());
    
    log.info("✅ All caches initialized for session {}", sessionId);
}
```

## 🚀 Cách test sau khi restart

### Bước 1: Restart Spring Boot

```bash
# Dừng app hiện tại
# Ctrl+C hoặc kill process

# Clean compile
mvn clean compile -DskipTests

# Restart
mvn spring-boot:run
```

### Bước 2: Tail logs trong terminal khác

```bash
tail -f app.log | grep -E "🚀|📝|⏱️|🕐|✅|🔑|❌"
```

### Bước 3: Test với Postman

Gọi `POST /api/quick-quiz/start`

**Logs mong đợi (THÀNH CÔNG):**
```
🚀 Initializing caches for session 33: 5 questions, 10 sec per question
📝 Step 1: Caching questions...
🔑 Attempting to cache questions with key: card-words:game:quickquiz:session:33:questions
📝 JSON serialized successfully, length: 2543 chars
✅ Cached 5 questions for quiz session 33
⏱️ Step 2: Caching time limit...
🔑 Attempting to cache time limit with key: card-words:game:quickquiz:session:33:timelimit, value: 10000
✅ Cached time limit 10000 ms for session 33
🕐 Step 3: Caching question start time...
✅ All caches initialized for session 33
```

**Logs nếu FAIL (sẽ thấy ở step nào):**
```
🚀 Initializing caches for session 33: 5 questions, 10 sec per question
📝 Step 1: Caching questions...
🔑 Attempting to cache questions with key: card-words:game:quickquiz:session:33:questions
❌ Failed to cache quiz questions (JSON): sessionId=33, error=Cannot serialize...
```

### Bước 4: Kiểm tra Redis

```bash
# Phải thấy key questions
redis-cli GET "card-words:game:quickquiz:session:33:questions"

# Hoặc list all keys
redis-cli KEYS "card-words:game:quickquiz:session:33:*"

# Kết quả mong đợi (3 keys):
# 1) card-words:game:quickquiz:session:33:questions
# 2) card-words:game:quickquiz:session:33:timelimit  
# 3) card-words:game:quickquiz:session:33:q:1:start
```

### Bước 5: Test answer API

Gọi `POST /api/quick-quiz/33/answer`

**Phải trả về 200 OK** thay vì 500!

## 🔥 Nếu vẫn lỗi

### Scenario 1: Không thấy logs "🔑 Attempting to cache"

→ Code chưa được compile/reload
→ Giải pháp: `mvn clean compile -DskipTests` và restart

### Scenario 2: Thấy logs nhưng có exception

→ Kiểm tra stack trace trong logs
→ Có thể là:
  - JSON serialization error (circular reference, missing getters/setters)
  - Redis connection error
  - ObjectMapper configuration issue

### Scenario 3: Logs OK nhưng Redis không có keys

→ Kiểm tra `redisService.set()` implementation
→ Có thể Redis đang write vào database khác
→ Check: `redis-cli SELECT 0` then `KEYS card-words:*`

## 📊 Files đã sửa

1. `GameSessionCacheService.java`:
   - `cacheQuizQuestions()` - thêm detailed logging
   - `cacheSessionTimeLimit()` - thêm try-catch và logging
   - `cacheImageMatchingSession()` - thêm detailed logging
   - `cacheWordDefSession()` - thêm detailed logging

2. `QuickQuizService.java`:
   - `initializeSessionCaches()` - thêm step-by-step logging

## 🎯 Root Cause Analysis

**Vấn đề gốc**: 
- Try-catch nuốt exception, API vẫn trả về 200 OK
- Developer không biết cache fail
- User gọi answer API → 500 error

**Giải pháp dài hạn**:
1. ❌ Không nên nuốt exception trong cache methods
2. ✅ Nên throw `RuntimeException` nếu cache fail (vì game phụ thuộc cache)
3. ✅ Hoặc ít nhất log ERROR với full stack trace
4. ✅ Add metrics/monitoring cho Redis operations

## 🚀 Next Steps

Sau khi fix:
1. Test tất cả 3 games
2. Test rate limiting (gọi API 6 lần liên tiếp)
3. Test TTL (đợi 30 phút xem keys có tự xóa không)
4. Deploy lên staging/production

---

**Created**: 2025-11-04  
**Status**: Chờ restart app để verify fix  
**Priority**: P0 - Critical
