package com.thuanthichlaptrinh.card_words.core.usecase.admin;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.UserVocabProgress;
import com.thuanthichlaptrinh.card_words.core.mapper.VocabProgressAdminMapper;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserVocabProgressRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.DifficultWordResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.OverallProgressStatsResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.UserVocabProgressAdminResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.VocabLearningStatsResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class VocabProgressAdminService {

    private final UserVocabProgressRepository progressRepository;
    private final UserRepository userRepository;
    private final VocabProgressAdminMapper vocabProgressAdminMapper;

    // Lấy tiến độ học từ vựng của một user
    public Page<UserVocabProgressAdminResponse> getUserProgress(UUID userId, int page, int size) {
        log.info("Admin: Getting vocab progress for user: {}", userId);

        if (!userRepository.existsById(userId)) {
            throw new ErrorException("Không tìm thấy người dùng");
        }

        Pageable pageable = PageRequest.of(page, size, Sort.by("updatedAt").descending());
        Page<UserVocabProgress> progress = progressRepository.findByUserId(userId, pageable);

        return progress.map(vocabProgressAdminMapper::toUserVocabProgressAdminResponse);
    }

    // Lấy thống kê học tập của một từ vựng
    public VocabLearningStatsResponse getVocabLearningStats(UUID vocabId) {
        log.info("Admin: Getting learning stats for vocab: {}", vocabId);

        List<UserVocabProgress> allProgress = progressRepository.findByVocabId(vocabId);

        long totalLearners = allProgress.size();
        int totalCorrect = allProgress.stream()
                .mapToInt(UserVocabProgress::getTimesCorrect)
                .sum();
        int totalWrong = allProgress.stream()
                .mapToInt(UserVocabProgress::getTimesWrong)
                .sum();
        int totalAttempts = totalCorrect + totalWrong;
        double accuracy = totalAttempts > 0 ? (totalCorrect * 100.0 / totalAttempts) : 0;

        return VocabLearningStatsResponse.builder()
                .vocabId(vocabId)
                .totalLearners(totalLearners)
                .totalCorrect(totalCorrect)
                .totalWrong(totalWrong)
                .totalAttempts(totalAttempts)
                .accuracy(accuracy)
                .build();
    }

    // Lấy tổng quan tiến độ học toàn hệ thống
    public OverallProgressStatsResponse getOverallStats() {
        log.info("Admin: Getting overall progress statistics");

        long totalProgressRecords = progressRepository.count();
        Long totalCorrectSum = progressRepository.sumAllTimesCorrect();
        Long totalWrongSum = progressRepository.sumAllTimesWrong();

        long totalCorrect = totalCorrectSum != null ? totalCorrectSum : 0;
        long totalWrong = totalWrongSum != null ? totalWrongSum : 0;
        long totalAttempts = totalCorrect + totalWrong;
        double overallAccuracy = totalAttempts > 0 ? (totalCorrect * 100.0 / totalAttempts) : 0;

        return OverallProgressStatsResponse.builder()
                .totalProgressRecords(totalProgressRecords)
                .totalCorrect(totalCorrect)
                .totalWrong(totalWrong)
                .totalAttempts(totalAttempts)
                .overallAccuracy(overallAccuracy)
                .build();
    }

    // Lấy danh sách từ khó nhất (tỷ lệ sai cao)
    public List<DifficultWordResponse> getDifficultWords(int limit) {
        log.info("Admin: Getting {} most difficult words", limit);

        List<UserVocabProgress> allProgress = progressRepository.findAll();

        // Group by vocab and calculate error rate
        var vocabStats = allProgress.stream()
                .collect(java.util.stream.Collectors.groupingBy(
                        p -> p.getVocab(),
                        java.util.stream.Collectors.collectingAndThen(
                                java.util.stream.Collectors.toList(),
                                list -> {
                                    int correct = list.stream()
                                            .mapToInt(UserVocabProgress::getTimesCorrect).sum();
                                    int wrong = list.stream()
                                            .mapToInt(UserVocabProgress::getTimesWrong).sum();
                                    int total = correct + wrong;
                                    double errorRate = total > 0 ? (wrong * 100.0 / total) : 0;
                                    return new Object[] { list.size(), correct, wrong, errorRate };
                                })));

        return vocabStats.entrySet().stream()
                .filter(entry -> {
                    Object[] stats = (Object[]) entry.getValue();
                    int total = (int) stats[1] + (int) stats[2];
                    return total >= 5; // Chỉ lấy từ có ít nhất 5 lần thử
                })
                .sorted((e1, e2) -> {
                    double rate1 = (double) ((Object[]) e1.getValue())[3];
                    double rate2 = (double) ((Object[]) e2.getValue())[3];
                    return Double.compare(rate2, rate1); // Sắp xếp giảm dần
                })
                .limit(limit)
                .map(entry -> {
                    var vocab = entry.getKey();
                    Object[] stats = (Object[]) entry.getValue();
                    return DifficultWordResponse.builder()
                            .vocabId(vocab.getId())
                            .word(vocab.getWord())
                            .meaningVi(vocab.getMeaningVi())
                            .cefr(vocab.getCefr())
                            .learnerCount((int) stats[0])
                            .timesCorrect((int) stats[1])
                            .timesWrong((int) stats[2])
                            .errorRate((double) stats[3])
                            .build();
                })
                .toList();
    }

    // Xóa một bản ghi tiến độ học từ vựng
    @Transactional
    public void deleteProgress(UUID id) {
        log.info("Admin: Deleting progress record: {}", id);

        if (!progressRepository.existsById(id)) {
            throw new ErrorException("Không tìm thấy bản ghi tiến độ");
        }

        progressRepository.deleteById(id);
    }

    // Reset toàn bộ tiến độ của một user
    @Transactional
    public void resetUserProgress(UUID userId) {
        log.info("Admin: Resetting all progress for user: {}", userId);

        if (!userRepository.existsById(userId)) {
            throw new ErrorException("Không tìm thấy người dùng");
        }

        progressRepository.deleteByUserId(userId);
    }
}
