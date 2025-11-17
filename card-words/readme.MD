# Card Words API Documentation

## Tổng quan

Card Words là ứng dụng học từ vựng tiếng Anh với các tính năng:

-   Hệ thống học từ vựng với thuật toán Spaced Repetition (SM-2)
-   Các mini-game học từ vựng: Quick Quiz, Image Word Matching, Word Definition Matching
-   Flashcard Review với hệ thống ôn tập thông minh
-   Streak tracking và leaderboard
-   Offline sync cho mobile app
-   Admin panel quản lý từ vựng, topics, users

## Tech Stack

-   **Java 17** + Spring Boot 3.2.5
-   **PostgreSQL 16** - Database
-   **Redis 7.x** - Caching
-   **JWT** - Authentication (Access Token + Refresh Token)
-   **Google OAuth2** - Social login
-   **Firebase Storage** - File storage
-   **Flyway** - Database migration
-   **Docker** - Containerization

## Authentication

Hầu hết các API yêu cầu JWT token trong header:

```
Authorization: Bearer <access_token>
```

Admin APIs yêu cầu role `ROLE_ADMIN`.

---

## 📚 API Endpoints

### 1. Authentication APIs

#### 1.1. Đăng ký tài khoản

**POST** `/api/v1/auth/signup`

**Request Body:**

```json
{
    "name": "Nguyễn Văn A",
    "email": "user@example.com",
    "password": "password123"
}
```

**Response:**

```json
{
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "refresh_token_here",
    "tokenType": "Bearer"
}
```

#### 1.2. Đăng nhập

**POST** `/api/v1/auth/signin`

**Request Body:**

```json
{
    "email": "user@example.com",
    "password": "password123"
}
```

**Response:** Tương tự đăng ký

#### 1.3. Đăng nhập bằng Google

**POST** `/api/v1/auth/google`

**Request Body:**

```json
{
    "idToken": "google_id_token_here"
}
```

#### 1.4. Đăng xuất

**POST** `/api/v1/auth/signout`

**Headers:** `Authorization: Bearer <token>`

#### 1.5. Quên mật khẩu

**POST** `/api/v1/auth/forgot-password`

**Request Body:**

```json
{
    "email": "user@example.com"
}
```

#### 1.6. Làm mới access token

**POST** `/api/v1/auth/refresh-token`

**Request Body:**

```json
{
    "refreshToken": "refresh_token_here"
}
```

---

### 2. User Profile APIs

#### 2.1. Lấy thông tin profile

**GET** `/api/v1/users`

**Headers:** `Authorization: Bearer <token>`

**Response:**

```json
{
    "id": 1,
    "name": "Nguyễn Văn A",
    "email": "user@example.com",
    "avatarUrl": "https://firebase.url/avatar.jpg",
    "gender": "MALE",
    "dateOfBirth": "1990-01-01",
    "currentLevel": "A2"
}
```

#### 2.2. Cập nhật profile

**PUT** `/api/v1/users`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**

```json
{
    "name": "Nguyễn Văn B",
    "gender": "MALE",
    "dateOfBirth": "1990-01-01",
    "currentLevel": "B1"
}
```

#### 2.3. Upload avatar

**PUT** `/api/v1/users/avatar`

**Headers:**

-   `Authorization: Bearer <token>`
-   `Content-Type: multipart/form-data`

**Form Data:**

-   `file`: Image file

#### 2.4. Lịch sử chơi game

**GET** `/api/v1/users/games/history`

**Query Params:**

-   `gameId` (optional): ID của game
-   `page` (default: 0)
-   `size` (default: 20)

#### 2.5. Thống kê game

**GET** `/api/v1/user/stats/high-scores`

**Response:**

```json
{
    "quickQuiz": 1500,
    "imageWordMatching": 2000,
    "wordDefinitionMatching": 1800
}
```

---

### 3. Vocabulary APIs

#### 3.1. Lấy danh sách từ vựng

**GET** `/api/v1/vocabs`

**Query Params:**

-   `page` (default: 0)
-   `size` (default: 20)
-   `sortBy` (default: "word")
-   `sortDir` (default: "asc")

#### 3.2. Tìm kiếm từ vựng

**GET** `/api/v1/vocabs/search`

**Query Params:**

-   `keyword`: Từ khóa tìm kiếm
-   `page` (default: 0)
-   `size` (default: 20)

#### 3.3. Lấy từ vựng theo ID

**GET** `/api/v1/vocabs/{id}`

#### 3.4. Lấy từ vựng theo từ

**GET** `/api/v1/vocabs/word/{word}`

**Example:** `/api/v1/vocabs/word/hello`

#### 3.5. Lấy từ vựng theo mức CEFR

**GET** `/api/v1/vocabs/cefr/{cefr}`

**Path Param:**

-   `cefr`: A1, A2, B1, B2, C1, C2

**Query Params:**

-   `page` (default: 0)
-   `size` (default: 20)

#### 3.6. Lấy media của từ vựng

**GET** `/api/v1/vocabs/{id}/media`

**Response:**

```json
{
    "imageUrl": "https://firebase.url/image.jpg",
    "audioUrl": "https://firebase.url/audio.mp3"
}
```

#### 3.7. Lấy media theo từ

**GET** `/api/v1/vocabs/word/{word}/media`

---

### 4. Topics APIs

#### 4.1. Lấy danh sách chủ đề

**GET** `/api/v1/topics`

**Response:**

```json
[
    {
        "id": 1,
        "name": "Animals",
        "description": "Động vật",
        "img": "https://firebase.url/topics/animals.jpg"
    }
]
```

#### 4.2. Lấy chủ đề theo ID

**GET** `/api/v1/topics/{id}`

---

### 5. Types APIs

#### 5.1. Lấy danh sách loại từ

**GET** `/api/v1/types`

**Response:**

```json
[
    {
        "id": 1,
        "name": "noun",
        "description": "Danh từ"
    },
    {
        "id": 2,
        "name": "verb",
        "description": "Động từ"
    }
]
```

