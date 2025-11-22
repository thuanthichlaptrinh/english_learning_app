package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user;

import java.time.LocalDate;

import com.thuanthichlaptrinh.card_words.common.enums.CEFRLevel;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserProfileResponse {
    private String email;
    private String name;
    private String avatar;
    private String gender;
    private LocalDate dateOfBirth;
    private CEFRLevel currentLevel;
    private Integer currentStreak;
    private Integer longestStreak;
    private Integer totalStudyDays;
    private LocalDate lastActivityDate;
    private String status;
}