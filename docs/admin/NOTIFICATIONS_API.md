# Notifications API Documentation

## Tổng quan

Hệ thống Notifications cung cấp khả năng thông báo cho người dùng về các sự kiện quan trọng trong ứng dụng Card Words. Người dùng có thể nhận thông báo về nhắc nhở học từ vựng, tính năng mới, thành tựu đạt được, cảnh báo hệ thống và tiến trình học tập.

## Kiến trúc

### Database Schema

```sql
notifications
├── id (BIGSERIAL, PK)
├── user_id (UUID, FK -> users.id)
├── title (VARCHAR(255))
├── content (TEXT)
├── type (VARCHAR(50))
├── is_read (BOOLEAN, default: false)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

### Components

```
Notification Entity
    ↓
NotificationRepository
    ↓
NotificationService
    ↓
├── NotificationController (User)
└── NotificationAdminController (Admin)
```

## Notification Types

### 1. vocab_reminder

Nhắc nhở người dùng ôn tập từ vựng

**Example:**

-   Title: "Vocabulary Review Reminder"
-   Content: "Your vocabulary review session is scheduled for tomorrow..."

### 2. new_feature

Thông báo về tính năng mới

**Example:**

-   Title: "New Vocabulary Package Available"
-   Content: "New vocabulary package 'Business English Advanced' has been added..."

### 3. achievement

Thông báo về thành tựu đạt được

**Example:**

-   Title: "Achievement Unlocked!"
-   Content: "Congratulations! You've completed 100 vocabulary words..."

### 4. system_alert

Cảnh báo từ hệ thống

**Example:**

-   Title: "System Maintenance Notice"
-   Content: "System will be under maintenance on..."

### 5. study_progress

Thông báo về tiến trình học tập

**Example:**

-   Title: "Weekly Progress Report"
-   Content: "You've studied 50 new words this week..."

### 6. game_achievement

Thành tích trong game (Quick Quiz, Word Definition, etc.)

**Example:**

-   Title: "🎯 Perfect Score!"
-   Content: "Amazing! You answered all questions correctly..."

### 7. streak_milestone

Cột mốc streak (3, 7, 30 ngày)

**Example:**

-   Title: "🔥 7-Day Streak Milestone!"
-   Content: "Congratulations! You've maintained a 7-day learning streak..."

### 8. streak_reminder

Nhắc nhở duy trì streak

**Example:**

-   Title: "🔥 Don't lose your streak!"
-   Content: "You haven't studied today. Complete a lesson to keep your streak alive!"

### 9. streak_break

Cảnh báo chuỗi học bị gián đoạn

**Example:**

-   Title: "💔 Streak Broken"
-   Content: "You missed yesterday. Start a new streak today!"

## User APIs

### 1. Lấy danh sách thông báo

**Endpoint:** `GET /api/v1/notifications`

**Permission:** Authenticated User

**Query Parameters:**

-   `isRead` (Boolean, optional) - Lọc theo trạng thái đã đọc
-   `type` (String, optional) - Lọc theo loại thông báo
-   `page` (Integer, default: 0) - Số trang
-   `size` (Integer, default: 10) - Kích thước trang

**Example Request:**

```bash
GET http://localhost:8080/api/v1/notifications?isRead=false&page=0&size=10
Authorization: Bearer <token>
```

**Response:**

```json
{
    "statusCode": 200,
    "message": "Lấy danh sách thông báo thành công",
    "data": {
        "content": [
            {
                "id": 1,
                "title": "Vocabulary Review Reminder",
                "content": "Your vocabulary review session is scheduled for tomorrow. Make sure to complete your daily practice to maintain your learning streak!",
                "type": "vocab_reminder",
                "isRead": false,
                "createdAt": "2024-01-20T10:00:00"
            },
            {
                "id": 2,
                "title": "New Vocabulary Package Available",
                "content": "New vocabulary package 'Business English Advanced' has been added to your available courses. Start learning now to expand your professional vocabulary.",
                "type": "new_feature",
                "isRead": false,
                "createdAt": "2024-01-20T09:00:00"
            }
        ],
        "pageable": {
            "pageNumber": 0,
            "pageSize": 10
        },
        "totalElements": 10,
        "totalPages": 1
    }
}
```

### 2. Lấy tổng quan thông báo

**Endpoint:** `GET /api/v1/notifications/summary`

**Permission:** Authenticated User

**Example Request:**

```bash
GET http://localhost:8080/api/v1/notifications/summary
Authorization: Bearer <token>
```

**Response:**

```json
{
    "statusCode": 200,
    "message": "Lấy tổng quan thành công",
    "data": {
        "totalNotifications": 10,
        "unreadNotifications": 2,
        "readNotifications": 8
    }
}
```

### 3. Đánh dấu thông báo đã đọc

**Endpoint:** `PUT /api/v1/notifications/{id}/read`

**Permission:** Authenticated User

**Example Request:**

```bash
PUT http://localhost:8080/api/v1/notifications/1/read
Authorization: Bearer <token>
```

**Response:**

```json
{
    "statusCode": 200,
    "message": "Đánh dấu đã đọc thành công",
    "data": null
}
```

### 4. Đánh dấu tất cả thông báo đã đọc

**Endpoint:** `PUT /api/v1/notifications/read-all`

**Permission:** Authenticated User

**Example Request:**

```bash
PUT http://localhost:8080/api/v1/notifications/read-all
Authorization: Bearer <token>
```

**Response:**

```json
{
    "statusCode": 200,
    "message": "Đã đánh dấu 5 thông báo",
    "data": 5
}
```

### 5. Xóa thông báo

**Endpoint:** `DELETE /api/v1/notifications/{id}`

**Permission:** Authenticated User

**Example Request:**

```bash
DELETE http://localhost:8080/api/v1/notifications/1
Authorization: Bearer <token>
```

**Response:**

```json
{
    "statusCode": 200,
    "message": "Xóa thông báo thành công",
    "data": null
}
```

### 6. Xóa nhiều thông báo

**Endpoint:** `DELETE /api/v1/notifications/selected`

**Permission:** Authenticated User

**Request Body:**

```json
[1, 2, 3]
```

**Example Request:**

```bash
DELETE http://localhost:8080/api/v1/notifications/selected
Authorization: Bearer <token>
Content-Type: application/json

