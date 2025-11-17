# API Lấy Từ Vựng Học Trong Ngày

## Tổng quan

API này cho phép lấy danh sách các từ vựng mà user đã học trong ngày hôm nay (dựa trên cột `created_at` trong bảng `user_vocab_progress`).

---

## Endpoint

```
GET /api/v1/user-vocab-progress/learned-today
```

### Authentication
- **Required**: YES
- **Type**: Bearer Token (JWT)

### Headers
```
Authorization: Bearer <your_jwt_token>
Content-Type: application/json
```

---

## Request

### Query Parameters
Không có query parameters (API tự động lấy userId từ JWT token và ngày hôm nay từ hệ thống)

---

## Response

### Success Response (200 OK)

```json
{
  "success": true,
  "message": "Lấy danh sách từ đã học trong ngày thành công. Tổng: 5 từ",
  "data": [
    {
      "id": "uuid-string",
      "userId": "uuid-string",
      "vocabId": "uuid-string",
      "vocab": {
        "id": "uuid-string",
        "word": "hello",
        "translation": "xin chào",
        "pronunciation": "həˈloʊ",
        "example": "Hello, how are you?",
        "imageUrl": "https://example.com/image.jpg",
        "difficulty": 1,
        "topics": [
          {
            "id": "uuid-string",
            "name": "Greetings",
            "description": "Common greetings"
          }
        ]
      },
      "status": "KNOWN",
      "lastReviewed": "2025-11-02",
      "nextReviewDate": "2025-11-09",
      "timesCorrect": 3,
      "timesWrong": 1,
      "createdAt": "2025-11-02T08:30:00",
      "updatedAt": "2025-11-02T15:45:00"
    },
    {
      "id": "uuid-string",
      "userId": "uuid-string",
      "vocabId": "uuid-string",
      "vocab": {
        "id": "uuid-string",
        "word": "world",
        "translation": "thế giới",
        "pronunciation": "wɜːrld",
        "example": "Welcome to the world",
        "imageUrl": "https://example.com/world.jpg",
        "difficulty": 2,
        "topics": [
          {
            "id": "uuid-string",
            "name": "Basic",
            "description": "Basic vocabulary"
          }
        ]
      },
      "status": "NEW",
      "lastReviewed": "2025-11-02",
      "nextReviewDate": "2025-11-03",
      "timesCorrect": 0,
      "timesWrong": 0,
      "createdAt": "2025-11-02T14:20:00",
      "updatedAt": "2025-11-02T14:20:00"
    }
  ]
}
```

### Error Responses

#### 401 Unauthorized
```json
{
  "success": false,
  "message": "Unauthorized - Invalid or missing token",
  "data": null
}
```

#### 500 Internal Server Error
```json
{
  "success": false,
  "message": "Unable to get user ID from authentication",
  "data": null
}
```

---

## Cách hoạt động

### 1. Flow xử lý
```
Client Request (với JWT token)
    ↓
Authentication Filter (validate token)
    ↓
UserVocabProgressController.getVocabsLearnedToday()
    ↓
getUserIdFromAuth() - Extract userId từ JWT
    ↓
UserVocabProgressService.getVocabsLearnedToday(userId)
    ↓
UserVocabProgressRepository.findLearnedVocabsByDate(userId, LocalDate.now())
    ↓
Database Query: SELECT từ user_vocab_progress WHERE userId = ? AND DATE(created_at) = TODAY
    ↓
Map Entity → Response DTO
    ↓
Return JSON Response
```

### 2. Database Query

Query SQL thực tế được thực thi:

```sql
SELECT 
    uvp.*,
    v.*
FROM user_vocab_progress uvp
LEFT JOIN vocabulary v ON uvp.vocab_id = v.id
WHERE uvp.user_id = ?
  AND CAST(uvp.created_at AS date) = CURRENT_DATE
ORDER BY uvp.created_at DESC
```

### 3. Logic xác định "học trong ngày"

- Từ vựng được coi là "học trong ngày" khi **cột `created_at`** của record trong bảng `user_vocab_progress` có **ngày** trùng với **ngày hôm nay**.
- `created_at` được set khi:
  - User lần đầu học một từ mới (tạo record mới trong `user_vocab_progress`)
  - Trong các game: Quick Quiz, Word-Image Matching, Word-Definition Matching
  - Trong chức năng Learn Vocab

### 4. Các trường hợp sử dụng

#### Case 1: User mới bắt đầu học hôm nay
```json
// Response: Danh sách tất cả từ đã học (status có thể là NEW, KNOWN, UNKNOWN)
{
  "success": true,
  "message": "Lấy danh sách từ đã học trong ngày thành công. Tổng: 15 từ",
  "data": [...]
}
```

