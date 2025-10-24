package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import java.util.List;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class QuestionData {
    private UUID vocabId;
    private String word;
    private String correctMeaning;
    private List<String> options; // 3 đáp án
    private int correctAnswerIndex; // Vị trí đáp án đúng (0, 1, hoặc 2)
}
