package com.thuanthichlaptrinh.card_words.core.domain;

import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.util.UUID;

import org.hibernate.annotations.GenericGenerator;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "user_vocab_progress", indexes = {
        @Index(name = "idx_uvp_user_id", columnList = "user_id"),
        @Index(name = "idx_uvp_vocab_id", columnList = "vocab_id"),
        @Index(name = "idx_uvp_status", columnList = "status"),
        @Index(name = "idx_uvp_next_review_date", columnList = "next_review_date"),
        @Index(name = "idx_uvp_user_vocab", columnList = "user_id,vocab_id", unique = true)
})
public class UserVocabProgress extends BaseEntity {
    @Id
    @GeneratedValue(generator = "UUID")
    @GenericGenerator(name = "UUID", strategy = "org.hibernate.id.UUIDGenerator")
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "uuid")
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vocab_id", nullable = false)
    private Vocab vocab;

    @Enumerated(EnumType.STRING)
    @Column(length = 50)
    private VocabStatus status;

    @Column(name = "last_reviewed")
    private LocalDate lastReviewed;

    @Builder.Default
    @Column(name = "times_correct", nullable = false)
    private Integer timesCorrect = 0;

    @Builder.Default
    @Column(name = "times_wrong", nullable = false)
    private Integer timesWrong = 0;

    @Builder.Default
    @Column(name = "ef_factor", nullable = false)
    private Double efFactor = 2.5;

    @Builder.Default
    @Column(name = "interval_days", nullable = false)
    private Integer intervalDays = 1;

    @Builder.Default
    @Column(nullable = false)
    private Integer repetition = 0;

    @Column(name = "next_review_date")
    private LocalDate nextReviewDate;
}
