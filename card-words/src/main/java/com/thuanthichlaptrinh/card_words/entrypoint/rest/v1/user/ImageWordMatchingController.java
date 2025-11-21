package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import com.thuanthichlaptrinh.card_words.common.helper.AuthenticationHelper;
import com.thuanthichlaptrinh.card_words.core.usecase.user.GameHistoryService;
import com.thuanthichlaptrinh.card_words.core.usecase.user.ImageWordMatchingService;
import com.thuanthichlaptrinh.card_words.core.usecase.user.UserGameSettingService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game.ImageWordMatchingAnswerRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game.ImageWordMatchingStartRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.LeaderboardEntryResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameInstructionResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameStatsResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.ImageWordMatchingResultResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.ImageWordMatchingSessionResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.List;
import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/v1/games/image-word-matching")
@RequiredArgsConstructor
@Tag(name = "Image-Word Matching Game", description = "API cho game ghép thẻ hình ảnh với từ vựng")
public class ImageWordMatchingController {

        private final ImageWordMatchingService imageWordMatchingService;
        private final GameHistoryService gameHistoryService;
        private final UserGameSettingService userGameSettingService;
        private final AuthenticationHelper authHelper;

        @GetMapping("/instructions")
        @Operation(summary = "Hướng dẫn chơi", description = "Lấy thông tin chi tiết về cách chơi và cách tính điểm")
        public ResponseEntity<GameInstructionResponse> getInstructions() {
                GameInstructionResponse instructions = GameInstructionResponse.builder()
                                .gameName("Image-Word Matching")
                                .description("Ghép thẻ hình ảnh với từ vựng tương ứng")
                                .rules(List.of(
                                                "Người chơi ghép các cặp hình ảnh - từ vựng",
                                                "Từ vựng theo CEFR hiện tại của người chơi",
                                                "Điểm được tính theo CEFR và thời gian hoàn thành"))
                                .scoring(List.of(
                                                "Điểm CEFR: A1=1, A2=2, B1=3, B2=4, C1=5, C2=6",
                                                "Time Bonus: < 10s = +50%, < 20s = +30%, < 30s = +20%, < 60s = +10%",
                                                "Tổng điểm = Tổng điểm CEFR + Time Bonus",
                                                "Ví dụ: 3 từ B1 (9đ) hoàn thành 15s → 9 + 2.7 = 11.7đ"))
                                .build();

                return ResponseEntity.ok(instructions);
        }

        @PostMapping("/start")
        @PreAuthorize("isAuthenticated()")
        @Operation(summary = "Bắt đầu game ghép thẻ", description = "Khởi tạo phiên chơi mới. Từ vựng được random ngẫu nhiên (không giới hạn topic). Trả về danh sách từ vựng với đầy đủ thuộc tính. Frontend tự clone và tạo cards.")
        public ResponseEntity<ImageWordMatchingSessionResponse> startGame(
                        @RequestBody ImageWordMatchingStartRequest request) {
                log.info("API: Start Image-Word Matching game - pairs: {}, cefr: {}",
                                request.getTotalPairs(), request.getCefr());

                ImageWordMatchingSessionResponse response = imageWordMatchingService.startGame(request);
                return ResponseEntity.ok(response);
        }

        @PostMapping("/start-auto")
        @PreAuthorize("isAuthenticated()")
        @Operation(summary = "Bắt đầu game ghép thẻ tự động", description = "Khởi tạo phiên chơi mới tự động dựa trên game settings và CEFR level của user. Không cần request body.\n\n"
                        + "**Auto Settings:**\n"
                        + "- Số cặp thẻ: Từ game settings (mặc định: 5)\n"
                        + "- CEFR level: Từ user profile hiện tại\n\n"
                        + "**Tính điểm:**\n"
                        + "- Điểm CEFR: A1=1, A2=2, B1=3, B2=4, C1=5, C2=6\n"
                        + "- Time Bonus: <10s +50%, <20s +30%, <30s +20%, <60s +10%")
        public ResponseEntity<ImageWordMatchingSessionResponse> startGameAuto(
                        Authentication authentication) {
                UUID userId = authHelper.getCurrentUserId(authentication);

                // Lấy settings từ database hoặc dùng defaults
                Integer totalPairs = userGameSettingService.getImageWordTotalPairs(userId);
                String cefrLevel = userGameSettingService.getUserCEFR(userId);

                // Tạo request từ settings
                ImageWordMatchingStartRequest request = ImageWordMatchingStartRequest.builder()
                                .totalPairs(totalPairs)
                                .cefr(cefrLevel)
                                .build();

                log.info("API: Start Image-Word Matching game AUTO - userId: {}, pairs: {}, cefr: {}",
                                userId, totalPairs, cefrLevel);

                ImageWordMatchingSessionResponse response = imageWordMatchingService.startGame(request);
                return ResponseEntity.ok(response);
        }

