# Phân tích và Đề xuất Status cho Từ vựng trong Game

## Tổng quan hiện tại

### VocabStatus Enum hiện có
```java
public enum VocabStatus {
    NEW,        // Từ mới - chưa có trong bảng user_vocab_progress
    KNOWN,      // Đã thuộc - user đã click "Đã thuộc"
    UNKNOWN,    // Chưa thuộc - user đã click "Chưa thuộc"
    MASTERED    // Thành thạo - tự động tính (timesCorrect >= 10, timesWrong <= 2, accuracy >= 80%)
}
```

---

## Vấn đề phát hiện

### 1. Cách xử lý hiện tại trong 3 game

#### Quick Quiz (QuickQuizService.java)
```java
private void updateVocabProgress(UUID userId, UUID vocabId, boolean isCorrect) {
    UserVocabProgress progress = userVocabProgressRepository
        .findByUserIdAndVocabId(userId, vocabId)
        .orElse(UserVocabProgress.builder()
            .user(user)
            .vocab(vocab)
            .timesCorrect(0)
            .timesWrong(0)
            .efFactor(2.5)
            .intervalDays(1)
            .repetition(0)
            .build()); // ❌ KHÔNG SET STATUS!
    
    if (isCorrect) {
        progress.setTimesCorrect(progress.getTimesCorrect() + 1);
    } else {
        progress.setTimesWrong(progress.getTimesWrong() + 1);
    }
    
    // ❌ Không có logic cập nhật status
    userVocabProgressRepository.save(progress);
}
```

#### Image-Word Matching (ImageWordMatchingService.java)
```java
private void updateUserVocabProgress(User user, Vocab vocab, boolean isCorrect) {
    UserVocabProgress progress;
    if (progressOpt.isPresent()) {
        progress = progressOpt.get();
        if (isCorrect) {
            progress.setTimesCorrect(progress.getTimesCorrect() + 1);
        } else {
            progress.setTimesWrong(progress.getTimesWrong() + 1);
        }
    } else {
        progress = UserVocabProgress.builder()
            .user(user)
            .vocab(vocab)
            .timesCorrect(isCorrect ? 1 : 0)
            .timesWrong(isCorrect ? 0 : 1)
            .build(); // ❌ KHÔNG SET STATUS!
    }
    
    // ❌ Không có logic cập nhật status
    userVocabProgressRepository.save(progress);
}
```

#### Word-Definition Matching (WordDefinitionMatchingService.java)
```java
private void updateUserVocabProgress(User user, Vocab vocab, boolean isCorrect) {
    // Tương tự Image-Word Matching
    // ❌ KHÔNG SET STATUS!
}
```

### 2. Vấn đề nghiêm trọng

❌ **Tất cả 3 game đều KHÔNG set status khi tạo record mới!**

Điều này dẫn đến:
- `status` = `NULL` trong database
- Các query lọc theo status sẽ bị sai
- Không thể phân biệt NEW, KNOWN, UNKNOWN
- Logic mastered không được kiểm tra

---

## Đề xuất giải pháp

### Phương án 1: Tự động set status dựa trên kết quả (⭐ KHUYẾN NGHỊ)

#### Logic đề xuất:

```
┌─────────────────────────────────────────────────────────────────┐
│           FLOW QUẢN LÝ STATUS TỪ VỰNG TRONG GAME                 │
└─────────────────────────────────────────────────────────────────┘

1. Khi user chơi game lần đầu với 1 từ:
   ├─ Tạo record mới trong user_vocab_progress
   ├─ Set status dựa trên kết quả:
   │  ├─ Nếu isCorrect = true  → status = KNOWN
   │  └─ Nếu isCorrect = false → status = UNKNOWN
   └─ Lưu vào database

2. Khi user chơi lại từ đã có:
   ├─ Lấy record hiện có
   ├─ Cập nhật timesCorrect hoặc timesWrong
   ├─ Kiểm tra điều kiện MASTERED:
   │  ├─ timesCorrect >= 10
   │  ├─ timesWrong <= 2  
   │  ├─ accuracy = timesCorrect / (timesCorrect + timesWrong) >= 0.8
   │  └─ Nếu đạt → status = MASTERED
   ├─ Nếu chưa MASTERED:
   │  ├─ Nếu isCorrect = true  → status = KNOWN
   │  └─ Nếu isCorrect = false → status = UNKNOWN
   └─ Lưu vào database

3. Status transition:
   NEW → KNOWN (trả lời đúng lần đầu)
   NEW → UNKNOWN (trả lời sai lần đầu)
   KNOWN → UNKNOWN (trả lời sai khi đã biết)
   UNKNOWN → KNOWN (trả lời đúng khi chưa biết)
   KNOWN → MASTERED (đạt điều kiện mastered)
   UNKNOWN → MASTERED (đạt điều kiện mastered)
   MASTERED → MASTERED (giữ nguyên, không downgrade)
```

#### Ưu điểm:
✅ Tự động, không cần user thao tác thêm
✅ Phản ánh chính xác trình độ user với từ đó
✅ Consistent logic cho cả 3 game
✅ Dễ tracking tiến trình học tập

#### Nhược điểm:
⚠️ User không có quyền "tự đánh giá" như API Learn Vocab
⚠️ 1 lần sai có thể chuyển KNOWN → UNKNOWN

---

### Phương án 2: Luôn giữ status = NEW cho game, chỉ cập nhật số liệu

```
1. Khi chơi game:
   ├─ Tạo hoặc update record
   ├─ Set status = NEW (nếu tạo mới)
   ├─ Chỉ cập nhật: timesCorrect, timesWrong, efFactor, intervalDays, etc.
   └─ Không thay đổi status

2. Status chỉ được cập nhật qua:
   ├─ API Learn Vocab (user tự chọn "Đã thuộc" / "Chưa thuộc")
   └─ Background job tính MASTERED định kỳ
```

#### Ưu điểm:
✅ Tách biệt rõ ràng giữa "chơi game" và "học từ"
✅ User có quyền kiểm soát status
✅ Game chỉ focus vào tracking attempts

#### Nhược điểm:
❌ Status không phản ánh đúng thực tế (đã trả lời đúng nhiều lần nhưng vẫn NEW)
❌ Phức tạp hơn, cần thêm background job
❌ User có thể quên không update status

---

### Phương án 3: Hybrid - Kết hợp cả 2 (⭐⭐ KHUYẾN NGHỊ NHẤT)

```
┌─────────────────────────────────────────────────────────────────┐
│                      HYBRID APPROACH                             │
└─────────────────────────────────────────────────────────────────┘

1. Khi tạo record mới (lần đầu gặp từ trong game):
   ├─ Set status = NEW
   ├─ Cập nhật timesCorrect/timesWrong dựa trên kết quả
   └─ Lưu database

2. Khi update record đã có:
   ├─ Giữ nguyên status hiện tại (NEW, KNOWN, UNKNOWN)
   ├─ Chỉ cập nhật số liệu: timesCorrect, timesWrong, etc.
   ├─ Kiểm tra điều kiện MASTERED:
   │  └─ Nếu đạt → status = MASTERED (auto upgrade)
   └─ Lưu database

3. Status transition rules:
   NEW → NEW (mặc định, giữ nguyên)
   NEW → MASTERED (tự động khi đạt điều kiện)
   KNOWN → KNOWN (giữ nguyên)
   KNOWN → MASTERED (tự động khi đạt điều kiện)
   UNKNOWN → UNKNOWN (giữ nguyên)
   UNKNOWN → MASTERED (tự động khi đạt điều kiện)
   MASTERED → MASTERED (không downgrade)

4. User có thể thay đổi status thủ công qua:
   ├─ API Learn Vocab
   └─ Hoặc API riêng: PUT /api/v1/vocab/{vocabId}/status
```

