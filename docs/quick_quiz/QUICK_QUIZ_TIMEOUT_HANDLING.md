# Quick Quiz - Xử lý Timeout và Skip Questions

## 📋 Vấn đề

Trước đây, nếu người dùng không gửi answer (bỏ câu hỏi, treo app, mất kết nối), game session sẽ:

-   ❌ Bị treo mãi mãi (không bao giờ hoàn thành)
-   ❌ Cache không được dọn dẹp (memory leak)
-   ❌ Người dùng có thể "gian lận" bằng cách nghiên cứu đáp án trước khi submit
-   ❌ Không có cách nào để hoàn thành game

## ✅ Giải pháp

### 1. **Skip/Timeout Endpoint**

Thêm endpoint mới cho phép client bỏ qua câu hỏi khi timeout:

```http
POST /api/v1/games/quick-quiz/skip
```

**Request Body:**

```json
{
    "sessionId": 123,
    "questionNumber": 5,
    "timeTaken": 3000
}
```

**Response:**

```json
{
    "success": true,
    "message": "⏭ Đã bỏ qua câu hỏi (timeout)",
    "data": {
        "sessionId": 123,
        "questionNumber": 5,
        "isCorrect": false,
        "correctAnswerIndex": 2,
        "currentScore": 50,
        "currentStreak": 0,
        "comboBonus": 0,
        "explanation": "⏱ Hết giờ! Đáp án đúng: apple nghĩa là táo",
        "hasNextQuestion": true,
        "nextQuestion": {
            /* câu hỏi tiếp theo */
        }
    }
}
```

### 2. **Logic xử lý Skip**

#### Trong `QuickQuizService.skipQuestion()`:

1. ✅ Validate session (giống submitAnswer)
2. ✅ Đánh dấu câu hỏi là **SAI** (isCorrect = false)
3. ✅ **Không cộng điểm** (0 points)
4. ✅ **Reset streak** về 0
5. ✅ Update vocab progress (mark as wrong cho spaced repetition)
6. ✅ Trả về câu hỏi tiếp theo hoặc kết thúc game
7. ✅ Cleanup cache nếu là câu cuối

#### Trong `processSkippedAnswer()`:

```java
private AnswerResult processSkippedAnswer(GameSession session, QuestionData questionData, Integer timeTaken) {
    // Skipped = wrong answer
    // No points earned
    // Streak reset to 0
    // Save as incorrect in database
}
```

### 3. **Client Implementation**

#### Frontend Timer Logic:

```javascript
// Trong component QuickQuiz
let timer;

function startQuestionTimer(timeLimit) {
    timer = setTimeout(() => {
        // Hết giờ -> tự động skip
        handleTimeout();
    }, timeLimit);
}

function handleTimeout() {
    clearTimeout(timer);

    // Gọi API skip
    fetch('/api/v1/games/quick-quiz/skip', {
        method: 'POST',
        body: JSON.stringify({
            sessionId: currentSession.id,
            questionNumber: currentQuestionNumber,
            timeTaken: timeLimit, // Full time limit
        }),
    })
        .then((response) => response.json())
        .then((data) => {
            // Hiển thị "Hết giờ!"
            showTimeoutMessage(data.explanation);

            // Chuyển sang câu tiếp theo
            if (data.hasNextQuestion) {
                loadNextQuestion(data.nextQuestion);
            } else {
                // Game kết thúc
                showGameResults(data.sessionId);
            }
        });
}

function submitAnswer(selectedIndex) {
    clearTimeout(timer); // Dừng timer

    // Gọi API submit answer bình thường
    // ...
}
```

### 4. **Hệ quả của Skip/Timeout**

| Khía cạnh          | Kết quả                               |
| ------------------ | ------------------------------------- |
| **Điểm số**        | 0 điểm (không cộng)                   |
| **Streak**         | Reset về 0                            |
| **Accuracy**       | Giảm (tính là sai)                    |
| **Vocab Progress** | Đánh dấu là "Wrong"                   |
| **Next Review**    | Đưa vào danh sách cần ôn lại          |
| **Game Flow**      | Chuyển sang câu tiếp theo bình thường |

