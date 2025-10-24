package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GameHistoryResponse {
    private Long sessionId;
    private String gameMode;
    private Integer totalPairs;
    private Integer correctPairs;
    private Double accuracy;
    private Integer totalScore;
    private Integer timeElapsed;
    private String status;
    private LocalDateTime playedAt;
}
