package com.thuanthichlaptrinh.card_words.dataprovider.repository;

import com.thuanthichlaptrinh.card_words.core.domain.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessage, UUID> {

    List<ChatMessage> findBySessionIdOrderByCreatedAtAsc(UUID sessionId);

    List<ChatMessage> findBySessionIdOrderByCreatedAtDesc(UUID sessionId);

    List<ChatMessage> findByUserId(UUID userId);

    void deleteBySessionId(UUID sessionId);

    long countBySessionId(UUID sessionId);
}
