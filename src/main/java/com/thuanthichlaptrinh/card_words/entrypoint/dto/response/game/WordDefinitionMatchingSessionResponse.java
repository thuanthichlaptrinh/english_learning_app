package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.vocab.VocabResponse;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WordDefinitionMatchingSessionResponse {

    private Long sessionId;
    private Integer totalPairs;
    private List<VocabResponse> vocabs;
    private String status; // IN_PROGRESS, COMPLETED
}
