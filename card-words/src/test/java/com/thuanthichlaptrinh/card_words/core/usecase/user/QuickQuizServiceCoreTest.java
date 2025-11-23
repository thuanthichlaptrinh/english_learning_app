package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.*;
import com.thuanthichlaptrinh.card_words.core.service.redis.GameSessionCacheService;
import com.thuanthichlaptrinh.card_words.core.service.redis.RateLimitingService;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.*;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game.QuickQuizAnswerRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game.QuickQuizStartRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.QuestionData;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.QuickQuizAnswerResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.QuickQuizSessionResponse;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class QuickQuizServiceCoreTest {

    @Mock
    private GameRepository gameRepository;

    @Mock
    private GameSessionRepository gameSessionRepository;

    @Mock
    private GameSessionDetailRepository gameSessionDetailRepository;

    @Mock
    private VocabRepository vocabRepository;

    @Mock
    private UserVocabProgressRepository userVocabProgressRepository;

    @Mock
    private StreakService streakService;

    @Mock
    private LeaderboardService leaderboardService;

    @Mock
    private NotificationService notificationService;

    @Mock
    private GameSessionCacheService gameSessionCacheService;

    @Mock
    private RateLimitingService rateLimitingService;

    @InjectMocks
    private QuickQuizService quickQuizService;

    @Test
    @DisplayName("CF-06: startGame respects rate-limit and caches first question")
    void startGame_whenAllowed_shouldCacheQuestionsAndReturnSession() {
        QuickQuizStartRequest request = QuickQuizStartRequest.builder()
                .totalQuestions(3)
                .timePerQuestion(5)
                .cefr("A2")
                .build();
        UUID userId = UUID.randomUUID();

        Game game = Game.builder().name("Quick Reflex Quiz").build();
        game.setId(1L);

        when(rateLimitingService.checkGameRateLimit(eq(userId), eq("quickquiz"), anyInt(), any(Duration.class)))
                .thenReturn(RateLimitingService.RateLimitResult.allowed(10));
        when(gameRepository.findByName("Quick Reflex Quiz")).thenReturn(Optional.of(game));
        when(vocabRepository.findByCefr("A2")).thenReturn(buildVocabs(12));
        when(gameSessionRepository.save(any(GameSession.class))).thenAnswer(invocation -> {
            GameSession session = invocation.getArgument(0);
            session.setId(UUID.randomUUID());
            return session;
        });

        QuickQuizSessionResponse response = quickQuizService.startGame(request, userId);

        assertThat(response.getSessionId()).isNotNull();
        assertThat(response.getTotalQuestions()).isEqualTo(3);
        assertThat(response.getTimePerQuestion()).isEqualTo(5);
        assertThat(response.getCurrentQuestion().getQuestionNumber()).isEqualTo(1);

        verify(gameSessionCacheService).cacheQuizQuestions(eq(response.getSessionId()), anyList());
        verify(gameSessionCacheService).cacheSessionTimeLimit(response.getSessionId(), 5000);
        verify(gameSessionCacheService).cacheQuestionStartTime(eq(response.getSessionId()), eq(1), any());
    }

    @Test
    @DisplayName("CF-06: startGame blocks users who exceed rate limit")
    void startGame_whenRateLimitExceeded_shouldThrow() {
        QuickQuizStartRequest request = QuickQuizStartRequest.builder()
                .totalQuestions(5)
                .timePerQuestion(4)
                .build();
        UUID userId = UUID.randomUUID();

        RateLimitingService.RateLimitResult denied = RateLimitingService.RateLimitResult.builder()
                .allowed(false)
                .currentCount(11)
                .limit(10)
                .remaining(0)
                .resetInSeconds(60)
                .build();

        when(rateLimitingService.checkGameRateLimit(eq(userId), eq("quickquiz"), anyInt(), any(Duration.class)))
                .thenReturn(denied);

        assertThatThrownBy(() -> quickQuizService.startGame(request, userId))
                .isInstanceOf(ErrorException.class)
                .hasMessageContaining("Quá nhiều phiên chơi");

        verifyNoInteractions(gameRepository);
    }

    @Test
    @DisplayName("CF-07: submitAnswer completes session and cleans caches")
    void submitAnswer_whenFinalQuestion_shouldFinishSession() {
        UUID userId = UUID.randomUUID();
        UUID sessionId = UUID.randomUUID();
        QuickQuizAnswerRequest request = QuickQuizAnswerRequest.builder()
                .sessionId(sessionId)
                .questionNumber(1)
                .selectedOptionIndex(2)
                .timeTaken(500)
                .build();

        GameSession session = buildSession(userId, sessionId, 1);
        Vocab mainVocab = buildVocab("word-1");
        QuestionData questionData = new QuestionData(mainVocab, buildOptions(mainVocab, 2), 2);

        when(gameSessionRepository.findById(sessionId)).thenReturn(Optional.of(session));
        when(gameSessionCacheService.getQuizQuestions(sessionId)).thenReturn(List.of(questionData));
        when(gameSessionCacheService.getSessionTimeLimit(sessionId)).thenReturn(3000);
        when(gameSessionCacheService.getQuestionStartTime(sessionId, 1))
                .thenReturn(LocalDateTime.now().minus(Duration.ofMillis(800)));
        when(gameSessionDetailRepository.save(any())).thenAnswer(invocation -> invocation.getArgument(0));

        UserVocabProgress progress = UserVocabProgress.builder()
                .user(session.getUser())
                .vocab(questionData.getMainVocab())
                .status(VocabStatus.NEW)
                .timesCorrect(0)
                .timesWrong(0)
                .repetition(0)
                .efFactor(2.5)
                .intervalDays(1)
                .build();
        when(userVocabProgressRepository.findByUserIdAndVocabId(userId, questionData.getMainVocab().getId()))
                .thenReturn(Optional.of(progress));
        when(userVocabProgressRepository.save(any())).thenAnswer(invocation -> invocation.getArgument(0));
        when(gameSessionRepository.save(session)).thenReturn(session);

        QuickQuizAnswerResponse response = quickQuizService.submitAnswer(request, userId);

        assertThat(response.getIsCorrect()).isTrue();
        assertThat(response.getHasNextQuestion()).isFalse();
        assertThat(session.getFinishedAt()).isNotNull();
        assertThat(session.getAccuracy()).isEqualTo(100.0);

        verify(gameSessionCacheService).deleteQuizSessionCache(sessionId);
        verify(leaderboardService).updateUserScore(userId, "quick-quiz", session.getScore());
        verify(notificationService, atLeastOnce()).createNotification(any());
        verify(streakService).recordActivity(any(User.class));
    }

    private List<Vocab> buildVocabs(int count) {
        List<Vocab> vocabs = new ArrayList<>();
        for (int i = 0; i < count; i++) {
            vocabs.add(buildVocab("word-" + i));
        }
        return vocabs;
    }

    private Vocab buildVocab(String word) {
        Vocab vocab = Vocab.builder()
                .word(word)
                .meaningVi("meaning-" + word)
                .types(Set.of())
                .build();
        vocab.setId(UUID.randomUUID());
        return vocab;
    }

        private List<Vocab> buildOptions(Vocab correct, int correctIndex) {
                List<Vocab> options = new ArrayList<>();
                for (int i = 0; i < 4; i++) {
                        options.add(buildVocab("opt-" + i));
                }
                options.set(correctIndex, correct);
                return options;
    }

    private GameSession buildSession(UUID userId, UUID sessionId, int totalQuestions) {
        User user = new User();
        user.setId(userId);

        Game game = Game.builder().name("Quick Reflex Quiz").build();
        game.setId(1L);

        GameSession session = GameSession.builder()
                .user(user)
                .game(game)
                .startedAt(LocalDateTime.now().minusSeconds(20))
                .totalQuestions(totalQuestions)
                .build();
        session.setId(sessionId);
        return session;
    }
}