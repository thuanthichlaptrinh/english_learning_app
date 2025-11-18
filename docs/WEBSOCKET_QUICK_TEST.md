# WebSocket Quick Test Guide

## 🚀 Sau khi deploy, test ngay:

### **1. Test WebSocket Connection (Browser Console)**

Mở browser console (F12) và chạy:

```javascript
// Load STOMP library (add to HTML first)
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

// Connect
const socket = new SockJS('http://localhost:8080/ws');
const stompClient = Stomp.over(socket);

stompClient.connect(
    {
        'Authorization': 'Bearer YOUR_JWT_TOKEN_HERE' // ← Thay JWT token của bạn
    },
    function(frame) {
        console.log('✅ Connected:', frame);

        // Subscribe
        stompClient.subscribe('/user/queue/notifications', function(message) {
            const notification = JSON.parse(message.body);
            console.log('📬 Received notification:', notification);
            alert(`New notification: ${notification.title}`);
        });

        console.log('✅ Subscribed to /user/queue/notifications');
    },
    function(error) {
        console.error('❌ Connection error:', error);
    }
);
```

---

### **2. Trigger Test Notification (Admin API)**

```bash
# Get Admin JWT token first
curl -X POST http://localhost:8080/api/v1/auth/signin \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@example.com",
    "password": "admin_password"
  }'

# Copy the token from response

# Send notification to yourself
curl -X POST http://localhost:8080/api/v1/admin/notifications \
  -H "Authorization: Bearer ADMIN_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "YOUR_USER_UUID",
    "title": "🎉 WebSocket Test",
    "content": "If you see this, WebSocket is working perfectly!",
    "type": "system_alert"
  }'
```

**Expected result:**

-   Browser console should log: `📬 Received notification: ...`
-   Alert popup should appear instantly!

---

### **3. Test Broadcast to All Users**

```bash
curl -X POST http://localhost:8080/api/v1/admin/notifications/broadcast \
  -H "Authorization: Bearer ADMIN_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "🚀 System Announcement",
    "content": "WebSocket real-time notifications are now live!",
    "type": "new_feature"
  }'
```

**Expected result:**

-   ALL connected users receive notification instantly!

---

### **4. Test Streak Reminder (Manual Trigger)**

Thay cron schedule tạm thời:

```java
// File: StreakReminderScheduler.java
// Change from:
@Scheduled(cron = "0 0 9 * * *")

// To (runs after 10 seconds):
@Scheduled(fixedDelay = 10000, initialDelay = 5000)
```

Rebuild và deploy:

```bash
docker-compose build card-words-api
docker-compose up -d
```

Check logs:

```bash
docker-compose logs -f card-words-api | grep -i "streak\|notification"
```

---

### **5. Monitor WebSocket Connections**

```bash
# Check logs for WebSocket events
docker-compose logs -f card-words-api | grep -i "websocket\|stomp"

# Should see:
# ✅ WebSocket authenticated for user: user@example.com
# ✅ Sent real-time notification to user: uuid-123
```

---

### **6. Test Reconnection**

```javascript
// In browser console:
// Disconnect
stompClient.disconnect();

// Reconnect after 2 seconds
setTimeout(() => {
    stompClient.connect(...);
}, 2000);
```

---

### **7. Test with Multiple Tabs**

1. Open 2 browser tabs
2. Login with same account
3. Connect WebSocket in both tabs
4. Send notification to that user
5. **Both tabs should receive instantly!**

---

## 📊 Success Checklist

-   [ ] WebSocket connection succeeds with JWT token
-   [ ] Can subscribe to `/user/queue/notifications`
-   [ ] Receives notification from admin API instantly (< 1s)
-   [ ] Broadcast notifications work
-   [ ] Multiple tabs receive same notification
-   [ ] Auto-reconnect works after disconnect
-   [ ] Logs show "Sent real-time notification"

---

## 🐛 If Not Working

### **Connection Failed:**

```bash
# Check if container is running
docker-compose ps

# Check WebSocket endpoint is accessible
curl -I http://localhost:8080/ws

# Check logs for errors
docker-compose logs card-words-api | grep -i error
```

### **Not Receiving Messages:**

```bash
# Verify JWT token is valid
# Check subscription destination is correct: /user/queue/notifications
# Check user UUID matches the one in notification request
```

### **Get detailed logs:**

```bash
# Enable debug logging (application.yml):
logging:
  level:
    org.springframework.messaging: DEBUG
    org.springframework.web.socket: DEBUG
```

---

## 🎉 Expected Timeline

1. **Build**: 2-3 minutes
2. **Deploy**: 10 seconds
3. **Connect**: < 1 second
4. **Receive notification**: < 100ms

**Total**: ~3-4 minutes from build to working WebSocket! 🚀
