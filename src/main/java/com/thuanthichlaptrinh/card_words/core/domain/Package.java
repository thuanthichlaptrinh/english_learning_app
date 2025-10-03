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
@Table(name = "packages", indexes = {
        @Index(name = "idx_package_name", columnList = "name"),
        @Index(name = "idx_package_topic_id", columnList = "topic_id"),
        @Index(name = "idx_package_version", columnList = "version")
})
public class Package extends BaseLongEntity {

    @Column(nullable = false, length = 100)
    private String name;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "topic_id")
    private Topic topic;

    @Column(nullable = false, length = 20)
    private String version;

    @Builder.Default
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "vocab_packages", joinColumns = @JoinColumn(name = "package_id"), inverseJoinColumns = @JoinColumn(name = "vocab_id"), indexes = {
            @Index(name = "idx_vocab_packages_package_id", columnList = "package_id"),
            @Index(name = "idx_vocab_packages_vocab_id", columnList = "vocab_id")
    })
    private Set<Vocab> vocabs = new HashSet<>();
}
