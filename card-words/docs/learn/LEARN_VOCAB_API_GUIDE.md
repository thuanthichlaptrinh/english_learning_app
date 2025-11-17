# 📚 Hướng Dẫn API Học Từ Vựng (Learn Vocab)

## 🎯 Tổng Quan

API này dùng cho chức năng **HỌC TỪ VỰNG MỚI** (không phải ôn tập).

### 🔄 Flow Học Tập:

```
1. Frontend lấy danh sách từ mới
   GET /api/v1/learn-vocabs/vocabs/new?topicName=Animals&page=0&size=20

2. Hiển thị từng từ một (dùng state currentIndex)

3. User xem từ và click một trong 2 nút:
   ✅ "Đã thuộc"
   ❌ "Chưa thuộc"

4. Gọi API submit:
   POST /api/v1/learn-vocabs/submit
   {
     "vocabId": "uuid-here",
     "isCorrect": true/false
   }

5. Backend tự động:
   - Click "Đã thuộc" → status = KNOWN
   - Click "Chưa thuộc" → status = UNKNOWN
   - Khi đủ điều kiện → status = MASTERED (tự động)

6. Chuyển sang từ tiếp theo (currentIndex++)
```

---

## 📊 4 Trạng Thái (VocabStatus)

| Status       | Ý nghĩa         | Khi nào?                                                            |
| ------------ | --------------- | ------------------------------------------------------------------- |
| **NEW**      | Từ mới chưa học | Chưa có trong bảng `user_vocab_progress`                            |
| **KNOWN**    | Đã thuộc        | User click "Đã thuộc"                                               |
| **UNKNOWN**  | Chưa thuộc      | User click "Chưa thuộc"                                             |
| **MASTERED** | Thành thạo      | Tự động: `timesCorrect >= 10 && timesWrong <= 2 && accuracy >= 80%` |

---

## 🚀 API Endpoints

### 1️⃣ Lấy Từ Mới Chưa Học

```http
GET /api/v1/learn-vocabs/vocabs/new?topicName=Animals&page=0&size=20
```

**Query Parameters:**

-   `topicName` (optional): Tên topic để lọc (vd: "Animals", "Food")
-   `page` (optional, default=0): Số trang
-   `size` (optional, default=10): Số từ trên mỗi trang

**Response:**

```json
{
    "success": true,
    "message": "...",
    "data": {
        "vocabs": [
            {
                "vocabId": "uuid-1",
                "word": "apple",
                "transcription": "/ˈæpl/",
                "meaningVi": "quả táo",
                "interpret": "Một loại trái cây...",
                "exampleSentence": "I eat an apple every day",
                "cefr": "A1",
                "img": "https://...",
                "audio": "https://...",
                "topics": ["Food", "Fruits"],
                "types": ["noun"],
                "status": "NEW",
                "timesCorrect": 0,
                "timesWrong": 0
            }
        ],
        "currentPage": 0,
        "pageSize": 20,
        "totalPages": 5,
        "totalElements": 100,
        "hasPrevious": false,
        "hasNext": true,
        "newVocabs": 100,
        "learningVocabs": 50,
        "masteredVocabs": 30,
        "dueVocabs": 20
    }
}
```

---

### 2️⃣ Gửi Kết Quả Học Tập

```http
POST /api/v1/learn-vocabs/submit
Content-Type: application/json
```

**Request Body:**

```json
{
    "vocabId": "uuid-here",
    "isCorrect": true,
    "quality": null
}
```

**Parameters:**

-   `vocabId` (required): UUID của từ vựng
-   `isCorrect` (required):
    -   `true` = Click "Đã thuộc"
    -   `false` = Click "Chưa thuộc"
-   `quality` (optional, 0-5): Đánh giá độ khó (để tính SM-2, không bắt buộc)

**Response:**

