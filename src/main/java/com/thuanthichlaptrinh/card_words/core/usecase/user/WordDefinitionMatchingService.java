package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.Game;
import com.thuanthichlaptrinh.card_words.core.domain.GameSession;
import com.thuanthichlaptrinh.card_words.core.domain.GameSessionDetail;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.domain.UserVocabProgress;
import com.thuanthichlaptrinh.card_words.core.domain.Vocab;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.GameRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.GameSessionDetailRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.GameSessionRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserVocabProgressRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.VocabRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.WordDefinitionMatchingAnswerRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.WordDefinitionMatchingStartRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.WordDefinitionMatchingResultResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.WordDefinitionMatchingSessionResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.SessionData;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.VocabResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;

import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class WordDefinitionMatchingService {

    private final GameRepository gameRepository;
    private final GameSessionRepository gameSessionRepository;
    private final GameSessionDetailRepository gameSessionDetailRepository;
    private final VocabRepository vocabRepository;
    private final UserRepository userRepository;
    private final UserVocabProgressRepository userVocabProgressRepository;

    private final Cache<Long, SessionData> sessionCache = Caffeine.newBuilder()
            .expireAfterWrite(30, TimeUnit.MINUTES)
            .maximumSize(10000)
            .build();

    private static final String GAME_NAME = "Word-Definition Matching";
    private static final int DEFAULT_PAIRS = 5;

    @Transactional
    public WordDefinitionMatchingSessionResponse startGame(WordDefinitionMatchingStartRequest request) {
        log.info("Starting Word-Definition Matching game: cefr={}, pairs={}",
                request.getCefr(), request.getTotalPairs());

        User user = getAuthenticatedUser();

        int totalPairs = request.getTotalPairs() != null && request.getTotalPairs() > 0
                ? request.getTotalPairs()
                : DEFAULT_PAIRS;

        Game game = getOrCreateGame();

        // Get random vocabs (không cần filter image)
        List<Vocab> vocabs = getRandomVocabs(totalPairs, request.getCefr());

        if (vocabs.size() < totalPairs) {
            throw new ErrorException(
                    "Không đủ từ vựng. Cần " + totalPairs + " từ, chỉ tìm thấy " + vocabs.size());
        }

        GameSession session = GameSession.builder()
                .game(game)
                .user(user)
                .totalQuestions(totalPairs)
                .correctCount(0)
                .score(0)
                .startedAt(LocalDateTime.now())
                .build();
        session = gameSessionRepository.save(session);

        SessionData sessionData = new SessionData(session.getId(), vocabs);
        sessionCache.put(session.getId(), sessionData);

        List<VocabResponse> vocabResponses = vocabs.stream()
                .map(this::mapToVocabResponse)
                .collect(Collectors.toList());

        log.info("Word-Definition Matching game started: sessionId={}, pairs={}", session.getId(), totalPairs);

        return WordDefinitionMatchingSessionResponse.builder()
                .sessionId(session.getId())
                .totalPairs(totalPairs)
                .vocabs(vocabResponses)
                .status("IN_PROGRESS")
                .build();
    }

    @Transactional
    public WordDefinitionMatchingResultResponse submitAnswer(WordDefinitionMatchingAnswerRequest request) {
        log.info("Submitting answer for session: {}", request.getSessionId());

        SessionData sessionData = sessionCache.getIfPresent(request.getSessionId());
        if (sessionData == null) {
            throw new ErrorException("Session không tồn tại hoặc đã hết hạn");
        }

        GameSession session = gameSessionRepository.findById(request.getSessionId())
                .orElseThrow(() -> new ErrorException("Không tìm thấy session"));

        User user = getAuthenticatedUser();
        if (!session.getUser().getId().equals(user.getId())) {
            throw new ErrorException("Bạn không có quyền truy cập session này");
        }

        if (session.getFinishedAt() != null) {
            throw new ErrorException("Game đã kết thúc");
        }

        List<Vocab> sessionVocabs = sessionData.getVocabs();
        Set<String> submittedIds = new HashSet<>(request.getMatchedVocabIds());
        Set<String> actualIds = sessionVocabs.stream()
                .map(v -> v.getId().toString())
                .collect(Collectors.toSet());

        if (submittedIds.size() != actualIds.size()) {
            throw new ErrorException("Số lượng vocab không khớp");
        }

        int correctMatches = 0;
        int cefrScore = 0;
        List<WordDefinitionMatchingResultResponse.VocabScore> vocabScores = new ArrayList<>();

        for (Vocab vocab : sessionVocabs) {
            String vocabId = vocab.getId().toString();
            boolean isCorrect = submittedIds.contains(vocabId);
            int points = 0;

            if (isCorrect) {
                correctMatches++;
                points = getCefrPoints(vocab.getCefr());
                cefrScore += points;
            }

            GameSessionDetail detail = GameSessionDetail.builder()
                    .session(session)
                    .vocab(vocab)
                    .isCorrect(isCorrect)
                    .build();
            gameSessionDetailRepository.save(detail);

            updateUserVocabProgress(user, vocab, isCorrect);

            vocabScores.add(WordDefinitionMatchingResultResponse.VocabScore.builder()
                    .vocabId(vocabId)
                    .word(vocab.getWord())
                    .cefr(vocab.getCefr())
                    .points(points)
                    .correct(isCorrect)
                    .build());
        }

        long seconds = request.getTimeTaken() / 1000;
        double bonusPercentage = 0;
        if (seconds < 10) {
            bonusPercentage = 0.50;
        } else if (seconds < 20) {
            bonusPercentage = 0.30;
        } else if (seconds < 30) {
            bonusPercentage = 0.20;
        } else if (seconds < 60) {
            bonusPercentage = 0.10;
        }

        int timeBonus = (int) Math.round(cefrScore * bonusPercentage);
        int totalScore = cefrScore + timeBonus;

        double accuracy = ((double) correctMatches / sessionVocabs.size()) * 100;

        session.setCorrectCount(correctMatches);
        session.setScore(totalScore);
        session.setAccuracy(accuracy);
        session.setFinishedAt(LocalDateTime.now());
        gameSessionRepository.save(session);

        sessionCache.invalidate(request.getSessionId());

        log.info("Word-Definition Matching completed: sessionId={}, score={}, accuracy={}%",
                session.getId(), totalScore, String.format("%.2f", accuracy));

        return WordDefinitionMatchingResultResponse.builder()
                .sessionId(session.getId())
                .totalPairs(sessionData.getVocabs().size())
                .correctMatches(correctMatches)
                .accuracy(accuracy)
                .timeTaken(request.getTimeTaken())
                .score(totalScore)
                .vocabScores(vocabScores)
                .build();
    }

    private int getCefrPoints(String cefr) {
        if (cefr == null)
            return 1;
        return switch (cefr.toUpperCase()) {
            case "A1" -> 1;
            case "A2" -> 2;
            case "B1" -> 3;
            case "B2" -> 4;
            case "C1" -> 5;
            case "C2" -> 6;
            default -> 1;
        };
    }

    private User getAuthenticatedUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            throw new ErrorException("Người dùng chưa đăng nhập");
        }
        String userEmail = authentication.getName();
        return userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new ErrorException("Không tìm thấy người dùng"));
    }

    private Game getOrCreateGame() {
        return gameRepository.findByName(GAME_NAME)
                .orElseGet(() -> {
                    Game game = Game.builder()
                            .name(GAME_NAME)
                            .description("Ghép thẻ từ vựng với nghĩa")
                            .build();
                    return gameRepository.save(game);
                });
    }

    private List<Vocab> getRandomVocabs(int count, String cefr) {
        List<Vocab> vocabs;

        if (cefr != null && !cefr.isBlank()) {
            vocabs = vocabRepository.findByCefr(cefr);
        } else {
            vocabs = vocabRepository.findAll();
        }

        Collections.shuffle(vocabs);
        return vocabs.stream()
                .limit(count)
                .collect(Collectors.toList());
    }

    private void updateUserVocabProgress(User user, Vocab vocab, boolean isCorrect) {
        Optional<UserVocabProgress> progressOpt = userVocabProgressRepository
                .findByUserIdAndVocabId(user.getId(), vocab.getId());

        UserVocabProgress progress;
        if (progressOpt.isPresent()) {
            progress = progressOpt.get();
            if (isCorrect) {
                progress.setTimesCorrect(progress.getTimesCorrect() + 1);
            } else {
                progress.setTimesWrong(progress.getTimesWrong() + 1);
            }
        } else {
            progress = UserVocabProgress.builder()
                    .user(user)
                    .vocab(vocab)
                    .timesCorrect(isCorrect ? 1 : 0)
                    .timesWrong(isCorrect ? 0 : 1)
                    .build();
        }

        userVocabProgressRepository.save(progress);
    }

    @Transactional(readOnly = true)
    public WordDefinitionMatchingSessionResponse getSession(Long sessionId) {
        SessionData sessionData = sessionCache.getIfPresent(sessionId);
        if (sessionData == null) {
            throw new ErrorException("Session không tồn tại hoặc đã hết hạn");
        }

        GameSession session = gameSessionRepository.findById(sessionId)
                .orElseThrow(() -> new ErrorException("Không tìm thấy session"));

        User user = getAuthenticatedUser();
        if (!session.getUser().getId().equals(user.getId())) {
            throw new ErrorException("Bạn không có quyền truy cập session này");
        }

        List<VocabResponse> vocabResponses = sessionData.getVocabs().stream()
                .map(this::mapToVocabResponse)
                .collect(Collectors.toList());

        return WordDefinitionMatchingSessionResponse.builder()
                .sessionId(session.getId())
                .totalPairs(sessionData.getVocabs().size())
                .vocabs(vocabResponses)
                .status(session.getFinishedAt() != null ? "COMPLETED" : "IN_PROGRESS")
                .build();
    }

    private VocabResponse mapToVocabResponse(Vocab vocab) {
        return VocabResponse.builder()
                .id(vocab.getId())
                .word(vocab.getWord())
                .meaningVi(vocab.getMeaningVi())
                .transcription(vocab.getTranscription())
                .interpret(vocab.getInterpret())
                .exampleSentence(vocab.getExampleSentence())
                .cefr(vocab.getCefr())
                .img(vocab.getImg())
                .audio(vocab.getAudio())
                .types(vocab.getTypes() != null ? vocab.getTypes().stream()
                        .map(type -> VocabResponse.TypeInfo.builder()
                                .id(type.getId())
                                .name(type.getName())
                                .build())
                        .collect(Collectors.toSet()) : null)
                .topics(vocab.getTopics() != null ? vocab.getTopics().stream()
                        .map(topic -> VocabResponse.TopicInfo.builder()
                                .id(topic.getId())
                                .name(topic.getName())
                                .build())
                        .collect(Collectors.toSet()) : null)
                .build();
    }
}
