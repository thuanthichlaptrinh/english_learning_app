package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.admin;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DashboardStats {
    private long totalUsers;
    private long totalVocabs;
    private long totalNotifications;
    private long totalLearningSession;
}
