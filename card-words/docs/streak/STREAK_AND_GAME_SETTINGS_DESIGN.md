# 🎯 Thiết kế API Streak & Game Settings

> **Mục tiêu:** Tạo hệ thống tracking streak học tập và cho phép user tùy chỉnh cấu hình game

**Ngày tạo:** 31/10/2025

---

## 📋 Tổng quan Features

### 1. **Streak System (Hệ thống chuỗi ngày học)**

-   Tracking số ngày user học liên tục
-   Tính điểm thưởng dựa trên streak
-   Reset khi bỏ lỡ 1 ngày
-   Hiển thị streak hiện tại, cao nhất, lần ôn tập gần nhất

### 2. **Game Settings (Cấu hình game)**

-   User tùy chỉnh số câu hỏi/cặp thẻ cho mỗi game
-   Lưu preference cho từng game
-   Validation giá trị hợp lệ
-   Default settings nếu chưa cấu hình

---

## 🗂️ Database Schema

### 1. Thêm cột vào bảng `users`

```sql
-- Migration: Add streak columns to users table
ALTER TABLE users
ADD COLUMN current_streak INT DEFAULT 0,
ADD COLUMN longest_streak INT DEFAULT 0,
ADD COLUMN last_activity_date DATE,
ADD COLUMN total_study_days INT DEFAULT 0;

-- Index for performance
CREATE INDEX idx_user_current_streak ON users(current_streak);
CREATE INDEX idx_user_last_activity ON users(last_activity_date);
```

**Giải thích:**

-   `current_streak`: Số ngày học liên tục hiện tại
-   `longest_streak`: Kỷ lục streak cao nhất từng đạt được
-   `last_activity_date`: Ngày học gần nhất (DATE, không có time)
-   `total_study_days`: Tổng số ngày đã học (không cần liên tục)

### 2. Tạo bảng `user_game_settings`

```sql
-- Migration: Create user game settings table
CREATE TABLE user_game_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    game_name VARCHAR(50) NOT NULL,

    -- Quick Quiz settings
    quick_quiz_total_questions INT,
    quick_quiz_time_per_question INT,

    -- Image Word Matching settings
    image_word_total_pairs INT,

    -- Flashcard Matching settings (nếu có game thứ 3)
    flashcard_total_pairs INT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_user_game_settings_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT uq_user_game UNIQUE(user_id, game_name)
);

-- Indexes
CREATE INDEX idx_ugs_user_id ON user_game_settings(user_id);
CREATE INDEX idx_ugs_game_name ON user_game_settings(game_name);
```

**Lý do thiết kế:**

-   Mỗi user có 1 record cho mỗi game
-   Flexible: có thể thêm settings cho game mới
-   `game_name`: 'QUICK_QUIZ', 'IMAGE_WORD_MATCHING', 'FLASHCARD_MATCHING'

---

## 🏗️ Entity Classes

### 1. User Entity (Update)

```java
@Entity
@Table(name = "users")
public class User extends BaseUUIDEntity {
    // ...existing fields...

    @Builder.Default
    @Column(name = "current_streak")
    private Integer currentStreak = 0;

    @Builder.Default
    @Column(name = "longest_streak")
    private Integer longestStreak = 0;

    @Column(name = "last_activity_date")
    private LocalDate lastActivityDate;

    @Builder.Default
    @Column(name = "total_study_days")
    private Integer totalStudyDays = 0;

    // Relationship
    @Builder.Default
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<UserGameSettings> gameSettings = new HashSet<>();

    // ...existing methods...
}
```

### 2. UserGameSettings Entity (New)