#### 5.2. Lấy loại từ theo ID

**GET** `/api/v1/types/{id}`

---

### 6. Learn Vocab APIs

#### 6.1. Lấy từ vựng để ôn tập

**POST** `/api/v1/learn-vocabs/vocabs/review`

**Request Body:**

```json
{
    "topicName": "Animals",
    "page": 0,
    "size": 20
}
```

#### 6.2. Lấy từ mới chưa học

**GET** `/api/v1/learn-vocabs/vocabs/new`

**Query Params:**

-   `topicName`: Tên chủ đề
-   `page` (default: 0)
-   `size` (default: 20)

#### 6.3. Lấy từ vựng theo topic

**GET** `/api/v1/learn-vocabs/topics/{topicName}/vocabs`

**Query Params:**

-   `page` (default: 0)
-   `size` (default: 20)

#### 6.4. Ghi nhận kết quả học

**POST** `/api/v1/learn-vocabs/submit`

**Request Body:**

```json
{
    "vocabId": 1,
    "isCorrect": true,
    "quality": 4
}
```

**Quality values:**

-   0: Complete blackout
-   1: Incorrect, correct answer seemed familiar
-   2: Incorrect, correct answer seemed easy to recall
-   3: Correct, but required significant effort
-   4: Correct, with some hesitation
-   5: Correct, with perfect recall

#### 6.5. Thống kê tiến độ học

**GET** `/api/v1/learn-vocabs/stats/progress`

**Query Params:**

-   `topicName` (optional): Thống kê theo topic

**Response:**

```json
{
    "totalVocabs": 500,
    "learnedVocabs": 120,
    "masteredVocabs": 50,
    "reviewingVocabs": 70,
    "newVocabs": 380
}
```

---

### 7. Flashcard Review APIs

#### 7.1. Lấy flashcards cần ôn hôm nay

**GET** `/api/v1/flashcard-review/due`

**Query Params:**

-   `limit` (optional): Số lượng flashcards

**Response:**

```json
[
    {
        "vocabId": 1,
        "word": "hello",
        "definition": "xin chào",
        "nextReview": "2024-01-15T10:00:00"
    }
]
```

#### 7.2. Lấy thông tin một flashcard

**GET** `/api/v1/flashcard-review/vocabs/{vocabId}`

#### 7.3. Ghi nhận kết quả ôn tập

**POST** `/api/v1/flashcard-review/submit`

**Request Body:**

```json
{
    "vocabId": 1,
    "quality": 4
}
```

**Quality:** 0-5 (theo thuật toán SM-2)

#### 7.4. Thống kê ôn tập hôm nay

**GET** `/api/v1/flashcard-review/stats/today`

**Response:**

```json
{
    "totalDue": 15,
    "reviewed": 10,
    "remaining": 5
}
```

---

### 8. Quick Quiz Game APIs

#### 8.1. Lấy hướng dẫn chơi

**GET** `/api/v1/games/quick-quiz/instructions`

**Public API** (không cần token)

#### 8.2. Bắt đầu game

**POST** `/api/v1/games/quick-quiz/start`

**Request Body:**

```json
{
    "topicName": "Animals",
    "difficulty": "EASY",
    "numberOfQuestions": 10
}
```

**Response:**

```json
{
    "sessionId": "uuid-here",
    "questions": [
        {
            "questionId": 1,
            "word": "hello",
            "options": ["xin chào", "tạm biệt", "cảm ơn", "xin lỗi"],
            "timeLimit": 15
        }
    ]
}
```

#### 8.3. Trả lời câu hỏi

**POST** `/api/v1/games/quick-quiz/answer`

**Request Body:**

```json
{
    "sessionId": "uuid-here",
    "questionId": 1,
    "selectedAnswer": "xin chào",
    "timeSpent": 8
}
```

#### 8.4. Bỏ qua câu hỏi (timeout)

**POST** `/api/v1/games/quick-quiz/skip`

**Request Body:**

```json
{
    "sessionId": "uuid-here",
    "questionId": 1
}
```

#### 8.5. Xem kết quả game

**GET** `/api/v1/games/quick-quiz/sessions/{sessionId}`

**Response:**

```json
{
    "sessionId": "uuid-here",
    "totalQuestions": 10,
    "correctAnswers": 8,
    "score": 1200,
    "accuracy": 80.0,
    "completedAt": "2024-01-15T10:30:00"
}
```

#### 8.6. Bảng xếp hạng

**GET** `/api/v1/games/quick-quiz/leaderboard`

**Query Params:**

-   `limit` (default: 10)

---

### 9. Image Word Matching Game APIs

#### 9.1. Lấy hướng dẫn chơi

**GET** `/api/v1/games/image-word-matching/instructions`

**Public API**

#### 9.2. Bắt đầu game

**POST** `/api/v1/games/image-word-matching/start`

**Request Body:**

```json
{
    "topicName": "Animals",
    "difficulty": "MEDIUM",
    "numberOfPairs": 6
}
```

**Response:**

```json
{
    "sessionId": "uuid-here",
    "pairs": [
        {
            "imageUrl": "https://firebase.url/cat.jpg",
            "word": "cat"
        }
    ],
    "timeLimit": 60
}
```

#### 9.3. Nộp kết quả

**POST** `/api/v1/games/image-word-matching/submit`

**Request Body:**

```json
{
    "sessionId": "uuid-here",
    "matches": [
        {
            "imageIndex": 0,
            "wordIndex": 2
        }
    ],
    "timeSpent": 45
}
```

#### 9.4. Lấy thông tin session

**GET** `/api/v1/games/image-word-matching/sessions/{sessionId}`

#### 9.5. Lịch sử chơi

**GET** `/api/v1/games/image-word-matching/history`

**Query Params:**

-   `page` (default: 0)
-   `size` (default: 20)

#### 9.6. Bảng xếp hạng

**GET** `/api/v1/games/image-word-matching/leaderboard`

**Query Params:**

-   `limit` (default: 10)

