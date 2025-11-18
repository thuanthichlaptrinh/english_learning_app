package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.chat;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChatResponse {
    private UUID messageId;
    private UUID sessionId;
    private String message;
    private String response;
    private LocalDateTime timestamp;
    private Integer tokensUsed;
    private List<String> relatedTopics;
    private List<VocabSuggestion> vocabSuggestions;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class VocabSuggestion {
        private UUID vocabId;
        private String word;
        private String meaningVi;
        private String cefr;
    }
}
