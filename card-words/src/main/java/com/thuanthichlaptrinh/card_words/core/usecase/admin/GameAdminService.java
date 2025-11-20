package com.thuanthichlaptrinh.card_words.core.usecase.admin;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.Game;
import com.thuanthichlaptrinh.card_words.core.domain.GameSession;
import com.thuanthichlaptrinh.card_words.core.domain.GameSessionDetail;
import com.thuanthichlaptrinh.card_words.core.mapper.GameAdminMapper;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.GameRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.GameSessionRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.GameSessionDetailRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.OverallGameStatisticsResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameAdminResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameSessionDetailResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameSessionResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameStatisticsResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.QuestionDetail;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class GameAdminService {

    private final GameRepository gameRepository;
    private final GameSessionRepository gameSessionRepository;
    private final GameSessionDetailRepository gameSessionDetailRepository;
    private final GameAdminMapper gameAdminMapper;

    @Transactional(readOnly = true)
    public List<GameAdminResponse> getAllGames() {
        log.info("Admin: Lấy danh sách game");

        List<Game> games = gameRepository.findAll();
        return games.stream()
                .map(gameAdminMapper::toGameAdminResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public GameAdminResponse getGameById(Long id) {
        log.info("Admin: Lấy thông tin game ID: {}", id);

        Game game = gameRepository.findById(id)
                .orElseThrow(() -> new ErrorException("Không tìm thấy game"));

        return gameAdminMapper.toGameAdminResponse(game);
    }

    @Transactional(readOnly = true)
    public Page<GameSessionResponse> getGameSessions(Long gameId, int page, int size) {
        log.info("Admin: Lấy danh sách session của game ID: {}", gameId);

        if (!gameRepository.existsById(gameId)) {
            throw new ErrorException("Không tìm thấy game");
        }

        Pageable pageable = PageRequest.of(page, size, Sort.by("startedAt").descending());
        Page<GameSession> sessions = gameSessionRepository.findByGameId(gameId, pageable);

        return sessions.map(gameAdminMapper::toGameSessionResponse);
    }

    @Transactional(readOnly = true)
    public GameSessionDetailResponse getSessionDetail(Long sessionId) {
        log.info("Admin: Lấy chi tiết session ID: {}", sessionId);

        GameSession session = gameSessionRepository.findById(sessionId)
                .orElseThrow(() -> new ErrorException("Không tìm thấy session"));

        List<GameSessionDetail> details = gameSessionDetailRepository.findBySessionId(sessionId);

        return GameSessionDetailResponse.builder()
                .sessionId(session.getId())
                .gameName(session.getGame().getName())
                .userName(session.getUser().getName())
                .userEmail(session.getUser().getEmail())
                .totalQuestions(session.getTotalQuestions())
                .correctCount(session.getCorrectCount())
                .score(session.getScore())
                .accuracy(session.getAccuracy())
                .startedAt(session.getStartedAt())
                .finishedAt(session.getFinishedAt())
                .details(details.stream()
                        .map(d -> new QuestionDetail(
                                d.getVocab().getWord(),
                                d.getVocab().getMeaningVi(),
                                d.getIsCorrect()))
                        .toList())
                .build();
    }

    @Transactional(readOnly = true)
    public GameStatisticsResponse getGameStatistics(Long gameId) {
        log.info("Admin: Lấy thống kê game ID: {}", gameId);

        Game game = gameRepository.findById(gameId)
                .orElseThrow(() -> new ErrorException("Không tìm thấy game"));

        long totalSessions = gameSessionRepository.countByGameId(gameId);
        Double avgScore = gameSessionRepository.findAverageScoreByGameId(gameId);
        Integer highestScore = gameSessionRepository.findHighestScoreByGameId(gameId);
        Integer lowestScore = gameSessionRepository.findLowestScoreByGameId(gameId);
        Double avgAccuracy = gameSessionRepository.findAverageAccuracyByGameId(gameId);

        return GameStatisticsResponse.builder()
                .gameName(game.getName())
                .totalSessions(totalSessions)
                .averageScore(avgScore != null ? avgScore : 0.0)
                .highestScore(highestScore != null ? highestScore : 0)
                .lowestScore(lowestScore != null ? lowestScore : 0)
                .averageAccuracy(avgAccuracy != null ? avgAccuracy : 0.0)
                .build();
    }

    @Transactional
    public void deleteSession(Long sessionId) {
        log.info("Admin: Xóa session ID: {}", sessionId);

        if (!gameSessionRepository.existsById(sessionId)) {
            throw new ErrorException("Không tìm thấy session");
        }

        gameSessionRepository.deleteById(sessionId);
    }

    @Transactional(readOnly = true)
    public OverallGameStatisticsResponse getOverallStatistics() {
        log.info("Admin: Lấy tổng quan thống kê tất cả game");

        long totalGames = gameRepository.count();
        long totalSessions = gameSessionRepository.count();
        Double overallAvgScore = gameSessionRepository.findOverallAverageScore();
        Integer overallHighestScore = gameSessionRepository.findOverallHighestScore();

        return OverallGameStatisticsResponse.builder()
                .totalGames(totalGames)
                .totalSessions(totalSessions)
                .overallAverageScore(overallAvgScore != null ? overallAvgScore : 0.0)
                .overallHighestScore(overallHighestScore != null ? overallHighestScore : 0)
                .build();
    }

}