#### 9.7. Thống kê cá nhân

**GET** `/api/v1/games/image-word-matching/stats`

---

### 10. Word Definition Matching Game APIs

#### 10.1. Lấy hướng dẫn chơi

**GET** `/api/v1/games/word-definition-matching/instructions`

**Public API**

#### 10.2. Bắt đầu game

**POST** `/api/v1/games/word-definition-matching/start`

**Request Body:**

```json
{
    "topicName": "Food",
    "difficulty": "HARD",
    "numberOfPairs": 8
}
```

#### 10.3. Nộp kết quả

**POST** `/api/v1/games/word-definition-matching/submit`

**Request Body:**

```json
{
    "sessionId": "uuid-here",
    "matches": [
        {
            "wordIndex": 0,
            "definitionIndex": 3
        }
    ],
    "timeSpent": 50
}
```

#### 10.4. Lấy thông tin session

**GET** `/api/v1/games/word-definition-matching/sessions/{sessionId}`

#### 10.5. Bảng xếp hạng

**GET** `/api/v1/games/word-definition-matching/leaderboard`

**Query Params:**

-   `limit` (default: 10)

---

### 11. User Vocab Progress APIs

#### 11.1. Lấy tất cả từ đã học

**GET** `/api/v1/user-vocab-progress`

#### 11.2. Lấy từ trả lời đúng

**GET** `/api/v1/user-vocab-progress/correct`

#### 11.3. Lấy từ trả lời sai

**GET** `/api/v1/user-vocab-progress/wrong`

#### 11.4. Thống kê tiến trình học

**GET** `/api/v1/user-vocab-progress/stats`

**Response:**

```json
{
    "totalLearned": 150,
    "mastered": 80,
    "reviewing": 50,
    "struggling": 20
}
```

#### 11.5. Từ cần ôn tập hôm nay

**GET** `/api/v1/user-vocab-progress/due-for-review`

#### 11.6. Từ đã học trong ngày

**GET** `/api/v1/user-vocab-progress/learned-today`

#### 11.7. Thống kê 7 ngày gần nhất

**GET** `/api/v1/user-vocab-progress/stats/last-7-days`

**Response:**

```json
[
    {
        "date": "2024-01-15",
        "wordsLearned": 10
    }
]
```

#### 11.8. Thống kê theo CEFR

**GET** `/api/v1/user-vocab-progress/stats/by-cefr`

**Response:**

```json
{
    "A1": 50,
    "A2": 40,
    "B1": 30,
    "B2": 20,
    "C1": 10,
    "C2": 0
}
```

---

### 12. Streak APIs

#### 12.1. Lấy thông tin streak

**GET** `/api/v1/user/streak`

**Response:**

```json
{
    "currentStreak": 7,
    "longestStreak": 15,
    "lastActivityDate": "2024-01-15"
}
```

#### 12.2. Ghi nhận hoạt động học

**POST** `/api/v1/user/streak/record`

Tự động cập nhật streak khi user học bài

---

### 13. Leaderboard APIs

#### 13.1. Top 10 players tổng hợp

**GET** `/api/v1/leaderboard/top-players`

#### 13.2. Bảng xếp hạng Quick Quiz toàn cầu

**GET** `/api/v1/leaderboard/quiz/global`

**Query Params:**

-   `limit` (default: 10)

#### 13.3. Bảng xếp hạng Quick Quiz theo ngày

**GET** `/api/v1/leaderboard/quiz/daily`

**Query Params:**

-   `date`: yyyy-MM-dd
-   `limit` (default: 10)

#### 13.4. Xếp hạng của tôi trong Quick Quiz

**GET** `/api/v1/leaderboard/quiz/my-rank`

#### 13.5. Bảng xếp hạng streak hiện tại

**GET** `/api/v1/leaderboard/streak/current`

**Query Params:**

-   `limit` (default: 10)

#### 13.6. Bảng xếp hạng streak tốt nhất

**GET** `/api/v1/leaderboard/streak/best`

**Query Params:**

-   `limit` (default: 10)

#### 13.7. Bảng xếp hạng Image Matching

**GET** `/api/v1/leaderboard/image-matching`

**Query Params:**

-   `limit` (default: 10)

#### 13.8. Bảng xếp hạng Word Definition

**GET** `/api/v1/leaderboard/word-definition`

**Query Params:**

-   `limit` (default: 10)

---

### 14. Offline Sync APIs

#### 14.1. Download APIs

##### 14.1.1. Lấy danh sách topics với tiến độ

**GET** `/api/v1/offline/topics`

##### 14.1.2. Download từ vựng của topic

**GET** `/api/v1/offline/topics/{topicId}/vocabs`

##### 14.1.3. Lấy từ học gần đây (30 ngày)

**GET** `/api/v1/offline/vocabs/recent`

##### 14.1.4. Kiểm tra cập nhật

**GET** `/api/v1/offline/check-updates`

**Query Params:**

-   `lastSyncTime`: ISO timestamp

#### 14.2. Upload APIs

##### 14.2.1. Batch upload tất cả

**POST** `/api/v1/offline/sync/batch`

**Request Body:**

```json
{
  "gameSessions": [...],
  "vocabProgress": [...]
}
```

##### 14.2.2. Upload game sessions

**POST** `/api/v1/offline/game-sessions`

**Request Body:**

```json
[
    {
        "sessionId": "offline-uuid",
        "gameId": 1,
        "score": 1500,
        "completedAt": "2024-01-15T10:30:00"
    }
]
```

##### 14.2.3. Upload learning progress

**POST** `/api/v1/offline/user-vocab-progress`

**Request Body:**

```json
[
    {
        "vocabId": 1,
        "isCorrect": true,
        "learnedAt": "2024-01-15T10:00:00"
    }
]
```

##### 14.2.4. Upload game details

**POST** `/api/v1/offline/game-sessions/{sessionId}/details`

**Request Body:**

```json
[
    {
        "questionId": 1,
        "isCorrect": true,
        "timeSpent": 10
    }
]
```

