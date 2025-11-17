# 🔥 STREAK API DOCUMENTATION

## Base URL
```
http://localhost:8080/api/v1/user/streak
```

## Authentication
All endpoints require JWT Bearer token in header:
```
Authorization: Bearer <jwt_token>
```

---

## 📡 ENDPOINTS

### 1. GET `/api/v1/user/streak` - Lấy thông tin streak

**Description:** Lấy thông tin chuỗi ngày học hiện tại của user

**Method:** `GET`

**Headers:**
```
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

**Response 200 - Success:**
```json
{
  "status": "200",
  "message": "Lấy thông tin streak thành công",
  "data": {
    "currentStreak": 7,
    "longestStreak": 15,
    "lastActivityDate": "2025-10-31",
    "totalStudyDays": 45,
    "streakStatus": "ACTIVE",
    "daysUntilBreak": 0,
    "message": "Tuyệt vời! Bạn đang có streak 7 ngày! 🔥"
  }
}
```

**Response Fields:**
| Field | Type | Description |
|-------|------|-------------|
| `currentStreak` | Integer | Số ngày học liên tục hiện tại |
| `longestStreak` | Integer | Kỷ lục streak cao nhất từng đạt được |
| `lastActivityDate` | Date | Ngày học gần nhất (YYYY-MM-DD) |
| `totalStudyDays` | Integer | Tổng số ngày đã học (không cần liên tục) |
| `streakStatus` | String | Trạng thái: NEW, ACTIVE, PENDING, BROKEN |
| `daysUntilBreak` | Integer | Số ngày còn lại trước khi mất streak (0 = đã học hôm nay, 1 = cần học hôm nay, -1 = đã mất) |
| `message` | String | Message động dựa trên streak |

**Streak Status Values:**
- `NEW` - User chưa học lần nào
- `ACTIVE` - Đã học hôm nay, streak đang active
- `PENDING` - Học hôm qua, chưa học hôm nay (còn 1 ngày để duy trì)
- `BROKEN` - Bỏ lỡ ít nhất 1 ngày, streak đã reset

**Response 401 - Unauthorized:**
```json
{
  "status": "401",
  "message": "Unauthorized",
  "data": null
}
```

**cURL Example:**
```bash
curl -X GET "http://localhost:8080/api/v1/user/streak" \
  -H "Authorization: Bearer eyJhbGc..." \
  -H "Content-Type: application/json"
```

---

### 2. POST `/api/v1/user/streak/record` - Ghi nhận hoạt động học

**Description:** Cập nhật streak khi user hoàn thành activity học tập. 

> **Note:** API này được tự động gọi từ backend khi user:
> - Hoàn thành Quick Quiz game
> - Hoàn thành Image-Word Matching game
> - Hoàn thành Word-Definition Matching game
> - Ôn tập flashcard (submit review)
>
> Frontend **KHÔNG CẦN** gọi API này manually!

**Method:** `POST`

**Headers:**
```
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

**Request Body:** None

**Response 200 - Success (Streak Increased):**
```json
{
  "status": "200",
  "message": "Hoạt động đã được ghi nhận",
  "data": {
    "currentStreak": 8,
    "longestStreak": 15,
    "isNewRecord": false,
    "streakIncreased": true,
    "message": "Tuyệt vời! Streak của bạn đã tăng lên 8 ngày! 🔥"
  }
}
```

**Response 200 - Success (New Record):**
```json
{
  "status": "200",
  "message": "Hoạt động đã được ghi nhận",
  "data": {
    "currentStreak": 16,
    "longestStreak": 16,
    "isNewRecord": true,
    "streakIncreased": true,
    "message": "🎉 KỶ LỤC MỚI! Streak 16 ngày! Bạn đã phá kỷ lục cũ!"
  }
}
```

**Response 200 - Success (Broken Streak - Starting Over):**
```json
{
  "status": "200",
  "message": "Hoạt động đã được ghi nhận",
  "data": {
    "currentStreak": 1,
    "longestStreak": 15,
    "isNewRecord": false,
    "streakIncreased": false,
    "message": "Chào mừng bạn quay lại! Hãy xây dựng streak mới! 💪"
  }
}
```

