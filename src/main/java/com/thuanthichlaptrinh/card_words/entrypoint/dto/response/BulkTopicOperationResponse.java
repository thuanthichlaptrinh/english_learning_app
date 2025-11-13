package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BulkTopicOperationResponse {
    private int totalRequested;
    private int successCount;
    private int failureCount;
    private List<TopicResult> results;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TopicResult {
        private boolean success;
        private String message;
        private TopicResponse data;
        private String inputName; // Tên topic từ request (để dễ trace)
        private Long inputId; // ID từ request (cho update)
    }
}
