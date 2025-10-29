package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserStatisticsResponse {
    private long totalUsers;
    private long activatedUsers;
    private long bannedUsers;
    private long adminUsers;
    private long normalUsers;
}
