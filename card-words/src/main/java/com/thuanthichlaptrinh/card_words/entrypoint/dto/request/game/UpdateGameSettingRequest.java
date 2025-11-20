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
    @Min(value = 2, message = "Số câu hỏi tối thiểu là 2")
    @Max(value = 40, message = "Số câu hỏi tối đa là 40")
    private Integer quickQuizTotalQuestions;

    @Min(value = 3, message = "Thời gian tối thiểu là 3 giây")
    @Max(value = 60, message = "Thời gian tối đa là 60 giây")
    private Integer quickQuizTimePerQuestion;

    // Image Word Matching settings
    @Min(value = 2, message = "Số cặp tối thiểu là 2")
    @Max(value = 5, message = "Số cặp tối đa là 5")
    private Integer imageWordTotalPairs;

    // Word Definition Matching settings
    @Min(value = 2, message = "Số cặp tối thiểu là 2")
    @Max(value = 5, message = "Số cặp tối đa là 5")
    private Integer wordDefinitionTotalPairs;
}
