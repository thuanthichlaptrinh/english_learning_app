# Card Words WebSocket Overview

## 1. Hạ tầng và bảo mật

-   Spring kích hoạt `@EnableWebSocketMessageBroker` với endpoint duy nhất `/ws` (có SockJS fallback, tạm thời mở `allowedOrigins="*"`).
-   Simple broker chạy in-memory, sử dụng prefix `/topic` cho broadcast và `/queue` cho tin nhắn cá nhân.
-   Mọi payload client gửi tới controller phải bắt đầu bằng `/app`. Các tin nhắn server gửi theo user đi qua `/user/queue/**`.
-   `AuthChannelInterceptor` đọc header `Authorization: Bearer <JWT>` trong frame `CONNECT`, xác thực bằng `JwtService`, sau đó gắn `UsernamePasswordAuthenticationToken` vào `StompHeaderAccessor`. Nhờ đó, tất cả handler có thể lấy `Principal` và giới hạn truy cập theo user.

## 2. Các luồng server push (NotificationService)

`NotificationService` dùng `SimpMessagingTemplate.convertAndSendToUser(userId, destination, payload)` để đẩy realtime khi REST API thành công:

-   `/user/queue/notifications`: gửi `NotificationResponse` mới.
-   `/user/queue/notifications/read`: gửi `notificationId` đã mark read.
-   `/user/queue/notifications/read-all`: gửi số lượng thông báo vừa đánh dấu đọc hết.
-   `/user/queue/notifications/deleted`: gửi ID vừa xóa.
-   `/user/queue/notifications/batch-deleted`: gửi danh sách ID bị xóa hàng loạt.
    Các sự kiện được kích hoạt bởi các REST endpoint như `markAsRead`, `markAllAsRead`, `deleteNotification`, `createNotification`, v.v.

## 3. Controller WebSocket chủ động (NotificationWebSocketController)

Client có thể gửi STOMP tới các đích `/app/...` sau để thao tác mà không cần REST:

| Đích client gửi                   | Payload                                                                   | Đích ACK                                                                | Ý nghĩa                           |
| --------------------------------- | ------------------------------------------------------------------------- | ----------------------------------------------------------------------- | --------------------------------- |
| `/app/notifications/push`         | `NotificationPushRequest` (`title`, `content`, `type`, tùy chọn `userId`) | `/user/queue/notifications/ack` (trả `NotificationResponse`)            | Tạo thông báo mới cho chính mình. |
| `/app/notifications/mark-read`    | `NotificationIdRequest` (`notificationId`)                                | `/user/queue/notifications/ack-read` (trả ID)                           | Đánh dấu một thông báo đã đọc.    |
| `/app/notifications/read-all`     | _không payload_                                                           | `/user/queue/notifications/ack-read-all` (trả số lượng)                 | Đánh dấu tất cả thông báo đã đọc. |
| `/app/notifications/delete`       | `NotificationIdRequest`                                                   | `/user/queue/notifications/ack-delete`                                  | Xóa một thông báo.                |
| `/app/notifications/delete-batch` | `NotificationBatchRequest` (danh sách ID)                                 | `/user/queue/notifications/ack-delete-batch`                            | Xóa nhiều thông báo một lúc.      |
| `/app/notifications/summary`      | _không payload_                                                           | `/user/queue/notifications/summary` (trả `NotificationSummaryResponse`) | Lấy tổng quan thông báo.          |

Controller luôn lấy `UUID` từ `Principal` (được set bởi interceptor). Nếu payload chứa `userId` khác user hiện tại, request sẽ bị từ chối để tránh gửi thông báo chéo trái phép.

## 4. Hướng dẫn tích hợp Flutter/STOMP

1. **Đăng nhập REST** để nhận JWT (access token).
2. **Khởi tạo STOMP client** (ví dụ `stomp_dart_client`) với config SockJS:
    ```dart
    final client = StompClient(
      config: StompConfig.sockJS(
        url: 'https://api.your-domain.com/ws',
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
        stompConnectHeaders: {'Authorization': 'Bearer $token'},
        heartbeatIncoming: const Duration(seconds: 10),
        heartbeatOutgoing: const Duration(seconds: 10),
        onConnect: (frame) {
          client.subscribe(destination: '/user/queue/notifications', callback: handleNewNotification);
          client.subscribe(destination: '/user/queue/notifications/read', callback: handleRead);
          client.subscribe(destination: '/user/queue/notifications/deleted', callback: handleDelete);
          client.subscribe(destination: '/user/queue/notifications/ack', callback: handleAck);
          // Đăng ký thêm các queue ack khác nếu cần
        },
      ),
    );
    client.activate();
    ```
3. **Gửi message** tới `/app/...` với JSON phù hợp. Ví dụ mark read:
    ```json
    { "notificationId": 123 }
    ```
    gửi tới `/app/notifications/mark-read`; server phản hồi tại `/user/queue/notifications/ack-read`.
4. **Nhận server push**: các sự kiện REST (do user khác hoặc admin kích hoạt) vẫn được đẩy về các queue `/user/queue/notifications*`, nên client chỉ cần cập nhật UI khi nhận được sự kiện thay vì poll.
5. **Khả năng tương thích WebSocket thuần**: hiện chỉ đăng ký endpoint SockJS (`/ws`). Client STOMP thuần phải trỏ tới `/ws/websocket`. Nếu muốn bỏ SockJS, cần đăng ký thêm endpoint native.

## 5. Việc nên làm thêm

-   Hợp nhất `WebSocketConfig` và `WebSocketSecurityConfig` để tránh cấu hình trùng lặp.
-   Giới hạn `setAllowedOriginPatterns` cho đúng domain production.
-   Cân nhắc thêm endpoint WebSocket thuần cho các client không hỗ trợ SockJS.