#### Ưu điểm:
✅ Tự động set status = NEW cho từ mới
✅ Tự động upgrade lên MASTERED khi đạt điều kiện
✅ User vẫn có quyền kiểm soát status (qua API khác)
✅ Không có status NULL trong database
✅ Cân bằng giữa tự động và thủ công

#### Nhược điểm:
⚠️ Logic phức tạp hơn một chút
⚠️ Cần document rõ ràng cho team và user

---

## Implementation - Phương án 3 (Khuyến nghị)

### 1. Tạo Utility Class để tính toán Status

```java
package com.thuanthichlaptrinh.card_words.core.util;

import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
import com.thuanthichlaptrinh.card_words.core.domain.UserVocabProgress;

public class VocabStatusCalculator {
    
    // Điều kiện để đạt MASTERED
    private static final int MIN_CORRECT_FOR_MASTERED = 10;
    private static final int MAX_WRONG_FOR_MASTERED = 2;
    private static final double MIN_ACCURACY_FOR_MASTERED = 0.8; // 80%
    
    /**
     * Tính status mới cho vocab progress
     * 
     * @param currentStatus Status hiện tại (có thể null nếu mới tạo)
     * @param timesCorrect Tổng số lần đúng
     * @param timesWrong Tổng số lần sai
     * @return Status mới phù hợp
     */
    public static VocabStatus calculateStatus(
            VocabStatus currentStatus, 
            int timesCorrect, 
            int timesWrong) {
        
        // 1. Nếu đã MASTERED → giữ nguyên (không downgrade)
        if (currentStatus == VocabStatus.MASTERED) {
            return VocabStatus.MASTERED;
        }
        
        // 2. Kiểm tra điều kiện MASTERED
        if (isMastered(timesCorrect, timesWrong)) {
            return VocabStatus.MASTERED;
        }
        
        // 3. Nếu là record mới (currentStatus = null) → set NEW
        if (currentStatus == null) {
            return VocabStatus.NEW;
        }
        
        // 4. Giữ nguyên status hiện tại (NEW, KNOWN, UNKNOWN)
        return currentStatus;
    }
    
    /**
     * Kiểm tra có đạt điều kiện MASTERED không
     */
    public static boolean isMastered(int timesCorrect, int timesWrong) {
        // Phải có ít nhất 10 lần đúng
        if (timesCorrect < MIN_CORRECT_FOR_MASTERED) {
            return false;
        }
        
        // Số lần sai không quá 2
        if (timesWrong > MAX_WRONG_FOR_MASTERED) {
            return false;
        }
        
        // Tính accuracy
        int totalAttempts = timesCorrect + timesWrong;
        if (totalAttempts == 0) {
            return false;
        }
        
        double accuracy = (double) timesCorrect / totalAttempts;
        return accuracy >= MIN_ACCURACY_FOR_MASTERED;
    }
    
    /**
     * Tính accuracy từ progress
     */
    public static double calculateAccuracy(UserVocabProgress progress) {
        int total = progress.getTimesCorrect() + progress.getTimesWrong();
        if (total == 0) {
            return 0.0;
        }
        return (double) progress.getTimesCorrect() / total;
    }
}
```

### 2. Update QuickQuizService

