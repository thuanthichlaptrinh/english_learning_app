# 🔥 Streak Reminder Scheduler - Complete Analysis

## ✅ **TRẢ LỜI CÂU HỎI:**

### **1. "Code đang làm gì?"**

**`StreakReminderScheduler`** tự động gửi nhắc nhở streak hàng ngày cho users:

#### **Chức năng chính:**

-   ✅ **Chạy tự động** vào **9:00 AM mỗi ngày** (không cần call API)
-   ✅ Kiểm tra tất cả users trong hệ thống
-   ✅ Xác định users cần nhắc nhở (có điều kiện)
-   ✅ Gửi **2 loại nhắc nhở**:
    1. **In-app notification** (lưu database + push WebSocket)
    2. **Email** (gửi qua SMTP)

---

### **2. "Đã chạy hoàn chỉnh chưa?"**

**✅ CODE HOÀN CHỈNH VÀ SẴN SÀNG!**

**Đã có đầy đủ:**

-   ✅ `@EnableScheduling` trong `CardWordsApplication.java`
-   ✅ `@Scheduled(cron = "0 0 9 * * *")` annotation
-   ✅ Logic kiểm tra điều kiện nhắc nhở
-   ✅ Integration với `NotificationService`
-   ✅ Integration với `EmailService`
-   ✅ Error handling cho từng user
-   ✅ Logging chi tiết

**Sẽ tự động chạy:**

-   ⏰ **Lần đầu tiên:** Ngày mai lúc 9:00 AM
-   ⏰ **Sau đó:** Mỗi ngày lúc 9:00 AM

---

### **3. "Tự động gọi nhắc nhở hay phải call API?"**

**✅ TỰ ĐỘNG 100% - KHÔNG CẦN CALL API!**

#### **Flow hoạt động:**

```
9:00 AM mỗi ngày
    ↓
Spring Scheduler trigger @Scheduled
    ↓
StreakReminderScheduler.sendStreakReminders()
    ↓
Loop qua TẤT CẢ users
    ↓
Check điều kiện cho từng user:
  - Đã học hôm qua? ✅
  - Chưa học hôm nay? ✅
  - Streak >= 3 ngày? ✅
    ↓
Nếu đủ điều kiện:
  1. Tạo notification → NotificationService.createNotification()
  2. Gửi email → EmailService.sendStreakReminderEmail()
    ↓
Log kết quả: "✅ Sent X reminders"
```

**Không cần:**

-   ❌ Không cần call API
-   ❌ Không cần manual trigger
-   ❌ Không cần cron job bên ngoài

**Tự động:**

-   ✅ Spring Boot tự động chạy
-   ✅ Mỗi ngày lúc 9:00 AM
-   ✅ Gửi notification + email cho users đủ điều kiện

---

### **4. "Có áp dụng WebSocket không?"**

**✅ CÓ! WEBSOCKET ĐÃ ĐƯỢC ÁP DỤNG TỰ ĐỘNG!**

#### **Flow WebSocket trong Scheduler:**

```java
// StreakReminderScheduler.java - line 119
CreateNotificationRequest notificationRequest = CreateNotificationRequest.builder()
    .userId(user.getId())
    .title("🔥 Don't Break Your Streak!")
    .content(String.format(
        "You're on a %d-day streak! Practice today to keep your learning momentum going.",
        streak))
    .type("vocab_reminder")
    .build();

// Gọi NotificationService
notificationService.createNotification(notificationRequest);
```

#### **Trong NotificationService.createNotification():**

```java
// NotificationService.java
public NotificationResponse createNotification(CreateNotificationRequest request) {
    // 1. Save to database
    notification = notificationRepository.save(notification);
    NotificationResponse response = toResponse(notification);

    // 2. ✅ AUTO PUSH VIA WEBSOCKET
    messagingTemplate.convertAndSendToUser(
        request.getUserId().toString(),
        "/queue/notifications",
        response
    );

    log.info("✅ Sent real-time notification to user {} via WebSocket", request.getUserId());

    return response;
}
```

#### **Kết quả:**

Khi scheduler chạy vào 9:00 AM:

