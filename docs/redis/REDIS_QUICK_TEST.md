# ⚡ Quick Start: Test Redis trong 2 phút

## 🎯 Tại sao Redis Insight trống?

**Vì bạn chưa gọi API để tạo dữ liệu!**

Redis chỉ có dữ liệu khi:
1. ✅ Application đang chạy
2. ✅ Có user gọi game APIs
3. ✅ Dữ liệu chưa hết TTL (30 phút)

---

## 🚀 3 Bước Test Nhanh

### 1. Check Redis
```bash
redis-cli ping
# Phải trả về: PONG
```

### 2. Cấu hình Redis Insight
- Host: `localhost`
- Port: `6379`
- Database: `0` ← **Quan trọng!**

### 3. Gọi API (chọn 1 cách)

#### Cách 1: Postman (Dễ nhất)
1. Import: `postman_redis_test_collection.json`
2. Set `jwt_token` variable
3. Chạy: `Start Quick Quiz`
4. Mở Redis Insight → Refresh → ✅ Thấy keys!

#### Cách 2: cURL
```bash
curl -X POST http://localhost:8080/api/quick-quiz/start \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"timePerQuestion": 30, "numQuestions": 10}'
```

#### Cách 3: Python
```bash
# Edit JWT_TOKEN trong file
python test_redis_integration.py
```

---

## 🔑 Keys bạn sẽ thấy

Sau khi start Quick Quiz, trong Redis Insight search: `card-words:*`

```
card-words:game:quiz:session:123:questions        (TTL: 30m)
card-words:game:quiz:session:123:time-limit       (TTL: 30m)
card-words:game:quiz:session:123:question:1:...   (TTL: 30m)
card-words:rate-limit:quickquiz:{userId}          (TTL: 5m)
```

Click vào bất kỳ key nào để xem JSON data!

---

## 🐛 Vẫn không thấy?

### Checklist:
- [ ] `redis-cli ping` → PONG ✅
- [ ] Redis Insight connect DB `0` ✅
- [ ] Spring Boot đang chạy ✅
- [ ] Đã gọi API start game ✅
- [ ] Refresh Redis Insight ✅

### Debug:
```bash
# Xem trực tiếp trong Redis CLI
redis-cli
127.0.0.1:6379> SELECT 0
127.0.0.1:6379> KEYS card-words:*
127.0.0.1:6379> DBSIZE
```

### Nếu KEYS trả về empty:
1. **Chưa gọi API** → Gọi lại API start game
2. **TTL hết hạn** → Keys tự xóa sau 30 phút
3. **Application error** → Check logs Spring Boot

---

## 📚 Chi tiết hơn?

- **Full guide**: `REDIS_TESTING_GUIDE.md`
- **Test script**: `test_redis_integration.py`
- **Postman**: `postman_redis_test_collection.json`
- **Shell check**: `check-redis-keys.sh` / `.bat`

---

## 💡 1 Câu lệnh để test ALL

```bash
# Check Redis → Check Keys → Monitor
redis-cli ping && \
redis-cli KEYS "card-words:*" && \
redis-cli DBSIZE
```

**Kết quả mong đợi sau khi gọi API:**
```
PONG
1) "card-words:game:quiz:session:123:questions"
2) "card-words:game:quiz:session:123:time-limit"
3) "card-words:rate-limit:quickquiz:abc-uuid"
(integer) 4
```

---

## 🎯 TL;DR

1. Redis Insight trống vì **chưa có data**
2. Data xuất hiện khi **gọi game APIs**
3. Gọi API → Refresh Redis Insight → ✅ Thấy keys!

**That's it!** 🎉
