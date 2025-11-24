# Flutter WebSocket Notification - Hướng dẫn Test

## 📦 Bước 1: Cài đặt dependencies

Thêm vào `pubspec.yaml`:

```yaml
dependencies:
    stomp_dart_client: ^2.0.0
    flutter_local_notifications: ^17.0.0 # Optional: cho local push notification
```

Chạy:

```bash
flutter pub get
```

## 🔧 Bước 2: Tạo NotificationService

Tạo file `lib/services/notification_service.dart`:

```dart
import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:flutter/foundation.dart';

class NotificationModel {
  final int id;
  final String title;
  final String content;
  final String type;
  final bool isRead;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      type: json['type'],
      isRead: json['isRead'],
      createdAt: json['createdAt'],
    );
  }
}

class NotificationService extends ChangeNotifier {
  StompClient? _stompClient;
  final List<NotificationModel> _notifications = [];
  int _unreadCount = 0;
  bool _isConnected = false;

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isConnected => _isConnected;

  // Kết nối WebSocket
  void connect(String jwtToken) {
    _stompClient = StompClient(
      config: StompConfig.sockJS(
        // ⚠️ Thay đổi URL theo môi trường của bạn
        url: 'http://localhost:8080/ws',  // Local
        // url: 'http://10.0.2.2:8080/ws',  // Android Emulator
        // url: 'https://api.cardwords.com/ws',  // Production

        stompConnectHeaders: {
          'Authorization': 'Bearer $jwtToken',
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $jwtToken',
        },

        onConnect: _onConnect,
        onWebSocketError: (dynamic error) {
          debugPrint('❌ WebSocket Error: $error');
          _isConnected = false;
          notifyListeners();
        },
        onStompError: (StompFrame frame) {
          debugPrint('❌ STOMP Error: ${frame.body}');
        },
        onDisconnect: (StompFrame frame) {
          debugPrint('👋 Disconnected');
          _isConnected = false;
          notifyListeners();
        },

        reconnectDelay: const Duration(seconds: 5),
        heartbeatIncoming: const Duration(seconds: 4),
        heartbeatOutgoing: const Duration(seconds: 4),
      ),
    );

    _stompClient!.activate();
    debugPrint('⏳ Connecting to WebSocket...');
  }

  void _onConnect(StompFrame frame) {
    debugPrint('✅ Connected to WebSocket');
    _isConnected = true;
    notifyListeners();

    // Subscribe to notifications
    _stompClient!.subscribe(
      destination: '/user/queue/notifications',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          _handleNewNotification(frame.body!);
        }
      },
    );

    // Subscribe to read events
    _stompClient!.subscribe(
      destination: '/user/queue/notifications/read',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          _handleReadNotification(frame.body!);
        }
      },
    );

    // Subscribe to read-all events
    _stompClient!.subscribe(
      destination: '/user/queue/notifications/read-all',
      callback: (StompFrame frame) {
        _handleReadAll();
      },
    );

    // Subscribe to delete events
    _stompClient!.subscribe(
      destination: '/user/queue/notifications/deleted',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          _handleDeletedNotification(frame.body!);
        }
      },
    );

    debugPrint('📡 Subscribed to all notification channels');
  }

  void _handleNewNotification(String payload) {
    try {
      final json = jsonDecode(payload);
      final notification = NotificationModel.fromJson(json);

      _notifications.insert(0, notification);
      if (!notification.isRead) {
        _unreadCount++;
      }

      debugPrint('📬 New notification: ${notification.title}');
      notifyListeners();
    } catch (e) {
      debugPrint('Error parsing notification: $e');
    }
  }

  void _handleReadNotification(String payload) {
    try {
      final json = jsonDecode(payload);
      final id = json['id'];

      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1 && !_notifications[index].isRead) {
        _unreadCount--;
        // Update notification to read (create new instance)
        final oldNotif = _notifications[index];
        _notifications[index] = NotificationModel(
          id: oldNotif.id,
          title: oldNotif.title,
          content: oldNotif.content,
          type: oldNotif.type,
          isRead: true,
          createdAt: oldNotif.createdAt,
        );
      }

      debugPrint('✅ Notification $id marked as read');
      notifyListeners();
    } catch (e) {
      debugPrint('Error handling read notification: $e');
    }
  }

  void _handleReadAll() {
    _unreadCount = 0;
    for (int i = 0; i < _notifications.length; i++) {
      final oldNotif = _notifications[i];
      _notifications[i] = NotificationModel(
        id: oldNotif.id,
        title: oldNotif.title,
        content: oldNotif.content,
        type: oldNotif.type,
        isRead: true,
        createdAt: oldNotif.createdAt,
      );
    }

    debugPrint('✅ All notifications marked as read');
    notifyListeners();
  }

  void _handleDeletedNotification(String payload) {
    try {
      final json = jsonDecode(payload);
      final id = json['id'];

      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        if (!_notifications[index].isRead) {
          _unreadCount--;
        }
        _notifications.removeAt(index);
      }

      debugPrint('🗑️ Notification $id deleted');
      notifyListeners();
    } catch (e) {
      debugPrint('Error handling deleted notification: $e');
    }
  }

  void disconnect() {
    _stompClient?.deactivate();
    _isConnected = false;
    notifyListeners();
    debugPrint('👋 WebSocket disconnected');
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
```

## 🎨 Bước 3: Tạo UI Test Screen

