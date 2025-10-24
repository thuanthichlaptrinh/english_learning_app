package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LeaderboardEntryResponse {
    private Integer rank;
    private String userName;
    private String avatar;
    private Integer totalScore;
    private Double accuracy;
    private Integer gamesPlayed;
    private LocalDateTime lastPlayedAt;
}
