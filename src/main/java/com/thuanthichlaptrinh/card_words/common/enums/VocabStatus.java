package com.thuanthichlaptrinh.card_words.common.enums;

/**
 * Trạng thái học tập của từ vựng
 */
public enum VocabStatus {
    /**
     * Từ mới - chưa có trong bảng user_vocab_progress
     */
    NEW,

    /**
     * Đã thuộc - user đã click "Đã thuộc"
     */
    KNOWN,

    /**
     * Chưa thuộc - user đã click "Chưa thuộc"
     */
    UNKNOWN,

    /**
     * Thành thạo - tự động tính dựa trên:
     * - timesCorrect >= 10
     * - timesWrong <= 2
     * - Tỷ lệ đúng >= 80%
     */
    MASTERED
}
