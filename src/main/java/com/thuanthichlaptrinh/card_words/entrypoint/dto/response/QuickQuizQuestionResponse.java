package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QuickQuizQuestionResponse {
    private Long sessionId;
    private Integer questionNumber;
    private java.util.UUID vocabId;
    private String word;
    private String transcription;
    private String displayedMeaning;
    private Boolean isCorrectPair;
    private Integer timeLimit;
    private String cefr;
    private String img;
    private String audio;
}
