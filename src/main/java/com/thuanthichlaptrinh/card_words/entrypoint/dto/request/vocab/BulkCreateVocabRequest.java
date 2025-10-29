package com.thuanthichlaptrinh.card_words.entrypoint.dto.request.vocab;

import java.util.List;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
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
    private List<VocabImportItem> vocabs;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class VocabImportItem {
        private String word;
        private String transcription;
        private String meaningVi;
        private String interpret;
        private String exampleSentence;
        private String cefr;
        private String img;
        private String audio;
        private String credit;
        private List<String> types;
        private List<String> topics;
    }
}
