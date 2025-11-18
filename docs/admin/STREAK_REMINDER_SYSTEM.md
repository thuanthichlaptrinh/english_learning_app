# Streak Reminder System - Documentation

## Tổng quan

Hệ thống tự động gửi nhắc nhở qua **email** và **in-app notification** cho users khi họ sắp đứt chuỗi học tập (streak).

## Cơ chế hoạt động

### 📅 Schedule

-   **Thời gian chạy**: Mỗi ngày lúc **9:00 AM**
-   **Cron expression**: `0 0 9 * * *`
-   **Scheduler class**: `StreakReminderScheduler`

### 🎯 Điều kiện gửi nhắc nhở

Hệ thống chỉ gửi nhắc nhở cho users thỏa mãn **TẤT CẢ** các điều kiện sau:

1. ✅ **Đã học hôm qua** - User có activity (game hoặc flashcard) hôm qua
2. ❌ **Chưa học hôm nay** - User chưa có activity hôm nay
3. 🔥 **Streak >= 3 ngày** - Streak đủ dài để đáng giữ

**Logic:**

```java
boolean shouldRemind =
    studiedYesterday && !studiedToday && currentStreak >= 3;
```

### 📱 Hai kênh thông báo

#### 1. In-App Notification

-   **Loại**: `vocab_reminder`
-   **Title**: "🔥 Don't Break Your Streak!"
-   **Content**: "You're on a {streak}-day streak! Practice today to keep your learning momentum going."
-   **Hiển thị**: Trong ứng dụng, notification bell icon

#### 2. Email Reminder

-   **Subject**: "🔥 Don't Break Your {streak}-Day Streak!"
-   **Template**: HTML đẹp với gradient, emoji, CTA button
-   **Nội dung**:
    -   Số ngày streak hiện tại (to, nổi bật)
    -   Lời nhắc nhở thân thiện
    -   Call-to-action: "Start Learning Now"
    -   Lợi ích của việc giữ streak
    -   Quick tips để học nhanh

## Implementation Details

### 1. StreakReminderScheduler

**File**: `core/scheduler/StreakReminderScheduler.java`

```java
@Component
@RequiredArgsConstructor
public class StreakReminderScheduler {

    @Scheduled(cron = "0 0 9 * * *")
    @Transactional(readOnly = true)
    public void sendStreakReminders() {
        // Lấy tất cả users
        // Kiểm tra điều kiện
        // Gửi email + notification
    }
}
```

**Dependencies:**

-   `UserRepository` - Query users
-   `UserVocabProgressRepository` - Check study history
-   `NotificationService` - Create in-app notifications
-   `EmailService` - Send emails

### 2. EmailService.sendStreakReminderEmail()

**File**: `core/usecase/user/EmailService.java`

```java
public void sendStreakReminderEmail(String toEmail, String name, int streak) {
    // Create HTML email with beautiful template
    // Send via JavaMailSender
}
```

**Email Template Features:**

-   🎨 Gradient backgrounds (purple, pink, orange)
-   🔥 Fire emoji và streak number nổi bật
-   📊 Streak box với số to, bold
-   ⚠️ Warning box màu vàng nhắc nhở
-   🚀 CTA button với gradient và shadow
-   ✨ Benefits section (4 lợi ích)
-   💡 Quick tips

### 3. Application Configuration

**File**: `CardWordsApplication.java`

```java
@SpringBootApplication
@EnableScheduling  // ← Enable scheduled tasks
public class CardWordsApplication {
    // ...
}
```

## Database Schema

### Tables Used

```sql
-- User streak data
users
├── current_streak (INT)
└── longest_streak (INT)

-- Study activity tracking
user_vocab_progress
└── created_at (TIMESTAMP)  -- Used to detect daily activity

-- Notifications
notifications
├── user_id (UUID)
├── title (VARCHAR)
├── content (TEXT)
├── type (VARCHAR) -- 'vocab_reminder'
└── created_at (TIMESTAMP)
```

## Testing

### Manual Test (Force run immediately)

Thay đổi cron expression tạm thời:

```java
// Chạy mỗi phút để test
@Scheduled(cron = "0 * * * * *")

// Hoặc fixed delay 10 giây
@Scheduled(fixedDelay = 10000, initialDelay = 5000)
```

### Test Scenarios

#### Scenario 1: Should send reminder ✅

```
User: john@example.com
Yesterday: Played 2 games ✓
Today: No activity ✗
Current Streak: 7 days ✓
Result: Email + Notification sent
```

#### Scenario 2: Should NOT send (already studied today) ❌

```
User: jane@example.com
Yesterday: Played game ✓
Today: Reviewed flashcards ✓
Current Streak: 5 days ✓
Result: No reminder (already active today)
```

#### Scenario 3: Should NOT send (streak too short) ❌

```
User: bob@example.com
Yesterday: Played game ✓
Today: No activity ✗
Current Streak: 2 days ✗
Result: No reminder (streak < 3)
```

#### Scenario 4: Should NOT send (missed yesterday) ❌

```
User: alice@example.com
Yesterday: No activity ✗
Today: No activity ✗
Current Streak: 0 days ✗
Result: No reminder (streak broken)
```

### Check Logs

```bash
# Docker logs
docker-compose logs card-words-api | grep "streak reminder"

# Expected output
🔔 Starting streak reminder job...
📱 Notification sent to user: john@example.com (streak: 7)
📧 Email sent to: john@example.com (streak: 7)
✅ Streak reminder job completed. Sent 3 reminders
```

### Verify Email Sent

