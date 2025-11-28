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
@Table(name = "tokens", indexes = {
        @Index(name = "idx_token_user_id", columnList = "user_id"),
        @Index(name = "idx_token_token", columnList = "token"),
        @Index(name = "idx_token_refresh_token", columnList = "refresh_token")
})
public class Token implements Serializable {

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

    @Column(nullable = false, unique = true, length = 500)
    private String token;

    @Column(name = "refresh_token", unique = true, length = 500)
    private String refreshToken;

    @Builder.Default
    @Column(nullable = false)
    private Boolean expired = false;

    @Builder.Default
    @Column(nullable = false)
    private Boolean revoked = false;
}
