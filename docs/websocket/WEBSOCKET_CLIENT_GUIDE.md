# WebSocket Real-time Notifications - Client Integration Guide

## 🚀 Overview

Hệ thống notification đã được nâng cấp lên **WebSocket real-time**. Notifications sẽ được push ngay lập tức đến client mà không cần polling.

---

## 📡 WebSocket Endpoint

```
ws://localhost:8080/ws
```

**Production:**

```
wss://your-domain.com/ws
```

---

## 🔐 Authentication

WebSocket sử dụng **JWT token** để authenticate. Token phải được gửi trong `Authorization` header khi connect.

---

## 📱 Client Implementation

### **1. JavaScript/TypeScript (Web)**

#### Install dependencies:

```bash
npm install sockjs-client stompjs
# hoặc
npm install @stomp/stompjs sockjs-client
```

#### Connect và Subscribe:

```javascript
import SockJS from 'sockjs-client';
import { Client } from '@stomp/stompjs';

class NotificationWebSocket {
    constructor() {
        this.client = null;
        this.jwtToken = localStorage.getItem('jwt_token'); // Lấy từ localStorage
    }

    connect() {
        // Create SockJS instance
        const socket = new SockJS('http://localhost:8080/ws');

        // Create STOMP client
        this.client = new Client({
            webSocketFactory: () => socket,

            connectHeaders: {
                Authorization: `Bearer ${this.jwtToken}`, // ← QUAN TRỌNG: JWT token
            },

            debug: (str) => {
                console.log('STOMP:', str);
            },

            reconnectDelay: 5000, // Auto reconnect sau 5s
            heartbeatIncoming: 4000,
            heartbeatOutgoing: 4000,

            onConnect: (frame) => {
                console.log('✅ WebSocket connected:', frame);

                // Subscribe to personal notification queue
                this.client.subscribe('/user/queue/notifications', (message) => {
                    const notification = JSON.parse(message.body);
                    this.handleNotification(notification);
                });
            },

            onStompError: (frame) => {
                console.error('❌ STOMP error:', frame);
            },

            onWebSocketClose: () => {
                console.warn('⚠️ WebSocket connection closed');
            },
        });

        // Activate connection
        this.client.activate();
    }

    handleNotification(notification) {
        console.log('📬 New notification:', notification);

        // Update UI
        this.showToast(notification);
        this.updateBadgeCount();
        this.playSound();

        // Add to notification list
        this.addToNotificationList(notification);
    }

    showToast(notification) {
        // Example using toast library
        toast.success(notification.title, {
            description: notification.content,
            duration: 5000,
        });
    }

    updateBadgeCount() {
        // Update unread count badge
        const badge = document.getElementById('notification-badge');
        const currentCount = parseInt(badge.textContent) || 0;
        badge.textContent = currentCount + 1;
        badge.style.display = 'block';
    }

    playSound() {
        const audio = new Audio('/notification-sound.mp3');
        audio.play().catch((err) => console.warn('Sound play failed:', err));
    }

    addToNotificationList(notification) {
        const list = document.getElementById('notification-list');
        const item = document.createElement('div');
        item.className = 'notification-item unread';
        item.innerHTML = `
            <h4>${notification.title}</h4>
            <p>${notification.content}</p>
            <small>${new Date(notification.createdAt).toLocaleString()}</small>
        `;
        list.prepend(item);
    }

    disconnect() {
        if (this.client) {
            this.client.deactivate();
            console.log('👋 WebSocket disconnected');
        }
    }
}

// Usage
const notificationWS = new NotificationWebSocket();
notificationWS.connect();

// Disconnect when user logs out
window.addEventListener('beforeunload', () => {
    notificationWS.disconnect();
});
```

---

### **2. React/Next.js**

