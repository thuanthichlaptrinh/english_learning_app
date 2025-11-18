package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.Notification;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.NotificationRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.NotificationFilterRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.NotificationResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.NotificationSummaryResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;
    private final SimpMessagingTemplate messagingTemplate;

    /**
     * Get notifications for a user with filters
     */
    public Page<NotificationResponse> getNotifications(UUID userId, NotificationFilterRequest request) {
        log.info("Lấy danh sách notifications cho user: {}", userId);

        Pageable pageable = PageRequest.of(request.getPage(), request.getSize());

        Page<Notification> notifications = notificationRepository.findByFilters(
                userId,
                request.getIsRead(),
                request.getType(),
                pageable);

        return notifications.map(this::toResponse);
    }

    /**
     * Get notification summary
     */
    public NotificationSummaryResponse getSummary(UUID userId) {
        log.info("Lấy tổng quan notifications cho user: {}", userId);

        long unreadCount = notificationRepository.countByUserIdAndIsReadFalse(userId);
        Pageable pageable = PageRequest.of(0, Integer.MAX_VALUE);
        long totalCount = notificationRepository.findByUserIdOrderByCreatedAtDesc(userId, pageable).getTotalElements();

        return NotificationSummaryResponse.builder()
                .totalNotifications(totalCount)
                .unreadNotifications(unreadCount)
                .readNotifications(totalCount - unreadCount)
                .build();
    }

    /**
     * Mark notification as read
     */
    @Transactional
    public void markAsRead(UUID userId, Long notificationId) {
        log.info("Đánh dấu notification {} đã đọc cho user: {}", notificationId, userId);

        int updated = notificationRepository.markAsRead(notificationId, userId);
        if (updated == 0) {
            throw new ErrorException("Không tìm thấy notification hoặc không có quyền truy cập");
        }

        // Push real-time update via WebSocket
        messagingTemplate.convertAndSendToUser(
                userId.toString(),
                "/queue/notifications/read",
                notificationId);
        log.info("✅ Sent mark-as-read notification to user {} via WebSocket", userId);
    }

    /**
     * Mark all notifications as read
     */
    @Transactional
    public int markAllAsRead(UUID userId) {
        log.info("Đánh dấu tất cả notifications đã đọc cho user: {}", userId);

        int count = notificationRepository.markAllAsRead(userId);

        // Push real-time update via WebSocket
        messagingTemplate.convertAndSendToUser(
                userId.toString(),
                "/queue/notifications/read-all",
                count);
        log.info("✅ Sent mark-all-as-read notification to user {} via WebSocket ({} notifications)", userId, count);

        return count;
    }

    /**
     * Delete notification
     */
    @Transactional
    public void deleteNotification(UUID userId, Long notificationId) {
        log.info("Xóa notification {} của user: {}", notificationId, userId);

        Notification notification = notificationRepository.findById(notificationId)
                .orElseThrow(() -> new ErrorException("Không tìm thấy notification"));

        if (!notification.getUser().getId().equals(userId)) {
            throw new ErrorException("Không có quyền xóa notification này");
        }

        notificationRepository.delete(notification);

        // Push real-time deletion via WebSocket
        messagingTemplate.convertAndSendToUser(
                userId.toString(),
                "/queue/notifications/deleted",
                notificationId);
        log.info("✅ Sent delete notification to user {} via WebSocket", userId);
    }

    /**
     * Delete selected notifications
     */
    @Transactional
    public void deleteNotifications(UUID userId, List<Long> notificationIds) {
        log.info("Xóa {} notifications của user: {}", notificationIds.size(), userId);

        for (Long id : notificationIds) {
            deleteNotification(userId, id);
        }

        // Push batch deletion via WebSocket (after all deletions complete)
        messagingTemplate.convertAndSendToUser(
                userId.toString(),
                "/queue/notifications/batch-deleted",
                notificationIds);
        log.info("✅ Sent batch-delete notification to user {} via WebSocket ({} notifications)", userId,
                notificationIds.size());
    }

    /**
     * Create notification for a user
     */
    @Transactional
    public NotificationResponse createNotification(CreateNotificationRequest request) {
        log.info("Tạo notification cho user: {}", request.getUserId());

        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new ErrorException("Không tìm thấy người dùng"));

        Notification notification = Notification.builder()
                .user(user)
                .title(request.getTitle())
                .content(request.getContent())
                .type(request.getType())
                .isRead(false)
                .build();

        notification = notificationRepository.save(notification);
        NotificationResponse response = toResponse(notification);

        // Push real-time notification via WebSocket
        messagingTemplate.convertAndSendToUser(
                request.getUserId().toString(),
                "/queue/notifications",
                response);
        log.info("✅ Sent real-time notification to user {} via WebSocket", request.getUserId());

        return response;
    }

    /**
     * Create notification for all users
     */
    @Transactional
    public void createNotificationForAll(CreateNotificationRequest request) {
        log.info("Tạo notification cho tất cả users");

        List<User> users = userRepository.findAll();

        for (User user : users) {
            Notification notification = Notification.builder()
                    .user(user)
                    .title(request.getTitle())
                    .content(request.getContent())
                    .type(request.getType())
                    .isRead(false)
                    .build();

            notification = notificationRepository.save(notification);
            NotificationResponse response = toResponse(notification);

            // Push real-time notification via WebSocket
            messagingTemplate.convertAndSendToUser(
                    user.getId().toString(),
                    "/queue/notifications",
                    response);
        }

        log.info("✅ Sent real-time notifications to {} users via WebSocket", users.size());
    }

    private NotificationResponse toResponse(Notification notification) {
        return NotificationResponse.builder()
                .id(notification.getId())
                .title(notification.getTitle())
                .content(notification.getContent())
                .type(notification.getType())
                .isRead(notification.getIsRead())
                .createdAt(notification.getCreatedAt())
                .build();
    }
}
