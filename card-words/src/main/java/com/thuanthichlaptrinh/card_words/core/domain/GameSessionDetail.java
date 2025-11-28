package com.thuanthichlaptrinh.card_words.core.domain;

import jakarta.persistence.*;
import lombok.*;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.io.Serial;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.UUID;

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
public class GameSessionDetail implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "uuid")
    private UUID id;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

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
