package com.thuanthichlaptrinh.card_words.entrypoint.dto.request.offline;

import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
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
public class OfflineVocabProgressRequest {
    @NotNull(message = "vocabId is required")
    private UUID vocabId;

    @NotNull(message = "status is required")
    private VocabStatus status;

    private String lastReviewedAt; // ISO 8601
    private String nextReviewAt; // ISO 8601

    @Builder.Default
    private Double easeFactor = 2.5; // Default SM-2 starting value

    @Builder.Default
    private Integer repetitions = 0;

    @Builder.Default
    private Integer interval = 0;

    // Performance metrics (optional - will be merged with server data)
    @Builder.Default
    private Integer timesCorrect = 0;

    @Builder.Default
    private Integer timesWrong = 0;
}
