# 🧪 Redis Integration Testing Guide

## 📌 Tại sao Redis Insight không có dữ liệu?

**Redis Insight trống vì:**
1. ⚠️ **Application chưa gọi API** → Redis chưa có keys
2. ⏰ **TTL đã hết hạn** → Keys tự động xóa (30 phút cho game sessions)
3. 🔢 **Database khác** → Redis Insight đang xem DB 1/2/... thay vì DB 0
4. 🔌 **Kết nối sai port** → Đang kết nối 6380 thay vì 6379

## ✅ Giải pháp: 3 Bước đơn giản

### Bước 1: Kiểm tra Redis đang chạy

```bash
# Bash/PowerShell
redis-cli ping
# Kết quả mong đợi: PONG

# Hoặc chạy script
./check-redis-keys.sh      # Linux/Mac
check-redis-keys.bat        # Windows
```

### Bước 2: Cấu hình Redis Insight

1. Mở Redis Insight
2. **Add Database**:
   - Host: `localhost`
   - Port: `6379`
   - Database Index: `0` ← **Quan trọng!**
   - Password: để trống

### Bước 3: Gọi API để tạo dữ liệu

#### Option A: Dùng Postman (Khuyến nghị)

1. Import file: `postman_redis_test_collection.json`
2. Set biến `jwt_token` (sau khi login)
3. Chạy request: `Start Quick Quiz`
4. → Mở Redis Insight → Refresh → Thấy keys!

#### Option B: Dùng cURL

```bash
# 1. Start Quick Quiz
curl -X POST http://localhost:8080/api/quick-quiz/start \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "timePerQuestion": 30,
    "numQuestions": 10
  }'

# 2. Start Image Word Matching
curl -X POST http://localhost:8080/api/image-word-matching/start \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{"numPairs": 6}'

# 3. Start Word Definition Matching
curl -X POST http://localhost:8080/api/word-def-matching/start \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{"numPairs": 8}'
```

#### Option C: Dùng Python Script

```bash
# 1. Thêm JWT_TOKEN vào file test_redis_integration.py
# 2. Chạy script
python test_redis_integration.py
```

---

## 🔑 Redis Keys bạn sẽ thấy

Sau khi gọi API, trong Redis Insight sẽ xuất hiện:

### Game Sessions (TTL: 30 phút)

```
📁 card-words:game:quiz:session:123:questions
   Type: String
   Value: [{"id":1,"word":"hello",...}, {...}]
   TTL: 1795s (29m 55s)

📁 card-words:game:quiz:session:123:time-limit
   Type: String
   Value: 30000
   TTL: 1795s

📁 card-words:game:quiz:session:123:question:1:start-time
   Type: String
   Value: 2024-01-15T10:30:00
   TTL: 1795s

📁 card-words:game:image-matching:session:456
   Type: String
   Value: {"vocabIds":[1,2,3],"startTime":"..."}
   TTL: 1795s

📁 card-words:game:word-def:session:789
   Type: String
   Value: {"wordIds":[4,5,6],"startTime":"..."}
   TTL: 1795s
```

### Rate Limiting (TTL: 5 phút)

```
📁 card-words:rate-limit:quickquiz:a1b2c3d4-uuid
   Type: String
   Value: 1
   TTL: 295s (4m 55s)
```

---

## 🛠️ Tools & Scripts

| File | Mô tả | Sử dụng |
|------|-------|---------|
| `test-redis.md` | Hướng dẫn chi tiết | Đọc để hiểu flow |
| `test_redis_integration.py` | Python test script | `python test_redis_integration.py` |
| `postman_redis_test_collection.json` | Postman collection | Import vào Postman |
| `check-redis-keys.sh` | Shell script | `./check-redis-keys.sh` |
| `check-redis-keys.bat` | Windows batch | `check-redis-keys.bat` |

---

## 🎯 Quick Test Checklist

- [ ] Redis server running (`redis-cli ping` → PONG)
- [ ] Redis Insight connected to `localhost:6379` DB `0`
- [ ] Spring Boot app running (`mvn spring-boot:run`)
- [ ] Có JWT token (sau khi login)
- [ ] Gọi API start game
- [ ] Refresh Redis Insight → Thấy keys
- [ ] Click vào key để xem JSON data
- [ ] Kiểm tra TTL countdown