```java
package com.thuanthichlaptrinh.card_words.core.domain;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.GenericGenerator;

import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "user_game_settings",
       uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "game_name"}),
       indexes = {
           @Index(name = "idx_ugs_user_id", columnList = "user_id"),
           @Index(name = "idx_ugs_game_name", columnList = "game_name")
       })
public class UserGameSettings extends BaseEntity {

    @Id
    @GeneratedValue(generator = "UUID")
    @GenericGenerator(name = "UUID", strategy = "org.hibernate.id.UUIDGenerator")
    @Column(updatable = false, nullable = false, columnDefinition = "uuid")
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(name = "game_name", length = 50, nullable = false)
    private GameName gameName;

    // Quick Quiz settings
    @Column(name = "quick_quiz_total_questions")
    private Integer quickQuizTotalQuestions;

    @Column(name = "quick_quiz_time_per_question")
    private Integer quickQuizTimePerQuestion;

    // Image Word Matching settings
    @Column(name = "image_word_total_pairs")
    private Integer imageWordTotalPairs;

    // Flashcard Matching settings
    @Column(name = "flashcard_total_pairs")
    private Integer flashcardTotalPairs;
}
```

### 3. GameName Enum (New)

```java
package com.thuanthichlaptrinh.card_words.common.enums;

public enum GameName {
    QUICK_QUIZ("Quick Quiz", "Trắc nghiệm nhanh"),
    IMAGE_WORD_MATCHING("Image Word Matching", "Ghép hình và từ"),
    FLASHCARD_MATCHING("Flashcard Matching", "Ghép thẻ từ vựng");

    private final String displayName;
    private final String displayNameVi;

    GameName(String displayName, String displayNameVi) {
        this.displayName = displayName;
        this.displayNameVi = displayNameVi;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getDisplayNameVi() {
        return displayNameVi;
    }
}
```

---

## 📡 API Design

### 🔥 A. Streak APIs

#### 1. GET `/api/v1/user/streak` - Lấy thông tin streak

**Response:**

```json
{
    "success": true,
    "data": {
        "currentStreak": 7,
        "longestStreak": 15,
        "lastActivityDate": "2025-10-31",
        "totalStudyDays": 45,
        "streakStatus": "ACTIVE",
        "daysUntilBreak": 0,
        "message": "Bạn đang có chuỗi 7 ngày học liên tục! 🔥"
    }
}
```

**Logic:**

```java
public StreakResponse getStreak(User user) {
    LocalDate today = LocalDate.now();
    LocalDate lastActivity = user.getLastActivityDate();

    String status;
    int daysUntilBreak;

    if (lastActivity == null) {
        status = "NEW";
        daysUntilBreak = 1;
    } else if (lastActivity.equals(today)) {
        status = "ACTIVE";
        daysUntilBreak = 0;
    } else if (lastActivity.equals(today.minusDays(1))) {
        status = "PENDING";
        daysUntilBreak = 1;
    } else {
        status = "BROKEN";
        daysUntilBreak = -1;
    }

    return StreakResponse.builder()
        .currentStreak(user.getCurrentStreak())
        .longestStreak(user.getLongestStreak())
        .lastActivityDate(user.getLastActivityDate())
        .totalStudyDays(user.getTotalStudyDays())
        .streakStatus(status)
        .daysUntilBreak(daysUntilBreak)
        .message(generateStreakMessage(user.getCurrentStreak(), status))
        .build();
}
```

#### 2. POST `/api/v1/user/streak/record` - Ghi nhận hoạt động học

**Trigger:** Tự động gọi khi:

-   User hoàn thành game session
-   User ôn tập flashcard
-   User học từ mới

**Request:** (Không cần body, lấy từ JWT)

**Response:**

```json
{
    "success": true,
    "data": {
        "currentStreak": 8,
        "longestStreak": 15,
        "isNewRecord": false,
        "streakIncreased": true,
        "message": "Chuỗi học của bạn đã tăng lên 8 ngày! 🎉"
    }
}
```

**Logic:**

