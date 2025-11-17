# Image-Word Matching Game - Hướng Dẫn Chơi

## Tổng Quan

Game ghép thẻ hình ảnh với từ vựng tiếng Anh. Người chơi phải ghép đúng tất cả các cặp hình ảnh - từ vựng để hoàn thành game.

### Đặc điểm chính:

-   ✅ **Single Mode**: Chỉ có 1 chế độ chơi duy nhất
-   ✅ **Random Vocabulary**: Từ vựng được chọn ngẫu nhiên (không giới hạn topic)
-   ✅ **CEFR-Based Scoring**: Điểm tính theo cấp độ CEFR (A1→C2)
-   ✅ **Time Bonus**: Hoàn thành nhanh = điểm cao hơn
-   ✅ **Session Cache**: Session được lưu trong 30 phút

---

## Cách Chơi

### 1. Bắt đầu Game:

**Tham số:**

-   `totalPairs`: Số cặp muốn chơi (mặc định: 5)
-   `cefr`: Lọc theo CEFR level (optional: A1, A2, B1, B2, C1, C2)

**Backend trả về:**

-   Danh sách N từ vựng với đầy đủ thuộc tính (word, img, audio, cefr, meaning, etc.)
-   Frontend tự tạo 2N cards (N image cards + N word cards) và xáo trộn

### 2. Người Chơi Ghép Cặp:

-   Ghép hình ảnh với từ vựng tương ứng
-   **Chỉ submit khi đã ghép ĐÚNG HẾT tất cả các cặp**
-   Gửi danh sách vocab IDs đã ghép đúng lên server

### 3. Tính Điểm:

**Điểm CEFR** (cho mỗi từ ghép đúng):

-   A1 = 1 điểm
-   A2 = 2 điểm
-   B1 = 3 điểm
-   B2 = 4 điểm
-   C1 = 5 điểm
-   C2 = 6 điểm

**Time Bonus**:

-   < 10s: +50% điểm CEFR
-   < 20s: +30% điểm CEFR
-   < 30s: +20% điểm CEFR
-   < 60s: +10% điểm CEFR
-   ≥ 60s: 0% bonus

**Công thức**: `Tổng điểm = Điểm CEFR + Time Bonus`

**Ví dụ:**

-   3 từ B1 ghép đúng = 3 × 3 = 9 điểm
-   Hoàn thành trong 15 giây → +30% = 9 + 2.7 = **11.7 điểm**

---

## API Flow

### Bước 1: Bắt Đầu Game

```bash
POST /api/v1/games/image-word-matching/start
Authorization: Bearer <token>
Content-Type: application/json

{
  "totalPairs": 5,
  "cefr": "A1"
}
```

**Response:**

```json
{
    "sessionId": 123,
    "totalPairs": 5,
    "status": "IN_PROGRESS",
    "vocabs": [
        {
            "id": "e2510cb1-8178-42de-904b-5e2cdc3680b5",
            "word": "apple",
            "transcription": "/ˈæpl/",
            "meaningVi": "quả táo",
            "interpret": "A round fruit with red or green skin",
            "exampleSentence": "I eat an apple every day.",
            "cefr": "A1",
            "img": "https://firebase.../apple.jpg",
            "audio": "https://firebase.../apple.mp3",
            "types": [{ "id": 1, "name": "Noun" }],
            "topics": [{ "id": 5, "name": "Food" }]
        }
        // ... 4 vocabs nữa
    ]
}
```

### Bước 2: Submit Kết Quả

**Chỉ submit khi đã ghép đúng HẾT tất cả các cặp!**

```bash
POST /api/v1/games/image-word-matching/submit
Authorization: Bearer <token>
Content-Type: application/json

{
  "sessionId": 123,
  "matchedVocabIds": [
    "e2510cb1-8178-42de-904b-5e2cdc3680b5",
    "45ea3c80-2e55-4c8c-a429-1d96576fcadf",
    "1e8ae068-1f58-455c-ac7a-c697a8188e43",
    "uuid-4",
    "uuid-5"
  ],
  "timeTaken": 45000
}
```

**Response:**

```json
{
    "sessionId": 123,
    "totalPairs": 5,
    "correctMatches": 5,
    "accuracy": 100.0,
    "timeTaken": 45000,
    "score": 8,
    "vocabScores": [
        {
            "vocabId": "e2510cb1-8178-42de-904b-5e2cdc3680b5",
            "word": "apple",
            "cefr": "A1",
            "points": 1,
            "correct": true
        }
        // ... 4 vocabs nữa
    ]
}
```

---

## Frontend Implementation Guide

### 1. Nhận Vocabs từ API:

