package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.admin;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SystemOverviewResponse {
    private long totalUsers;
    private long activeUsersToday;
    private long totalVocabs;
    private long totalTopics;
    private long totalGameSessions;
    private long completedGameSessions;
    private double averageScore;
    private int highestScore;
    private long totalWordsLearned;
}
