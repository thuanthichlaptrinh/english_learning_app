package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
import com.thuanthichlaptrinh.card_words.core.domain.UserVocabProgress;
import com.thuanthichlaptrinh.card_words.core.mapper.UserVocabProgressMapper;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserVocabProgressRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.DailyVocabStatsResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.UserVocabProgressResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.UserVocabStatsResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.TextStyle;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserVocabProgressService {

    private final UserVocabProgressRepository userVocabProgressRepository;
    private final UserVocabProgressMapper userVocabProgressMapper;

    // Get all vocabs learned by user
    @Transactional(readOnly = true)
    public List<UserVocabProgressResponse> getAllLearnedVocabs(UUID userId) {
        log.info("Getting all learned vocabs for user: {}", userId);

        List<UserVocabProgress> progressList = userVocabProgressRepository.findByUserIdWithVocab(userId);

        return progressList.stream()
                .map(userVocabProgressMapper::toUserVocabProgressResponse)
                .collect(Collectors.toList());
    }

    // Get only correct vocabs (timesCorrect > 0)
    @Transactional(readOnly = true)
    public List<UserVocabProgressResponse> getCorrectVocabs(UUID userId) {
        log.info("Getting correct vocabs for user: {}", userId);

        List<UserVocabProgress> progressList = userVocabProgressRepository.findCorrectVocabsByUserId(userId);

        return progressList.stream()
                .map(userVocabProgressMapper::toUserVocabProgressResponse)
                .collect(Collectors.toList());
    }

    // Get only wrong vocabs (timesWrong > 0)
    @Transactional(readOnly = true)
    public List<UserVocabProgressResponse> getWrongVocabs(UUID userId) {
        log.info("Getting wrong vocabs for user: {}", userId);

        List<UserVocabProgress> progressList = userVocabProgressRepository.findWrongVocabsByUserId(userId);

        return progressList.stream()
                .map(userVocabProgressMapper::toUserVocabProgressResponse)
                .collect(Collectors.toList());
    }

    // Get user vocabulary statistics
    @Transactional(readOnly = true)
    public UserVocabStatsResponse getUserStats(UUID userId) {
        log.info("Getting vocabulary stats for user: {}", userId);

        Long totalCorrect = userVocabProgressRepository.countTotalCorrectAttempts(userId);
        Long totalWrong = userVocabProgressRepository.countTotalWrongAttempts(userId);

        if (totalCorrect == null)
            totalCorrect = 0L;
        if (totalWrong == null)
            totalWrong = 0L;

        Long totalAttempts = totalCorrect + totalWrong;
        Double overallAccuracy = totalAttempts > 0 ? (totalCorrect * 100.0 / totalAttempts) : 0.0;

        Long totalLearned = userVocabProgressRepository.countLearnedVocabs(userId);
        Long mastered = userVocabProgressRepository.countByUserIdAndStatus(userId, VocabStatus.MASTERED);
        // learning = KNOWN + UNKNOWN (chưa đạt MASTERED)
        Long known = userVocabProgressRepository.countByUserIdAndStatus(userId, VocabStatus.KNOWN);
        Long unknown = userVocabProgressRepository.countByUserIdAndStatus(userId, VocabStatus.UNKNOWN);
        Long learning = known + unknown;
        Long vocabsNew = userVocabProgressRepository.countByUserIdAndStatus(userId, VocabStatus.NEW);

        List<UserVocabProgress> dueVocabs = userVocabProgressRepository.findDueForReview(userId, LocalDate.now());

        return UserVocabStatsResponse.builder()
                .totalVocabsLearned(totalLearned)
                .totalCorrect(totalCorrect)
                .totalWrong(totalWrong)
                .totalAttempts(totalAttempts)
                .overallAccuracy(Math.round(overallAccuracy * 100.0) / 100.0)
                .vocabsMastered(mastered)
                .vocabsLearning(learning)
                .vocabsNew(vocabsNew)
                .vocabsDueForReview((long) dueVocabs.size())
                .build();
    }

    // Get vocabs due for review today
    @Transactional(readOnly = true)
    public List<UserVocabProgressResponse> getVocabsDueForReview(UUID userId) {
        log.info("Getting vocabs due for review for user: {}", userId);

        List<UserVocabProgress> progressList = userVocabProgressRepository.findDueForReview(userId, LocalDate.now());

        return progressList.stream()
                .map(userVocabProgressMapper::toUserVocabProgressResponse)
                .collect(Collectors.toList());
    }

    // Get vocabs learned today
    @Transactional(readOnly = true)
    public List<UserVocabProgressResponse> getVocabsLearnedToday(UUID userId) {
        log.info("Getting vocabs learned today for user: {}", userId);

        List<UserVocabProgress> progressList = userVocabProgressRepository.findLearnedVocabsByDate(userId,
                LocalDate.now());

        return progressList.stream()
                .map(userVocabProgressMapper::toUserVocabProgressResponse)
                .collect(Collectors.toList());
    }

    /**
     * Lấy thống kê số từ vựng đã học trong 7 ngày gần nhất
     * 
     * @param userId ID của user
     * @return Danh sách thống kê theo ngày (7 ngày gần nhất, bao gồm cả ngày không
     *         có từ học)
     */
    @Transactional(readOnly = true)
    public List<DailyVocabStatsResponse> getVocabStatsLast7Days(UUID userId) {
        log.info("Getting vocab stats for last 7 days for user: {}", userId);

        LocalDate today = LocalDate.now();
        LocalDate startDate = today.minusDays(6); // 7 ngày gần nhất bao gồm hôm nay

        // Convert to LocalDateTime (start of day)
        LocalDateTime startDateTime = startDate.atStartOfDay();

        // Lấy dữ liệu từ database
        List<Object[]> rawResults = userVocabProgressRepository.countVocabsLearnedByDateForLast7Days(userId,
                startDateTime);

        // Chuyển thành Map để dễ tra cứu (date -> count)
        Map<LocalDate, Long> countByDate = rawResults.stream()
                .collect(Collectors.toMap(
                        arr -> (LocalDate) arr[0],
                        arr -> (Long) arr[1]));

        // Tạo response cho đủ 7 ngày (kể cả ngày không có dữ liệu)
        List<DailyVocabStatsResponse> response = new ArrayList<>();
        for (int i = 6; i >= 0; i--) {
            LocalDate date = today.minusDays(i);
            Long count = countByDate.getOrDefault(date, 0L);
            String dayName = date.getDayOfWeek().getDisplayName(TextStyle.FULL, Locale.ENGLISH);

            response.add(DailyVocabStatsResponse.builder()
                    .date(date)
                    .dayName(dayName)
                    .count(count)
                    .build());
        }

        log.info("Retrieved stats for {} days, total records: {}", response.size(),
                response.stream().mapToLong(DailyVocabStatsResponse::getCount).sum());
        return response;
    }

}