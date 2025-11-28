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

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "topics", indexes = {
        @Index(name = "idx_topic_name", columnList = "name")
})
public class Topic implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @Column(nullable = false, unique = true, length = 100)
    private String name;

    @Column(length = 500)
    private String description;

    @Column(length = 1000)
    private String img;

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "topic", cascade = CascadeType.ALL)
    private Set<Vocab> vocabs = new HashSet<>();

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "topic", cascade = CascadeType.ALL)
    private Set<GameSession> gameSessions = new HashSet<>();
}
