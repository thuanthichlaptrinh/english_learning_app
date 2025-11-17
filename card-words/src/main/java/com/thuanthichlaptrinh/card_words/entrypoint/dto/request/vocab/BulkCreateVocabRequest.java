package com.thuanthichlaptrinh.card_words.entrypoint.dto.request.vocab;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BulkCreateVocabRequest {

    @NotEmpty(message = "Danh sách từ vựng không được rỗng")
    @Valid
    @JsonProperty("vocabs")
    private List<VocabImportItem> vocabs;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class VocabImportItem {
        @NotBlank(message = "Từ vựng không được để trống")
        @JsonProperty("word")
        private String word;

        @JsonProperty("transcription")
        private String transcription;

        @NotBlank(message = "Nghĩa tiếng Việt không được để trống")
        @JsonProperty("meaningVi")
        private String meaningVi;

        @JsonProperty("interpret")
        private String interpret;

        @JsonProperty("exampleSentence")
        private String exampleSentence;

        @JsonProperty("cefr")
        private String cefr;

        @JsonProperty("img")
        private String img;

        @JsonProperty("audio")
        private String audio;

        @JsonProperty("credit")
        private String credit;

        @JsonProperty("types")
        private List<String> types;

        @JsonProperty("topic")
        private String topic;
    }
}
