package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ActionLogStatisticsResponse {

    private Long totalActions;
    private Long successfulActions;
    private Long failedActions;
    private Long activeUsers;
}
