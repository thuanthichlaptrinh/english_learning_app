# 🎮 Tài Liệu Mô Tả Thuật Toán Các Game

## 📚 Tổng Quan

Hệ thống bao gồm 3 trò chơi học từ vựng với các thuật toán tính điểm và quản lý tiến độ khác nhau:

1. **Quick Reflex Quiz** - Trắc nghiệm nhanh với combo streak
2. **Image-Word Matching** - Ghép hình ảnh với từ vựng
3. **Word-Definition Matching** - Ghép từ với nghĩa

---

## 1. 🚀 Quick Reflex Quiz

### 1.1. Mô Tả Game

Người chơi xem một từ tiếng Anh và chọn nghĩa đúng trong 3 lựa chọn, với giới hạn thời gian 3 giây/câu.

### 1.2. Thuật Toán Sinh Câu Hỏi

#### **Input:**

-   `totalQuestions`: Số lượng câu hỏi (do user chọn)
-   `cefr`: Mức độ CEFR (optional: A1, A2, B1, B2, C1, C2)

#### **Thuật Toán:**

```
FUNCTION getRandomVocabs(totalQuestions, cefr):
    // Bước 1: Lọc từ vựng theo CEFR (nếu có)
    IF cefr != null AND cefr != empty THEN
        vocabs = SELECT * FROM vocab WHERE cefr = cefr
    ELSE
        vocabs = SELECT * FROM vocab  // Lấy tất cả
    END IF

    // Bước 2: Kiểm tra số lượng đủ không
    requiredVocabs = totalQuestions × 3  // Cần 3 từ cho 1 câu hỏi
    IF vocabs.size < requiredVocabs THEN
        THROW ERROR "Không đủ từ vựng"
    END IF

    // Bước 3: Shuffle để random
    SHUFFLE(vocabs)

    // Bước 4: Lấy đủ số lượng cần
    RETURN vocabs[0..requiredVocabs-1]
END FUNCTION
```

#### **Thuật Toán Tạo Options:**

```
FUNCTION generateQuestion(vocabIndex, vocabs):
    correctVocab = vocabs[vocabIndex × 3]       // Đáp án đúng
    wrongVocab1 = vocabs[vocabIndex × 3 + 1]   // Đáp án sai 1
    wrongVocab2 = vocabs[vocabIndex × 3 + 2]   // Đáp án sai 2

    // Tạo danh sách options
    options = [
        correctVocab.meaningVi,    // Nghĩa đúng
        wrongVocab1.meaningVi,     // Nghĩa sai 1
        wrongVocab2.meaningVi      // Nghĩa sai 2
    ]

    // Shuffle để random vị trí
    SHUFFLE(options)

    // Tìm index của đáp án đúng sau khi shuffle
    correctIndex = options.indexOf(correctVocab.meaningVi)

    RETURN QuestionData(
        vocabId: correctVocab.id,
        word: correctVocab.word,
        correctMeaning: correctVocab.meaningVi,
        options: options,
        correctAnswerIndex: correctIndex
    )
END FUNCTION
```

### 1.3. Thuật Toán Tính Điểm

#### **Công Thức:**

```
totalScore = basePoints + streakBonus + speedBonus
```

#### **1.3.1. Base Points**

```
IF answerCorrect THEN
    basePoints = 10
ELSE
    basePoints = 0
END IF
```

#### **1.3.2. Streak Bonus (Combo)**

Thưởng cho chuỗi trả lời đúng liên tiếp:

```
FUNCTION calculateStreakBonus(currentStreak):
    IF currentStreak >= 3 THEN
        comboCount = FLOOR(currentStreak / 3)
        streakBonus = 5 × comboCount
    ELSE
        streakBonus = 0
    END IF

    RETURN streakBonus
END FUNCTION
```

**Ví dụ:**

-   3 câu đúng liên tiếp: +5 điểm
-   6 câu đúng liên tiếp: +10 điểm
-   9 câu đúng liên tiếp: +15 điểm

#### **1.3.3. Speed Bonus**

Thưởng cho tốc độ trả lời nhanh:

```
FUNCTION calculateSpeedBonus(timeTaken):
    IF timeTaken < 1500ms THEN  // Dưới 1.5 giây
        speedBonus = 5
    ELSE
        speedBonus = 0
    END IF

    RETURN speedBonus
END FUNCTION
```

#### **1.3.4. Thuật Toán Tính Streak**

```
FUNCTION calculateCurrentStreak(sessionDetails):
    streak = 0

    // Duyệt ngược từ câu hỏi cuối
    FOR i FROM sessionDetails.length - 1 DOWN TO 0 DO
        IF sessionDetails[i].isCorrect == true THEN
            streak++
        ELSE
            BREAK  // Gặp câu sai thì dừng
        END IF
    END FOR

    RETURN streak
END FUNCTION
```

#### **1.3.5. Ví Dụ Tính Điểm:**

**Scenario 1: Trả lời đúng, nhanh, có streak**

```
- Base Points: 10
- Streak: 5 câu đúng → Combo: 5 điểm
- Time: 1200ms → Speed Bonus: 5 điểm
→ Total: 10 + 5 + 5 = 20 điểm
```

**Scenario 2: Trả lời đúng, chậm, không streak**

```
- Base Points: 10
- Streak: 1 câu → Combo: 0 điểm
- Time: 2500ms → Speed Bonus: 0 điểm
→ Total: 10 điểm
```

### 1.4. Caching Strategy

```
// Cache tất cả câu hỏi ngay từ đầu
sessionQuestionsCache = ConcurrentHashMap<sessionId, List<QuestionData>>

ON startGame():
    questions = generateAllQuestions()
    sessionQuestionsCache.put(sessionId, questions)

ON submitAnswer():
    questions = sessionQuestionsCache.get(sessionId)
    currentQuestion = questions[questionNumber - 1]
    // Validate answer...

ON finishGame():
    sessionQuestionsCache.remove(sessionId)
```

**Lợi ích:**

-   ✅ Tránh tạo lại câu hỏi mỗi lần submit
-   ✅ Đảm bảo tính nhất quán của câu hỏi
-   ✅ Giảm load database

---

## 2. 🖼️ Image-Word Matching

### 2.1. Mô Tả Game

Người chơi ghép thẻ hình ảnh với từ vựng tương ứng. Điểm số dựa trên mức độ CEFR và thời gian hoàn thành.

### 2.2. Thuật Toán Lọc Từ Vựng Có Hình Ảnh

```
FUNCTION getRandomVocabsWithImages(totalPairs, cefr):
    // Bước 1: Lọc theo CEFR (nếu có)
    IF cefr != null AND cefr != empty THEN
        vocabs = SELECT * FROM vocab WHERE cefr = cefr
    ELSE
        vocabs = SELECT * FROM vocab
    END IF

    // Bước 2: Lọc chỉ lấy từ có hình ảnh
    vocabsWithImages = []
    FOR EACH vocab IN vocabs DO
        IF vocab.img != null AND vocab.img != empty THEN
            vocabsWithImages.add(vocab)
        END IF
    END FOR

    // Bước 3: Kiểm tra đủ số lượng
    IF vocabsWithImages.size < totalPairs THEN
        THROW ERROR "Không đủ từ vựng có hình ảnh"
    END IF

    // Bước 4: Random và lấy đủ số lượng
    SHUFFLE(vocabsWithImages)
    RETURN vocabsWithImages[0..totalPairs-1]
END FUNCTION
```

### 2.3. Thuật Toán Tính Điểm

#### **Công Thức:**

```
totalScore = cefrScore + timeBonus
```

#### **2.3.1. CEFR Score**

Điểm dựa trên độ khó của từ vựng:

```
FUNCTION getCefrPoints(cefr):
    SWITCH cefr:
        CASE "A1": RETURN 1
        CASE "A2": RETURN 2
        CASE "B1": RETURN 3
        CASE "B2": RETURN 4
        CASE "C1": RETURN 5
        CASE "C2": RETURN 6
        DEFAULT:   RETURN 1
    END SWITCH
END FUNCTION
```