[1, 2, 3]
```

**Response:**

```json
{
    "statusCode": 200,
    "message": "Xóa thông báo thành công",
    "data": null
}
```

## Admin APIs

### 1. Tạo thông báo cho một user

**Endpoint:** `POST /api/v1/admin/notifications`

**Permission:** ADMIN

**Request Body:**

```json
{
    "userId": "uuid-here",
    "title": "Vocabulary Review Reminder",
    "content": "Your vocabulary review session is scheduled for tomorrow...",
    "type": "vocab_reminder"
}
```

**Example Request:**

```bash
POST http://localhost:8080/api/v1/admin/notifications
Authorization: Bearer <admin-token>
Content-Type: application/json

{
  "userId": "123e4567-e89b-12d3-a456-426614174000",
  "title": "Vocabulary Review Reminder",
  "content": "Your vocabulary review session is scheduled for tomorrow. Make sure to complete your daily practice to maintain your learning streak!",
  "type": "vocab_reminder"
}
```

**Response:**

```json
{
    "statusCode": 200,
    "message": "Tạo thông báo thành công",
    "data": {
        "id": 1,
        "title": "Vocabulary Review Reminder",
        "content": "Your vocabulary review session is scheduled for tomorrow...",
        "type": "vocab_reminder",
        "isRead": false,
        "createdAt": "2024-01-20T10:00:00"
    }
}
```

### 2. Tạo thông báo cho tất cả users

**Endpoint:** `POST /api/v1/admin/notifications/broadcast`

**Permission:** ADMIN

**Request Body:**

```json
{
    "title": "New Vocabulary Package Available",
    "content": "New vocabulary package 'Business English Advanced' has been added to your available courses...",
    "type": "new_feature"
}
```

**Example Request:**

```bash
POST http://localhost:8080/api/v1/admin/notifications/broadcast
Authorization: Bearer <admin-token>
Content-Type: application/json

{
  "title": "New Vocabulary Package Available",
  "content": "New vocabulary package 'Business English Advanced' has been added to your available courses. Start learning now to expand your professional vocabulary.",
  "type": "new_feature"
}
```

**Response:**

```json
{
    "statusCode": 200,
    "message": "Tạo thông báo cho tất cả users thành công",
    "data": null
}
```

## Integration Examples

### 1. Tự động tạo thông báo khi hoàn thành game

```java
@Service
public class GameService {

    @Autowired
    private NotificationService notificationService;

