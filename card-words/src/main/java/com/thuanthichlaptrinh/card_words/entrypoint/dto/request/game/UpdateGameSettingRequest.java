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
public class UpdateGameSettingRequest {

    // Quick Quiz settings
    @Min(value = 5, message = "Số câu hỏi tối thiểu là 5")
    @Max(value = 50, message = "Số câu hỏi tối đa là 50")
    private Integer quickQuizTotalQuestions;

    @Min(value = 1, message = "Thời gian tối thiểu là 1 giây")
    @Max(value = 10, message = "Thời gian tối đa là 10 giây")
    private Integer quickQuizTimePerQuestion;

    // Image Word Matching settings
    @Min(value = 3, message = "Số cặp tối thiểu là 3")
    @Max(value = 20, message = "Số cặp tối đa là 20")
    private Integer imageWordTotalPairs;

    // Word Definition Matching settings
    @Min(value = 3, message = "Số cặp tối thiểu là 3")
    @Max(value = 20, message = "Số cặp tối đa là 20")
    private Integer wordDefinitionTotalPairs;
}
