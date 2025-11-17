package com.thuanthichlaptrinh.card_words.entrypoint.dto.request;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReviewFlashcardRequest {

    @NotNull(message = "Vocab ID is required")
    private UUID vocabId;
    /**
     * Quality rating (SM-2 algorithm):
     * 0 - Complete blackout, wrong answer
     * 1 - Incorrect, but recognized when shown answer
     * 2 - Incorrect, but almost correct
     * 3 - Correct, but difficult to recall
     * 4 - Correct, hesitated
     * 5 - Perfect, easy recall
     */
    @NotNull(message = "Quality rating is required")
    @Min(value = 0, message = "Quality must be between 0 and 5")
    @Max(value = 5, message = "Quality must be between 0 and 5")
    private Integer quality;

    // Time spent reviewing in seconds (optional)
    private Integer timeSpentSeconds;
}
