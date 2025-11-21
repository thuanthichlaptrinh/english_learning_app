package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WordDefinitionMatchingResultResponse {

    private UUID sessionId;
    private Integer totalPairs;
    private Integer correctMatches;
    private Double accuracy;
    private Long timeTaken;
    private Integer score; // Tổng điểm = cefrScore + timeBonus - wrongPenalty

    // Score breakdown
    private Integer cefrScore; // Điểm CEFR cơ bản
    private Integer timeBonus; // Thưởng thời gian
    private Integer wrongPenalty; // Phạt số lần sai
    private Integer wrongAttempts; // Số lần ghép sai

    private List<VocabScore> vocabScores;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class VocabScore {
        private String vocabId;
        private String word;
        private String cefr;
        private Integer points;
        private Boolean correct;
    }
}
