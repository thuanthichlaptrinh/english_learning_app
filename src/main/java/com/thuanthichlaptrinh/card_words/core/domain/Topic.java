package com.thuanthichlaptrinh.card_words.core.domain;

import jakarta.persistence.*;
import lombok.*;

import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "topics", indexes = {
        @Index(name = "idx_topic_name", columnList = "name")
})
public class Topic extends BaseLongEntity {

    @Column(nullable = false, unique = true, length = 100)
    private String name;

    @Column(length = 500)
    private String description;

    @Builder.Default
    @OneToMany(mappedBy = "topic", cascade = CascadeType.ALL)
    private Set<Package> packages = new HashSet<>();

    @Builder.Default
    @ManyToMany(mappedBy = "topics", fetch = FetchType.LAZY)
    private Set<Vocab> vocabs = new HashSet<>();

    @Builder.Default
    @OneToMany(mappedBy = "topic", cascade = CascadeType.ALL)
    private Set<GameSession> gameSessions = new HashSet<>();
}