#### Case 2: User chưa học từ nào hôm nay
```json
// Response: Danh sách rỗng
{
  "success": true,
  "message": "Lấy danh sách từ đã học trong ngày thành công. Tổng: 0 từ",
  "data": []
}
```

#### Case 3: User đã học từ này trước đó, nhưng ôn tập lại hôm nay
```
// Record trong user_vocab_progress:
// created_at: 2025-10-20 (ngày học lần đầu)
// updated_at: 2025-11-02 (ngày ôn tập hôm nay)

// API này sẽ KHÔNG trả về từ này vì created_at không phải hôm nay
// (Chỉ lấy từ LẦN ĐẦU HỌC trong ngày)
```

---

## So sánh với các API khác

### 1. `/api/v1/user-vocab-progress` - Tất cả từ đã học
- Lấy **tất cả** từ vựng user đã học (không phân biệt ngày)
- Sắp xếp theo `lastReviewed` DESC

### 2. `/api/v1/user-vocab-progress/learned-today` - Từ học hôm nay ⭐ (API MỚI)
- Lấy **chỉ những từ** được tạo record (lần đầu học) trong ngày hôm nay
- Sắp xếp theo `createdAt` DESC
- Dựa vào cột `created_at`

### 3. `/api/v1/user-vocab-progress/due-for-review` - Từ cần ôn tập
- Lấy từ có `nextReviewDate <= today`
- Phục vụ cho Spaced Repetition

### 4. `/api/v1/user-vocab-progress/correct` - Từ đã đúng
- Lấy từ có `timesCorrect > 0`

### 5. `/api/v1/user-vocab-progress/wrong` - Từ đã sai
- Lấy từ có `timesWrong > 0`

---

## Ví dụ sử dụng

### cURL

```bash
curl -X GET "http://localhost:8080/api/v1/user-vocab-progress/learned-today" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json"
```

### JavaScript (Fetch API)

```javascript
async function getLearnedTodayVocabs() {
  const token = localStorage.getItem('jwt_token');
  
  try {
    const response = await fetch(
      'http://localhost:8080/api/v1/user-vocab-progress/learned-today',
      {
        method: 'GET',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      }
    );
    
    const result = await response.json();
    
    if (result.success) {
      console.log(`Hôm nay đã học: ${result.data.length} từ`);
      console.log(result.data);
      return result.data;
    } else {
      console.error('Error:', result.message);
      return [];
    }
  } catch (error) {
    console.error('Network error:', error);
    return [];
  }
}

// Sử dụng
getLearnedTodayVocabs().then(vocabs => {
  vocabs.forEach(vocab => {
    console.log(`- ${vocab.vocab.word}: ${vocab.vocab.translation} (${vocab.status})`);
  });
});
```

### Axios

```javascript
import axios from 'axios';

const getLearnedTodayVocabs = async () => {
  try {
    const response = await axios.get(
      'http://localhost:8080/api/v1/user-vocab-progress/learned-today',
      {
        headers: {
          'Authorization': `Bearer ${localStorage.getItem('jwt_token')}`
        }
      }
    );
    
    return response.data.data;
  } catch (error) {
    console.error('Error:', error.response?.data?.message || error.message);
    return [];
  }
};
```

### React Component Example

```jsx
import React, { useEffect, useState } from 'react';
import axios from 'axios';

function LearnedTodayComponent() {
  const [vocabs, setVocabs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchLearnedToday = async () => {
      try {
        const token = localStorage.getItem('jwt_token');
        const response = await axios.get(
          'http://localhost:8080/api/v1/user-vocab-progress/learned-today',
          {
            headers: { 'Authorization': `Bearer ${token}` }
          }
        );
        
        setVocabs(response.data.data);
        setLoading(false);
      } catch (err) {
        setError(err.response?.data?.message || 'Có lỗi xảy ra');
        setLoading(false);
      }
    };

    fetchLearnedToday();
  }, []);

  if (loading) return <div>Đang tải...</div>;
  if (error) return <div>Lỗi: {error}</div>;

  return (
    <div className="learned-today-container">
      <h2>Từ vựng đã học hôm nay ({vocabs.length} từ)</h2>
      
      {vocabs.length === 0 ? (
        <p>Bạn chưa học từ nào hôm nay. Hãy bắt đầu học nhé! 📚</p>
      ) : (
        <div className="vocab-list">
          {vocabs.map(item => (
            <div key={item.id} className="vocab-card">
              <div className="vocab-header">
                <h3>{item.vocab.word}</h3>
                <span className={`status-badge ${item.status.toLowerCase()}`}>
                  {item.status}
                </span>
              </div>
              
              <p className="translation">{item.vocab.translation}</p>
              <p className="pronunciation">/{item.vocab.pronunciation}/</p>
              
              {item.vocab.imageUrl && (
                <img src={item.vocab.imageUrl} alt={item.vocab.word} />
              )}
              
              <div className="stats">
                <span className="correct">✅ {item.timesCorrect}</span>
                <span className="wrong">❌ {item.timesWrong}</span>
              </div>
              
              <div className="times">
                <small>Học lúc: {new Date(item.createdAt).toLocaleTimeString('vi-VN')}</small>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

export default LearnedTodayComponent;
```

