package com.thuanthichlaptrinh.card_words.core.usecase.admin;

import com.thuanthichlaptrinh.card_words.core.domain.ActionLog;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.ActionLogRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.ActionLogFilterRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ActionLogResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ActionLogStatisticsResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class ActionLogService {

    private final ActionLogRepository actionLogRepository;

    /**
     * Get action logs with filters and pagination
     */
    public Page<ActionLogResponse> getActionLogs(ActionLogFilterRequest request) {
        log.info("Admin: Lấy danh sách action logs với filters");

        Sort sort = Sort.by(
                "DESC".equalsIgnoreCase(request.getSortDirection()) ? Sort.Direction.DESC : Sort.Direction.ASC,
                request.getSortBy());

        Pageable pageable = PageRequest.of(request.getPage(), request.getSize(), sort);

        Page<ActionLog> actionLogs = actionLogRepository.findByFilters(
                request.getUserId(),
                request.getActionType(),
                request.getResourceType(),
                request.getStatus(),
                request.getStartDate(),
                request.getEndDate(),
                request.getKeyword(),
                pageable);

        return actionLogs.map(this::toResponse);
    }

    /**
     * Get action log statistics
     */
    public ActionLogStatisticsResponse getStatistics() {
        log.info("Admin: Lấy thống kê action logs");

        long totalActions = actionLogRepository.count();
        long successfulActions = actionLogRepository.countByStatus("SUCCESS");
        long failedActions = actionLogRepository.countByStatus("FAILED");
        long activeUsers = actionLogRepository.countDistinctUsers();

        return ActionLogStatisticsResponse.builder()
                .totalActions(totalActions)
                .successfulActions(successfulActions)
                .failedActions(failedActions)
                .activeUsers(activeUsers)
                .build();
    }

    /**
     * Log an action
     */
    public void logAction(UUID userId, String userEmail, String userName,
            String actionType, String actionCategory,
            String resourceType, String resourceId,
            String description, String status,
            String ipAddress, String userAgent) {

        ActionLog actionLog = ActionLog.builder()
                .userId(userId)
                .userEmail(userEmail)
                .userName(userName)
                .actionType(actionType)
                .actionCategory(actionCategory)
                .resourceType(resourceType)
                .resourceId(resourceId)
                .description(description)
                .status(status)
                .ipAddress(ipAddress)
                .userAgent(userAgent)
                .build();

        actionLogRepository.save(actionLog);
        log.debug("Action logged: {} - {} - {}", actionType, resourceType, status);
    }

    /**
     * Export action logs
     */
    public List<ActionLogResponse> exportActionLogs(LocalDateTime startDate, LocalDateTime endDate) {
        log.info("Admin: Export action logs từ {} đến {}", startDate, endDate);

        List<ActionLog> actionLogs = actionLogRepository.findForExport(startDate, endDate);
        return actionLogs.stream()
                .map(this::toResponse)
                .toList();
    }

    /**
     * Delete old action logs
     */
    public void deleteOldLogs(int daysToKeep) {
        log.info("Admin: Xóa action logs cũ hơn {} ngày", daysToKeep);

        LocalDateTime cutoffDate = LocalDateTime.now().minusDays(daysToKeep);
        List<ActionLog> oldLogs = actionLogRepository.findForExport(null, cutoffDate);

        actionLogRepository.deleteAll(oldLogs);
        log.info("Đã xóa {} action logs", oldLogs.size());
    }

    private ActionLogResponse toResponse(ActionLog actionLog) {
        return ActionLogResponse.builder()
                .id(actionLog.getId())
                .userId(actionLog.getUserId())
                .userEmail(actionLog.getUserEmail())
                .userName(actionLog.getUserName())
                .actionType(actionLog.getActionType())
                .actionCategory(actionLog.getActionCategory())
                .resourceType(actionLog.getResourceType())
                .resourceId(actionLog.getResourceId())
                .description(actionLog.getDescription())
                .status(actionLog.getStatus())
                .ipAddress(actionLog.getIpAddress())
                .createdAt(actionLog.getCreatedAt())
                .build();
    }
}
