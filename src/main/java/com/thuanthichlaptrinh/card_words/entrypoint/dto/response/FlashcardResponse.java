package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FlashcardResponse {
    private UUID vocabId;
    private String word;
    private String transcription;
    private String meaningVi;
    private String interpret;
    private String exampleSentence;
    private String img;
    private String audio;

    // Progress info
    private LocalDate lastReviewed;
    private LocalDate nextReviewDate;
    private Integer timesCorrect;
    private Integer timesWrong;
    private Integer repetition;
    private Double efFactor;
    private Integer intervalDays;
    private String status;
}