```java
@Transactional
public StreakRecordResponse recordActivity(User user) {
    LocalDate today = LocalDate.now();
    LocalDate lastActivity = user.getLastActivityDate();

    boolean streakIncreased = false;
    boolean isNewRecord = false;

    // Nếu chưa học hôm nay
    if (lastActivity == null || !lastActivity.equals(today)) {

        if (lastActivity == null) {
            // Lần đầu tiên học
            user.setCurrentStreak(1);
            user.setTotalStudyDays(1);
        } else if (lastActivity.equals(today.minusDays(1))) {
            // Học liên tục (ngày hôm qua)
            user.setCurrentStreak(user.getCurrentStreak() + 1);
            user.setTotalStudyDays(user.getTotalStudyDays() + 1);
            streakIncreased = true;
        } else {
            // Bỏ lỡ ít nhất 1 ngày -> Reset streak
            user.setCurrentStreak(1);
            user.setTotalStudyDays(user.getTotalStudyDays() + 1);
        }

        // Update longest streak
        if (user.getCurrentStreak() > user.getLongestStreak()) {
            user.setLongestStreak(user.getCurrentStreak());
            isNewRecord = true;
        }

        user.setLastActivityDate(today);
        userRepository.save(user);
    }

    return StreakRecordResponse.builder()
        .currentStreak(user.getCurrentStreak())
        .longestStreak(user.getLongestStreak())
        .isNewRecord(isNewRecord)
        .streakIncreased(streakIncreased)
        .message(generateRecordMessage(user.getCurrentStreak(), isNewRecord))
        .build();
}
```

---

### ⚙️ B. Game Settings APIs

#### 1. GET `/api/v1/user/game-settings/{gameName}` - Lấy cấu hình game

**URL:**

-   `/api/v1/user/game-settings/QUICK_QUIZ`
-   `/api/v1/user/game-settings/IMAGE_WORD_MATCHING`

**Response:**

```json
{
    "success": true,
    "data": {
        "gameName": "QUICK_QUIZ",
        "settings": {
            "totalQuestions": 15,
            "timePerQuestion": 5
        },
        "defaults": {
            "totalQuestions": 10,
            "timePerQuestion": 3
        },
        "limits": {
            "minQuestions": 5,
            "maxQuestions": 50,
            "minTime": 1,
            "maxTime": 10
        }
    }
}
```

**Response cho Image Word Matching:**

```json
{
    "success": true,
    "data": {
        "gameName": "IMAGE_WORD_MATCHING",
        "settings": {
            "totalPairs": 8
        },
        "defaults": {
            "totalPairs": 5
        },
        "limits": {
            "minPairs": 3,
            "maxPairs": 12
        }
    }
}
```

#### 2. PUT `/api/v1/user/game-settings/{gameName}` - Cập nhật cấu hình

**Request cho Quick Quiz:**

```json
{
    "totalQuestions": 20,
    "timePerQuestion": 5
}
```

**Request cho Image Word Matching:**

```json
{
    "totalPairs": 8
}
```

**Response:**

```json
{
    "success": true,
    "message": "Cấu hình game đã được cập nhật thành công",
    "data": {
        "gameName": "QUICK_QUIZ",
        "settings": {
            "totalQuestions": 20,
            "timePerQuestion": 5
        }
    }
}
```

**Validation:**

```java
public class QuickQuizSettingsRequest {
    @Min(value = 5, message = "Số câu hỏi tối thiểu là 5")
    @Max(value = 50, message = "Số câu hỏi tối đa là 50")
    private Integer totalQuestions;

    @Min(value = 1, message = "Thời gian tối thiểu là 1 giây")
    @Max(value = 10, message = "Thời gian tối đa là 10 giây")
    private Integer timePerQuestion;
}

public class ImageWordMatchingSettingsRequest {
    @Min(value = 3, message = "Số cặp tối thiểu là 3")
    @Max(value = 12, message = "Số cặp tối đa là 12")
    private Integer totalPairs;
}
```

#### 3. GET `/api/v1/user/game-settings` - Lấy tất cả cấu hình

**Response:**

