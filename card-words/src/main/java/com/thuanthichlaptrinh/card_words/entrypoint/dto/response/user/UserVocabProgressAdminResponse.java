package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserVocabProgressAdminResponse {
    private UUID id;
    private UUID userId;
    private String userName;
    private UUID vocabId;
    private String word;
    private String meaningVi;
    private String cefr;
    private Integer timesCorrect;
    private Integer timesWrong;
    private double accuracy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
