# Giải Thích Cách Tính Tiến Độ Topic

## Công Thức Chính Xác

```
Progress (%) = (Số từ có trong user_vocab_progress / Tổng số từ trong topic) × 100
```

## Ví Dụ Minh Họa

### Case 1: User đã bắt đầu học

**Topic: "Animals"**

-   Tổng số từ trong topic: **100 từ**

**Bảng `user_vocab_progress` của User A:**

```sql
| vocab_id | status   |
|----------|----------|
| vocab_1  | NEW      |
| vocab_2  | KNOWN    |
| vocab_3  | UNKNOWN  |
| vocab_4  | MASTERED |
| vocab_5  | KNOWN    |
```

**Tính toán:**

-   Số từ có trong `user_vocab_progress`: **5 từ** (tất cả 5 records)
-   Tổng từ trong topic: **100 từ**
-   Progress = (5 / 100) × 100 = **5.0%**

✅ **Tất cả từ trong `user_vocab_progress` đều được tính**, không quan tâm status là gì.

---

### Case 2: User chưa bắt đầu học

**Topic: "Animals"**

-   Tổng số từ trong topic: **100 từ**

**Bảng `user_vocab_progress` của User B:**

```sql
(Không có record nào)
```

**Tính toán:**

-   Số từ có trong `user_vocab_progress`: **0 từ**
-   Tổng từ trong topic: **100 từ**
-   Progress = (0 / 100) × 100 = **0.0%**

---

### Case 3: User đã học hết

**Topic: "Colors"**

-   Tổng số từ trong topic: **10 từ**

**Bảng `user_vocab_progress` của User C:**

```sql
| vocab_id  | status   |
|-----------|----------|
| vocab_10  | MASTERED |
| vocab_11  | KNOWN    |
| vocab_12  | MASTERED |
| vocab_13  | KNOWN    |
| vocab_14  | MASTERED |
| vocab_15  | MASTERED |
| vocab_16  | UNKNOWN  |
| vocab_17  | MASTERED |
| vocab_18  | KNOWN    |
| vocab_19  | MASTERED |
```

**Tính toán:**

-   Số từ có trong `user_vocab_progress`: **10 từ**
-   Tổng từ trong topic: **10 từ**
-   Progress = (10 / 10) × 100 = **100.0%**

---

## SQL Query Thực Tế

### Query đếm từ trong user_vocab_progress:

```sql
SELECT COUNT(uvp)
FROM user_vocab_progress uvp
JOIN vocab v ON uvp.vocab_id = v.id
WHERE uvp.user_id = :userId
AND v.topic_id = :topicId;
```

**Điều này đếm TẤT CẢ records** trong `user_vocab_progress`, không filter theo status.

### Query đếm tổng từ trong topic:

```sql
SELECT COUNT(v)
FROM vocab v
WHERE v.topic_id = :topicId;
```

---

## Ý Nghĩa

-   ✅ **Từ có trong `user_vocab_progress`** = Từ mà user đã "tương tác" (đã gặp/học ít nhất 1 lần)
-   ✅ Không quan tâm status là `NEW`, `KNOWN`, `UNKNOWN`, hay `MASTERED`
-   ✅ Chỉ cần từ xuất hiện trong bảng `user_vocab_progress` là được tính

---

## So Sánh Với Cách Tính Khác (KHÔNG dùng)

### ❌ Cách KHÔNG đúng: Chỉ tính từ có status = MASTERED

```sql
-- SAI - Không phải yêu cầu
SELECT COUNT(uvp)
FROM user_vocab_progress uvp
WHERE uvp.user_id = :userId
AND uvp.status = 'MASTERED';
```

### ❌ Cách KHÔNG đúng: Chỉ tính từ có timesCorrect > 0

```sql
-- SAI - Không phải yêu cầu
SELECT COUNT(uvp)
FROM user_vocab_progress uvp
WHERE uvp.user_id = :userId
AND uvp.times_correct > 0;
```

### ✅ Cách ĐÚNG: Tính tất cả từ có trong bảng

```sql
-- ĐÚNG - Tính tất cả records
SELECT COUNT(uvp)
FROM user_vocab_progress uvp
JOIN vocab v ON uvp.vocab_id = v.id
WHERE uvp.user_id = :userId
AND v.topic_id = :topicId;
```

---

## Test Cases Để Verify

```java
// Test Case 1: User chưa học từ nào
Topic topic1 = { id: 1, totalVocabs: 100 }
UserVocabProgress records = []
Expected: progress = 0.0%

// Test Case 2: User học 30/100 từ
Topic topic2 = { id: 2, totalVocabs: 100 }
UserVocabProgress records = [
    { status: NEW },      // 10 từ
    { status: KNOWN },    // 15 từ
    { status: UNKNOWN },  // 3 từ
    { status: MASTERED }  // 2 từ
] // Tổng 30 từ
Expected: progress = 30.0%

// Test Case 3: User học hết 50/50 từ
Topic topic3 = { id: 3, totalVocabs: 50 }
UserVocabProgress records = 50 records (bất kỳ status nào)
Expected: progress = 100.0%

// Test Case 4: Topic không có từ vựng
Topic topic4 = { id: 4, totalVocabs: 0 }
UserVocabProgress records = []
Expected: progress = 0.0%
```

---

## Kết Luận

**Tiến độ được tính dựa trên việc từ vựng có xuất hiện trong bảng `user_vocab_progress` hay không, không phân biệt status.**

Điều này có ý nghĩa:

-   User đã "gặp" từ đó ít nhất 1 lần
-   User đã bắt đầu quá trình học từ đó
-   Từ đó đã được track trong hệ thống học của user
