package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserVocabStatsResponse {
    private Long totalVocabsLearned;
    private Long totalCorrect;
    private Long totalWrong;
    private Long totalAttempts;
    private Double overallAccuracy; // %
    private Long vocabsMastered; // status = "MASTERED"
    private Long vocabsLearning; // status = "LEARNING"
    private Long vocabsNew; // status = "NEW"
    private Long vocabsDueForReview;
}
