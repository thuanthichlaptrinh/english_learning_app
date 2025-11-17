# Quick Quiz - Timeout Handling Summary

## ✅ Đã hoàn thành

### 1. Backend API

-   ✅ **Endpoint mới**: `POST /api/v1/games/quick-quiz/skip`
-   ✅ **Service method**: `QuickQuizService.skipQuestion()`
-   ✅ **Helper method**: `processSkippedAnswer()`
-   ✅ **DTO updated**: `QuickQuizAnswerRequest` - `selectedOptionIndex` giờ nullable

### 2. Logic xử lý Skip/Timeout

```
Skip/Timeout → isCorrect = FALSE
              → pointsEarned = 0
              → currentStreak = 0
              → Save to database
              → Update vocab progress (wrong)
              → Next question or finish game
```

### 3. Files đã sửa

1. `QuickQuizController.java` - Thêm endpoint `/skip`
2. `QuickQuizService.java` - Thêm methods `skipQuestion()` và `processSkippedAnswer()`
3. `QuickQuizAnswerRequest.java` - Cho phép `selectedOptionIndex` = null

### 4. Documentation

1. `QUICK_QUIZ_TIMEOUT_HANDLING.md` - Chi tiết về giải pháp
2. `QUICK_QUIZ_SKIP_API_EXAMPLES.md` - Ví dụ API và integration

## 🎯 Kết quả

### Trước (có vấn đề):

```
User không gửi answer
  ↓
❌ Game session bị treo mãi
❌ Cache không được dọn
❌ Không có cách hoàn thành game
❌ Có thể gian lận
```

### Sau (đã fix):

```
User không gửi answer (timeout)
  ↓
✅ Frontend tự động gọi /skip
✅ Server mark câu là SAI
✅ Reset streak về 0
✅ Chuyển sang câu tiếp theo
✅ Game hoàn thành bình thường
✅ Cache được cleanup
```

## 📋 Cần làm tiếp (Frontend)

### 1. Implement Timer

```javascript
// Countdown timer cho mỗi câu hỏi
useEffect(() => {
    const timer = setTimeout(() => {
        handleTimeout();
    }, timeLimit * 1000);

    return () => clearTimeout(timer);
}, [currentQuestion]);
```

### 2. Handle Timeout

```javascript
const handleTimeout = async () => {
    // Call skip API
    const response = await fetch('/api/v1/games/quick-quiz/skip', {
        method: 'POST',
        body: JSON.stringify({
            sessionId,
            questionNumber,
            timeTaken: timeLimit * 1000,
        }),
    });

    // Show message and next question
    const data = await response.json();
    showTimeoutMessage(data.explanation);
    loadNextQuestion(data.nextQuestion);
};
```

### 3. UI/UX

-   [ ] Hiển thị countdown timer (⏱ 3... 2... 1...)
-   [ ] Warning khi còn 1 giây (⚠️ màu đỏ)
-   [ ] Animation "HẾT GIỜ!" khi timeout
-   [ ] Hiển thị đáp án đúng sau timeout
-   [ ] (Optional) Nút "Bỏ qua" cho user không biết

### 4. Testing

-   [ ] Test auto-skip sau 3 giây
-   [ ] Test streak reset
-   [ ] Test game completion với có skip
-   [ ] Test network disconnection
-   [ ] Test multiple skip liên tiếp

## 🔄 API Usage

### Normal Answer

```http
POST /api/v1/games/quick-quiz/answer
{
  "sessionId": 123,
  "questionNumber": 5,
  "selectedOptionIndex": 2,
  "timeTaken": 1500
}
```

### Skip/Timeout

```http
POST /api/v1/games/quick-quiz/skip
{
  "sessionId": 123,
  "questionNumber": 5,
  "selectedOptionIndex": null,  // Không cần
  "timeTaken": 3000
}
```

## 📊 Impact Analysis

| Aspect              | Before                 | After                 |
| ------------------- | ---------------------- | --------------------- |
| **Stuck Sessions**  | ❌ Có thể bị treo      | ✅ Không bao giờ treo |
| **Memory Leaks**    | ❌ Cache không dọn     | ✅ Auto cleanup       |
| **User Experience** | ❌ Game không kết thúc | ✅ Luôn hoàn thành    |
| **Data Integrity**  | ❌ Thiếu data          | ✅ Đầy đủ data        |
| **Anti-Cheat**      | ⚠️ Có thể gian lận     | ✅ Không lợi khi skip |

## 🎮 Game Balancing

### Penalties cho Skip/Timeout:

1. ✅ **0 điểm** - Không cộng điểm
2. ✅ **Streak reset** - Mất combo
3. ✅ **Tính là SAI** - Giảm accuracy
4. ✅ **Mark as WRONG** - Phải ôn lại vocab

### Fairness:

-   Skip/Timeout = Wrong Answer
-   Không có lợi thế gì khi skip
-   Khuyến khích trả lời nhanh và đúng

## 🚀 Deployment Notes

### Backend (Ready):

-   ✅ Code đã merge-ready
-   ✅ Không breaking changes
-   ✅ Backward compatible
-   ✅ Database không cần migrate

### Frontend (TODO):

-   ⏳ Implement timer logic
-   ⏳ Call skip API on timeout
-   ⏳ Update UI/UX
-   ⏳ Testing

### Testing Checklist:

```bash
# 1. Start game
POST /api/v1/games/quick-quiz/start

# 2. Answer some questions
POST /api/v1/games/quick-quiz/answer (x3)

# 3. Skip one question
POST /api/v1/games/quick-quiz/skip

# 4. Continue answering
POST /api/v1/games/quick-quiz/answer (x6)

# 5. Check results
GET /api/v1/games/quick-quiz/session/{id}

# Verify:
# - correctCount + wrongCount = totalQuestions
# - Skip được tính vào wrongCount
# - Score đúng (không tính điểm skip)
# - Streak reset after skip
```

## 🎯 Success Criteria

✅ **Done when**:

1. User timeout → Auto skip → Next question
2. Game luôn hoàn thành (không bị treo)
3. Cache được cleanup sau game
4. Data được lưu đầy đủ trong database
5. UI hiển thị rõ ràng timeout message
6. Testing pass toàn bộ scenarios

## 📞 Support

Nếu có issues:

1. Check logs: `QuickQuizService.skipQuestion()`
2. Verify database: `game_session_details` có record với `is_correct = false`
3. Check cache: Session đã bị remove sau game finish
4. Frontend console: API call `/skip` có thành công không

## 📚 Related Docs

1. `QUICK_QUIZ_TIMEOUT_HANDLING.md` - Chi tiết technical
2. `QUICK_QUIZ_SKIP_API_EXAMPLES.md` - API examples
3. `QUICK_QUIZ_API_GUIDE.md` - Original API guide
