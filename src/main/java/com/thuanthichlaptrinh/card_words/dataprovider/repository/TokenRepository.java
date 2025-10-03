package com.thuanthichlaptrinh.card_words.dataprovider.repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.thuanthichlaptrinh.card_words.core.domain.Token;

@Repository
public interface TokenRepository extends JpaRepository<Token, UUID> {

    @Query("""
                SELECT t FROM Token t
                INNER JOIN User u ON t.user.id = u.id
                WHERE u.id = :userId AND (t.expired = false OR t.revoked = false)
            """)
    List<Token> findAllValidTokenByUser(UUID userId);

    Optional<Token> findByToken(String token);
}
