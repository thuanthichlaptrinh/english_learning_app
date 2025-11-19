package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import com.thuanthichlaptrinh.card_words.common.helper.AuthenticationHelper;
import com.thuanthichlaptrinh.card_words.core.usecase.user.GameHistoryService;
import com.thuanthichlaptrinh.card_words.core.usecase.user.QuickQuizService;
import com.thuanthichlaptrinh.card_words.core.usecase.user.UserGameSettingService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game.QuickQuizAnswerRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game.QuickQuizStartRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.LeaderboardEntryResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.QuickQuizAnswerResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.QuickQuizInstructionResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.QuickQuizSessionResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/games/quick-quiz")
@RequiredArgsConstructor
@Tag(name = "Quick Reflex Quiz", description = "API cho trò chơi Trắc nghiệm phản xạ nhanh (True/False Lightning)")
public class QuickQuizController {

        private final QuickQuizService quickQuizService;
        private final GameHistoryService gameHistoryService;
        private final UserGameSettingService userGameSettingService;
        private final AuthenticationHelper authHelper;

        @PostMapping("/start")
        @Operation(summary = "Bắt đầu game Quick Quiz", description = "Tạo phiên chơi mới với câu hỏi Multiple Choice (4 đáp án). Mỗi câu có 3 giây để trả lời.\n\n"
                        +
                        "**Tính điểm:**\n" +
                        "- Base Points: 10 điểm/câu đúng\n" +
                        "- Streak Bonus: +5 điểm cho mỗi 3 câu đúng liên tiếp\n" +
                        "- Speed Bonus: +5 điểm nếu trả lời < 1.5 giây\n" +
                        "- Max Points/Question: 20 điểm (base + speed + streak)", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<QuickQuizSessionResponse>> startGame(
                        @Valid @RequestBody QuickQuizStartRequest request,
                        Authentication authentication) {

                UUID userId = authHelper.getCurrentUserId(authentication);
                QuickQuizSessionResponse response = quickQuizService.startGame(request, userId);

                return ResponseEntity.status(HttpStatus.CREATED)
                                .body(ApiResponse.success("Bắt đầu game thành công!", response));
        }

        @PostMapping("/start-auto")
        @Operation(summary = "Bắt đầu game Quick Quiz tự động", description = "Tạo phiên chơi mới tự động dựa trên game settings và CEFR level của user. Không cần request body.\n\n"
                        +
                        "**Tính điểm:**\n" +
                        "- Base Points: 10 điểm/câu đúng\n" +
                        "- Streak Bonus: +5 điểm cho mỗi 3 câu đúng liên tiếp\n" +
                        "- Speed Bonus: +5 điểm nếu trả lời < 1.5 giây\n" +
                        "- Max Points/Question: 20 điểm (base + speed + streak)\n\n" +
                        "**Auto Settings:**\n" +
                        "- Số câu hỏi: Từ game settings (mặc định: 10)\n" +
                        "- Thời gian/câu: Từ game settings (mặc định: 3 giây)\n" +
                        "- CEFR level: Từ user profile hiện tại", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<QuickQuizSessionResponse>> startGameAuto(
                        Authentication authentication) {

                UUID userId = authHelper.getCurrentUserId(authentication);

                // Lấy settings từ database hoặc dùng defaults
                Integer totalQuestions = userGameSettingService.getQuickQuizTotalQuestions(userId);
                Integer timePerQuestion = userGameSettingService.getQuickQuizTimePerQuestion(userId);
                String cefrLevel = userGameSettingService.getUserCEFR(userId);

                // Tạo request từ settings
                QuickQuizStartRequest request = new QuickQuizStartRequest();
                request.setTotalQuestions(totalQuestions);
                request.setTimePerQuestion(timePerQuestion);
                request.setCefr(cefrLevel);

                QuickQuizSessionResponse response = quickQuizService.startGame(request, userId);

                return ResponseEntity.status(HttpStatus.CREATED)
                                .body(ApiResponse.success("Bắt đầu game tự động thành công! (Câu hỏi: "
                                                + totalQuestions + ", Thời gian: " + timePerQuestion + "s, CEFR: "
                                                + (cefrLevel != null ? cefrLevel : "ALL") + ")", response));
        }

        @PostMapping("/answer")
        @Operation(summary = "Trả lời câu hỏi", description = "Gửi câu trả lời (chọn 1 trong 4 đáp án) cho câu hỏi hiện tại. Nhận ngay kết quả và câu hỏi tiếp theo hoặc kết quả cuối cùng.", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<QuickQuizAnswerResponse>> submitAnswer(
                        @Valid @RequestBody QuickQuizAnswerRequest request,
                        Authentication authentication) {

                UUID userId = authHelper.getCurrentUserId(authentication);
                QuickQuizAnswerResponse response = quickQuizService.submitAnswer(request, userId);

                String message = response.getIsCorrect()
                                ? "✓ Chính xác! +" + (10
                                                + (response.getComboBonus() != null ? response.getComboBonus() : 0))
                                                + " điểm"
                                : "✗ Sai rồi! Cố gắng lần sau nhé";

                return ResponseEntity.ok(ApiResponse.success(message, response));
        }

        @PostMapping("/skip")
        @Operation(summary = "Bỏ qua câu hỏi (timeout)", description = "Bỏ qua câu hỏi hiện tại khi hết thời gian hoặc không biết đáp án. Câu hỏi sẽ được tính là SAI và mất combo.", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<QuickQuizAnswerResponse>> skipQuestion(
                        @Valid @RequestBody QuickQuizAnswerRequest request,
                        Authentication authentication) {

                UUID userId = authHelper.getCurrentUserId(authentication);
                QuickQuizAnswerResponse response = quickQuizService.skipQuestion(request, userId);

                return ResponseEntity.ok(ApiResponse.success("⏭ Đã bỏ qua câu hỏi (timeout)", response));
        }

        @GetMapping("/session/{sessionId}")
        @Operation(summary = "Xem kết quả game", description = "Lấy thông tin chi tiết và kết quả của phiên chơi.", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<QuickQuizSessionResponse>> getSessionResults(
                        @PathVariable Long sessionId,
                        Authentication authentication) {

                UUID userId = authHelper.getCurrentUserId(authentication);
                QuickQuizSessionResponse response = quickQuizService.getSessionResults(sessionId, userId);

                return ResponseEntity.ok(ApiResponse.success("Lấy kết quả thành công", response));
        }

        @GetMapping("/instructions")
        @Operation(summary = "Hướng dẫn chơi", description = "Xem hướng dẫn và luật chơi của Quick Reflex Quiz")
        public ResponseEntity<ApiResponse<QuickQuizInstructionResponse>> getInstructions() {
                QuickQuizInstructionResponse instructions = QuickQuizInstructionResponse.builder()
                                .gameName("Quick Quiz - Trắc nghiệm phản xạ nhanh")
                                .description("Game Multiple Choice: Kiểm tra phản xạ và độ nhạy từ vựng của bạn!")
                                .howToPlay("1. Xem từ vựng (tiếng Anh)\n"
                                                + "2. Chọn 1 trong 3 nghĩa tiếng Việt đúng nhất\n"
                                                + "3. Bạn có 3 giây để trả lời mỗi câu\n"
                                                + "4. Hoàn thành 10 câu hỏi liên tục không dừng\n"
                                                + "5. Topic được chọn ngẫu nhiên (không cần nhập)")
                                .scoring("• Trả lời đúng: +10 điểm\n"
                                                + "• Combo 3+ câu đúng liên tiếp: +5 điểm/combo\n"
                                                + "• Trả lời nhanh (<1.5s): +5 điểm bonus\n"
                                                + "• Trả lời sai: 0 điểm, mất combo")
                                .tips("Mẹo:\n"
                                                + "• Đọc kỹ 3 đáp án trước khi chọn\n"
                                                + "• Giữ combo để nhân điểm\n"
                                                + "• Trả lời nhanh để được speed bonus\n"
                                                + "• Học từ vựng thường xuyên để đạt độ chính xác cao")
                                .build();

                return ResponseEntity.ok(ApiResponse.success("Hướng dẫn game", instructions));
        }

        @GetMapping("/leaderboard")
        @Operation(summary = "Bảng xếp hạng Quick Quiz", description = "Lấy top điểm cao nhất của Quick Quiz game.\n\n"
                        +
                        "**URL:** `GET /api/v1/games/quick-quiz/leaderboard?limit=100`\n\n" +
                        "**Response:** Danh sách top players với rank, score, accuracy", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<List<LeaderboardEntryResponse>>> getLeaderboard(
                        Authentication authentication,
                        @Parameter(description = "Số lượng top players (default: 100)") @RequestParam(defaultValue = "100") int limit) {

                UUID userId = authHelper.getCurrentUserId(authentication);
                // Game ID for Quick Quiz is 1 (you may need to adjust this)
                Long gameId = 1L;
                List<LeaderboardEntryResponse> response = gameHistoryService.getGameLeaderboard(gameId, userId, limit);

                return ResponseEntity.ok(ApiResponse.success(
                                "Lấy bảng xếp hạng thành công. Top " + response.size() + " players",
                                response));
        }
}
