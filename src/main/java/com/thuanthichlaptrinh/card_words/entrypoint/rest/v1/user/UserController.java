package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import org.springframework.data.domain.Page;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.thuanthichlaptrinh.card_words.core.usecase.user.GameHistoryService;
import com.thuanthichlaptrinh.card_words.core.usecase.user.UserService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.user.ChangePasswordRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.user.UpdateUserRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameHistoryResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameStatsResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.UserProfileResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import java.security.Principal;
import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;

@RestController
@RequestMapping(path = "/api/v1/users")
@RequiredArgsConstructor
@Tag(name = "User", description = "API quản lý người dùng")
public class UserController {

    private final UserService userService;
    private final GameHistoryService gameHistoryService;

    @GetMapping
    @Operation(summary = "Lấy thông tin profile", description = "Lấy thông tin cá nhân của user đang đăng nhập.", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<UserProfileResponse>> getUserProfile(Principal principal) {
        UserProfileResponse response = userService.getUserProfile(principal.getName());
        return ResponseEntity.ok(ApiResponse.success("Lấy thông tin thành công", response));
    }

    @PutMapping(consumes = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "Cập nhật thông tin profile", description = "Cập nhật thông tin cá nhân của user đang đăng nhập (name, gender, dateOfBirth, currentLevel).", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<UserProfileResponse>> updateUserProfile(
            Principal principal,
            @Valid @RequestBody UpdateUserRequest request) {
        UserProfileResponse response = userService.updateUserProfile(principal.getName(), request, null);
        return ResponseEntity.ok(ApiResponse.success("Cập nhật thông tin thành công", response));
    }

    @PutMapping(value = "/avatar", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "Cập nhật avatar", description = "Upload và cập nhật ảnh avatar của user.", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<UserProfileResponse>> updateAvatar(
            Principal principal,
            @Parameter(description = "File ảnh avatar (chấp nhận: jpg, jpeg, png, gif, webp)") @RequestPart(value = "avatar") MultipartFile avatarFile) {
        UserProfileResponse response = userService.updateUserProfile(principal.getName(), null, avatarFile);
        return ResponseEntity.ok(ApiResponse.success("Cập nhật avatar thành công", response));
    }

    @GetMapping("/games/history")
    @Operation(summary = "Lịch sử chơi game", description = "Lấy lịch sử tất cả game sessions của user với phân trang.\n\n"
            +
            "**URL:** `GET /api/v1/users/games/history?gameId=1&page=0&size=20`\n\n" +
            "**Parameters:**\n" +
            "- `gameId` (optional): Lọc theo game cụ thể\n" +
            "- `page`: Số trang (default: 0)\n" +
            "- `size`: Kích thước trang (default: 20)", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<Page<GameHistoryResponse>>> getGameHistory(
            Authentication authentication,
            @Parameter(description = "ID của game (optional)") @RequestParam(required = false) Long gameId,
            @Parameter(description = "Số trang") @RequestParam(defaultValue = "0") int page,
            @Parameter(description = "Kích thước trang") @RequestParam(defaultValue = "20") int size) {

        UUID userId = getUserIdFromAuth(authentication);
        Page<GameHistoryResponse> response = gameHistoryService.getUserGameHistory(userId, gameId, page, size);

        return ResponseEntity.ok(ApiResponse.success(
                "Lấy lịch sử chơi game thành công. Tổng: " + response.getTotalElements() + " games",
                response));
    }

    @GetMapping("/games/stats")
    @Operation(summary = "Thống kê game tổng quan", description = "Lấy thống kê tổng hợp về tất cả các game đã chơi.\n\n"
            +
            "**Bao gồm:**\n" +
            "- Tổng số game đã chơi\n" +
            "- Điểm số trung bình & cao nhất\n" +
            "- Độ chính xác trung bình & cao nhất\n" +
            "- Thống kê riêng cho từng loại game", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<GameStatsResponse>> getGameStats(Authentication authentication) {
        UUID userId = getUserIdFromAuth(authentication);
        GameStatsResponse response = gameHistoryService.getUserGameStats(userId);

        return ResponseEntity.ok(ApiResponse.success("Lấy thống kê game thành công", response));
    }

    @PostMapping("/change-password")
    @Operation(summary = "Đổi mật khẩu", description = "Đổi mật khẩu của user. Yêu cầu nhập mật khẩu hiện tại để xác thực.\n\n"
            +
            "**Request Body:**\n" +
            "```json\n" +
            "{\n" +
            "  \"currentPassword\": \"password123\",\n" +
            "  \"newPassword\": \"newPassword456\",\n" +
            "  \"confirmPassword\": \"newPassword456\"\n" +
            "}\n" +
            "```", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<Void>> changePassword(
            Principal principal,
            @Valid @RequestBody ChangePasswordRequest request) {
        userService.changePassword(
                principal.getName(),
                request.getCurrentPassword(),
                request.getNewPassword(),
                request.getConfirmPassword());
        return ResponseEntity.ok(ApiResponse.success("Đổi mật khẩu thành công", null));
    }

    // Helper method
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