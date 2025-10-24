package com.thuanthichlaptrinh.card_words.entrypoint.rest.user;

import com.thuanthichlaptrinh.card_words.core.usecase.user.QuickQuizService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.QuickQuizAnswerRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.QuickQuizStartRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.QuickQuizAnswerResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.QuickQuizInstructionResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.QuickQuizSessionResponse;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/games/quick-quiz")
@RequiredArgsConstructor
@Tag(name = "Quick Reflex Quiz", description = "API cho trò chơi Trắc nghiệm phản xạ nhanh (True/False Lightning)")
public class QuickQuizController {

    private final QuickQuizService quickQuizService;

    @PostMapping("/start")
    @Operation(summary = "Bắt đầu game Quick Quiz", description = "Tạo phiên chơi mới với 10 câu hỏi Multiple Choice (3 đáp án). Mỗi câu có 3 giây để trả lời.", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<QuickQuizSessionResponse>> startGame(
            @Valid @RequestBody QuickQuizStartRequest request,
            Authentication authentication) {

        UUID userId = getUserIdFromAuth(authentication);
        QuickQuizSessionResponse response = quickQuizService.startGame(request, userId);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Bắt đầu game thành công!", response));
    }

    @PostMapping("/answer")
    @Operation(summary = "Trả lời câu hỏi", description = "Gửi câu trả lời (chọn 1 trong 3 đáp án) cho câu hỏi hiện tại. Nhận ngay kết quả và câu hỏi tiếp theo.", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<QuickQuizAnswerResponse>> submitAnswer(
            @Valid @RequestBody QuickQuizAnswerRequest request,
            Authentication authentication) {

        UUID userId = getUserIdFromAuth(authentication);
        QuickQuizAnswerResponse response = quickQuizService.submitAnswer(request, userId);

        String message = response.getIsCorrect()
                ? "✓ Chính xác! +" + (10 + (response.getComboBonus() != null ? response.getComboBonus() : 0)) + " điểm"
                : "✗ Sai rồi! Cố gắng lần sau nhé";

        return ResponseEntity.ok(ApiResponse.success(message, response));
    }

    @GetMapping("/session/{sessionId}")
    @Operation(summary = "Xem kết quả game", description = "Lấy thông tin chi tiết và kết quả của phiên chơi.", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<QuickQuizSessionResponse>> getSessionResults(
            @PathVariable Long sessionId,
            Authentication authentication) {

        UUID userId = getUserIdFromAuth(authentication);
        QuickQuizSessionResponse response = quickQuizService.getSessionResults(sessionId, userId);

        return ResponseEntity.ok(ApiResponse.success("Lấy kết quả thành công", response));
    }

    @GetMapping("/instructions")
    @Operation(summary = "Hướng dẫn chơi", description = "Xem hướng dẫn và luật chơi của Quick Reflex Quiz")
    public ResponseEntity<ApiResponse<QuickQuizInstructionResponse>> getInstructions() {
        QuickQuizInstructionResponse instructions = QuickQuizInstructionResponse.builder()
                .gameName("Quick Reflex Quiz - Trắc nghiệm phản xạ nhanh")
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

    // Helper method to extract user ID from authentication
    private UUID getUserIdFromAuth(Authentication authentication) {
        if (authentication != null && authentication.getPrincipal() instanceof UserDetails) {
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            // Assuming your UserDetails implementation has getId() method
            if (userDetails instanceof User) {
                return ((User) userDetails).getId();
            }
        }
        throw new RuntimeException("Unable to get user ID from authentication");
    }
}
