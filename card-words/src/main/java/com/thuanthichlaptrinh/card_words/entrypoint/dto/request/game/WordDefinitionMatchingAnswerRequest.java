package com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WordDefinitionMatchingAnswerRequest {

    @NotNull(message = "Session ID không được để trống")
    private UUID sessionId;

    @NotEmpty(message = "Danh sách vocab IDs đã ghép không được để trống")
    private List<String> matchedVocabIds;

    @NotNull(message = "Thời gian hoàn thành không được để trống")
    private Long timeTaken; // milliseconds

    @Builder.Default
    private Integer wrongAttempts = 0; // Số lần ghép sai trước khi submit
}
