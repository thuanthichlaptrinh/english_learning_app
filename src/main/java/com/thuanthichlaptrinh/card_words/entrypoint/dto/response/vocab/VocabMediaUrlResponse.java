package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.vocab;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VocabMediaUrlResponse {
    private UUID vocabId;
    private String word;
    private String imageUrl;
    private String audioUrl;
    private boolean hasImage;
    private boolean hasAudio;
}
