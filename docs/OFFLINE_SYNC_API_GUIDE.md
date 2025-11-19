# 📱 Offline Sync API - Hướng dẫn sử dụng

## 🎯 Tổng quan

API hỗ trợ đồng bộ dữ liệu game offline lên server, tự động cập nhật tiến trình học từ vựng của user.

## 🔄 Luồng xử lý (Processing Flow)

```
Frontend (Offline Mode)
   │
   ├─ User chơi 3 lần game (mỗi lần 5 câu)
   │  ├─ Game 1: 5 questions → 1 session + 5 details
   │  ├─ Game 2: 5 questions → 1 session + 5 details
   │  └─ Game 3: 5 questions → 1 session + 5 details
   │
   └─ Khi có mạng → Gửi 1 request lên server:
      {
        "gameSessions": [3 sessions],
        "gameSessionDetails": [15 details],
        "vocabProgress": [...] (optional)
      }

Backend Processing
   │
   ├─ Step 1: Lưu 3 game sessions
   │
   ├─ Step 2: Lưu 15 game session details
   │           └─ Tự động cập nhật user_vocab_progress:
   │              ├─ isCorrect = true → timesCorrect++
   │              ├─ isCorrect = false → timesWrong++
   │              ├─ Áp dụng thuật toán SM-2 (Spaced Repetition)
   │              └─ Cập nhật status: UNKNOWN → KNOWN → MASTERED
   │
   └─ Step 3: Merge với vocabProgress (nếu có)
              └─ Dùng cho manual updates: "Đánh dấu đã thuộc"
```

## 📝 Request Format

### POST `/api/v1/offline/sync/batch`

```json
{
    "clientId": "device-uuid-12345",
    "syncTimestamp": "2025-11-19T10:30:00",
    "gameSessions": [
        {
            "clientSessionId": "session-uuid-1",
            "gameId": 1,
            "startedAt": "2025-11-19T10:00:00",
            "finishedAt": "2025-11-19T10:02:30",
            "totalQuestions": 5,
            "correctCount": 4,
            "score": 80
        },
        {
            "clientSessionId": "session-uuid-2",
            "gameId": 1,
            "startedAt": "2025-11-19T10:05:00",
            "finishedAt": "2025-11-19T10:07:15",
            "totalQuestions": 5,
            "correctCount": 3,
            "score": 60
        },
        {
            "clientSessionId": "session-uuid-3",
            "gameId": 2,
            "startedAt": "2025-11-19T10:10:00",
            "finishedAt": "2025-11-19T10:12:45",
            "totalQuestions": 5,
            "correctCount": 5,
            "score": 100
        }
    ],
    "gameSessionDetails": [
        // Session 1 - 5 questions
        {
            "clientSessionId": "session-uuid-1",
            "vocabId": "vocab-uuid-1",
            "questionNumber": 1,
            "isCorrect": true,
            "timeTaken": 2500
        },
        {
            "clientSessionId": "session-uuid-1",
            "vocabId": "vocab-uuid-2",
            "questionNumber": 2,
            "isCorrect": true,
            "timeTaken": 1800
        },
        {
            "clientSessionId": "session-uuid-1",
            "vocabId": "vocab-uuid-3",
            "questionNumber": 3,
            "isCorrect": false,
            "timeTaken": 3200
        },
        {
            "clientSessionId": "session-uuid-1",
            "vocabId": "vocab-uuid-4",
            "questionNumber": 4,
            "isCorrect": true,
            "timeTaken": 2100
        },
        {
            "clientSessionId": "session-uuid-1",
            "vocabId": "vocab-uuid-5",
            "questionNumber": 5,
            "isCorrect": true,
            "timeTaken": 1900
        },

        // Session 2 - 5 questions
        {
            "clientSessionId": "session-uuid-2",
            "vocabId": "vocab-uuid-6",
            "questionNumber": 1,
            "isCorrect": true,
            "timeTaken": 2000
        },
        // ... 4 more details

        // Session 3 - 5 questions
        {
            "clientSessionId": "session-uuid-3",
            "vocabId": "vocab-uuid-11",
            "questionNumber": 1,
            "isCorrect": true,
            "timeTaken": 1500
        }
        // ... 4 more details
    ],
    "vocabProgress": [
        // Optional: Manual updates (user clicked "Mark as Known")
        {
            "vocabId": "vocab-uuid-100",
            "status": "KNOWN",
            "lastReviewedAt": "2025-11-19T10:00:00",
            "nextReviewAt": "2025-11-20T10:00:00",
            "easeFactor": 2.5,
            "repetitions": 1,
            "interval": 1,
            "timesCorrect": 0,
            "timesWrong": 0
        }
    ]
}
```

