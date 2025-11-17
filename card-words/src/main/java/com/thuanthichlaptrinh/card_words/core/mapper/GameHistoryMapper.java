package com.thuanthichlaptrinh.card_words.core.mapper;

import com.thuanthichlaptrinh.card_words.core.domain.GameSession;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.GameSessionRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.LeaderboardEntryResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameHistoryResponse;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
@RequiredArgsConstructor
public class GameHistoryMapper {

    private final GameSessionRepository gameSessionRepository;

    public GameHistoryResponse toGameHistoryResponse(GameSession session) {
        if (session == null) {
            return null;
        }

        return GameHistoryResponse.builder()
                .sessionId(session.getId())
                .gameMode(session.getGame().getName())
                .totalPairs(session.getTotalQuestions())
                .correctPairs(session.getCorrectCount())
                .accuracy(session.getAccuracy())
                .totalScore(session.getScore())
                .timeElapsed(session.getDuration())
                .status(session.getFinishedAt() != null ? "COMPLETED" : "IN_PROGRESS")
                .playedAt(session.getStartedAt())
                .build();
    }

    public LeaderboardEntryResponse toLeaderboardEntry(GameSession session, int rank, UUID currentUserId) {
        if (session == null) {
            return null;
        }

        int gamesPlayed = gameSessionRepository.findByUserIdAndGameId(
                session.getUser().getId(),
                session.getGame().getId()).size();

        return LeaderboardEntryResponse.builder()
                .rank(rank)
                .userName(session.getUser().getName())
                .avatar(session.getUser().getAvatar())
                .totalScore(session.getScore())
                .accuracy(session.getAccuracy())
                .gamesPlayed(gamesPlayed)
                .lastPlayedAt(session.getStartedAt())
                .build();
    }

    public LeaderboardEntryResponse toLeaderboardEntry(
            int rank,
            String userName,
            String avatar,
            int totalScore,
            double averageAccuracy,
            int gamesPlayed,
            java.time.LocalDateTime lastPlayedAt) {

        return LeaderboardEntryResponse.builder()
                .rank(rank)
                .userName(userName)
                .avatar(avatar)
                .totalScore(totalScore)
                .accuracy(averageAccuracy)
                .gamesPlayed(gamesPlayed)
                .lastPlayedAt(lastPlayedAt)
                .build();
    }
}
