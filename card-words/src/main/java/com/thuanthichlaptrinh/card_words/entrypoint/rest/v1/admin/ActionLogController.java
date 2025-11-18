package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.admin;

import com.thuanthichlaptrinh.card_words.core.usecase.admin.ActionLogService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.ActionLogFilterRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ActionLogResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ActionLogStatisticsResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping(path = "/api/v1/admin/action-logs")
@RequiredArgsConstructor
@Tag(name = "Action Logs Admin", description = "API quản lý action logs cho admin")
@PreAuthorize("hasRole('ROLE_ADMIN')")
@SecurityRequirement(name = "Bearer Authentication")
public class ActionLogController {

    private final ActionLogService actionLogService;

    @GetMapping
    @Operation(summary = "[Admin] Lấy danh sách action logs", description = "Lấy danh sách action logs với filters và pagination\n\n" +
            "**URL**: `GET http://localhost:8080/api/v1/admin/action-logs`\n\n" +
            "**Query Parameters:**\n" +
            "- userId: UUID của user\n" +
            "- actionType: Loại action (USER_LOGIN, VOCAB_CREATE, etc.)\n" +
            "- resourceType: Loại resource (Authentication System, Vocabulary, etc.)\n" +
            "- status: Trạng thái (SUCCESS, FAILED)\n" +
            "- startDate: Từ ngày (ISO format)\n" +
            "- endDate: Đến ngày (ISO format)\n" +
            "- keyword: Tìm kiếm trong description, userEmail, userName\n" +
            "- page: Số trang (default 0)\n" +
            "- size: Kích thước trang (default 10)\n" +
            "- sortBy: Sắp xếp theo trường (default createdAt)\n" +
            "- sortDirection: Hướng sắp xếp (ASC, DESC)\n\n" +
            "**Example**: `GET http://localhost:8080/api/v1/admin/action-logs?status=SUCCESS&page=0&size=10`")
    public ResponseEntity<ApiResponse<Page<ActionLogResponse>>> getActionLogs(
            @Valid @ModelAttribute ActionLogFilterRequest request) {

        Page<ActionLogResponse> response = actionLogService.getActionLogs(request);
        return ResponseEntity.ok(ApiResponse.success("Lấy danh sách action logs thành công", response));
    }

    @GetMapping("/statistics")
    @Operation(summary = "[Admin] Lấy thống kê action logs", description = "Lấy thống kê tổng quan về action logs\n\n" +
            "**URL**: `GET http://localhost:8080/api/v1/admin/action-logs/statistics`\n\n" +
            "**Response bao gồm:**\n" +
            "- totalActions: Tổng số actions\n" +
            "- successfulActions: Số actions thành công\n" +
            "- failedActions: Số actions thất bại\n" +
            "- activeUsers: Số users có hoạt động")
    public ResponseEntity<ApiResponse<ActionLogStatisticsResponse>> getStatistics() {
        ActionLogStatisticsResponse response = actionLogService.getStatistics();
        return ResponseEntity.ok(ApiResponse.success("Lấy thống kê thành công", response));
    }

    @GetMapping("/export")
    @Operation(summary = "[Admin] Export action logs", description = "Export action logs theo khoảng thời gian\n\n" +
            "**URL**: `GET http://localhost:8080/api/v1/admin/action-logs/export`\n\n" +
            "**Query Parameters:**\n" +
            "- startDate: Từ ngày (ISO format)\n" +
            "- endDate: Đến ngày (ISO format)\n\n" +
            "**Example**: `GET http://localhost:8080/api/v1/admin/action-logs/export?startDate=2024-01-01T00:00:00&endDate=2024-12-31T23:59:59`")
    public ResponseEntity<ApiResponse<List<ActionLogResponse>>> exportActionLogs(
            @Parameter(description = "Từ ngày") @RequestParam(required = false) LocalDateTime startDate,
            @Parameter(description = "Đến ngày") @RequestParam(required = false) LocalDateTime endDate) {

        List<ActionLogResponse> response = actionLogService.exportActionLogs(startDate, endDate);
        return ResponseEntity.ok(ApiResponse.success("Export thành công", response));
    }

    @DeleteMapping("/cleanup")
    @Operation(summary = "[Admin] Xóa action logs cũ", description = "Xóa các action logs cũ hơn số ngày chỉ định\n\n" +
            "**URL**: `DELETE http://localhost:8080/api/v1/admin/action-logs/cleanup?daysToKeep=90`\n\n" +
            "**Query Parameters:**\n" +
            "- daysToKeep: Số ngày cần giữ lại (default 90)")
    public ResponseEntity<ApiResponse<Void>> deleteOldLogs(
            @Parameter(description = "Số ngày cần giữ lại") @RequestParam(defaultValue = "90") int daysToKeep) {

        actionLogService.deleteOldLogs(daysToKeep);
        return ResponseEntity.ok(ApiResponse.success("Xóa logs cũ thành công", null));
    }
}
