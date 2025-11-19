package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.offline;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserVocabProgressDownloadResponse {

    // Primary key
    private UUID id;

    // Foreign keys
    @JsonProperty("user_id")
    private UUID user_id;

    @JsonProperty("vocab_id")
    private UUID vocab_id;

    // Progress fields
    private VocabStatus status;

    @JsonProperty("last_reviewed")
    private LocalDate last_reviewed;

    @JsonProperty("times_correct")
    private Integer times_correct;

    @JsonProperty("times_wrong")
    private Integer times_wrong;

    @JsonProperty("ef_factor")
    private Double ef_factor; // Ease Factor for SM-2 algorithm

    @JsonProperty("interval_days")
    private Integer interval_days;

    private Integer repetition;

    @JsonProperty("next_review_date")
    private LocalDate next_review_date;

    // BaseEntity fields
    @JsonProperty("created_at")
    private LocalDateTime created_at;

    @JsonProperty("updated_at")
    private LocalDateTime updated_at;

    // Helper method to check if this vocab is due for review
    public boolean isDueForReview() {
        return next_review_date != null && !next_review_date.isAfter(LocalDate.now());
    }

    // Helper method to calculate accuracy
    public double getAccuracy() {
        int total = times_correct + times_wrong;
        return total > 0 ? (times_correct * 100.0 / total) : 0.0;
    }
}
