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
@Table(name = "user_game_settings", uniqueConstraints = @UniqueConstraint(name = "uq_user_game_settings_user_id", columnNames = {
                "user_id" }), indexes = {
                                @Index(name = "idx_ugs_user_id", columnList = "user_id")
                })
public class UserGameSetting implements Serializable {

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

        // Quick Quiz settings
        @Column(name = "quick_quiz_total_questions")
        private Integer quickQuizTotalQuestions;

        @Column(name = "quick_quiz_time_per_question")
        private Integer quickQuizTimePerQuestion;

        // Image Word Matching settings
        @Column(name = "image_word_total_pairs")
        private Integer imageWordTotalPairs;

        // Word Definition Matching settings
        @Column(name = "word_definition_total_pairs")
        private Integer wordDefinitionTotalPairs;

}