**Response 200 - Success (Already Studied Today):**
```json
{
  "status": "200",
  "message": "Hoạt động đã được ghi nhận",
  "data": {
    "currentStreak": 8,
    "longestStreak": 15,
    "isNewRecord": false,
    "streakIncreased": false,
    "message": "Hoạt động đã được ghi nhận! Tiếp tục học tập nhé! 📚"
  }
}
```

**Response Fields:**
| Field | Type | Description |
|-------|------|-------------|
| `currentStreak` | Integer | Streak hiện tại sau khi update |
| `longestStreak` | Integer | Kỷ lục cao nhất (có thể mới được update) |
| `isNewRecord` | Boolean | `true` nếu phá kỷ lục cũ |
| `streakIncreased` | Boolean | `true` nếu streak tăng (học liên tục) |
| `message` | String | Message động theo kết quả |

**Response 401 - Unauthorized:**
```json
{
  "status": "401",
  "message": "Unauthorized",
  "data": null
}
```

**cURL Example:**
```bash
curl -X POST "http://localhost:8080/api/v1/user/streak/record" \
  -H "Authorization: Bearer eyJhbGc..." \
  -H "Content-Type: application/json"
```

---

## 🔄 WORKFLOW

### User Journey - Streak Tracking

```
Day 1 (First Time):
  User finishes Quick Quiz
    ↓
  Backend auto-calls recordActivity()
    ↓
  currentStreak = 1, totalStudyDays = 1
    ↓
  Message: "Chào mừng bạn quay lại! Hãy xây dựng streak mới! 💪"

Day 2 (Continuous):
  User finishes Image-Word Matching
    ↓
  Backend auto-calls recordActivity()
    ↓
  currentStreak = 2, totalStudyDays = 2
    ↓
  Message: "Tuyệt vời! Streak của bạn đã tăng lên 2 ngày! 🔥"

Day 3 (Multiple activities same day):
  User finishes Quick Quiz → streak updated to 3
  User finishes another game → no update (already studied today)
  User reviews flashcard → no update (already studied today)
    ↓
  Message: "Hoạt động đã được ghi nhận! Tiếp tục học tập nhé! 📚"

Day 5 (Missed Day 4):
  User comes back
    ↓
  Backend detects gap
    ↓
  currentStreak = 1 (reset), totalStudyDays = 4
    ↓
  Message: "Chào mừng bạn quay lại! Hãy xây dựng streak mới! 💪"
```

---

## 🎨 MESSAGE VARIATIONS

### Active Streak Messages (GET endpoint)
```
streak = 0:
  "Bắt đầu streak của bạn ngay hôm nay! 🎯"

streak = 1:
  "Bạn đang có streak 1 ngày! Hãy duy trì nhé! 💪"

streak = 2-6:
  "Tuyệt vời! Bạn đang có streak X ngày! 🔥"

streak = 7-29:
  "Xuất sắc! Streak X ngày! Tiếp tục phát huy! 🌟"

streak = 30-99:
  "Phi thường! Streak X ngày! Bạn là champion! 🏆"

streak >= 100:
  "Huyền thoại! Streak X ngày! Không gì cản được bạn! 👑"
```

### Status Messages (GET endpoint)
```
Status = NEW:
  "Bắt đầu streak của bạn bằng cách học hôm nay! 🚀"

Status = ACTIVE:
  (See active streak messages above)

Status = PENDING:
  "Học hôm nay để duy trì streak X ngày! ⏰"

Status = BROKEN:
  "Streak đã bị gián đoạn. Bắt đầu lại hôm nay! 💪"
```

### Record Messages (POST endpoint)
```
New Record (streak > 1):
  "🎉 KỶ LỤC MỚI! Streak X ngày! Bạn đã phá kỷ lục cũ!"

Streak Increased:
  "Tuyệt vời! Streak của bạn đã tăng lên X ngày! 🔥"

First Time / Reset (streak = 1):
  "Chào mừng bạn quay lại! Hãy xây dựng streak mới! 💪"

Already Studied Today:
  "Hoạt động đã được ghi nhận! Tiếp tục học tập nhé! 📚"
```

