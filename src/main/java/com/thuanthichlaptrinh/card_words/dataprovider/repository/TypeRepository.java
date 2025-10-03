package com.thuanthichlaptrinh.card_words.dataprovider.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.thuanthichlaptrinh.card_words.core.domain.Type;

@Repository
public interface TypeRepository extends JpaRepository<Type, Long> {

    Optional<Type> findByName(String name);

    boolean existsByName(String name);

}