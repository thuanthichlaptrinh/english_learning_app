# 📚 API Ôn Tập Từ Vựng (Flashcard Review API)

## 🎯 Tổng quan

API ôn tập từ vựng sử dụng **thuật toán SM-2 (SuperMemo 2)** để tối ưu hóa quá trình ghi nhớ từ vựng dài hạn thông qua phương pháp **Spaced Repetition** (Lặp lại ngắt quãng).

### ✨ Tính năng chính

-   Lấy danh sách flashcard cần ôn tập hôm nay
-   Gửi đánh giá chất lượng ôn tập (quality rating 0-5)
-   Tự động tính toán lịch ôn tập tiếp theo dựa trên thuật toán SM-2
-   Theo dõi tiến độ học tập (timesCorrect, timesWrong, status)
-   Thống kê ôn tập hôm nay

---

## 🧮 Thuật toán SM-2

### Quality Rating (0-5)

| Điểm  | Mô tả             | Ý nghĩa                             |
| ----- | ----------------- | ----------------------------------- |
| **5** | Perfect           | Nhớ hoàn hảo, dễ dàng               |
| **4** | Correct           | Đúng nhưng hơi do dự                |
| **3** | Correct           | Đúng nhưng khó nhớ                  |
| **2** | Incorrect         | Sai nhưng gần đúng                  |
| **1** | Incorrect         | Sai nhưng quen thuộc khi xem đáp án |
| **0** | Complete blackout | Hoàn toàn không nhớ                 |

### Công thức tính toán

```
1. Easiness Factor (EF):
   - Giá trị khởi tạo: 2.5
   - EF mới = EF cũ + (0.1 - (5 - quality) × (0.08 + (5 - quality) × 0.02))
   - EF tối thiểu: 1.3

2. Interval (Khoảng thời gian ôn tập):
   - Nếu quality < 3: Bắt đầu lại (interval = 1 ngày)
   - Lần 1: 1 ngày
   - Lần 2: 6 ngày
   - Lần 3+: interval = interval_trước × EF

3. Status (Trạng thái):
   - NEW: Từ mới chưa ôn tập
   - LEARNING: Đang học (interval ≤ 21 ngày)
   - MASTERED: Đã thuộc (interval > 21 ngày)
```

### Ví dụ thực tế

```
Ngày 1: Học từ "apple"
  → Quality: 4
  → Interval: 1 ngày
  → Next review: Ngày 2

Ngày 2: Ôn "apple"
  → Quality: 5
  → Interval: 6 ngày
  → Next review: Ngày 8

Ngày 8: Ôn "apple"
  → Quality: 4
  → EF: 2.5 → 2.4
  → Interval: 6 × 2.4 = 14 ngày
  → Next review: Ngày 22

Ngày 22: Ôn "apple"
  → Quality: 5
  → EF: 2.4 → 2.5
  → Interval: 14 × 2.5 = 35 ngày
  → Status: MASTERED (interval > 21)
  → Next review: Ngày 57
```

---

## 📡 API Endpoints

### 1. Lấy danh sách flashcard cần ôn tập

**GET** `/api/v1/flashcard-review/due`

Lấy tất cả flashcard đến hạn ôn tập hôm nay.

#### Headers

```
Authorization: Bearer {token}
```

#### Query Parameters

| Tham số | Type    | Bắt buộc | Mô tả                                        |
| ------- | ------- | -------- | -------------------------------------------- |
| limit   | Integer | Không    | Số lượng flashcard tối đa (mặc định: tất cả) |

#### Response

```json
{
    "success": true,
    "message": "Lấy danh sách flashcard cần ôn tập thành công",
    "data": {
        "totalDueCards": 15,
        "reviewedToday": 0,
        "remainingCards": 15,
        "flashcards": [
            {
                "vocabId": "uuid",
                "word": "apple",
                "transcription": "/ˈæp.əl/",
                "meaningVi": "quả táo",
                "interpret": "A round fruit with red or green skin",
                "exampleSentence": "I eat an apple every day.",
                "img": "https://example.com/apple.jpg",
                "audio": "https://example.com/apple.mp3",
                "lastReviewed": "2025-10-15",
                "nextReviewDate": "2025-10-16",
                "timesCorrect": 3,
                "timesWrong": 1,
                "repetition": 3,
                "efFactor": 2.4,
                "intervalDays": 14,
                "status": "LEARNING"
            }
        ]
    }
}
```

---

### 2. Lấy thông tin một flashcard

**GET** `/api/v1/flashcard-review/flashcard/{vocabId}`

Lấy chi tiết flashcard của một từ vựng cụ thể.

#### Headers

```
Authorization: Bearer {token}
```

#### Path Parameters

| Tham số | Type | Mô tả          |
| ------- | ---- | -------------- |
| vocabId | UUID | ID của từ vựng |

#### Response

