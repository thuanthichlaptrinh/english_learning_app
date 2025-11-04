package com.thuanthichlaptrinh.card_words.core.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
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
@Table(name = "types", indexes = {
        @Index(name = "idx_type_name", columnList = "name")
})
public class Type extends BaseLongEntity {

    @Column(nullable = false, unique = true, length = 50)
    private String name;

    @JsonIgnore
    @Builder.Default
    @ManyToMany(mappedBy = "types", fetch = FetchType.LAZY)
    private Set<Vocab> vocabs = new HashSet<>();
}
