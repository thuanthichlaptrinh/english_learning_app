# Admin Dashboard API Documentation

## Tổng quan

Các API này cung cấp thống kê và dữ liệu cho trang admin dashboard, bao gồm:

-   Thống kê tổng quan hệ thống
-   Biểu đồ đăng ký người dùng theo ngày
-   Top học viên giỏi nhất
-   Thống kê chi tiết các game

---

## 1. Lấy biểu đồ đăng ký người dùng và top học viên

**GET** `/api/v1/admin/users/registration-chart`

Lấy thống kê số người dùng đăng ký theo từng ngày và danh sách top học viên.

### Query Parameters

| Tham số | Kiểu | Mặc định | Mô tả                                       |
| ------- | ---- | -------- | ------------------------------------------- |
| days    | int  | 30       | Số ngày thống kê (từ hiện tại trở về trước) |

### Response

```json
{
    "status": "success",
    "message": "Lấy biểu đồ đăng ký thành công",
    "data": {
        "stats": {
            "totalUsers": 1230,
            "totalVocabs": 8540,
            "totalNotifications": 35,
            "totalLearningSession": 12430
        },
        "userRegistrationChart": [
            {
                "date": "2024-01-01",
                "count": 20
            },
            {
                "date": "2024-01-02",
                "count": 30
            }
        ],
        "topLearners": [
            {
                "userId": "123e4567-e89b-12d3-a456-426614174000",
                "name": "Nguyễn Văn A",
                "email": "user@example.com",
                "avatarUrl": "https://firebase.url/avatar.jpg",
                "totalWordsLearned": 500,
                "currentStreak": 15,
                "totalScore": 25000
            }
        ]
    }
}
```

### Ví dụ

```bash
# Lấy thống kê 30 ngày gần nhất
curl -X GET "http://localhost:8080/api/v1/admin/users/registration-chart?days=30" \
  -H "Authorization: Bearer <admin_token>"

# Lấy thống kê 7 ngày gần nhất
curl -X GET "http://localhost:8080/api/v1/admin/users/registration-chart?days=7" \
  -H "Authorization: Bearer <admin_token>"
```

---

## 2. Lấy tổng quan hệ thống

**GET** `/api/v1/admin/users/system-overview`

Lấy thống kê tổng quan toàn bộ hệ thống.

### Response

```json
{
    "status": "success",
    "message": "Lấy tổng quan hệ thống thành công",
    "data": {
        "totalUsers": 1230,
        "activeUsersToday": 150,
        "totalVocabs": 8540,
        "totalTopics": 25,
        "totalGameSessions": 15000,
        "completedGameSessions": 12430,
        "averageScore": 1850.5,
        "highestScore": 5000,
        "totalWordsLearned": 45000
    }
}
```

### Mô tả các trường

| Trường                | Kiểu   | Mô tả                             |
| --------------------- | ------ | --------------------------------- |
| totalUsers            | long   | Tổng số người dùng trong hệ thống |
| activeUsersToday      | long   | Số người dùng hoạt động hôm nay   |
| totalVocabs           | long   | Tổng số từ vựng                   |
| totalTopics           | long   | Tổng số chủ đề                    |
| totalGameSessions     | long   | Tổng số phiên chơi game           |
| completedGameSessions | long   | Số phiên game đã hoàn thành       |
| averageScore          | double | Điểm trung bình của tất cả game   |
| highestScore          | int    | Điểm cao nhất từng đạt được       |
| totalWordsLearned     | long   | Tổng số từ đã được học            |

### Ví dụ

```bash
curl -X GET "http://localhost:8080/api/v1/admin/users/system-overview" \
  -H "Authorization: Bearer <admin_token>"
```

---

## 3. Lấy thống kê các game

**GET** `/api/v1/admin/users/game-stats`

Lấy thống kê chi tiết của từng game trong hệ thống.

### Response

