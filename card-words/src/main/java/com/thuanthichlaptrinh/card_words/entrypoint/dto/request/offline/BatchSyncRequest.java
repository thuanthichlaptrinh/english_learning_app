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

    // Game sessions (without details embedded)
    private List<OfflineGameSessionRequest> gameSessions;

    // Game session details (separate list, linked by clientSessionId)
    private List<OfflineGameDetailRequest> gameSessionDetails;

    // Vocab learning progress (optional - for manual updates like "Mark as Known")
    private List<OfflineVocabProgressRequest> vocabProgress;
}