```
FUNCTION calculateCefrScore(vocabs, matchedIds):
    cefrScore = 0

    FOR EACH vocab IN vocabs DO
        IF vocab.id IN matchedIds THEN  // Ghép đúng
            cefrScore += getCefrPoints(vocab.cefr)
        END IF
    END FOR

    RETURN cefrScore
END FUNCTION
```

**Ví dụ:**

-   Ghép đúng 3 từ A1: 1 + 1 + 1 = 3 điểm
-   Ghép đúng 3 từ B2: 4 + 4 + 4 = 12 điểm
-   Ghép đúng 3 từ C2: 6 + 6 + 6 = 18 điểm

#### **2.3.2. Time Bonus**

Thưởng dựa trên tốc độ hoàn thành:

```
FUNCTION calculateTimeBonus(timeTakenSeconds, cefrScore):
    bonusPercentage = 0

    IF timeTakenSeconds < 10 THEN
        bonusPercentage = 0.5      // +50%
    ELSE IF timeTakenSeconds < 20 THEN
        bonusPercentage = 0.3      // +30%
    ELSE IF timeTakenSeconds < 30 THEN
        bonusPercentage = 0.2      // +20%
    ELSE IF timeTakenSeconds < 60 THEN
        bonusPercentage = 0.1      // +10%
    ELSE
        bonusPercentage = 0        // Không bonus
    END IF

    timeBonus = FLOOR(cefrScore × bonusPercentage)
    RETURN timeBonus
END FUNCTION
```

#### **2.3.3. Ví Dụ Tính Điểm:**

**Scenario 1: Ghép 5 từ B2 trong 15 giây**

```
CEFR Score:
- 5 từ B2 đúng: 5 × 4 = 20 điểm

Time Bonus:
- 15 giây < 20 giây → +30%
- Bonus: 20 × 0.3 = 6 điểm

Total Score: 20 + 6 = 26 điểm
```

**Scenario 2: Ghép 5 từ C2 trong 8 giây**

```
CEFR Score:
- 5 từ C2 đúng: 5 × 6 = 30 điểm

Time Bonus:
- 8 giây < 10 giây → +50%
- Bonus: 30 × 0.5 = 15 điểm

Total Score: 30 + 15 = 45 điểm
```

**Scenario 3: Ghép 5 từ A1 trong 70 giây**

```
CEFR Score:
- 5 từ A1 đúng: 5 × 1 = 5 điểm

Time Bonus:
- 70 giây > 60 giây → +0%
- Bonus: 0 điểm

Total Score: 5 + 0 = 5 điểm
```

### 2.4. Session Caching

```
// Cache session data với Caffeine
sessionCache = Caffeine.newBuilder()
    .expireAfterWrite(30, MINUTES)
    .maximumSize(10000)
    .build()

ON startGame():
    sessionData = SessionData(sessionId, vocabs)
    sessionCache.put(sessionId, sessionData)

ON submitAnswer():
    sessionData = sessionCache.get(sessionId)
    IF sessionData == null THEN
        THROW ERROR "Session không tồn tại hoặc đã hết hạn"
    END IF
    // Validate and calculate score...

ON finishGame():
    sessionCache.invalidate(sessionId)
```

**Đặc điểm:**

-   ⏰ Auto expire sau 30 phút
-   💾 Maximum 10,000 sessions
-   🚀 Fast in-memory access

---

## 3. 📖 Word-Definition Matching

### 3.1. Mô Tả Game

Người chơi ghép từ tiếng Anh với định nghĩa tiếng Việt tương ứng. Tương tự Image-Word Matching nhưng không cần hình ảnh.

### 3.2. Thuật Toán Lọc Từ Vựng

```
FUNCTION getRandomVocabs(totalPairs, cefr):
    // Bước 1: Lọc theo CEFR (nếu có)
    IF cefr != null AND cefr != empty THEN
        vocabs = SELECT * FROM vocab WHERE cefr = cefr
    ELSE
        vocabs = SELECT * FROM vocab
    END IF

    // Bước 2: Kiểm tra số lượng
    IF vocabs.size < totalPairs THEN
        THROW ERROR "Không đủ từ vựng"
    END IF

    // Bước 3: Random và lấy
    SHUFFLE(vocabs)
    RETURN vocabs[0..totalPairs-1]
END FUNCTION
```

