# CHƯƠNG 4: THIẾT KẾ API

## 4.1. Tổng quan kiến trúc API

### 4.1.1. Kiến trúc RESTful API

Hệ thống Card Words được xây dựng theo kiến trúc RESTful API, tuân thủ các nguyên tắc thiết kế REST (Representational State Transfer) để đảm bảo tính nhất quán, dễ bảo trì và mở rộng.

**Các nguyên tắc thiết kế:**

- **Stateless**: Mỗi request từ client chứa đầy đủ thông tin cần thiết, server không lưu trữ trạng thái session
- **Resource-based**: API được tổ chức xung quanh các tài nguyên (resources) như users, vocabs, topics, games
- **HTTP Methods**: Sử dụng đúng các phương thức HTTP (GET, POST, PUT, DELETE, PATCH)
- **Uniform Interface**: Giao diện thống nhất với cấu trúc URL và response format nhất quán

### 4.1.2. Cấu trúc URL

```
https://{domain}/api/v1/{resource}/{id}/{sub-resource}
```

### 4.1.3. Cấu trúc Response chuẩn

**Response thành công:**
```json
{
    "success": true,
    "message": "Thao tác thành công",
    "data": { }
}
```

**Response lỗi:**
```json
{
    "success": false,
    "message": "Mô tả lỗi",
    "error": {
        "code": "ERROR_CODE",
        "details": "Chi tiết lỗi"
    }
}
```

### 4.1.4. HTTP Status Codes

| Status Code | Ý nghĩa | Sử dụng |
|-------------|---------|---------|
| 200 OK | Thành công | GET, PUT, PATCH thành công |
| 201 Created | Tạo mới thành công | POST tạo resource mới |
| 204 No Content | Thành công không có nội dung | DELETE thành công |
| 400 Bad Request | Request không hợp lệ | Validation errors |
| 401 Unauthorized | Chưa xác thực | Token không hợp lệ/hết hạn |
| 403 Forbidden | Không có quyền | Không đủ quyền truy cập |
| 404 Not Found | Không tìm thấy | Resource không tồn tại |
| 429 Too Many Requests | Quá nhiều request | Rate limiting |
| 500 Internal Server Error | Lỗi server | Lỗi hệ thống |

---

## 4.2. Xác thực và Phân quyền

### 4.2.1. JWT Authentication

Hệ thống sử dụng JSON Web Token (JWT) để xác thực người dùng.

**Luồng xác thực:**

```
┌─────────┐     1. Login Request      ┌─────────┐
│  Client │ ──────────────────────────▶│  Server │
└─────────┘                            └─────────┘
     │                                      │
     │     2. Validate credentials          │
     │     3. Generate JWT Token            │
     │◀─────────────────────────────────────│
     │                                      │
     │     4. Request with Bearer Token     │
     │─────────────────────────────────────▶│
     │     5. Validate Token & Response     │
     │◀─────────────────────────────────────│
```

### 4.2.2. Role-Based Access Control (RBAC)

| Role | Quyền hạn |
|------|-----------|
| `ROLE_USER` | Truy cập các API user, chơi game, quản lý profile |
| `ROLE_ADMIN` | Toàn quyền: quản lý users, vocabs, topics, thống kê |

---

## 4.3. Danh sách API Endpoints

### 4.3.1. Authentication APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `POST` | `/api/v1/auth/signup` | Đăng ký tài khoản mới | ❌ |
| `POST` | `/api/v1/auth/signin` | Đăng nhập bằng email/password | ❌ |
| `POST` | `/api/v1/auth/signout` | Đăng xuất | ✅ |
| `POST` | `/api/v1/auth/google` | Đăng nhập bằng Google OAuth2 | ❌ |
| `POST` | `/api/v1/auth/refresh-token` | Làm mới access token | ❌ |
| `POST` | `/api/v1/auth/forgot-password` | Yêu cầu đặt lại mật khẩu | ❌ |

### 4.3.2. User APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `GET` | `/api/v1/users` | Lấy thông tin profile | ✅ |
| `PUT` | `/api/v1/users` | Cập nhật thông tin profile | ✅ |
| `PUT` | `/api/v1/users/avatar` | Upload avatar | ✅ |
| `POST` | `/api/v1/users/change-password` | Đổi mật khẩu | ✅ |
| `GET` | `/api/v1/users/games/history` | Lịch sử chơi game | ✅ |
| `GET` | `/api/v1/users/games/stats` | Thống kê game tổng quan | ✅ |

