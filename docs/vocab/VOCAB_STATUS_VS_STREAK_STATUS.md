# 📚 VocabStatus vs StreakStatus - Giải thích chi tiết

## 🔍 Sự khác biệt

### 1️⃣ VocabStatus (Trạng thái từ vựng)
**Áp dụng cho:** MỖI TỪ VỰNG trong bảng `user_vocab_progress`

**4 Trạng thái:**

#### 🆕 NEW
- **Định nghĩa:** Từ chưa có trong bảng `user_vocab_progress`
- **Khi nào:** User chưa bao giờ học từ này
- **Trong code:** Không có record trong database
```java
// Check if vocab is NEW
Optional<UserVocabProgress> progress = 
    userVocabProgressRepository.findByUserIdAndVocabId(userId, vocabId);
if (progress.isEmpty()) {
    // Status = NEW
}
```

#### ✅ KNOWN
- **Định nghĩa:** User biết từ này
- **Khi nào:** User nhấn "Đã thuộc" (submit với `isCorrect = true`)
- **Trong code:** `status = VocabStatus.KNOWN`
```java
// When user clicks "Đã thuộc"
if (Boolean.TRUE.equals(request.getIsCorrect())) {
    progress.setTimesCorrect(progress.getTimesCorrect() + 1);
    progress.setStatus(VocabStatus.KNOWN);
}
```

#### ❌ UNKNOWN
- **Định nghĩa:** User chưa biết từ này
- **Khi nào:** User nhấn "Chưa thuộc" (submit với `isCorrect = false`)
- **Trong code:** `status = VocabStatus.UNKNOWN`
```java
// When user clicks "Chưa thuộc"
if (Boolean.FALSE.equals(request.getIsCorrect())) {
    progress.setTimesWrong(progress.getTimesWrong() + 1);
    progress.setStatus(VocabStatus.UNKNOWN);
}
```

#### 🏆 MASTERED
- **Định nghĩa:** User đã thành thạo từ này
- **Khi nào:** TỰ ĐỘNG tính khi đạt điều kiện:
  - `timesCorrect >= 10`
  - `timesWrong <= 2`
  - `accuracy >= 80%`
- **Trong code:** Tự động update
```java
// Auto-calculate MASTERED status
int totalAttempts = timesCorrect + timesWrong;
double accuracy = (double) timesCorrect / totalAttempts;

if (timesCorrect >= 10 && timesWrong <= 2 && accuracy >= 0.8) {
    progress.setStatus(VocabStatus.MASTERED);
}
```

---

### 2️⃣ StreakStatus (Trạng thái chuỗi ngày học)
**Áp dụng cho:** TOÀN BỘ USER (tổng thể học tập)

**4 Trạng thái:**

#### 🆕 NEW
- **Định nghĩa:** User chưa học lần nào
- **Khi nào:** Chưa có record nào trong `user_vocab_progress`
- **Trong code:** `totalStudyDays = 0`

#### 🔥 ACTIVE
- **Định nghĩa:** Đã học hôm nay, streak đang active
- **Khi nào:** `lastActivityDate = today`
- **Message:** "Tuyệt vời! Bạn đang có streak X ngày! 🔥"

#### ⏰ PENDING
- **Định nghĩa:** Cần học hôm nay để duy trì streak
- **Khi nào:** `lastActivityDate = yesterday`
- **Message:** "Học hôm nay để duy trì streak X ngày! ⏰"

#### 💔 BROKEN
- **Định nghĩa:** Đã bỏ lỡ, streak bị reset
- **Khi nào:** `lastActivityDate < yesterday`
- **Message:** "Streak đã bị gián đoạn. Bắt đầu lại hôm nay! 💪"

---

## 🔄 Mối quan hệ giữa VocabStatus và Streak

### ✅ Điều quan trọng:

**Streak KHÔNG PHỤ THUỘC vào VocabStatus!**

- User học từ mới → Tạo record trong `user_vocab_progress` → **Streak tăng**
- User chọn "Đã thuộc" (KNOWN) → **Streak tăng**
- User chọn "Chưa thuộc" (UNKNOWN) → **Streak CŨNG tăng!**
- Từ đạt MASTERED → **Không ảnh hưởng streak**

**Lý do:** Streak đo lường **TÍNH ĐỀU ĐẶN HỌC TẬP**, không đo lường **KẾT QUẢ HỌC TẬP**.

### 📊 Ví dụ thực tế

#### Scenario 1: User học tốt
```
Ngày 1/10:
- Học vocab A → Chọn "Đã thuộc" → Status = KNOWN ✅
- Học vocab B → Chọn "Đã thuộc" → Status = KNOWN ✅
→ Streak = 1

Ngày 2/10:
- Học vocab C → Chọn "Đã thuộc" → Status = KNOWN ✅
→ Streak = 2

Kết quả:
- VocabStatus: 3 từ KNOWN
- StreakStatus: ACTIVE
- currentStreak: 2
```

#### Scenario 2: User học không tốt (nhưng vẫn có streak!)
```
Ngày 1/10:
- Học vocab A → Chọn "Chưa thuộc" → Status = UNKNOWN ❌
- Học vocab B → Chọn "Chưa thuộc" → Status = UNKNOWN ❌
→ Streak = 1 ✅ (vẫn tăng!)

Ngày 2/10:
- Học vocab C → Chọn "Chưa thuộc" → Status = UNKNOWN ❌
→ Streak = 2 ✅ (vẫn tăng!)

Kết quả:
- VocabStatus: 3 từ UNKNOWN (không học tốt)
- StreakStatus: ACTIVE ✅
- currentStreak: 2 ✅ (vẫn có streak vì học đều đặn!)
```

