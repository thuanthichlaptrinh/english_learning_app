package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GameSessionResponse {
    private UUID sessionId;
    private String gameName;
    private String userName;
    private String userEmail;
    private Integer totalQuestions;
    private Integer correctCount;
    private Integer score;
    private Double accuracy;
    private LocalDateTime startedAt;
    private LocalDateTime finishedAt;
}
