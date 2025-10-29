package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.core.domain.Game;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.GameRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.GameSessionRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.UserHighScoresResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserStatsService {

    private final GameRepository gameRepository;
    private final GameSessionRepository gameSessionRepository;

    /**
     * Lấy điểm cao nhất của user cho tất cả các game
     */
    public UserHighScoresResponse getUserHighScores(UUID userId) {
        log.info("Getting high scores for user: {}", userId);

        // Lấy tất cả games
        List<Game> allGames = gameRepository.findAll();

        List<UserHighScoresResponse.GameHighScore> highScores = new ArrayList<>();

        for (Game game : allGames) {
            Integer highestScore = gameSessionRepository.findHighestScoreByUserAndGame(userId, game.getId());

            UserHighScoresResponse.GameHighScore gameHighScore = UserHighScoresResponse.GameHighScore.builder()
                    .gameName(game.getName())
                    .highestScore(highestScore != null ? highestScore : 0)
                    .build();

            highScores.add(gameHighScore);
        }

        return UserHighScoresResponse.builder()
                .highScores(highScores)
                .build();
    }
}