**Khác biệt với Image-Word Matching:**

-   ❌ KHÔNG cần filter `img != null`
-   ✅ Có thể dùng TẤT CẢ từ vựng

### 3.3. Thuật Toán Tính Điểm

**Hoàn toàn giống với Image-Word Matching:**

```
totalScore = cefrScore + timeBonus
```

#### **3.3.1. CEFR Score**

```
FOR EACH vocab IN sessionVocabs DO
    IF vocab.id IN submittedMatchedIds THEN
        points = getCefrPoints(vocab.cefr)
        cefrScore += points
    END IF
END FOR
```

#### **3.3.2. Time Bonus**

```
IF timeTakenSeconds < 10 THEN
    timeBonus = cefrScore × 0.5    // +50%
ELSE IF timeTakenSeconds < 20 THEN
    timeBonus = cefrScore × 0.3    // +30%
ELSE IF timeTakenSeconds < 30 THEN
    timeBonus = cefrScore × 0.2    // +20%
ELSE IF timeTakenSeconds < 60 THEN
    timeBonus = cefrScore × 0.1    // +10%
ELSE
    timeBonus = 0
END IF
```

### 3.4. Validation Logic

```
FUNCTION validateSubmission(sessionVocabs, submittedIds):
    // Bước 1: Convert to sets
    actualIds = SET of sessionVocabs.map(v => v.id)
    submittedSet = SET of submittedIds

    // Bước 2: Kiểm tra số lượng
    IF submittedSet.size != actualIds.size THEN
        THROW ERROR "Số lượng vocab không khớp"
    END IF

    // Bước 3: Kiểm tra từng vocab
    correctMatches = 0
    FOR EACH vocab IN sessionVocabs DO
        IF vocab.id IN submittedSet THEN
            correctMatches++
        END IF
    END FOR

    RETURN correctMatches
END FUNCTION
```

---

## 4. 📊 Thuật Toán Chung: Cập Nhật Tiến Độ

### 4.1. Update User Vocab Progress

Được gọi sau mỗi lần trả lời trong TẤT CẢ các game:

```
FUNCTION updateUserVocabProgress(user, vocab, isCorrect):
    // Bước 1: Tìm progress hiện tại
    progress = FIND UserVocabProgress
               WHERE userId = user.id
               AND vocabId = vocab.id

    // Bước 2: Cập nhật hoặc tạo mới
    IF progress EXISTS THEN
        IF isCorrect THEN
            progress.timesCorrect++
        ELSE
            progress.timesWrong++
        END IF
    ELSE
        progress = NEW UserVocabProgress(
            user: user,
            vocab: vocab,
            timesCorrect: isCorrect ? 1 : 0,
            timesWrong: isCorrect ? 0 : 1
        )
    END IF

    // Bước 3: Lưu vào database
    SAVE(progress)
END FUNCTION
```

### 4.2. Save Game Session Detail

Lưu chi tiết từng câu hỏi/cặp ghép:

```
FUNCTION saveGameSessionDetail(session, vocab, isCorrect, timeTaken):
    detail = NEW GameSessionDetail(
        session: session,
        vocab: vocab,
        isCorrect: isCorrect,
        timeTaken: timeTaken
    )

    SAVE(detail)
END FUNCTION
```

### 4.3. Calculate Accuracy

```
FUNCTION calculateAccuracy(correctCount, totalQuestions):
    IF totalQuestions > 0 THEN
        accuracy = (correctCount × 100.0) / totalQuestions
    ELSE
        accuracy = 0
    END IF

    RETURN ROUND(accuracy, 2)  // Làm tròn 2 chữ số thập phân
END FUNCTION
```

---

## 5. 🎯 So Sánh Các Game

### 5.1. Bảng So Sánh Tính Năng

