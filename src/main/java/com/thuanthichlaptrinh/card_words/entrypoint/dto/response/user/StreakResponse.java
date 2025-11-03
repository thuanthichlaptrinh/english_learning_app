package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StreakResponse {
    private Integer currentStreak;
    private Integer longestStreak;
    private LocalDate lastActivityDate;
    private Integer totalStudyDays;
    private String streakStatus; // ACTIVE, PENDING, BROKEN, NEW
    private Integer daysUntilBreak;
    private String message;
}