```json
{
    "success": true,
    "message": "Ghi nhận kết quả ôn tập thành công",
    "data": {
        "vocabId": "uuid-here",
        "word": "apple",
        "status": "KNOWN",
        "timesCorrect": 1,
        "timesWrong": 0,
        "nextReviewDate": "2025-10-25",
        "intervalDays": 1,
        "efFactor": 2.5,
        "repetition": 1,
        "message": "Tốt lắm! Bạn đã thuộc từ này! 💪"
    }
}
```

---

### 3️⃣ Xem Thống Kê

```http
GET /api/v1/learn-vocabs/stats?topicName=Animals
```

**Query Parameters:**

-   `topicName` (optional): Tên topic để lọc stats

**Response:**

```json
{
    "success": true,
    "data": {
        "totalVocabs": 200,
        "newVocabs": 100,
        "learningVocabs": 60,
        "masteredVocabs": 40,
        "dueVocabs": 20
    }
}
```

**Giải thích:**

-   `newVocabs`: Số từ NEW (chưa học)
-   `learningVocabs`: Số từ KNOWN + UNKNOWN (đã học nhưng chưa thành thạo)
-   `masteredVocabs`: Số từ MASTERED (đã thành thạo)
-   `dueVocabs`: Số từ đến hạn ôn tập hôm nay

---

## 💻 Frontend Implementation

### React/Vue/Angular Example:

```javascript
// 1. Fetch từ mới
const fetchNewVocabs = async (topicName = null, page = 0) => {
    const url = `/api/v1/learn-vocabs/vocabs/new?page=${page}&size=20${topicName ? `&topicName=${topicName}` : ''}`;
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
        },
    });
    const data = await response.json();
    return data.data.vocabs;
};

// 2. Component state
const [vocabs, setVocabs] = useState([]);
const [currentIndex, setCurrentIndex] = useState(0);
const [stats, setStats] = useState({});

// 3. Load vocabs
useEffect(() => {
    fetchNewVocabs('Animals', 0).then(setVocabs);
}, []);

// 4. Handle button click
const handleKnown = async () => {
    const currentVocab = vocabs[currentIndex];

    await fetch('/api/v1/learn-vocabs/submit', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({
            vocabId: currentVocab.vocabId,
            isCorrect: true,
        }),
    });

    // Chuyển sang từ tiếp theo
    setCurrentIndex((prev) => prev + 1);
};

const handleUnknown = async () => {
    const currentVocab = vocabs[currentIndex];

    await fetch('/api/v1/learn-vocabs/submit', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({
            vocabId: currentVocab.vocabId,
            isCorrect: false,
        }),
    });

    // Chuyển sang từ tiếp theo
    setCurrentIndex((prev) => prev + 1);
};

// 5. Render
return (
    <div className="flashcard">
        {vocabs[currentIndex] && (
            <>
                <div className="vocab-card">
                    <img src={vocabs[currentIndex].img} alt={vocabs[currentIndex].word} />
                    <h2>{vocabs[currentIndex].word}</h2>
                    <p>{vocabs[currentIndex].transcription}</p>
                    <p>{vocabs[currentIndex].meaningVi}</p>
                    <p>{vocabs[currentIndex].exampleSentence}</p>
                </div>

                <div className="buttons">
                    <button onClick={handleUnknown}>❌ Chưa thuộc</button>
                    <button onClick={handleKnown}>✅ Đã thuộc</button>
                </div>

                <div className="progress">
                    {currentIndex + 1} / {vocabs.length}
                </div>
            </>
        )}
    </div>
);
```

---

## 🎮 Test Scenarios

### Scenario 1: Học từ mới lần đầu

```
1. GET /vocabs/new → Nhận từ "apple" với status=NEW
2. Click "Đã thuộc" → POST /submit (isCorrect=true)
3. Response: status=KNOWN, timesCorrect=1
```

### Scenario 2: Học sai

```
1. GET /vocabs/new → Nhận từ "banana" với status=NEW
2. Click "Chưa thuộc" → POST /submit (isCorrect=false)
3. Response: status=UNKNOWN, timesWrong=1
```

