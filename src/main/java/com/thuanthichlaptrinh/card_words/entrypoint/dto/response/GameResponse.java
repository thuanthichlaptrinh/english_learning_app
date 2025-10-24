package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import java.time.LocalDateTime;

import com.google.auto.value.AutoValue.Builder;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GameResponse {
    private Long id;
    private String name;
    private String description;
    private long sessionCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
