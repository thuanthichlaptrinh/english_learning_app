package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.offline;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TopicProgressResponse {

    private Long id;
    private String name;
    // private String nameVi;
    // private String description;

    // Progress information
    // private Integer vocabCount; // Tổng số từ trong topic
    // private Integer learnedCount; // Số từ đã học (LEARNED/REVIEWING)
    private Double progressPercent; // Phần trăm đã học (0-100)

    // Metadata
    // private String cefr;
    // private LocalDateTime lastUpdated;
    // private LocalDateTime createdAt;
}
