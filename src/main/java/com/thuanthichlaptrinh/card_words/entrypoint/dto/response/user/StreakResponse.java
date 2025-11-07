package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StreakResponse {
    private String message;
    private Integer currentStreak;
    private Integer longestStreak;
    private LocalDate lastActivityDate;
    private Integer totalStudyDays;
    private String streakStatus; // ACTIVE, PENDING, BROKEN, NEW
    private Integer daysUntilBreak;
    // Format: { "2025": { "10": [29, 30, 31], "11": [1, 3, 4] } }
    private Map<String, Map<String, List<Integer>>> activityLog;
}
