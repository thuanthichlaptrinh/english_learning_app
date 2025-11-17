package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GameStatsResponse {
    private Integer totalGamesPlayed;
    private Integer totalGamesCompleted;
    private Double averageScore;
    private Double averageAccuracy;
    private Integer highestScore;
    private Integer totalCorrectPairs;
    private Integer totalWrongPairs;

    // Stats by mode
    private ModeStats classicStats;
    private ModeStats speedMatchStats;
    private ModeStats progressiveStats;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ModeStats {
        private Integer gamesPlayed;
        private Integer gamesCompleted;
        private Double averageScore;
        private Double averageAccuracy;
        private Integer highestScore;
    }
}
