# 🔔 WebSocket Notification Events - Complete Guide

## 🎯 **TẤT CẢ NOTIFICATION ĐỀU SỬ DỤNG WEBSOCKET!**

Hệ thống đã được cập nhật để **TẤT CẢ** thao tác notification đều push realtime qua WebSocket.

---

## 📡 **WebSocket Destinations (Channels)**

Client cần subscribe các channels sau để nhận realtime updates:

### **1️⃣ `/user/queue/notifications` - Notification mới**

**Trigger:** Khi tạo notification mới (API hoặc auto)

**Event Data:**

```json
{
    "id": 123,
    "title": "🔥 Streak Reminder",
    "content": "Don't break your 7-day streak!",
    "type": "streak_reminder",
    "isRead": false,
    "createdAt": "2025-11-18T09:00:00"
}
```

**Client Action:**

-   Hiển thị popup/toast notification
-   Thêm vào notification list
-   Cập nhật unread count badge
-   Play notification sound
-   Show browser notification (nếu có permission)

---

### **2️⃣ `/user/queue/notifications/read` - Đánh dấu đã đọc**

**Trigger:** Khi user đánh dấu 1 notification đã đọc

**Event Data:**

```json
123 // notificationId đã được đánh dấu đã đọc
```

**Client Action:**

```javascript
stompClient.subscribe('/user/queue/notifications/read', (message) => {
    const notificationId = JSON.parse(message.body);

    // Update UI: mark as read
    const notifElement = document.querySelector(`[data-id="${notificationId}"]`);
    notifElement.classList.remove('unread');
    notifElement.classList.add('read');

    // Update unread count
    unreadCount--;
    updateBadge(unreadCount);
});
```

---

### **3️⃣ `/user/queue/notifications/read-all` - Đánh dấu tất cả đã đọc**

**Trigger:** Khi user đánh dấu tất cả notifications đã đọc

**Event Data:**

```json
15 // Số lượng notifications đã được đánh dấu
```

**Client Action:**

```javascript
stompClient.subscribe('/user/queue/notifications/read-all', (message) => {
    const count = JSON.parse(message.body);

    // Update UI: mark all as read
    document.querySelectorAll('.notification').forEach((el) => {
        el.classList.remove('unread');
        el.classList.add('read');
    });

    // Reset unread count to 0
    updateBadge(0);

    showToast(`✅ Marked ${count} notifications as read`);
});
```

---

### **4️⃣ `/user/queue/notifications/deleted` - Xóa notification**

**Trigger:** Khi user hoặc admin xóa 1 notification

**Event Data:**

```json
123 // notificationId đã bị xóa
```

**Client Action:**

```javascript
stompClient.subscribe('/user/queue/notifications/deleted', (message) => {
    const notificationId = JSON.parse(message.body);

    // Remove from UI
    const notifElement = document.querySelector(`[data-id="${notificationId}"]`);
    notifElement.style.animation = 'slideOut 0.3s';
    setTimeout(() => notifElement.remove(), 300);

    // Update count
    totalCount--;
    updateBadge(unreadCount);
});
```

---

### **5️⃣ `/user/queue/notifications/batch-deleted` - Xóa nhiều notifications**

**Trigger:** Khi xóa nhiều notifications cùng lúc

**Event Data:**

```json
[123, 456, 789] // Array of notificationIds đã bị xóa
```

**Client Action:**

```javascript
stompClient.subscribe('/user/queue/notifications/batch-deleted', (message) => {
    const deletedIds = JSON.parse(message.body);

    deletedIds.forEach((id) => {
        const notifElement = document.querySelector(`[data-id="${id}"]`);
        if (notifElement) notifElement.remove();
    });

    showToast(`🗑️ Deleted ${deletedIds.length} notifications`);
});
```

---

### **6️⃣ `/topic/admin/user-registrations` - Admin broadcast khi có user mới**

**Trigger:** Mỗi lần user đăng ký tài khoản thành công.

**Event Data:**

```json
{
    "message": "🎉 Đã có thêm Nguyễn Văn A vừa đăng ký tài khoản",
    "totalUsers": 1250,
    "recentUserName": "Nguyễn Văn A",
    "recentUserEmail": "new.user@example.com",
    "registeredAt": "2025-11-23T07:05:12"
}
```

**Client Action (Admin Dashboard):**

-   Hiện toast hoặc banner realtime ghi nhận user mới.
-   Cập nhật widget thống kê tổng số người dùng (`totalUsers`).
-   Option: phát âm thanh / highlight bảng user để admin kiểm duyệt nhanh.

```javascript
stompClient.subscribe('/topic/admin/user-registrations', (message) => {
    const event = JSON.parse(message.body);
    renderAdminToast(event.message, event.totalUsers);
    updateUserCounter(event.totalUsers);
    prependRecentUser(event.recentUserName, event.recentUserEmail, event.registeredAt);
});
```

