package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.domain.UserVocabProgress;
import com.thuanthichlaptrinh.card_words.core.mapper.UserVocabProgressMapper;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserVocabProgressRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.DailyVocabStatsResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.UserVocabProgressResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.UserVocabStatsResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.vocab.VocabStatsByCEFRResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.format.TextStyle;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserVocabProgressService {

    private final UserVocabProgressRepository userVocabProgressRepository;
    private final UserRepository userRepository;
    private final UserVocabProgressMapper userVocabProgressMapper;

    private static final ZoneId VIETNAM_ZONE = ZoneId.of("Asia/Ho_Chi_Minh");

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
        Long known = userVocabProgressRepository.countByUserIdAndStatus(userId, VocabStatus.KNOWN);
        Long unknown = userVocabProgressRepository.countByUserIdAndStatus(userId, VocabStatus.UNKNOWN);
        Long newStatus = userVocabProgressRepository.countByUserIdAndStatus(userId, VocabStatus.NEW);

        if (mastered == null)
            mastered = 0L;
        if (known == null)
            known = 0L;
        if (unknown == null)
            unknown = 0L;
        if (newStatus == null)
            newStatus = 0L;

        long learning = newStatus + known + unknown;
        long untrackedVocabs = userVocabProgressRepository.countAllUnlearnedVocabs(userId);
        long vocabsNew = newStatus + untrackedVocabs;

        long totalTrackedVocabs = learning + mastered;

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ErrorException("Không tìm thấy người dùng"));

        LocalDate signupDate = user.getCreatedAt().toLocalDate();
        long totalDaysParticipated = Math.max(1, ChronoUnit.DAYS.between(signupDate, LocalDate.now()) + 1);
        double dailyAverage = totalTrackedVocabs == 0 ? 0.0
                : Math.ceil((double) totalTrackedVocabs / totalDaysParticipated);

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
                .dailyAverage(dailyAverage)
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

        LocalDate today = LocalDate.now(VIETNAM_ZONE);
        LocalDate startDate = today.minusDays(6); // 7 ngày gần nhất bao gồm hôm nay

        // Quy đổi mốc 00:00 VN về UTC để query dữ liệu đúng múi giờ lưu trữ
        LocalDateTime startDateTimeUtc = startDate
                .atStartOfDay(VIETNAM_ZONE)
                .withZoneSameInstant(ZoneOffset.UTC)
                .toLocalDateTime();

        List<LocalDateTime> createdAtList = userVocabProgressRepository.findCreatedAtSince(userId,
                startDateTimeUtc);

        // Map ngày theo múi giờ VN -> số từ
        Map<LocalDate, Long> countByDate = createdAtList.stream()
                .map(dt -> dt.atZone(ZoneOffset.UTC)
                        .withZoneSameInstant(VIETNAM_ZONE)
                        .toLocalDate())
                .collect(Collectors.groupingBy(date -> date, Collectors.counting()));

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

    /**
     * Lấy thống kê số từ vựng đã học theo cấp bậc CEFR
     * 
     * @param userId ID của user
     * @return Thống kê số từ theo từng cấp bậc CEFR (A1, A2, B1, B2, C1, C2)
     */
    @Transactional(readOnly = true)
    public VocabStatsByCEFRResponse getVocabStatsByCEFR(UUID userId) {
        log.info("Getting vocab stats by CEFR for user: {}", userId);

        List<Object[]> rawResults = userVocabProgressRepository.countVocabsLearnedByCEFR(userId);

        Map<String, Long> statsMap = new java.util.LinkedHashMap<>();

        String[] cefrLevels = { "A1", "A2", "B1", "B2", "C1", "C2" };
        for (String level : cefrLevels) {
            statsMap.put(level, 0L);
        }

        // Fill dữ liệu thực tế
        long total = 0L;
        for (Object[] row : rawResults) {
            String cefr = (String) row[0];
            Long count = (Long) row[1];

            if (cefr != null && count != null) {
                statsMap.put(cefr.toUpperCase(), count);
                total += count;
            }
        }

        log.info("Retrieved CEFR stats for user {}: total={} words", userId, total);

        return VocabStatsByCEFRResponse.builder()
                .stats(statsMap)
                .total(total)
                .build();
    }

}