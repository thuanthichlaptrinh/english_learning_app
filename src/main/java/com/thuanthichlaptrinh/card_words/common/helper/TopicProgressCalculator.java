package com.thuanthichlaptrinh.card_words.common.helper;

import java.util.UUID;

import org.springframework.stereotype.Component;

import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserVocabProgressRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.VocabRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * Utility component để tính toán tiến độ học từ vựng theo topic
 * Component này có thể được tái sử dụng ở nhiều nơi khác nhau
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class TopicProgressCalculator {

    private final VocabRepository vocabRepository;
    private final UserVocabProgressRepository userVocabProgressRepository;

    /**
     * Tính % tiến độ học từ vựng của user trong một topic
     * Progress = (Số từ có trong user_vocab_progress / Tổng số từ trong topic) ×
     * 100
     * 
     * @param userId  ID của user
     * @param topicId ID của topic
     * @return Phần trăm tiến độ (0.0 - 100.0), trả về 0.0 nếu topic không có từ
     *         vựng
     */
    public Double calculateTopicProgress(UUID userId, Long topicId) {
        // Đếm tổng số từ vựng trong topic
        long totalVocabs = vocabRepository.countByTopicId(topicId);

        if (totalVocabs == 0) {
            log.debug("Topic {} không có từ vựng nào", topicId);
            return 0.0;
        }

        // Đếm số từ vựng có trong bảng user_vocab_progress của user trong topic này
        // (tất cả từ đã xuất hiện trong progress, không phân biệt status)
        long vocabsInProgress = userVocabProgressRepository.countLearnedVocabsByUserAndTopic(userId, topicId);

        // Tính phần trăm
        double progress = (vocabsInProgress * 100.0) / totalVocabs;

        log.debug("Topic {} progress cho user {}: {}/{} = {}%",
                topicId, userId, vocabsInProgress, totalVocabs, String.format("%.2f", progress));

        return Math.round(progress * 100.0) / 100.0; // Làm tròn đến 2 chữ số thập phân
    }

    /**
     * Kiểm tra xem user có hoàn thành topic hay chưa
     * Topic được coi là hoàn thành khi tất cả từ vựng đã có trong
     * user_vocab_progress
     * 
     * @param userId  ID của user
     * @param topicId ID của topic
     * @return true nếu tất cả từ vựng trong topic đã xuất hiện trong
     *         user_vocab_progress
     */
    public boolean isTopicCompleted(UUID userId, Long topicId) {
        long totalVocabs = vocabRepository.countByTopicId(topicId);
        if (totalVocabs == 0) {
            return false;
        }

        long vocabsInProgress = userVocabProgressRepository.countLearnedVocabsByUserAndTopic(userId, topicId);
        return vocabsInProgress >= totalVocabs;
    }

    /**
     * Lấy số lượng từ vựng trong user_vocab_progress và tổng số từ vựng trong topic
     * 
     * @param userId  ID của user
     * @param topicId ID của topic
     * @return Mảng [vocabsInProgress, totalVocabs]
     */
    public long[] getTopicProgressCounts(UUID userId, Long topicId) {
        long totalVocabs = vocabRepository.countByTopicId(topicId);
        long vocabsInProgress = userVocabProgressRepository.countLearnedVocabsByUserAndTopic(userId, topicId);

        return new long[] { vocabsInProgress, totalVocabs };
    }
}
