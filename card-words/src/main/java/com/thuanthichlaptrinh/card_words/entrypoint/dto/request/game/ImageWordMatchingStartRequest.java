package com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ImageWordMatchingStartRequest {

    @Min(value = 2, message = "Số cặp tối thiểu là 2")
    @Max(value = 5, message = "Số cặp tối đa là 5")
    @Builder.Default
    private Integer totalPairs = 5; // Number of pairs (default 5)

    private String cefr; // Optional: filter by CEFR level (A1, A2, B1, B2, C1, C2)

}
