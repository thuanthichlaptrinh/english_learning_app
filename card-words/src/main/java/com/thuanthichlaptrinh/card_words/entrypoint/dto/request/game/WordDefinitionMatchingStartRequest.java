package com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WordDefinitionMatchingStartRequest {

    @Min(value = 2, message = "Số cặp tối thiểu là 2")
    @Max(value = 5, message = "Số cặp tối đa là 5")
    @Builder.Default
    private Integer totalPairs = 5;

    private String cefr; // A1, A2, B1, B2, C1, C2
}
