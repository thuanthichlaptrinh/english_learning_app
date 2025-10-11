package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QuickQuizResultDetail {
    private Integer questionNumber;
    private String word;
    private String correctMeaning;
    private String displayedMeaning;
    private Boolean isCorrectPair;
    private Boolean userAnswer;
    private Boolean isCorrect;
    private Integer timeTaken;
    private Integer pointsEarned;
}
