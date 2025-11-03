package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game;

import java.util.List;
import java.util.UUID;

import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.vocab.VocabOptionResponse;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QuickQuizQuestionResponse {
    private Integer questionNumber;

    // Main vocabulary (câu hỏi)
    private UUID vocabId;
    private String word;
    private String transcription;
    private String meaningVi;
    private String interpret;
    private String exampleSentence;
    private String cefr;
    private String img;
    private String audio;
    private String credit;

    // 4 options (đáp án) - full vocabulary objects
    private List<VocabOptionResponse> options;
    private Integer correctAnswerIndex; // Hidden from response, used internally
    private Integer timeLimit;
}
