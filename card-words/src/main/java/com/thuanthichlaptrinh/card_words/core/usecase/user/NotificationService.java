package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.common.constants.NotificationConstants;
import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.Notification;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.NotificationRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.NotificationFilterRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.NotificationCategoryResponse;
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
import java.util.Objects;
import java.util.UUID;
import java.util.stream.Collectors;

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
        @Transactional(readOnly = true)
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
         * Admin: Get notifications of a specific user
         */
        @Transactional(readOnly = true)
        public Page<NotificationResponse> getUserNotificationsAsAdmin(UUID userId, NotificationFilterRequest request) {
                validateUserExists(userId);
                return getNotifications(userId, request);
        }

        /**
         * Admin: Get notifications of multiple users in a single paginated feed
         */
        @Transactional(readOnly = true)
        public Page<NotificationResponse> getNotificationsForUsers(List<UUID> userIds, NotificationFilterRequest request) {
                if (userIds == null || userIds.isEmpty()) {
                        throw new ErrorException("Danh sách userId không được để trống");
                }

                List<UUID> distinctIds = userIds.stream()
                        .filter(Objects::nonNull)
                        .distinct()
                        .collect(Collectors.toList());

                if (distinctIds.isEmpty()) {
                        throw new ErrorException("Danh sách userId không hợp lệ");
                }

                List<User> users = userRepository.findAllById(distinctIds);
                if (users.size() != distinctIds.size()) {
                        throw new ErrorException("Một hoặc nhiều userId không tồn tại trong hệ thống");
                }

                log.info("Admin: Lấy notifications cho {} users", distinctIds.size());

                Pageable pageable = PageRequest.of(request.getPage(), request.getSize());
                Page<Notification> notifications = notificationRepository.findByUserIdsAndFilters(
                                distinctIds,
                                request.getIsRead(),
                                request.getType(),
                                pageable);

                return notifications.map(this::toResponse);
        }

        /**
         * Admin: Get notifications across the whole system
         */
        @Transactional(readOnly = true)
        public Page<NotificationResponse> getAllNotifications(NotificationFilterRequest request) {
                Pageable pageable = PageRequest.of(request.getPage(), request.getSize());
                Page<Notification> notifications = notificationRepository.findAllByFilters(
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

        // Validate type
        request.validateType();

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

        // Validate type
        request.validateType();

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

    /**
     * Get notification categories with counts for a user
     */
    public List<NotificationCategoryResponse> getCategories(UUID userId) {
        log.info("Lấy danh sách categories với số lượng cho user: {}", userId);

        List<NotificationCategoryResponse> categories = new java.util.ArrayList<>();

        // All Notifications
        Pageable pageable = PageRequest.of(0, Integer.MAX_VALUE);
        long totalCount = notificationRepository.findByUserIdOrderByCreatedAtDesc(userId, pageable)
                .getTotalElements();
        categories.add(NotificationCategoryResponse.builder()
                .category("All Notifications")
                .count(totalCount)
                .type(null)
                .build());

        // Unread
        long unreadCount = notificationRepository.countByUserIdAndIsReadFalse(userId);
        categories.add(NotificationCategoryResponse.builder()
                .category("Unread")
                .count(unreadCount)
                .type(null)
                .build());

        // Study Progress
        long studyProgressCount = notificationRepository.countByUserIdAndType(userId, "study_progress");
        categories.add(NotificationCategoryResponse.builder()
                .category("Study Progress")
                .count(studyProgressCount)
                .type("study_progress")
                .build());

        // Vocabulary Reminders
        long vocabReminderCount = notificationRepository.countByUserIdAndType(userId, "vocab_reminder");
        categories.add(NotificationCategoryResponse.builder()
                .category("Vocabulary Reminders")
                .count(vocabReminderCount)
                .type("vocab_reminder")
                .build());

        // Streak Reminders
        long streakReminderCount = notificationRepository.countByUserIdAndType(userId, "streak_reminder");
        categories.add(NotificationCategoryResponse.builder()
                .category("Streak Reminders")
                .count(streakReminderCount)
                .type("streak_reminder")
                .build());

        // Streak Milestones
        long streakMilestoneCount = notificationRepository.countByUserIdAndType(userId, "streak_milestone");
        categories.add(NotificationCategoryResponse.builder()
                .category("Streak Milestones")
                .count(streakMilestoneCount)
                .type("streak_milestone")
                .build());

        // Game Achievements
        long gameAchievementCount = notificationRepository.countByUserIdAndType(userId, "game_achievement");
        categories.add(NotificationCategoryResponse.builder()
                .category("Game Achievements")
                .count(gameAchievementCount)
                .type("game_achievement")
                .build());

        // Achievements
        long achievementCount = notificationRepository.countByUserIdAndType(userId, "achievement");
        categories.add(NotificationCategoryResponse.builder()
                .category("Achievements")
                .count(achievementCount)
                .type("achievement")
                .build());

        // New Features
        long newFeatureCount = notificationRepository.countByUserIdAndType(userId, "new_feature");
        categories.add(NotificationCategoryResponse.builder()
                .category("New Features")
                .count(newFeatureCount)
                .type("new_feature")
                .build());

        // System Alerts
        long systemAlertCount = notificationRepository.countByUserIdAndType(userId, "system_alert");
        categories.add(NotificationCategoryResponse.builder()
                .category("System Alerts")
                .count(systemAlertCount)
                .type("system_alert")
                .build());

        // Streak Break Alerts
        long streakBreakCount = notificationRepository.countByUserIdAndType(userId, NotificationConstants.STREAK_BREAK);
        categories.add(NotificationCategoryResponse.builder()
                .category("Streak Break Alerts")
                .count(streakBreakCount)
                .type(NotificationConstants.STREAK_BREAK)
                .build());

        return categories;
    }

    /**
     * Get admin summary (Total, Unread, Read)
     */
    public List<NotificationCategoryResponse> getAdminSummary() {
        log.info("Admin: Lấy tổng quan hệ thống");

        List<NotificationCategoryResponse> summary = new java.util.ArrayList<>();

        // Total
        long totalCount = notificationRepository.count();
        summary.add(NotificationCategoryResponse.builder()
                .category("Total")
                .count(totalCount)
                .type(null)
                .build());

        // Unread
        long unreadCount = notificationRepository.countByIsReadFalse();
        summary.add(NotificationCategoryResponse.builder()
                .category("Unread")
                .count(unreadCount)
                .type(null)
                .build());

        // Read
        long readCount = totalCount - unreadCount;
        summary.add(NotificationCategoryResponse.builder()
                .category("Read")
                .count(readCount)
                .type(null)
                .build());

        return summary;
    }

    /**
     * Get all notification categories with counts (Admin)
     */
    public List<NotificationCategoryResponse> getAllCategories() {
        log.info("Admin: Lấy danh sách categories với số lượng");

        List<NotificationCategoryResponse> categories = new java.util.ArrayList<>();

        // All Notifications
        long totalCount = notificationRepository.count();
        categories.add(NotificationCategoryResponse.builder()
                .category("All Notifications")
                .count(totalCount)
                .type(null)
                .build());

        // Unread
        long unreadCount = notificationRepository.countByIsReadFalse();
        categories.add(NotificationCategoryResponse.builder()
                .category("Unread")
                .count(unreadCount)
                .type(null)
                .build());

        // Study Progress
        long studyProgressCount = notificationRepository.countByType("study_progress");
        categories.add(NotificationCategoryResponse.builder()
                .category("Study Progress")
                .count(studyProgressCount)
                .type("study_progress")
                .build());

        // Vocabulary Reminders
        long vocabReminderCount = notificationRepository.countByType("vocab_reminder");
        categories.add(NotificationCategoryResponse.builder()
                .category("Vocabulary Reminders")
                .count(vocabReminderCount)
                .type("vocab_reminder")
                .build());

        // Streak Reminders
        long streakReminderCount = notificationRepository.countByType("streak_reminder");
        categories.add(NotificationCategoryResponse.builder()
                .category("Streak Reminders")
                .count(streakReminderCount)
                .type("streak_reminder")
                .build());

        // Streak Milestones
        long streakMilestoneCount = notificationRepository.countByType("streak_milestone");
        categories.add(NotificationCategoryResponse.builder()
                .category("Streak Milestones")
                .count(streakMilestoneCount)
                .type("streak_milestone")
                .build());

        // Game Achievements
        long gameAchievementCount = notificationRepository.countByType("game_achievement");
        categories.add(NotificationCategoryResponse.builder()
                .category("Game Achievements")
                .count(gameAchievementCount)
                .type("game_achievement")
                .build());

        // Achievements
        long achievementCount = notificationRepository.countByType("achievement");
        categories.add(NotificationCategoryResponse.builder()
                .category("Achievements")
                .count(achievementCount)
                .type("achievement")
                .build());

        // New Features
        long newFeatureCount = notificationRepository.countByType("new_feature");
        categories.add(NotificationCategoryResponse.builder()
                .category("New Features")
                .count(newFeatureCount)
                .type("new_feature")
                .build());

        // System Alerts
        long systemAlertCount = notificationRepository.countByType("system_alert");
        categories.add(NotificationCategoryResponse.builder()
                .category("System Alerts")
                .count(systemAlertCount)
                .type("system_alert")
                .build());

        // Streak Break Alerts
        long streakBreakCount = notificationRepository.countByType(NotificationConstants.STREAK_BREAK);
        categories.add(NotificationCategoryResponse.builder()
                .category("Streak Break Alerts")
                .count(streakBreakCount)
                .type(NotificationConstants.STREAK_BREAK)
                .build());

        return categories;
    }

    private NotificationResponse toResponse(Notification notification) {
        return NotificationResponse.builder()
                .id(notification.getId())
                .title(notification.getTitle())
                .content(notification.getContent())
                .type(notification.getType())
                .isRead(notification.getIsRead())
                .createdAt(notification.getCreatedAt())
                                .userId(notification.getUser() != null ? notification.getUser().getId() : null)
                                .userName(notification.getUser() != null ? notification.getUser().getName() : null)
                                .userEmail(notification.getUser() != null ? notification.getUser().getEmail() : null)
                .build();
    }

        private void validateUserExists(UUID userId) {
                if (!userRepository.existsById(userId)) {
                        throw new ErrorException("Không tìm thấy người dùng với ID: " + userId);
                }
        }
}
