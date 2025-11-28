package com.thuanthichlaptrinh.card_words.core.domain;

import jakarta.persistence.*;
import lombok.*;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.io.Serial;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "game_sessions", indexes = {
        @Index(name = "idx_gs_user_id", columnList = "user_id"),
        @Index(name = "idx_gs_game_id", columnList = "game_id"),
        @Index(name = "idx_gs_topic_id", columnList = "topic_id"),
        @Index(name = "idx_gs_started_at", columnList = "started_at"),
        @Index(name = "idx_gs_score", columnList = "score")
})
public class GameSession implements Serializable {

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
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "game_id", nullable = false)
    private Game game;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "topic_id")
    private Topic topic;

    @Column(name = "started_at", nullable = false)
    private LocalDateTime startedAt;

    @Column(name = "finished_at")
    private LocalDateTime finishedAt;

    @Column(name = "total_questions")
    private Integer totalQuestions;

    @Builder.Default
    @Column(name = "correct_count", nullable = false)
    private Integer correctCount = 0;

    @Column
    private Double accuracy;

    @Column
    private Integer duration;

    @Builder.Default
    @Column(nullable = false)
    private Integer score = 0;

    @Builder.Default
    @OneToMany(mappedBy = "session", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<GameSessionDetail> details = new HashSet<>();
}
