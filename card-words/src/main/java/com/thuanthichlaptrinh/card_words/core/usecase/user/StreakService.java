package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.domain.UserVocabProgress;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserVocabProgressRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.StreakRecordResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.StreakResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class StreakService {

    private final UserRepository userRepository;
    private final UserVocabProgressRepository userVocabProgressRepository;
    private final NotificationService notificationService;

    /**
     * Lấy thông tin streak của user
     * Tính toán dựa trên created_at trong user_vocab_progress
     * Tự động cập nhật streak vào bảng users
     */
    @Transactional
    public StreakResponse getStreak(User user) {
        log.info("Getting streak info for user: {}", user.getId());

        // Lấy tất cả ngày học từ user_vocab_progress (based on created_at)
        List<UserVocabProgress> progressList = userVocabProgressRepository.findByUserIdWithVocab(user.getId());

        // Extract unique dates from created_at
        Set<LocalDate> studyDates = progressList.stream()
                .map(p -> p.getCreatedAt().toLocalDate())
                .collect(Collectors.toCollection(TreeSet::new)); // TreeSet để sort tự động

        LocalDate today = LocalDate.now();

        // Tính toán streak từ study dates
        StreakCalculation calculation = calculateStreakFromDates(studyDates, today);

        // Convert studyDates thành activityLog format
        Map<String, Map<String, List<Integer>>> activityLog = buildActivityLog(studyDates);

        // Sync với User entity và LƯU VÀO DATABASE
        syncUserStreakData(user, calculation);
        userRepository.save(user); // <--- Lưu vào DB để đồng bộ dữ liệu

        String status;
        int daysUntilBreak;
        String message;

        if (calculation.totalStudyDays == 0) {
            // User chưa học lần nào
            status = "NEW";
            daysUntilBreak = 1;
            message = "Bắt đầu streak của bạn bằng cách học hôm nay! 🚀";
        } else if (calculation.lastActivityDate.equals(today)) {
            // Đã học hôm nay
            status = "ACTIVE";
            daysUntilBreak = 0;
            message = generateActiveMessage(calculation.currentStreak);
        } else if (calculation.lastActivityDate.equals(today.minusDays(1))) {
            // Học hôm qua, chưa học hôm nay
            status = "PENDING";
            daysUntilBreak = 1;
            message = "Học hôm nay để duy trì streak " + calculation.currentStreak + " ngày! ⏰";
        } else {
            // Bỏ lỡ > 1 ngày
            status = "BROKEN";
            daysUntilBreak = -1;
            message = "Streak đã bị gián đoạn. Bắt đầu lại hôm nay! 💪";
        }

        return StreakResponse.builder()
                .currentStreak(calculation.currentStreak)
                .longestStreak(calculation.longestStreak)
                .lastActivityDate(calculation.lastActivityDate)
                .totalStudyDays(calculation.totalStudyDays)
                .streakStatus(status)
                .daysUntilBreak(daysUntilBreak)
                .message(message)
                .activityLog(activityLog)
                .build();
    }

    /**
     * Ghi nhận hoạt động học của user
     * Tự động gọi khi user hoàn thành game hoặc ôn flashcard
     * Tính toán dựa trên user_vocab_progress created_at
     * Chạy trong transaction riêng để tránh conflict với transaction của game
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public StreakRecordResponse recordActivity(User user) {
        log.info("Recording activity for user: {}", user.getId());

        LocalDate today = LocalDate.now();

        // Lấy tất cả ngày học từ user_vocab_progress
        List<UserVocabProgress> progressList = userVocabProgressRepository.findByUserIdWithVocab(user.getId());

        // Extract unique dates
        Set<LocalDate> studyDates = progressList.stream()
                .map(p -> p.getCreatedAt().toLocalDate())
                .collect(Collectors.toCollection(TreeSet::new));

        // Check xem hôm nay đã có activity chưa
        boolean alreadyStudiedToday = studyDates.contains(today);

        boolean streakIncreased = false;
        boolean isNewRecord = false;

        if (!alreadyStudiedToday) {
            // Thêm ngày hôm nay vào set (simulate activity đã được tạo)
            studyDates.add(today);
        }

        // Tính toán streak mới
        StreakCalculation calculation = calculateStreakFromDates(studyDates, today);

        // So sánh với streak cũ để detect changes (handle null for new users)
        int oldStreak = user.getCurrentStreak() != null ? user.getCurrentStreak() : 0;
        int oldLongest = user.getLongestStreak() != null ? user.getLongestStreak() : 0;

        if (!alreadyStudiedToday) {
            if (calculation.currentStreak > oldStreak) {
                streakIncreased = true;
                log.info("Streak increased from {} to {} for user: {}", oldStreak, calculation.currentStreak,
                        user.getId());
            }

            if (calculation.longestStreak > oldLongest) {
                isNewRecord = true;
                log.info("New record! Longest streak: {} for user: {}", calculation.longestStreak, user.getId());
            }

            // Sync và lưu vào User entity
            syncUserStreakData(user, calculation);
            userRepository.save(user);

            // 🔔 Create streak milestone notifications
            createStreakNotifications(user, calculation.currentStreak, calculation.longestStreak, isNewRecord);

            log.info("Activity recorded successfully for user: {}", user.getId());
        } else {
            log.info("User {} already studied today. No streak update needed.", user.getId());
            // Vẫn sync data để đảm bảo consistency
            syncUserStreakData(user, calculation);
        }

        return StreakRecordResponse.builder()
                .message(generateRecordMessage(calculation.currentStreak, isNewRecord, streakIncreased))
                .currentStreak(calculation.currentStreak)
                .longestStreak(calculation.longestStreak)
                .isNewRecord(isNewRecord)
                .streakIncreased(streakIncreased)
                .build();
    }

    /**
     * Generate message cho active streak
     */
    private String generateActiveMessage(int streak) {
        if (streak == 0) {
            return "Bắt đầu streak của bạn ngay hôm nay! 🎯";
        } else if (streak == 1) {
            return "Bạn đang có streak 1 ngày! Hãy duy trì nhé! 💪";
        } else if (streak < 7) {
            return String.format("Tuyệt vời! Bạn đang có streak %d ngày! 🔥", streak);
        } else if (streak < 30) {
            return String.format("Xuất sắc! Streak %d ngày! Tiếp tục phát huy! 🌟", streak);
        } else if (streak < 100) {
            return String.format("Phi thường! Streak %d ngày! Bạn là champion! 🏆", streak);
        } else {
            return String.format("Huyền thoại! Streak %d ngày! Không gì cản được bạn! 👑", streak);
        }
    }

    /**
     * Generate message sau khi record activity
     */
    private String generateRecordMessage(int streak, boolean isNewRecord, boolean streakIncreased) {
        if (isNewRecord && streak > 1) {
            return String.format("🎉 KỶ LỤC MỚI! Streak %d ngày! Bạn đã phá kỷ lục cũ!", streak);
        } else if (streakIncreased) {
            return String.format("Tuyệt vời! Streak của bạn đã tăng lên %d ngày! 🔥", streak);
        } else if (streak == 1) {
            return "Chào mừng bạn quay lại! Hãy xây dựng streak mới! 💪";
        } else {
            return "Hoạt động đã được ghi nhận! Tiếp tục học tập nhé! 📚";
        }
    }

    /**
     * Tính toán streak từ danh sách các ngày học
     */
    private StreakCalculation calculateStreakFromDates(Set<LocalDate> studyDates, LocalDate today) {
        if (studyDates.isEmpty()) {
            return new StreakCalculation(0, 0, null, 0);
        }

        LocalDate lastDate = studyDates.stream()
                .max(LocalDate::compareTo)
                .orElse(null);

        int totalStudyDays = studyDates.size();

        // ✅ FIX: Kiểm tra xem streak có bị gián đoạn không
        // Nếu lastDate cách today > 1 ngày → streak đã bị break
        boolean streakIsBroken = lastDate.isBefore(today.minusDays(1));

        // Tính current streak (từ ngày gần nhất về trước)
        int currentStreak = 0;

        if (!streakIsBroken) {
            // Chỉ tính streak nếu chưa bị gián đoạn
            LocalDate checkDate = lastDate;

            while (checkDate != null && studyDates.contains(checkDate)) {
                currentStreak++;
                checkDate = checkDate.minusDays(1);
            }
        }
        // Nếu streakIsBroken = true → currentStreak = 0

        // Tính longest streak
        int longestStreak = 0;
        int tempStreak = 0;
        LocalDate previousDate = null;

        for (LocalDate date : studyDates) {
            if (previousDate == null || date.equals(previousDate.plusDays(1))) {
                // Liên tục
                tempStreak++;
            } else {
                // Gián đoạn - lưu longest và reset
                longestStreak = Math.max(longestStreak, tempStreak);
                tempStreak = 1;
            }
            previousDate = date;
        }
        longestStreak = Math.max(longestStreak, tempStreak);

        return new StreakCalculation(currentStreak, longestStreak, lastDate, totalStudyDays);
    }

    /**
     * Sync streak data vào User entity
     */
    private void syncUserStreakData(User user, StreakCalculation calculation) {
        user.setCurrentStreak(calculation.currentStreak);
        user.setLongestStreak(calculation.longestStreak);
        user.setLastActivityDate(calculation.lastActivityDate);
        user.setTotalStudyDays(calculation.totalStudyDays);
    }

    /**
     * Convert studyDates thành activityLog format
     * Format: { "2025": { "10": [29, 30, 31], "11": [1, 3, 4] } }
     */
    private Map<String, Map<String, List<Integer>>> buildActivityLog(Set<LocalDate> studyDates) {
        Map<String, Map<String, List<Integer>>> activityLog = new LinkedHashMap<>();

        for (LocalDate date : studyDates) {
            String year = String.valueOf(date.getYear());
            String month = String.valueOf(date.getMonthValue());
            int day = date.getDayOfMonth();

            // Tạo year map nếu chưa có
            activityLog.putIfAbsent(year, new LinkedHashMap<>());

            // Tạo month list nếu chưa có
            activityLog.get(year).putIfAbsent(month, new ArrayList<>());

            // Thêm day vào list
            activityLog.get(year).get(month).add(day);
        }

        // Sort days trong mỗi month
        activityLog.values().forEach(yearMap -> yearMap.values().forEach(Collections::sort));

        return activityLog;
    }

    /**
     * Create streak milestone notifications
     */
    private void createStreakNotifications(User user, int currentStreak, int longestStreak, boolean isNewRecord) {
        try {
            // Milestone notifications for significant streaks
            if (currentStreak == 7) {
                com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest request = 
                    com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest.builder()
                        .userId(user.getId())
                        .title("🔥 7-Day Streak Milestone!")
                        .content("Congratulations! You've maintained a 7-day learning streak. Keep up the momentum!")
                        .type("study_progress")
                        .build();
                notificationService.createNotification(request);
            } else if (currentStreak == 30) {
                com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest request = 
                    com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest.builder()
                        .userId(user.getId())
                        .title("🌟 30-Day Streak Champion!")
                        .content("Amazing! You've achieved a 30-day learning streak! You're building great habits!")
                        .type("study_progress")
                        .build();
                notificationService.createNotification(request);
            } else if (currentStreak == 100) {
                com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest request = 
                    com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest.builder()
                        .userId(user.getId())
                        .title("👑 100-Day Streak Legend!")
                        .content("Incredible! You've reached a 100-day streak! You're a true learning champion!")
                        .type("achievement")
                        .build();
                notificationService.createNotification(request);
            }

            // New personal record notification
            if (isNewRecord && longestStreak > 7) {
                com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest request = 
                    com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest.builder()
                        .userId(user.getId())
                        .title("🎉 New Personal Record!")
                        .content(String.format("You've set a new personal record with a %d-day streak! Keep pushing forward!", longestStreak))
                        .type("achievement")
                        .build();
                notificationService.createNotification(request);
            }

            log.info("✅ Streak notifications created for user: {}", user.getId());
        } catch (Exception e) {
            log.error("❌ Failed to create streak notifications: {}", e.getMessage(), e);
        }
    }

    /**
     * Inner class để giữ kết quả tính toán streak
     */
    private static class StreakCalculation {
        final int currentStreak;
        final int longestStreak;
        final LocalDate lastActivityDate;
        final int totalStudyDays;

        StreakCalculation(int currentStreak, int longestStreak, LocalDate lastActivityDate, int totalStudyDays) {
            this.currentStreak = currentStreak;
            this.longestStreak = longestStreak;
            this.lastActivityDate = lastActivityDate;
            this.totalStudyDays = totalStudyDays;
        }
    }
}