```json
{
    "success": true,
    "data": [
        {
            "gameName": "QUICK_QUIZ",
            "displayName": "Quick Quiz",
            "displayNameVi": "Trắc nghiệm nhanh",
            "settings": {
                "totalQuestions": 15,
                "timePerQuestion": 5
            }
        },
        {
            "gameName": "IMAGE_WORD_MATCHING",
            "displayName": "Image Word Matching",
            "displayNameVi": "Ghép hình và từ",
            "settings": {
                "totalPairs": 8
            }
        }
    ]
}
```

#### 4. DELETE `/api/v1/user/game-settings/{gameName}` - Reset về mặc định

**Response:**

```json
{
    "success": true,
    "message": "Đã reset cấu hình về mặc định"
}
```

---

## 🔄 Integration với Game Flow

### Quick Quiz Flow (Updated)

**Before:**

```java
// User không thể tùy chỉnh
POST /api/v1/games/quick-quiz/start
{
    "totalQuestions": 10,  // Fixed
    "timePerQuestion": 3   // Fixed
}
```

**After:**

```java
// Option 1: User sử dụng settings đã lưu
POST /api/v1/games/quick-quiz/start
{
    "useCustomSettings": true  // Dùng settings từ DB
}

// Option 2: Override tạm thời (không lưu)
POST /api/v1/games/quick-quiz/start
{
    "totalQuestions": 20,
    "timePerQuestion": 5
}

// Backend logic:
public QuickQuizSessionResponse startGame(User user, QuickQuizStartRequest request) {
    Integer totalQuestions;
    Integer timePerQuestion;

    if (request.getUseCustomSettings()) {
        UserGameSettings settings = settingsRepository
            .findByUserIdAndGameName(user.getId(), GameName.QUICK_QUIZ)
            .orElse(null);

        if (settings != null) {
            totalQuestions = settings.getQuickQuizTotalQuestions();
            timePerQuestion = settings.getQuickQuizTimePerQuestion();
        } else {
            // Use defaults
            totalQuestions = 10;
            timePerQuestion = 3;
        }
    } else {
        totalQuestions = request.getTotalQuestions() != null
            ? request.getTotalQuestions() : 10;
        timePerQuestion = request.getTimePerQuestion() != null
            ? request.getTimePerQuestion() : 3;
    }

    // Continue with game logic...
}
```

### Auto-record Streak

```java
// Trong QuickQuizService.finishGame()
@Transactional
public QuickQuizSessionResponse finishGame(User user, Long sessionId) {
    // ...existing game finish logic...

    // Record streak activity
    streakService.recordActivity(user);

    return response;
}

// Trong ImageWordMatchingService.submitMatch()
@Transactional
public ImageWordMatchingResultResponse submitMatch(...) {
    // ...existing logic...

    // Record streak activity khi hoàn thành game
    if (session.getFinishedAt() != null) {
        streakService.recordActivity(user);
    }

    return response;
}

// Trong LearnVocabService.submitReview()
@Transactional
public ReviewResultResponse submitReview(User user, ReviewVocabRequest request) {
    // ...existing logic...

    // Record streak activity
    streakService.recordActivity(user);

    return response;
}
```

---

## 📊 Response DTOs

### StreakResponse

```java
@Data
@Builder
public class StreakResponse {
    private Integer currentStreak;
    private Integer longestStreak;
    private LocalDate lastActivityDate;
    private Integer totalStudyDays;
    private String streakStatus; // ACTIVE, PENDING, BROKEN, NEW
    private Integer daysUntilBreak;
    private String message;
}
```

### StreakRecordResponse

```java
@Data
@Builder
public class StreakRecordResponse {
    private Integer currentStreak;
    private Integer longestStreak;
    private Boolean isNewRecord;
    private Boolean streakIncreased;
    private String message;
}
```

### GameSettingsResponse

```java
@Data
@Builder
public class GameSettingsResponse {
    private String gameName;
    private String displayName;
    private String displayNameVi;
    private Map<String, Object> settings;
    private Map<String, Object> defaults;
    private Map<String, Object> limits;
}
```

