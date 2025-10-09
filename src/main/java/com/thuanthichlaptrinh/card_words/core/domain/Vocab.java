package com.thuanthichlaptrinh.card_words.core.domain;

import jakarta.persistence.*;
import lombok.*;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import org.hibernate.annotations.GenericGenerator;

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
public class Vocab extends BaseEntity {
    @Id
    @GeneratedValue(generator = "UUID")
    @GenericGenerator(name = "UUID", strategy = "org.hibernate.id.UUIDGenerator")
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "uuid")
    private UUID id;

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

    @Builder.Default
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "vocab_types", joinColumns = @JoinColumn(name = "vocab_id"), inverseJoinColumns = @JoinColumn(name = "type_id"), indexes = {
            @Index(name = "idx_vocab_types_vocab_id", columnList = "vocab_id"),
            @Index(name = "idx_vocab_types_type_id", columnList = "type_id")
    })
    private Set<Type> types = new HashSet<>();

    @Builder.Default
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "vocab_topics", joinColumns = @JoinColumn(name = "vocab_id"), inverseJoinColumns = @JoinColumn(name = "topic_id"), indexes = {
            @Index(name = "idx_vocab_topics_vocab_id", columnList = "vocab_id"),
            @Index(name = "idx_vocab_topics_topic_id", columnList = "topic_id")
    })
    private Set<Topic> topics = new HashSet<>();

    @Builder.Default
    @ManyToMany(mappedBy = "vocabs", fetch = FetchType.LAZY)
    private Set<Package> packages = new HashSet<>();

    @Builder.Default
    @OneToMany(mappedBy = "vocab", cascade = CascadeType.ALL)
    private Set<UserVocabProgress> userProgress = new HashSet<>();

    @Builder.Default
    @OneToMany(mappedBy = "vocab", cascade = CascadeType.ALL)
    private Set<GameSessionDetail> gameSessionDetails = new HashSet<>();
}