| Đặc điểm             | Quick Quiz        | Image-Word            | Word-Definition       |
| -------------------- | ----------------- | --------------------- | --------------------- |
| **Số lượng options** | 3                 | N pairs               | N pairs               |
| **Thời gian**        | 3s/câu            | Tự do                 | Tự do                 |
| **Điểm cơ bản**      | 10 điểm cố định   | CEFR-based (1-6)      | CEFR-based (1-6)      |
| **Streak bonus**     | ✅ Có             | ❌ Không              | ❌ Không              |
| **Speed bonus**      | ✅ < 1.5s (+5)    | ✅ Theo thang (0-50%) | ✅ Theo thang (0-50%) |
| **Yêu cầu hình ảnh** | ❌ Không          | ✅ Bắt buộc           | ❌ Không              |
| **Cache strategy**   | ConcurrentHashMap | Caffeine              | Caffeine              |
| **Validation**       | Index-based       | ID set matching       | ID set matching       |

### 5.2. Bảng So Sánh Scoring

| Điểm          | Quick Quiz        | Image/Word Matching  |
| ------------- | ----------------- | -------------------- |
| **Base**      | 10 (fixed)        | 1-6 (CEFR)           |
| **Streak**    | +5 per 3-combo    | None                 |
| **Speed**     | +5 if < 1.5s      | +0-50% based on time |
| **Max bonus** | No limit (streak) | +50% (< 10s)         |

### 5.3. Complexity Analysis

#### **Quick Quiz:**

-   **Sinh câu hỏi:** O(n) - n = totalQuestions
-   **Validate answer:** O(1) - direct index comparison
-   **Calculate streak:** O(m) - m = number of details (≤ n)
-   **Space:** O(n) - cache all questions

#### **Image-Word Matching:**

-   **Lọc vocabs:** O(v) - v = total vocabs in database
-   **Validate answer:** O(n) - n = totalPairs
-   **Calculate score:** O(n)
-   **Space:** O(n) - cache session data

#### **Word-Definition Matching:**

-   **Lọc vocabs:** O(v) - v = total vocabs
-   **Validate answer:** O(n) - n = totalPairs
-   **Calculate score:** O(n)
-   **Space:** O(n) - cache session data

---

## 6. 🔐 Security & Validation

### 6.1. Input Validation

```
FUNCTION validateStartRequest(request):
    // Validate totalQuestions/totalPairs
    IF request.total <= 0 OR request.total > 50 THEN
        THROW ERROR "Invalid quantity"
    END IF

    // Validate CEFR
    IF request.cefr NOT IN [null, "A1", "A2", "B1", "B2", "C1", "C2"] THEN
        THROW ERROR "Invalid CEFR level"
    END IF
END FUNCTION
```

### 6.2. Session Validation

```
FUNCTION validateSession(sessionId, userId):
    session = FIND GameSession WHERE id = sessionId

    IF session NOT EXISTS THEN
        THROW ERROR "Session không tồn tại"
    END IF

    IF session.userId != userId THEN
        THROW ERROR "Unauthorized access"
    END IF

    IF session.finishedAt != null THEN
        THROW ERROR "Session đã kết thúc"
    END IF

    RETURN session
END FUNCTION
```

### 6.3. Answer Validation

**Quick Quiz:**

```
FUNCTION validateQuizAnswer(request, cachedQuestion):
    IF request.selectedOptionIndex < 0
       OR request.selectedOptionIndex >= cachedQuestion.options.length THEN
        THROW ERROR "Invalid option index"
    END IF
END FUNCTION
```

**Matching Games:**

```
FUNCTION validateMatchingAnswer(submittedIds, sessionVocabs):
    // Kiểm tra số lượng
    IF submittedIds.length != sessionVocabs.length THEN
        THROW ERROR "Số lượng không khớp"
    END IF

    // Kiểm tra tất cả ID hợp lệ
    validIds = SET of sessionVocabs.map(v => v.id)
    FOR EACH id IN submittedIds DO
        IF id NOT IN validIds THEN
            THROW ERROR "Invalid vocab ID"
        END IF
    END FOR
END FUNCTION
```

---

## 7. 🚀 Performance Optimization

### 7.1. Caching Strategy

**Quick Quiz:**

-   ✅ Cache toàn bộ questions khi start game
-   ✅ Dùng ConcurrentHashMap cho thread-safety
-   ✅ Clear cache khi game finish

**Image/Word Matching:**

