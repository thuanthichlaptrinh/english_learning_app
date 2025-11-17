package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.admin;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TopLearner {
    private UUID userId;
    private String name;
    private String email;
    private String avatarUrl;
    private long totalWordsLearned;
    private int currentStreak;
    private int totalScore;
}