### 4.3.3. User Streak APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `GET` | `/api/v1/user/streak` | Lấy thông tin streak hiện tại | ✅ |
| `POST` | `/api/v1/user/streak/record` | Ghi nhận hoạt động học | ✅ |

### 4.3.4. Vocabulary APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `GET` | `/api/v1/vocabs` | Danh sách từ vựng (phân trang) | ✅ |
| `GET` | `/api/v1/vocabs/{id}` | Lấy từ vựng theo ID | ✅ |
| `GET` | `/api/v1/vocabs/word/{word}` | Lấy từ vựng theo từ | ✅ |
| `GET` | `/api/v1/vocabs/search` | Tìm kiếm từ vựng | ✅ |
| `GET` | `/api/v1/vocabs/cefr/{cefr}` | Lấy từ vựng theo CEFR level | ✅ |
| `GET` | `/api/v1/vocabs/{id}/media` | Lấy URL hình ảnh/âm thanh | ✅ |
| `GET` | `/api/v1/vocabs/word/{word}/media` | Lấy media theo từ | ✅ |

### 4.3.5. Topic APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `GET` | `/api/v1/topics` | Danh sách chủ đề kèm tiến độ | ✅ |
| `GET` | `/api/v1/topics/{id}` | Chi tiết chủ đề | ✅ |

### 4.3.6. Type APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `GET` | `/api/v1/types` | Danh sách loại từ (noun, verb, adj...) | ✅ |

### 4.3.7. Notification APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `GET` | `/api/v1/notifications` | Danh sách thông báo | ✅ |
| `GET` | `/api/v1/notifications/summary` | Tổng quan thông báo | ✅ |
| `PUT` | `/api/v1/notifications/{id}/read` | Đánh dấu đã đọc | ✅ |
| `PUT` | `/api/v1/notifications/read-all` | Đánh dấu tất cả đã đọc | ✅ |
| `DELETE` | `/api/v1/notifications/{id}` | Xóa thông báo | ✅ |
| `DELETE` | `/api/v1/notifications/selected` | Xóa nhiều thông báo | ✅ |

### 4.3.8. Quick Quiz Game APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `POST` | `/api/v1/games/quick-quiz/start` | Bắt đầu game | ✅ |
| `POST` | `/api/v1/games/quick-quiz/start-auto` | Bắt đầu game tự động | ✅ |
| `POST` | `/api/v1/games/quick-quiz/answer` | Trả lời câu hỏi | ✅ |
| `POST` | `/api/v1/games/quick-quiz/skip` | Bỏ qua câu hỏi | ✅ |
| `GET` | `/api/v1/games/quick-quiz/session/{sessionId}` | Xem kết quả game | ✅ |
| `GET` | `/api/v1/games/quick-quiz/instructions` | Hướng dẫn chơi | ✅ |
| `GET` | `/api/v1/games/quick-quiz/leaderboard` | Bảng xếp hạng | ✅ |

### 4.3.9. Image-Word Matching Game APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `POST` | `/api/v1/games/image-word-matching/start` | Bắt đầu game | ✅ |
| `POST` | `/api/v1/games/image-word-matching/start-auto` | Bắt đầu game tự động | ✅ |
| `POST` | `/api/v1/games/image-word-matching/answer` | Trả lời câu hỏi | ✅ |
| `GET` | `/api/v1/games/image-word-matching/session/{sessionId}` | Xem kết quả game | ✅ |
| `GET` | `/api/v1/games/image-word-matching/instructions` | Hướng dẫn chơi | ✅ |
| `GET` | `/api/v1/games/image-word-matching/leaderboard` | Bảng xếp hạng | ✅ |

### 4.3.10. Word-Definition Matching Game APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `POST` | `/api/v1/games/word-definition-matching/start` | Bắt đầu game | ✅ |
| `POST` | `/api/v1/games/word-definition-matching/start-auto` | Bắt đầu game tự động | ✅ |
| `POST` | `/api/v1/games/word-definition-matching/answer` | Trả lời câu hỏi | ✅ |
| `GET` | `/api/v1/games/word-definition-matching/session/{sessionId}` | Xem kết quả game | ✅ |
| `GET` | `/api/v1/games/word-definition-matching/instructions` | Hướng dẫn chơi | ✅ |
| `GET` | `/api/v1/games/word-definition-matching/leaderboard` | Bảng xếp hạng | ✅ |

