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
@Table(name = "games", indexes = {
        @Index(name = "idx_game_name", columnList = "name")
})
public class Game extends BaseLongEntity {

    @Column(nullable = false, unique = true, length = 100)
    private String name;

    @Column(length = 500)
    private String description;

    @Column(name = "rules_json", columnDefinition = "TEXT")
    private String rulesJson;

    @Builder.Default
    @OneToMany(mappedBy = "game", cascade = CascadeType.ALL)
    private Set<GameSession> gameSessions = new HashSet<>();
}