```java
private void updateVocabProgress(UUID userId, UUID vocabId, boolean isCorrect) {
    User user = new User();
    user.setId(userId);

    Vocab vocab = new Vocab();
    vocab.setId(vocabId);

    UserVocabProgress progress = userVocabProgressRepository
            .findByUserIdAndVocabId(userId, vocabId)
            .orElse(UserVocabProgress.builder()
                    .user(user)
                    .vocab(vocab)
                    .status(VocabStatus.NEW) // ✅ Set status = NEW cho record mới
                    .timesCorrect(0)
                    .timesWrong(0)
                    .efFactor(2.5)
                    .intervalDays(1)
                    .repetition(0)
                    .build());

    // Lưu status hiện tại
    VocabStatus currentStatus = progress.getStatus();
    
    // Cập nhật số liệu
    if (isCorrect) {
        progress.setTimesCorrect(progress.getTimesCorrect() + 1);
        progress.setRepetition(progress.getRepetition() + 1);

        // SM-2 algorithm: increase interval
        if (progress.getRepetition() == 1) {
            progress.setIntervalDays(1);
        } else if (progress.getRepetition() == 2) {
            progress.setIntervalDays(6);
        } else {
            progress.setIntervalDays((int) (progress.getIntervalDays() * progress.getEfFactor()));
        }
    } else {
        progress.setTimesWrong(progress.getTimesWrong() + 1);
        progress.setRepetition(0); // Reset
        progress.setIntervalDays(1);
    }
    
    // ✅ Tính toán và cập nhật status mới
    VocabStatus newStatus = VocabStatusCalculator.calculateStatus(
        currentStatus,
        progress.getTimesCorrect(),
        progress.getTimesWrong()
    );
    progress.setStatus(newStatus);
    
    // Cập nhật lastReviewed và nextReviewDate
    progress.setLastReviewed(LocalDate.now());
    progress.setNextReviewDate(LocalDate.now().plusDays(progress.getIntervalDays()));

    userVocabProgressRepository.save(progress);
    
    // Log status change
    if (currentStatus != newStatus) {
        log.info("Vocab status updated: userId={}, vocabId={}, {} -> {}", 
                 userId, vocabId, currentStatus, newStatus);
    }
}
```

### 3. Update ImageWordMatchingService

```java
private void updateUserVocabProgress(User user, Vocab vocab, boolean isCorrect) {
    Optional<UserVocabProgress> progressOpt = userVocabProgressRepository
            .findByUserIdAndVocabId(user.getId(), vocab.getId());

    UserVocabProgress progress;
    VocabStatus currentStatus;
    
    if (progressOpt.isPresent()) {
        // Record đã tồn tại
        progress = progressOpt.get();
        currentStatus = progress.getStatus();
        
        if (isCorrect) {
            progress.setTimesCorrect(progress.getTimesCorrect() + 1);
        } else {
            progress.setTimesWrong(progress.getTimesWrong() + 1);
        }
    } else {
        // Record mới - set status = NEW
        currentStatus = null;
        progress = UserVocabProgress.builder()
                .user(user)
                .vocab(vocab)
                .status(VocabStatus.NEW) // ✅ Set status = NEW
                .timesCorrect(isCorrect ? 1 : 0)
                .timesWrong(isCorrect ? 0 : 1)
                .efFactor(2.5)
                .intervalDays(1)
                .repetition(0)
                .build();
    }
    
    // ✅ Tính toán và cập nhật status mới
    VocabStatus newStatus = VocabStatusCalculator.calculateStatus(
        currentStatus,
        progress.getTimesCorrect(),
        progress.getTimesWrong()
    );
    progress.setStatus(newStatus);
    
    // Cập nhật review dates
    progress.setLastReviewed(LocalDate.now());
    if (progress.getIntervalDays() != null && progress.getIntervalDays() > 0) {
        progress.setNextReviewDate(LocalDate.now().plusDays(progress.getIntervalDays()));
    }

    userVocabProgressRepository.save(progress);
    
    // Log status change
    if (currentStatus != newStatus) {
        log.info("Vocab status updated: userId={}, vocabId={}, {} -> {}", 
                 user.getId(), vocab.getId(), currentStatus, newStatus);
    }
}
```

### 4. Update WordDefinitionMatchingService