### 4.3.11. Leaderboard APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `GET` | `/api/v1/leaderboard` | Bảng xếp hạng tổng | ✅ |
| `GET` | `/api/v1/leaderboard/game/{gameId}` | Bảng xếp hạng theo game | ✅ |

### 4.3.12. User Stats APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `GET` | `/api/v1/user-stats` | Thống kê học tập của user | ✅ |

### 4.3.13. Flashcard Review APIs (Spaced Repetition)

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `GET` | `/api/v1/flashcard-review/due` | Lấy từ cần ôn tập (SM-2) | ✅ |
| `POST` | `/api/v1/flashcard-review/review` | Ghi nhận kết quả ôn tập | ✅ |

### 4.3.14. User Vocab Progress APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `GET` | `/api/v1/user-vocab-progress` | Tiến độ học từ vựng | ✅ |
| `GET` | `/api/v1/user-vocab-progress/topic/{topicId}` | Tiến độ theo chủ đề | ✅ |

### 4.3.15. Learn Vocab APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `GET` | `/api/v1/learn-vocab/topic/{topicId}` | Lấy từ vựng để học theo topic | ✅ |
| `POST` | `/api/v1/learn-vocab/mark-known` | Đánh dấu từ đã biết | ✅ |

### 4.3.16. Chatbot APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `POST` | `/api/v1/chatbot/chat` | Chat với AI Gemini | ✅ |

### 4.3.17. Game Settings APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `GET` | `/api/v1/game-settings` | Lấy cài đặt game của user | ✅ |
| `PUT` | `/api/v1/game-settings` | Cập nhật cài đặt game | ✅ |

### 4.3.18. Offline Sync APIs

Hệ thống hỗ trợ chế độ offline cho phép người dùng học từ vựng và chơi game khi không có kết nối mạng. Dữ liệu được đồng bộ khi có mạng trở lại.

#### Download APIs - Tải dữ liệu về thiết bị

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `GET` | `/api/v1/offline/topics` | Lấy danh sách topics kèm tiến độ học | ✅ |
| `GET` | `/api/v1/offline/topics/{topicId}/vocabs` | Download từ vựng của 1 topic cụ thể | ✅ |
| `GET` | `/api/v1/offline/vocabs/recent` | Lấy từ vựng đã học gần đây (30 ngày) | ✅ |
| `GET` | `/api/v1/offline/check-updates` | Kiểm tra có dữ liệu mới sau lần sync cuối | ✅ |
| `GET` | `/api/v1/offline/user-vocab-progress` | Download tất cả tiến trình học từ vựng | ✅ |

#### Upload APIs - Đồng bộ dữ liệu lên server

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `POST` | `/api/v1/offline/sync/batch` | Batch upload tất cả trong 1 request (Recommended) | ✅ |
| `POST` | `/api/v1/offline/sync/complete` | Complete sync: sessions + details + progress | ✅ |
| `POST` | `/api/v1/offline/game-sessions` | Upload game sessions riêng lẻ (fallback) | ✅ |
| `POST` | `/api/v1/offline/user-vocab-progress` | Upload vocab progress riêng lẻ (fallback) | ✅ |
| `POST` | `/api/v1/offline/game-session-details` | Upload game session details riêng lẻ (fallback) | ✅ |

#### Luồng đồng bộ Offline