Check email inbox của test users. Email template có:

-   Subject: "🔥 Don't Break Your 7-Day Streak!"
-   Beautiful HTML với gradient
-   Streak number hiển thị to, bold
-   CTA button "Start Learning Now"

### Verify Notification Created

```sql
-- Check notifications table
SELECT * FROM notifications
WHERE type = 'vocab_reminder'
  AND title LIKE '%Don''t Break%'
ORDER BY created_at DESC
LIMIT 10;
```

## Configuration

### Email SMTP Settings

File: `.env` or `application.yml`

```yaml
spring:
    mail:
        host: smtp.gmail.com
        port: 587
        username: ${MAIL_USERNAME}
        password: ${MAIL_PASSWORD} # App Password
        properties:
            mail:
                smtp:
                    auth: true
                    starttls:
                        enable: true
```

### Timezone Configuration

```yaml
spring:
    jackson:
        time-zone: Asia/Ho_Chi_Minh
```

Ensure server timezone khớp với user timezone để gửi đúng lúc 9:00 AM local time.

## Monitoring & Analytics

### Metrics to Track

```sql
-- Reminders sent per day
SELECT DATE(created_at) as date, COUNT(*) as reminders_sent
FROM notifications
WHERE type = 'vocab_reminder'
  AND title LIKE '%Don''t Break%'
GROUP BY DATE(created_at)
ORDER BY date DESC;

-- Success rate (users who returned after reminder)
SELECT
  n.user_id,
  n.created_at as reminder_sent,
  MIN(uvp.created_at) as next_activity
FROM notifications n
LEFT JOIN user_vocab_progress uvp
  ON n.user_id = uvp.user_id
  AND uvp.created_at > n.created_at
  AND DATE(uvp.created_at) = DATE(n.created_at)
WHERE n.type = 'vocab_reminder'
GROUP BY n.user_id, n.created_at;
```

### Scheduler Health Check

```bash
# Check if scheduler is running
curl http://localhost:8080/actuator/scheduledtasks

# Check thread pool
curl http://localhost:8080/actuator/metrics/executor.active
```

## Troubleshooting

### Issue 1: Scheduler not running

**Symptoms:** No logs, no emails/notifications sent

**Solution:**

1. Check `@EnableScheduling` in `CardWordsApplication`
2. Check scheduler bean is created: `@Component` annotation
3. Check cron expression syntax
4. Check application logs for errors

### Issue 2: Emails not sent

**Symptoms:** Notifications created, but no emails

**Solution:**

1. Check SMTP configuration in `.env`
2. Check Gmail App Password valid
3. Check firewall/network allows SMTP port 587
4. Check email logs: `grep "email" logs/application.log`

### Issue 3: Wrong users getting reminders

**Symptoms:** Users with streak < 3 getting reminders

**Solution:**

1. Check `user.getCurrentStreak()` data in database
2. Verify `shouldSendReminder()` logic
3. Check `user_vocab_progress` has correct `created_at`

### Issue 4: Duplicate reminders

**Symptoms:** Same user gets multiple reminders

**Solution:**

1. Check for duplicate scheduler beans
2. Add de-duplication logic with Redis cache
3. Check cron doesn't run multiple times

## Future Enhancements

### Planned Features

-   ⏰ **Customizable reminder time** per user (user settings)
-   🌍 **Multi-timezone support** (send at 9 AM user's local time)
-   📊 **A/B testing** different email templates
-   🎯 **Smart timing** (send when user usually active)
-   📱 **Push notifications** (mobile app integration)
-   💬 **SMS reminders** (for critical streaks >= 30 days)
-   🏆 **Bonus rewards** for maintaining streaks

### Optimization Ideas

-   Cache study dates in Redis for faster lookups
-   Batch email sending (send 100 emails at once)
-   Async processing with CompletableFuture
-   Retry failed emails with exponential backoff
-   Email open/click tracking

## Best Practices

1. **Don't spam users**: Only remind when streak >= 3 days
2. **Respect quiet hours**: 9 AM is reasonable, not too early
3. **Graceful error handling**: Log failures, don't crash scheduler
4. **Monitoring**: Track sent count, success rate
5. **A/B test**: Try different subject lines, content
6. **Personalization**: Use user name, specific streak number
7. **Mobile-friendly email**: Responsive HTML template

---

## Quick Reference

### Enable/Disable Scheduler

```java
// Disable temporarily by commenting out @Scheduled
// @Scheduled(cron = "0 0 9 * * *")
public void sendStreakReminders() { ... }
```

### Change Schedule Time

```java
// Chạy 8:30 AM
@Scheduled(cron = "0 30 8 * * *")

// Chạy 9 AM và 6 PM
@Scheduled(cron = "0 0 9,18 * * *")

// Chạy mỗi giờ từ 8 AM - 8 PM
@Scheduled(cron = "0 0 8-20 * * *")
```

### Cron Expression Format

```
┌───────────── second (0-59)
│ ┌───────────── minute (0-59)
│ │ ┌───────────── hour (0-23)
│ │ │ ┌───────────── day of month (1-31)
│ │ │ │ ┌───────────── month (1-12)
│ │ │ │ │ ┌───────────── day of week (0-7, 0 or 7 = Sunday)
│ │ │ │ │ │
* * * * * *
```

**Examples:**

-   `0 0 9 * * *` - 9:00 AM every day
-   `0 30 8 * * MON-FRI` - 8:30 AM weekdays only
-   `0 0 12 1 * *` - Noon on 1st of every month

---

**Contact:** For questions, contact the development team.