```tsx
import { useEffect, useState, useRef } from 'react';
import { Client } from '@stomp/stompjs';
import SockJS from 'sockjs-client';

interface Notification {
    id: number;
    title: string;
    content: string;
    type: string;
    isRead: boolean;
    createdAt: string;
}

export function useNotificationWebSocket() {
    const [notifications, setNotifications] = useState<Notification[]>([]);
    const [unreadCount, setUnreadCount] = useState(0);
    const clientRef = useRef<Client | null>(null);

    useEffect(() => {
        const jwtToken = localStorage.getItem('jwt_token');
        if (!jwtToken) return;

        const socket = new SockJS('http://localhost:8080/ws');

        const client = new Client({
            webSocketFactory: () => socket,
            connectHeaders: {
                Authorization: `Bearer ${jwtToken}`,
            },

            onConnect: () => {
                console.log('✅ WebSocket connected');

                client.subscribe('/user/queue/notifications', (message) => {
                    const notification: Notification = JSON.parse(message.body);

                    // Add to notifications array
                    setNotifications((prev) => [notification, ...prev]);
                    setUnreadCount((prev) => prev + 1);

                    // Show toast
                    toast.success(notification.title, {
                        description: notification.content,
                    });
                });
            },

            onStompError: (frame) => {
                console.error('STOMP error:', frame);
            },
        });

        client.activate();
        clientRef.current = client;

        return () => {
            client.deactivate();
        };
    }, []);

    return { notifications, unreadCount };
}

// Component usage
export function NotificationBell() {
    const { notifications, unreadCount } = useNotificationWebSocket();

    return (
        <div className="relative">
            <BellIcon className="w-6 h-6" />
            {unreadCount > 0 && (
                <span className="absolute -top-1 -right-1 bg-red-500 text-white rounded-full w-5 h-5 text-xs flex items-center justify-center">
                    {unreadCount}
                </span>
            )}
        </div>
    );
}
```

---

### **3. React Native / Expo**

```bash
npm install stompjs sockjs-client
```

```javascript
import { useEffect, useState } from 'react';
import SockJS from 'sockjs-client';
import Stomp from 'stompjs';

export function useNotifications() {
    const [client, setClient] = useState(null);
    const [notifications, setNotifications] = useState([]);

    useEffect(() => {
        const jwtToken = await AsyncStorage.getItem('jwt_token');

        const socket = new SockJS('http://localhost:8080/ws');
        const stompClient = Stomp.over(socket);

        stompClient.connect(
            { 'Authorization': `Bearer ${jwtToken}` },
            (frame) => {
                console.log('Connected:', frame);

                stompClient.subscribe('/user/queue/notifications', (message) => {
                    const notification = JSON.parse(message.body);

                    setNotifications(prev => [notification, ...prev]);

                    // Show local notification
                    Notifications.scheduleNotificationAsync({
                        content: {
                            title: notification.title,
                            body: notification.content,
                            sound: true,
                        },
                        trigger: null,
                    });
                });
            },
            (error) => {
                console.error('Connection error:', error);
            }
        );

        setClient(stompClient);

        return () => {
            if (stompClient) {
                stompClient.disconnect();
            }
        };
    }, []);

    return { notifications };
}
```

---

### **4. Flutter/Dart**

```yaml
# pubspec.yaml
dependencies:
    stomp_dart_client: ^1.0.0
```

```dart
import 'package:stomp_dart_client/stomp_dart_client.dart';

class NotificationService {
  StompClient? stompClient;
  String jwtToken;

  NotificationService(this.jwtToken);

  void connect() {
    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://localhost:8080/ws',
        onConnect: onConnect,
        beforeConnect: () async {
          print('⏳ Connecting to WebSocket...');
        },
        onWebSocketError: (dynamic error) => print('❌ Error: $error'),
        stompConnectHeaders: {
          'Authorization': 'Bearer $jwtToken',
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $jwtToken',
        },
      ),
    );

    stompClient!.activate();
  }

  void onConnect(StompFrame frame) {
    print('✅ Connected to WebSocket');

    stompClient!.subscribe(
      destination: '/user/queue/notifications',
      callback: (frame) {
        final notification = jsonDecode(frame.body!);

        print('📬 New notification: ${notification['title']}');

        // Show local notification
        _showLocalNotification(notification);

        // Update UI
        notificationController.add(notification);
      },
    );
  }

  void _showLocalNotification(Map<String, dynamic> notification) {
    FlutterLocalNotificationsPlugin().show(
      0,
      notification['title'],
      notification['content'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          'notifications',
          'Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  void disconnect() {
    stompClient?.deactivate();
  }
}

// Usage
final notificationService = NotificationService(jwtToken);
notificationService.connect();
```

---

## 🧪 Testing WebSocket

### **1. Postman (WebSocket Request)**

1. New → WebSocket Request
2. URL: `ws://localhost:8080/ws`
3. Headers:
    ```
    Authorization: Bearer YOUR_JWT_TOKEN
    ```
4. Connect
5. Subscribe to `/user/queue/notifications`

### **2. Browser Console**

```javascript
// Open developer console on your website
const socket = new SockJS('http://localhost:8080/ws');
const client = Stomp.over(socket);

client.connect({ Authorization: 'Bearer YOUR_JWT_TOKEN' }, (frame) => {
    console.log('Connected:', frame);

    client.subscribe('/user/queue/notifications', (message) => {
        console.log('Received:', JSON.parse(message.body));
    });
});
```