```
┌─────────────────────────────────────────────────────────────────┐
│                    OFFLINE SYNC FLOW                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────┐     1. Download Topics & Vocabs    ┌─────────┐    │
│  │  Client │ ◀──────────────────────────────────│  Server │    │
│  │ (Mobile)│                                    │         │    │
│  └─────────┘                                    └─────────┘    │
│       │                                              ▲         │
│       │  2. User học offline                         │         │
│       │     - Chơi game                              │         │
│       │     - Review flashcards                      │         │
│       │     - Đánh dấu từ đã biết                    │         │
│       ▼                                              │         │
│  ┌─────────┐     3. Batch Sync khi có mạng     ┌─────────┐    │
│  │  Local  │ ─────────────────────────────────▶│  Server │    │
│  │   DB    │     - Game sessions               │         │    │
│  └─────────┘     - Session details             └─────────┘    │
│                  - Vocab progress                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

#### Batch Sync Request Format

```json
{
  "gameSessions": [
    {
      "sessionId": "uuid",
      "gameId": 1,
      "score": 80,
      "totalQuestions": 10,
      "correctAnswers": 8,
      "startTime": "2025-11-09T10:00:00",
      "endTime": "2025-11-09T10:05:00"
    }
  ],
  "gameSessionDetails": [
    {
      "sessionId": "uuid",
      "vocabId": 123,
      "isCorrect": true,
      "responseTime": 2500
    }
  ],
  "userVocabProgress": [
    {
      "vocabId": 123,
      "status": "LEARNED",
      "lastReviewed": "2025-11-09T10:00:00"
    }
  ]
}
```

---

## 4.4. Admin API Endpoints

### 4.4.1. User Admin APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `GET` | `/api/v1/admin/users` | Danh sách người dùng | 🔐 Admin |
| `GET` | `/api/v1/admin/users/{id}` | Chi tiết người dùng theo ID | 🔐 Admin |
| `GET` | `/api/v1/admin/users/email/{email}` | Tìm người dùng theo email | 🔐 Admin |
| `GET` | `/api/v1/admin/users/search` | Tìm kiếm người dùng | 🔐 Admin |
| `GET` | `/api/v1/admin/users/statistics` | Thống kê người dùng | 🔐 Admin |
| `GET` | `/api/v1/admin/users/registration-chart` | Biểu đồ đăng ký theo ngày | 🔐 Admin |
| `GET` | `/api/v1/admin/users/system-overview` | Tổng quan hệ thống | 🔐 Admin |
| `GET` | `/api/v1/admin/users/game-stats` | Thống kê tất cả game | 🔐 Admin |
| `PUT` | `/api/v1/admin/users/{id}/ban` | Khóa/mở khóa tài khoản | 🔐 Admin |
| `PUT` | `/api/v1/admin/users/{id}/activate` | Kích hoạt tài khoản | 🔐 Admin |
| `PUT` | `/api/v1/admin/users/{id}/roles` | Cập nhật role người dùng | 🔐 Admin |
| `POST` | `/api/v1/admin/users/{id}/reset-password` | Reset mật khẩu | 🔐 Admin |
| `DELETE` | `/api/v1/admin/users/{id}` | Xóa người dùng | 🔐 Admin |

### 4.4.2. Vocab Admin APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `GET` | `/api/v1/admin/vocabs` | Danh sách từ vựng | 🔐 Admin |
| `GET` | `/api/v1/admin/vocabs/{id}` | Chi tiết từ vựng | 🔐 Admin |
| `GET` | `/api/v1/admin/vocabs/word/{word}` | Tìm từ vựng theo từ | 🔐 Admin |
| `GET` | `/api/v1/admin/vocabs/search` | Tìm kiếm từ vựng | 🔐 Admin |
| `GET` | `/api/v1/admin/vocabs/cefr/{cefr}` | Lọc theo CEFR level | 🔐 Admin |
| `POST` | `/api/v1/admin/vocabs` | Thêm từ vựng mới | 🔐 Admin |
| `POST` | `/api/v1/admin/vocabs/bulk-import` | Import hàng loạt từ vựng | 🔐 Admin |
| `PUT` | `/api/v1/admin/vocabs/{id}` | Cập nhật từ vựng theo ID | 🔐 Admin |
| `PUT` | `/api/v1/admin/vocabs/word/{word}` | Cập nhật từ vựng theo từ | 🔐 Admin |
| `DELETE` | `/api/v1/admin/vocabs/{id}` | Xóa từ vựng | 🔐 Admin |
| `GET` | `/api/v1/admin/vocabs/export/excel` | Xuất file Excel | 🔐 Admin |

### 4.4.3. Topic Admin APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `GET` | `/api/v1/admin/topics` | Danh sách chủ đề | 🔐 Admin |
| `POST` | `/api/v1/admin/topics` | Thêm chủ đề mới | 🔐 Admin |
| `PUT` | `/api/v1/admin/topics/{id}` | Cập nhật chủ đề | 🔐 Admin |
| `DELETE` | `/api/v1/admin/topics/{id}` | Xóa chủ đề | 🔐 Admin |

### 4.4.4. Type Admin APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `GET` | `/api/v1/admin/types` | Danh sách loại từ | 🔐 Admin |
| `POST` | `/api/v1/admin/types` | Thêm loại từ mới | 🔐 Admin |
| `PUT` | `/api/v1/admin/types/{id}` | Cập nhật loại từ | 🔐 Admin |
| `DELETE` | `/api/v1/admin/types/{id}` | Xóa loại từ | 🔐 Admin |

### 4.4.5. Game Admin APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `GET` | `/api/v1/admin/games` | Danh sách game | 🔐 Admin |
| `GET` | `/api/v1/admin/games/stats` | Thống kê tất cả game | 🔐 Admin |

### 4.4.6. Notification Admin APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `POST` | `/api/v1/admin/notifications` | Tạo thông báo cho user | 🔐 Admin |
| `POST` | `/api/v1/admin/notifications/broadcast` | Broadcast tới tất cả users | 🔐 Admin |

### 4.4.7. Action Log APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `GET` | `/api/v1/admin/action-logs` | Danh sách action logs | 🔐 Admin |
| `GET` | `/api/v1/admin/action-logs/statistics` | Thống kê logs | 🔐 Admin |
| `GET` | `/api/v1/admin/action-logs/export` | Export logs | 🔐 Admin |
| `DELETE` | `/api/v1/admin/action-logs/cleanup` | Xóa logs cũ | 🔐 Admin |

### 4.4.8. Vocab Progress Admin APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `GET` | `/api/v1/admin/vocab-progress` | Tiến độ học của tất cả users | 🔐 Admin |
| `GET` | `/api/v1/admin/vocab-progress/user/{userId}` | Tiến độ theo user cụ thể | 🔐 Admin |

### 4.4.9. Firebase Storage APIs

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| `POST` | `/api/v1/admin/storage/upload` | Upload file lên Firebase | 🔐 Admin |
| `DELETE` | `/api/v1/admin/storage/delete` | Xóa file trên Firebase | 🔐 Admin |

---

## 4.5. WebSocket Endpoints

### 4.5.1. Kết nối WebSocket

| Endpoint | Mô tả |
|----------|-------|
| `ws://localhost:8080/ws` | WebSocket connection endpoint |

