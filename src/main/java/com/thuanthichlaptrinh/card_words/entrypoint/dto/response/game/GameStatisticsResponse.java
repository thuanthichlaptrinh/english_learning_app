package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GameStatisticsResponse {
    private String gameName;
    private Long totalSessions;
    private Double averageScore;
    private Integer highestScore;
    private Integer lowestScore;
    private Double averageAccuracy;
}