---

## 🔐 Admin APIs

**Tất cả Admin APIs yêu cầu role `ROLE_ADMIN`**

### 15. Vocab Admin APIs

#### 15.1. Lấy từ vựng theo ID

**GET** `/api/v1/admin/vocabs/{id}`

#### 15.2. Lấy từ vựng theo từ

**GET** `/api/v1/admin/vocabs/word/{word}`

#### 15.3. Lấy danh sách từ vựng

**GET** `/api/v1/admin/vocabs`

**Query Params:**

-   `page`, `size`, `sortBy`, `sortDir`

#### 15.4. Tìm kiếm từ vựng

**GET** `/api/v1/admin/vocabs/search`

**Query Params:**

-   `keyword`, `page`, `size`

#### 15.5. Lấy từ vựng theo CEFR

**GET** `/api/v1/admin/vocabs/cefr/{cefr}`

#### 15.6. Thêm từ vựng mới

**POST** `/api/v1/admin/vocabs`

**Request Body:**

```json
{
    "word": "hello",
    "definition": "xin chào",
    "pronunciation": "/həˈloʊ/",
    "example": "Hello, how are you?",
    "cefr": "A1",
    "topicId": 1,
    "typeId": 1,
    "imageUrl": "https://...",
    "audioUrl": "https://..."
}
```

#### 15.7. Thêm hàng loạt từ vựng

**POST** `/api/v1/admin/vocabs/bulk-import`

**Request Body:**

```json
{
  "vocabs": [
    {
      "word": "hello",
      "definition": "xin chào",
      ...
    }
  ]
}
```

#### 15.8. Cập nhật từ vựng theo ID

**PUT** `/api/v1/admin/vocabs/{id}`

#### 15.9. Cập nhật từ vựng theo từ

**PUT** `/api/v1/admin/vocabs/word/{word}`

#### 15.10. Xóa từ vựng

**DELETE** `/api/v1/admin/vocabs/{id}`

#### 15.11. Xuất Excel

**GET** `/api/v1/admin/vocabs/export/excel`

---

### 16. Topic Admin APIs

#### 16.1. Lấy danh sách chủ đề

**GET** `/api/v1/admin/topics`

#### 16.2. Lấy chủ đề theo ID

**GET** `/api/v1/admin/topics/{id}`

#### 16.3. Tạo chủ đề mới

**POST** `/api/v1/admin/topics`

**Headers:** `Content-Type: multipart/form-data`

**Form Data:**

-   `name`: Tên chủ đề (required)
-   `description`: Mô tả
-   `image`: File ảnh

**Response:**

```json
{
    "id": 1,
    "name": "Animals",
    "description": "Động vật",
    "img": "https://firebase.url/topics/images/uuid.jpg"
}
```

#### 16.4. Cập nhật chủ đề

**PUT** `/api/v1/admin/topics/{id}`

**Headers:** `Content-Type: multipart/form-data`

**Form Data:**

-   `name`: Tên mới (optional)
-   `description`: Mô tả mới (optional)
-   `image`: File ảnh mới (optional)

**Lưu ý:** Chỉ cập nhật các trường được cung cấp

#### 16.5. Xóa chủ đề

**DELETE** `/api/v1/admin/topics/{id}`

#### 16.6. Tạo nhiều chủ đề cùng lúc

**POST** `/api/v1/admin/topics/bulk-create`

**Request Body:**

```json
{
    "topics": [
        {
            "name": "Animals",
            "description": "Động vật",
            "imageUrl": "https://..."
        },
        {
            "name": "Food",
            "description": "Thức ăn"
        }
    ]
}
```

**Response:**

```json
{
    "totalRequested": 2,
    "successCount": 2,
    "failureCount": 0,
    "results": [
        {
            "success": true,
            "topic": {
                "id": 1,
                "name": "Animals",
                "description": "Động vật",
                "img": "https://..."
            }
        }
    ]
}
```

#### 16.7. Cập nhật nhiều chủ đề cùng lúc

**PUT** `/api/v1/admin/topics/bulk-update`

**Request Body:**

```json
{
    "topics": [
        {
            "id": 1,
            "name": "Wild Animals",
            "description": "Động vật hoang dã"
        },
        {
            "id": 2,
            "imageUrl": "https://new-image-url"
        }
    ]
}
```

**Lưu ý:** Mỗi topic chỉ cập nhật các trường được cung cấp

---

### 17. Type Admin APIs

#### 17.1. Lấy danh sách loại từ

**GET** `/api/v1/admin/types`

#### 17.2. Lấy loại từ theo ID

**GET** `/api/v1/admin/types/{id}`

#### 17.3. Tạo loại từ mới

**POST** `/api/v1/admin/types`

**Request Body:**

```json
{
    "name": "adjective",
    "description": "Tính từ"
}
```

#### 17.4. Xóa loại từ

**DELETE** `/api/v1/admin/types/{id}`

---

### 18. User Admin APIs

#### 18.1. Lấy danh sách người dùng

**GET** `/api/v1/admin/users`

**Query Params:**

-   `page`, `size`, `sortBy`, `sortDir`

#### 18.2. Lấy user theo ID

**GET** `/api/v1/admin/users/{id}`

#### 18.3. Lấy user theo email

**GET** `/api/v1/admin/users/email/{email}`

#### 18.4. Tìm kiếm người dùng

**GET** `/api/v1/admin/users/search`

**Query Params:**

-   `keyword`, `page`, `size`

#### 18.5. Khóa/mở khóa tài khoản

**PUT** `/api/v1/admin/users/{id}/ban`

**Query Params:**

-   `banned`: true/false

#### 18.6. Kích hoạt/vô hiệu hóa tài khoản

**PUT** `/api/v1/admin/users/{id}/activate`

**Query Params:**

-   `activated`: true/false

#### 18.7. Cập nhật role

**PUT** `/api/v1/admin/users/{id}/roles`

**Request Body:**

```json
{
    "roles": ["ROLE_USER", "ROLE_ADMIN"]
}
```

