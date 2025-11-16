package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.admin;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GameStatsSummary {
    private Long gameId;
    private String gameName;
    private long totalSessions;
    private long completedSessions;
    private double averageScore;
    private int highestScore;
    private double averageAccuracy;
}