---

## 💡 FRONTEND INTEGRATION TIPS

### 1. Display Streak in Header/Navbar
```javascript
// Fetch on app load
useEffect(() => {
  const fetchStreak = async () => {
    const response = await api.get('/api/v1/user/streak');
    setStreak(response.data.data);
  };
  fetchStreak();
}, []);

// Display
<StreakBadge 
  streak={streak.currentStreak}
  status={streak.streakStatus}
/>
```

### 2. Show Streak Modal After Game
```javascript
// After game finishes, backend already recorded streak
// Just fetch updated streak to show user
const handleGameFinish = async (gameResult) => {
  // Backend already called recordActivity()
  
  // Fetch updated streak
  const streakResponse = await api.get('/api/v1/user/streak');
  const updatedStreak = streakResponse.data.data;
  
  // Show modal with game result + streak
  showResultModal({
    gameScore: gameResult.score,
    streak: updatedStreak.currentStreak,
    streakMessage: updatedStreak.message,
    isNewRecord: updatedStreak.isNewRecord
  });
};
```

### 3. Profile Page - Streak Stats
```javascript
const StreakStats = ({ streak }) => (
  <div className="streak-stats">
    <StatCard 
      icon="🔥"
      title="Current Streak"
      value={`${streak.currentStreak} days`}
      status={streak.streakStatus}
    />
    <StatCard 
      icon="🏆"
      title="Best Streak"
      value={`${streak.longestStreak} days`}
    />
    <StatCard 
      icon="📚"
      title="Total Study Days"
      value={`${streak.totalStudyDays} days`}
    />
  </div>
);
```

### 4. Daily Reminder
```javascript
// Check if user needs to study today
const shouldShowReminder = () => {
  return streak.streakStatus === 'PENDING' && 
         streak.daysUntilBreak === 1;
};

if (shouldShowReminder()) {
  showNotification({
    title: "Don't break your streak!",
    message: `You have a ${streak.currentStreak} day streak. Study today to keep it going! 🔥`,
    type: "warning"
  });
}
```

---

## 🔒 SECURITY NOTES

1. **Authentication Required:** All endpoints require valid JWT token
2. **User Isolation:** Users can only access their own streak data
3. **Rate Limiting:** Consider implementing rate limiting on POST endpoint
4. **Idempotency:** Multiple calls to recordActivity() on same day = no side effects

---

## 🐛 ERROR HANDLING

### Common Errors:

**401 Unauthorized:**
- Token missing or invalid
- Token expired
- Solution: Refresh token or redirect to login

**500 Internal Server Error:**
- Database connection issue
- Solution: Check logs, retry request

---

## 📊 ANALYTICS IDEAS

Track these metrics:
- Average streak length per user
- % of users with streak > 7 days
- % of users with streak > 30 days
- Streak break rate
- Most common streak break days (weekends?)
- User retention correlation with streak length

---

## 🧪 TESTING

### Postman Collection

Import this collection to test:

```json
{
  "info": {
    "name": "Streak API",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Get Streak",
      "request": {
        "method": "GET",
        "header": [
          {
            "key": "Authorization",
            "value": "Bearer {{jwt_token}}"
          }
        ],
        "url": {
          "raw": "{{base_url}}/api/v1/user/streak",
          "host": ["{{base_url}}"],
          "path": ["api", "v1", "user", "streak"]
        }
      }
    },
    {
      "name": "Record Activity",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Authorization",
            "value": "Bearer {{jwt_token}}"
          }
        ],
        "url": {
          "raw": "{{base_url}}/api/v1/user/streak/record",
          "host": ["{{base_url}}"],
          "path": ["api", "v1", "user", "streak", "record"]
        }
      }
    }
  ]
}
```

---

## 📞 SUPPORT

For issues or questions:
- Check logs for error details
- Verify JWT token is valid
- Ensure database migrations ran successfully
- Contact backend team if issues persist

---

**Last Updated:** October 31, 2025  
**API Version:** v1  
**Status:** ✅ Production Ready

