# ✅ Offline Sync - Implementation Summary

## 🎯 Yêu cầu

User chơi game offline (3 lần × 5 câu = 15 câu) → Gửi lên:

-   3 game sessions
-   15 game session details
-   Backend tự động cập nhật `user_vocab_progress`

## 🔧 Các thay đổi đã thực hiện

### 1. **BatchSyncRequest.java** - Bổ sung field `gameSessionDetails`

**Trước:**

```java
private List<OfflineGameSessionRequest> gameSessions;
private List<OfflineVocabProgressRequest> vocabProgress;
```

**Sau:**

```java
private List<OfflineGameSessionRequest> gameSessions;
private List<OfflineGameDetailRequest> gameSessionDetails;  // ⭐ NEW
private List<OfflineVocabProgressRequest> vocabProgress;
```

### 2. **OfflineGameDetailRequest.java** - Thêm `clientSessionId` để link

**Trước:**

```java
private UUID vocabId;
private Boolean isCorrect;
private Integer timeTaken;
```

**Sau:**

```java
private String clientSessionId;  // ⭐ NEW - Link to session
private UUID vocabId;
private Boolean isCorrect;
private Integer timeTaken;
```

### 3. **OfflineVocabProgressRequest.java** - Thêm metrics

**Trước:**

```java
private VocabStatus status;
private Double easeFactor;
private Integer repetitions;
```

**Sau:**

```java
private VocabStatus status;
private Double easeFactor;
private Integer repetitions;
private Integer timesCorrect;  // ⭐ NEW
private Integer timesWrong;    // ⭐ NEW
```

### 4. **OfflineSyncService.java** - Logic xử lý mới

#### 4.1. Method `syncBatch()` - Refactor hoàn toàn

```java
// Step 1: Lưu game sessions (không có details)
Map<String, GameSession> sessionMap = new HashMap<>();
for (session : request.getGameSessions()) {
    GameSession saved = saveGameSessionOnly(userId, session);
    sessionMap.put(session.getClientSessionId(), saved);
}

// Step 2: Lưu details và auto-update progress
for (detail : request.getGameSessionDetails()) {
    GameSession session = sessionMap.get(detail.getClientSessionId());
    syncGameSessionDetail(session, detail);  // ⭐ Auto-update progress
}

// Step 3: Merge với manual vocab progress
for (progress : request.getVocabProgress()) {
    syncVocabProgress(userId, progress);
}
```

#### 4.2. Method `saveGameSessionOnly()` - Tách riêng

```java
private GameSession saveGameSessionOnly(UUID userId, OfflineGameSessionRequest request) {
    // Chỉ lưu session, không xử lý details
    GameSession session = GameSession.builder()
        .user(user)
        .game(game)
        .startedAt(...)
        .totalQuestions(...)
        .build();

    return gameSessionRepository.save(session);
}
```

#### 4.3. Method `syncGameSessionDetail()` - Auto-update progress

**Trước:**

```java
private void syncGameSessionDetail(GameSession session, OfflineGameDetailRequest detail) {
    // Chỉ lưu detail
    gameSessionDetailRepository.save(detailEntity);
}
```

**Sau:**

```java
private void syncGameSessionDetail(GameSession session, OfflineGameDetailRequest detail) {
    // Lưu detail
    gameSessionDetailRepository.save(detailEntity);

    // ⭐ Auto-update user_vocab_progress
    updateUserVocabProgressFromGameResult(
        session.getUser().getId(),
        vocab,
        detail.getIsCorrect()
    );
}
```

#### 4.4. Method `updateUserVocabProgressFromGameResult()` - ⭐ MỚI

```java
private void updateUserVocabProgressFromGameResult(UUID userId, Vocab vocab, Boolean isCorrect) {
    UserVocabProgress progress = findOrCreate(userId, vocab);

    // Cập nhật times correct/wrong
    if (isCorrect) {
        progress.setTimesCorrect(progress.getTimesCorrect() + 1);
    } else {
        progress.setTimesWrong(progress.getTimesWrong() + 1);
    }

    // Áp dụng SM-2 algorithm
    applySpacedRepetition(progress, isCorrect);

    progress.setLastReviewed(LocalDate.now());
    userVocabProgressRepository.save(progress);
}
```

#### 4.5. Method `applySpacedRepetition()` - ⭐ MỚI - SM-2 Algorithm

```java
private void applySpacedRepetition(UserVocabProgress progress, Boolean isCorrect) {
    int quality = isCorrect ? 5 : 1;

    if (quality >= 3) {
        // Correct answer
        if (repetition == 0) interval = 1;
        else if (repetition == 1) interval = 6;
        else interval = previous × EF;

        repetition++;

        // Update status based on performance
        int totalAttempts = timesCorrect + timesWrong;
        double accuracy = timesCorrect × 100.0 / totalAttempts;

        if (timesCorrect >= 10 && timesWrong <= 2 && accuracy >= 80.0) {
            status = MASTERED;
        } else if (timesCorrect >= 3 && accuracy >= 60.0) {
            status = KNOWN;
        } else {
            status = UNKNOWN;
        }
    } else {
        // Incorrect - reset
        repetition = 0;
        interval = 1;
        status = UNKNOWN;
    }

    // Update Ease Factor
    newEF = EF + (0.1 - (5-quality) × (0.08 + (5-quality) × 0.02));
    if (newEF < 1.3) newEF = 1.3;

    nextReviewDate = today + interval;
}
```

#### 4.6. Method `updateProgress()` - Merge thông minh

**Trước:**

```java
private void updateProgress(...) {
    progress.setStatus(request.getStatus());
    progress.setEfFactor(request.getEaseFactor());
    // Không xử lý timesCorrect/timesWrong
}
```