    public void completeGameSession(UUID userId, int score) {
        // Complete game logic...

        // Create achievement notification
        if (score >= 90) {
            CreateNotificationRequest request = CreateNotificationRequest.builder()
                .userId(userId)
                .title("Achievement Unlocked!")
                .content("Congratulations! You've achieved a score of " + score + " in the game!")
                .type("achievement")
                .build();

            notificationService.createNotification(request);
        }
    }
}
```

### 2. Scheduled reminder cho vocabulary review

```java
@Service
public class ScheduledNotificationService {

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private UserRepository userRepository;

    @Scheduled(cron = "0 0 9 * * *") // Every day at 9 AM
    public void sendVocabReviewReminders() {
        List<User> users = userRepository.findAll();

        for (User user : users) {
            CreateNotificationRequest request = CreateNotificationRequest.builder()
                .userId(user.getId())
                .title("Vocabulary Review Reminder")
                .content("Time for your daily vocabulary review! Keep your learning streak going!")
                .type("vocab_reminder")
                .build();

            notificationService.createNotification(request);
        }
    }
}
```

## Frontend Integration

### Display notification badge

```javascript
// Fetch notification summary
const getNotificationSummary = async () => {
    const response = await fetch('/api/v1/notifications/summary', {
        headers: {
            Authorization: `Bearer ${token}`,
        },
    });
    const data = await response.json();

    // Display unread count in badge
    document.getElementById('notification-badge').innerText = data.data.unreadNotifications;
};
```

### Mark notification as read when clicked

```javascript
const markAsRead = async (notificationId) => {
    await fetch(`/api/v1/notifications/${notificationId}/read`, {
        method: 'PUT',
        headers: {
            Authorization: `Bearer ${token}`,
        },
    });

    // Refresh notification list
    loadNotifications();
};
```

## Best Practices

### 1. Notification Content

-   **Rõ ràng và ngắn gọn**: Title nên ngắn gọn (< 50 ký tự)
-   **Hữu ích**: Content cung cấp thông tin có giá trị cho user
-   **Call-to-action**: Hướng dẫn user làm gì tiếp theo nếu cần

### 2. Notification Types

-   Sử dụng đúng type cho từng loại thông báo
-   Giúp user có thể filter notifications
-   Có thể customize UI dựa trên type

### 3. Frequency

-   Không spam quá nhiều thông báo
-   Cho phép user customize notification preferences
-   Group similar notifications nếu có thể

### 4. Privacy

-   Không gửi thông tin nhạy cảm qua notifications
-   Chỉ user owner mới xem được notifications của mình

## Performance Considerations

### Indexes

-   `idx_notif_user_id` - Tìm kiếm theo user
-   `idx_notif_is_read` - Lọc theo trạng thái
-   `idx_notif_type` - Lọc theo loại
-   `idx_notif_created_at` - Sắp xếp theo thời gian

### Pagination

-   Luôn sử dụng pagination cho danh sách
-   Default page size: 10
-   Max page size: 50

### Cleanup

-   Tự động xóa notifications đã đọc sau 30 ngày
-   Giữ unread notifications vô thời hạn
-   User có thể xóa manually

## Security

### Access Control

-   User chỉ xem được notifications của mình
-   Admin có thể tạo notifications cho bất kỳ user nào
-   Validation userId trước khi thao tác

### Data Validation

-   Title: required, max 255 characters
-   Content: optional, max 5000 characters
-   Type: optional, max 50 characters
-   Valid types: vocab_reminder, new_feature, achievement, system_alert, study_progress

## Troubleshooting

### Notifications không hiển thị

1. Kiểm tra user đã đăng nhập
2. Verify userId trong request
3. Check filters applied

### Mark as read không hoạt động

1. Verify notification ID
2. Check user permissions
3. Ensure notification belongs to user

### Broadcast quá chậm

1. Thực hiện async nếu có nhiều users
2. Batch processing
3. Use message queue cho large scale

## Related Files

-   Entity: `core/domain/Notification.java`
-   Repository: `dataprovider/repository/NotificationRepository.java`
-   Service: `core/usecase/user/NotificationService.java`
-   Controllers:
    -   `entrypoint/rest/v1/user/NotificationController.java`
    -   `entrypoint/rest/v1/admin/NotificationAdminController.java`
-   DTOs:
    -   `entrypoint/dto/request/CreateNotificationRequest.java`
    -   `entrypoint/dto/request/NotificationFilterRequest.java`
    -   `entrypoint/dto/response/NotificationResponse.java`
    -   `entrypoint/dto/response/NotificationSummaryResponse.java`
