package com.thuanthichlaptrinh.card_words.entrypoint.dto.request.offline;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BatchSyncRequest {
    private String clientId; // Device/client identifier
    private String syncTimestamp; // ISO 8601 timestamp

    // Game sessions with details
    private List<OfflineGameSessionRequest> gameSessions;

    // Vocab learning progress
    private List<OfflineVocabProgressRequest> vocabProgress;
}
