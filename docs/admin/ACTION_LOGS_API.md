# Action Logs API Documentation

## Tổng quan

Action Logs là hệ thống ghi nhận và theo dõi tất cả các hoạt động của người dùng và hệ thống trong ứng dụng Card Words. Hệ thống này giúp admin giám sát, phân tích và kiểm toán các hành động diễn ra trong ứng dụng.

## Kiến trúc

### Database Schema

```sql
action_logs
├── id (BIGSERIAL, PK)
├── user_id (UUID)
├── user_email (VARCHAR(100))
├── user_name (VARCHAR(100))
├── action_type (VARCHAR(50)) -- Loại hành động
├── action_category (VARCHAR(50)) -- Danh mục
├── resource_type (VARCHAR(50)) -- Loại tài nguyên
├── resource_id (VARCHAR(100)) -- ID tài nguyên
├── description (TEXT)
├── status (VARCHAR(20)) -- SUCCESS, FAILED
├── ip_address (VARCHAR(50))
├── user_agent (TEXT)
├── metadata (TEXT) -- JSON string
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

### Components

```
ActionLog Entity
    ↓
ActionLogRepository
    ↓
ActionLogService
    ↓
ActionLogController (Admin)
```

## Action Types

### User Actions

-   `USER_LOGIN` - Đăng nhập
-   `USER_LOGOUT` - Đăng xuất
-   `USER_REGISTER` - Đăng ký
-   `USER_UPDATE_PROFILE` - Cập nhật profile
-   `USER_CHANGE_PASSWORD` - Đổi mật khẩu
-   `USER_ROLE_ASSIGN` - Gán role

### Vocabulary Actions

-   `VOCAB_CREATE` - Tạo từ vựng
-   `VOCAB_UPDATE` - Cập nhật từ vựng
-   `VOCAB_DELETE` - Xóa từ vựng
-   `VOCAB_IMPORT` - Import từ vựng

### Game Actions

-   `GAME_SESSION_COMPLETE` - Hoàn thành game
-   `GAME_SESSION_START` - Bắt đầu game

### System Actions

-   `SYSTEM_ERROR` - Lỗi hệ thống
-   `SYSTEM_MAINTENANCE` - Bảo trì

## API Endpoints

### 1. Lấy danh sách Action Logs

**Endpoint:** `GET /api/v1/admin/action-logs`

**Permission:** ADMIN

**Query Parameters:**

-   `userId` (UUID, optional) - Lọc theo user
-   `actionType` (String, optional) - Lọc theo loại action
-   `resourceType` (String, optional) - Lọc theo loại resource
-   `status` (String, optional) - Lọc theo trạng thái (SUCCESS/FAILED)
-   `startDate` (ISO DateTime, optional) - Từ ngày
-   `endDate` (ISO DateTime, optional) - Đến ngày
-   `keyword` (String, optional) - Tìm kiếm trong description, email, name
-   `page` (Integer, default: 0) - Số trang
-   `size` (Integer, default: 10) - Kích thước trang
-   `sortBy` (String, default: "createdAt") - Sắp xếp theo
-   `sortDirection` (String, default: "DESC") - Hướng sắp xếp

**Example Request:**

```bash
GET http://localhost:8080/api/v1/admin/action-logs?status=SUCCESS&page=0&size=10
Authorization: Bearer <token>
```

**Response:**

```json
{
    "statusCode": 200,
    "message": "Lấy danh sách action logs thành công",
    "data": {
        "content": [
            {
                "id": 1,
                "userId": "uuid-here",
                "userEmail": "john.doe@example.com",
                "userName": "John Doe",
                "actionType": "USER_LOGIN",
                "actionCategory": "SYSTEM",
                "resourceType": "Authentication System",
                "resourceId": "system",
                "description": "User logged in successfully",
                "status": "SUCCESS",
                "ipAddress": "192.168.1.1",
                "createdAt": "2024-01-20T23:00:00"
            }
        ],
        "pageable": {
            "pageNumber": 0,
            "pageSize": 10
        },
        "totalElements": 100,
        "totalPages": 10
    }
}
```

### 2. Lấy thống kê Action Logs

**Endpoint:** `GET /api/v1/admin/action-logs/statistics`

**Permission:** ADMIN

**Example Request:**

```bash
GET http://localhost:8080/api/v1/admin/action-logs/statistics
Authorization: Bearer <token>
```

**Response:**

```json
{
    "statusCode": 200,
    "message": "Lấy thống kê thành công",
    "data": {
        "totalActions": 10,
        "successfulActions": 9,
        "failedActions": 1,
        "activeUsers": 6
    }
}
```

### 3. Export Action Logs

**Endpoint:** `GET /api/v1/admin/action-logs/export`

**Permission:** ADMIN

**Query Parameters:**

-   `startDate` (ISO DateTime, optional)
-   `endDate` (ISO DateTime, optional)

**Example Request:**

```bash
GET http://localhost:8080/api/v1/admin/action-logs/export?startDate=2024-01-01T00:00:00&endDate=2024-12-31T23:59:59
Authorization: Bearer <token>
```

### 4. Xóa Action Logs cũ

**Endpoint:** `DELETE /api/v1/admin/action-logs/cleanup`

**Permission:** ADMIN

**Query Parameters:**

-   `daysToKeep` (Integer, default: 90) - Số ngày cần giữ lại

**Example Request:**

```bash
DELETE http://localhost:8080/api/v1/admin/action-logs/cleanup?daysToKeep=90
Authorization: Bearer <token>
```

## Logging Actions

### Trong Service Layer

```java
@Autowired
private ActionLogService actionLogService;

