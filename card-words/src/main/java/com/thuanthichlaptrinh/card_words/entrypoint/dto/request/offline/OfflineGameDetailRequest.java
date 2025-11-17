package com.thuanthichlaptrinh.card_words.entrypoint.dto.request.offline;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OfflineGameDetailRequest {
    private UUID vocabId;
    private Integer questionNumber;
    private String userAnswer;
    private String correctAnswer;
    private Boolean isCorrect;
    private Integer timeTaken; // milliseconds
    private Integer pointsEarned;
}
