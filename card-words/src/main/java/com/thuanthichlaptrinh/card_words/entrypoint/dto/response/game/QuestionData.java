package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game;

import java.util.List;

import com.thuanthichlaptrinh.card_words.core.domain.Vocab;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class QuestionData {
    private Vocab mainVocab; // Vocabulary chính (câu hỏi)
    private List<Vocab> optionVocabs; // 4 vocabulary làm đáp án
    private int correctAnswerIndex; // Vị trí đáp án đúng (0, 1, 2 hoặc 3)
}
