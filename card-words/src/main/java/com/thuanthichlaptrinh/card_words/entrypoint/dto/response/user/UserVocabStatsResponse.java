package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user;

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
    private Long vocabsLearning; // status = "NEW, KNOWN, UNKNOWN"
    private Long vocabsNew; // status = "NEW", và những từ nằm ngoài bảng UserVocabProgress
    private Long vocabsDueForReview;
    private Double dailyAverage; // tổng số từ đã học (status = "NEW, KNOWN, UNKNOWN, MASTERED") / số ngày tham gia học
}
