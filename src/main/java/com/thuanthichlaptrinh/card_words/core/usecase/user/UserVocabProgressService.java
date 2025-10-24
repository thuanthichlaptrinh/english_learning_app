package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.core.domain.UserVocabProgress;
import com.thuanthichlaptrinh.card_words.core.mapper.UserVocabProgressMapper;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserVocabProgressRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.UserVocabProgressResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.UserVocabStatsResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
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
        Long mastered = userVocabProgressRepository.countByUserIdAndStatus(userId, "MASTERED");
        Long learning = userVocabProgressRepository.countByUserIdAndStatus(userId, "LEARNING");
        Long vocabsNew = userVocabProgressRepository.countByUserIdAndStatus(userId, "NEW");

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

}