### Scenario 3: Đạt thành thạo

```
1. Click "Đã thuộc" 10 lần liên tiếp
2. timesCorrect=10, timesWrong=0, accuracy=100%
3. Backend tự động: status → MASTERED
4. Response: message="Xuất sắc! Bạn đã thành thạo từ này! 🎉"
```

### Scenario 4: Thất bại thành thạo

```
1. timesCorrect=8, timesWrong=3
2. accuracy = 8/(8+3) = 72% < 80%
3. status = KNOWN (chưa đủ điều kiện MASTERED)
```

---

## 🔧 Database Schema

```sql
CREATE TABLE user_vocab_progress (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    vocab_id UUID NOT NULL,
    status VARCHAR(50),  -- 'NEW', 'KNOWN', 'UNKNOWN', 'MASTERED'
    times_correct INT DEFAULT 0,
    times_wrong INT DEFAULT 0,
    last_reviewed DATE,
    next_review_date DATE,
    interval_days INT DEFAULT 1,
    ef_factor DECIMAL(3,2) DEFAULT 2.5,
    repetition INT DEFAULT 0,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    UNIQUE(user_id, vocab_id)
);
```

---

## ⚙️ Logic Tính MASTERED

```java
int totalAttempts = timesCorrect + timesWrong;
double accuracy = (double) timesCorrect / totalAttempts;

if (timesCorrect >= 10
    && timesWrong <= 2
    && accuracy >= 0.8) {
    status = MASTERED;
}
```

**Điều kiện:**

-   ✅ Trả lời đúng ít nhất 10 lần
-   ✅ Sai tối đa 2 lần
-   ✅ Độ chính xác >= 80%

**Ví dụ:**

-   10 đúng, 0 sai → 100% → ✅ MASTERED
-   10 đúng, 1 sai → 91% → ✅ MASTERED
-   10 đúng, 2 sai → 83% → ✅ MASTERED
-   10 đúng, 3 sai → 77% → ❌ Chưa MASTERED (KNOWN)
-   8 đúng, 0 sai → Chưa đủ 10 lần → ❌ Chưa MASTERED (KNOWN)

---

## 📝 Notes

1. **Từ NEW**: Không có record trong `user_vocab_progress` → Frontend hiển thị status=NEW
2. **Từ KNOWN/UNKNOWN**: Có record với status tương ứng
3. **Từ MASTERED**: Tự động tính, không thể set thủ công
4. **Migration**: Chạy `V3__update_vocab_status_enum.sql` để migrate data cũ

---

## ❓ FAQ

**Q: Tại sao cần 4 trạng thái thay vì 3?**
A: Để phân biệt giữa "Đã thuộc" (KNOWN) và "Chưa thuộc" (UNKNOWN). User có thể click cả 2 nút, status sẽ theo hành động gần nhất.

**Q: Khi nào status chuyển từ KNOWN sang MASTERED?**
A: Tự động khi đủ điều kiện: >= 10 lần đúng, <= 2 lần sai, độ chính xác >= 80%.

**Q: Có thể reset status về NEW không?**
A: Không. Một khi đã học (KNOWN/UNKNOWN) thì không quay lại NEW. Muốn reset phải xóa record trong DB.

**Q: quality parameter dùng để làm gì?**
A: Dùng cho thuật toán SM-2 (spaced repetition) để tính khoảng cách ôn tập tối ưu. Không bắt buộc.

---

## 🔗 Related APIs

-   **Flashcard Review**: `/api/v1/flashcard-review` - Ôn tập từ đã học theo SM-2
-   **Vocab Management**: `/api/v1/vocabs` - Quản lý từ vựng
-   **Topic Management**: `/api/v1/topics` - Quản lý chủ đề

---

**Ngày tạo**: 2025-10-24  
**Version**: 1.0  
**Author**: Card Words Team