1. ✅ **Database:** Notification được lưu vào DB
2. ✅ **WebSocket:** Notification tự động push realtime tới user đang online
3. ✅ **Email:** Email được gửi song song

**User nhận:**

-   📱 **Ngay lập tức** (nếu đang online): Popup notification qua WebSocket
-   📧 **Trong vòng vài giây**: Email trong inbox
-   💾 **Luôn luôn**: Notification lưu trong database (xem sau nếu offline)

---

## 📊 **Chi Tiết Kỹ Thuật**

### **Điều Kiện Gửi Nhắc Nhở:**

```java
private boolean shouldSendReminder(User user, LocalDate today, LocalDate yesterday) {
    // 1. User phải có lịch sử học
    if (progressList.isEmpty()) return false;

    // 2. Đã học HÔM QUA
    boolean studiedYesterday = studyDates.contains(yesterday);

    // 3. CHƯA học HÔM NAY
    boolean studiedToday = studyDates.contains(today);

    // 4. Streak hiện tại >= 3 ngày (đáng để giữ)
    int currentStreak = user.getCurrentStreak();

    // Kết luận
    return studiedYesterday && !studiedToday && currentStreak >= 3;
}
```

**Ví dụ:**

-   ✅ **GỬI:** User có streak 7 ngày, học hôm qua, chưa học hôm nay → Nhắc nhở
-   ❌ **KHÔNG:** User streak 2 ngày → Không nhắc (streak quá thấp)
-   ❌ **KHÔNG:** User đã học hôm nay → Không cần nhắc
-   ❌ **KHÔNG:** User không học hôm qua → Streak đã break, không cần nhắc

---

### **Nội Dung Notification:**

```java
Title: "🔥 Don't Break Your Streak!"
Content: "You're on a 7-day streak! Practice today to keep your learning momentum going."
Type: "vocab_reminder"
```

**Email template:** (được gửi qua `EmailService.sendStreakReminderEmail()`)

-   Subject: "🔥 Don't Break Your Streak!"
-   Body: HTML email với thông tin streak và call-to-action

---

### **Error Handling:**

```java
// 1. Per-user error handling (không ảnh hưởng users khác)
for (User user : allUsers) {
    try {
        if (shouldSendReminder(user, today, yesterday)) {
            sendStreakReminderToUser(user);
            remindersSent++;
        }
    } catch (Exception e) {
        log.error("❌ Failed to send reminder to user {}", user.getId());
        // Continue với user tiếp theo
    }
}

// 2. Global error handling
try {
    // Toàn bộ job
} catch (Exception e) {
    log.error("❌ Streak reminder job failed: {}", e.getMessage(), e);
}
```

**Benefits:**

-   ✅ Nếu 1 user fail → Các user khác vẫn nhận được nhắc nhở
-   ✅ Nếu notification fail → Email vẫn được gửi (và ngược lại)
-   ✅ Logs chi tiết để debug

---

## 🧪 **Testing Scheduler**

### **Option 1: Đợi đến 9:00 AM ngày mai**

-   ⏰ Scheduler sẽ tự động chạy
-   📋 Check logs: `docker-compose logs -f card-words-api | grep -i streak`

---

### **Option 2: Test ngay lập tức (Temporary Change)**

**Thay đổi cron expression tạm thời:**

```java
// StreakReminderScheduler.java
// FROM:
@Scheduled(cron = "0 0 9 * * *") // 9:00 AM mỗi ngày

// TO (chạy mỗi 2 phút):
@Scheduled(cron = "0 */2 * * * *") // Mỗi 2 phút
```

**Rebuild và deploy:**

```bash
docker-compose build card-words-api
docker-compose up -d card-words-api

# Watch logs
docker-compose logs -f card-words-api | grep -i "streak\|reminder"
```

**Expected logs:**

```
2025-11-18 15:00:00 INFO  🔔 Starting streak reminder job...
2025-11-18 15:00:01 INFO  📱 Notification sent to user: user@example.com (streak: 7)
2025-11-18 15:00:01 INFO  ✅ Sent real-time notification to user xxx via WebSocket
2025-11-18 15:00:02 INFO  📧 Email sent to: user@example.com (streak: 7)
2025-11-18 15:00:03 INFO  ✅ Streak reminder job completed. Sent 5 reminders
```

