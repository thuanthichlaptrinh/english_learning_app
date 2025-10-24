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

    // Admin methods
    org.springframework.data.domain.Page<User> findByNameContainingIgnoreCaseOrEmailContainingIgnoreCase(
            String name, String email, org.springframework.data.domain.Pageable pageable);

    long countByActivated(boolean activated);

    long countByBanned(boolean banned);

    @Query("SELECT COUNT(u) FROM User u JOIN u.roles r WHERE r.name = :roleName")
    long countByRoles_Name(@Param("roleName") String roleName);

}
