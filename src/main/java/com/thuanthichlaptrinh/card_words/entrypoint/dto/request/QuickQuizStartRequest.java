package com.thuanthichlaptrinh.card_words.entrypoint.dto.request;

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

    private String topicName;

    @Min(value = 5, message = "Số câu hỏi tối thiểu là 5")
    @Max(value = 50, message = "Số câu hỏi tối đa là 50")
    @Builder.Default
    private Integer totalQuestions = 10;

    @Min(value = 1, message = "Thời gian tối thiểu là 1 giây")
    @Max(value = 10, message = "Thời gian tối đa là 10 giây")
    @Builder.Default
    private Integer timePerQuestion = 3;

    private String cefr;
}
