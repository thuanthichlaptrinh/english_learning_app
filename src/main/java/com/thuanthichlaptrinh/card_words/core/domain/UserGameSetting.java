package com.thuanthichlaptrinh.card_words.core.domain;

import jakarta.persistence.*;
import lombok.*;

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
public class UserGameSetting extends BaseUUIDEntity {

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
