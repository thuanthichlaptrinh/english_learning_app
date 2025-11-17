package com.thuanthichlaptrinh.card_words.dataprovider.repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import java.time.LocalDateTime;

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
    Page<User> findByNameContainingIgnoreCaseOrEmailContainingIgnoreCase(String name, String email, Pageable pageable);

    long countByActivated(boolean activated);

    long countByBanned(boolean banned);

    @Query("SELECT COUNT(u) FROM User u JOIN u.roles r WHERE r.name = :roleName")
    long countByRoles_Name(@Param("roleName") String roleName);

    // Dashboard queries
    @Query("SELECT CAST(u.createdAt AS LocalDate) as date, COUNT(u) as count " +
            "FROM User u " +
            "WHERE u.createdAt >= :startDate " +
            "GROUP BY CAST(u.createdAt AS LocalDate) " +
            "ORDER BY CAST(u.createdAt AS LocalDate) ASC")
    List<Object[]> countUserRegistrationsByDate(@Param("startDate") LocalDateTime startDate);

    @Query("SELECT u FROM User u " +
            "LEFT JOIN u.vocabProgress vp " +
            "GROUP BY u.id " +
            "ORDER BY COUNT(vp) DESC")
    Page<User> findTopLearners(Pageable pageable);

}
