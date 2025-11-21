package com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QuickQuizAnswerRequest {

    @NotNull(message = "Session ID không được để trống")
    private UUID sessionId;

    @NotNull(message = "Question number không được để trống")
    private Integer questionNumber;

    // Nullable for skip/timeout case
    private Integer selectedOptionIndex; // 0, 1, 2, 3 (null = skip)

    @NotNull(message = "Thời gian trả lời không được để trống")
    private Integer timeTaken;
}
