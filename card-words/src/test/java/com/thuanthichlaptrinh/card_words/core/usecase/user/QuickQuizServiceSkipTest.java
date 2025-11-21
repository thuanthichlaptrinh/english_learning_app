package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.*;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.*;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game.QuickQuizAnswerRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.QuickQuizAnswerResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.*;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Unit tests for QuickQuizService - Skip/Timeout functionality
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("QuickQuiz Skip/Timeout Tests")
class QuickQuizServiceSkipTest {

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

        @InjectMocks
        private QuickQuizService quickQuizService;

        private UUID testUserId;
        private UUID testSessionId;
        private GameSession testSession;

        @BeforeEach
        void setUp() {
                testUserId = UUID.randomUUID();
                testSessionId = UUID.randomUUID();

                // Setup test user
                User testUser = new User();
                testUser.setId(testUserId);

                // Setup test game
                Game testGame = new Game();
                testGame.setId(1L);
                testGame.setName("Quick Reflex Quiz");

                // Setup test session
                testSession = GameSession.builder()
                                .user(testUser)
                                .game(testGame)
                                .startedAt(LocalDateTime.now())
                                .totalQuestions(10)
                                .correctCount(5)
                                .score(50)
                                .details(new HashSet<>())
                                .build();
                // Set ID via reflection or directly if there's a setter
                testSession.setId(testSessionId);
        }

        @Test
        @DisplayName("Skip question should mark as wrong and reset streak")
        void skipQuestion_ShouldMarkAsWrongAndResetStreak() {
                // Given
                when(gameSessionRepository.findById(testSessionId)).thenReturn(Optional.of(testSession));
                when(gameSessionDetailRepository.save(any(GameSessionDetail.class)))
                                .thenAnswer(invocation -> invocation.getArgument(0));
                when(userVocabProgressRepository.findByUserIdAndVocabId(any(), any()))
                                .thenReturn(Optional.empty());
                when(userVocabProgressRepository.save(any())).thenAnswer(invocation -> invocation.getArgument(0));

                QuickQuizAnswerRequest request = QuickQuizAnswerRequest.builder()
                                .sessionId(testSessionId)
                                .questionNumber(6)
                                .selectedOptionIndex(null) // Skip = no selection
                                .timeTaken(3000)
                                .build();

                // When
                QuickQuizAnswerResponse response = quickQuizService.skipQuestion(request, testUserId);

                // Then
                assertThat(response).isNotNull();
                assertThat(response.getIsCorrect()).isFalse();
                assertThat(response.getCurrentStreak()).isEqualTo(0);
                assertThat(response.getCurrentScore()).isEqualTo(50); // No score increase

                verify(gameSessionDetailRepository, times(1)).save(argThat(detail -> detail.getIsCorrect() == false &&
                                detail.getTimeTaken() == 3000));
        }

        @Test
        @DisplayName("Skip should not increase score")
        void skipQuestion_ShouldNotIncreaseScore() {
                // Given
                int initialScore = testSession.getScore();
                when(gameSessionRepository.findById(testSessionId)).thenReturn(Optional.of(testSession));
                when(gameSessionDetailRepository.save(any())).thenAnswer(invocation -> invocation.getArgument(0));
                when(userVocabProgressRepository.findByUserIdAndVocabId(any(), any()))
                                .thenReturn(Optional.empty());
                when(userVocabProgressRepository.save(any())).thenAnswer(invocation -> invocation.getArgument(0));

                QuickQuizAnswerRequest request = QuickQuizAnswerRequest.builder()
                                .sessionId(testSessionId)
                                .questionNumber(1)
                                .timeTaken(3000)
                                .build();

                // When
                QuickQuizAnswerResponse response = quickQuizService.skipQuestion(request, testUserId);

                // Then
                assertThat(response.getCurrentScore()).isEqualTo(initialScore);
                verify(gameSessionRepository, times(1)).save(argThat(session -> session.getScore() == initialScore));
        }

        @Test
        @DisplayName("Skip should update vocab progress as wrong")
        void skipQuestion_ShouldUpdateVocabProgressAsWrong() {
                // Given
                when(gameSessionRepository.findById(testSessionId)).thenReturn(Optional.of(testSession));
                when(gameSessionDetailRepository.save(any())).thenAnswer(invocation -> invocation.getArgument(0));
                when(userVocabProgressRepository.findByUserIdAndVocabId(any(), any()))
                                .thenReturn(Optional.empty());
                when(userVocabProgressRepository.save(any())).thenAnswer(invocation -> invocation.getArgument(0));

                QuickQuizAnswerRequest request = QuickQuizAnswerRequest.builder()
                                .sessionId(testSessionId)
                                .questionNumber(1)
                                .timeTaken(3000)
                                .build();

                // When
                quickQuizService.skipQuestion(request, testUserId);

                // Then
                verify(userVocabProgressRepository, times(1)).save(argThat(progress -> progress.getTimesWrong() > 0 &&
                                progress.getRepetition() == 0));
        }

