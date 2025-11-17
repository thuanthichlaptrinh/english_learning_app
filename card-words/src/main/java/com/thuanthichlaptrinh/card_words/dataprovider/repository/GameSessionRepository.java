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

    Page<GameSession> findByGameIdAndUserIdOrderByStartedAtDesc(Long gameId, UUID userId, Pageable pageable);

    @Query("SELECT gs FROM GameSession gs WHERE gs.game.id = :gameId ORDER BY gs.score DESC, gs.accuracy DESC")
    Page<GameSession> findTopScoresByGame(@Param("gameId") Long gameId, Pageable pageable);

    @Query("SELECT gs FROM GameSession gs WHERE gs.finishedAt IS NOT NULL ORDER BY gs.score DESC")
    Page<GameSession> findGlobalLeaderboard(Pageable pageable);

    List<GameSession> findByUserIdAndGameIdOrderByCreatedAtDesc(UUID userId, Long gameId);

    List<GameSession> findByUserIdAndGameId(UUID userId, Long gameId);

    // Admin methods
    Page<GameSession> findByGameId(Long gameId, Pageable pageable);

    long countByGameId(Long gameId);

    long countByGameIdAndFinishedAtIsNotNull(Long gameId);

    long countByFinishedAtIsNotNull();

    @Query("SELECT AVG(gs.score) FROM GameSession gs WHERE gs.game.id = :gameId AND gs.finishedAt IS NOT NULL")
    Double findAverageScoreByGameId(@Param("gameId") Long gameId);

    @Query("SELECT MAX(gs.score) FROM GameSession gs WHERE gs.game.id = :gameId AND gs.finishedAt IS NOT NULL")
    Integer findHighestScoreByGameId(@Param("gameId") Long gameId);

    @Query("SELECT MIN(gs.score) FROM GameSession gs WHERE gs.game.id = :gameId AND gs.finishedAt IS NOT NULL")
    Integer findLowestScoreByGameId(@Param("gameId") Long gameId);

    @Query("SELECT AVG(gs.accuracy) FROM GameSession gs WHERE gs.game.id = :gameId AND gs.finishedAt IS NOT NULL")
    Double findAverageAccuracyByGameId(@Param("gameId") Long gameId);

    @Query("SELECT AVG(gs.score) FROM GameSession gs WHERE gs.finishedAt IS NOT NULL")
    Double findOverallAverageScore();

    @Query("SELECT MAX(gs.score) FROM GameSession gs WHERE gs.finishedAt IS NOT NULL")
    Integer findOverallHighestScore();

    // User high scores
    @Query("SELECT MAX(gs.score) FROM GameSession gs WHERE gs.user.id = :userId AND gs.game.id = :gameId AND gs.finishedAt IS NOT NULL")
    Integer findHighestScoreByUserAndGame(@Param("userId") UUID userId, @Param("gameId") Long gameId);
}