```json
{
    "success": true,
    "message": "Lấy thông tin flashcard thành công",
    "data": {
        "vocabId": "uuid",
        "word": "book",
        "transcription": "/bʊk/",
        "meaningVi": "sách",
        "interpret": "A set of printed pages bound together",
        "exampleSentence": "She is reading a book.",
        "img": "https://example.com/book.jpg",
        "audio": "https://example.com/book.mp3",
        "lastReviewed": null,
        "nextReviewDate": "2025-10-16",
        "timesCorrect": 0,
        "timesWrong": 0,
        "repetition": 0,
        "efFactor": 2.5,
        "intervalDays": 1,
        "status": "NEW"
    }
}
```

---

### 3. Gửi kết quả ôn tập ⭐

**POST** `/api/v1/flashcard-review/submit`

Gửi đánh giá chất lượng ôn tập và cập nhật tiến độ.

#### Headers

```
Authorization: Bearer {token}
Content-Type: application/json
```

#### Request Body

```json
{
    "vocabId": "uuid",
    "quality": 4,
    "timeSpentSeconds": 15
}
```

| Trường           | Type    | Bắt buộc | Mô tả                     |
| ---------------- | ------- | -------- | ------------------------- |
| vocabId          | UUID    | Có       | ID của từ vựng            |
| quality          | Integer | Có       | Đánh giá chất lượng (0-5) |
| timeSpentSeconds | Integer | Không    | Thời gian ôn tập (giây)   |

#### Response

```json
{
    "success": true,
    "message": "Gửi kết quả ôn tập thành công",
    "data": {
        "vocabId": "uuid",
        "word": "apple",
        "quality": 4,
        "timesCorrect": 4,
        "timesWrong": 1,
        "repetition": 4,
        "efFactor": 2.4,
        "intervalDays": 33,
        "nextReviewDate": "2025-11-18",
        "status": "MASTERED",
        "remainingDueCards": 14,
        "totalReviewedToday": 0,
        "message": "Great job! 👍 Review scheduled in 33 day(s)."
    }
}
```

#### Thông điệp khuyến khích

| Quality | Message                                           |
| ------- | ------------------------------------------------- |
| 5       | "Perfect! 🌟 You'll see this again in X day(s)."  |
| 4       | "Great job! 👍 Review scheduled in X day(s)."     |
| 3       | "Good! Keep practicing. Next review in X day(s)." |
| 2       | "Almost there! 💪 You'll review this soon."       |
| 1       | "Don't worry, practice makes perfect! 📚"         |
| 0       | "Let's review this again tomorrow! 🎯"            |

---

### 4. Thống kê ôn tập hôm nay

**GET** `/api/v1/flashcard-review/stats`

Lấy thống kê số lượng flashcard đã ôn tập và còn lại.

#### Headers

```
Authorization: Bearer {token}
```

#### Response

```json
{
    "success": true,
    "message": "Lấy thống kê ôn tập thành công",
    "data": {
        "totalDueCards": 15,
        "reviewedToday": 0,
        "remainingCards": 15,
        "flashcards": []
    }
}
```

---

## 🔄 Workflow ôn tập điển hình

```
1. User mở app
   ↓
2. GET /flashcard-review/due?limit=10
   → Lấy 10 flashcard cần ôn tập
   ↓
3. Hiển thị từ vựng đầu tiên
   → User đọc từ → Nghĩ nghĩa → Lật flashcard
   ↓
4. User đánh giá quality (0-5)
   ↓
5. POST /flashcard-review/submit
   {
     "vocabId": "uuid",
     "quality": 4
   }
   → Cập nhật progress, tính next review date
   ↓
6. Nhận response với remainingDueCards
   ↓
7. Nếu còn flashcard → Quay lại bước 3
   Nếu hết → Hiển thị thông báo hoàn thành
```

---

## 📊 Database Schema

### Table: `user_vocab_progress`

| Column           | Type        | Description                 |
| ---------------- | ----------- | --------------------------- |
| id               | UUID        | Primary key                 |
| user_id          | UUID        | FK to users                 |
| vocab_id         | UUID        | FK to vocab                 |
| status           | VARCHAR(50) | NEW, LEARNING, MASTERED     |
| last_reviewed    | DATE        | Ngày ôn tập gần nhất        |
| times_correct    | INTEGER     | Số lần trả lời đúng         |
| times_wrong      | INTEGER     | Số lần trả lời sai          |
| ef_factor        | DOUBLE      | Easiness Factor (SM-2)      |
| interval_days    | INTEGER     | Khoảng thời gian ôn tập     |
| repetition       | INTEGER     | Số lần đã ôn tập thành công |
| next_review_date | DATE        | Ngày ôn tập tiếp theo       |

---

## 🎨 Frontend Integration Tips

### 1. Flashcard Component

