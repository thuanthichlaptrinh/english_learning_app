package com.thuanthichlaptrinh.card_words.entrypoint.rest.admin;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import com.thuanthichlaptrinh.card_words.core.usecase.admin.VocabProgressAdminService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.DifficultWordResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.OverallProgressStatsResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.UserVocabProgressAdminResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.VocabLearningStatsResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping(path = "/api/v1/admin/vocab-progress")
@RequiredArgsConstructor
@Tag(name = "Vocab Progress Admin", description = "API quản lý tiến độ học từ vựng cho admin")
@PreAuthorize("hasRole('ADMIN')")
@SecurityRequirement(name = "Bearer Authentication")
public class VocabProgressAdminController {

    private final VocabProgressAdminService vocabProgressAdminService;

    @GetMapping("/user/{userId}")
    @Operation(summary = "[Admin] Lấy tiến độ học từ của user", description = "Lấy toàn bộ tiến độ học từ vựng của một người dùng cụ thể\n\n"
            +
            "**URL**: `GET http://localhost:8080/api/v1/admin/vocab-progress/user/{userId}?page=0&size=20`\n\n" +
            "**Example**: `GET http://localhost:8080/api/v1/admin/vocab-progress/user/123e4567-e89b-12d3-a456-426614174000?page=0&size=20`")
    public ResponseEntity<ApiResponse<Page<UserVocabProgressAdminResponse>>> getUserProgress(
            @Parameter(description = "ID người dùng (UUID)") @PathVariable UUID userId,
            @Parameter(description = "Số trang") @RequestParam(defaultValue = "0") int page,
            @Parameter(description = "Kích thước trang") @RequestParam(defaultValue = "20") int size) {

        Page<UserVocabProgressAdminResponse> response = vocabProgressAdminService.getUserProgress(userId, page, size);
        return ResponseEntity.ok(ApiResponse.success("Lấy tiến độ học từ thành công", response));
    }

    @GetMapping("/vocab/{vocabId}")
    @Operation(summary = "[Admin] Lấy thống kê từ vựng", description = "Xem có bao nhiêu user đã học từ vựng này và độ chính xác\n\n"
            +
            "**URL**: `GET http://localhost:8080/api/v1/admin/vocab-progress/vocab/{vocabId}`\n\n" +
            "**Example**: `GET http://localhost:8080/api/v1/admin/vocab-progress/vocab/123e4567-e89b-12d3-a456-426614174000`")
    public ResponseEntity<ApiResponse<VocabLearningStatsResponse>> getVocabLearningStats(
            @Parameter(description = "ID từ vựng (UUID)") @PathVariable UUID vocabId) {

        VocabLearningStatsResponse stats = vocabProgressAdminService.getVocabLearningStats(vocabId);
        return ResponseEntity.ok(ApiResponse.success("Lấy thống kê từ vựng thành công", stats));
    }

    @GetMapping("/statistics")
    @Operation(summary = "[Admin] Tổng quan tiến độ học toàn hệ thống", description = "Thống kê tổng quan về tiến độ học từ vựng của tất cả người dùng\n\n"
            +
            "**URL**: `GET http://localhost:8080/api/v1/admin/vocab-progress/statistics`")
    public ResponseEntity<ApiResponse<OverallProgressStatsResponse>> getOverallStats() {
        OverallProgressStatsResponse stats = vocabProgressAdminService.getOverallStats();
        return ResponseEntity.ok(ApiResponse.success("Lấy tổng quan thành công", stats));
    }

    @GetMapping("/difficult-words")
    @Operation(summary = "[Admin] Lấy danh sách từ khó nhất", description = "Lấy danh sách từ vựng có tỷ lệ sai nhiều nhất\n\n"
            +
            "**URL**: `GET http://localhost:8080/api/v1/admin/vocab-progress/difficult-words?limit=20`\n\n" +
            "**Example**: `GET http://localhost:8080/api/v1/admin/vocab-progress/difficult-words?limit=50`")
    public ResponseEntity<ApiResponse<List<DifficultWordResponse>>> getDifficultWords(
            @Parameter(description = "Số lượng từ cần lấy") @RequestParam(defaultValue = "20") int limit) {

        List<DifficultWordResponse> difficultWords = vocabProgressAdminService.getDifficultWords(limit);
        return ResponseEntity.ok(ApiResponse.success("Lấy danh sách từ khó thành công", difficultWords));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "[Admin] Xóa bản ghi tiến độ", description = "Xóa một bản ghi tiến độ học từ vựng\n\n" +
            "**URL**: `DELETE http://localhost:8080/api/v1/admin/vocab-progress/{id}`\n\n" +
            "**Example**: `DELETE http://localhost:8080/api/v1/admin/vocab-progress/123e4567-e89b-12d3-a456-426614174000`")
    public ResponseEntity<ApiResponse<Void>> deleteProgress(
            @Parameter(description = "ID bản ghi tiến độ (UUID)") @PathVariable UUID id) {

        vocabProgressAdminService.deleteProgress(id);
        return ResponseEntity.ok(ApiResponse.success("Xóa bản ghi tiến độ thành công", null));
    }

    @DeleteMapping("/user/{userId}/reset")
    @Operation(summary = "[Admin] Reset tiến độ của user", description = "Xóa toàn bộ tiến độ học từ vựng của một người dùng\n\n"
            +
            "**URL**: `DELETE http://localhost:8080/api/v1/admin/vocab-progress/user/{userId}/reset`\n\n" +
            "**Example**: `DELETE http://localhost:8080/api/v1/admin/vocab-progress/user/123e4567-e89b-12d3-a456-426614174000/reset`")
    public ResponseEntity<ApiResponse<Void>> resetUserProgress(
            @Parameter(description = "ID người dùng") @PathVariable UUID userId) {

        vocabProgressAdminService.resetUserProgress(userId);
        return ResponseEntity.ok(ApiResponse.success("Reset tiến độ người dùng thành công", null));
    }
}