---

### **Option 3: Test Manual Trigger (Create Admin Endpoint)**

**Thêm endpoint test (chỉ cho development):**

```java
@RestController
@RequestMapping("/api/v1/admin/scheduler")
@PreAuthorize("hasRole('ROLE_ADMIN')")
public class SchedulerTestController {

    private final StreakReminderScheduler streakReminderScheduler;

    @PostMapping("/trigger-streak-reminder")
    public ResponseEntity<String> triggerStreakReminder() {
        streakReminderScheduler.sendStreakReminders();
        return ResponseEntity.ok("Streak reminder job triggered manually");
    }
}
```

**Call API:**

```bash
curl -X POST http://localhost:8080/api/v1/admin/scheduler/trigger-streak-reminder \
  -H "Authorization: Bearer ADMIN_TOKEN"
```

---

## 📈 **Performance & Monitoring**

### **Logging:**

```java
// Start job
log.info("🔔 Starting streak reminder job...");

// Per user
log.info("📱 Notification sent to user: {} (streak: {})", email, streak);
log.info("📧 Email sent to: {} (streak: {})", email, streak);

// End job
log.info("✅ Streak reminder job completed. Sent {} reminders", remindersSent);
```

### **Metrics to Monitor:**

1. **Job execution time**
2. **Number of reminders sent**
3. **Success/failure rate**
4. **WebSocket delivery rate**
5. **Email delivery rate**

---

## 🎯 **Example Scenario**

### **Hôm nay: November 18, 2025**

**User A:**

-   Current Streak: 7 days
-   Last Study Date: November 17 (yesterday)
-   Today Study Date: None
-   **Result:** ✅ **NHẬN NHẮC NHỞ** (cả notification + email + WebSocket)

**User B:**

-   Current Streak: 2 days
-   Last Study Date: November 17 (yesterday)
-   Today Study Date: None
-   **Result:** ❌ **KHÔNG NHẬN** (streak < 3, chưa đủ cao để quan tâm)

**User C:**

-   Current Streak: 10 days
-   Last Study Date: November 18 (today - đã học)
-   **Result:** ❌ **KHÔNG NHẬN** (đã học rồi, không cần nhắc)

**User D:**

-   Current Streak: 5 days
-   Last Study Date: November 16 (2 days ago)
-   **Result:** ❌ **KHÔNG NHẬN** (streak đã break, không học hôm qua)

---

## ✅ **Summary**

### **1. Code đang làm gì?**

→ Tự động gửi nhắc nhở streak cho users vào 9:00 AM mỗi ngày

### **2. Đã chạy hoàn chỉnh chưa?**

→ ✅ HOÀN CHỈNH! Sẽ chạy lần đầu vào 9:00 AM ngày mai

### **3. Tự động hay phải call API?**

→ ✅ HOÀN TOÀN TỰ ĐỘNG! Không cần call API

### **4. Có áp dụng WebSocket không?**

→ ✅ CÓ! Notification tự động push qua WebSocket khi scheduler chạy

---

## 🚀 **Integration Flow**

```
9:00 AM - Spring Scheduler
    ↓
StreakReminderScheduler.sendStreakReminders()
    ↓
Check each user's streak & activity
    ↓
If eligible (streak >= 3, studied yesterday, not today):
    ↓
    ├─ NotificationService.createNotification()
    │     ├─ Save to Database ✅
    │     └─ Push WebSocket ✅ (tự động trong NotificationService)
    │           └─ /user/queue/notifications
    │
    └─ EmailService.sendStreakReminderEmail()
          └─ Send SMTP Email ✅
```

**Kết quả:**

-   💾 Notification lưu database
-   📱 Push realtime qua WebSocket (nếu user online)
-   📧 Email gửi vào inbox
-   📊 Logs chi tiết

**🎉 Hệ thống HOÀN TOÀN TỰ ĐỘNG với WebSocket!**
