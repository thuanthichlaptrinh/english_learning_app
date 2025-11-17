package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.core.domain.GameSession;
import com.thuanthichlaptrinh.card_words.core.mapper.GameHistoryMapper;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.GameSessionRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.LeaderboardEntryResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameHistoryResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameStatsResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.UserStatsResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Service for managing game history, statistics, and leaderboards
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class GameHistoryService {

    private final GameSessionRepository gameSessionRepository;
    private final GameHistoryMapper gameHistoryMapper;

    /**
     * Get user's game history with pagination
     * 
     * @param userId User ID
     * @param gameId Optional game ID to filter by specific game
     * @param page   Page number (0-based)
     * @param size   Page size
     * @return Paginated game history
     */
    @Transactional(readOnly = true)
    public Page<GameHistoryResponse> getUserGameHistory(UUID userId, Long gameId, int page, int size) {
        log.info("Getting game history for user: {}, gameId: {}, page: {}, size: {}", userId, gameId, page, size);

        Pageable pageable = PageRequest.of(page, size);
        Page<GameSession> sessions;

        if (gameId != null) {
            sessions = gameSessionRepository.findByGameIdAndUserIdOrderByStartedAtDesc(gameId, userId, pageable);
        } else {
            sessions = gameSessionRepository.findByUserIdOrderByStartedAtDesc(userId, pageable);
        }

        return sessions.map(gameHistoryMapper::toGameHistoryResponse);
    }

    /**
     * Get user's overall game statistics
     * 
     * @param userId User ID
     * @return Aggregated game statistics
     */
    @Transactional(readOnly = true)
    public GameStatsResponse getUserGameStats(UUID userId) {
        log.info("Getting game stats for user: {}", userId);

        List<GameSession> allSessions = gameSessionRepository.findByUserIdOrderByStartedAtDesc(userId);

        if (allSessions.isEmpty()) {
            return GameStatsResponse.builder()
                    .totalGamesPlayed(0)
                    .totalGamesCompleted(0)
                    .averageScore(0.0)
                    .averageAccuracy(0.0)
                    .highestScore(0)
                    .totalCorrectPairs(0)
                    .totalWrongPairs(0)
                    .build();
        }

        // Calculate overall stats
        int totalGames = allSessions.size();
        long completedGames = allSessions.stream()
                .filter(s -> s.getFinishedAt() != null)
                .count();

        double avgScore = allSessions.stream()
                .filter(s -> s.getScore() != null)
                .mapToInt(GameSession::getScore)
                .average()
                .orElse(0.0);

        double avgAccuracy = allSessions.stream()
                .filter(s -> s.getAccuracy() != null)
                .mapToDouble(GameSession::getAccuracy)
                .average()
                .orElse(0.0);

        int highestScore = allSessions.stream()
                .filter(s -> s.getScore() != null)
                .mapToInt(GameSession::getScore)
                .max()
                .orElse(0);

        int totalCorrect = allSessions.stream()
                .filter(s -> s.getCorrectCount() != null)
                .mapToInt(GameSession::getCorrectCount)
                .sum();

        int totalWrong = allSessions.stream()
                .filter(s -> s.getTotalQuestions() != null && s.getCorrectCount() != null)
                .mapToInt(s -> s.getTotalQuestions() - s.getCorrectCount())
                .sum();

        // Mode stats (for now null, can be enhanced later)
        return GameStatsResponse.builder()
                .totalGamesPlayed(totalGames)
                .totalGamesCompleted((int) completedGames)
                .averageScore(Math.round(avgScore * 100.0) / 100.0)
                .averageAccuracy(Math.round(avgAccuracy * 100.0) / 100.0)
                .highestScore(highestScore)
                .totalCorrectPairs(totalCorrect)
                .totalWrongPairs(totalWrong)
                .classicStats(null)
                .speedMatchStats(null)
                .progressiveStats(null)
                .build();
    }

    /**
     * Get leaderboard for a specific game
     * Groups sessions by user and takes best score for each user
     * 
     * @param gameId        Game ID to get leaderboard for
     * @param currentUserId Current user ID for highlighting
     * @param limit         Maximum number of entries
     * @return Sorted leaderboard entries
     */
    @Transactional(readOnly = true)
    public List<LeaderboardEntryResponse> getGameLeaderboard(Long gameId, UUID currentUserId, int limit) {
        log.info("Getting leaderboard for gameId: {}, limit: {}", gameId, limit);

        Pageable pageable = PageRequest.of(0, limit);
        Page<GameSession> topSessions = gameSessionRepository.findTopScoresByGame(gameId, pageable);

        // Group by user and get best performance
        Map<UUID, GameSession> bestSessionByUser = new HashMap<>();
        for (GameSession session : topSessions) {
            UUID userId = session.getUser().getId();
            if (!bestSessionByUser.containsKey(userId) ||
                    session.getScore() > bestSessionByUser.get(userId).getScore()) {
                bestSessionByUser.put(userId, session);
            }
        }

        // Sort by score and create leaderboard
        List<GameSession> sortedSessions = bestSessionByUser.values().stream()
                .sorted((a, b) -> {
                    int scoreCompare = Integer.compare(b.getScore(), a.getScore());
                    if (scoreCompare != 0)
                        return scoreCompare;
                    return Double.compare(
                            b.getAccuracy() != null ? b.getAccuracy() : 0.0,
                            a.getAccuracy() != null ? a.getAccuracy() : 0.0);
                })
                .limit(limit)
                .collect(Collectors.toList());

        List<LeaderboardEntryResponse> leaderboard = new ArrayList<>();
        for (int i = 0; i < sortedSessions.size(); i++) {
            GameSession session = sortedSessions.get(i);
            leaderboard.add(gameHistoryMapper.toLeaderboardEntry(session, i + 1, currentUserId));
        }

        return leaderboard;
    }

    /**
     * Get global leaderboard across all games
     * Aggregates stats for each user across all their game sessions
     * 
     * @param currentUserId Current user ID for highlighting
     * @param limit         Maximum number of entries
     * @return Sorted global leaderboard
     */
    @Transactional(readOnly = true)
    public List<LeaderboardEntryResponse> getGlobalLeaderboard(UUID currentUserId, int limit) {
        log.info("Getting global leaderboard, limit: {}", limit);

        List<GameSession> allSessions = gameSessionRepository.findAll();

        // Group by user and calculate total stats
        Map<UUID, UserStatsResponse> userStatsMap = new HashMap<>();

        for (GameSession session : allSessions) {
            UUID userId = session.getUser().getId();
            UserStatsResponse stats = userStatsMap.computeIfAbsent(userId,
                    k -> new UserStatsResponse(session.getUser()));
            stats.addSession(session);
        }

        // Sort by total score and create leaderboard
        List<UserStatsResponse> sortedStats = userStatsMap.values().stream()
                .sorted((a, b) -> {
                    int scoreCompare = Integer.compare(b.getTotalScore(), a.getTotalScore());
                    if (scoreCompare != 0)
                        return scoreCompare;
                    return Double.compare(b.getAverageAccuracy(), a.getAverageAccuracy());
                })
                .limit(limit)
                .collect(Collectors.toList());

        List<LeaderboardEntryResponse> leaderboard = new ArrayList<>();
        for (int i = 0; i < sortedStats.size(); i++) {
            UserStatsResponse stats = sortedStats.get(i);

            leaderboard.add(gameHistoryMapper.toLeaderboardEntry(
                    i + 1,
                    stats.getUser().getName(),
                    stats.getUser().getAvatar(),
                    stats.getTotalScore(),
                    stats.getAverageAccuracy(),
                    stats.getGamesPlayed(),
                    stats.getLastPlayedAt()));
        }

        return leaderboard;
    }
}
