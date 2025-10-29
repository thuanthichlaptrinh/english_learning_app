package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.vocab;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VocabOptionResponse {
    private String word;
    private String transcription;
    private String meaningVi;
    private String interpret;
    private String exampleSentence;
    private String cefr;
    private String img;
    private String audio;
    private String credit;
}
