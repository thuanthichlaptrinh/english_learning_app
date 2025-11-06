# API Ôn Tập Từ Vựng (Vocab Review API)

## Tổng quan

API này cung cấp các tính năng ôn tập từ vựng với khả năng:

-   ✅ Lọc từ vựng theo **topic** (chủ đề) - sử dụng tên topic
-   ✅ Lấy từ vựng **chưa học** (NEW)
-   ✅ Lấy từ vựng **đến hạn ôn tập** hôm nay
-   ✅ **Phân trang** với page và size
-   ✅ Ghi nhận kết quả ôn tập với thuật toán **SM-2 Spaced Repetition**
-   ✅ Thống kê tiến độ học tập

## Base URL

```
/api/v1/vocab-review
```

---

## 1. Lấy danh sách từ vựng cần ôn tập (có phân trang)

### Endpoint

```http
POST /api/v1/vocab-review/vocabs
```

### Request Body

```json
{
    "topicName": "Animals", // Optional: Tên của topic (null = tất cả topic)
    "page": 0, // Optional: Số trang (bắt đầu từ 0, default: 0)
    "size": 10, // Optional: Số từ trên mỗi trang (default: 10, max: 100)
    "onlyNew": false, // Optional: Chỉ lấy từ mới chưa học (default: false)
    "onlyDue": false // Optional: Chỉ lấy từ đến hạn ôn tập (default: false)
}
```

### Các trường hợp sử dụng

#### Case 1: Lấy tất cả từ cần ôn tập (mới + đến hạn) - trang đầu tiên

```json
{
    "topicName": null,
    "page": 0,
    "size": 20,
    "onlyNew": false,
    "onlyDue": false
}
```

#### Case 2: Chỉ lấy từ mới theo topic "Animals" - trang 2

```json
{
    "topicName": "Animals",
    "page": 1,
    "size": 10,
    "onlyNew": true,
    "onlyDue": false
}
```

#### Case 3: Chỉ lấy từ đến hạn ôn tập hôm nay

```json
{
    "topicName": null,
    "page": 0,
    "size": 20,
    "onlyNew": false,
    "onlyDue": true
}
```

### Response

```json
{
    "success": true,
    "message": "Lấy danh sách từ vựng ôn tập thành công",
    "data": {
        "vocabs": [
            {
                "vocabId": "123e4567-e89b-12d3-a456-426614174000",
                "word": "apple",
                "transcription": "/ˈæp.əl/",
                "meaningVi": "quả táo",
                "interpret": "A round fruit with red, green, or yellow skin",
                "exampleSentence": "I eat an apple every day.",
                "cefr": "A1",
                "img": "https://storage.googleapis.com/.../apple.jpg",
                "audio": "https://storage.googleapis.com/.../apple.mp3",
                "topics": ["Food", "Fruits"],
                "types": ["noun"],
                "status": "NEW",
                "timesCorrect": 0,
                "timesWrong": 0,
                "lastReviewed": null,
                "nextReviewDate": "2025-10-24",
                "intervalDays": 1
            }
        ],
        "currentPage": 0,
        "pageSize": 10,
        "totalPages": 5,
        "totalElements": 50,
        "hasPrevious": false,
        "hasNext": true,
        "newVocabs": 30,
        "learningVocabs": 80,
        "masteredVocabs": 40,
        "dueVocabs": 25
    }
}
```

---

## 2. Lấy từ vựng mới (chưa học) - có phân trang

### Endpoint

```http
GET /api/v1/vocab-review/vocabs/new?topicName=Animals&page=0&size=10
```

### Query Parameters

-   `topicName` (optional): Tên của topic
-   `page` (optional): Số trang (bắt đầu từ 0, default: 0)
-   `size` (optional): Số từ trên mỗi trang (default: 10)

### Response

Giống như endpoint `POST /vocabs` nhưng chỉ trả về từ có `status = "NEW"` hoặc chưa được học.

---

## 3. Lấy từ vựng đến hạn ôn tập - có phân trang

### Endpoint

```http
GET /api/v1/vocab-review/vocabs/due?topicName=Food&page=0&size=20
```

### Query Parameters

-   `topicName` (optional): Tên của topic
-   `page` (optional): Số trang (bắt đầu từ 0, default: 0)
-   `size` (optional): Số từ trên mỗi trang (default: 20)

### Response

Trả về danh sách từ có `nextReviewDate <= hôm nay`.

---

## 4. Lấy từ vựng theo topic cụ thể - có phân trang

### Endpoint

```http
GET /api/v1/vocab-review/vocabs/by-topic/Sports?page=0&size=20
```

### Path Parameters

-   `topicName` (required): Tên của topic

### Query Parameters

-   `page` (optional): Số trang (bắt đầu từ 0, default: 0)
-   `size` (optional): Số từ trên mỗi trang (default: 20)