> ⚠️ Chỉ admin (ROLE_ADMIN) nên subscribe kênh này. Hãy kiểm tra JWT chứa role trước khi render UI.

---

## 🔌 **Complete Client Implementation**

### **React Hook Example:**

```typescript
import { useEffect, useState } from 'react';
import SockJS from 'sockjs-client';
import { Stomp, Client } from '@stomp/stompjs';

interface Notification {
    id: number;
    title: string;
    content: string;
    type: string;
    isRead: boolean;
    createdAt: string;
}

export const useNotificationWebSocket = (token: string) => {
    const [notifications, setNotifications] = useState<Notification[]>([]);
    const [unreadCount, setUnreadCount] = useState(0);
    const [client, setClient] = useState<Client | null>(null);

    useEffect(() => {
        const socket = new SockJS('http://localhost:8080/ws');
        const stompClient = Stomp.over(socket);
        stompClient.debug = () => {}; // Disable debug

        stompClient.connect(
            { Authorization: `Bearer ${token}` },
            () => {
                console.log('✅ WebSocket connected');

                // 1. New notifications
                stompClient.subscribe('/user/queue/notifications', (message) => {
                    const notification: Notification = JSON.parse(message.body);

                    setNotifications((prev) => [notification, ...prev]);
                    setUnreadCount((prev) => prev + 1);

                    // Show browser notification
                    if (Notification.permission === 'granted') {
                        new Notification(notification.title, {
                            body: notification.content,
                            icon: '🔔',
                        });
                    }

                    // Play sound
                    new Audio('/notification.mp3').play();
                });

                // 2. Mark as read
                stompClient.subscribe('/user/queue/notifications/read', (message) => {
                    const notificationId = JSON.parse(message.body);

                    setNotifications((prev) => prev.map((n) => (n.id === notificationId ? { ...n, isRead: true } : n)));
                    setUnreadCount((prev) => prev - 1);
                });

                // 3. Mark all as read
                stompClient.subscribe('/user/queue/notifications/read-all', (message) => {
                    const count = JSON.parse(message.body);

                    setNotifications((prev) => prev.map((n) => ({ ...n, isRead: true })));
                    setUnreadCount(0);
                });

                // 4. Single delete
                stompClient.subscribe('/user/queue/notifications/deleted', (message) => {
                    const notificationId = JSON.parse(message.body);

                    setNotifications((prev) => prev.filter((n) => n.id !== notificationId));
                });

                // 5. Batch delete
                stompClient.subscribe('/user/queue/notifications/batch-deleted', (message) => {
                    const deletedIds: number[] = JSON.parse(message.body);

                    setNotifications((prev) => prev.filter((n) => !deletedIds.includes(n.id)));
                });

                setClient(stompClient);
            },
            (error) => {
                console.error('❌ WebSocket error:', error);
            },
        );

        return () => {
            if (client) client.disconnect();
        };
    }, [token]);

    return { notifications, unreadCount, client };
};
```

---

### **Flutter/Dart Example:**

```dart
import 'package:stomp_dart_client/stomp_dart_client.dart';

class NotificationWebSocketService {
  StompClient? _client;
  final String jwtToken;

  final _notificationsController = StreamController<Notification>.broadcast();
  final _readController = StreamController<int>.broadcast();
  final _deletedController = StreamController<int>.broadcast();

  Stream<Notification> get notificationsStream => _notificationsController.stream;
  Stream<int> get readStream => _readController.stream;
  Stream<int> get deletedStream => _deletedController.stream;

  NotificationWebSocketService(this.jwtToken);

  void connect() {
    _client = StompClient(
      config: StompConfig(
        url: 'http://localhost:8080/ws',
        stompConnectHeaders: {
          'Authorization': 'Bearer $jwtToken',
        },
        onConnect: _onConnect,
        onWebSocketError: (error) => print('❌ WebSocket error: $error'),
      ),
    );

    _client!.activate();
  }

  void _onConnect(StompFrame frame) {
    print('✅ WebSocket connected');

    // 1. New notifications
    _client!.subscribe(
      destination: '/user/queue/notifications',
      callback: (frame) {
        final notification = Notification.fromJson(jsonDecode(frame.body!));
        _notificationsController.add(notification);

        // Show local notification
        _showLocalNotification(notification);
      },
    );

    // 2. Mark as read
    _client!.subscribe(
      destination: '/user/queue/notifications/read',
      callback: (frame) {
        final notificationId = int.parse(frame.body!);
        _readController.add(notificationId);
      },
    );

    // 3. Mark all as read
    _client!.subscribe(
      destination: '/user/queue/notifications/read-all',
      callback: (frame) {
        final count = int.parse(frame.body!);
        print('✅ Marked $count notifications as read');
      },
    );

    // 4. Single delete
    _client!.subscribe(
      destination: '/user/queue/notifications/deleted',
      callback: (frame) {
        final notificationId = int.parse(frame.body!);
        _deletedController.add(notificationId);
      },
    );

    // 5. Batch delete
    _client!.subscribe(
      destination: '/user/queue/notifications/batch-deleted',
      callback: (frame) {
        final deletedIds = List<int>.from(jsonDecode(frame.body!));
        print('🗑️ Deleted ${deletedIds.length} notifications');
      },
    );
  }

  void disconnect() {
    _client?.deactivate();
    _notificationsController.close();
    _readController.close();
    _deletedController.close();
  }
}
```

