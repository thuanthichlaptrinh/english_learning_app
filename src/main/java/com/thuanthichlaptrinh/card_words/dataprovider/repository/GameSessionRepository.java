package com.thuanthichlaptrinh.card_words.dataprovider.repository;

import com.thuanthichlaptrinh.card_words.core.domain.GameSession;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface GameSessionRepository extends JpaRepository<GameSession, Long> {

    List<GameSession> findByUserIdOrderByStartedAtDesc(UUID userId);

    Page<GameSession> findByUserIdOrderByStartedAtDesc(UUID userId, Pageable pageable);

    List<GameSession> findByGameIdAndUserIdOrderByStartedAtDesc(Long gameId, UUID userId);

    @Query("SELECT gs FROM GameSession gs WHERE gs.game.id = :gameId ORDER BY gs.score DESC, gs.accuracy DESC")
    Page<GameSession> findTopScoresByGame(@Param("gameId") Long gameId, Pageable pageable);

    @Query("SELECT gs FROM GameSession gs WHERE gs.finishedAt IS NOT NULL ORDER BY gs.score DESC")
    Page<GameSession> findGlobalLeaderboard(Pageable pageable);
}
