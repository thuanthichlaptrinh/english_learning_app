package com.thuanthichlaptrinh.card_words.core.scheduler;

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
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.stream.Collectors;

/**
 * Scheduled task để gửi nhắc nhở streak hàng ngày
 * Chạy vào 9:00 AM mỗi ngày để nhắc users duy trì streak
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
     * Chạy hàng ngày lúc 9:00 AM
     * Gửi email và notification cho users:
     * - Đã học hôm qua nhưng chưa học hôm nay
     * - Đang có streak >= 3 ngày (đáng để giữ)
     */
    @Scheduled(cron = "0 0 9 * * *") // 9:00 AM every day
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
                    // Kiểm tra xem user có cần nhắc nhở không
                    if (shouldSendReminder(user, today, yesterday)) {
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
    private boolean shouldSendReminder(User user, LocalDate today, LocalDate yesterday) {
        // Lấy lịch sử học tập
        List<UserVocabProgress> progressList = userVocabProgressRepository.findByUserIdWithVocab(user.getId());

        if (progressList.isEmpty()) {
            return false; // User chưa học lần nào
        }

        // Extract ngày học
        Set<LocalDate> studyDates = progressList.stream()
                .map(p -> p.getCreatedAt().toLocalDate())
                .collect(Collectors.toCollection(TreeSet::new));

        // Kiểm tra điều kiện
        boolean studiedYesterday = studyDates.contains(yesterday);
        boolean studiedToday = studyDates.contains(today);
        int currentStreak = user.getCurrentStreak() != null ? user.getCurrentStreak() : 0;

        // Chỉ nhắc nếu: học hôm qua, chưa học hôm nay, streak >= 3
        return studiedYesterday && !studiedToday && currentStreak >= 3;
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
                    .title("🔥 Don't Break Your Streak!")
                    .content(String.format(
                            "You're on a %d-day streak! Practice today to keep your learning momentum going.", streak))
                    .type("vocab_reminder")
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
}
