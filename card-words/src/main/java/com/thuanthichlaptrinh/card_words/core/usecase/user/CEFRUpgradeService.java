package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.common.constants.NotificationConstants;
import com.thuanthichlaptrinh.card_words.common.enums.CEFRLevel;
import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserVocabProgressRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

/**
 * Service để tự động cập nhật CEFR level cho user dựa trên hiệu suất học tập.
 * 
 * Công thức nâng cấp CEFR Level:
 * 1. Mastery Rate >= 70% ở level hiện tại
 * 2. Accuracy >= 75% ở level hiện tại (tăng dần theo level)
 * 3. Đã học ít nhất 10 từ ở level tiếp theo
 * 4. Accuracy >= 60% ở level tiếp theo
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CEFRUpgradeService {

    private final UserRepository userRepository;
    private final UserVocabProgressRepository userVocabProgressRepository;
    private final NotificationService notificationService;

    // Minimum words required at current level to be eligible for upgrade
    private static final int MIN_WORDS_A1 = 30;
    private static final int MIN_WORDS_A2 = 50;
    private static final int MIN_WORDS_B1 = 70;
    private static final int MIN_WORDS_B2 = 90;
    private static final int MIN_WORDS_C1 = 110;

    // Minimum exploration words at next level
    private static final int MIN_EXPLORATION_BASIC = 10; // A1->A2, A2->B1, B1->B2
    private static final int MIN_EXPLORATION_ADVANCED = 15; // B2->C1
    private static final int MIN_EXPLORATION_EXPERT = 20; // C1->C2

    // Mastery rate threshold (percentage of MASTERED words)
    private static final double MIN_MASTERY_RATE = 0.70;

    // Accuracy thresholds by level
    private static final double MIN_ACCURACY_A1 = 0.75;
    private static final double MIN_ACCURACY_A2 = 0.75;
    private static final double MIN_ACCURACY_B1 = 0.78;
    private static final double MIN_ACCURACY_B2 = 0.80;
    private static final double MIN_ACCURACY_C1 = 0.82;

    // Next level accuracy thresholds
    private static final double MIN_NEXT_ACCURACY_BASIC = 0.60; // A1->A2, A2->B1, B1->B2
    private static final double MIN_NEXT_ACCURACY_ADVANCED = 0.65; // B2->C1
    private static final double MIN_NEXT_ACCURACY_EXPERT = 0.70; // C1->C2

    /**
     * Kiểm tra và cập nhật CEFR level cho user sau mỗi hoạt động học tập.
     * Gọi method này sau khi user hoàn thành game, flashcard review, hoặc learn
     * vocab.
     *
     * @param userId ID của user
     * @return true nếu user được nâng cấp level, false nếu không
     */
    @Transactional
    public boolean checkAndUpgradeCEFR(UUID userId) {
        try {
            User user = userRepository.findById(userId).orElse(null);
            if (user == null) {
                log.warn("User not found for CEFR upgrade check: {}", userId);
                return false;
            }

            CEFRLevel currentLevel = user.getCurrentLevel();
            if (currentLevel == null) {
                currentLevel = CEFRLevel.A1;
            }

            // C2 is the highest level, cannot upgrade further
            if (currentLevel == CEFRLevel.C2) {
                return false;
            }

            CEFRLevel nextLevel = getNextLevel(currentLevel);
            if (nextLevel == null) {
                return false;
            }

            // Get stats for current level
            CEFRStats currentStats = getCEFRStats(userId, currentLevel.getDisplayName());

            // Get stats for next level
            CEFRStats nextStats = getCEFRStats(userId, nextLevel.getDisplayName());

            // Check upgrade conditions
            UpgradeCheckResult result = checkUpgradeConditions(currentLevel, currentStats, nextStats);

            if (result.canUpgrade) {
                // Upgrade user's CEFR level
                user.setCurrentLevel(nextLevel);
                userRepository.save(user);

                // Send congratulation notification
                sendUpgradeNotification(user, currentLevel, nextLevel, currentStats, nextStats);

                log.info("🎉 User {} upgraded from {} to {}!", userId, currentLevel, nextLevel);
                return true;
            } else {
                log.debug("User {} not eligible for upgrade from {}. Reason: {}",
                        userId, currentLevel, result.reason);
                return false;
            }

        } catch (Exception e) {
            log.error("Error checking CEFR upgrade for user {}: {}", userId, e.getMessage(), e);
            return false;
        }
    }

    /**
     * Lấy thống kê học tập của user tại một CEFR level cụ thể.
     */
    private CEFRStats getCEFRStats(UUID userId, String cefrLevel) {
        // Count total words learned at this level
        Long totalLearned = userVocabProgressRepository.countByUserIdAndVocabCefr(userId, cefrLevel);
        if (totalLearned == null)
            totalLearned = 0L;

        // Count mastered words at this level
        Long masteredCount = userVocabProgressRepository.countByUserIdAndVocabCefrAndStatus(
                userId, cefrLevel, VocabStatus.MASTERED);
        if (masteredCount == null)
            masteredCount = 0L;

        // Get accuracy (correct / total attempts) at this level
        Object[] accuracyResult = userVocabProgressRepository.getAccuracyByUserIdAndCefr(userId, cefrLevel);
        long totalCorrect = 0L;
        long totalWrong = 0L;

        if (accuracyResult != null && accuracyResult.length >= 2) {
            totalCorrect = accuracyResult[0] != null ? ((Number) accuracyResult[0]).longValue() : 0L;
            totalWrong = accuracyResult[1] != null ? ((Number) accuracyResult[1]).longValue() : 0L;
        }

        double accuracy = (totalCorrect + totalWrong) > 0
                ? (double) totalCorrect / (totalCorrect + totalWrong)
                : 0.0;

        double masteryRate = totalLearned > 0
                ? (double) masteredCount / totalLearned
                : 0.0;

        return new CEFRStats(totalLearned, masteredCount, totalCorrect, totalWrong, accuracy, masteryRate);
    }

    /**
     * Kiểm tra các điều kiện nâng cấp CEFR.
     */
    private UpgradeCheckResult checkUpgradeConditions(CEFRLevel currentLevel,
            CEFRStats currentStats,
            CEFRStats nextStats) {
        // 1. Check minimum words at current level
        int minWords = getMinWordsRequired(currentLevel);
        if (currentStats.totalLearned < minWords) {
            return new UpgradeCheckResult(false,
                    String.format("Cần học ít nhất %d từ ở level %s (hiện tại: %d)",
                            minWords, currentLevel, currentStats.totalLearned));
        }

        // 2. Check mastery rate at current level
        if (currentStats.masteryRate < MIN_MASTERY_RATE) {
            return new UpgradeCheckResult(false,
                    String.format("Cần đạt %.0f%% từ MASTERED ở level %s (hiện tại: %.1f%%)",
                            MIN_MASTERY_RATE * 100, currentLevel, currentStats.masteryRate * 100));
        }

        // 3. Check accuracy at current level
        double minAccuracy = getMinAccuracyForLevel(currentLevel);
        if (currentStats.accuracy < minAccuracy) {
            return new UpgradeCheckResult(false,
                    String.format("Cần đạt %.0f%% độ chính xác ở level %s (hiện tại: %.1f%%)",
                            minAccuracy * 100, currentLevel, currentStats.accuracy * 100));
        }

        // 4. Check exploration at next level
        int minExploration = getMinExplorationWords(currentLevel);
        if (nextStats.totalLearned < minExploration) {
            return new UpgradeCheckResult(false,
                    String.format("Cần khám phá ít nhất %d từ ở level tiếp theo (hiện tại: %d)",
                            minExploration, nextStats.totalLearned));
        }

        // 5. Check accuracy at next level
        double minNextAccuracy = getMinNextLevelAccuracy(currentLevel);
        if (nextStats.accuracy < minNextAccuracy) {
            return new UpgradeCheckResult(false,
                    String.format("Cần đạt %.0f%% độ chính xác ở level tiếp theo (hiện tại: %.1f%%)",
                            minNextAccuracy * 100, nextStats.accuracy * 100));
        }

        return new UpgradeCheckResult(true, "Đủ điều kiện nâng cấp!");
    }

    /**
     * Gửi thông báo chúc mừng khi user được nâng cấp CEFR level.
     */
    private void sendUpgradeNotification(User user, CEFRLevel oldLevel, CEFRLevel newLevel,
            CEFRStats oldStats, CEFRStats newStats) {
        try {
            String title = String.format("🎊 Chúc mừng! Bạn đã đạt trình độ %s!", newLevel.getDisplayName());

            String content = String.format(
                    "Bạn đã:\n" +
                            "✅ Thành thạo %.0f%% từ vựng %s (%d/%d từ)\n" +
                            "✅ Độ chính xác %.0f%% ở level %s\n" +
                            "✅ Khám phá %d từ %s với độ chính xác %.0f%%\n\n" +
                            "Tiếp tục học để đạt %s! 🚀",
                    oldStats.masteryRate * 100,
                    oldLevel.getDisplayName(),
                    oldStats.masteredCount,
                    oldStats.totalLearned,
                    oldStats.accuracy * 100,
                    oldLevel.getDisplayName(),
                    newStats.totalLearned,
                    newLevel.getDisplayName(),
                    newStats.accuracy * 100,
                    getNextLevel(newLevel) != null ? getNextLevel(newLevel).getDisplayName() : "đỉnh cao");

            CreateNotificationRequest request = CreateNotificationRequest.builder()
                    .userId(user.getId())
                    .title(title)
                    .content(content)
                    .type(NotificationConstants.ACHIEVEMENT)
                    .build();

            notificationService.createNotification(request);
            log.info("Sent CEFR upgrade notification to user {}", user.getId());

        } catch (Exception e) {
            log.error("Failed to send CEFR upgrade notification: {}", e.getMessage());
        }
    }

    /**
     * Lấy CEFR level tiếp theo.
     */
    private CEFRLevel getNextLevel(CEFRLevel current) {
        if (current == null)
            return CEFRLevel.A2;

        return switch (current) {
            case A1 -> CEFRLevel.A2;
            case A2 -> CEFRLevel.B1;
            case B1 -> CEFRLevel.B2;
            case B2 -> CEFRLevel.C1;
            case C1 -> CEFRLevel.C2;
            case C2 -> null; // Highest level
        };
    }

    /**
     * Lấy số từ tối thiểu cần học ở level hiện tại.
     */
    private int getMinWordsRequired(CEFRLevel level) {
        return switch (level) {
            case A1 -> MIN_WORDS_A1;
            case A2 -> MIN_WORDS_A2;
            case B1 -> MIN_WORDS_B1;
            case B2 -> MIN_WORDS_B2;
            case C1 -> MIN_WORDS_C1;
            case C2 -> Integer.MAX_VALUE; // Cannot upgrade from C2
        };
    }

    /**
     * Lấy độ chính xác tối thiểu cần đạt ở level hiện tại.
     */
    private double getMinAccuracyForLevel(CEFRLevel level) {
        return switch (level) {
            case A1 -> MIN_ACCURACY_A1;
            case A2 -> MIN_ACCURACY_A2;
            case B1 -> MIN_ACCURACY_B1;
            case B2 -> MIN_ACCURACY_B2;
            case C1 -> MIN_ACCURACY_C1;
            case C2 -> 1.0; // Cannot upgrade from C2
        };
    }

    /**
     * Lấy số từ tối thiểu cần khám phá ở level tiếp theo.
     */
    private int getMinExplorationWords(CEFRLevel level) {
        return switch (level) {
            case A1, A2, B1 -> MIN_EXPLORATION_BASIC;
            case B2 -> MIN_EXPLORATION_ADVANCED;
            case C1 -> MIN_EXPLORATION_EXPERT;
            case C2 -> Integer.MAX_VALUE;
        };
    }

    /**
     * Lấy độ chính xác tối thiểu cần đạt ở level tiếp theo.
     */
    private double getMinNextLevelAccuracy(CEFRLevel level) {
        return switch (level) {
            case A1, A2, B1 -> MIN_NEXT_ACCURACY_BASIC;
            case B2 -> MIN_NEXT_ACCURACY_ADVANCED;
            case C1 -> MIN_NEXT_ACCURACY_EXPERT;
            case C2 -> 1.0;
        };
    }

    /**
     * Lấy thông tin tiến độ nâng cấp CEFR của user (để hiển thị trên UI).
     */
    @Transactional(readOnly = true)
    public CEFRProgressResponse getCEFRProgress(UUID userId) {
        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return null;
        }

        CEFRLevel currentLevel = user.getCurrentLevel() != null ? user.getCurrentLevel() : CEFRLevel.A1;
        CEFRLevel nextLevel = getNextLevel(currentLevel);

        CEFRStats currentStats = getCEFRStats(userId, currentLevel.getDisplayName());
        CEFRStats nextStats = nextLevel != null
                ? getCEFRStats(userId, nextLevel.getDisplayName())
                : new CEFRStats(0L, 0L, 0L, 0L, 0.0, 0.0);

        int minWords = getMinWordsRequired(currentLevel);
        double minAccuracy = getMinAccuracyForLevel(currentLevel);
        int minExploration = getMinExplorationWords(currentLevel);
        double minNextAccuracy = getMinNextLevelAccuracy(currentLevel);

        return CEFRProgressResponse.builder()
                .currentLevel(currentLevel.getDisplayName())
                .nextLevel(nextLevel != null ? nextLevel.getDisplayName() : null)
                // Current level stats
                .wordsLearnedAtCurrentLevel(currentStats.totalLearned)
                .wordsRequiredAtCurrentLevel(minWords)
                .masteredAtCurrentLevel(currentStats.masteredCount)
                .masteryRate(currentStats.masteryRate)
                .masteryRateRequired(MIN_MASTERY_RATE)
                .accuracyAtCurrentLevel(currentStats.accuracy)
                .accuracyRequiredAtCurrentLevel(minAccuracy)
                // Next level stats
                .wordsLearnedAtNextLevel(nextStats.totalLearned)
                .wordsRequiredAtNextLevel(minExploration)
                .accuracyAtNextLevel(nextStats.accuracy)
                .accuracyRequiredAtNextLevel(minNextAccuracy)
                // Overall progress
                .canUpgrade(
                        nextLevel != null && checkUpgradeConditions(currentLevel, currentStats, nextStats).canUpgrade)
                .build();
    }

    // Inner classes for data transfer
    private record CEFRStats(
            long totalLearned,
            long masteredCount,
            long totalCorrect,
            long totalWrong,
            double accuracy,
            double masteryRate) {
    }

    private record UpgradeCheckResult(boolean canUpgrade, String reason) {
    }

    @lombok.Builder
    @lombok.Data
    public static class CEFRProgressResponse {
        private String currentLevel;
        private String nextLevel;
        // Current level
        private long wordsLearnedAtCurrentLevel;
        private int wordsRequiredAtCurrentLevel;
        private long masteredAtCurrentLevel;
        private double masteryRate;
        private double masteryRateRequired;
        private double accuracyAtCurrentLevel;
        private double accuracyRequiredAtCurrentLevel;
        // Next level
        private long wordsLearnedAtNextLevel;
        private int wordsRequiredAtNextLevel;
        private double accuracyAtNextLevel;
        private double accuracyRequiredAtNextLevel;
        // Status
        private boolean canUpgrade;
    }
}
