package com.thuanthichlaptrinh.card_words.common.utils;

import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
import com.thuanthichlaptrinh.card_words.core.domain.UserVocabProgress;
import lombok.extern.slf4j.Slf4j;

/**
 * Utility class để tính toán và quản lý VocabStatus
 * Sử dụng trong 3 game: Quick Quiz, Image-Word Matching, Word-Definition
 * Matching
 */
@Slf4j
public class VocabStatusCalculator {

    // Điều kiện để đạt MASTERED
    private static final int MIN_CORRECT_FOR_MASTERED = 10;
    private static final int MAX_WRONG_FOR_MASTERED = 2;
    private static final double MIN_ACCURACY_FOR_MASTERED = 0.8; // 80%

    /**
     * Tính status mới cho vocab progress dựa trên kết quả game
     *
     * Logic:
     * - Nếu đã MASTERED → giữ nguyên (không downgrade)
     * - Nếu đạt điều kiện MASTERED → upgrade lên MASTERED
     * - Nếu là record mới (currentStatus = null) → set NEW
     * - Nếu không đủ điều kiện MASTERED → giữ nguyên status hiện tại
     *
     * @param currentStatus Status hiện tại (có thể null nếu mới tạo)
     * @param timesCorrect  Tổng số lần đúng
     * @param timesWrong    Tổng số lần sai
     * @return Status mới phù hợp
     */
    public static VocabStatus calculateStatus(
            VocabStatus currentStatus,
            int timesCorrect,
            int timesWrong) {

        // 1. Nếu đã MASTERED → giữ nguyên (không downgrade)
        if (currentStatus == VocabStatus.MASTERED) {
            log.debug("Status is already MASTERED, keeping it");
            return VocabStatus.MASTERED;
        }

        // 2. Kiểm tra điều kiện MASTERED
        if (isMastered(timesCorrect, timesWrong)) {
            log.info("Vocab達到 MASTERED condition: correct={}, wrong={}, accuracy={}%",
                    timesCorrect, timesWrong, calculateAccuracy(timesCorrect, timesWrong) * 100);
            return VocabStatus.MASTERED;
        }

        // 3. Nếu là record mới (currentStatus = null) → set NEW
        if (currentStatus == null) {
            log.debug("New record, setting status to NEW");
            return VocabStatus.NEW;
        }

        // 4. Giữ nguyên status hiện tại (NEW, KNOWN, UNKNOWN)
        log.debug("Keeping current status: {}", currentStatus);
        return currentStatus;
    }

    /**
     * Kiểm tra có đạt điều kiện MASTERED không
     *
     * Điều kiện:
     * - timesCorrect >= 10
     * - timesWrong <= 2
     * - accuracy >= 80%
     *
     * @param timesCorrect Số lần trả lời đúng
     * @param timesWrong   Số lần trả lời sai
     * @return true nếu đạt điều kiện MASTERED
     */
    public static boolean isMastered(int timesCorrect, int timesWrong) {
        // Phải có ít nhất 10 lần đúng
        if (timesCorrect < MIN_CORRECT_FOR_MASTERED) {
            return false;
        }

        // Số lần sai không quá 2
        if (timesWrong > MAX_WRONG_FOR_MASTERED) {
            return false;
        }

        // Tính accuracy
        int totalAttempts = timesCorrect + timesWrong;
        if (totalAttempts == 0) {
            return false;
        }

        double accuracy = (double) timesCorrect / totalAttempts;
        return accuracy >= MIN_ACCURACY_FOR_MASTERED;
    }

    /**
     * Tính accuracy từ timesCorrect và timesWrong
     *
     * @param timesCorrect Số lần đúng
     * @param timesWrong   Số lần sai
     * @return Accuracy từ 0.0 đến 1.0
     */
    public static double calculateAccuracy(int timesCorrect, int timesWrong) {
        int total = timesCorrect + timesWrong;
        if (total == 0) {
            return 0.0;
        }
        return (double) timesCorrect / total;
    }

    /**
     * Tính accuracy từ UserVocabProgress
     *
     * @param progress UserVocabProgress object
     * @return Accuracy từ 0.0 đến 1.0
     */
    public static double calculateAccuracy(UserVocabProgress progress) {
        if (progress == null) {
            return 0.0;
        }
        return calculateAccuracy(progress.getTimesCorrect(), progress.getTimesWrong());
    }

    /**
     * Kiểm tra xem vocab progress có đủ điều kiện để được coi là "đã học" không
     *
     * @param progress UserVocabProgress object
     * @return true nếu đã có ít nhất 1 attempt
     */
    public static boolean isLearned(UserVocabProgress progress) {
        if (progress == null) {
            return false;
        }
        return (progress.getTimesCorrect() + progress.getTimesWrong()) > 0;
    }

    /**
     * Format accuracy thành percentage string
     *
     * @param timesCorrect Số lần đúng
     * @param timesWrong   Số lần sai
     * @return String dạng "80.5%"
     */
    public static String formatAccuracy(int timesCorrect, int timesWrong) {
        double accuracy = calculateAccuracy(timesCorrect, timesWrong);
        return String.format("%.1f%%", accuracy * 100);
    }

    /**
     * Get description của status hiện tại
     *
     * @param status VocabStatus
     * @return Mô tả tiếng Việt
     */
    public static String getStatusDescription(VocabStatus status) {
        if (status == null) {
            return "Chưa học";
        }

        switch (status) {
            case NEW:
                return "Từ mới";
            case KNOWN:
                return "Đã biết";
            case UNKNOWN:
                return "Chưa biết";
            case MASTERED:
                return "Đã thành thạo";
            default:
                return "Không xác định";
        }
    }
}