        @PostMapping("/submit")
        @PreAuthorize("isAuthenticated()")
        @Operation(summary = "Nộp kết quả ghép thẻ", description = "Gửi danh sách vocab IDs đã ghép đúng. Điểm = CEFR score + time bonus. Càng nhanh càng cao điểm: <10s +50%, <20s +30%, <30s +20%, <60s +10%")
        public ResponseEntity<ImageWordMatchingResultResponse> submitAnswer(
                        @RequestBody ImageWordMatchingAnswerRequest request) {
                log.info("API: Submit Image-Word Matching answer - sessionId: {}, matched: {}",
                                request.getSessionId(), request.getMatchedVocabIds().size());

                ImageWordMatchingResultResponse response = imageWordMatchingService.submitAnswer(request);
                return ResponseEntity.ok(response);
        }

        @GetMapping("/session/{sessionId}")
        @PreAuthorize("isAuthenticated()")
        @Operation(summary = "Lấy thông tin session", description = "Lấy thông tin chi tiết của session hiện tại")
        public ResponseEntity<ImageWordMatchingSessionResponse> getSession(
                        @PathVariable UUID sessionId) {
                log.info("API: Get session info - sessionId: {}", sessionId);

                ImageWordMatchingSessionResponse response = imageWordMatchingService.getSession(sessionId);
                return ResponseEntity.ok(response);
        }

        @GetMapping("/history")
        @PreAuthorize("isAuthenticated()")
        @Operation(summary = "Lịch sử chơi", description = "Xem lịch sử các game đã chơi của người dùng")
        public ResponseEntity<List<com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameHistoryResponse>> getHistory(
                        @RequestParam(defaultValue = "0") int page,
                        @RequestParam(defaultValue = "10") int size) {
                log.info("API: Get game history - page: {}, size: {}", page, size);

                List<com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameHistoryResponse> response = imageWordMatchingService
                                .getHistory(page, size);
                return ResponseEntity.ok(response);
        }

        @GetMapping("/leaderboard")
        @PreAuthorize("isAuthenticated()")
        @Operation(summary = "Bảng xếp hạng Image-Word Matching", description = "Lấy top điểm cao nhất của Image-Word Matching game.\n\n"
                        +
                        "**URL:** `GET /api/v1/games/image-word-matching/leaderboard?limit=100`")
        public ResponseEntity<List<LeaderboardEntryResponse>> getLeaderboard(
                        Authentication authentication,
                        @Parameter(description = "Số lượng top players") @RequestParam(defaultValue = "100") int limit) {
                log.info("API: Get leaderboard - limit: {}", limit);

                UUID userId = authHelper.getCurrentUserId(authentication);
                Long gameId = 2L; // Image-Word Matching game ID
                List<LeaderboardEntryResponse> response = gameHistoryService.getGameLeaderboard(gameId, userId, limit);
                return ResponseEntity.ok(response);
        }

        @GetMapping("/stats")
        @PreAuthorize("isAuthenticated()")
        @Operation(summary = "Thống kê cá nhân", description = "Xem thống kê game của người dùng")
        public ResponseEntity<com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameStatsResponse> getStats() {
                log.info("API: Get user stats");

                GameStatsResponse response = imageWordMatchingService
                                .getStats();
                return ResponseEntity.ok(response);
        }
}
