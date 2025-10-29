package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game;

import java.time.LocalDateTime;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GameSessionDetailResponse {
    private Long sessionId;
    private String gameName;
    private String userName;
    private String userEmail;
    private Integer totalQuestions;
    private Integer correctCount;
    private Integer score;
    private Double accuracy;
    private LocalDateTime startedAt;
    private LocalDateTime finishedAt;
    private List<QuestionDetail> details;
}
