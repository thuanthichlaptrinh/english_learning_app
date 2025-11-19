package com.thuanthichlaptrinh.card_words.entrypoint.dto.request.offline;

import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
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
    private UUID vocabId;
    private VocabStatus status;
    private String lastReviewedAt; // ISO 8601
    private String nextReviewAt; // ISO 8601
    private Double easeFactor;
    private Integer repetitions;
    private Integer interval;

    // Performance metrics (optional - will be merged with server data)
    private Integer timesCorrect;
    private Integer timesWrong;
}
