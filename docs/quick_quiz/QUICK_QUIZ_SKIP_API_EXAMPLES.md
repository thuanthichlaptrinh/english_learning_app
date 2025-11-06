# Quick Quiz API - Skip/Timeout Examples

## 🎯 API Endpoint

```
POST /api/v1/games/quick-quiz/skip
```

## 📝 Request Examples

### Example 1: Timeout tự động (hết 3 giây)

**Request:**

```json
POST /api/v1/games/quick-quiz/skip
Content-Type: application/json
Authorization: Bearer YOUR_JWT_TOKEN

{
  "sessionId": 123,
  "questionNumber": 3,
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
    "questionNumber": 3,
    "isCorrect": false,
    "correctAnswerIndex": 2,
    "currentScore": 25,
    "currentStreak": 0,
    "comboBonus": 0,
    "explanation": "⏱ Hết giờ! Đáp án đúng: apple nghĩa là táo",
    "hasNextQuestion": true,
    "nextQuestion": {
      "questionNumber": 4,
      "vocabId": "uuid-here",
      "word": "banana",
      "transcription": "/bəˈnɑːnə/",
      "meaningVi": null,
      "interpret": null,
      "exampleSentence": "I eat a banana every morning",
      "cefr": "A1",
      "img": "https://...",
      "audio": "https://...",
      "credit": null,
      "options": [
        {
          "word": "banana",
          "meaningVi": "chuối",
          ...
        },
        {
          "word": "orange",
          "meaningVi": "cam",
          ...
        },
        {
          "word": "grape",
          "meaningVi": "nho",
          ...
        },
        {
          "word": "mango",
          "meaningVi": "xoài",
          ...
        }
      ],
      "correctAnswerIndex": null,
      "timeLimit": 3000
    }
  }
}
```

### Example 2: User bấm "Bỏ qua" (không biết đáp án)

**Request:**

```json
POST /api/v1/games/quick-quiz/skip
Content-Type: application/json
Authorization: Bearer YOUR_JWT_TOKEN

{
  "sessionId": 123,
  "questionNumber": 7,
  "timeTaken": 1500
}
```

**Response:** _(tương tự Example 1)_

### Example 3: Skip câu cuối cùng (game kết thúc)

**Request:**

```json
POST /api/v1/games/quick-quiz/skip
Content-Type: application/json
Authorization: Bearer YOUR_JWT_TOKEN

{
  "sessionId": 123,
  "questionNumber": 10,
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
        "questionNumber": 10,
        "isCorrect": false,
        "correctAnswerIndex": 1,
        "currentScore": 65,
        "currentStreak": 0,
        "comboBonus": 0,
        "explanation": "⏱ Hết giờ! Đáp án đúng: computer nghĩa là máy tính",
        "hasNextQuestion": false,
        "nextQuestion": null
    }
}
```

Sau đó gọi:

```
GET /api/v1/games/quick-quiz/session/123
```

để xem kết quả cuối cùng.

## ⚠️ Error Cases

### Error 1: Session không tồn tại

```json
{
    "success": false,
    "message": "Game session not found",
    "data": null
}
```

### Error 2: Session đã kết thúc

```json
{
    "success": false,
    "message": "Game session already finished",
    "data": null
}
```

### Error 3: Câu hỏi đã trả lời rồi

```json
{
    "success": false,
    "message": "Question already answered. Cannot submit again.",
    "data": null
}
```

### Error 4: Question number không hợp lệ

```json
{
    "success": false,
    "message": "Invalid question number",
    "data": null
}
```

### Error 5: Unauthorized (không phải session của mình)

```json
{
    "success": false,
    "message": "Unauthorized: This session belongs to another user",
    "data": null
}
```

## 🔄 Complete Flow Example

### 1. Start Game

```bash
POST /api/v1/games/quick-quiz/start
{
  "totalQuestions": 10,
  "timePerQuestion": 3,
  "cefr": "A1"
}

→ Response: sessionId = 123, Question 1
```

### 2. Answer Question 1 (Correct)

```bash
POST /api/v1/games/quick-quiz/answer
{
  "sessionId": 123,
  "questionNumber": 1,
  "selectedOptionIndex": 2,
  "timeTaken": 1200
}

→ Score: 15 (base 10 + speed 5)
→ Streak: 1
```

### 3. Answer Question 2 (Correct)