        @Test
        @DisplayName("Skip should throw exception if session not found")
        void skipQuestion_ShouldThrowException_WhenSessionNotFound() {
                // Given
                when(gameSessionRepository.findById(testSessionId)).thenReturn(Optional.empty());

                QuickQuizAnswerRequest request = QuickQuizAnswerRequest.builder()
                                .sessionId(testSessionId)
                                .questionNumber(1)
                                .timeTaken(3000)
                                .build();

                // When & Then
                assertThatThrownBy(() -> quickQuizService.skipQuestion(request, testUserId))
                                .isInstanceOf(ErrorException.class)
                                .hasMessageContaining("Game session not found");
        }

        @Test
        @DisplayName("Skip should throw exception if session already finished")
        void skipQuestion_ShouldThrowException_WhenSessionAlreadyFinished() {
                // Given
                testSession.setFinishedAt(LocalDateTime.now());
                when(gameSessionRepository.findById(testSessionId)).thenReturn(Optional.of(testSession));

                QuickQuizAnswerRequest request = QuickQuizAnswerRequest.builder()
                                .sessionId(testSessionId)
                                .questionNumber(1)
                                .timeTaken(3000)
                                .build();

                // When & Then
                assertThatThrownBy(() -> quickQuizService.skipQuestion(request, testUserId))
                                .isInstanceOf(ErrorException.class)
                                .hasMessageContaining("Game session already finished");
        }

        @Test
        @DisplayName("Skip should throw exception if unauthorized user")
        void skipQuestion_ShouldThrowException_WhenUnauthorizedUser() {
                // Given
                UUID differentUserId = UUID.randomUUID();
                when(gameSessionRepository.findById(testSessionId)).thenReturn(Optional.of(testSession));

                QuickQuizAnswerRequest request = QuickQuizAnswerRequest.builder()
                                .sessionId(testSessionId)
                                .questionNumber(1)
                                .timeTaken(3000)
                                .build();

                // When & Then
                assertThatThrownBy(() -> quickQuizService.skipQuestion(request, differentUserId))
                                .isInstanceOf(ErrorException.class)
                                .hasMessageContaining("Unauthorized");
        }

        @Test
        @DisplayName("Skip last question should finish game")
        void skipQuestion_LastQuestion_ShouldFinishGame() {
                // Given
                testSession.setTotalQuestions(10);
                when(gameSessionRepository.findById(testSessionId)).thenReturn(Optional.of(testSession));
                when(gameSessionDetailRepository.save(any())).thenAnswer(invocation -> invocation.getArgument(0));
                when(userVocabProgressRepository.findByUserIdAndVocabId(any(), any()))
                                .thenReturn(Optional.empty());
                when(userVocabProgressRepository.save(any())).thenAnswer(invocation -> invocation.getArgument(0));

                QuickQuizAnswerRequest request = QuickQuizAnswerRequest.builder()
                                .sessionId(testSessionId)
                                .questionNumber(10) // Last question
                                .timeTaken(3000)
                                .build();

                // When
                QuickQuizAnswerResponse response = quickQuizService.skipQuestion(request, testUserId);

                // Then
                assertThat(response.getHasNextQuestion()).isFalse();
                assertThat(response.getNextQuestion()).isNull();
                verify(gameSessionRepository, times(1)).save(argThat(session -> session.getFinishedAt() != null));
        }

        @Test
        @DisplayName("Multiple skips should keep score at initial value")
        void multipleSkips_ShouldKeepScoreUnchanged() {
                // Given
                int initialScore = 50;
                testSession.setScore(initialScore);
                when(gameSessionRepository.findById(testSessionId)).thenReturn(Optional.of(testSession));
                when(gameSessionDetailRepository.save(any())).thenAnswer(invocation -> invocation.getArgument(0));
                when(userVocabProgressRepository.findByUserIdAndVocabId(any(), any()))
                                .thenReturn(Optional.empty());
                when(userVocabProgressRepository.save(any())).thenAnswer(invocation -> invocation.getArgument(0));

                // When - Skip 3 questions
                for (int i = 1; i <= 3; i++) {
                        QuickQuizAnswerRequest request = QuickQuizAnswerRequest.builder()
                                        .sessionId(testSessionId)
                                        .questionNumber(i)
                                        .timeTaken(3000)
                                        .build();

                        quickQuizService.skipQuestion(request, testUserId);
                }

                // Then
                assertThat(testSession.getScore()).isEqualTo(initialScore);
        }
}
