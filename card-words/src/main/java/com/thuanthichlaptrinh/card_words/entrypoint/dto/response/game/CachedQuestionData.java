package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CachedQuestionData {

    // Main vocab (the question)
    private UUID mainVocabId;
    private String mainWord;
    private String mainMeaningVi;

    // Options (4 possible answers)
    private List<OptionData> options;

    // Correct answer index (0, 1, 2, or 3)
    private int correctAnswerIndex;

    /**
     * Option DTO - simple data only
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class OptionData {
        private UUID vocabId;
        private String word;
        private String meaningVi;
    }
}
