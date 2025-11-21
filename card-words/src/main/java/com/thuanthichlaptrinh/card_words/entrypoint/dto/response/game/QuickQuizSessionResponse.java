package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QuickQuizSessionResponse {

    private UUID sessionId;
    private String gameType;
    private String status; // "IN_PROGRESS", "COMPLETED"

    // Game settings
    private Integer totalQuestions;
    private Integer timePerQuestion; // seconds

    // Progress
    private Integer currentQuestionNumber; // 1-10
    private Integer correctCount;
    private Integer wrongCount;
    private Integer currentStreak;
    private Integer longestStreak;

    // Scoring
    private Integer totalScore;
    private Double accuracy; // percentage
    private Integer averageTimePerQuestion; // milliseconds

    // Timestamps
    private LocalDateTime startedAt;
    private LocalDateTime finishedAt;
    private Integer totalDuration; // seconds

    // Current or first question
    private QuickQuizQuestionResponse currentQuestion;

    // Results (only when completed)
    private List<QuickQuizResultDetail> results;
}