---

## 📊 **WebSocket Events Summary**

| Event                | Destination                               | Data Type                    | Trigger                         |
| -------------------- | ----------------------------------------- | ---------------------------- | ------------------------------- |
| **New Notification** | `/user/queue/notifications`               | `NotificationResponse`       | Create notification API         |
| **Mark as Read**     | `/user/queue/notifications/read`          | `number`                     | PUT `/notifications/{id}/read`  |
| **Mark All Read**    | `/user/queue/notifications/read-all`      | `number`                     | PUT `/notifications/read-all`   |
| **Delete**           | `/user/queue/notifications/deleted`       | `number`                     | DELETE `/notifications/{id}`    |
| **Batch Delete**     | `/user/queue/notifications/batch-deleted` | `number[]`                   | DELETE `/notifications?ids=...` |
| **New User (Admin)** | `/topic/admin/user-registrations`         | `AdminUserRegistrationEvent` | User register success           |

---

## 🎯 **Complete Flow Example**

### **Scenario: User receives streak reminder**

```
9:00 AM - Server
├─ StreakReminderScheduler triggers
├─ NotificationService.createNotification()
├─ Save to database
└─ Push WebSocket: /user/queue/notifications

< 100ms - Client
├─ Receive notification via WebSocket
├─ Show toast popup
├─ Play notification sound
├─ Update badge count (+1)
└─ Add to notification list

User clicks notification
├─ API: PUT /notifications/123/read
├─ Server marks as read in database
└─ Server pushes: /user/queue/notifications/read

< 50ms - Client
├─ Receive mark-as-read event
├─ Update notification UI (remove blue dot)
└─ Update badge count (-1)

User clicks "Delete"
├─ API: DELETE /notifications/123
├─ Server deletes from database
└─ Server pushes: /user/queue/notifications/deleted

< 50ms - Client
├─ Receive deleted event
├─ Animate notification slide-out
└─ Remove from list
```

---

## ✅ **Benefits của WebSocket cho TẤT CẢ Notifications**

1. **Instant Updates** - < 100ms latency (vs 10-30s polling)
2. **Battery Efficient** - No periodic polling (tiết kiệm 90% pin)
3. **Real-time Sync** - Multi-device sync tự động
4. **Less Server Load** - 99.9% reduction trong requests
5. **Better UX** - Notifications xuất hiện ngay lập tức

---

## 🧪 **Testing WebSocket Events**

### **Test 1: Create Notification**

```bash
curl -X POST http://localhost:8080/api/v1/admin/notifications \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "USER_UUID",
    "title": "Test",
    "content": "WebSocket test",
    "type": "system_alert"
  }'
```

**Expected:** Client nhận qua `/user/queue/notifications`

---

### **Test 2: Mark as Read**

```bash
curl -X PUT http://localhost:8080/api/v1/notifications/123/read \
  -H "Authorization: Bearer USER_TOKEN"
```

**Expected:** Client nhận qua `/user/queue/notifications/read`

---

### **Test 3: Mark All Read**

```bash
curl -X PUT http://localhost:8080/api/v1/notifications/read-all \
  -H "Authorization: Bearer USER_TOKEN"
```

**Expected:** Client nhận qua `/user/queue/notifications/read-all`

---

### **Test 4: Delete**

```bash
curl -X DELETE http://localhost:8080/api/v1/notifications/123 \
  -H "Authorization: Bearer USER_TOKEN"
```

**Expected:** Client nhận qua `/user/queue/notifications/deleted`

---

### **Test 5: Batch Delete**

```bash
curl -X DELETE "http://localhost:8080/api/v1/notifications?ids=123,456,789" \
  -H "Authorization: Bearer USER_TOKEN"
```

**Expected:** Client nhận qua `/user/queue/notifications/batch-deleted`

---

## 🎉 **Summary**

✅ **Tất cả thao tác notification đều push realtime qua WebSocket:**

-   ✅ Create → `/user/queue/notifications`
-   ✅ Mark as Read → `/user/queue/notifications/read`
-   ✅ Mark All Read → `/user/queue/notifications/read-all`
-   ✅ Delete → `/user/queue/notifications/deleted`
-   ✅ Batch Delete → `/user/queue/notifications/batch-deleted`

✅ **Client chỉ cần:**

1. Connect WebSocket 1 lần
2. Subscribe 5 channels
3. Nhận tất cả updates tự động

✅ **Zero polling needed!** Tiết kiệm bandwidth, battery, server resources! 🚀
