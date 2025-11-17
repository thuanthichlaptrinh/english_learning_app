package com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game;

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
    private Integer totalPairs; // Number of pairs (default 5)
    private String cefr; // Optional: filter by CEFR level (A1, A2, B1, B2, C1, C2)
}
