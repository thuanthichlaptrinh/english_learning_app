package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
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
    private UUID id;
    private String word;
    private String transcription;
    private String meaningVi;
    private String interpret;
    private String exampleSentence;
    private String img;
    private String audio;
    private String cefr;

    // Progress info
    private LocalDate lastReviewed;
    private LocalDate nextReviewDate;
    private Integer timesCorrect;
    private Integer timesWrong;
    private Integer repetition;
    private Double efFactor;
    private Integer intervalDays;
    private VocabStatus status;
}
