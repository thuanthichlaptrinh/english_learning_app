package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OverallProgressStatsResponse {
    private long totalProgressRecords;
    private long totalCorrect;
    private long totalWrong;
    private long totalAttempts;
    private double overallAccuracy;
}
