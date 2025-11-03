package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OverallGameStatisticsResponse {
    private Long totalGames;
    private Long totalSessions;
    private Double overallAverageScore;
    private Integer overallHighestScore;
}
