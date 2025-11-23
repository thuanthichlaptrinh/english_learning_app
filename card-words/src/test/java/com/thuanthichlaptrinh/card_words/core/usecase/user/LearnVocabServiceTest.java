package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
import com.thuanthichlaptrinh.card_words.core.domain.Topic;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.domain.UserVocabProgress;
import com.thuanthichlaptrinh.card_words.core.domain.Vocab;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserVocabProgressRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.VocabRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.GetReviewVocabsRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.ReviewVocabRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.PagedReviewVocabResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ReviewResultResponse;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class LearnVocabServiceTest {

    @Mock
    private UserVocabProgressRepository userVocabProgressRepository;

    @Mock
    private VocabRepository vocabRepository;

    @Mock
    private StreakService streakService;

    @InjectMocks
    private LearnVocabService learnVocabService;

    @Test
    @DisplayName("CF-04: getReviewVocabsPaged aggregates progress and stats")
    void getReviewVocabsPaged_shouldReturnProgressAndMetadata() {
        UUID userId = UUID.randomUUID();
        User user = new User();
        user.setId(userId);

        Topic topic = Topic.builder().name("Travel").build();
        topic.setId(1L);

        Vocab vocab = Vocab.builder()
                .word("journey")
                .meaningVi("chuyến đi")
                .types(Set.of())
                .topic(topic)
                .build();
        vocab.setId(UUID.randomUUID());

        UserVocabProgress progress = UserVocabProgress.builder()
                .user(user)
                .vocab(vocab)
                .status(VocabStatus.UNKNOWN)
                .timesCorrect(1)
                .timesWrong(0)
                .build();

        Page<UserVocabProgress> progressPage = new PageImpl<>(
                List.of(progress),
                PageRequest.of(0, 2),
                1);

        when(userVocabProgressRepository.findLearningVocabsPaged(eq(userId), any()))
                .thenReturn(progressPage);
        when(vocabRepository.count()).thenReturn(10L);
        when(userVocabProgressRepository.count()).thenReturn(3L);
        when(userVocabProgressRepository.countByUserIdAndStatus(userId, VocabStatus.NEW)).thenReturn(2L);
        when(userVocabProgressRepository.countByUserIdAndStatus(userId, VocabStatus.UNKNOWN)).thenReturn(1L);
        when(userVocabProgressRepository.countByUserIdAndStatus(userId, VocabStatus.KNOWN)).thenReturn(1L);
        when(userVocabProgressRepository.countByUserIdAndStatus(userId, VocabStatus.MASTERED)).thenReturn(0L);

        GetReviewVocabsRequest request = GetReviewVocabsRequest.builder()
                .page(1)
                .size(2)
                .build();

        PagedReviewVocabResponse response = learnVocabService.getReviewVocabsPaged(user, request);

        assertThat(response.getVocabs()).hasSize(1);
        assertThat(response.getVocabs().get(0).getWord()).isEqualTo("journey");
        assertThat(response.getVocabs().get(0).getStatus()).isEqualTo(VocabStatus.UNKNOWN);

        PagedReviewVocabResponse.PageMetadata meta = response.getMeta();
        assertThat(meta.getTotalItems()).isEqualTo(1);
        assertThat(meta.getTotalPages()).isEqualTo(1);
        assertThat(meta.getPage()).isEqualTo(1);
        assertThat(meta.getNewVocabs()).isEqualTo(7); // total 10 - learned 3
        assertThat(meta.getLearningVocabs()).isEqualTo(3); // NEW(2) + UNKNOWN(1)
        assertThat(meta.getMasteredVocabs()).isEqualTo(0);
        assertThat(meta.getHasNext()).isFalse();
        assertThat(meta.getHasPrev()).isTrue();
    }

    @Test
    @DisplayName("CF-05: submitReview updates spaced repetition stats")
    void submitReview_whenCorrect_shouldPromoteStatusAndIncrementCounters() {
        UUID userId = UUID.randomUUID();
        UUID vocabId = UUID.randomUUID();
        User user = new User();
        user.setId(userId);

        Vocab vocab = Vocab.builder()
                .word("explore")
                .meaningVi("khám phá")
                .types(Set.of())
                .build();
        vocab.setId(vocabId);

        UserVocabProgress progress = UserVocabProgress.builder()
                .user(user)
                .vocab(vocab)
                .status(VocabStatus.UNKNOWN)
                .timesCorrect(1)
                .timesWrong(2)
                .repetition(1)
                .intervalDays(2)
                .efFactor(2.5)
                .nextReviewDate(LocalDate.now())
                .build();

        when(userVocabProgressRepository.findByUserIdAndVocabId(userId, vocabId))
                .thenReturn(Optional.of(progress));
        when(userVocabProgressRepository.save(any())).thenAnswer(invocation -> invocation.getArgument(0));

        ReviewVocabRequest request = ReviewVocabRequest.builder()
                .vocabId(vocabId)
                .isCorrect(true)
                .quality(5)
                .build();

        doNothing().when(streakService).recordActivity(user);

        ReviewResultResponse response = learnVocabService.submitReview(user, request);

        assertThat(response.getTimesCorrect()).isEqualTo(2);
        assertThat(response.getStatus()).isEqualTo(VocabStatus.KNOWN);
        assertThat(response.getNextReviewDate()).isAfterOrEqualTo(LocalDate.now());
        assertThat(response.getIntervalDays()).isGreaterThanOrEqualTo(1);

        ArgumentCaptor<UserVocabProgress> captor = ArgumentCaptor.forClass(UserVocabProgress.class);
        verify(userVocabProgressRepository).save(captor.capture());
        assertThat(captor.getValue().getTimesCorrect()).isEqualTo(2);
        assertThat(captor.getValue().getStatus()).isEqualTo(VocabStatus.KNOWN);

        verify(streakService).recordActivity(user);
    }
}