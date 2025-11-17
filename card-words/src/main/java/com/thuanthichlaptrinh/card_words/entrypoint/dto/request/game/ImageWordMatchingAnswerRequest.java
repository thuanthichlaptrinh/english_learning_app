package com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ImageWordMatchingAnswerRequest {
    private Long sessionId;
    private List<String> matchedVocabIds;
    private Long timeTaken;
}
