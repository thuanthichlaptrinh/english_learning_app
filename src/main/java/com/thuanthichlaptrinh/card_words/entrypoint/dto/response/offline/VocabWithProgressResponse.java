package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.offline;

// import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

// import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VocabWithProgressResponse {

    // Vocab info
    private UUID id;
    private String word;
    private String meaningVi;
    private String transcription;
    private String audio;
    private String img;
    private String exampleSentence;
    private String cefr;
    private String interpret;
    private List<String> wordTypes;
    private String credit;

    // User progress (if exists)
    // private VocabStatus status;
    // private LocalDateTime lastReviewedAt;
    // private LocalDateTime nextReviewAt;
    // private Double easeFactor;
    // private Integer repetitions;
    // private Integer interval;
}
