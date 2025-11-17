package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game;

import java.util.List;

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
public class GameInstructionResponse {
    private String gameName;
    private String description;
    private List<String> rules;
    private List<String> scoring;
}
