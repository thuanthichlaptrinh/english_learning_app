package com.thuanthichlaptrinh.card_words.entrypoint.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Set;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdateVocabRequest {
    private String word;
    private String transcription;
    private String meaningVi;
    private String interpret;
    private String exampleSentence;
    private String cefr;
    private String img;
    private String audio;
    private String credit;
    private Set<String> types;
    private Set<String> topics;
}
