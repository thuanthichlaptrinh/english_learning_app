package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
import com.thuanthichlaptrinh.card_words.core.domain.*;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.*;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.offline.*;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.offline.TopicProgressResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.offline.VocabWithProgressResponse;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class OfflineSyncServiceTest {

    @Mock
    private TopicRepository topicRepository;

    @Mock
    private VocabRepository vocabRepository;

    @Mock
    private UserVocabProgressRepository userVocabProgressRepository;

    @Mock
    private GameSessionRepository gameSessionRepository;

    @Mock
    private GameSessionDetailRepository gameSessionDetailRepository;

    @Mock
    private GameRepository gameRepository;

    @InjectMocks
    private OfflineSyncService offlineSyncService;

    @Test
    @DisplayName("CF-12: getTopicsWithProgress counts only KNOWN/MASTERED vocabs")
    void getTopicsWithProgress_shouldCalculatePercentageFromLearnedStatuses() {
        UUID userId = UUID.randomUUID();
        Topic travel = buildTopic(1L, "Travel");
        Topic animals = buildTopic(2L, "Animals");

        Vocab plane = buildVocab(UUID.randomUUID(), travel, "plane");
        Vocab hotel = buildVocab(UUID.randomUUID(), travel, "hotel");
        Vocab ticket = buildVocab(UUID.randomUUID(), travel, "ticket");

        when(topicRepository.findAll()).thenReturn(List.of(travel, animals));
        when(vocabRepository.findByTopicNameIgnoreCase("Travel"))
                .thenReturn(List.of(plane, hotel, ticket));
        when(vocabRepository.findByTopicNameIgnoreCase("Animals"))
                .thenReturn(Collections.emptyList());
        when(userVocabProgressRepository.findByUserIdAndVocabId(userId, plane.getId()))
                .thenReturn(Optional.of(buildProgress(userId, plane, VocabStatus.KNOWN)));
        when(userVocabProgressRepository.findByUserIdAndVocabId(userId, hotel.getId()))
                .thenReturn(Optional.of(buildProgress(userId, hotel, VocabStatus.MASTERED)));
        when(userVocabProgressRepository.findByUserIdAndVocabId(userId, ticket.getId()))
                .thenReturn(Optional.of(buildProgress(userId, ticket, VocabStatus.UNKNOWN)));

        List<TopicProgressResponse> responses = offlineSyncService.getTopicsWithProgress(userId);

        assertThat(responses).hasSize(2);
        TopicProgressResponse travelProgress = responses.stream()
                .filter(resp -> Objects.equals(resp.getId(), travel.getId()))
                .findFirst()
                .orElseThrow();
        TopicProgressResponse animalsProgress = responses.stream()
                .filter(resp -> Objects.equals(resp.getId(), animals.getId()))
                .findFirst()
                .orElseThrow();

        assertThat(travelProgress.getProgressPercent()).isEqualTo(66.67);
        assertThat(animalsProgress.getProgressPercent()).isZero();
    }

    @Test
    @DisplayName("CF-13: getVocabsByTopic returns vocab metadata with topic info")
    void getVocabsByTopic_shouldReturnMappedResponses() {
        UUID userId = UUID.randomUUID();
        Long topicId = 10L;
        Topic topic = buildTopic(topicId, "Space");
        Vocab vocab = buildVocab(UUID.randomUUID(), topic, "orbit");

        when(topicRepository.findById(topicId)).thenReturn(Optional.of(topic));
        when(vocabRepository.findByTopicNameIgnoreCase(topic.getName()))
                .thenReturn(List.of(vocab));

        List<VocabWithProgressResponse> responses = offlineSyncService.getVocabsByTopic(userId, topicId);

        assertThat(responses).hasSize(1);
        VocabWithProgressResponse response = responses.get(0);
        assertThat(response.getId()).isEqualTo(vocab.getId());
        assertThat(response.getWord()).isEqualTo("orbit");
        assertThat(response.getTopic().getId()).isEqualTo(topicId);
        assertThat(response.getTopic().getName()).isEqualTo("Space");
    }

    @Test
    @DisplayName("CF-13: getVocabsByTopic throws when topic does not exist")
    void getVocabsByTopic_whenTopicMissing_shouldThrow() {
        UUID userId = UUID.randomUUID();
        Long topicId = 99L;
        when(topicRepository.findById(topicId)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> offlineSyncService.getVocabsByTopic(userId, topicId))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Topic not found");
    }

    @Test
    @DisplayName("CF-14: syncBatch persists sessions, details and manual progress")
    void syncBatch_validPayload_shouldCountAllEntities() {
        UUID userId = UUID.randomUUID();
        Long gameId = 5L;
        UUID vocabId = UUID.randomUUID();
        Topic topic = buildTopic(7L, "Technology");
        Vocab vocab = buildVocab(vocabId, topic, "circuit");
        User user = new User();
        user.setId(userId);

        LocalDateTime firstStart = LocalDateTime.of(2025, 1, 5, 8, 0);
        OfflineGameSessionRequest primarySession = OfflineGameSessionRequest.builder()
                .sessionId("session-primary")
                .gameId(gameId)
                .startedAt(firstStart.toString())
                .finishedAt(firstStart.plusMinutes(2).toString())
                .totalQuestions(5)
                .correctCount(4)
                .score(420)
                .build();
        OfflineGameSessionRequest duplicateSession = OfflineGameSessionRequest.builder()
                .sessionId("session-dup")
                .gameId(gameId)
                .startedAt(firstStart.plusSeconds(1).toString())
                .finishedAt(firstStart.plusMinutes(3).toString())
                .totalQuestions(4)
                .correctCount(2)
                .score(180)
                .build();
        OfflineGameDetailRequest detail = OfflineGameDetailRequest.builder()
                .sessionId(primarySession.getSessionId())
                .vocabId(vocabId)
                .questionNumber(1)
                .userAnswer("answer")
                .correctAnswer("answer")
                .isCorrect(true)
                .timeTaken(1800)
                .build();
        OfflineVocabProgressRequest manualProgress = OfflineVocabProgressRequest.builder()
                .vocabId(vocabId)
                .status(VocabStatus.KNOWN)
                .lastReviewedAt(LocalDateTime.of(2025, 1, 4, 9, 0).toString())
                .nextReviewAt(LocalDateTime.of(2025, 1, 7, 9, 0).toString())
                .easeFactor(2.6)
                .repetitions(3)
                .interval(6)
                .timesCorrect(5)
                .timesWrong(1)
                .build();
        BatchSyncRequest request = BatchSyncRequest.builder()
                .clientId("device-01")
                .gameSessions(List.of(primarySession, duplicateSession))
                .gameSessionDetails(List.of(detail))
                .vocabProgress(List.of(manualProgress))
                .build();

        Game game = Game.builder().name("Quick Reflex Quiz").build();
        game.setId(gameId);
        when(gameRepository.findById(gameId)).thenReturn(Optional.of(game));
        when(gameSessionRepository.findByGameIdAndUserIdOrderByStartedAtDesc(gameId, userId))
                .thenReturn(Collections.emptyList())
                .thenReturn(List.of(GameSession.builder()
                        .startedAt(LocalDateTime.parse(duplicateSession.getStartedAt()))
                        .build()));
        when(gameSessionRepository.save(any(GameSession.class))).thenAnswer(invocation -> {
            GameSession session = invocation.getArgument(0);
            session.setId(UUID.randomUUID());
            return session;
        });
        when(vocabRepository.findById(vocabId)).thenReturn(Optional.of(vocab));
        UserVocabProgress existingProgress = UserVocabProgress.builder()
                .user(user)
                .vocab(vocab)
                .status(VocabStatus.NEW)
                .timesCorrect(1)
                .timesWrong(0)
                .efFactor(2.5)
                .intervalDays(1)
                .repetition(0)
                .lastReviewed(LocalDate.now())
                .nextReviewDate(LocalDate.now().plusDays(1))
                .build();
        when(userVocabProgressRepository.findByUserIdAndVocabId(userId, vocabId))
                .thenReturn(Optional.of(existingProgress))
                .thenReturn(Optional.empty());
        when(gameSessionDetailRepository.save(any(GameSessionDetail.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));
        when(userVocabProgressRepository.save(any(UserVocabProgress.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        Map<String, Object> result = offlineSyncService.syncBatch(userId, request);

        assertThat(result.get("syncedGameSessions")).isEqualTo(1);
        assertThat(result.get("syncedGameSessionDetails")).isEqualTo(1);
        assertThat(result.get("syncedVocabProgress")).isEqualTo(1);
        assertThat(result.get("skippedDuplicates")).isEqualTo(1);
        assertThat((List<?>) result.get("errors")).isEmpty();
        assertThat(result.get("serverTimestamp")).isInstanceOf(String.class);

        verify(gameSessionRepository, times(1)).save(any(GameSession.class));
        verify(gameSessionDetailRepository, times(1)).save(any(GameSessionDetail.class));
        verify(userVocabProgressRepository, times(2)).save(any(UserVocabProgress.class));
    }

    @Test
    @DisplayName("CF-15: syncBatch skips already-synced sessions without persisting")
    void syncBatch_duplicateSessions_shouldSkipWithoutSaving() {
        UUID userId = UUID.randomUUID();
        Long gameId = 8L;
        LocalDateTime startedAt = LocalDateTime.of(2025, 2, 1, 6, 30);
        OfflineGameSessionRequest duplicateSession = OfflineGameSessionRequest.builder()
                .sessionId("dup-session")
                .gameId(gameId)
                .startedAt(startedAt.toString())
                .finishedAt(startedAt.plusMinutes(1).toString())
                .totalQuestions(3)
                .correctCount(2)
                .score(150)
                .build();
        BatchSyncRequest request = BatchSyncRequest.builder()
                .clientId("device-dup")
                .gameSessions(List.of(duplicateSession))
                .build();

        when(gameSessionRepository.findByGameIdAndUserIdOrderByStartedAtDesc(gameId, userId))
                .thenReturn(List.of(GameSession.builder().startedAt(startedAt).build()));

        Map<String, Object> result = offlineSyncService.syncBatch(userId, request);

        assertThat(result.get("syncedGameSessions")).isEqualTo(0);
        assertThat(result.get("syncedGameSessionDetails")).isEqualTo(0);
        assertThat(result.get("syncedVocabProgress")).isEqualTo(0);
        assertThat(result.get("skippedDuplicates")).isEqualTo(1);
        assertThat((List<?>) result.get("errors")).isEmpty();

        verify(gameSessionRepository, never()).save(any(GameSession.class));
        verifyNoInteractions(gameRepository, gameSessionDetailRepository, vocabRepository, userVocabProgressRepository);
    }

    private Topic buildTopic(Long id, String name) {
        Topic topic = Topic.builder()
                .name(name)
                .description(name + " desc")
                .build();
        topic.setId(id);
        return topic;
    }

    private Vocab buildVocab(UUID id, Topic topic, String word) {
        Vocab vocab = Vocab.builder()
                .word(word)
                .meaningVi(word + " meaning")
                .types(new HashSet<>())
                .build();
        vocab.setId(id);
        vocab.setTopic(topic);
        return vocab;
    }

    private UserVocabProgress buildProgress(UUID userId, Vocab vocab, VocabStatus status) {
        User user = new User();
        user.setId(userId);
        return UserVocabProgress.builder()
                .user(user)
                .vocab(vocab)
                .status(status)
                .lastReviewed(LocalDate.now())
                .timesCorrect(3)
                .timesWrong(1)
                .efFactor(2.5)
                .intervalDays(3)
                .repetition(2)
                .nextReviewDate(LocalDate.now().plusDays(2))
                .build();
    }
}
