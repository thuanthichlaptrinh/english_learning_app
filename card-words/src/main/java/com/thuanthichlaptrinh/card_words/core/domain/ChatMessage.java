package com.thuanthichlaptrinh.card_words.core.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.GenericGenerator;

import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "chat_messages", indexes = {
        @Index(name = "idx_chat_user_id", columnList = "user_id"),
        @Index(name = "idx_chat_session_id", columnList = "session_id"),
        @Index(name = "idx_chat_created_at", columnList = "created_at")
})
public class ChatMessage extends BaseEntity {

    @Id
    @GeneratedValue(generator = "UUID")
    @GenericGenerator(name = "UUID", strategy = "org.hibernate.id.UUIDGenerator")
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "uuid")
    private UUID id;

    @Column(name = "session_id", nullable = false, columnDefinition = "uuid")
    private UUID sessionId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    @JsonIgnore
    private User user;

    @Column(nullable = false, length = 10)
    @Enumerated(EnumType.STRING)
    private MessageRole role;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    @Column(name = "context_used", columnDefinition = "TEXT")
    private String contextUsed;

    @Column(name = "tokens_used")
    private Integer tokensUsed;

    public enum MessageRole {
        USER, ASSISTANT, SYSTEM
    }
}