**Sau:**

```java
private void updateProgress(...) {
    progress.setStatus(request.getStatus());
    progress.setEfFactor(request.getEaseFactor());

    // ⭐ Merge metrics - dùng max để tránh mất data
    if (request.getTimesCorrect() != null) {
        progress.setTimesCorrect(
            Math.max(progress.getTimesCorrect(), request.getTimesCorrect())
        );
    }
    if (request.getTimesWrong() != null) {
        progress.setTimesWrong(
            Math.max(progress.getTimesWrong(), request.getTimesWrong())
        );
    }
}
```

## 📊 Luồng dữ liệu (Data Flow)

```
Frontend Offline
┌─────────────────────────────────────────┐
│ User chơi 3 game × 5 câu                │
│                                         │
│ gameSessions:                           │
│ [                                       │
│   { clientSessionId: "s1", ... },      │
│   { clientSessionId: "s2", ... },      │
│   { clientSessionId: "s3", ... }       │
│ ]                                       │
│                                         │
│ gameSessionDetails:                     │
│ [                                       │
│   { clientSessionId: "s1", vocab, ... },│ 5 câu
│   { clientSessionId: "s1", vocab, ... },│
│   ...                                   │
│   { clientSessionId: "s2", vocab, ... },│ 5 câu
│   ...                                   │
│   { clientSessionId: "s3", vocab, ... } │ 5 câu
│ ]                                       │
└─────────────────────────────────────────┘
                    │
                    │ POST /api/v1/offline/sync/batch
                    ▼
┌─────────────────────────────────────────┐
│ Backend Processing                      │
│                                         │
│ 1. Save sessions → sessionMap           │
│    s1 → GameSession#1                   │
│    s2 → GameSession#2                   │
│    s3 → GameSession#3                   │
│                                         │
│ 2. For each detail:                     │
│    a) Save detail to DB                 │
│    b) Update user_vocab_progress:       │
│       - timesCorrect++/timesWrong++     │
│       - Apply SM-2 algorithm            │
│       - Update status/EF/interval       │
│                                         │
│ 3. Merge vocabProgress (if any)         │
└─────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│ Database State                          │
│                                         │
│ game_sessions: 3 rows                   │
│ game_session_details: 15 rows           │
│ user_vocab_progress: 15 rows updated    │
│   ├─ timesCorrect, timesWrong           │
│   ├─ status: UNKNOWN/KNOWN/MASTERED     │
│   ├─ efFactor, repetition, interval     │
│   └─ nextReviewDate                     │
└─────────────────────────────────────────┘
```

## 🎯 Kết quả

### ✅ Đã fix

1. ✅ Gửi riêng list `gameSessionDetails` (không nhúng trong sessions)
2. ✅ Link details với sessions qua `clientSessionId`
3. ✅ Tự động cập nhật `user_vocab_progress` từ game results
4. ✅ Tính toán `timesCorrect`, `timesWrong`
5. ✅ Áp dụng thuật toán SM-2 (Spaced Repetition)
6. ✅ Cập nhật status: UNKNOWN → KNOWN → MASTERED
7. ✅ Merge thông minh với manual vocab progress
8. ✅ Transaction safety (all-or-nothing)
9. ✅ Error handling từng item riêng lẻ
10. ✅ Duplicate detection tự động

### 📝 Response Example

```json
{
    "status": "200",
    "message": "Batch sync completed",
    "data": {
        "syncedGameSessions": 3,
        "syncedGameSessionDetails": 15,
        "syncedVocabProgress": 0,
        "skippedDuplicates": 0,
        "errors": [],
        "serverTimestamp": "2025-11-19T17:00:00"
    }
}
```

### 🧮 Status Progression Logic

```
Vocab chưa học (NEW)
   │
   ├─ User chơi game lần đầu
   │  └─ Create UserVocabProgress (status = UNKNOWN)
   │
   ├─ Correct answer
   │  ├─ timesCorrect++
   │  ├─ repetition++
   │  ├─ interval increase
   │  └─ if (timesCorrect >= 3 && accuracy >= 60%)
   │     └─ status = KNOWN
   │
   ├─ Incorrect answer
   │  ├─ timesWrong++
   │  ├─ repetition = 0
   │  ├─ interval = 1
   │  └─ status = UNKNOWN
   │
   └─ Mastery achieved
      └─ if (timesCorrect >= 10 && timesWrong <= 2 && accuracy >= 80%)
         └─ status = MASTERED
```

## 📚 Related Files

-   ✅ `/docs/OFFLINE_SYNC_API_GUIDE.md` - Chi tiết API documentation
-   ✅ `BatchSyncRequest.java` - Request DTO
-   ✅ `OfflineGameDetailRequest.java` - Detail DTO with clientSessionId
-   ✅ `OfflineVocabProgressRequest.java` - Progress DTO with metrics
-   ✅ `OfflineSyncService.java` - Business logic
-   ✅ `OfflineSyncController.java` - REST endpoint

## 🚀 Testing

```bash
# Build
cd card-words
mvn clean package -DskipTests

# Deploy
cd ..
docker-compose build card-words-api
docker-compose up -d card-words-api

# Test endpoint
curl -X POST http://localhost:8080/api/v1/offline/sync/batch \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d @test-batch-sync.json
```

## 🎉 Summary

Đã hoàn thành:

-   ✅ Nhận list gameSessions và gameSessionDetails riêng biệt
-   ✅ Tự động tính toán và cập nhật user_vocab_progress
-   ✅ Áp dụng thuật toán Spaced Repetition (SM-2)
-   ✅ Merge thông minh với manual updates
-   ✅ Build thành công, không lỗi
