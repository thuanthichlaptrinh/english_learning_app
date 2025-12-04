package com.thuanthichlaptrinh.card_words.core.scheduler;

import com.thuanthichlaptrinh.card_words.common.constants.NotificationConstants;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.domain.UserVocabProgress;
import com.thuanthichlaptrinh.card_words.core.usecase.user.EmailService;
import com.thuanthichlaptrinh.card_words.core.usecase.user.NotificationService;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserVocabProgressRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Scheduled task để gửi nhắc nhở streak hàng ngày
 * Chạy vào 7:00 AM và 19:00 PM mỗi ngày để nhắc users duy trì streak
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class StreakReminderScheduler {

    private final UserRepository userRepository;
    private final UserVocabProgressRepository userVocabProgressRepository;
    private final NotificationService notificationService;
    private final EmailService emailService;

    /**
     * Chạy hàng ngày lúc 07:00 và 19:00 (giờ Việt Nam)
     * Gửi email & notification cho users:
     * - Đã học hôm qua nhưng chưa học hôm nay
     * - Đang có streak >= 3 ngày (đáng để giữ)
     */
    @Scheduled(cron = "0 0 7,19 * * *", zone = "Asia/Ho_Chi_Minh") // 07:00 và 19:00 giờ VN
    @Transactional(readOnly = true)
    public void sendStreakReminders() {
        log.info("🔔 Starting streak reminder job...");

        try {
            LocalDate today = LocalDate.now();
            LocalDate yesterday = today.minusDays(1);

            // Lấy tất cả active users
            List<User> allUsers = userRepository.findAll();
            int remindersSent = 0;

            for (User user : allUsers) {
                try {
                    Set<LocalDate> studyDates = loadStudyDates(user.getId());
                    // Kiểm tra xem user có cần nhắc nhở không
                    if (shouldSendReminder(user, today, yesterday, studyDates)) {
                        sendStreakReminderToUser(user);
                        remindersSent++;
                    }
                } catch (Exception e) {
                    log.error("❌ Failed to send reminder to user {}: {}", user.getId(), e.getMessage());
                }
            }

            log.info("✅ Streak reminder job completed. Sent {} reminders", remindersSent);

        } catch (Exception e) {
            log.error("❌ Streak reminder job failed: {}", e.getMessage(), e);
        }
    }

    /**
     * Kiểm tra xem user có cần nhắc nhở không
     * Điều kiện:
     * 1. Đã học hôm qua (có activity)
     * 2. Chưa học hôm nay
     * 3. Streak hiện tại >= 3 ngày (đáng để giữ)
     */
    private boolean shouldSendReminder(User user, LocalDate today, LocalDate yesterday, Set<LocalDate> studyDates) {
        if (studyDates.isEmpty()) {
            return false; // User chưa học lần nào
        }

        // Kiểm tra điều kiện
        boolean studiedYesterday = studyDates.contains(yesterday);
        boolean studiedToday = studyDates.contains(today);
        int currentStreak = user.getCurrentStreak() != null ? user.getCurrentStreak() : 0;

        // Chỉ nhắc nếu: học hôm qua, chưa học hôm nay, streak >= 3
        return studiedYesterday && !studiedToday && currentStreak >= 3;
    }

    /**
     * Gửi thông báo nhắc người dùng khi chuỗi đã bị dừng (chỉ chạy 07:00 giờ VN mỗi
     * ngày)
     */
    @Scheduled(cron = "0 0 7 * * *", zone = "Asia/Ho_Chi_Minh")
    @Transactional(readOnly = true)
    public void sendStreakStopAlerts() {
        log.info("🛑 Starting streak stop alert job...");

        try {
            LocalDate today = LocalDate.now();
            LocalDate yesterday = today.minusDays(1);
            LocalDate dayBeforeYesterday = today.minusDays(2);

            List<User> allUsers = userRepository.findAll();
            int alertsSent = 0;

            for (User user : allUsers) {
                try {
                    Set<LocalDate> studyDates = loadStudyDates(user.getId());
                    if (shouldSendStopAlert(studyDates, yesterday, dayBeforeYesterday)) {
                        sendStreakStopNotification(user);
                        alertsSent++;
                    }
                } catch (Exception e) {
                    log.error("❌ Failed to send stop alert to user {}: {}", user.getId(), e.getMessage());
                }
            }

            log.info("✅ Streak stop alert job completed. Sent {} alerts", alertsSent);
        } catch (Exception e) {
            log.error("❌ Streak stop alert job failed: {}", e.getMessage(), e);
        }
    }

    /**
     * Gửi email và notification nhắc nhở streak
     */
    private void sendStreakReminderToUser(User user) {
        int streak = user.getCurrentStreak() != null ? user.getCurrentStreak() : 0;

        // 1. Tạo notification trong app
        try {
            CreateNotificationRequest notificationRequest = CreateNotificationRequest.builder()
                    .userId(user.getId())
                    .title("🔥 Đừng để chuỗi học bị gãy!")
                    .content(String.format(
                            "Bạn đang có chuỗi %d ngày. Luyện tập ngay hôm nay để duy trì phong độ nhé!", streak))
                    .type(NotificationConstants.STREAK_REMINDER)
                    .build();

            notificationService.createNotification(notificationRequest);
            log.info("📱 Notification sent to user: {} (streak: {})", user.getEmail(), streak);

        } catch (Exception e) {
            log.error("❌ Failed to create notification for user {}: {}", user.getId(), e.getMessage());
        }

        // 2. Gửi email nhắc nhở
        try {
            emailService.sendStreakReminderEmail(user.getEmail(), user.getName(), streak);
            log.info("📧 Email sent to: {} (streak: {})", user.getEmail(), streak);

        } catch (Exception e) {
            log.error("❌ Failed to send email to {}: {}", user.getEmail(), e.getMessage());
        }
    }

    private Set<LocalDate> loadStudyDates(UUID userId) {
        List<UserVocabProgress> progressList = userVocabProgressRepository.findByUserIdWithVocab(userId);

        if (progressList.isEmpty()) {
            return Collections.emptySet();
        }

        return progressList.stream()
                .map(progress -> progress.getCreatedAt().toLocalDate())
                .collect(Collectors.toCollection(TreeSet::new));
    }

    private boolean shouldSendStopAlert(Set<LocalDate> studyDates, LocalDate yesterday, LocalDate dayBeforeYesterday) {
        if (studyDates.isEmpty()) {
            return false;
        }

        boolean missedYesterday = !studyDates.contains(yesterday);
        boolean studiedDayBefore = studyDates.contains(dayBeforeYesterday);
        return missedYesterday && studiedDayBefore;
    }

    private void sendStreakStopNotification(User user) {
        try {
            CreateNotificationRequest notificationRequest = CreateNotificationRequest.builder()
                    .userId(user.getId())
                    .title("⚠️ Chuỗi học của bạn đã bị gián đoạn")
                    .content(
                            "Bạn đã bỏ lỡ buổi học hôm qua. Hãy quay lại ôn tập để khởi động lại chuỗi mới ngay hôm nay!")
                    .type(NotificationConstants.STREAK_BREAK)
                    .build();

            notificationService.createNotification(notificationRequest);
            log.info("🛑 Streak break notification sent to user: {}", user.getEmail());
        } catch (Exception e) {
            log.error("❌ Failed to create streak break notification for user {}: {}", user.getId(), e.getMessage());
        }
    }
}