### Response

Trả về tất cả từ vựng cần ôn tập (cả mới và đến hạn) thuộc topic đó với phân trang.

---

## 5. Ghi nhận kết quả ôn tập

### Endpoint

```http
POST /api/v1/vocab-review/submit
```

### Request Body

#### Cách 1: Ghi nhận kết quả đơn giản (đúng/sai)

```json
{
    "vocabId": "123e4567-e89b-12d3-a456-426614174000",
    "isCorrect": true,
    "quality": null
}
```

#### Cách 2: Ghi nhận với độ khó (SM-2 Algorithm)

```json
{
    "vocabId": "123e4567-e89b-12d3-a456-426614174000",
    "isCorrect": true,
    "quality": 4
}
```

### Quality Scale (0-5)

-   **0**: Hoàn toàn không nhớ
-   **1**: Sai nhưng có chút ấn tượng
-   **2**: Sai nhưng gần đúng
-   **3**: Đúng nhưng khó nhớ
-   **4**: Đúng và hơi dễ
-   **5**: Hoàn hảo, rất dễ nhớ

### Response

```json
{
    "success": true,
    "message": "Ghi nhận kết quả ôn tập thành công",
    "data": {
        "vocabId": "123e4567-e89b-12d3-a456-426614174000",
        "word": "apple",
        "status": "LEARNING",
        "timesCorrect": 1,
        "timesWrong": 0,
        "nextReviewDate": "2025-10-30",
        "intervalDays": 6,
        "efFactor": 2.6,
        "repetition": 1,
        "message": "Tốt lắm! Tiếp tục cố gắng! 💪"
    }
}
```

---

## 6. Thống kê tiến độ ôn tập

### Endpoint

```http
GET /api/v1/vocab-review/stats?topicId=5
```

### Query Parameters

-   `topicId` (optional): ID của topic (null = thống kê tổng thể)

### Response

```json
{
    "success": true,
    "message": "Lấy thống kê ôn tập thành công",
    "data": {
        "totalVocabs": 150,
        "newVocabs": 30,
        "learningVocabs": 80,
        "masteredVocabs": 40,
        "dueVocabs": 25
    }
}
```

### Giải thích

-   `totalVocabs`: Tổng số từ đã học
-   `newVocabs`: Số từ mới (chưa thuộc)
-   `learningVocabs`: Số từ đang học
-   `masteredVocabs`: Số từ đã thành thạo
-   `dueVocabs`: Số từ đến hạn ôn tập hôm nay

---

## Trạng thái từ vựng (Status)

| Status     | Mô tả           | Điều kiện                                 |
| ---------- | --------------- | ----------------------------------------- |
| `NEW`      | Từ mới chưa học | `repetition = 0`                          |
| `LEARNING` | Đang học        | `repetition > 0` và `intervalDays < 21`   |
| `MASTERED` | Đã thành thạo   | `repetition >= 5` và `intervalDays >= 21` |

---

## Thuật toán SM-2 (Spaced Repetition)

Hệ thống sử dụng thuật toán SM-2 để tối ưu lịch ôn tập:

### Công thức tính khoảng cách ôn tập

```
- Nếu quality >= 3 (đúng):
  - Lần 1: interval = 1 ngày
  - Lần 2: interval = 6 ngày
  - Lần sau: interval = interval_cũ * EF_Factor

- Nếu quality < 3 (sai):
  - interval = 1 ngày (reset về đầu)
```

### EF Factor (Ease Factor)

```
newEF = oldEF + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
minEF = 1.3
```

---

## Ví dụ sử dụng

### 1. Ôn tập 10 từ mới về chủ đề "Animals"

```javascript
// Bước 1: Lấy danh sách từ mới (trang đầu tiên)
const response = await fetch('/api/v1/vocab-review/vocabs/new?topicName=Animals&page=0&size=10', {
    headers: {
        Authorization: 'Bearer YOUR_TOKEN',
    },
});

const { data } = await response.json();
const { vocabs, hasNext, currentPage } = data;

// Bước 2: User trả lời từng từ
for (const vocab of vocabs) {
    // Hiển thị câu hỏi cho user...
    const userAnswer = getUserAnswer(); // Giả sử function này lấy câu trả lời

    // Ghi nhận kết quả
    await fetch('/api/v1/vocab-review/submit', {
        method: 'POST',
        headers: {
            Authorization: 'Bearer YOUR_TOKEN',
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            vocabId: vocab.vocabId,
            isCorrect: userAnswer === vocab.meaningVi,
            quality: 4, // User tự đánh giá
        }),
    });
}

// Bước 3: Lấy trang tiếp theo nếu có
if (hasNext) {
    const nextResponse = await fetch(
        `/api/v1/vocab-review/vocabs/new?topicName=Animals&page=${currentPage + 1}&size=10`,
        {
            headers: {
                Authorization: 'Bearer YOUR_TOKEN',
            },
        },
    );
}
```