#### Scenario 3: User học từ cũ (review)
```
Ngày 1/10:
- Học vocab A lần đầu → created_at = 1/10 → Tính streak ✅

Ngày 2/10:
- Học vocab B lần đầu → created_at = 2/10 → Tính streak ✅
→ Streak = 2

Ngày 3/10:
- Ôn lại vocab A (đã học 1/10) → created_at VẪN là 1/10 → KHÔNG tính vào streak ❌
- Ôn lại vocab B (đã học 2/10) → created_at VẪN là 2/10 → KHÔNG tính vào streak ❌
→ Streak BROKEN (không học từ mới ngày 3/10)

Kết quả:
- currentStreak = 1 (reset về 1 khi học lại ngày 3/10, nếu tạo từ mới)
- hoặc BROKEN nếu chỉ ôn cũ
```

---

## 💡 Logic tính Streak chi tiết

### Khi nào streak tăng?

**✅ Tăng khi:**
1. User học **từ mới** (tạo record mới trong `user_vocab_progress`)
2. Record được tạo **hôm nay**
3. Ngày hôm nay **liên tục** với ngày học trước đó

**❌ KHÔNG tăng khi:**
1. User chỉ **ôn lại từ cũ** (record đã tồn tại, không tạo mới)
2. User học nhiều từ **cùng 1 ngày** (chỉ tính 1 lần)
3. **Bỏ lỡ ngày** giữa các lần học

### Code logic

```java
// Extract unique dates from user_vocab_progress
Set<LocalDate> studyDates = progressList.stream()
    .map(p -> p.getCreatedAt().toLocalDate()) // Lấy ngày từ created_at
    .collect(Collectors.toCollection(TreeSet::new)); // Unique dates only

// Example:
// User có 10 từ học ngày 1/10 → Chỉ tính 1 ngày
// User có 5 từ học ngày 2/10 → Chỉ tính 1 ngày
// → studyDates = [1/10, 2/10]
// → currentStreak = 2
```

### Tại sao lại dùng created_at?

**Lý do:**
1. **created_at** = Thời điểm user học từ **LẦN ĐẦU TIÊN**
2. Không thay đổi khi user ôn lại
3. Đại diện cho ngày user **BẮT ĐẦU** học từ đó

**So sánh với updated_at:**
```
created_at: Ngày học từ lần đầu ✅ (dùng cho streak)
updated_at: Ngày ôn lại gần nhất ❌ (không dùng cho streak)

Ví dụ:
- 1/10: Học vocab A → created_at = 1/10 ✅
- 5/10: Ôn lại vocab A → updated_at = 5/10, created_at VẪN là 1/10 ✅
→ Streak chỉ tính ngày 1/10 (ngày học lần đầu)
```

---

## 🎯 Best Practices

### 1. Khuyến khích user học từ mới
```
Message khi streak cao:
"Streak 7 ngày! Tiếp tục học từ mới để duy trì! 🔥"

Message khi chỉ ôn cũ:
"Bạn đã ôn lại 5 từ hôm nay. Hãy học thêm từ mới để tăng streak! 💪"
```

### 2. Gamification
```
Streak bonus:
- 7 ngày: +50 coins + badge "Week Warrior"
- 30 ngày: +200 coins + badge "Month Master"
- 100 ngày: +1000 coins + badge "Century Champion"

Điều kiện: Phải học ít nhất 1 từ mới mỗi ngày
```

### 3. Analytics
```
Tracking metrics:
- Số từ mới học/ngày
- Số từ ôn lại/ngày
- Tỷ lệ KNOWN vs UNKNOWN
- Số từ đạt MASTERED

→ Giúp user hiểu được tiến độ học tập
```

---

## 🔄 Flow Chart

```
User mở app học từ vựng
    ↓
Chọn từ để học
    ↓
┌─────────────────────────┬──────────────────────────┐
│  Từ mới (không có       │  Từ cũ (đã học trước)    │
│  trong user_vocab_       │  có trong user_vocab_    │
│  progress)              │  progress)               │
└──────────┬──────────────┴──────────┬───────────────┘
           ↓                         ↓
    Tạo record mới              Update record cũ
    created_at = TODAY          created_at = OLD DATE
           ↓                         ↓
    User chọn đáp án           User chọn đáp án
           ↓                         ↓
    ┌──────────────┬──────────────┐  │
    │ "Đã thuộc"   │ "Chưa thuộc" │  │
    │ KNOWN ✅     │ UNKNOWN ❌   │  │
    └──────┬───────┴──────┬───────┘  │
           ↓              ↓           ↓
    Save to database             Save to database
           ↓                         ↓
    ✅ STREAK TĂNG!          ❌ STREAK KHÔNG TĂNG
    (vì created_at = TODAY)  (vì created_at = OLD DATE)
```

---

## ✅ Summary

| Aspect | VocabStatus | StreakStatus |
|--------|-------------|--------------|
| **Scope** | Per vocab | Per user |
| **States** | NEW, KNOWN, UNKNOWN, MASTERED | NEW, ACTIVE, PENDING, BROKEN |
| **Based on** | User choice + auto-calculation | Study dates (created_at) |
| **Changed by** | User action (submit review) | Time & consistency |
| **Purpose** | Track learning progress per word | Track daily learning habit |

**Key takeaway:** 
- VocabStatus = Bạn học TỪ này thế nào?
- StreakStatus = Bạn học ĐỀU ĐẶN chưa?

---

**Created:** October 31, 2025  
**Purpose:** Clarify VocabStatus vs StreakStatus  
**Status:** ✅ Documentation Complete

