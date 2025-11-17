package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StreakRecordResponse {
    private Integer currentStreak;
    private Integer longestStreak;
    private Boolean isNewRecord;
    private Boolean streakIncreased;
    private String message;
}