#### 18.8. Xóa người dùng

**DELETE** `/api/v1/admin/users/{id}`

#### 18.9. Thống kê người dùng

**GET** `/api/v1/admin/users/statistics`

**Response:**

```json
{
    "totalUsers": 1000,
    "activeUsers": 800,
    "bannedUsers": 50,
    "newUsersThisMonth": 120
}
```

---

### 19. Vocab Progress Admin APIs

#### 19.1. Lấy tiến độ học từ của user

**GET** `/api/v1/admin/vocab-progress/user/{userId}`

**Query Params:**

-   `page`, `size`

#### 19.2. Thống kê từ vựng

**GET** `/api/v1/admin/vocab-progress/vocab/{vocabId}/stats`

**Response:**

```json
{
    "totalLearners": 500,
    "masteredCount": 200,
    "averageAttempts": 3.5
}
```

#### 19.3. Tổng quan tiến độ học

**GET** `/api/v1/admin/vocab-progress/statistics`

#### 19.4. Danh sách từ khó nhất

**GET** `/api/v1/admin/vocab-progress/difficult-words`

**Query Params:**

-   `limit` (default: 10)

#### 19.5. Xóa bản ghi tiến độ

**DELETE** `/api/v1/admin/vocab-progress/{id}`

#### 19.6. Reset toàn bộ tiến độ của user

**DELETE** `/api/v1/admin/vocab-progress/user/{userId}/reset`

---

### 20. Game Admin APIs

#### 20.1. Lấy danh sách game

**GET** `/api/v1/admin/games`

#### 20.2. Lấy thông tin game theo ID

**GET** `/api/v1/admin/games/{id}`

#### 20.3. Lấy danh sách session của game

**GET** `/api/v1/admin/games/{id}/sessions`

**Query Params:**

-   `page`, `size`

#### 20.4. Lấy chi tiết session

**GET** `/api/v1/admin/games/sessions/{sessionId}`

#### 20.5. Thống kê game

**GET** `/api/v1/admin/games/{id}/statistics`

#### 20.6. Tổng quan thống kê tất cả game

**GET** `/api/v1/admin/games/statistics/overview`

#### 20.7. Xóa session

**DELETE** `/api/v1/admin/games/sessions/{sessionId}`

---

### 21. Firebase Storage APIs

#### 21.1. Upload ảnh

**POST** `/api/v1/storage/upload/image`

**Headers:** `Content-Type: multipart/form-data`

**Form Data:**

-   `file`: Image file

**Response:**

```json
{
    "url": "https://firebase.url/image.jpg"
}
```

#### 21.2. Upload audio

**POST** `/api/v1/storage/upload/audio`

**Headers:** `Content-Type: multipart/form-data`

**Form Data:**

-   `file`: Audio file

#### 21.3. Upload nhiều ảnh

**POST** `/api/v1/storage/upload/images/bulk`

**Headers:** `Content-Type: multipart/form-data`

**Form Data:**

-   `files[]`: Array of image files

**Response:**

```json
{
    "urls": ["https://firebase.url/image1.jpg", "https://firebase.url/image2.jpg"]
}
```

#### 21.4. Upload nhiều audio

**POST** `/api/v1/storage/upload/audios/bulk`

**Headers:** `Content-Type: multipart/form-data`

**Form Data:**

-   `files[]`: Array of audio files

#### 21.5. Upload media và cập nhật vocab

**POST** `/api/v1/storage/upload/vocab-media/{vocabId}`

**Headers:** `Content-Type: multipart/form-data`

**Form Data:**

-   `files[]`: Image và audio files

#### 21.6. Dọn dẹp audio không sử dụng

**POST** `/api/v1/storage/cleanup/audios`

**Query Params:**

-   `dryRun`: true/false (preview mode)

#### 21.7. Dọn dẹp image không sử dụng

**POST** `/api/v1/storage/cleanup/images`

**Query Params:**

-   `dryRun`: true/false

#### 21.8. Xóa file

**DELETE** `/api/v1/storage/delete`

**Query Params:**

-   `url`: Firebase Storage URL

---

## 📊 Tổng kết

-   **Tổng số Controllers:** 22
-   **Public APIs:** 7 endpoints (Authentication + Game instructions)
-   **User APIs:** ~80 endpoints (yêu cầu Bearer Token)
-   **Admin APIs:** ~60 endpoints (yêu cầu ROLE_ADMIN)
-   **Tổng số endpoints:** ~147 APIs

---

## 🚀 Getting Started

### Prerequisites

-   Java 17+
-   Maven 3.6+
-   Docker & Docker Compose
-   PostgreSQL 16
-   Redis

### Running with Docker

```bash
# Build và chạy tất cả services
./docker-deploy.bat  # Windows
./docker-deploy.sh   # Linux/Mac

# Ứng dụng sẽ chạy tại http://localhost:8080
```

### Running locally

```bash
# Install dependencies
mvn clean install

# Run application
mvn spring-boot:run
```

---

## 📝 API Testing

### Using cURL

```bash
# Đăng ký
curl -X POST http://localhost:8080/api/v1/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","password":"password123"}'

# Đăng nhập
curl -X POST http://localhost:8080/api/v1/auth/signin \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Lấy profile (với token)
curl -X GET http://localhost:8080/api/v1/users \
  -H "Authorization: Bearer <your_token>"
```

### Using PowerShell

Xem các test scripts trong thư mục gốc:

-   `test-topic-image-api.ps1`
-   `test-bulk-topics.ps1`
-   Redis Sorted Sets (O(log N) performance)

### 6. Redis Caching

-   **Phase 1**: User caching (email lookup, profiles, online tracking)
-   **Phase 2**: Game sessions (Quiz, Image Matching, Word Definition)
-   **Phase 3**: Leaderboards (Global, Daily, Weekly)
-   Performance: 50-200x faster than database queries

## Prerequisites

