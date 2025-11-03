package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.usecase.user.StreakService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.StreakRecordResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.StreakResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/v1/user/streak")
@RequiredArgsConstructor
@Tag(name = "User Streak", description = "API quản lý chuỗi ngày học liên tục của người dùng")
public class StreakController {

    private final StreakService streakService;

    @GetMapping
    @Operation(
            summary = "Lấy thông tin streak hiện tại",
            description = "Hiển thị thông tin chuỗi ngày học của user: streak hiện tại, kỷ lục, tổng ngày học, trạng thái\n URL: GET /api/v1/user/streak",
            security = @SecurityRequirement(name = "Bearer Authentication")
    )
    public ResponseEntity<ApiResponse<StreakResponse>> getStreak(Authentication authentication) {
        log.info("GET /api/v1/user/streak - Getting streak info");

        User user = (User) authentication.getPrincipal();
        StreakResponse response = streakService.getStreak(user);

        return ResponseEntity.ok(ApiResponse.success("Lấy thông tin streak thành công", response));
    }

    @PostMapping("/record")
    @Operation(
            summary = "Ghi nhận hoạt động học",
            description = "Cập nhật streak khi user hoàn thành hoạt động học. API này được tự động gọi khi user hoàn thành game.\n URL: /api/v1/user/streak/record",
            security = @SecurityRequirement(name = "Bearer Authentication")
    )
    public ResponseEntity<ApiResponse<StreakRecordResponse>> recordActivity(Authentication authentication) {
        log.info("POST /api/v1/user/streak/record - Recording activity");

        User user = (User) authentication.getPrincipal();
        StreakRecordResponse response = streakService.recordActivity(user);

        return ResponseEntity.ok(ApiResponse.success("Hoạt động đã được ghi nhận", response));
    }
}