```java
private void updateUserVocabProgress(User user, Vocab vocab, boolean isCorrect) {
    Optional<UserVocabProgress> progressOpt = userVocabProgressRepository
            .findByUserIdAndVocabId(user.getId(), vocab.getId());

    UserVocabProgress progress;
    VocabStatus currentStatus;
    
    if (progressOpt.isPresent()) {
        progress = progressOpt.get();
        currentStatus = progress.getStatus();
        
        if (isCorrect) {
            progress.setTimesCorrect(progress.getTimesCorrect() + 1);
        } else {
            progress.setTimesWrong(progress.getTimesWrong() + 1);
        }
    } else {
        currentStatus = null;
        progress = UserVocabProgress.builder()
                .user(user)
                .vocab(vocab)
                .status(VocabStatus.NEW) // ✅ Set status = NEW
                .timesCorrect(isCorrect ? 1 : 0)
                .timesWrong(isCorrect ? 0 : 1)
                .efFactor(2.5)
                .intervalDays(1)
                .repetition(0)
                .build();
    }
    
    // ✅ Tính toán và cập nhật status mới
    VocabStatus newStatus = VocabStatusCalculator.calculateStatus(
        currentStatus,
        progress.getTimesCorrect(),
        progress.getTimesWrong()
    );
    progress.setStatus(newStatus);
    
    // Cập nhật review dates
    progress.setLastReviewed(LocalDate.now());
    if (progress.getIntervalDays() != null && progress.getIntervalDays() > 0) {
        progress.setNextReviewDate(LocalDate.now().plusDays(progress.getIntervalDays()));
    }

    userVocabProgressRepository.save(progress);
    
    // Log status change
    if (currentStatus != newStatus) {
        log.info("Vocab status updated: userId={}, vocabId={}, {} -> {}", 
                 user.getId(), vocab.getId(), currentStatus, newStatus);
    }
}
```

---

## So sánh với API Learn Vocab

### Learn Vocab API (LearnVocabService)
```java
// User TỰ CHỌN status khi học từ
public void submitLearningResult(User user, UUID vocabId, boolean isKnown) {
    progress.setStatus(isKnown ? VocabStatus.KNOWN : VocabStatus.UNKNOWN);
    // User có quyền quyết định
}
```

### Game Services (3 games)
```java
// Status TỰ ĐỘNG dựa trên performance
public void updateVocabProgress(User user, Vocab vocab, boolean isCorrect) {
    // Lần đầu: status = NEW
    // Sau đó: tự động lên MASTERED nếu đạt điều kiện
    // Giữ nguyên NEW/KNOWN/UNKNOWN nếu chưa đạt
}
```

**Kết luận**: Cả 2 cách đều có thể cập nhật status, nhưng:
- **Learn Vocab**: User tự đánh giá → Chủ quan nhưng chính xác theo cảm nhận user
- **Games**: Hệ thống tự tính → Khách quan dựa trên kết quả thực tế

---

## Status Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    VOCAB STATUS LIFECYCLE                        │
└─────────────────────────────────────────────────────────────────┘

                          ┌─────────┐
                          │   NEW   │ (Record mới được tạo)
                          └────┬────┘
                               │
                ┌──────────────┼──────────────┐
                │                             │
         [Learn Vocab API]              [Game - chơi nhiều lần]
                │                             │
                ↓                             ↓
        ┌───────────────┐           ┌──────────────┐
        │ KNOWN/UNKNOWN │           │     NEW      │
        │  (User chọn)  │           │ (Giữ nguyên) │
        └───────┬───────┘           └──────┬───────┘
                │                          │
                │                          │
                └──────────┬───────────────┘
                           │
                    [Đạt điều kiện]
                   (10 correct, ≤2 wrong, 80% accuracy)
                           │
                           ↓
                    ┌──────────┐
                    │ MASTERED │ ──┐
                    └──────────┘   │
                           ↑       │
                           └───────┘
                      (Không downgrade)
