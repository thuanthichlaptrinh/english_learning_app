package com.thuanthichlaptrinh.card_words.dataprovider.repository;

import com.thuanthichlaptrinh.card_words.core.domain.ActionLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface ActionLogRepository extends JpaRepository<ActionLog, Long> {

        Page<ActionLog> findAll(Pageable pageable);

        Page<ActionLog> findByUserId(UUID userId, Pageable pageable);

        Page<ActionLog> findByActionType(String actionType, Pageable pageable);

        Page<ActionLog> findByResourceType(String resourceType, Pageable pageable);

        Page<ActionLog> findByStatus(String status, Pageable pageable);

        Page<ActionLog> findByCreatedAtBetween(LocalDateTime startDate, LocalDateTime endDate, Pageable pageable);

        @Query("SELECT a FROM ActionLog a WHERE " +
                        "(:#{#userId == null} = true OR a.userId = :userId) AND " +
                        "(:#{#actionType == null} = true OR a.actionType = :actionType) AND " +
                        "(:#{#resourceType == null} = true OR a.resourceType = :resourceType) AND " +
                        "(:#{#status == null} = true OR a.status = :status) AND " +
                        "(:#{#startDate == null} = true OR a.createdAt >= :startDate) AND " +
                        "(:#{#endDate == null} = true OR a.createdAt <= :endDate) AND " +
                        "(:#{#keyword == null || #keyword == ''} = true OR " +
                        "LOWER(a.description) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                        "LOWER(a.userEmail) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                        "LOWER(a.userName) LIKE LOWER(CONCAT('%', :keyword, '%')))")
        Page<ActionLog> findByFilters(
                        @Param("userId") UUID userId,
                        @Param("actionType") String actionType,
                        @Param("resourceType") String resourceType,
                        @Param("status") String status,
                        @Param("startDate") LocalDateTime startDate,
                        @Param("endDate") LocalDateTime endDate,
                        @Param("keyword") String keyword,
                        Pageable pageable);

        long countByStatus(String status);

        long countByActionType(String actionType);

        @Query("SELECT COUNT(DISTINCT a.userId) FROM ActionLog a")
        long countDistinctUsers();

        @Query("SELECT COUNT(a) FROM ActionLog a WHERE a.createdAt >= :startDate")
        long countByCreatedAtAfter(@Param("startDate") LocalDateTime startDate);

        List<ActionLog> findTop10ByOrderByCreatedAtDesc();

        // Export data
        @Query("SELECT a FROM ActionLog a WHERE " +
                        "(:#{#startDate == null} = true OR a.createdAt >= :startDate) AND " +
                        "(:#{#endDate == null} = true OR a.createdAt <= :endDate)")
        List<ActionLog> findForExport(
                        @Param("startDate") LocalDateTime startDate,
                        @Param("endDate") LocalDateTime endDate);
}