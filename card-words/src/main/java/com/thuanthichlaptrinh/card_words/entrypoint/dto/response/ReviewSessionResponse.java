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
public class ReviewSessionResponse {

    private Integer totalDueCards;
    private Integer reviewedToday;
    private Integer remainingCards;
    private List<FlashcardResponse> flashcards;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ReviewStats {
        private Integer totalReviewed;
        private Integer perfect; // quality 5
        private Integer good; // quality 3-4
        private Integer hard; // quality 1-2
        private Integer failed; // quality 0
        private Double averageQuality;
    }
}
