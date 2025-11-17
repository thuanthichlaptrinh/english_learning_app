package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QuickQuizInstructionResponse {
    private String gameName;
    private String description;
    private String howToPlay;
    private String scoring;
    private String tips;
}