-   **Java 17+**
-   **Maven 3.8+**
-   **PostgreSQL 15+**
-   **Redis 7+** (or Docker)
-   **Docker & Docker Compose** (optional but recommended)

## Installation & Setup

### 1. Clone Repository

```bash
git clone https://github.com/thuanthichlaptrinh/card_words.git
cd card_words
```

### 2. Configure Environment

Copy file `.env.docker.example` thanh `.env` va cap nhat cac bien:

```bash
# Database
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=card_words
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_password

# JWT
JWT_SECRET=your_jwt_secret_key_min_256_bits
JWT_EXPIRATION=86400000

# Google OAuth2
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# Firebase (for file storage)
FIREBASE_BUCKET=your_firebase_bucket
```

### 3. Setup Database

**Option A: PostgreSQL local**

```bash
# Tao database
psql -U postgres
CREATE DATABASE card_words;
\q

# Flyway se tu dong chay migrations khi start app
```

**Option B: PostgreSQL Docker**

```bash
docker-compose up -d postgres
```

### 4. Setup Redis

**Option A: Redis Docker (Recommended)**

```bash
docker-compose up -d redis
```

**Option B: Redis local**

```bash
# Windows (with Chocolatey)
choco install redis

# Mac
brew install redis
brew services start redis

# Linux
sudo apt-get install redis-server
sudo systemctl start redis
```

### 5. Build & Run Application

**Option A: Maven Wrapper**

```bash
# Build
./mvnw clean install -DskipTests

# Run
./mvnw spring-boot:run
```

\*\*Option B: Maven (neu da cai)

```bash
mvn clean install -DskipTests
mvn spring-boot:run
```

**Option C: Docker Compose (Full stack)**

```bash
# Build va start TAT CA 3 services:
# 1. PostgreSQL (port 5432)
# 2. Redis (port 6379)
# 3. Spring Boot App (port 8080)
docker-compose up -d

# Xem logs cua ung dung
docker-compose logs -f app

# Xem logs tat ca services
docker-compose logs -f

# Stop tat ca services
docker-compose down

# Stop va xoa volumes (database data)
docker-compose down -v
```

### 6. Verify Application

Ung dung se chay o: **http://localhost:8080**

**Health Check**:

```bash
curl http://localhost:8080/actuator/health
```

**Swagger UI** (API Documentation):

```
http://localhost:8080/swagger-ui.html
```

---

## Docker Compose Services

Khi chay `docker-compose up -d`, cac services sau se duoc khoi dong:

### 1. PostgreSQL Database

-   **Container**: `card-words-postgres`
-   **Image**: `postgres:16-alpine`
-   **Port**: `5432` (mapped to host)
-   **Volume**: `postgres_data` (luu du lieu database)
-   **Health Check**: Ping PostgreSQL moi 10s
-   **Init Script**: `init-db.sql` (tu dong chay khi lan dau)

### 2. Redis Cache

-   **Container**: `card-words-redis`
-   **Image**: `redis:7-alpine`
-   **Port**: `6379` (mapped to host)
-   **Volume**: `redis_data` (luu AOF file)
-   **Health Check**: Redis PING command
-   **Persistence**: AOF (Append-Only File) enabled

### 3. Spring Boot Application

-   **Container**: `card-words-app`

---

## 📖 Additional Documentation

Xem thêm tài liệu chi tiết trong thư mục `/docs`:

-   **Redis**: `redis/REDIS_QUICK_START.md` - Hướng dẫn Redis caching
-   **Flashcard**: `flash_card/FLASHCARD_REVIEW_API_GUIDE.md` - Chi tiết Flashcard APIs
-   **Games**: `game/GAME_ALGORITHMS_DESIGN.md` - Thuật toán tính điểm game
-   **Streak**: `streak/STREAK_FEATURE_COMPLETED.md` - Streak tracking system
-   **Docker**: `docker/DOCKER_DATABASE_INDEX.md` - Docker & Database setup
-   **Learn Vocab**: `learn/LEARN_VOCAB_API_GUIDE.md` - Learn vocabulary APIs
-   **Quick Quiz**: `quick_quiz/QUICK_QUIZ_API_GUIDE.md` - Quick Quiz game guide
-   **Image Matching**: `image_word/IMAGE_WORD_MATCHING_GUIDE.md` - Image matching game
-   **Vocab Status**: `vocab/VOCAB_STATUS_IMPLEMENTATION_SUMMARY.md` - Vocabulary management

---

## 🐳 Docker Architecture

### Container Structure

```
card-words-network
├── postgres:16      (port 5433:5432)
├── redis:7-alpine   (port 6380:6379)
└── card-words-app   (port 8080:8080)
```

### Service Configuration

#### PostgreSQL

-   **Image**: `postgres:16-alpine`
-   **Port**: `5433` (host) → `5432` (container)
-   **Database**: `card_words`
-   **User**: `admin` / Password: từ `.env.docker`
-   **Volumes**: `postgres-data` (persistent storage)
-   **Health Check**: `pg_isready` mỗi 10s

#### Redis

-   **Image**: `redis:7-alpine`
-   **Port**: `6380` (host) → `6379` (container)
-   **Password**: Cấu hình trong `.env.docker`
-   **Volumes**: `redis-data` (persistent storage)
-   **Health Check**: `redis-cli ping` mỗi 10s

#### Spring Boot App

-   **Build**: Từ Dockerfile trong project
-   **Port**: `8080` (mapped to host)
-   **Dependencies**: Đợi PostgreSQL và Redis healthy trước khi start
-   **Restart**: Automatic (unless-stopped)
-   **Environment**: Đọc từ file `.env.docker`

### Service Dependencies

```
Spring Boot App
    ├── depends_on: PostgreSQL (healthy)
    └── depends_on: Redis (healthy)
```

**Chú ý**: App chỉ start sau khi PostgreSQL và Redis đã HEALTHY

---

## ⚡ Quick Start Commands

### Development Mode

```bash
# 1. Start Redis
docker-compose up -d redis

# 2. Start PostgreSQL (nếu dùng Docker)
docker-compose up -d postgres

# 3. Run Spring Boot
./mvnw spring-boot:run

# 4. Xem logs
tail -f app.log
```

