package com.thuanthichlaptrinh.card_words.dataprovider.repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.thuanthichlaptrinh.card_words.core.domain.Vocab;

@Repository
public interface VocabRepository extends JpaRepository<Vocab, UUID> {

    Optional<Vocab> findByWord(String word);

    boolean existsByWord(String word);

    List<Vocab> findByCefr(String cefr);

    @Query("SELECT v FROM Vocab v LEFT JOIN FETCH v.types LEFT JOIN FETCH v.topics WHERE v.word LIKE %:keyword% OR v.meaningVi LIKE %:keyword%")
    Page<Vocab> searchByKeyword(@Param("keyword") String keyword, Pageable pageable);

    @Query("SELECT v FROM Vocab v LEFT JOIN FETCH v.types LEFT JOIN FETCH v.topics WHERE v.cefr = :cefr")
    Page<Vocab> findByCefrWithPaging(@Param("cefr") String cefr, Pageable pageable);

    @Query("SELECT v FROM Vocab v LEFT JOIN FETCH v.types LEFT JOIN FETCH v.topics WHERE v.id = :id")
    Optional<Vocab> findByIdWithTypesAndTopics(@Param("id") UUID id);

    @Query("SELECT v FROM Vocab v LEFT JOIN FETCH v.types LEFT JOIN FETCH v.topics WHERE v.word = :word")
    Optional<Vocab> findByWordWithTypesAndTopics(@Param("word") String word);

    @Query("SELECT v FROM Vocab v LEFT JOIN FETCH v.types LEFT JOIN FETCH v.topics")
    Page<Vocab> findAllWithTypesAndTopics(Pageable pageable);
}