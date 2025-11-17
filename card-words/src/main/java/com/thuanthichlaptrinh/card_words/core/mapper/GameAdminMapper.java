package com.thuanthichlaptrinh.card_words.core.mapper;

import org.springframework.stereotype.Component;

import com.thuanthichlaptrinh.card_words.core.domain.Game;
import com.thuanthichlaptrinh.card_words.core.domain.GameSession;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.GameSessionRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameAdminResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameSessionResponse;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class GameAdminMapper {

    private final GameSessionRepository gameSessionRepository;

    public GameAdminResponse toGameAdminResponse(Game game) {
        long sessionCount = gameSessionRepository.countByGameId(game.getId());

        return GameAdminResponse.builder()
                .id(game.getId())
                .name(game.getName())
                .description(game.getDescription())
                .sessionCount(sessionCount)
                .createdAt(game.getCreatedAt())
                .updatedAt(game.getUpdatedAt())
                .build();
    }

    public GameSessionResponse toGameSessionResponse(GameSession session) {
        return GameSessionResponse.builder()
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
                .build();
    }
}
