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

    // Pagination
    Page<ActionLog> findAll(Pageable pageable);

    // Filter by user
    Page<ActionLog> findByUserId(UUID userId, Pageable pageable);

    // Filter by action type
    Page<ActionLog> findByActionType(String actionType, Pageable pageable);

    // Filter by resource type
    Page<ActionLog> findByResourceType(String resourceType, Pageable pageable);

    // Filter by status
    Page<ActionLog> findByStatus(String status, Pageable pageable);

    // Filter by date range
    Page<ActionLog> findByCreatedAtBetween(LocalDateTime startDate, LocalDateTime endDate, Pageable pageable);

    // Combined filters
    @Query("SELECT a FROM ActionLog a WHERE " +
            "(:userId IS NULL OR a.userId = :userId) AND " +
            "(:actionType IS NULL OR a.actionType = :actionType) AND " +
            "(:resourceType IS NULL OR a.resourceType = :resourceType) AND " +
            "(:status IS NULL OR a.status = :status) AND " +
            "(:startDate IS NULL OR a.createdAt >= :startDate) AND " +
            "(:endDate IS NULL OR a.createdAt <= :endDate) AND " +
            "(:keyword IS NULL OR a.description LIKE %:keyword% OR a.userEmail LIKE %:keyword% OR a.userName LIKE %:keyword%)")
    Page<ActionLog> findByFilters(
            @Param("userId") UUID userId,
            @Param("actionType") String actionType,
            @Param("resourceType") String resourceType,
            @Param("status") String status,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate,
            @Param("keyword") String keyword,
            Pageable pageable);

    // Statistics
    long countByStatus(String status);

    long countByActionType(String actionType);

    @Query("SELECT COUNT(DISTINCT a.userId) FROM ActionLog a")
    long countDistinctUsers();

    @Query("SELECT COUNT(a) FROM ActionLog a WHERE a.createdAt >= :startDate")
    long countByCreatedAtAfter(@Param("startDate") LocalDateTime startDate);

    // Get recent actions
    List<ActionLog> findTop10ByOrderByCreatedAtDesc();

    // Export data
    @Query("SELECT a FROM ActionLog a WHERE " +
            "(:startDate IS NULL OR a.createdAt >= :startDate) AND " +
            "(:endDate IS NULL OR a.createdAt <= :endDate)")
    List<ActionLog> findForExport(
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate);
}
