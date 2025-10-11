package com.thuanthichlaptrinh.card_words.dataprovider.repository;

import com.thuanthichlaptrinh.card_words.core.domain.UserVocabProgress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserVocabProgressRepository extends JpaRepository<UserVocabProgress, UUID> {

    Optional<UserVocabProgress> findByUserIdAndVocabId(UUID userId, UUID vocabId);

    List<UserVocabProgress> findByUserIdOrderByNextReviewDateAsc(UUID userId);

    @Query("SELECT uvp FROM UserVocabProgress uvp WHERE uvp.user.id = :userId AND uvp.nextReviewDate <= :date ORDER BY uvp.nextReviewDate")
    List<UserVocabProgress> findDueForReview(@Param("userId") UUID userId, @Param("date") LocalDate date);

    long countByUserIdAndStatus(UUID userId, String status);

    @Query("SELECT COUNT(uvp) FROM UserVocabProgress uvp WHERE uvp.user.id = :userId AND uvp.timesCorrect > 0")
    long countLearnedVocabs(@Param("userId") UUID userId);

    // Get all vocab progress with vocab details
    @Query("SELECT uvp FROM UserVocabProgress uvp LEFT JOIN FETCH uvp.vocab WHERE uvp.user.id = :userId ORDER BY uvp.lastReviewed DESC")
    List<UserVocabProgress> findByUserIdWithVocab(@Param("userId") UUID userId);

    // Get only correct vocabs (timesCorrect > 0)
    @Query("SELECT uvp FROM UserVocabProgress uvp LEFT JOIN FETCH uvp.vocab WHERE uvp.user.id = :userId AND uvp.timesCorrect > 0 ORDER BY uvp.timesCorrect DESC")
    List<UserVocabProgress> findCorrectVocabsByUserId(@Param("userId") UUID userId);

    // Get only wrong vocabs (timesWrong > 0)
    @Query("SELECT uvp FROM UserVocabProgress uvp LEFT JOIN FETCH uvp.vocab WHERE uvp.user.id = :userId AND uvp.timesWrong > 0 ORDER BY uvp.timesWrong DESC")
    List<UserVocabProgress> findWrongVocabsByUserId(@Param("userId") UUID userId);

    // Count total correct attempts by user
    @Query("SELECT SUM(uvp.timesCorrect) FROM UserVocabProgress uvp WHERE uvp.user.id = :userId")
    Long countTotalCorrectAttempts(@Param("userId") UUID userId);

    // Count total wrong attempts by user
    @Query("SELECT SUM(uvp.timesWrong) FROM UserVocabProgress uvp WHERE uvp.user.id = :userId")
    Long countTotalWrongAttempts(@Param("userId") UUID userId);
}