```jsx
const FlashcardReview = () => {
    const [flashcard, setFlashcard] = useState(null);
    const [showAnswer, setShowAnswer] = useState(false);

    const handleFlip = () => setShowAnswer(!showAnswer);

    const handleReview = async (quality) => {
        await axios.post('/api/v1/flashcard-review/submit', {
            vocabId: flashcard.vocabId,
            quality,
        });
        loadNextFlashcard();
    };

    return (
        <div className="flashcard">
            {!showAnswer ? (
                <div onClick={handleFlip}>
                    <h1>{flashcard.word}</h1>
                    <p>{flashcard.transcription}</p>
                </div>
            ) : (
                <div>
                    <h1>{flashcard.word}</h1>
                    <p>{flashcard.meaningVi}</p>
                    <p>{flashcard.exampleSentence}</p>

                    <div className="quality-buttons">
                        <button onClick={() => handleReview(0)}>❌ Không nhớ</button>
                        <button onClick={() => handleReview(1)}>😕 Quen quen</button>
                        <button onClick={() => handleReview(2)}>🤔 Gần đúng</button>
                        <button onClick={() => handleReview(3)}>😊 Đúng nhưng khó</button>
                        <button onClick={() => handleReview(4)}>😃 Đúng</button>
                        <button onClick={() => handleReview(5)}>🌟 Hoàn hảo</button>
                    </div>
                </div>
            )}
        </div>
    );
};
```

### 2. Progress Tracking

```jsx
const ReviewProgress = () => {
    const [stats, setStats] = useState(null);

    useEffect(() => {
        const fetchStats = async () => {
            const response = await axios.get('/api/v1/flashcard-review/stats');
            setStats(response.data.data);
        };
        fetchStats();
    }, []);

    return (
        <div className="review-progress">
            <h3>📊 Tiến độ hôm nay</h3>
            <p>Tổng cần ôn: {stats?.totalDueCards}</p>
            <p>Đã ôn: {stats?.reviewedToday}</p>
            <p>Còn lại: {stats?.remainingCards}</p>
            <ProgressBar value={stats?.reviewedToday} max={stats?.totalDueCards} />
        </div>
    );
};
```

---

## 🧪 Testing với Postman/cURL

### Get Due Flashcards

```bash
curl -X GET "http://localhost:8080/api/v1/flashcard-review/due?limit=5" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### Submit Review

```bash
curl -X POST "http://localhost:8080/api/v1/flashcard-review/submit" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "vocabId": "123e4567-e89b-12d3-a456-426614174000",
    "quality": 4
  }'
```

---

## 📈 Best Practices

### 1. Daily Review

-   Khuyến khích user ôn tập **mỗi ngày**
-   Hiển thị số lượng flashcard cần ôn tập trên notification

### 2. Quality Rating Guidelines

-   Cung cấp **hướng dẫn rõ ràng** cho mỗi mức quality
-   Không cần "perfect" mới đúng → Quality 3 cũng tăng interval

### 3. Gamification

-   Thêm **streak** (chuỗi ngày ôn tập liên tiếp)
-   Thêm **daily goal** (mục tiêu số flashcard/ngày)
-   Badge cho milestones (100, 500, 1000 từ mastered)

### 4. Analytics

-   Track **average quality** để đánh giá độ khó
-   Track **time spent** để cải thiện UX
-   Hiển thị **learning curve** (progress over time)

---

## 🔧 Troubleshooting

### Issue: Không có flashcard cần ôn tập

**Giải pháp:**

-   Kiểm tra `next_review_date` trong database
-   Đảm bảo user đã học từ vựng (status != NULL)
-   Test với `GET /flashcard-review/flashcard/{vocabId}` để tạo progress mới

### Issue: Interval tăng quá nhanh

**Giải pháp:**

-   Điều chỉnh EF calculation
-   Giảm multiplier cho repetition >= 3
-   Set max interval (ví dụ: 180 ngày)

### Issue: User quên từ nhưng vẫn status MASTERED

**Giải pháp:**

-   Khi quality < 3 → Reset status về LEARNING
-   Điều chỉnh threshold (hiện tại: interval > 21 → MASTERED)

---

## 📚 Tài liệu tham khảo

-   [SuperMemo SM-2 Algorithm](https://www.supermemo.com/en/archives1990-2015/english/ol/sm2)
-   [Spaced Repetition on Wikipedia](https://en.wikipedia.org/wiki/Spaced_repetition)
-   [Anki Algorithm](https://faqs.ankiweb.net/what-spaced-repetition-algorithm.html)

---

## 🎉 Tổng kết

API ôn tập này cung cấp một giải pháp **khoa học** và **hiệu quả** để giúp người học ghi nhớ từ vựng lâu dài. Thuật toán SM-2 đã được chứng minh qua hàng triệu người dùng trên thế giới (Anki, Duolingo, Memrise).
