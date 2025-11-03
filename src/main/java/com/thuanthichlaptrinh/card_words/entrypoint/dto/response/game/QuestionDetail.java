package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class QuestionDetail {
    private String word;
    private String meaning;
    private Boolean isCorrect;
}
