package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GameAdminResponse {
    private Long id;
    private String name;
    private String description;
    private Long sessionCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
