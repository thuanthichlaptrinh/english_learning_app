package com.thuanthichlaptrinh.card_words.entrypoint.dto.request;

import jakarta.validation.constraints.Size;
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
public class ActionLogFilterRequest {

    private UUID userId;

    @Size(max = 50)
    private String actionType;

    @Size(max = 50)
    private String resourceType;

    @Size(max = 20)
    private String status; // SUCCESS, FAILED

    private LocalDateTime startDate;

    private LocalDateTime endDate;

    @Size(max = 255)
    private String keyword; // Search in description, userEmail, userName

    @Builder.Default
    private Integer page = 0;

    @Builder.Default
    private Integer size = 10;

    @Builder.Default
    private String sortBy = "createdAt";

    @Builder.Default
    private String sortDirection = "DESC";
}
