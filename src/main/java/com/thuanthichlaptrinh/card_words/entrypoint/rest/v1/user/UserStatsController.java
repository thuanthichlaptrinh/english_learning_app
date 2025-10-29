package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.usecase.user.UserStatsService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.UserHighScoresResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@Slf4j
@RestController
@RequestMapping("/api/v1/user/stats")
@RequiredArgsConstructor
@Tag(name = "User Stats", description = "API thống kê và thành tích của người dùng")
@SecurityRequirement(name = "bearerAuth")
public class UserStatsController {

    private final UserStatsService userStatsService;

    @GetMapping("/high-scores")
    @Operation(summary = "Lấy điểm cao nhất của user cho tất cả game", description = "Lấy điểm cao nhất mà user đã đạt được cho từng game.\n\n"
            +
            "**Response bao gồm:**\n" +
            "- Tên game\n" +
            "- Điểm cao nhất (0 nếu chưa chơi)\n" +
            "- Trạng thái đã chơi hay chưa\n\n" +
            "**Games hiện tại:**\n" +
            "- Quick Reflex Quiz\n" +
            "- Image-Word Matching\n" +
            "- Word-Definition Matching", responses = {
                    @ApiResponse(responseCode = "200", description = "Lấy điểm cao nhất thành công", content = @Content(mediaType = "application/json", schema = @Schema(implementation = UserHighScoresResponse.class))),
                    @ApiResponse(responseCode = "401", description = "Chưa đăng nhập"),
                    @ApiResponse(responseCode = "500", description = "Lỗi server")
            })
    public ResponseEntity<UserHighScoresResponse> getUserHighScores(
            Authentication authentication) {
        UUID userId = getUserIdFromAuth(authentication);
        log.info("GET /api/v1/user/stats/high-scores - User: {}", userId);

        UserHighScoresResponse response = userStatsService.getUserHighScores(userId);

        return ResponseEntity.ok(response);
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