```bash
POST /api/v1/games/quick-quiz/answer
{
  "sessionId": 123,
  "questionNumber": 2,
  "selectedOptionIndex": 0,
  "timeTaken": 1800
}

→ Score: 25 (15 + 10)
→ Streak: 2
```

### 4. Skip Question 3 (Timeout)

```bash
POST /api/v1/games/quick-quiz/skip
{
  "sessionId": 123,
  "questionNumber": 3,
  "timeTaken": 3000
}

→ Score: 25 (không cộng)
→ Streak: 0 (reset)
```

### 5. Answer Question 4 (Correct)

```bash
POST /api/v1/games/quick-quiz/answer
{
  "sessionId": 123,
  "questionNumber": 4,
  "selectedOptionIndex": 1,
  "timeTaken": 2100
}

→ Score: 35 (25 + 10)
→ Streak: 1 (bắt đầu lại)
```

### 6. Continue until Question 10...

### 7. Get Final Results

```bash
GET /api/v1/games/quick-quiz/session/123

→ Response: {
  "totalQuestions": 10,
  "correctCount": 7,
  "wrongCount": 3,
  "totalScore": 95,
  "accuracy": 70.0,
  "results": [...]
}
```

## 📊 Statistics Impact

| Metric          | Skip/Timeout Effect       |
| --------------- | ------------------------- |
| Total Questions | +1 (counted)              |
| Correct Count   | No change                 |
| Wrong Count     | +1                        |
| Score           | No change (0 points)      |
| Streak          | Reset to 0                |
| Accuracy        | Decrease (tính là sai)    |
| Avg Time        | Affected (3000ms counted) |

## 🧪 Postman Collection

```json
{
    "info": {
        "name": "Quick Quiz - Skip/Timeout",
        "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
    },
    "item": [
        {
            "name": "Skip Question (Timeout)",
            "request": {
                "method": "POST",
                "header": [
                    {
                        "key": "Content-Type",
                        "value": "application/json"
                    },
                    {
                        "key": "Authorization",
                        "value": "Bearer {{jwt_token}}"
                    }
                ],
                "body": {
                    "mode": "raw",
                    "raw": "{\n  \"sessionId\": {{sessionId}},\n  \"questionNumber\": {{questionNumber}},\n  \"timeTaken\": 3000\n}"
                },
                "url": {
                    "raw": "{{base_url}}/api/v1/games/quick-quiz/skip",
                    "host": ["{{base_url}}"],
                    "path": ["api", "v1", "games", "quick-quiz", "skip"]
                }
            }
        }
    ]
}
```

## 🎮 Frontend Integration

### React/Vue Example

```javascript
// Timer component
const QuickQuizTimer = ({ timeLimit, onTimeout }) => {
    const [timeLeft, setTimeLeft] = useState(timeLimit);

    useEffect(() => {
        if (timeLeft === 0) {
            onTimeout();
            return;
        }

        const timer = setTimeout(() => {
            setTimeLeft(timeLeft - 1);
        }, 1000);

        return () => clearTimeout(timer);
    }, [timeLeft]);

    return <div className={`timer ${timeLeft <= 1 ? 'warning' : ''}`}>⏱ {timeLeft}s</div>;
};

// Main component
const handleTimeout = async () => {
    const response = await fetch('/api/v1/games/quick-quiz/skip', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({
            sessionId: currentSession.id,
            questionNumber: currentQuestionNumber,
            timeTaken: timeLimit * 1000,
        }),
    });

    const result = await response.json();

    // Show timeout message
    showMessage('⏱ Hết giờ!', result.data.explanation);

    // Load next question or finish
    if (result.data.hasNextQuestion) {
        loadQuestion(result.data.nextQuestion);
    } else {
        showResults(result.data.sessionId);
    }
};
```

## ✅ Testing Checklist

-   [ ] Test timeout tự động (đợi 3 giây)
-   [ ] Test skip thủ công (bấm nút)
-   [ ] Test skip khi còn streak
-   [ ] Test skip ở câu đầu tiên
-   [ ] Test skip ở câu cuối cùng
-   [ ] Test skip nhiều câu liên tiếp
-   [ ] Test game completion có skip
-   [ ] Verify database lưu đúng (isCorrect = false)
-   [ ] Verify cache cleanup
-   [ ] Verify streak reset
-   [ ] Verify accuracy calculation