### 4.5.2. STOMP Subscription Channels

| Channel | Mô tả | Auth |
|---------|-------|------|
| `/user/queue/notifications` | Nhận thông báo mới real-time | ✅ |
| `/user/queue/notifications/read` | Sự kiện đánh dấu đã đọc | ✅ |
| `/user/queue/notifications/read-all` | Sự kiện đánh dấu tất cả đã đọc | ✅ |
| `/user/queue/notifications/deleted` | Sự kiện xóa thông báo | ✅ |
| `/user/queue/notifications/batch-deleted` | Sự kiện xóa hàng loạt | ✅ |
| `/topic/admin/user-registrations` | Admin: User mới đăng ký | 🔐 Admin |

---

## 4.6. Rate Limiting

| Endpoint | Limit | Window | Mô tả |
|----------|-------|--------|-------|
| `/api/v1/auth/signin` | 5 requests | 15 phút | Chống brute force |
| `/api/v1/auth/signup` | 3 requests | 1 giờ | Chống spam đăng ký |
| `/api/v1/auth/forgot-password` | 3 requests | 1 giờ | Chống spam email |
| Các API khác | 100 requests | 1 phút | Rate limit chung |

---

## 4.7. Tài liệu API tương tác

| Công cụ | URL | Mô tả |
|---------|-----|-------|
| Swagger UI | `http://localhost:8080/swagger-ui.html` | Test API trực tiếp |
| OpenAPI Spec | `http://localhost:8080/v3/api-docs` | JSON specification |

---

## 4.8. Tổng kết

### Thống kê API Endpoints

| Nhóm | Số lượng |
|------|----------|
| Authentication | 6 |
| User | 8 |
| Vocabulary | 7 |
| Topic & Type | 3 |
| Notification | 6 |
| Games (3 loại) | 21 |
| Leaderboard | 2 |
| Learning Progress | 8 |
| Chatbot & Settings | 3 |
| Offline Sync | 10 |
| **Admin APIs** | 35 |
| **Tổng cộng** | **~109 endpoints** |

### Đặc điểm thiết kế

1. **RESTful Architecture**: Tuân thủ nguyên tắc REST
2. **JWT Authentication**: Bảo mật với token-based authentication
3. **Role-Based Access Control**: Phân quyền User/Admin
4. **Real-time Communication**: WebSocket cho thông báo
5. **Pagination & Filtering**: Hỗ trợ phân trang và lọc
6. **Rate Limiting**: Bảo vệ API khỏi abuse
7. **Comprehensive Documentation**: Swagger UI và OpenAPI
