package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GameSettingResponse {

    // Quick Quiz settings
    private Integer quickQuizTotalQuestions;
    private Integer quickQuizTimePerQuestion;

    // Image Word Matching settings
    private Integer imageWordTotalPairs;

    // Word Definition Matching settings
    private Integer wordDefinitionTotalPairs;
}