```json
{
    "status": "success",
    "message": "Lấy thống kê game thành công",
    "data": [
        {
            "gameId": 1,
            "gameName": "Quick Quiz",
            "totalSessions": 5000,
            "completedSessions": 4500,
            "averageScore": 1850.5,
            "highestScore": 3000,
            "averageAccuracy": 85.5
        },
        {
            "gameId": 2,
            "gameName": "Image Word Matching",
            "totalSessions": 4000,
            "completedSessions": 3800,
            "averageScore": 2100.0,
            "highestScore": 4000,
            "averageAccuracy": 90.2
        },
        {
            "gameId": 3,
            "gameName": "Word Definition Matching",
            "totalSessions": 3500,
            "completedSessions": 3200,
            "averageScore": 1950.0,
            "highestScore": 3500,
            "averageAccuracy": 88.0
        }
    ]
}
```

### Mô tả các trường

| Trường            | Kiểu   | Mô tả                       |
| ----------------- | ------ | --------------------------- |
| gameId            | long   | ID của game                 |
| gameName          | string | Tên game                    |
| totalSessions     | long   | Tổng số phiên chơi          |
| completedSessions | long   | Số phiên đã hoàn thành      |
| averageScore      | double | Điểm trung bình             |
| highestScore      | int    | Điểm cao nhất               |
| averageAccuracy   | double | Độ chính xác trung bình (%) |

### Ví dụ

```bash
curl -X GET "http://localhost:8080/api/v1/admin/users/game-stats" \
  -H "Authorization: Bearer <admin_token>"
```

---

## 4. Lấy thống kê người dùng cơ bản

**GET** `/api/v1/admin/users/statistics`

Lấy thống kê cơ bản về người dùng (API đã có sẵn).

### Response

```json
{
    "status": "success",
    "message": "Lấy thống kê thành công",
    "data": {
        "totalUsers": 1230,
        "activatedUsers": 1150,
        "bannedUsers": 20,
        "adminUsers": 5,
        "normalUsers": 1225
    }
}
```

---

## Use Cases cho Frontend

### Dashboard Page

```javascript
// 1. Load tổng quan hệ thống (hiển thị ở header cards)
const systemOverview = await fetch('/api/v1/admin/users/system-overview');
// Hiển thị: Người dùng, Từ vựng, Thông báo, Lượt học

// 2. Load biểu đồ đăng ký (hiển thị chart)
const registrationData = await fetch('/api/v1/admin/users/registration-chart?days=30');
// Vẽ line chart với data.userRegistrationChart

// 3. Hiển thị top học viên (bảng xếp hạng)
// Sử dụng data.topLearners từ API registration-chart

// 4. Thống kê game (optional - hiển thị ở section riêng)
const gameStats = await fetch('/api/v1/admin/users/game-stats');
// Hiển thị bảng hoặc cards cho từng game
```

---

## Authorization

Tất cả các API này yêu cầu:

-   **Bearer Token** trong header `Authorization`
-   **Role**: `ROLE_ADMIN`

```bash
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

---

## Error Responses

### 401 Unauthorized

```json
{
    "status": "error",
    "message": "Unauthorized",
    "data": null
}
```

### 403 Forbidden

```json
{
    "status": "error",
    "message": "Access Denied - Admin role required",
    "data": null
}
```

---

## Performance Notes

-   API `registration-chart` có thể mất 200-500ms tùy thuộc vào số lượng người dùng
-   API `system-overview` được tối ưu với các query đếm nhanh
-   API `game-stats` sẽ chậm hơn nếu có nhiều game sessions (có thể cache kết quả)
-   Nên cache kết quả ở frontend trong 5-10 phút để giảm tải server

---

## Changelog

### Version 1.0.0 (2024-11-17)

-   Thêm API `/registration-chart` - Biểu đồ đăng ký và top học viên
-   Thêm API `/system-overview` - Tổng quan hệ thống
-   Thêm API `/game-stats` - Thống kê các game