---

## 🎨 Frontend Integration Ideas

### 1. Streak Display

```
╔══════════════════════════════════╗
║   🔥 CHUỖI HỌC TẬP                ║
║                                  ║
║   Hiện tại: 7 ngày 🎯            ║
║   Kỷ lục: 15 ngày 🏆             ║
║   Tổng ngày học: 45 ngày 📚       ║
║                                  ║
║   Học hôm nay để duy trì streak! ║
╚══════════════════════════════════╝
```

### 2. Settings Page

```
╔══════════════════════════════════╗
║   ⚙️ CẤU HÌNH GAME                ║
║                                  ║
║   📝 Quick Quiz                  ║
║   • Số câu hỏi: [15] (5-50)     ║
║   • Thời gian/câu: [5]s (1-10)  ║
║                                  ║
║   🖼️ Image Word Matching         ║
║   • Số cặp: [8] (3-12)           ║
║                                  ║
║   [💾 Lưu cấu hình]              ║
║   [🔄 Reset về mặc định]         ║
╚══════════════════════════════════╝
```

---

## 🚀 Implementation Steps

### Phase 1: Database & Entity

1. ✅ Tạo migration cho `users` table (thêm streak columns)
2. ✅ Tạo migration cho `user_game_settings` table
3. ✅ Update `User` entity
4. ✅ Tạo `UserGameSettings` entity
5. ✅ Tạo `GameName` enum

### Phase 2: Repositories

1. ✅ Tạo `UserGameSettingsRepository`
2. ✅ Update `UserRepository` (nếu cần query methods)

### Phase 3: Services

1. ✅ Tạo `StreakService`
2. ✅ Tạo `GameSettingsService`
3. ✅ Update các game services (QuickQuiz, ImageWordMatching)

### Phase 4: Controllers & DTOs

1. ✅ Tạo `StreakController`
2. ✅ Tạo `GameSettingsController`
3. ✅ Tạo Request/Response DTOs

### Phase 5: Integration & Testing

1. ✅ Integrate streak recording vào game flows
2. ✅ Integrate custom settings vào game start
3. ✅ Test tất cả APIs
4. ✅ Update API documentation

---

## ⚠️ Edge Cases & Considerations

### Streak Logic

1. **Timezone issue:** Sử dụng server timezone hoặc lưu user timezone
2. **Multiple activities per day:** Chỉ tính 1 lần/ngày
3. **Streak freeze:** (Future) Cho phép user "freeze" streak khi đi du lịch
4. **Streak repair:** (Future) Cho phép dùng coin/diamond để sửa streak bị đứt

### Game Settings

1. **Default values:** Nếu user chưa set, dùng giá trị mặc định
2. **Validation:** Strict validation để tránh game bị exploit
3. **Migration:** User cũ sẽ dùng default settings
4. **Performance:** Cache settings trong session để tránh query nhiều

---

## 📈 Future Enhancements

1. **Streak Rewards:**

    - 7 ngày: +50 coins
    - 30 ngày: +200 coins + badge
    - 100 ngày: +1000 coins + special badge

2. **Social Features:**

    - Streak leaderboard
    - Share streak achievement
    - Compare with friends

3. **Analytics:**

    - Streak history chart
    - Best study days
    - Activity heatmap

4. **Smart Reminders:**
    - Notification khi sắp mất streak
    - Email nhắc nhở

---

## 🔗 Related Documentation

-   [GAME_ALGORITHMS_DESIGN.md](GAME_ALGORITHMS_DESIGN.md)
-   [QUICK_QUIZ_API_GUIDE.md](QUICK_QUIZ_API_GUIDE.md)
-   [IMAGE_WORD_MATCHING_GUIDE.md](IMAGE_WORD_MATCHING_GUIDE.md)

---

**Tác giả:** GitHub Copilot  
**Ngày cập nhật:** 31/10/2025
