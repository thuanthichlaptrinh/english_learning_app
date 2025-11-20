package com.thuanthichlaptrinh.card_words.dataprovider.repository;

import com.thuanthichlaptrinh.card_words.core.domain.Notification;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {

        // Find by user
        Page<Notification> findByUserIdOrderByCreatedAtDesc(UUID userId, Pageable pageable);

        // Find unread notifications
        Page<Notification> findByUserIdAndIsReadFalseOrderByCreatedAtDesc(UUID userId, Pageable pageable);

        // Find read notifications
        Page<Notification> findByUserIdAndIsReadTrueOrderByCreatedAtDesc(UUID userId, Pageable pageable);

        // Find by type
        Page<Notification> findByUserIdAndTypeOrderByCreatedAtDesc(UUID userId, String type, Pageable pageable);

        // Combined filters
        @Query("SELECT n FROM Notification n WHERE n.user.id = :userId AND " +
                        "(:isRead IS NULL OR n.isRead = :isRead) AND " +
                        "(:type IS NULL OR n.type = :type) " +
                        "ORDER BY n.createdAt DESC")
        Page<Notification> findByFilters(
                        @Param("userId") UUID userId,
                        @Param("isRead") Boolean isRead,
                        @Param("type") String type,
                        Pageable pageable);

        // Count unread
        long countByUserIdAndIsReadFalse(UUID userId);

        // Count by type
        long countByUserIdAndType(UUID userId, String type);

        // Mark as read
        @Modifying
        @Query("UPDATE Notification n SET n.isRead = true WHERE n.id = :id AND n.user.id = :userId")
        int markAsRead(@Param("id") Long id, @Param("userId") UUID userId);

        // Mark all as read
        @Modifying
        @Query("UPDATE Notification n SET n.isRead = true WHERE n.user.id = :userId AND n.isRead = false")
        int markAllAsRead(@Param("userId") UUID userId);

        // Delete by user
        void deleteByUserId(UUID userId);

        // Delete read notifications
        @Modifying
        @Query("DELETE FROM Notification n WHERE n.user.id = :userId AND n.isRead = true")
        int deleteReadNotifications(@Param("userId") UUID userId);

        // Get recent notifications
        List<Notification> findTop10ByUserIdOrderByCreatedAtDesc(UUID userId);

        // Admin: Count all unread
        long countByIsReadFalse();

        // Admin: Count by type
        long countByType(String type);
}
