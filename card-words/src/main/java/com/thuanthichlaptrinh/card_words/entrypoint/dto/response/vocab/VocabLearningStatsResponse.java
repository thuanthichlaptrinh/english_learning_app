package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.vocab;

import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VocabLearningStatsResponse {
    private UUID vocabId;
    private long totalLearners;
    private int totalCorrect;
    private int totalWrong;
    private int totalAttempts;
    private double accuracy;
}
