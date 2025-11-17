package com.thuanthichlaptrinh.card_words.common.helper;

import java.time.LocalDate;

public class StreakCalculation {
    final int currentStreak;
    final int longestStreak;
    final LocalDate lastActivityDate;
    final int totalStudyDays;

    StreakCalculation(int currentStreak, int longestStreak, LocalDate lastActivityDate, int totalStudyDays) {
        this.currentStreak = currentStreak;
        this.longestStreak = longestStreak;
        this.lastActivityDate = lastActivityDate;
        this.totalStudyDays = totalStudyDays;
    }
}
