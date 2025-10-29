package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import com.thuanthichlaptrinh.card_words.core.usecase.user.UserVocabProgressService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.UserVocabProgressResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.UserVocabStatsResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/user-vocab-progress")
@RequiredArgsConstructor
@Tag(name = "User Vocabulary Progress", description = "API quản lý tiến trình học từ vựng của người dùng")
public class UserVocabProgressController {

    private final UserVocabProgressService userVocabProgressService;

    @GetMapping()
    @Operation(summary = "Lấy tất cả từ đã học", description = "Hiển thị tất cả từ vựng mà user đã từng học (có trong bảng user_vocab_progress)", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<List<UserVocabProgressResponse>>> getAllLearnedVocabs(
            Authentication authentication) {

        UUID userId = getUserIdFromAuth(authentication);
        List<UserVocabProgressResponse> response = userVocabProgressService.getAllLearnedVocabs(userId);

        return ResponseEntity.ok(ApiResponse.success(
                "Lấy danh sách từ đã học thành công. Tổng: " + response.size() + " từ",
                response));
    }

    @GetMapping("/correct")
    @Operation(summary = "Lấy những từ đã trả lời đúng", description = "Hiển thị những từ mà user đã trả lời đúng ít nhất 1 lần (timesCorrect > 0)", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<List<UserVocabProgressResponse>>> getCorrectVocabs(
            Authentication authentication) {

        UUID userId = getUserIdFromAuth(authentication);
        List<UserVocabProgressResponse> response = userVocabProgressService.getCorrectVocabs(userId);

        return ResponseEntity.ok(ApiResponse.success(
                "Lấy danh sách từ đúng thành công. Tổng: " + response.size() + " từ",
                response));
    }

    @GetMapping("/wrong")
    @Operation(summary = "Lấy những từ đã trả lời sai", description = "Hiển thị những từ mà user đã trả lời sai ít nhất 1 lần (timesWrong > 0)", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<List<UserVocabProgressResponse>>> getWrongVocabs(
            Authentication authentication) {

        UUID userId = getUserIdFromAuth(authentication);
        List<UserVocabProgressResponse> response = userVocabProgressService.getWrongVocabs(userId);

        return ResponseEntity.ok(ApiResponse.success(
                "Lấy danh sách từ sai thành công. Tổng: " + response.size() + " từ",
                response));
    }

    @GetMapping("/stats")
    @Operation(summary = "Thống kê tiến trình học từ vựng", description = "Hiển thị các số liệu thống kê: tổng từ đã học, số từ đúng/sai, độ chính xác, trạng thái từ vựng", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<UserVocabStatsResponse>> getUserStats(
            Authentication authentication) {

        UUID userId = getUserIdFromAuth(authentication);
        UserVocabStatsResponse response = userVocabProgressService.getUserStats(userId);

        return ResponseEntity.ok(ApiResponse.success(
                "Lấy thống kê thành công",
                response));
    }

    @GetMapping("/due-for-review")
    @Operation(summary = "Lấy từ cần ôn tập hôm nay", description = "Hiển thị những từ cần ôn tập (nextReviewDate <= hôm nay) theo thuật toán Spaced Repetition", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<List<UserVocabProgressResponse>>> getVocabsDueForReview(
            Authentication authentication) {

        UUID userId = getUserIdFromAuth(authentication);
        List<UserVocabProgressResponse> response = userVocabProgressService.getVocabsDueForReview(userId);

        return ResponseEntity.ok(ApiResponse.success(
                "Lấy danh sách từ cần ôn tập thành công. Tổng: " + response.size() + " từ",
                response));
    }

    private UUID getUserIdFromAuth(Authentication authentication) {
        if (authentication != null && authentication.getPrincipal() instanceof UserDetails) {
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            if (userDetails instanceof com.thuanthichlaptrinh.card_words.core.domain.User) {
                return ((com.thuanthichlaptrinh.card_words.core.domain.User) userDetails).getId();
            }
        }
        throw new RuntimeException("Unable to get user ID from authentication");
    }

}