## 📤 Response Format

```json
{
    "status": "200",
    "message": "Batch sync completed",
    "data": {
        "syncedGameSessions": 3,
        "syncedGameSessionDetails": 15,
        "syncedVocabProgress": 1,
        "skippedDuplicates": 0,
        "errors": [],
        "serverTimestamp": "2025-11-19T10:30:05"
    }
}
```

## 🎮 Các trường hợp xử lý

### 1️⃣ Chơi game offline → Auto sync progress

```json
{
  "gameSessions": [3 sessions],
  "gameSessionDetails": [15 details]
  // Không cần gửi vocabProgress - backend tự tính
}
```

**Backend tự động:**

-   Lưu sessions + details
-   Cập nhật `user_vocab_progress`:
    -   `timesCorrect`, `timesWrong`
    -   `status`: UNKNOWN → KNOWN → MASTERED
    -   `efFactor`, `repetition`, `intervalDays`
    -   `nextReviewDate`

### 2️⃣ User đánh dấu "Đã thuộc" thủ công

```json
{
  "vocabProgress": [
    {
      "vocabId": "...",
      "status": "KNOWN",
      ...
    }
  ]
  // Không có gameSessions
}
```

### 3️⃣ Kết hợp cả hai

```json
{
  "gameSessions": [...],
  "gameSessionDetails": [...],
  "vocabProgress": [...]  // Manual updates
}
```

**Thứ tự xử lý:**

1. Lưu game sessions
2. Lưu details → auto-update progress
3. Merge với manual vocabProgress

## 🧮 Thuật toán SM-2 (Spaced Repetition)

### Status Progression

```
NEW (chưa học)
   ↓
UNKNOWN (đang học, sai nhiều)
   ↓ (correct >= 3, accuracy >= 60%)
KNOWN (đã thuộc)
   ↓ (correct >= 10, wrong <= 2, accuracy >= 80%)
MASTERED (thành thạo)
```

### Interval Calculation

-   **Correct answer (quality = 5):**

    -   Rep 0: interval = 1 day
    -   Rep 1: interval = 6 days
    -   Rep 2+: interval = previous × EF

-   **Incorrect answer (quality = 1):**
    -   Reset: repetition = 0, interval = 1 day
    -   Status → UNKNOWN

### Ease Factor (EF) Formula

```
EF' = EF + (0.1 - (5-q) × (0.08 + (5-q) × 0.02))
```

-   q = 5 (correct) hoặc 1 (incorrect)
-   Minimum EF = 1.3

## 🔗 Linking Details với Sessions

**Quan trọng:** Mỗi `gameSessionDetail` phải có `clientSessionId` khớp với `gameSessions`:

```json
{
  "gameSessions": [
    { "clientSessionId": "session-1", ... }
  ],
  "gameSessionDetails": [
    { "clientSessionId": "session-1", ... },  // ✅ Link đúng
    { "clientSessionId": "session-2", ... }   // ❌ Session-2 không tồn tại → ERROR
  ]
}
```

## ⚠️ Error Handling

Backend sẽ xử lý từng item riêng lẻ:

```json
{
    "syncedGameSessions": 2, // 2/3 sessions thành công
    "syncedGameSessionDetails": 13, // 13/15 details thành công
    "errors": ["Session session-uuid-3: Game not found: 999", "Detail vocab vocab-uuid-x: Vocab not found"]
}
```

