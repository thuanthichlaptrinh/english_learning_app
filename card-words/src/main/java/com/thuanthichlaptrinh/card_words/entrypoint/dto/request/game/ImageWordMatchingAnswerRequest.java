package com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ImageWordMatchingAnswerRequest {
    private UUID sessionId;
    private List<String> matchedVocabIds;
    private Long timeTaken; // milliseconds

    @Builder.Default
    private Integer wrongAttempts = 0; // Số lần ghép sai trước khi submit
}
