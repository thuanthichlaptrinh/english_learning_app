package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

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
public class ReviewResultResponse {

    private UUID id;
    private String word;
    private Integer quality;

    // Updated progress
    private Integer timesCorrect;
    private Integer timesWrong;
    private Integer repetition;
    private Double efFactor;
    private Integer intervalDays;
    private LocalDate nextReviewDate;
    private VocabStatus status;

    // Review session info
    private Integer remainingDueCards;
    private Integer totalReviewedToday;
    private String message;
}
