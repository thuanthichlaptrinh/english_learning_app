package com.thuanthichlaptrinh.card_words.dataprovider.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.thuanthichlaptrinh.card_words.core.domain.User;

@Repository
public interface UserRepository extends JpaRepository<User, UUID> {

    @Query("SELECT u FROM User u WHERE u.email = :identifier OR u.name = :identifier")
    Optional<User> findByEmailOrPhone(@Param("identifier") String identifier);

    Optional<User> findByEmail(String email);

    @Query("SELECT u FROM User u JOIN FETCH u.roles WHERE u.email = :email")
    Optional<User> findByEmailWithRoles(@Param("email") String email);

    Optional<User> findByActivationKey(String activationKey);

    boolean existsByEmail(String email);

}
