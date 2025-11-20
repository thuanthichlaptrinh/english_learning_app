package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ActionLogResponse {

    private Long id;
    private UUID userId;
    private String actionType;
    private String actionCategory;
    private String resourceType;
    private String description;
    private String status;
    private String ipAddress;
    private LocalDateTime createdAt;

}