**Items thành công vẫn được lưu**, items lỗi được báo trong `errors` array.

## 🔄 Duplicate Detection

Backend tự động skip duplicate sessions (dựa vào `userId + gameId + startedAt`):

```json
{
  "syncedGameSessions": 2,
  "skippedDuplicates": 1,  // 1 session đã tồn tại
  ...
}
```

## 💡 Best Practices

### Frontend Implementation

```javascript
// Offline mode: Store data locally
const offlineData = {
    sessions: [],
    details: [],
};

// User chơi game
function playGame(gameId) {
    const sessionId = generateUUID();

    // Start session
    offlineData.sessions.push({
        clientSessionId: sessionId,
        gameId: gameId,
        startedAt: new Date().toISOString(),
        totalQuestions: 5,
        correctCount: 0,
        score: 0,
    });

    // Each question
    questions.forEach((question, index) => {
        const isCorrect = checkAnswer(question);

        offlineData.details.push({
            clientSessionId: sessionId, // ⚠️ Link to session
            vocabId: question.vocabId,
            questionNumber: index + 1,
            isCorrect: isCorrect,
            timeTaken: getTimeTaken(),
        });

        if (isCorrect) {
            offlineData.sessions[0].correctCount++;
        }
    });

    // Finish session
    offlineData.sessions[0].finishedAt = new Date().toISOString();
    offlineData.sessions[0].score = calculateScore();
}

// Sync when online
async function syncWhenOnline() {
    if (navigator.onLine && offlineData.sessions.length > 0) {
        const response = await fetch('/api/v1/offline/sync/batch', {
            method: 'POST',
            headers: {
                Authorization: 'Bearer ' + token,
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                clientId: getDeviceId(),
                syncTimestamp: new Date().toISOString(),
                gameSessions: offlineData.sessions,
                gameSessionDetails: offlineData.details,
            }),
        });

        const result = await response.json();

        if (result.data.errors.length === 0) {
            // Clear local data
            offlineData.sessions = [];
            offlineData.details = [];
        }
    }
}
```

## 📊 Database Updates

Sau khi sync, database sẽ có:

### `game_sessions` table

```
id | user_id | game_id | started_at | finished_at | total_questions | correct_count | score
---|---------|---------|------------|-------------|-----------------|---------------|------
1  | user-1  | 1       | 10:00:00   | 10:02:30    | 5               | 4             | 80
2  | user-1  | 1       | 10:05:00   | 10:07:15    | 5               | 3             | 60
3  | user-1  | 2       | 10:10:00   | 10:12:45    | 5               | 5             | 100
```

### `game_session_details` table

```
id | session_id | vocab_id | is_correct | time_taken
---|------------|----------|------------|------------
1  | 1          | vocab-1  | true       | 2500
2  | 1          | vocab-2  | true       | 1800
3  | 1          | vocab-3  | false      | 3200
...
15 | 3          | vocab-15 | true       | 1500
```

### `user_vocab_progress` table (Auto-updated)

```
id | user_id | vocab_id | status | times_correct | times_wrong | ef_factor | next_review_date
---|---------|----------|--------|---------------|-------------|-----------|------------------
1  | user-1  | vocab-1  | KNOWN  | 1             | 0           | 2.6       | 2025-11-20
2  | user-1  | vocab-2  | KNOWN  | 1             | 0           | 2.6       | 2025-11-20
3  | user-1  | vocab-3  | UNKNOWN| 0             | 1           | 2.3       | 2025-11-20
...
```

## 🎯 Summary

-   ✅ **1 request duy nhất** để sync tất cả dữ liệu offline
-   ✅ **Tự động tính toán** user_vocab_progress từ game results
-   ✅ **Spaced Repetition (SM-2)** algorithm tích hợp sẵn
-   ✅ **Error handling** từng item riêng lẻ
-   ✅ **Duplicate detection** tự động
-   ✅ **Transaction safety** - all-or-nothing cho mỗi session
