package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user;

import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserVocabProgressResponse {
    private UUID id;
    private VocabInfo vocab;
    private VocabStatus status;
    private LocalDate lastReviewed;
    private Integer timesCorrect;
    private Integer timesWrong;
    private Integer totalAttempts;
    private Double accuracyRate; // % correct
    private Double efFactor;
    private Integer intervalDays;
    private Integer repetition;
    private LocalDate nextReviewDate;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class VocabInfo {
        private UUID id;
        private String word;
        private String meaningVi;
        private String transcription;
        private String cefr;
    }
}