### **3. Trigger Test Notification**

Gọi Admin API để tạo notification test:

```bash
curl -X POST http://localhost:8080/api/v1/admin/notifications \
  -H "Authorization: Bearer ADMIN_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "YOUR_USER_UUID",
    "title": "Test Notification",
    "content": "This is a test notification via WebSocket",
    "type": "system_alert"
  }'
```

Notification sẽ được push **ngay lập tức** qua WebSocket!

---

## 📊 Message Format

### **Received Notification:**

```json
{
    "id": 123,
    "title": "🔥 Don't Break Your Streak!",
    "content": "You're on a 7-day streak! Practice today to keep your learning momentum going.",
    "type": "vocab_reminder",
    "isRead": false,
    "createdAt": "2025-11-18T09:00:00.000Z"
}
```

### **Notification Types:**

-   `vocab_reminder` - Nhắc nhở học từ vựng
-   `new_feature` - Tính năng mới
-   `achievement` - Thành tích (high score, streak milestone)
-   `system_alert` - Thông báo hệ thống
-   `study_progress` - Tiến độ học tập

---

## 🔥 Best Practices

### **1. Handle Connection States**

```javascript
const states = {
    CONNECTING: 'connecting',
    CONNECTED: 'connected',
    DISCONNECTED: 'disconnected',
    ERROR: 'error',
};

let connectionState = states.DISCONNECTED;

client.onConnect = () => {
    connectionState = states.CONNECTED;
    showConnectionStatus('✅ Connected');
};

client.onWebSocketClose = () => {
    connectionState = states.DISCONNECTED;
    showConnectionStatus('⚠️ Disconnected');
};
```

### **2. Auto Reconnect**

```javascript
const client = new Client({
    reconnectDelay: 5000, // Retry after 5 seconds
    heartbeatIncoming: 4000,
    heartbeatOutgoing: 4000,
});
```

### **3. Token Refresh**

```javascript
// Khi token hết hạn, refresh và reconnect
async function refreshTokenAndReconnect() {
    const newToken = await refreshJWT();
    localStorage.setItem('jwt_token', newToken);

    client.deactivate();
    // Đợi 1 giây rồi reconnect
    setTimeout(() => {
        notificationWS.connect();
    }, 1000);
}
```

### **4. Offline Handling**

```javascript
window.addEventListener('online', () => {
    console.log('📡 Back online, reconnecting...');
    notificationWS.connect();
});

window.addEventListener('offline', () => {
    console.log('📴 Offline');
    notificationWS.disconnect();
});
```

---

## 🐛 Troubleshooting

### **Connection Failed**

-   ✅ Check JWT token validity
-   ✅ Verify WebSocket endpoint URL
-   ✅ Check CORS/firewall settings
-   ✅ Inspect browser console for errors

### **Not Receiving Messages**

-   ✅ Verify subscription destination: `/user/queue/notifications`
-   ✅ Check user ID in JWT token
-   ✅ Test with admin API to trigger notification
-   ✅ Check server logs for WebSocket events

### **Connection Drops**

-   ✅ Enable heartbeat (default: 4000ms)
-   ✅ Enable auto-reconnect
-   ✅ Check network stability
-   ✅ Verify server keep-alive settings

---

## 📚 API References

### **REST APIs (Still Available)**

Các REST APIs vẫn hoạt động bình thường:

```bash
# Get notifications (pagination)
GET /api/v1/notifications?page=0&size=10

# Get summary (unread count)
GET /api/v1/notifications/summary

# Mark as read
PUT /api/v1/notifications/{id}/read

# Mark all as read
PUT /api/v1/notifications/read-all

# Delete notification
DELETE /api/v1/notifications/{id}
```

---

## ✨ Benefits of WebSocket

| Feature     | Polling (Old)     | WebSocket (New)  |
| ----------- | ----------------- | ---------------- |
| Latency     | 5-30 seconds      | < 100ms ⚡       |
| Server Load | High (1000 req/s) | Low (0 req/s) 🎯 |
| Bandwidth   | ~600 KB/min       | ~10 KB/min 💾    |
| Battery     | High drain ⚡⚡⚡ | Low drain ⚡     |
| Real-time   | ❌ No             | ✅ Yes           |

---

**Tác giả**: Card Words Team  
**Ngày cập nhật**: 2025-11-18  
**Version**: 2.0 (WebSocket Only)