---

## Use Cases thực tế

### 1. Dashboard - Thống kê học tập hàng ngày
```javascript
// Hiển thị số từ đã học trong ngày
const showDailyStats = async () => {
  const vocabs = await getLearnedTodayVocabs();
  
  document.getElementById('daily-count').textContent = vocabs.length;
  
  // Tính tỷ lệ đúng/sai
  const totalCorrect = vocabs.reduce((sum, v) => sum + v.timesCorrect, 0);
  const totalWrong = vocabs.reduce((sum, v) => sum + v.timesWrong, 0);
  const accuracy = totalCorrect / (totalCorrect + totalWrong) * 100;
  
  document.getElementById('daily-accuracy').textContent = `${accuracy.toFixed(1)}%`;
};
```

### 2. Reward System - Thưởng khi học đủ số từ
```javascript
const checkDailyGoal = async () => {
  const vocabs = await getLearnedTodayVocabs();
  const dailyGoal = 20; // Mục tiêu học 20 từ/ngày
  
  if (vocabs.length >= dailyGoal) {
    showCongratulations('🎉 Chúc mừng! Bạn đã hoàn thành mục tiêu hôm nay!');
    awardPoints(100); // Thưởng 100 điểm
  } else {
    showProgress(`Còn ${dailyGoal - vocabs.length} từ nữa để đạt mục tiêu!`);
  }
};
```

### 3. Review End of Day - Ôn tập cuối ngày
```javascript
// Hiển thị tất cả từ đã học trong ngày để ôn tập lại
const showEndOfDayReview = async () => {
  const vocabs = await getLearnedTodayVocabs();
  
  if (vocabs.length > 0) {
    showReviewModal({
      title: 'Ôn tập cuối ngày',
      message: `Hôm nay bạn đã học ${vocabs.length} từ mới. Hãy xem lại nhé!`,
      vocabs: vocabs
    });
  }
};

// Gọi vào cuối ngày (ví dụ: 9 PM)
scheduleTask('21:00', showEndOfDayReview);
```

### 4. Progress Tracking - Theo dõi tiến trình
```javascript
const trackWeeklyProgress = async () => {
  // Gọi API này mỗi ngày và lưu kết quả
  const vocabs = await getLearnedTodayVocabs();
  
  const progressData = {
    date: new Date().toISOString().split('T')[0],
    count: vocabs.length,
    status: {
      new: vocabs.filter(v => v.status === 'NEW').length,
      known: vocabs.filter(v => v.status === 'KNOWN').length,
      mastered: vocabs.filter(v => v.status === 'MASTERED').length
    }
  };
  
  saveToLocalStorage('weekly_progress', progressData);
  updateProgressChart();
};
```

### 5. Gamification - Streak và Achievements
```javascript
const updateStreak = async () => {
  const vocabs = await getLearnedTodayVocabs();
  
  if (vocabs.length > 0) {
    // User đã học ít nhất 1 từ hôm nay
    incrementStreak();
    checkAchievements([
      { name: '7 Day Streak', requirement: streak >= 7 },
      { name: '30 Day Streak', requirement: streak >= 30 },
      { name: 'Daily Warrior', requirement: vocabs.length >= 50 }
    ]);
  } else {
    // Cảnh báo user chưa học
    showReminder('⏰ Bạn chưa học từ nào hôm nay!');
  }
};
```

---

## Lưu ý quan trọng

### 1. Timezone
- API sử dụng **server timezone** để xác định "hôm nay"
- Đảm bảo server timezone được cấu hình đúng (ví dụ: Asia/Ho_Chi_Minh)
- Config trong `application.yml`:
```yaml
spring:
  jackson:
    time-zone: Asia/Ho_Chi_Minh
```