---

## 🐛 Troubleshooting

### Redis Insight vẫn trống?

**1. Kiểm tra Database Index**
```bash
redis-cli
127.0.0.1:6379> SELECT 0  # Chuyển sang DB 0
127.0.0.1:6379> KEYS card-words:*  # List keys
```

**2. Kiểm tra Spring Boot logs**
```bash
# Tìm dòng này trong logs:
✅ Primary RedisTemplate initialized
Cached quiz questions for session 123
```

**3. Test Redis trực tiếp**
```bash
redis-cli SET test:key "hello"
redis-cli GET test:key
# Nếu không work → Redis có vấn đề
```

**4. Kiểm tra .env file**
```bash
cat .env | grep REDIS
# Phải là:
# REDIS_HOST=localhost
# REDIS_PORT=6379
# REDIS_DB=0
# REDIS_PASSWORD=
```

**5. Xem logs Spring Boot chi tiết**
```bash
# application.yml
logging:
  level:
    org.springframework.data.redis: DEBUG
```

---

## 📊 Redis Commands hữu ích

```bash
# List tất cả keys
redis-cli KEYS "card-words:*"

# Đếm số keys
redis-cli DBSIZE

# Xem value
redis-cli GET "card-words:game:quiz:session:123:questions"

# Xem TTL còn lại
redis-cli TTL "card-words:game:quiz:session:123:questions"

# Xem type
redis-cli TYPE "card-words:game:quiz:session:123:questions"

# Monitor real-time (debug)
redis-cli MONITOR

# Xóa 1 key
redis-cli DEL "card-words:game:quiz:session:123:questions"

# Xóa tất cả keys pattern
redis-cli --scan --pattern "card-words:game:*" | xargs redis-cli DEL

# Flush DB (⚠️ cẩn thận!)
redis-cli FLUSHDB
```

---

## 🎓 Expected Flow

1. **User calls**: `POST /api/quick-quiz/start`
2. **Backend**: 
   - Tạo session ID = 123
   - `gameSessionCacheService.cacheQuizQuestions(123, questions)`
   - `gameSessionCacheService.cacheSessionTimeLimit(123, 30000)`
   - `rateLimitingService.checkGameRateLimit(userId, "quickquiz", 5, 5min)`
3. **Redis**: Tạo 4 keys với TTL
4. **Response**: JSON với sessionId, questions
5. **Redis Insight**: Refresh → Thấy keys!

---

## 📝 Kết quả mong đợi

Sau khi chạy 1 Quick Quiz game:

```
🔍 redis-cli KEYS "card-words:*"
1) "card-words:game:quiz:session:123:questions"
2) "card-words:game:quiz:session:123:time-limit"
3) "card-words:game:quiz:session:123:question:1:start-time"
4) "card-words:rate-limit:quickquiz:a1b2c3d4-uuid"

📊 redis-cli DBSIZE
(integer) 4

⏰ redis-cli TTL "card-words:game:quiz:session:123:questions"
(integer) 1795  # 29m 55s
```

---

## 🚀 Next Steps

Sau khi test thành công Redis:

1. ✅ **Test game flow**: Start → Answer → Complete
2. ✅ **Test rate limiting**: Gọi API 6 lần liên tiếp (5 OK, 6th = 429)
3. ✅ **Test TTL**: Đợi 30 phút → Keys tự xóa
4. 🔜 **Phase 3**: JWT blacklist
5. 🔜 **Phase 4**: Leaderboards với Redis Sorted Sets

---

## 💡 Tips

- 🔄 **Refresh Redis Insight thường xuyên** để thấy keys mới
- ⏰ **Chú ý TTL countdown** - keys sẽ biến mất khi hết thời gian
- 🔍 **Dùng Search** trong Redis Insight: `card-words:*`
- 📊 **Click vào key** để xem JSON data chi tiết
- 🎯 **Test nhiều lần** để thấy rate limiting hoạt động

---

## 🎉 Happy Testing!

Nếu còn vấn đề, check:
1. Redis server running?
2. Spring Boot running?
3. Đã gọi API chưa?
4. Database index đúng chưa?
5. Logs có error không?

**Mục tiêu**: Thấy ít nhất 4 keys trong Redis Insight sau khi start 1 game! 🎯
