package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.usecase.user.UserVocabProgressService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.DailyVocabStatsResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.UserVocabProgressResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.UserVocabStatsResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.vocab.VocabStatsByCEFRResponse;

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

    @GetMapping("/learned-today")
    @Operation(summary = "Lấy từ đã học trong ngày", description = "Hiển thị những từ vựng mà user đã học trong ngày hôm nay (dựa trên created_at)", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<List<UserVocabProgressResponse>>> getVocabsLearnedToday(
            Authentication authentication) {

        UUID userId = getUserIdFromAuth(authentication);
        List<UserVocabProgressResponse> response = userVocabProgressService.getVocabsLearnedToday(userId);

        return ResponseEntity.ok(ApiResponse.success(
                "Lấy danh sách từ đã học trong ngày thành công. Tổng: " + response.size() + " từ",
                response));
    }

    @GetMapping("/stats/last-7-days")
    @Operation(summary = "Thống kê số từ học trong 7 ngày gần nhất", description = "Lấy số lượng từ vựng đã học trong 7 ngày gần nhất, bao gồm tên ngày trong tuần và số lượng từ mỗi ngày. Response bao gồm cả những ngày không có từ nào được học (count = 0). Dữ liệu được sắp xếp từ cũ đến mới (7 ngày trước -> hôm nay).", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<List<DailyVocabStatsResponse>>> getVocabStatsLast7Days(
            Authentication authentication) {

        UUID userId = getUserIdFromAuth(authentication);
        List<DailyVocabStatsResponse> response = userVocabProgressService.getVocabStatsLast7Days(userId);

        long totalWords = response.stream().mapToLong(DailyVocabStatsResponse::getCount).sum();

        return ResponseEntity.ok(ApiResponse.success(
                String.format("Lấy thống kê 7 ngày thành công. Tổng: %d từ trong 7 ngày", totalWords),
                response));
    }

    @GetMapping("/stats/by-cefr")
    @Operation(summary = "Thống kê số từ đã học theo cấp bậc CEFR", description = "Lấy thống kê số lượng từ vựng đã học theo từng cấp bậc CEFR (A1, A2, B1, B2, C1, C2). Response bao gồm tất cả cấp bậc, kể cả cấp bậc chưa học từ nào (count = 0). Dữ liệu được sắp xếp theo thứ tự cấp bậc từ A1 đến C2.", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<VocabStatsByCEFRResponse>> getVocabStatsByCEFR(
            Authentication authentication) {

        UUID userId = getUserIdFromAuth(authentication);
        VocabStatsByCEFRResponse response = userVocabProgressService.getVocabStatsByCEFR(userId);

        return ResponseEntity.ok(ApiResponse.success(
                String.format("Lấy thống kê theo CEFR thành công. Tổng: %d từ", response.getTotal()),
                response));
    }

    private UUID getUserIdFromAuth(Authentication authentication) {
        if (authentication != null && authentication.getPrincipal() instanceof UserDetails) {
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            if (userDetails instanceof User) {
                return ((User) userDetails).getId();
            }
        }
        throw new RuntimeException("Unable to get user ID from authentication");
    }

}