### 2. Performance
- Query này có **index** trên cột `user_id` và `created_at` nên rất nhanh
- Với user có nhiều từ vựng, nên cache kết quả trong 1-2 phút
- Sử dụng pagination nếu cần thiết (hiện tại trả về tất cả)

### 3. Data Consistency
- `created_at` **không bao giờ thay đổi** sau khi được tạo
- Chỉ `updated_at` thay đổi khi user ôn tập lại
- Nếu muốn lấy từ "ôn tập hôm nay", cần tạo API khác dựa vào `updated_at`

### 4. Status Values
Các giá trị có thể của `status`:
- `NEW`: Từ mới, chưa học
- `KNOWN`: Đã biết, trả lời đúng
- `UNKNOWN`: Chưa biết, trả lời sai
- `MASTERED`: Đã thành thạo (tự động khi đạt điều kiện)

---

## Testing

### Test Case 1: User đã học từ hôm nay
```bash
# Giả sử user đã chơi game và học 5 từ mới
GET /api/v1/user-vocab-progress/learned-today
Expected: Array với 5 phần tử, tất cả có created_at là hôm nay
```

### Test Case 2: User chưa học gì hôm nay
```bash
GET /api/v1/user-vocab-progress/learned-today
Expected: Array rỗng []
```

### Test Case 3: User học từ vào các thời điểm khác nhau trong ngày
```bash
# User học lúc 8h sáng: 3 từ
# User học lúc 2h chiều: 5 từ
# User học lúc 8h tối: 2 từ
GET /api/v1/user-vocab-progress/learned-today
Expected: Array với 10 phần tử, sắp xếp từ mới nhất (8h tối) đến cũ nhất (8h sáng)
```

### Test Case 4: Unauthorized request
```bash
# Request không có token
GET /api/v1/user-vocab-progress/learned-today
Expected: 401 Unauthorized
```

---

## Database Schema Reference

### Bảng `user_vocab_progress`

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| user_id | UUID | Foreign key → users.id |
| vocab_id | UUID | Foreign key → vocabulary.id |
| status | VARCHAR(50) | NEW, KNOWN, UNKNOWN, MASTERED |
| last_reviewed | DATE | Ngày ôn tập gần nhất |
| next_review_date | DATE | Ngày ôn tập tiếp theo (spaced repetition) |
| times_correct | INTEGER | Số lần trả lời đúng |
| times_wrong | INTEGER | Số lần trả lời sai |
| **created_at** | TIMESTAMP | **Ngày giờ tạo record (lần đầu học)** ⭐ |
| updated_at | TIMESTAMP | Ngày giờ cập nhật gần nhất |

### Index
```sql
CREATE INDEX idx_uvp_user_created_at ON user_vocab_progress(user_id, created_at);
```

---

## Roadmap & Future Improvements

### Version 1.1 (Current)
- ✅ Lấy từ học trong ngày dựa trên `created_at`
- ✅ Sắp xếp theo thời gian tạo mới nhất

### Version 1.2 (Planned)
- [ ] Thêm query parameter `date` để lấy từ học của ngày cụ thể
- [ ] Thêm pagination (page, size)
- [ ] Thêm filter theo status (NEW, KNOWN, etc.)
- [ ] Thêm filter theo topic

### Version 2.0 (Future)
- [ ] API lấy từ "ôn tập hôm nay" (dựa trên `updated_at`)
- [ ] API thống kê theo tuần/tháng
- [ ] Export dữ liệu ra CSV/Excel
- [ ] Analytics chi tiết hơn

---

## Troubleshooting

### Lỗi: "Unable to get user ID from authentication"
**Nguyên nhân**: Token không hợp lệ hoặc đã hết hạn
**Giải pháp**: Refresh token hoặc đăng nhập lại

### Lỗi: API trả về từ không phải hôm nay
**Nguyên nhân**: Server timezone không đúng
**Giải pháp**: Kiểm tra timezone config trong application.yml

### Lỗi: Performance chậm với user có nhiều từ
**Nguyên nhân**: Chưa có index hoặc JOIN quá nhiều bảng
**Giải pháp**: 
1. Tạo index: `CREATE INDEX idx_uvp_user_created_at ON user_vocab_progress(user_id, created_at);`
2. Implement caching với Redis
3. Thêm pagination

---

## Support

Nếu có vấn đề hoặc câu hỏi, vui lòng liên hệ:
- Email: support@cardwords.com
- GitHub Issues: https://github.com/your-repo/issues
- Documentation: https://docs.cardwords.com

---

**Version**: 1.0  
**Last Updated**: 2025-11-02  
**Author**: Development Team

