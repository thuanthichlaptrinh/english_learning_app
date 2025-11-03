package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DifficultWordResponse {
    private UUID vocabId;
    private String word;
    private String meaningVi;
    private String cefr;
    private int learnerCount;
    private int timesCorrect;
    private int timesWrong;
    private double errorRate;
}
