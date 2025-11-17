package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QuickQuizAnswerResponse {
    private Long sessionId;
    private Integer questionNumber;
    private Boolean isCorrect;
    private Integer correctAnswerIndex; // Index of correct answer (0, 1, hoặc 2)
    private Integer currentScore;
    private Integer currentStreak;
    private Integer comboBonus;
    private String explanation;
    private Boolean hasNextQuestion;
    private QuickQuizQuestionResponse nextQuestion;
}