### Production Build

```bash
# Build JAR
./mvnw clean package -DskipTests

# Run JAR
java -jar target/card-words-0.0.1-SNAPSHOT.jar
```

### Docker Commands

```bash
# Build image
docker build -t card-words:latest .

# Run container
docker run -d -p 8080:8080 --name card-words card-words:latest

# Stop container
docker stop card-words
docker rm card-words
```

### Docker Compose Commands

```bash
# Start tất cả services (detached mode)
docker-compose up -d

# Start chỉ Redis và Postgres (không start app)
docker-compose up -d redis postgres

# Xem status các services
docker-compose ps

# Xem logs realtime
docker-compose logs -f

# Xem logs một service cụ thể
docker-compose logs -f app
docker-compose logs -f redis
docker-compose logs -f postgres

# Restart một service
docker-compose restart app

# Stop tất cả services
docker-compose stop

# Stop và xóa containers (GIỮ dữ liệu volumes)
docker-compose down

# Stop, xóa containers VÀ volumes (MẤT dữ liệu database)
docker-compose down -v

# Rebuild image và restart
docker-compose up -d --build

# Kiểm tra health status
docker-compose ps
docker inspect card-words-postgres | grep -A 5 Health
docker inspect card-words-redis | grep -A 5 Health
```

---

## 📄 License

Copyright © 2024 Card Words Project

## API Endpoints

### Authentication

```
POST   /api/v1/auth/register          - Dang ky tai khoan
POST   /api/v1/auth/login             - Dang nhap
POST   /api/v1/auth/google            - Dang nhap Google OAuth2
POST   /api/v1/auth/refresh-token     - Refresh JWT token
POST   /api/v1/auth/logout            - Dang xuat
```

### Vocabulary

```
GET    /api/v1/vocabs                 - Lay danh sach tu vung
GET    /api/v1/vocabs/{id}            - Chi tiet tu vung
POST   /api/v1/vocabs                 - Them tu vung (Admin)
PUT    /api/v1/vocabs/{id}            - Cap nhat tu vung (Admin)
DELETE /api/v1/vocabs/{id}            - Xoa tu vung (Admin)
```

### Learning

```
GET    /api/v1/learn/review-vocabs    - Lay tu can on tap
POST   /api/v1/learn/review           - Danh gia ket qua on tap
GET    /api/v1/learn/flashcards       - Lay flashcards
POST   /api/v1/learn/flashcard-review - Danh gia flashcard
GET    /api/v1/learn/stats            - Thong ke hoc tap
```

### Games

```
POST   /api/v1/games/quick-quiz/start    - Bat dau Quick Quiz
POST   /api/v1/games/quick-quiz/answer   - Tra loi cau hoi
POST   /api/v1/games/quick-quiz/skip     - Bo qua cau hoi
GET    /api/v1/games/quick-quiz/results  - Ket qua game

POST   /api/v1/games/image-matching/start
POST   /api/v1/games/image-matching/answer

POST   /api/v1/games/word-definition/start
POST   /api/v1/games/word-definition/answer
```

### Leaderboard (Phase 3)

```
GET    /api/v1/leaderboard/quiz/global       - Bang xep hang toan cau
GET    /api/v1/leaderboard/quiz/daily        - Bang xep hang theo ngay
GET    /api/v1/leaderboard/quiz/my-rank      - Xep hang cua toi
GET    /api/v1/leaderboard/streak/current    - Bang xep hang streak
GET    /api/v1/leaderboard/streak/best       - Bang xep hang streak tot nhat
GET    /api/v1/leaderboard/image-matching    - Image Matching leaderboard
GET    /api/v1/leaderboard/word-definition   - Word Definition leaderboard
```

### Streak

```
GET    /api/v1/streak                 - Lay thong tin streak
POST   /api/v1/streak/check-in        - Check-in hang ngay
```

### User Stats

```
GET    /api/v1/users/stats            - Thong ke nguoi dung
GET    /api/v1/users/profile          - Thong tin ca nhan
PUT    /api/v1/users/profile          - Cap nhat thong tin
```

## Testing

### Run Tests

```bash
# Run tat ca tests
./mvnw test

# Run mot test class
./mvnw test -Dtest=QuickQuizServiceTest

# Skip tests khi build
./mvnw clean install -DskipTests
```

### Test Coverage

```bash
./mvnw jacoco:report
```

## Redis Utilities

### Check Redis Connection

```bash
# Linux/Mac
./check-redis-keys.sh

# Windows
check-redis-keys.bat
```

### Redis CLI Commands

```bash
# Connect to Redis
docker exec -it card-words-redis redis-cli

# List all keys
KEYS cardwords:*

# Check leaderboard
ZREVRANGE cardwords:leaderboard:quickquiz:global 0 9 WITHSCORES

# Get user rank
ZRANK cardwords:leaderboard:quickquiz:global "user-uuid"

# Check cache TTL
TTL cardwords:user:email:test@example.com
```

## Performance Optimization

### Redis Caching Benefits

| Operation                   | Without Redis | With Redis | Improvement    |
| --------------------------- | ------------- | ---------- | -------------- |
| User Login                  | 100ms         | 5ms        | 95% faster     |
| Leaderboard Query (Top 100) | 500-1000ms    | 5-10ms     | 50-200x faster |
| Game Session Load           | 50ms          | 2ms        | 96% faster     |
| User Profile Lookup         | 30ms          | 1ms        | 97% faster     |

### Cache Strategies

-   **User Cache**: 30 minutes TTL
-   **Game Sessions**: 30 minutes TTL
-   **Leaderboard Global**: No expiration
-   **Leaderboard Daily**: 26 hours TTL
-   **Leaderboard Weekly**: 8 days TTL

## Troubleshooting

### Redis Connection Error

```bash
# Check if Redis is running
docker ps | grep redis

# Restart Redis
docker-compose restart redis

# Check logs
docker-compose logs redis
```

