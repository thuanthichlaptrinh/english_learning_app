package com.thuanthichlaptrinh.card_words.core.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
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
@Table(name = "vocab", indexes = {
                @Index(name = "idx_vocab_word", columnList = "word"),
                @Index(name = "idx_vocab_cefr", columnList = "cefr")
})
public class Vocab implements Serializable {

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

        @Column(nullable = false, unique = true, length = 100)
        private String word;

        @Column(length = 100)
        private String transcription;

        @Column(name = "meaning_vi", length = 500)
        private String meaningVi;

        @Column(length = 1000)
        private String interpret;

        @Column(name = "example_sentence", length = 1000)
        private String exampleSentence;

        @Column(length = 10)
        private String cefr;

        @Column(length = 500)
        private String img;

        @Column(length = 500)
        private String audio;

        @Column(length = 255)
        private String credit;

        @JsonIgnore
        @Builder.Default
        @ManyToMany(fetch = FetchType.LAZY)
        @JoinTable(name = "vocab_types", joinColumns = @JoinColumn(name = "vocab_id"), inverseJoinColumns = @JoinColumn(name = "type_id"), indexes = {
                        @Index(name = "idx_vocab_types_vocab_id", columnList = "vocab_id"),
                        @Index(name = "idx_vocab_types_type_id", columnList = "type_id")
        })
        private Set<Type> types = new HashSet<>();

        @JsonIgnore
        @ManyToOne(fetch = FetchType.LAZY)
        @JoinColumn(name = "topic_id")
        private Topic topic;

        @JsonIgnore
        @Builder.Default
        @OneToMany(mappedBy = "vocab", cascade = CascadeType.ALL)
        private Set<UserVocabProgress> userProgress = new HashSet<>();

        @JsonIgnore
        @Builder.Default
        @OneToMany(mappedBy = "vocab", cascade = CascadeType.ALL)
        private Set<GameSessionDetail> gameSessionDetails = new HashSet<>();
}
