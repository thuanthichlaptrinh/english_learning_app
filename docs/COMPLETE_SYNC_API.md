# 🚀 Complete Sync API - Endpoint Mới

## 📍 Endpoint

```
POST /api/v1/offline/sync/complete
```

## 🎯 Mục đích

API chuyên dụng để upload **đầy đủ 3 list** cùng lúc:

1. **gameSessions** - Danh sách các lần chơi game
2. **gameSessionDetails** - Chi tiết từng câu hỏi
3. **vocabProgress** - Tiến trình học từ vựng (optional)

## 🔒 Authentication

```
Authorization: Bearer <JWT_TOKEN>
```

## 📝 Request Body

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
        {
            "clientSessionId": "session-uuid-1",
            "vocabId": "550e8400-e29b-41d4-a716-446655440001",
            "questionNumber": 1,
            "isCorrect": true,
            "timeTaken": 2500
        },
        {
            "clientSessionId": "session-uuid-1",
            "vocabId": "550e8400-e29b-41d4-a716-446655440002",
            "questionNumber": 2,
            "isCorrect": true,
            "timeTaken": 1800
        },
        {
            "clientSessionId": "session-uuid-1",
            "vocabId": "550e8400-e29b-41d4-a716-446655440003",
            "questionNumber": 3,
            "isCorrect": false,
            "timeTaken": 3200
        },
        {
            "clientSessionId": "session-uuid-1",
            "vocabId": "550e8400-e29b-41d4-a716-446655440004",
            "questionNumber": 4,
            "isCorrect": true,
            "timeTaken": 2100
        },
        {
            "clientSessionId": "session-uuid-1",
            "vocabId": "550e8400-e29b-41d4-a716-446655440005",
            "questionNumber": 5,
            "isCorrect": true,
            "timeTaken": 1900
        },

        {
            "clientSessionId": "session-uuid-2",
            "vocabId": "550e8400-e29b-41d4-a716-446655440006",
            "questionNumber": 1,
            "isCorrect": true,
            "timeTaken": 2000
        },
        {
            "clientSessionId": "session-uuid-2",
            "vocabId": "550e8400-e29b-41d4-a716-446655440007",
            "questionNumber": 2,
            "isCorrect": false,
            "timeTaken": 3500
        },
        {
            "clientSessionId": "session-uuid-2",
            "vocabId": "550e8400-e29b-41d4-a716-446655440008",
            "questionNumber": 3,
            "isCorrect": true,
            "timeTaken": 1700
        },
        {
            "clientSessionId": "session-uuid-2",
            "vocabId": "550e8400-e29b-41d4-a716-446655440009",
            "questionNumber": 4,
            "isCorrect": false,
            "timeTaken": 4000
        },
        {
            "clientSessionId": "session-uuid-2",
            "vocabId": "550e8400-e29b-41d4-a716-446655440010",
            "questionNumber": 5,
            "isCorrect": false,
            "timeTaken": 3800
        },

        {
            "clientSessionId": "session-uuid-3",
            "vocabId": "550e8400-e29b-41d4-a716-446655440011",
            "questionNumber": 1,
            "isCorrect": true,
            "timeTaken": 1500
        },
        {
            "clientSessionId": "session-uuid-3",
            "vocabId": "550e8400-e29b-41d4-a716-446655440012",
            "questionNumber": 2,
            "isCorrect": true,
            "timeTaken": 1600
        },
        {
            "clientSessionId": "session-uuid-3",
            "vocabId": "550e8400-e29b-41d4-a716-446655440013",
            "questionNumber": 3,
            "isCorrect": true,
            "timeTaken": 1400
        },
        {
            "clientSessionId": "session-uuid-3",
            "vocabId": "550e8400-e29b-41d4-a716-446655440014",
            "questionNumber": 4,
            "isCorrect": true,
            "timeTaken": 1700
        },
        {
            "clientSessionId": "session-uuid-3",
            "vocabId": "550e8400-e29b-41d4-a716-446655440015",
            "questionNumber": 5,
            "isCorrect": true,
            "timeTaken": 1300
        }
    ],

    "vocabProgress": [
        {
            "vocabId": "550e8400-e29b-41d4-a716-446655440100",
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

## ✅ Success Response (200 OK)

```json
{
    "status": "200",
    "message": "Complete sync finished: 3 sessions, 15 details, 1 progress updates",
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

## ❌ Error Response (400 Bad Request)

### Thiếu gameSessions

```json
{
    "status": "400",
    "message": "gameSessions is required",
    "data": null
}
```

### Thiếu gameSessionDetails

```json
{
    "status": "400",
    "message": "gameSessionDetails is required",
    "data": null
}
```

### Có lỗi khi xử lý

```json
{
    "status": "200",
    "message": "Complete sync finished: 2 sessions, 13 details, 0 progress updates",
    "data": {
        "syncedGameSessions": 2,
        "syncedGameSessionDetails": 13,
        "syncedVocabProgress": 0,
        "skippedDuplicates": 1,
        "errors": ["Session session-uuid-3: Game not found: 999", "Detail vocab 550e8400-...: Vocab not found"],
        "serverTimestamp": "2025-11-19T10:30:05"
    }
}
```

## 🔄 Processing Flow

```
1. Validate Request
   ├─ gameSessions ≠ empty ✓
   └─ gameSessionDetails ≠ empty ✓

2. Save Game Sessions
   ├─ Loop through gameSessions
   ├─ Check duplicates (skip if exists)
   ├─ Save to game_sessions table
   └─ Map: clientSessionId → GameSession

3. Save Game Session Details + Auto-update Progress
   ├─ Loop through gameSessionDetails
   ├─ Get session from map by clientSessionId
   ├─ Save to game_session_details table
   └─ Auto-update user_vocab_progress:
      ├─ isCorrect = true → timesCorrect++
      ├─ isCorrect = false → timesWrong++
      ├─ Apply SM-2 algorithm
      │  ├─ Update efFactor
      │  ├─ Update repetition
      │  ├─ Update intervalDays
      │  └─ Calculate nextReviewDate
      └─ Update status:
         ├─ timesCorrect ≥ 10, timesWrong ≤ 2, accuracy ≥ 80% → MASTERED
         ├─ timesCorrect ≥ 3, accuracy ≥ 60% → KNOWN
         └─ else → UNKNOWN

4. Merge Vocab Progress (Optional)
   ├─ Loop through vocabProgress
   ├─ Check if newer than server data
   └─ Update if client data is newer
```

## 📊 Database Changes

### game_sessions

```sql
INSERT INTO game_sessions (user_id, game_id, started_at, finished_at, total_questions, correct_count, score)
VALUES (user_id, 1, '2025-11-19 10:00:00', '2025-11-19 10:02:30', 5, 4, 80);
-- 3 rows inserted
```

### game_session_details

```sql
INSERT INTO game_session_details (session_id, vocab_id, is_correct, time_taken)
VALUES (1, '550e8400-...', true, 2500);
-- 15 rows inserted
```

### user_vocab_progress (Auto-updated)

```sql
-- For each vocab in gameSessionDetails:
UPDATE user_vocab_progress
SET
  times_correct = times_correct + 1,  -- if isCorrect = true
  times_wrong = times_wrong + 1,      -- if isCorrect = false
  status = 'KNOWN',                   -- calculated based on performance
  ef_factor = 2.6,                    -- SM-2 algorithm
  repetition = 2,
  interval_days = 6,
  next_review_date = '2025-11-25',
  last_reviewed = '2025-11-19'
WHERE user_id = user_id AND vocab_id = vocab_id;

-- If not exists, INSERT new row
```

## 🎮 Use Case: Offline Game Play

```javascript
// Frontend code example
const offlineData = {
    sessions: [],
    details: [],
};

// User plays 3 games offline
for (let i = 0; i < 3; i++) {
    const sessionId = generateUUID();

    // Start game
    const session = {
        clientSessionId: sessionId,
        gameId: getRandomGameId(),
        startedAt: new Date().toISOString(),
        totalQuestions: 5,
        correctCount: 0,
        score: 0,
    };

    // Play 5 questions
    for (let q = 1; q <= 5; q++) {
        const vocab = getRandomVocab();
        const isCorrect = askQuestion(vocab);

        offlineData.details.push({
            clientSessionId: sessionId,
            vocabId: vocab.id,
            questionNumber: q,
            isCorrect: isCorrect,
            timeTaken: getTimeTaken(),
        });

        if (isCorrect) session.correctCount++;
    }

    session.finishedAt = new Date().toISOString();
    session.score = calculateScore(session.correctCount);
    offlineData.sessions.push(session);
}

// When online, sync all at once
async function syncAllData() {
    const response = await fetch('/api/v1/offline/sync/complete', {
        method: 'POST',
        headers: {
            Authorization: `Bearer ${token}`,
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            clientId: getDeviceId(),
            syncTimestamp: new Date().toISOString(),
            gameSessions: offlineData.sessions,
            gameSessionDetails: offlineData.details,
            // vocabProgress is optional
        }),
    });

    const result = await response.json();
    console.log('Synced:', result.data);

    // Clear offline data if successful
    if (result.data.errors.length === 0) {
        offlineData.sessions = [];
        offlineData.details = [];
    }
}
```

## 🆚 So sánh với `/sync/batch`

| Feature        | `/sync/complete`                              | `/sync/batch`          |
| -------------- | --------------------------------------------- | ---------------------- |
| Validation     | ✅ Required gameSessions + gameSessionDetails | ❌ Optional all fields |
| Use case       | Offline game sync                             | General purpose sync   |
| Documentation  | ✅ Chi tiết, rõ ràng                          | Standard               |
| Error response | ✅ Specific validation errors                 | Generic errors         |
| Recommendation | ✅ **Recommended for offline game sync**      | For mixed scenarios    |

## 💡 Best Practices

1. **Always link details to sessions:**

    ```json
    {
        "gameSessions": [{ "clientSessionId": "s1" }],
        "gameSessionDetails": [
            { "clientSessionId": "s1" } // ✅ Match
        ]
    }
    ```

2. **Generate unique clientSessionId:**

    ```javascript
    const sessionId = `${Date.now()}-${Math.random().toString(36)}`;
    ```

3. **Batch multiple games in one request:**

    - Don't send 1 request per game
    - Collect offline data → Send 1 request with all

4. **Handle partial failures:**

    ```javascript
    if (result.data.errors.length > 0) {
        // Some items failed
        console.error('Errors:', result.data.errors);
        // Retry failed items or log for manual review
    }
    ```

5. **vocabProgress is optional:**
    - Only send if user manually marked vocab as "Known"
    - Backend auto-updates from game results anyway

## 🎯 Summary

-   ✅ **Endpoint:** `POST /api/v1/offline/sync/complete`
-   ✅ **Required:** gameSessions + gameSessionDetails
-   ✅ **Optional:** vocabProgress
-   ✅ **Auto-updates:** user_vocab_progress from game results
-   ✅ **Algorithm:** SM-2 Spaced Repetition
-   ✅ **Validation:** Returns 400 if missing required fields
-   ✅ **Transaction safe:** All-or-nothing per session
-   ✅ **Error handling:** Partial success with error list