### Database Connection Error

```bash
# Check PostgreSQL
docker ps | grep postgres

# Test connection
psql -h localhost -U postgres -d card_words

# Check logs
docker-compose logs postgres
```

### Application Won't Start

```bash
# Check logs
tail -f app.log

# Verify environment variables
cat .env

# Clean rebuild
./mvnw clean install -DskipTests
```

## Project Structure

```
card-words/
├── src/main/java/com/thuanthichlaptrinh/card_words/
│   ├── common/                 # Constants, enums, exceptions, utils
│   ├── configuration/          # Spring configs (Security, JWT, Redis, Swagger)
│   ├── core/
│   │   ├── domain/            # JPA entities
│   │   ├── mapper/            # Entity <-> DTO mappers
│   │   ├── service/redis/     # Redis cache services
│   │   └── usecase/           # Business logic services
│   ├── dataprovider/
│   │   └── repository/        # JPA repositories
│   └── entrypoint/
│       ├── dto/               # Request/Response DTOs
│       └── rest/              # REST Controllers
├── src/main/resources/
│   ├── db/migration/          # Flyway SQL scripts
│   ├── data/                  # Initial vocabulary data
│   └── application.yml        # Application config
├── docs/                      # Documentation
├── docker-compose.yml         # Docker services
└── Dockerfile                 # App container image
```

## Documentation

Chi tiet trong folder `docs/`:

-   `REDIS_IMPLEMENTATION_PLAN.md` - Ke hoach Redis caching
-   `PHASE_3_LEADERBOARD_COMPLETE.md` - Tai lieu Phase 3
-   `STREAK_FEATURE_COMPLETED.md` - Tai lieu Streak System

---

## 📦 Backup & Restore Database

### ⚠️ QUAN TRỌNG: Data Portability

Khi mang code sang máy khác, Docker volumes sẽ **KHÔNG** được transfer tự động. Database sẽ chỉ có:

-   ✅ **Schema** (tables, constraints) - từ Flyway migrations
-   ✅ **2 roles** (ROLE_ADMIN, ROLE_USER) - từ DataInitializer
-   ✅ **2 admin accounts** (admin1@cardwords.com, admin2@cardwords.com) với password `Admin@123` - từ DataInitializer
-   ❌ **KHÔNG CÓ** user data, vocab, topics, game_sessions

### 🔄 Backup Database (Máy hiện tại)

**Trên máy có data:**

```bash
# Linux/Mac
./backup-database.sh

# Windows
backup-database.bat
```

-   File backup được lưu tại: `database-backups/card_words_YYYYMMDD_HHMMSS.sql`
-   Script tự động giữ 5 bản backup gần nhất

### 📥 Restore Database (Máy mới)

**Trên máy mới hoặc máy chưa có data:**

```bash
# 1. Start Docker containers
docker-compose up -d

# 2. Đợi app khởi động xong (check logs)
docker logs -f card-words-app
# Chờ đến khi thấy: "Started CardWordsApplication"

# 3. Restore database
# Linux/Mac:
./restore-database.sh database-backups/card_words_20250116_120000.sql

# Windows:
restore-database.bat database-backups\card_words_20250116_120000.sql
```

### 💡 Lưu ý khi di chuyển sang máy khác

1. **Copy các file cần thiết:**

    ```
    📁 card-words/
    ├── database-backups/         ← QUAN TRỌNG: Copy folder này
    │   └── card_words_*.sql
    ├── backup-database.sh        ← Script backup
    ├── restore-database.sh       ← Script restore
    ├── .env                      ← Environment variables
    └── docker-compose.yml
    ```

2. **Quy trình setup trên máy mới:**

    ```bash
    # Bước 1: Clone code
    git clone <your-repo>
    cd card-words

    # Bước 2: Copy file backup từ máy cũ (hoặc pull từ Git nếu đã commit)
    # database-backups/card_words_*.sql

    # Bước 3: Start Docker
    docker-compose up -d

    # Bước 4: Đợi app start xong
    docker logs -f card-words-app

    # Bước 5: Restore database
    ./restore-database.sh database-backups/card_words_*.sql

    # ✅ Done! Database đã có đầy đủ data
    ```

3. **Nếu không có file backup:**

    - Database sẽ rỗng (chỉ có schema và 2 admin accounts)
    - Cần import lại data từ PgAdmin hoặc SQL dump
    - Hoặc populate data mới qua API

### 🔒 Bảo mật file backup

**KHÔNG commit file backup vào Git nếu chứa:**

-   User passwords (ngay cả đã hash)
-   Sensitive user data (email, phone numbers)
-   Production data

**Khuyến nghị:**

-   Add vào `.gitignore`:
    ```gitignore
    database-backups/
    *.sql
    ```
-   Sử dụng secure storage (AWS S3, Google Drive, BitBucket Artifacts)
-   Encrypt backup files trước khi share

### 📊 Docker Volume Management (Nâng cao)

**Backup toàn bộ PostgreSQL volume:**

```bash
# Export volume
docker run --rm \
  -v card-words_postgres_data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/postgres_volume.tar.gz -C /data .
```

**Restore volume:**

```bash
# Import volume
docker volume create card-words_postgres_data
docker run --rm \
  -v card-words_postgres_data:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/postgres_volume.tar.gz -C /data
```

---

-   `GAME_ALGORITHMS_DESIGN.md` - Thuat toan game
-   `FLYWAY_MIGRATION_GUIDE.md` - Huong dan migration DB

## Contributing

1. Fork project
2. Tao branch moi: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'feat: Add amazing feature'`
4. Push len branch: `git push origin feature/amazing-feature`
5. Tao Pull Request

## License

MIT License - xem file LICENSE de biet them chi tiet

## Contact

-   **Author**: Ngo Minh Thuan (thuanthichlaptrinh)
-   **Email**: thuanthichlaptrinh@gmail.com
-   **GitHub**: https://github.com/thuanthichlaptrinh/card_words