-   ✅ Cache session data với Caffeine
-   ✅ Auto-expire sau 30 phút
-   ✅ Maximum 10,000 sessions
-   ✅ Invalidate khi game complete

### 7.2. Database Optimization

```
// Pre-fetch vocabs với relationships
@Query("SELECT v FROM Vocab v LEFT JOIN FETCH v.topics WHERE ...")

// Batch save details
gameSessionDetailRepository.saveAll(details)

// Index trên các cột thường query
CREATE INDEX idx_vocab_cefr ON vocab(cefr)
CREATE INDEX idx_session_user ON game_session(user_id)
```

### 7.3. Memory Management

```
// Quick Quiz: Clear cache sau game
ON finishGame(sessionId):
    sessionQuestionsCache.remove(sessionId)

// Matching Games: Auto-expire với Caffeine
Caffeine.newBuilder()
    .expireAfterWrite(30, MINUTES)
    .maximumSize(10000)
```

---

## 8. 📈 Metrics & Analytics

### 8.1. Tracked Metrics

Mỗi game session lưu:

-   `totalQuestions` / `totalPairs`: Số câu hỏi/cặp
-   `correctCount`: Số câu đúng
-   `score`: Tổng điểm
-   `accuracy`: Độ chính xác (%)
-   `duration`: Thời gian hoàn thành (giây)
-   `startedAt`: Thời điểm bắt đầu
-   `finishedAt`: Thời điểm kết thúc

### 8.2. Calculated Stats

```
FUNCTION calculateGameStats(sessions):
    totalGames = sessions.length
    totalScore = SUM(sessions.map(s => s.score))
    avgScore = totalScore / totalGames
    avgAccuracy = AVG(sessions.map(s => s.accuracy))
    bestScore = MAX(sessions.map(s => s.score))
    totalTime = SUM(sessions.map(s => s.duration))

    RETURN GameStats(
        totalGames,
        avgScore,
        avgAccuracy,
        bestScore,
        totalTime
    )
END FUNCTION
```

---

## 9. 🔄 Game Flow Diagrams

### 9.1. Quick Quiz Flow

```
START
  ↓
[User chọn: totalQuestions, CEFR]
  ↓
[Lọc vocabs theo CEFR] → [Kiểm tra đủ số lượng?]
  ↓ YES                     ↓ NO
[Tạo GameSession]        [ERROR]
  ↓
[Generate tất cả questions & cache]
  ↓
[Gửi question 1 cho client]
  ↓
┌─────────────────────────┐
│ LOOP cho mỗi question:  │
│   [Client submit answer]│
│   ↓                     │
│   [Validate answer]     │
│   ↓                     │
│   [Calculate streak]    │
│   ↓                     │
│   [Calculate points]    │
│   ↓                     │
│   [Update progress]     │
│   ↓                     │
│   [Save detail]         │
│   ↓                     │
│   [Has next?]           │
│   ↓ YES    ↓ NO         │
│ [Next Q]  [Finish]      │
└─────────────────────────┘
  ↓
[Calculate final score & accuracy]
  ↓
[Clear cache]
  ↓
END
```

### 9.2. Matching Games Flow

```
START
  ↓
[User chọn: totalPairs, CEFR]
  ↓
[Lọc vocabs theo CEFR (+ img nếu là Image-Word)]
  ↓
[Kiểm tra đủ số lượng?]
  ↓ YES              ↓ NO
[Tạo GameSession]  [ERROR]
  ↓
[Cache session data]
  ↓
[Gửi tất cả vocabs cho client]
  ↓
[Client ghép các cặp]
  ↓
[Client submit matchedIds + timeTaken]
  ↓
[Validate session & số lượng]
  ↓
[FOR EACH vocab: Check if matched?]
  ↓
[Calculate CEFR score]
  ↓
[Calculate time bonus]
  ↓
[Total score = CEFR score + time bonus]
  ↓
[Update user progress cho mỗi vocab]
  ↓
[Save details]
  ↓
[Update session: score, accuracy, finishedAt]
  ↓
[Invalidate cache]
  ↓
END
```

---

## 10. 📝 API Examples

### 10.1. Quick Quiz

**Start Game:**

