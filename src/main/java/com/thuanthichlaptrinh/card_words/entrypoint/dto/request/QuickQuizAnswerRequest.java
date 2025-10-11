package com.thuanthichlaptrinh.card_words.entrypoint.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QuickQuizAnswerRequest {

    @NotNull(message = "Session ID không được để trống")
    private Long sessionId;

    @NotNull(message = "Question number không được để trống")
    private Integer questionNumber;

    @NotNull(message = "Câu trả lời không được để trống")
    private Boolean userAnswer;

    @NotNull(message = "Thời gian trả lời không được để trống")
    private Integer timeTaken;
}
