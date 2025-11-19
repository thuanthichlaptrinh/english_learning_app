package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import com.thuanthichlaptrinh.card_words.common.helper.AuthenticationHelper;
import com.thuanthichlaptrinh.card_words.core.usecase.user.UserStatsService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.UserHighScoresResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
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
    private final AuthenticationHelper authHelper;

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
            "- Word-Definition Matching")
    public ResponseEntity<ApiResponse<UserHighScoresResponse>> getUserHighScores(
            Authentication authentication) {
        UUID userId = authHelper.getCurrentUserId(authentication);
        log.info("GET /api/v1/user/stats/high-scores - User: {}", userId);

        UserHighScoresResponse response = userStatsService.getUserHighScores(userId);

        return ResponseEntity.ok(ApiResponse.success("Lấy điểm cao nhất thành công", response));
    }

}
