package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.usecase.user.UserGameSettingService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game.UpdateGameSettingRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameSettingResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/game-settings")
@RequiredArgsConstructor
@Tag(name = "Game Settings", description = "API quản lý cài đặt game của user (tất cả settings trong 1 record)")
public class GameSettingController {

    private final UserGameSettingService userGameSettingService;

    @PutMapping
    @Operation(summary = "Cập nhật cài đặt game", description = "Cập nhật cài đặt cho tất cả games. Chỉ cập nhật các trường có dữ liệu, các trường null sẽ giữ nguyên giá trị cũ.\n\n"
            +
            "**Có thể cập nhật:**\n" +
            "- quickQuizTotalQuestions (5-50)\n" +
            "- quickQuizTimePerQuestion (1-10)\n" +
            "- imageWordTotalPairs (3-20)\n" +
            "- wordDefinitionTotalPairs (3-20)", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<GameSettingResponse>> updateGameSetting(
            Authentication authentication,
            @Valid @RequestBody UpdateGameSettingRequest request) {

        UUID userId = getUserIdFromAuth(authentication);
        GameSettingResponse response = userGameSettingService.updateGameSetting(userId, request);

        return ResponseEntity.ok(ApiResponse.success("Cập nhật cài đặt game thành công", response));
    }

    @GetMapping
    @Operation(summary = "Lấy cài đặt game", description = "Lấy tất cả cài đặt game của user (hiển thị đầy đủ 4 trường)", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<GameSettingResponse>> getGameSetting(
            Authentication authentication) {

        UUID userId = getUserIdFromAuth(authentication);
        GameSettingResponse response = userGameSettingService.getGameSetting(userId);

        return ResponseEntity.ok(ApiResponse.success("Lấy cài đặt game thành công", response));
    }

    // Helper method to extract user ID from authentication
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
