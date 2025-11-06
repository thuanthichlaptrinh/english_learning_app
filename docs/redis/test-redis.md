# 🧪 Hướng dẫn Test Redis Integration

## 📌 Cấu hình Redis Insight

1. **Mở Redis Insight**
2. **Add Database** với thông tin:
   - Host: `localhost`
   - Port: `6379`
   - Database Index: `0`
   - Password: (để trống)

## 🚀 Test Game APIs để tạo dữ liệu Redis

### 1️⃣ Quick Quiz Game

**Bước 1: Bắt đầu game**
```bash
curl -X POST http://localhost:8080/api/quick-quiz/start \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "timePerQuestion": 30,
    "numQuestions": 10
  }'
```

**Response:**
```json
{
  "sessionId": 123,
  "questions": [...],
  "timePerQuestion": 30
}
```

**Bước 2: Kiểm tra Redis Insight**
- Mở Redis Insight → Browser
- Tìm keys: `card-words:game:*`
- Bạn sẽ thấy:
  - `card-words:game:quiz:session:123:questions` (TTL: 30 phút)
  - `card-words:game:quiz:session:123:time-limit` (TTL: 30 phút)
  - `card-words:game:quiz:session:123:question:1:start-time` (TTL: 30 phút)
  - `card-words:rate-limit:quickquiz:USER_ID` (TTL: 5 phút)

**Bước 3: Trả lời câu hỏi**
```bash
curl -X POST http://localhost:8080/api/quick-quiz/123/answer \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "questionIndex": 1,
    "selectedAnswer": "correct answer"
  }'
```

---

### 2️⃣ Image Word Matching Game

**Bước 1: Bắt đầu game**
```bash
curl -X POST http://localhost:8080/api/image-word-matching/start \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "numPairs": 6
  }'
```

**Bước 2: Kiểm tra Redis**
- Key: `card-words:game:image-matching:session:SESSION_ID`
- Value: JSON object chứa `vocabIds`, `startTime`, `timeLimit`
- TTL: 30 phút

**Bước 3: Submit answer**
```bash
curl -X POST http://localhost:8080/api/image-word-matching/{sessionId}/submit \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "matches": [
      {"vocabId": 1, "imageIndex": 0},
      {"vocabId": 2, "imageIndex": 1}
    ]
  }'
```

---

### 3️⃣ Word Definition Matching Game

**Bước 1: Bắt đầu game**
```bash
curl -X POST http://localhost:8080/api/word-def-matching/start \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "numPairs": 8
  }'
```

**Bước 2: Kiểm tra Redis**
- Key: `card-words:game:word-def:session:SESSION_ID`
- Value: SessionData object
- TTL: 30 phút

---

## 🔍 Redis Keys Pattern

Sau khi test API, bạn sẽ thấy các keys này trong Redis Insight:

### Game Sessions:
```
card-words:game:quiz:session:123:questions
card-words:game:quiz:session:123:time-limit
card-words:game:quiz:session:123:question:1:start-time
card-words:game:image-matching:session:456
card-words:game:word-def:session:789
```

### Rate Limiting:
```
card-words:rate-limit:quickquiz:{userId}
card-words:rate-limit:image-matching:{userId}
card-words:rate-limit:word-def:{userId}
```

### Leaderboards (Phase 3):
```
card-words:leaderboard:quickquiz:daily
card-words:leaderboard:quickquiz:weekly
card-words:leaderboard:quickquiz:monthly
```

---

## 🛠️ Commands hữu ích trong Redis CLI

```bash
# Xem tất cả keys
redis-cli KEYS "card-words:*"

# Xem value của 1 key
redis-cli GET "card-words:game:quiz:session:123:questions"

# Xem TTL còn lại
redis-cli TTL "card-words:game:quiz:session:123:questions"

# Xóa tất cả keys (cẩn thận!)
redis-cli FLUSHDB

# Đếm số keys
redis-cli DBSIZE
```

---

## ✅ Checklist Test Redis

- [ ] Redis server đã chạy (`redis-cli ping` → PONG)
- [ ] Redis Insight đã kết nối Database 0
- [ ] Application Spring Boot đã start thành công
- [ ] Đã login và có JWT token
- [ ] Gọi API start game → Thấy keys xuất hiện trong Redis Insight
- [ ] Gọi API answer/submit → Keys tự động xóa hoặc cập nhật
- [ ] Kiểm tra TTL của keys (30 phút cho sessions, 5 phút cho rate limit)

---

## 🎯 Kết quả mong đợi

Sau khi bắt đầu 1 game Quick Quiz:
1. Redis Insight sẽ hiển thị ít nhất 4 keys mới
2. Mỗi key có TTL countdown (1800 seconds = 30 phút)
3. Click vào key để xem JSON data
4. Data bao gồm: questions list, time limits, timestamps

---

## 🐛 Troubleshooting

### Redis Insight vẫn trống?

1. **Kiểm tra database index**
   - Redis Insight phải chọn Database `0`
   - Không phải Database `1`, `2`, ...

2. **Kiểm tra connection**
   ```bash
   redis-cli -h localhost -p 6379 ping
   ```

3. **Kiểm tra Spring Boot logs**
   - Tìm dòng: `✅ Primary RedisTemplate initialized`
   - Tìm dòng: `Cached quiz questions for session`

4. **Test Redis trực tiếp**
   ```bash
   redis-cli SET test:key "hello"
   redis-cli GET test:key
   redis-cli DEL test:key
   ```

5. **Kiểm tra .env file**
   - `REDIS_HOST=localhost`
   - `REDIS_PORT=6379`
   - `REDIS_DB=0`
   - `REDIS_PASSWORD=` (trống)

---

## 📸 Screenshot mẫu Redis Insight

Sau khi start 1 Quick Quiz game, bạn sẽ thấy:

```
📁 card-words:game:quiz:session:123:questions (TTL: 1795s)
   Type: String
   Value: [{"id":1,"word":"hello",...}, {...}]

📁 card-words:game:quiz:session:123:time-limit (TTL: 1795s)
   Type: String
   Value: 30000

📁 card-words:rate-limit:quickquiz:a1b2c3d4-... (TTL: 295s)
   Type: String
   Value: 1
```

Nhấp vào từng key để xem chi tiết JSON data!

---

## 🎓 Next Steps

Sau khi test thành công Redis với game APIs:
1. **Phase 3**: Implement JWT blacklist
2. **Phase 4**: Add Leaderboards
3. **Performance**: Monitor cache hit rates
4. **Production**: Add Redis Sentinel/Cluster

Happy testing! 🚀
