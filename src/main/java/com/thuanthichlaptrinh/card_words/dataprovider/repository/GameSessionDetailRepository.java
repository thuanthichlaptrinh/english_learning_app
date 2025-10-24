package com.thuanthichlaptrinh.card_words.dataprovider.repository;

import com.thuanthichlaptrinh.card_words.core.domain.GameSessionDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface GameSessionDetailRepository extends JpaRepository<GameSessionDetail, Long> {

    List<GameSessionDetail> findBySessionIdOrderById(Long sessionId);

    @Query("SELECT gsd FROM GameSessionDetail gsd WHERE gsd.session.id = :sessionId AND gsd.vocab.id = :vocabId")
    List<GameSessionDetail> findBySessionIdAndVocabId(@Param("sessionId") Long sessionId,
            @Param("vocabId") UUID vocabId);

    long countBySessionIdAndIsCorrect(Long sessionId, Boolean isCorrect);

    // Admin method
    List<GameSessionDetail> findBySessionId(Long sessionId);
}
