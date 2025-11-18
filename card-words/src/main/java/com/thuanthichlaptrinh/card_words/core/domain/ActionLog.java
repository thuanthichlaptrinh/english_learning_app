package com.thuanthichlaptrinh.card_words.core.domain;

import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "action_logs", indexes = {
        @Index(name = "idx_action_log_user_id", columnList = "user_id"),
        @Index(name = "idx_action_log_action_type", columnList = "action_type"),
        @Index(name = "idx_action_log_resource_type", columnList = "resource_type"),
        @Index(name = "idx_action_log_status", columnList = "status"),
        @Index(name = "idx_action_log_created_at", columnList = "created_at")
})
public class ActionLog extends BaseLongEntity {

    @Column(name = "user_id")
    private UUID userId;

    @Column(name = "user_email", length = 100)
    private String userEmail;

    @Column(name = "user_name", length = 100)
    private String userName;

    @Column(name = "action_type", nullable = false, length = 50)
    private String actionType; // USER_LOGIN, USER_LOGOUT, VOCAB_CREATE, VOCAB_UPDATE, etc.

    @Column(name = "action_category", length = 50)
    private String actionCategory; // SYSTEM, USER, VOCAB, GAME, etc.

    @Column(name = "resource_type", length = 50)
    private String resourceType; // Authentication System, Vocabulary, User, Game, etc.

    @Column(name = "resource_id", length = 100)
    private String resourceId; // ID of the affected resource

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false, length = 20)
    @Builder.Default
    private String status = "SUCCESS"; // SUCCESS, FAILED

    @Column(name = "ip_address", length = 50)
    private String ipAddress;

    @Column(name = "user_agent", columnDefinition = "TEXT")
    private String userAgent;

    @Column(columnDefinition = "TEXT")
    private String metadata; // JSON string for additional data
}