```http
POST /api/v1/quick-quiz/start
Content-Type: application/json

{
  "totalQuestions": 10,
  "cefr": "B1",
  "timePerQuestion": 3
}
```

**Submit Answer:**

```http
POST /api/v1/quick-quiz/answer
Content-Type: application/json

{
  "sessionId": 123,
  "questionNumber": 1,
  "selectedOptionIndex": 2,
  "timeTaken": 1200
}
```

### 10.2. Image-Word Matching

**Start Game:**

```http
POST /api/v1/image-word-matching/start
Content-Type: application/json

{
  "totalPairs": 5,
  "cefr": "A2"
}
```

**Submit Answer:**

```http
POST /api/v1/image-word-matching/submit
Content-Type: application/json

{
  "sessionId": 456,
  "matchedVocabIds": [
    "uuid1", "uuid2", "uuid3", "uuid4", "uuid5"
  ],
  "timeTaken": 15000
}
```

### 10.3. Word-Definition Matching

**Start Game:**

```http
POST /api/v1/word-definition-matching/start
Content-Type: application/json

{
  "totalPairs": 8,
  "cefr": "C1"
}
```

**Submit Answer:**

```http
POST /api/v1/word-definition-matching/submit
Content-Type: application/json

{
  "sessionId": 789,
  "matchedVocabIds": [
    "uuid1", "uuid2", "uuid3", "uuid4",
    "uuid5", "uuid6", "uuid7", "uuid8"
  ],
  "timeTaken": 25000
}
```

---

## 11. 🎓 Best Practices & Tips

### 11.1. Đối Với Người Chơi

**Quick Quiz:**

-   ⚡ Trả lời nhanh trong 1.5s để được speed bonus
-   🔥 Duy trì streak để nhận combo bonus
-   🎯 Chọn CEFR phù hợp với trình độ

**Image-Word Matching:**

-   🖼️ Quan sát kỹ hình ảnh trước khi ghép
-   ⏱️ Cố gắng hoàn thành dưới 10s để +50% điểm
-   📈 Chọn CEFR cao hơn để được điểm cao hơn

**Word-Definition Matching:**

-   📖 Đọc kỹ definition trước khi ghép
-   🚀 Hoàn thành nhanh để nhận time bonus
-   💡 Tập trung vào từ khó (C1, C2) để tối đa điểm

### 11.2. Đối Với Developer

**Code Quality:**

-   ✅ Validate input ở mọi endpoint
-   ✅ Handle exceptions properly
-   ✅ Log important events
-   ✅ Use transactions cho consistency

**Performance:**

-   🚀 Cache sessions để giảm DB load
-   🎯 Pre-fetch relationships
-   📊 Index các cột thường query
-   💾 Clear cache khi không cần

**Security:**

-   🔐 Validate session ownership
-   🛡️ Check session status
-   🔒 Sanitize user input
-   ✋ Rate limiting cho APIs

---

## 12. 🔧 Troubleshooting

### 12.1. Common Issues

**Issue: "Không đủ từ vựng"**

```
Nguyên nhân:
- Filter CEFR quá chặt
- Không đủ từ có hình ảnh (Image-Word)
- Database thiếu data

Giải pháp:
- Giảm totalQuestions/totalPairs
- Bỏ CEFR filter
- Import thêm vocabs
```

**Issue: "Session không tồn tại"**

```
Nguyên nhân:
- Session đã expire (>30 phút)
- Cache bị clear
- SessionId sai

Giải pháp:
- Start game mới
- Kiểm tra sessionId
```

**Issue: "Số lượng vocab không khớp"**

```
Nguyên nhân:
- Client gửi thiếu/thừa IDs
- Duplicate IDs

Giải pháp:
- Validate trước khi submit
- Use Set để loại bỏ duplicate
```

---

## 📚 Tài Liệu Tham Khảo

1. **CEFR Levels:** Common European Framework of Reference for Languages
2. **Caffeine Cache:** High-performance Java caching library
3. **Spaced Repetition:** Algorithm for optimal learning retention
4. **Game Design Patterns:** Best practices for educational games

---

**Phiên bản:** 1.0  
**Ngày cập nhật:** 2025-10-24  
**Tác giả:** Development Team
