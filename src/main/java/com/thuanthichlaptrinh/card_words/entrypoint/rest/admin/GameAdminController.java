package com.thuanthichlaptrinh.card_words.entrypoint.rest.admin;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import com.thuanthichlaptrinh.card_words.core.usecase.admin.GameAdminService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.GameAdminResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.GameSessionDetailResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.GameSessionResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.GameStatisticsResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.OverallGameStatisticsResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping(path = "/api/v1/admin/games")
@RequiredArgsConstructor
@Tag(name = "Game Admin", description = "API quản lý game cho admin")
@PreAuthorize("hasRole('ADMIN')")
@SecurityRequirement(name = "Bearer Authentication")
public class GameAdminController {

    private final GameAdminService gameAdminService;

    @GetMapping
    @Operation(summary = "[Admin] Lấy danh sách game", description = "Lấy tất cả game trong hệ thống\n\n" +
            "**URL**: `GET http://localhost:8080/api/v1/admin/games`")
    public ResponseEntity<ApiResponse<List<GameAdminResponse>>> getAllGames() {
        List<GameAdminResponse> response = gameAdminService.getAllGames();
        return ResponseEntity.ok(ApiResponse.success("Lấy danh sách game thành công", response));
    }

    @GetMapping("/{id}")
    @Operation(summary = "[Admin] Lấy thông tin game theo ID", description = "Lấy chi tiết game theo ID\n\n" +
            "**URL**: `GET http://localhost:8080/api/v1/admin/games/{id}`\n\n" +
            "**Example**: `GET http://localhost:8080/api/v1/admin/games/1`")
    public ResponseEntity<ApiResponse<GameAdminResponse>> getGameById(
            @Parameter(description = "ID của game") @PathVariable Long id) {

        GameAdminResponse response = gameAdminService.getGameById(id);
        return ResponseEntity.ok(ApiResponse.success("Lấy thông tin game thành công", response));
    }

    @GetMapping("/{id}/sessions")
    @Operation(summary = "[Admin] Lấy danh sách session của game", description = "Lấy tất cả session đã chơi của một game cụ thể\n\n"
            +
            "**URL**: `GET http://localhost:8080/api/v1/admin/games/{id}/sessions?page=0&size=20`\n\n" +
            "**Example**: `GET http://localhost:8080/api/v1/admin/games/1/sessions?page=0&size=20`")
    public ResponseEntity<ApiResponse<Page<GameSessionResponse>>> getGameSessions(
            @Parameter(description = "ID của game") @PathVariable Long id,
            @Parameter(description = "Số trang") @RequestParam(defaultValue = "0") int page,
            @Parameter(description = "Kích thước trang") @RequestParam(defaultValue = "20") int size) {

        Page<GameSessionResponse> response = gameAdminService.getGameSessions(id, page, size);
        return ResponseEntity.ok(ApiResponse.success("Lấy danh sách session thành công", response));
    }

    @GetMapping("/sessions/{sessionId}")
    @Operation(summary = "[Admin] Lấy chi tiết session", description = "Lấy thông tin chi tiết của một game session\n\n"
            +
            "**URL**: `GET http://localhost:8080/api/v1/admin/games/sessions/{sessionId}`\n\n" +
            "**Example**: `GET http://localhost:8080/api/v1/admin/games/sessions/123`")
    public ResponseEntity<ApiResponse<GameSessionDetailResponse>> getSessionDetail(
            @Parameter(description = "ID của session") @PathVariable Long sessionId) {

        GameSessionDetailResponse response = gameAdminService.getSessionDetail(sessionId);
        return ResponseEntity.ok(ApiResponse.success("Lấy chi tiết session thành công", response));
    }

    @GetMapping("/{id}/statistics")
    @Operation(summary = "[Admin] Thống kê game", description = "Lấy thống kê chi tiết về một game\n\n" +
            "**URL**: `GET http://localhost:8080/api/v1/admin/games/{id}/statistics`\n\n" +
            "**Example**: `GET http://localhost:8080/api/v1/admin/games/1/statistics`")
    public ResponseEntity<ApiResponse<GameStatisticsResponse>> getGameStatistics(
            @Parameter(description = "ID của game") @PathVariable Long id) {

        GameStatisticsResponse stats = gameAdminService.getGameStatistics(id);
        return ResponseEntity.ok(ApiResponse.success("Lấy thống kê game thành công", stats));
    }

    @DeleteMapping("/sessions/{sessionId}")
    @Operation(summary = "[Admin] Xóa session", description = "Xóa một game session (bao gồm cả details)\n\n" +
            "**URL**: `DELETE http://localhost:8080/api/v1/admin/games/sessions/{sessionId}`\n\n" +
            "**Example**: `DELETE http://localhost:8080/api/v1/admin/games/sessions/123`")
    public ResponseEntity<ApiResponse<Void>> deleteSession(
            @Parameter(description = "ID của session") @PathVariable Long sessionId) {

        gameAdminService.deleteSession(sessionId);
        return ResponseEntity.ok(ApiResponse.success("Xóa session thành công", null));
    }

    @GetMapping("/statistics/overview")
    @Operation(summary = "[Admin] Tổng quan thống kê tất cả game", description = "Lấy thống kê tổng quan về tất cả game trong hệ thống\n\n"
            +
            "**URL**: `GET http://localhost:8080/api/v1/admin/games/statistics/overview`")
    public ResponseEntity<ApiResponse<OverallGameStatisticsResponse>> getOverallStatistics() {
        OverallGameStatisticsResponse stats = gameAdminService.getOverallStatistics();
        return ResponseEntity.ok(ApiResponse.success("Lấy tổng quan thành công", stats));
    }
}
