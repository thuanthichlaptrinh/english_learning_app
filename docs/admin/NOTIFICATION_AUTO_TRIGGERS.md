# Auto Notification Triggers - Hướng Dẫn

## Tổng quan

Hệ thống tự động tạo thông báo cho người dùng dựa trên các sự kiện và thành tựu trong quá trình học.

## 1. Game Achievement Notifications

### 🎮 Quick Quiz

#### 🏆 High Score Achievement

**Trigger:** Khi user đạt điểm >= 80 trong Quick Quiz

**Tự động tạo bởi:** `QuickQuizService.finishGame()`

**Example:**

```
Title: "🏆 High Score Achievement!"
Content: "Congratulations! You scored 85 points in Quick Quiz. Keep up the excellent work!"
Type: achievement
```

#### 🎯 Perfect Score

**Trigger:** Khi user đạt 100% accuracy

**Example:**

```
Title: "🎯 Perfect Score!"
Content: "Amazing! You answered all 10 questions correctly with 100% accuracy!"
Type: achievement
```

#### 📈 Excellent Performance

**Trigger:** Khi user đạt accuracy >= 90%

**Example:**

```
Title: "📈 Excellent Performance!"
Content: "Great job! You achieved 95.0% accuracy with 9 out of 10 correct answers!"
Type: achievement
```

### 🧩 Word Definition Game

#### 🏆 High Score Achievement

**Trigger:** Khi user đạt điểm >= 80 trong Word Definition Game

**Tự động tạo bởi:** `WordDefinitionMatchingService.finishGame()`

**Example:**

```
Title: "🏆 High Score Achievement!"
Content: "Congratulations! You scored 85 points in Word Definition Game. Keep up the excellent work!"
Type: achievement
```

#### 🎯 Perfect Score

**Trigger:** Khi user đạt 100% accuracy

**Example:**

```
Title: "🎯 Perfect Score!"
Content: "Amazing! You answered all questions correctly with 100% accuracy!"
Type: game_achievement
```

#### 📈 Excellent Performance

**Trigger:** Khi user đạt accuracy >= 90%

**Example:**

```
Title: "📈 Excellent Performance!"
Content: "Great job! You achieved 95.0% accuracy!"
Type: game_achievement
```

---

## 2. Streak Milestone Notifications

### 🔥 7-Day Streak

**Trigger:** Khi user duy trì streak đúng 7 ngày

**Tự động tạo bởi:** `StreakService.recordActivity()`

**Example:**

```
Title: "🔥 7-Day Streak Milestone!"
Content: "Congratulations! You've maintained a 7-day learning streak. Keep up the momentum!"
Type: study_progress
```

### 🌟 30-Day Streak Champion

**Trigger:** Khi user đạt 30 ngày streak

**Example:**

```
Title: "🌟 30-Day Streak Champion!"
Content: "Amazing! You've achieved a 30-day learning streak! You're building great habits!"
Type: study_progress
```

### 👑 100-Day Streak Legend

**Trigger:** Khi user đạt 100 ngày streak

**Example:**

```
Title: "👑 100-Day Streak Legend!"
Content: "Incredible! You've reached a 100-day streak! You're a true learning champion!"
Type: achievement
```

### 🎉 New Personal Record

**Trigger:** Khi user phá kỷ lục streak cá nhân (longest streak > 7 days)

**Example:**

```
Title: "🎉 New Personal Record!"
Content: "You've set a new personal record with a 15-day streak! Keep pushing forward!"
Type: achievement
```

---

## 3. System Notifications

### 👋 Welcome Notification

**Trigger:** Khi user đăng ký tài khoản thành công

**Tự động tạo bởi:** `AuthenticationService.register()`

**Example:**

```
Title: "Welcome to Card Words!"
Content: "Welcome [username]! Start your learning journey today."
Type: system
```

---

## 4. Leaderboard Notifications

### 🥇 Top 1 Leaderboard

**Trigger:** Khi user vươn lên vị trí số 1 trên bảng xếp hạng

**Tự động tạo bởi:** `LeaderboardService.checkAndNotifyLeaderboardRank()`

**Example:**

```
Title: "🥇 Top 1 Leaderboard!"
Content: "Incredible! You are now #1 on the leaderboard! Keep it up!"
Type: achievement
```

### 🥈 Top 3 Leaderboard

**Trigger:** Khi user lọt vào Top 3

**Example:**

```
Title: "🥈 Top 3 Leaderboard!"
Content: "Great job! You've reached the Top 3 on the leaderboard!"
Type: achievement
```

### 🥉 Top 10 Leaderboard

**Trigger:** Khi user lọt vào Top 10

**Example:**

```
Title: "🥉 Top 10 Leaderboard!"
Content: "Congratulations! You've broken into the Top 10!"
Type: achievement
```

---

## 5. Study Goal Notifications

### 🎯 Daily Goal: 10 Words

**Trigger:** Khi user ôn tập đủ 10 từ trong ngày

**Tự động tạo bởi:** `LearnVocabService.checkDailyGoalMilestone()`

**Example:**

```
Title: "🎯 Daily Goal Reached!"
Content: "Great start! You've reviewed 10 words today. Keep going!"
Type: study_progress
```

### 🚀 Daily Goal: 20 Words

**Trigger:** Khi user ôn tập đủ 20 từ trong ngày

**Example:**

```
Title: "🚀 Momentum Building!"
Content: "You're on fire! 20 words reviewed today!"
Type: study_progress
```

### 🏆 Daily Goal: 50 Words

**Trigger:** Khi user ôn tập đủ 50 từ trong ngày

**Example:**

```
Title: "🏆 Vocabulary Master!"
Content: "Incredible dedication! You've reviewed 50 words today!"
Type: study_progress
```

