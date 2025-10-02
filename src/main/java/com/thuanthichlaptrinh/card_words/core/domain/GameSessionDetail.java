package com.thuanthichlaptrinh.card_words.core.domain;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "game_session_details", indexes = {
        @Index(name = "idx_gsd_session_id", columnList = "session_id"),
        @Index(name = "idx_gsd_vocab_id", columnList = "vocab_id"),
        @Index(name = "idx_gsd_is_correct", columnList = "is_correct")
})
public class GameSessionDetail extends BaseEntity {
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "session_id", nullable = false)
    private GameSession session;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vocab_id", nullable = false)
    private Vocab vocab;

    @Builder.Default
    @Column(name = "is_correct", nullable = false)
    private Boolean isCorrect = false;

    @Column(name = "time_taken")
    private Integer timeTaken;
}
