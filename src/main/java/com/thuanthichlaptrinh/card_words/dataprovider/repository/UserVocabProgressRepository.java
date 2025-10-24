package com.thuanthichlaptrinh.card_words.dataprovider.repository;

import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
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

    @Query("SELECT uvp FROM UserVocabProgress uvp WHERE uvp.user.id = :userId AND uvp.nextReviewDate IS NOT NULL AND uvp.nextReviewDate <= :date ORDER BY uvp.nextReviewDate")
    List<UserVocabProgress> findDueForReview(@Param("userId") UUID userId, @Param("date") LocalDate date);

    long countByUserIdAndStatus(UUID userId, VocabStatus status);

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

    // Admin methods
    @Query("SELECT uvp FROM UserVocabProgress uvp LEFT JOIN FETCH uvp.vocab WHERE uvp.user.id = :userId")
    org.springframework.data.domain.Page<UserVocabProgress> findByUserId(@Param("userId") UUID userId,
            org.springframework.data.domain.Pageable pageable);

    @Query("SELECT uvp FROM UserVocabProgress uvp WHERE uvp.vocab.id = :vocabId")
    List<UserVocabProgress> findByVocabId(@Param("vocabId") UUID vocabId);

    @Query("SELECT SUM(uvp.timesCorrect) FROM UserVocabProgress uvp")
    Long sumAllTimesCorrect();

    @Query("SELECT SUM(uvp.timesWrong) FROM UserVocabProgress uvp")
    Long sumAllTimesWrong();

    void deleteByUserId(UUID userId);

    // Queries for review by topic with pagination
    @Query("SELECT uvp FROM UserVocabProgress uvp " +
            "LEFT JOIN FETCH uvp.vocab v " +
            "LEFT JOIN v.topics t " +
            "WHERE uvp.user.id = :userId " +
            "AND LOWER(t.name) = LOWER(:topicName) " +
            "AND uvp.nextReviewDate IS NOT NULL " +
            "AND uvp.nextReviewDate <= :date " +
            "ORDER BY uvp.nextReviewDate ASC")
    org.springframework.data.domain.Page<UserVocabProgress> findDueForReviewByTopicPaged(
            @Param("userId") UUID userId,
            @Param("topicName") String topicName,
            @Param("date") LocalDate date,
            org.springframework.data.domain.Pageable pageable);

    @Query("SELECT uvp FROM UserVocabProgress uvp " +
            "LEFT JOIN FETCH uvp.vocab v " +
            "WHERE uvp.user.id = :userId " +
            "AND uvp.nextReviewDate IS NOT NULL " +
            "AND uvp.nextReviewDate <= :date " +
            "ORDER BY uvp.nextReviewDate ASC")
    org.springframework.data.domain.Page<UserVocabProgress> findDueForReviewPaged(
            @Param("userId") UUID userId,
            @Param("date") LocalDate date,
            org.springframework.data.domain.Pageable pageable);

    @Query("SELECT v FROM Vocab v " +
            "LEFT JOIN v.topics t " +
            "WHERE LOWER(t.name) = LOWER(:topicName) " +
            "AND v.id NOT IN (SELECT uvp.vocab.id FROM UserVocabProgress uvp WHERE uvp.user.id = :userId) " +
            "ORDER BY v.word ASC")
    org.springframework.data.domain.Page<com.thuanthichlaptrinh.card_words.core.domain.Vocab> findUnlearnedVocabsByTopicPaged(
            @Param("userId") UUID userId,
            @Param("topicName") String topicName,
            org.springframework.data.domain.Pageable pageable);

    @Query("SELECT v FROM Vocab v " +
            "WHERE v.id NOT IN (SELECT uvp.vocab.id FROM UserVocabProgress uvp WHERE uvp.user.id = :userId) " +
            "ORDER BY v.word ASC")
    org.springframework.data.domain.Page<com.thuanthichlaptrinh.card_words.core.domain.Vocab> findAllUnlearnedVocabsPaged(
            @Param("userId") UUID userId,
            org.springframework.data.domain.Pageable pageable);

    // Queries for LEARNING vocabs (based on STATUS only - for learn-vocabs API)
    // Lấy từ đang học (KNOWN hoặc UNKNOWN) theo topic - KHÔNG dùng nextReviewDate
    @Query("SELECT uvp FROM UserVocabProgress uvp " +
            "LEFT JOIN FETCH uvp.vocab v " +
            "LEFT JOIN v.topics t " +
            "WHERE uvp.user.id = :userId " +
            "AND LOWER(t.name) = LOWER(:topicName) " +
            "AND (uvp.status = 'KNOWN' OR uvp.status = 'UNKNOWN') " +
            "ORDER BY uvp.updatedAt DESC")
    org.springframework.data.domain.Page<UserVocabProgress> findLearningVocabsByTopicPaged(
            @Param("userId") UUID userId,
            @Param("topicName") String topicName,
            org.springframework.data.domain.Pageable pageable);

    // Lấy tất cả từ đang học (KNOWN hoặc UNKNOWN) - KHÔNG dùng nextReviewDate
    @Query("SELECT uvp FROM UserVocabProgress uvp " +
            "LEFT JOIN FETCH uvp.vocab v " +
            "WHERE uvp.user.id = :userId " +
            "AND (uvp.status = 'KNOWN' OR uvp.status = 'UNKNOWN') " +
            "ORDER BY uvp.updatedAt DESC")
    org.springframework.data.domain.Page<UserVocabProgress> findLearningVocabsPaged(
            @Param("userId") UUID userId,
            org.springframework.data.domain.Pageable pageable);

    @Query("SELECT uvp FROM UserVocabProgress uvp " +
            "LEFT JOIN FETCH uvp.vocab v " +
            "WHERE uvp.user.id = :userId " +
            "AND uvp.status = 'NEW' " +
            "ORDER BY uvp.createdAt ASC")
    org.springframework.data.domain.Page<UserVocabProgress> findNewVocabsByUserPaged(
            @Param("userId") UUID userId,
            org.springframework.data.domain.Pageable pageable);

    @Query("SELECT uvp FROM UserVocabProgress uvp " +
            "LEFT JOIN FETCH uvp.vocab v " +
            "LEFT JOIN v.topics t " +
            "WHERE uvp.user.id = :userId " +
            "AND LOWER(t.name) = LOWER(:topicName) " +
            "AND uvp.status = 'NEW' " +
            "ORDER BY uvp.createdAt ASC")
    org.springframework.data.domain.Page<UserVocabProgress> findNewVocabsByUserAndTopicPaged(
            @Param("userId") UUID userId,
            @Param("topicName") String topicName,
            org.springframework.data.domain.Pageable pageable);

    // Queries for review by topic (non-paged - keep for backward compatibility)
    @Query("SELECT uvp FROM UserVocabProgress uvp " +
            "LEFT JOIN FETCH uvp.vocab v " +
            "LEFT JOIN v.topics t " +
            "WHERE uvp.user.id = :userId " +
            "AND LOWER(t.name) = LOWER(:topicName) " +
            "AND uvp.nextReviewDate IS NOT NULL " +
            "AND uvp.nextReviewDate <= :date " +
            "ORDER BY uvp.nextReviewDate ASC")
    List<UserVocabProgress> findDueForReviewByTopic(@Param("userId") UUID userId,
            @Param("topicName") String topicName,
            @Param("date") LocalDate date);

    @Query("SELECT v FROM Vocab v " +
            "LEFT JOIN v.topics t " +
            "WHERE LOWER(t.name) = LOWER(:topicName) " +
            "AND v.id NOT IN (SELECT uvp.vocab.id FROM UserVocabProgress uvp WHERE uvp.user.id = :userId) " +
            "ORDER BY v.word ASC")
    List<com.thuanthichlaptrinh.card_words.core.domain.Vocab> findUnlearnedVocabsByTopic(
            @Param("userId") UUID userId,
            @Param("topicName") String topicName);

    @Query("SELECT uvp FROM UserVocabProgress uvp " +
            "LEFT JOIN FETCH uvp.vocab v " +
            "WHERE uvp.user.id = :userId " +
            "AND uvp.status = 'NEW' " +
            "ORDER BY uvp.createdAt ASC")
    List<UserVocabProgress> findNewVocabsByUser(@Param("userId") UUID userId);

    @Query("SELECT uvp FROM UserVocabProgress uvp " +
            "LEFT JOIN FETCH uvp.vocab v " +
            "LEFT JOIN v.topics t " +
            "WHERE uvp.user.id = :userId " +
            "AND LOWER(t.name) = LOWER(:topicName) " +
            "AND uvp.status = 'NEW' " +
            "ORDER BY uvp.createdAt ASC")
    List<UserVocabProgress> findNewVocabsByUserAndTopic(@Param("userId") UUID userId,
            @Param("topicName") String topicName);

    // Non-paged queries for LEARNING vocabs (based on STATUS only)
    @Query("SELECT uvp FROM UserVocabProgress uvp " +
            "LEFT JOIN FETCH uvp.vocab v " +
            "LEFT JOIN v.topics t " +
            "WHERE uvp.user.id = :userId " +
            "AND LOWER(t.name) = LOWER(:topicName) " +
            "AND (uvp.status = 'KNOWN' OR uvp.status = 'UNKNOWN') " +
            "ORDER BY uvp.updatedAt DESC")
    List<UserVocabProgress> findLearningVocabsByTopic(@Param("userId") UUID userId,
            @Param("topicName") String topicName);

    @Query("SELECT uvp FROM UserVocabProgress uvp " +
            "LEFT JOIN FETCH uvp.vocab v " +
            "WHERE uvp.user.id = :userId " +
            "AND (uvp.status = 'KNOWN' OR uvp.status = 'UNKNOWN') " +
            "ORDER BY uvp.updatedAt DESC")
    List<UserVocabProgress> findLearningVocabs(@Param("userId") UUID userId);
}
