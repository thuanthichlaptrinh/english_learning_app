package com.thuanthichlaptrinh.card_words.core.domain;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "notifications", indexes = {
        @Index(name = "idx_notif_user_id", columnList = "user_id"),
        @Index(name = "idx_notif_is_read", columnList = "is_read"),
        @Index(name = "idx_notif_type", columnList = "type"),
        @Index(name = "idx_notif_created_at", columnList = "created_at")
})
public class Notification extends BaseLongEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false, length = 255)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String content;

    @Column(length = 50)
    private String type;

    @Builder.Default
    @Column(name = "is_read", nullable = false)
    private Boolean isRead = false;
}
