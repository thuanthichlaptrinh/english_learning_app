package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

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
    private Boolean correctAnswer;
    private Integer currentScore;
    private Integer currentStreak;
    private Integer comboBonus;
    private String explanation;
    private Boolean hasNextQuestion;
    private QuickQuizQuestionResponse nextQuestion;
}
