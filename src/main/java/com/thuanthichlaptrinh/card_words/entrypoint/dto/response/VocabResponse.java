package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import java.time.LocalDateTime;
import java.util.Set;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VocabResponse {
    private UUID id;
    private String word;
    private String transcription;
    private String meaningVi;
    private String interpret;
    private String exampleSentence;
    private String cefr;
    private String img;
    private String audio;
    private String credit;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Set<TypeInfo> types;
    private Set<TopicInfo> topics;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TypeInfo {
        private Long id;
        private String name;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TopicInfo {
        private Long id;
        private String name;
    }

}