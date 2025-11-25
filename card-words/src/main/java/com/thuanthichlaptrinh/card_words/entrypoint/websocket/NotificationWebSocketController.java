package com.thuanthichlaptrinh.card_words.entrypoint.websocket;

import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.usecase.user.NotificationService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.NotificationBatchRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.NotificationIdRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.NotificationPushRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.NotificationResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.NotificationSummaryResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.validation.annotation.Validated;

import java.security.Principal;
import java.util.List;
import java.util.UUID;

/**
 * Controller WebSocket cho phép user đẩy thông báo realtime thông qua STOMP.
 */
@Slf4j
@Controller
@Validated
@RequiredArgsConstructor
public class NotificationWebSocketController {

    private final NotificationService notificationService;

    /**
     * Client gửi message tới đích "/app/notifications/push" để tạo thông báo mới.
     * Phản hồi sẽ được trả lại vào "/user/queue/notifications/ack" để client xác nhận thành công.
     */
    @MessageMapping("/notifications/push")
    @SendToUser("/queue/notifications/ack")
    public NotificationResponse pushNotification(@Valid NotificationPushRequest payload, Principal principal) {
        UUID currentUserId = resolveUserId(principal);
        UUID targetUserId = payload.getUserId() != null ? payload.getUserId() : currentUserId;

        // Không cho phép user gửi thông báo cho người khác khi chưa có quyền rõ ràng
        if (!currentUserId.equals(targetUserId)) {
            log.warn("User {} cố gắng gửi notification tới user {}", currentUserId, targetUserId);
            throw new AccessDeniedException("Bạn chỉ có thể tự gửi thông báo cho chính mình");
        }

        CreateNotificationRequest request = CreateNotificationRequest.builder()
                .userId(targetUserId)
                .title(payload.getTitle())
                .content(payload.getContent())
                .type(payload.getType())
                .build();

        return notificationService.createNotification(request);
    }

    /**
     * Đánh dấu 1 thông báo là đã đọc thông qua WebSocket.
     */
    @MessageMapping("/notifications/mark-read")
    @SendToUser("/queue/notifications/ack-read")
    public Long markNotificationAsRead(@Valid NotificationIdRequest payload, Principal principal) {
        UUID userId = resolveUserId(principal);
        notificationService.markAsRead(userId, payload.getNotificationId());
        return payload.getNotificationId();
    }

    /**
     * Đánh dấu tất cả thông báo đã đọc.
     */
    @MessageMapping("/notifications/read-all")
    @SendToUser("/queue/notifications/ack-read-all")
    public Integer markAllNotificationsAsRead(Principal principal) {
        UUID userId = resolveUserId(principal);
        return notificationService.markAllAsRead(userId);
    }

    /**
     * Xóa một thông báo cụ thể.
     */
    @MessageMapping("/notifications/delete")
    @SendToUser("/queue/notifications/ack-delete")
    public Long deleteNotification(@Valid NotificationIdRequest payload, Principal principal) {
        UUID userId = resolveUserId(principal);
        notificationService.deleteNotification(userId, payload.getNotificationId());
        return payload.getNotificationId();
    }

    /**
     * Xóa nhiều thông báo.
     */
    @MessageMapping("/notifications/delete-batch")
    @SendToUser("/queue/notifications/ack-delete-batch")
    public List<Long> deleteNotifications(@Valid NotificationBatchRequest payload, Principal principal) {
        UUID userId = resolveUserId(principal);
        notificationService.deleteNotifications(userId, payload.getNotificationIds());
        return payload.getNotificationIds();
    }

    /**
     * Lấy summary thông báo qua WebSocket (tổng số, unread, read).
     */
    @MessageMapping("/notifications/summary")
    @SendToUser("/queue/notifications/summary")
    public NotificationSummaryResponse getSummary(Principal principal) {
        UUID userId = resolveUserId(principal);
        return notificationService.getSummary(userId);
    }

    private UUID resolveUserId(Principal principal) {
        if (principal instanceof Authentication authentication) {
            Object authPrincipal = authentication.getPrincipal();
            if (authPrincipal instanceof User user) {
                return user.getId();
            }
        }
        throw new AccessDeniedException("Không xác định được người dùng từ phiên WebSocket");
    }
}
