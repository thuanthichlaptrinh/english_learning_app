package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ImageWordMatchingSessionResponse {

    private Long sessionId;
    private Integer totalPairs;
    private List<VocabResponse> vocabs;
    private String status; // IN_PROGRESS, COMPLETED
}
