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
public class QuickQuizStartRequest {

    @Min(value = 2, message = "Số câu hỏi tối thiểu là 2")
    @Max(value = 40, message = "Số câu hỏi tối đa là 40")
    @Builder.Default
    private Integer totalQuestions = 10;

    @Min(value = 3, message = "Thời gian tối thiểu là 3 giây")
    @Max(value = 60, message = "Thời gian tối đa là 60 giây")
    @Builder.Default
    private Integer timePerQuestion = 3;

    private String cefr;
}