---

## 6. Manual Admin Notifications

Admins có thể tạo thông báo thủ công qua API:

### Tạo cho 1 user cụ thể

```bash
POST /api/v1/admin/notifications
{
  "userId": "uuid-here",
  "title": "System Maintenance Notice",
  "content": "System will be under maintenance tonight from 2-4 AM.",
  "type": "system_alert"
}
```

### Broadcast cho tất cả users

```bash
POST /api/v1/admin/notifications/broadcast
{
  "title": "New Vocabulary Package Available",
  "content": "We've just added 500 new business English vocabulary words!",
  "type": "new_feature"
}
```

---

## 7. Notification Types

| Type             | Mục đích                | Auto/Manual |
| ---------------- | ----------------------- | ----------- |
| `vocab_reminder` | Nhắc nhở học từ vựng    | Manual      |
| `new_feature`    | Thông báo tính năng mới | Manual      |
| `achievement`    | Thành tựu đạt được      | **Auto**    |
| `system_alert`   | Cảnh báo hệ thống       | Manual      |
| `study_progress` | Tiến trình học tập      | **Auto**    |

---

## 8. Testing Workflow

### Test Auto Notifications

#### A. Test Game Achievements:

1. Chơi Quick Quiz với user `cardwordsgame@gmail.com`
2. Đạt điểm cao (>= 80) hoặc accuracy >= 90%
3. Check notifications:

```bash
GET /api/v1/notifications
Authorization: Bearer <token>
```

#### B. Test Streak Milestones:

1. Tạo user_vocab_progress records cho 7 ngày liên tiếp
2. Gọi API để trigger streak calculation
3. Check notifications cho milestone 7 ngày

### Test Manual Notifications

#### Admin Broadcast:

```bash
curl -X POST http://localhost:8080/api/v1/admin/notifications/broadcast \
  -H "Authorization: Bearer <admin-token>" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "🎊 Weekend Learning Challenge",
    "content": "Complete 5 games this weekend to earn bonus points!",
    "type": "new_feature"
  }'
```

---

## 9. Database Schema

```sql
notifications
├── id (BIGSERIAL, PK)
├── user_id (UUID, FK -> users.id)
├── title (VARCHAR(255))
├── content (TEXT)
├── type (VARCHAR(50))
├── is_read (BOOLEAN, default: false)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

---

## 10. Code Integration Points

### QuickQuizService

```java
private void finishGame(GameSession session, List<GameSessionDetail> details) {
    // ... game completion logic ...

    // 🔔 CREATE ACHIEVEMENT NOTIFICATIONS
    createGameAchievementNotifications(session, accuracy);
}
```

### StreakService

```java
public StreakRecordResponse recordActivity(User user) {
    // ... streak calculation ...

    // 🔔 Create streak milestone notifications
    createStreakNotifications(user, currentStreak, longestStreak, isNewRecord);
}
```

### AuthenticationService

```java
public AuthenticationResponse register(RegisterRequest request) {
    // ... registration logic ...

    // 🔔 Send welcome notification
    sendWelcomeNotification(user);
}
```

### LeaderboardService

```java
public void checkAndNotifyLeaderboardRank(User user, int oldRank, int newRank) {
    // ... rank check logic ...

    // 🔔 Send rank up notification
    notificationService.createNotification(
        user.getId(),
        title,
        content,
        NotificationType.ACHIEVEMENT
    );
}
```

### LearnVocabService

```java
public void checkDailyGoalMilestone(User user, int wordsReviewedToday) {
    // ... milestone check logic ...

    // 🔔 Send daily goal notification
    notificationService.createNotification(
        user.getId(),
        title,
        content,
        NotificationType.STUDY_PROGRESS
    );
}
```

### WordDefinitionMatchingService

```java
private void finishGame(GameSession session, int score, double accuracy) {
    // ... game completion logic ...

    // 🔔 Send game completion notification
    sendGameCompletionNotification(session, score, accuracy);
}
```

---

## 11. Future Enhancements

### Planned Auto Triggers:

-   ✅ Game high score achievements (Quick Quiz & Word Definition)
-   ✅ Streak milestones (7, 30, 100 days)
-   ✅ Vocabulary mastery (Daily Goals)
-   ✅ Welcome Notification
-   ✅ Leaderboard Rank Up
-   ⏳ Daily reminder at 9:00 AM (scheduled job)
-   ⏳ Inactive user reminder (7 days no activity)
-   ⏳ New vocabulary package released
-   ⏳ Friend challenges & competitions

### Scheduled Jobs (Coming Soon):

```java
@Scheduled(cron = "0 0 9 * * *") // Daily at 9 AM
public void sendDailyReminders() {
    // Send vocab_reminder to users who haven't studied today
}

@Scheduled(cron = "0 0 0 * * MON") // Monday at midnight
public void sendWeeklyProgressReport() {
    // Send study_progress with weekly stats
}
```

---

## 12. Best Practices

1. **Don't spam users**: Limit achievement notifications to significant milestones only
2. **Personalize content**: Include user-specific data (score, streak count, etc.)
3. **Use appropriate types**: Correctly categorize notifications for filtering
4. **Handle errors gracefully**: Log failures but don't break main workflow
5. **Test thoroughly**: Verify notifications appear in user's notification list

---

## 13. Monitoring

### Check notification counts:

```sql
-- Total notifications
SELECT COUNT(*) FROM notifications;

-- Unread notifications per user
SELECT user_id, COUNT(*) as unread_count
FROM notifications
WHERE is_read = false
GROUP BY user_id;

-- Notifications by type
SELECT type, COUNT(*) as count
FROM notifications
GROUP BY type
ORDER BY count DESC;
```

---

## Contact

For questions or issues, contact the development team.