### 5. **Anti-Cheat Measures**

#### Đã có sẵn:

-   ✅ Server-side timestamp validation
-   ✅ Min answer time (100ms) để chống bot
-   ✅ Max time limit validation
-   ✅ Network latency tolerance (3s)

#### Thêm mới với Skip:

-   ✅ Skip được tính là **SAI** → không lợi cho gian lận
-   ✅ Không có cách nào để "pause" game để tra cứu
-   ✅ Rate limiting (10 games / 5 phút)

### 6. **UX/UI Improvements**

#### Recommended:

1. **Visual Timer**: Hiển thị countdown timer rõ ràng

    ```
    ⏱ 3... 2... 1... ⏱
    ```

2. **Warning**: Cảnh báo khi còn 1 giây

    ```
    ⚠️ Còn 1 giây! ⚠️
    ```

3. **Timeout Animation**: Hiệu ứng khi hết giờ

    ```
    🔴 HẾT GIỜ! 🔴
    Đáp án đúng: apple = táo
    ```

4. **Manual Skip Button** (Optional): Cho phép user tự skip
    ```
    [⏭ Bỏ qua (không biết)]
    ```

### 7. **Hướng dẫn cập nhật cho người chơi**

Thêm vào `/instructions`:

```markdown
⚡ Lưu ý về Thời gian:

-   Mỗi câu hỏi có 3 giây để trả lời
-   Nếu hết giờ, câu hỏi sẽ tự động bị bỏ qua
-   Câu bỏ qua = trả lời SAI (0 điểm, mất combo)
-   Hãy trả lời nhanh để được speed bonus!
```

### 8. **Testing Checklist**

-   [ ] Test timeout tự động sau 3 giây
-   [ ] Test manual skip button (nếu có)
-   [ ] Test skip ở câu đầu tiên
-   [ ] Test skip ở câu cuối cùng
-   [ ] Test skip nhiều câu liên tiếp
-   [ ] Test streak reset sau skip
-   [ ] Test game completion với có câu skip
-   [ ] Test network disconnection scenario
-   [ ] Test cache cleanup sau skip

### 9. **Database Schema**

Không cần thay đổi schema. `GameSessionDetail` đã có:

```sql
CREATE TABLE game_session_details (
  ...
  is_correct BOOLEAN,  -- FALSE cho skip
  time_taken INTEGER,  -- timeLimit cho skip
  ...
);
```

### 10. **Future Enhancements**

#### Có thể thêm sau:

1. **Grace Period**: Cho thêm 0.5s để xử lý network lag
2. **Skip Stats**: Thống kê số câu skip / session
3. **Penalty Options**: Config có phạt điểm khi skip không
4. **Pause Feature**: Cho phép pause 1 lần/game (cho emergency)
5. **Auto-resume**: Tự động resume nếu mất kết nối < 5s

## 📊 Ví dụ Flow hoàn chỉnh

### Scenario: User timeout ở câu 5

1. **Client**: Start question 5 → Start timer (3000ms)
2. **User**: Không làm gì cả
3. **Timer**: Hết 3 giây → trigger `handleTimeout()`
4. **Client**: POST `/api/v1/games/quick-quiz/skip`
    ```json
    {
        "sessionId": 123,
        "questionNumber": 5,
        "timeTaken": 3000
    }
    ```
5. **Server**:
    - Mark question 5 as WRONG
    - Reset streak to 0
    - Save to database
    - Return next question (question 6)
6. **Client**: Show timeout message + load question 6
7. **User**: Continue playing normally

## 🎯 Kết luận

✅ **Vấn đề đã được giải quyết**:

-   Game không còn bị treo
-   Cache được dọn dẹp đúng cách
-   User experience được cải thiện
-   Không có lỗ hổng gian lận

✅ **API đã sẵn sàng**:

-   Endpoint: `POST /api/v1/games/quick-quiz/skip`
-   Logic: `QuickQuizService.skipQuestion()`
-   Testing: Cần test trên frontend

✅ **Cần làm tiếp**:

-   Implement frontend timer
-   Implement auto-skip khi timeout
-   Test toàn bộ flow
-   Cập nhật UI/UX cho timeout case