```javascript
const response = await fetch('/api/v1/games/image-word-matching/start', {
    method: 'POST',
    headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
    },
    body: JSON.stringify({ totalPairs: 5, cefr: 'A1' }),
});

const { sessionId, vocabs } = await response.json();
```

### 2. Tạo Cards:

```javascript
const cards = [];

// Tạo image cards
vocabs.forEach((vocab) => {
    cards.push({
        id: `img-${vocab.id}`,
        type: 'IMAGE',
        content: vocab.img,
        vocabId: vocab.id,
    });
});

// Tạo word cards
vocabs.forEach((vocab) => {
    cards.push({
        id: `word-${vocab.id}`,
        type: 'WORD',
        content: vocab.word,
        vocabId: vocab.id,
    });
});

// Xáo trộn
const shuffledCards = cards.sort(() => Math.random() - 0.5);
```

### 3. Track Matched Pairs:

```javascript
const matchedVocabIds = [];
const startTime = Date.now();

// Khi user ghép đúng 1 cặp
function onCorrectMatch(vocabId) {
    if (!matchedVocabIds.includes(vocabId)) {
        matchedVocabIds.push(vocabId);
    }

    // Kiểm tra đã ghép hết chưa
    if (matchedVocabIds.length === vocabs.length) {
        submitResult();
    }
}
```

### 4. Submit Kết Quả:

```javascript
async function submitResult() {
    const timeTaken = Date.now() - startTime;

    const response = await fetch('/api/v1/games/image-word-matching/submit', {
        method: 'POST',
        headers: {
            Authorization: `Bearer ${token}`,
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            sessionId,
            matchedVocabIds,
            timeTaken,
        }),
    });

    const result = await response.json();
    console.log('Score:', result.score);
    console.log('Accuracy:', result.accuracy);
}
```

---

## Session Management

### Cache Time: 30 phút

-   Session được lưu trong cache 30 phút kể từ khi start
-   Sau 30 phút, session tự động expired
-   API `/session/{sessionId}` sẽ trả về lỗi nếu session đã expired

### Lấy Thông Tin Session:

```bash
GET /api/v1/games/image-word-matching/session/{sessionId}
Authorization: Bearer <token>
```

**Response:** Giống như response của `/start`

---

## Các API Khác

### Lịch Sử Chơi:

```bash
GET /api/v1/games/image-word-matching/history?page=0&size=10
Authorization: Bearer <token>
```

### Bảng Xếp Hạng:

```bash
GET /api/v1/games/image-word-matching/leaderboard?limit=10
```

### Thống Kê Cá Nhân:

```bash
GET /api/v1/games/image-word-matching/stats
Authorization: Bearer <token>
```

### Hướng Dẫn Chơi:

```bash
GET /api/v1/games/image-word-matching/instructions
```

---

## Lưu Ý Quan Trọng

### ✅ DO:

-   Ghép đúng HẾT tất cả các cặp trước khi submit
-   Gửi `timeTaken` chính xác (milliseconds)
-   Chỉ gửi vocab IDs đã ghép đúng trong `matchedVocabIds`

### ❌ DON'T:

-   Submit khi chưa ghép hết tất cả cặp
-   Gửi vocab IDs sai hoặc không tồn tại
-   Submit nhiều lần cho cùng 1 session
-   Quên gửi `timeTaken` (sẽ không có time bonus)

---

## Test Cases

### Case 1: Perfect Score với Time Bonus

**Request:**

```json
{
    "sessionId": 123,
    "matchedVocabIds": ["uuid-1", "uuid-2", "uuid-3", "uuid-4", "uuid-5"],
    "timeTaken": 25000
}
```

**Expected:**

-   5 từ A1 = 5 điểm
-   < 30s = +20% = 1 điểm
-   **Total: 6 điểm**
-   Accuracy: 100%

### Case 2: Slow Completion (No Bonus)

**Request:**

```json
{
    "sessionId": 123,
    "matchedVocabIds": ["uuid-1", "uuid-2", "uuid-3", "uuid-4", "uuid-5"],
    "timeTaken": 70000
}
```

**Expected:**

-   5 từ A1 = 5 điểm
-   ≥ 60s = 0% bonus
-   **Total: 5 điểm**
-   Accuracy: 100%

### Case 3: High CEFR Words

**Request:**

```json
{
    "sessionId": 456,
    "matchedVocabIds": ["uuid-1", "uuid-2", "uuid-3"],
    "timeTaken": 15000
}
```

**Scenario:** 3 từ C2

**Expected:**

-   3 từ C2 = 18 điểm
-   < 20s = +30% = 5.4 điểm
-   **Total: 23.4 điểm**
-   Accuracy: 100%