public void someMethod(UUID userId, String userEmail, String userName) {
    try {
        // Business logic here

        // Log success
        actionLogService.logAction(
            userId,
            userEmail,
            userName,
            "VOCAB_CREATE",
            "VOCAB",
            "Vocabulary",
            String.valueOf(vocab.getId()),
            "Created new vocabulary: " + vocab.getWord(),
            "SUCCESS",
            request.getRemoteAddr(),
            request.getHeader("User-Agent")
        );
    } catch (Exception e) {
        // Log failure
        actionLogService.logAction(
            userId,
            userEmail,
            userName,
            "VOCAB_CREATE",
            "VOCAB",
            "Vocabulary",
            null,
            "Failed to create vocabulary: " + e.getMessage(),
            "FAILED",
            request.getRemoteAddr(),
            request.getHeader("User-Agent")
        );
        throw e;
    }
}
```

## Best Practices

### 1. Action Type Naming

-   Sử dụng định dạng: `RESOURCE_ACTION`
-   Ví dụ: `USER_LOGIN`, `VOCAB_CREATE`, `GAME_START`

### 2. Resource Type

-   Sử dụng tên rõ ràng, có ý nghĩa
-   Ví dụ: "Authentication System", "Vocabulary", "Game Session"

### 3. Description

-   Viết mô tả chi tiết, dễ hiểu
-   Bao gồm thông tin quan trọng về hành động
-   Ví dụ: "Created new vocabulary: perseverance"

### 4. Status

-   Chỉ sử dụng: `SUCCESS` hoặc `FAILED`
-   Luôn log cả success và failure

### 5. Data Retention

-   Định kỳ xóa logs cũ để tiết kiệm storage
-   Mặc định giữ lại 90 ngày
-   Có thể export trước khi xóa

## Performance Considerations

### Indexes

-   `idx_action_log_user_id` - Tìm kiếm theo user
-   `idx_action_log_action_type` - Lọc theo loại action
-   `idx_action_log_resource_type` - Lọc theo resource
-   `idx_action_log_status` - Lọc theo status
-   `idx_action_log_created_at` - Sắp xếp theo thời gian

### Query Optimization

-   Sử dụng pagination cho danh sách lớn
-   Filter càng cụ thể càng tốt
-   Limit kết quả export nếu cần

## Security

### Access Control

-   Chỉ ADMIN mới có quyền truy cập
-   Sử dụng `@PreAuthorize("hasRole('ROLE_ADMIN')")`

### Data Privacy

-   Không lưu password hoặc thông tin nhạy cảm
-   IP address và User Agent cho mục đích audit only

### Audit Trail

-   Tất cả actions đều được log
-   Không thể sửa đổi logs đã tạo
-   Chỉ có thể xóa (với quyền admin)

## Troubleshooting

### Logs không được tạo

1. Kiểm tra service có inject ActionLogService
2. Kiểm tra database connection
3. Xem application logs để biết lỗi

### Performance chậm

1. Kiểm tra số lượng records
2. Sử dụng filters để giảm kết quả
3. Tăng page size hợp lý
4. Chạy cleanup để xóa logs cũ

### Export quá lớn

1. Thu hẹp khoảng thời gian
2. Thêm filters cụ thể
3. Export theo batch nhỏ hơn

## Related Files

-   Entity: `core/domain/ActionLog.java`
-   Repository: `dataprovider/repository/ActionLogRepository.java`
-   Service: `core/usecase/admin/ActionLogService.java`
-   Controller: `entrypoint/rest/v1/admin/ActionLogController.java`
-   DTOs: `entrypoint/dto/request/ActionLogFilterRequest.java`, `entrypoint/dto/response/ActionLogResponse.java`
-   Migration: `resources/db/migration/V7__add_action_logs_table.sql`