### 2. Lấy từ đến hạn ôn tập hôm nay với phân trang

```bash
# Trang 1
curl -X GET "http://localhost:8080/api/v1/vocab-review/vocabs/due?page=0&size=20" \
  -H "Authorization: Bearer YOUR_TOKEN"

# Trang 2
curl -X GET "http://localhost:8080/api/v1/vocab-review/vocabs/due?page=1&size=20" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 3. Xem thống kê theo topic

```bash
curl -X GET "http://localhost:8080/api/v1/vocab-review/stats?topicName=Travel" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 4. Lấy tất cả từ theo topic với phân trang

```javascript
// Lấy trang đầu tiên
const response = await fetch('/api/v1/vocab-review/vocabs/by-topic/Sports?page=0&size=15', {
    headers: {
        Authorization: 'Bearer YOUR_TOKEN',
    },
});

const { data } = await response.json();
console.log(`Trang ${data.currentPage + 1}/${data.totalPages}`);
console.log(`Tổng số từ: ${data.totalElements}`);
console.log(`Từ trong trang này: ${data.vocabs.length}`);
```

---

## Phân trang (Pagination)

### Thông tin phân trang trong Response

```json
{
    "currentPage": 0, // Trang hiện tại (bắt đầu từ 0)
    "pageSize": 10, // Số lượng từ trên mỗi trang
    "totalPages": 5, // Tổng số trang
    "totalElements": 50, // Tổng số từ vựng
    "hasPrevious": false, // Có trang trước không
    "hasNext": true // Có trang sau không
}
```

### Các trường hợp phân trang

#### 1. Lấy trang đầu tiên

```
page=0&size=10
```

#### 2. Lấy trang thứ 3 (index 2)

```
page=2&size=10
```

#### 3. Tăng kích thước trang

```
page=0&size=50  // Tối đa 100
```

#### 4. Điều hướng phân trang

```javascript
// Frontend logic
if (data.hasNext) {
    // Hiển thị nút "Next"
    nextPage = data.currentPage + 1;
}

if (data.hasPrevious) {
    // Hiển thị nút "Previous"
    prevPage = data.currentPage - 1;
}

// Tính toán số trang
const pages = Array.from({ length: data.totalPages }, (_, i) => i);
```

---

## So sánh với Flashcard Review API

| Tính năng         | Vocab Review API  | Flashcard Review API   |
| ----------------- | ----------------- | ---------------------- |
| Lọc theo topic    | ✅ Có (topicName) | ❌ Không               |
| Lấy từ mới        | ✅ Có             | ❌ Không               |
| Từ chưa học       | ✅ Có             | ❌ Không               |
| Phân trang        | ✅ Có             | ❌ Không               |
| Thuật toán SM-2   | ✅ Có             | ✅ Có                  |
| Ghi nhận đơn giản | ✅ Có (isCorrect) | ❌ Không (chỉ quality) |

**Khuyến nghị**: Sử dụng **Vocab Review API** cho ứng dụng học từ vựng có phân loại theo topic, trạng thái học tập và cần phân trang.

---

## Error Codes

| Status Code | Error                 | Mô tả                                                 |
| ----------- | --------------------- | ----------------------------------------------------- |
| 400         | Bad Request           | Tham số không hợp lệ (limit > 100, quality ngoài 0-5) |
| 401         | Unauthorized          | Chưa đăng nhập hoặc token không hợp lệ                |
| 404         | Not Found             | Không tìm thấy vocab hoặc topic                       |
| 500         | Internal Server Error | Lỗi hệ thống                                          |

---

## Notes

1. **Phân trang**:

    - Trang bắt đầu từ 0 (zero-indexed)
    - Kích thước trang tối đa: 100 từ
    - Response luôn bao gồm thông tin phân trang đầy đủ

2. **Topic Name**:

    - Sử dụng tên topic (string) thay vì ID
    - So sánh không phân biệt hoa/thường
    - Ví dụ: "Animals", "animals", "ANIMALS" đều giống nhau

3. **Ngày ôn tập**: Được tính toán tự động dựa trên thuật toán SM-2

4. **Quality**: Nếu không truyền quality, hệ thống sẽ dùng thuật toán đơn giản (double interval khi đúng)

5. **Performance**:
    - Sử dụng LEFT JOIN FETCH để tối ưu query
    - Phân trang giúp giảm tải dữ liệu
    - Index trên các trường thường xuyên query

---

## Authentication

Tất cả các endpoint đều yêu cầu Bearer Token:

```http
Authorization: Bearer YOUR_JWT_TOKEN
```

Lấy token từ API đăng nhập: `POST /api/v1/auth/signin`