```

---

## Testing Strategy

### Test Cases cần implement

#### 1. Test tạo record mới
```java
@Test
void whenFirstPlayGame_shouldSetStatusToNew() {
    // Given: User chưa có progress cho vocab này
    // When: Chơi game và trả lời (đúng hoặc sai)
    // Then: Status = NEW
}
```

#### 2. Test update existing record
```java
@Test
void whenPlayAgain_shouldKeepStatusIfNotMastered() {
    // Given: Record đã tồn tại với status = NEW
    // When: Chơi lại nhưng chưa đạt điều kiện mastered
    // Then: Status vẫn = NEW
}
```

#### 3. Test auto upgrade to MASTERED
```java
@Test
void whenReachMasteredCondition_shouldAutoUpgrade() {
    // Given: timesCorrect = 9, timesWrong = 1
    // When: Trả lời đúng thêm 1 lần (timesCorrect = 10)
    // Then: Status = MASTERED
}
```

#### 4. Test không downgrade từ MASTERED
```java
@Test
void whenMastered_shouldNotDowngrade() {
    // Given: Status = MASTERED
    // When: Trả lời sai
    // Then: Status vẫn = MASTERED
}
```

---

## Migration Plan

### Bước 1: Tạo Utility Class
- Tạo `VocabStatusCalculator.java`
- Test thoroughly

### Bước 2: Update Services từng cái một
1. Update QuickQuizService
2. Test Quick Quiz game
3. Update ImageWordMatchingService
4. Test Image-Word Matching game
5. Update WordDefinitionMatchingService
6. Test Word-Definition Matching game

### Bước 3: Migrate dữ liệu cũ
```sql
-- Set status = NEW cho các record có status = NULL
UPDATE user_vocab_progress
SET status = 'NEW'
WHERE status IS NULL;

-- Tự động update status = MASTERED cho các record đạt điều kiện
UPDATE user_vocab_progress
SET status = 'MASTERED'
WHERE status != 'MASTERED'
  AND times_correct >= 10
  AND times_wrong <= 2
  AND (times_correct::float / (times_correct + times_wrong)) >= 0.8;
```

### Bước 4: Add database constraint
```sql
ALTER TABLE user_vocab_progress
ALTER COLUMN status SET NOT NULL;

ALTER TABLE user_vocab_progress
ALTER COLUMN status SET DEFAULT 'NEW';
```

---

## Monitoring và Analytics

### Metrics cần track
1. **Status distribution**: Số lượng vocab ở mỗi status
2. **Status transition rate**: Tỷ lệ chuyển từ NEW → MASTERED
3. **Time to mastery**: Thời gian trung bình để đạt MASTERED
4. **Accuracy by status**: Độ chính xác theo từng status

### Dashboard suggestions
```sql
-- Status distribution by user
SELECT 
    u.email,
    COUNT(CASE WHEN uvp.status = 'NEW' THEN 1 END) as new_count,
    COUNT(CASE WHEN uvp.status = 'KNOWN' THEN 1 END) as known_count,
    COUNT(CASE WHEN uvp.status = 'UNKNOWN' THEN 1 END) as unknown_count,
    COUNT(CASE WHEN uvp.status = 'MASTERED' THEN 1 END) as mastered_count,
    COUNT(*) as total
FROM users u
LEFT JOIN user_vocab_progress uvp ON u.id = uvp.user_id
GROUP BY u.id, u.email
ORDER BY mastered_count DESC;

-- Average time to mastery
SELECT 
    AVG(EXTRACT(EPOCH FROM (updated_at - created_at)) / 86400) as avg_days_to_mastery
FROM user_vocab_progress
WHERE status = 'MASTERED';
```

---

## Conclusion

### ⭐ Khuyến nghị cuối cùng: Phương án 3 (Hybrid)

**Lý do**:
1. ✅ Tự động set status = NEW cho từ mới → Không còn NULL
2. ✅ Tự động upgrade lên MASTERED khi đạt điều kiện → Động lực học tập
3. ✅ User vẫn có quyền kiểm soát qua Learn Vocab API → Linh hoạt
4. ✅ Giữ nguyên status hiện tại (NEW/KNOWN/UNKNOWN) nếu chưa MASTERED → Ổn định
5. ✅ Không downgrade từ MASTERED → Tôn trọng thành tựu của user

**Implementation priority**:
1. **High**: Tạo `VocabStatusCalculator` utility class
2. **High**: Update 3 game services để set status
3. **Medium**: Migrate dữ liệu cũ
4. **Low**: Add monitoring dashboard

---

**Date**: 2025-11-02  
**Version**: 1.0  
**Status**: Đề xuất - Chờ approval