Tạo file `lib/screens/notification_test_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/notification_service.dart';

class NotificationTestScreen extends StatefulWidget {
  final String jwtToken;

  const NotificationTestScreen({Key? key, required this.jwtToken}) : super(key: key);

  @override
  State<NotificationTestScreen> createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  late NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService();
    _notificationService.connect(widget.jwtToken);
  }

  @override
  void dispose() {
    _notificationService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _notificationService,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('WebSocket Notifications Test'),
          actions: [
            Consumer<NotificationService>(
              builder: (context, service, child) {
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {},
                    ),
                    if (service.unreadCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Text(
                            '${service.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Connection Status
            Consumer<NotificationService>(
              builder: (context, service, child) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: service.isConnected ? Colors.green : Colors.red,
                  child: Row(
                    children: [
                      Icon(
                        service.isConnected ? Icons.check_circle : Icons.error,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        service.isConnected ? 'Connected' : 'Disconnected',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Instructions
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📝 Cách test:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text('1. Đảm bảo WebSocket đã Connected (màu xanh)'),
                  const Text('2. Gọi API tạo notification từ Postman:'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey.shade200,
                    child: const SelectableText(
                      'POST http://localhost:8080/api/v1/admin/notifications\n'
                      'Headers: Authorization: Bearer <JWT>\n'
                      'Body: {\n'
                      '  "title": "Test Notification",\n'
                      '  "content": "This is a test",\n'
                      '  "type": "system"\n'
                      '}',
                      style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('3. Notification sẽ hiện ngay lập tức ở danh sách bên dưới'),
                ],
              ),
            ),

            // Notifications List
            Expanded(
              child: Consumer<NotificationService>(
                builder: (context, service, child) {
                  if (service.notifications.isEmpty) {
                    return const Center(
                      child: Text('Chưa có notifications.\nGọi API để test!'),
                    );
                  }

                  return ListView.builder(
                    itemCount: service.notifications.length,
                    itemBuilder: (context, index) {
                      final notif = service.notifications[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: notif.isRead ? Colors.white : Colors.blue.shade50,
                        child: ListTile(
                          leading: Icon(
                            _getIconForType(notif.type),
                            color: notif.isRead ? Colors.grey : Colors.blue,
                          ),
                          title: Text(
                            notif.title,
                            style: TextStyle(
                              fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(notif.content),
                              const SizedBox(height: 4),
                              Text(
                                _formatTime(notif.createdAt),
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                          trailing: !notif.isRead
                              ? const Icon(Icons.circle, color: Colors.blue, size: 12)
                              : null,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'streak_milestone':
        return Icons.local_fire_department;
      case 'game_result':
        return Icons.games;
      case 'reminder':
        return Icons.alarm;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  String _formatTime(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inSeconds < 60) {
        return 'Vừa xong';
      } else if (diff.inMinutes < 60) {
        return '${diff.inMinutes} phút trước';
      } else if (diff.inHours < 24) {
        return '${diff.inHours} giờ trước';
      } else {
        return '${diff.inDays} ngày trước';
      }
    } catch (e) {
      return timestamp;
    }
  }
}
```

## 🚀 Bước 4: Sử dụng trong App

Trong `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'screens/notification_test_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _tokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: 'Paste JWT Token',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_tokenController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationTestScreen(
                        jwtToken: _tokenController.text,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Connect to WebSocket'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🧪 Bước 5: Test Workflow

### 1. Lấy JWT Token

Gọi API login từ Postman:

```bash
POST http://localhost:8080/api/v1/auth/signin
Content-Type: application/json

{
  "email": "your-email@example.com",
  "password": "your-password"
}
```

Copy `accessToken` từ response.

### 2. Chạy Flutter App

```bash
flutter run
```

Paste JWT token vào TextField và nhấn "Connect to WebSocket".

### 3. Tạo Test Notification

Từ Postman, gọi API:

```bash
POST http://localhost:8080/api/v1/admin/notifications
Authorization: Bearer <YOUR_JWT_TOKEN>
Content-Type: application/json

{
  "title": "🎉 Test Notification",
  "content": "This is a real-time test from Postman",
  "type": "system"
}
```

**Kết quả:** Notification sẽ xuất hiện ngay lập tức trong Flutter app!

### 4. Test các sự kiện khác

**Mark as Read:**

```bash
PUT http://localhost:8080/api/v1/notifications/{id}/read
Authorization: Bearer <YOUR_JWT_TOKEN>
```

**Delete Notification:**

```bash
DELETE http://localhost:8080/api/v1/notifications/{id}
Authorization: Bearer <YOUR_JWT_TOKEN>
```

**Mark All Read:**

```bash
PUT http://localhost:8080/api/v1/notifications/read-all
Authorization: Bearer <YOUR_JWT_TOKEN>
```

Tất cả thay đổi sẽ tự động sync real-time!

## 🔧 Troubleshooting

### ❌ Không kết nối được

**Android Emulator:**

-   Đổi URL từ `localhost` → `10.0.2.2`

**iOS Simulator:**

-   URL giữ nguyên `localhost` hoặc dùng IP máy: `http://192.168.1.x:8080/ws`

### ❌ STOMP Error: Unauthorized

-   Kiểm tra JWT token còn hạn không
-   Verify header `Authorization: Bearer <token>` đúng format

### ❌ Connection timeout

-   Kiểm tra Spring Boot server đang chạy: `docker-compose ps`
-   Verify WebSocket endpoint: `http://localhost:8080/ws`
-   Check firewall/antivirus

## 📚 Tham khảo thêm

-   [WEBSOCKET_CLIENT_GUIDE.md](./WEBSOCKET_CLIENT_GUIDE.md) - Hướng dẫn đầy đủ
-   [WEBSOCKET_EVENTS.md](./WEBSOCKET_EVENTS.md) - Danh sách events
-   [NOTIFICATION_API_COMPLETE.md](./NOTIFICATION_API_COMPLETE.md) - REST API docs

---

**Happy Testing! 🚀**
