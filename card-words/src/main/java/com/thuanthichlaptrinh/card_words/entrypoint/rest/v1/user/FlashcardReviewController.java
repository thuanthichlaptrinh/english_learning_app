package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.usecase.user.FlashcardReviewService;
import com.thuanthichlaptrinh.card_words.core.usecase.user.SimpleRecommendationService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.ReviewFlashcardRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.FlashcardResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ReviewResultResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ReviewSessionResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.SmartReviewResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping(path = "/api/v1/flashcard-review")
@RequiredArgsConstructor
@Tag(name = "Flashcard Review", description = "API ôn tập từ vựng với thuật toán Spaced Repetition (SM-2)")
public class FlashcardReviewController {

        private final FlashcardReviewService flashcardReviewService;
        private final SimpleRecommendationService simpleRecommendationService;

        @GetMapping("/due")
        @Operation(summary = "Lấy danh sách flashcard cần ôn tập hôm nay", description = "Lấy tất cả flashcard đến hạn ôn tập dựa trên thuật toán SM-2", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<ReviewSessionResponse>> getDueFlashcards(
                        @AuthenticationPrincipal User user,
                        @Parameter(description = "Số lượng flashcard tối đa (mặc định: tất cả)") @RequestParam(required = false) Integer limit) {

                ReviewSessionResponse response = flashcardReviewService.getDueFlashcards(user, limit);

                return ResponseEntity.ok(ApiResponse.success(
                                "Lấy danh sách flashcard cần ôn tập thành công",
                                response));
        }

        @GetMapping("/flashcard/{vocabId}")
        @Operation(summary = "Lấy thông tin một flashcard", description = "Lấy chi tiết flashcard của một từ vựng cụ thể", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<FlashcardResponse>> getFlashcard(
                        @AuthenticationPrincipal User user,
                        @Parameter(description = "ID của từ vựng") @PathVariable UUID vocabId) {

                FlashcardResponse response = flashcardReviewService.getFlashcard(user, vocabId);

                return ResponseEntity.ok(ApiResponse.success(
                                "Lấy thông tin flashcard thành công",
                                response));
        }

        @PostMapping("/submit")
        @Operation(summary = "Gửi kết quả ôn tập", description = "Gửi đánh giá chất lượng ôn tập và cập nhật tiến độ theo thuật toán SM-2. "
                        +
                        "Quality: 0=Không nhớ, 1=Sai nhưng quen, 2=Gần đúng, 3=Đúng nhưng khó, 4=Đúng hơi khó, 5=Hoàn hảo", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<ReviewResultResponse>> submitReview(
                        @AuthenticationPrincipal User user,
                        @Valid @RequestBody ReviewFlashcardRequest request) {

                ReviewResultResponse response = flashcardReviewService.submitReview(user, request);

                return ResponseEntity.ok(ApiResponse.success(
                                "Gửi kết quả ôn tập thành công",
                                response));
        }

        @GetMapping("/stats")
        @Operation(summary = "Thống kê ôn tập hôm nay", description = "Lấy thống kê số lượng flashcard đã ôn tập và còn lại trong ngày", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<ReviewSessionResponse>> getTodayStats(
                        @AuthenticationPrincipal User user) {

                ReviewSessionResponse response = flashcardReviewService.getDueFlashcards(user, null);

                return ResponseEntity.ok(ApiResponse.success(
                                "Lấy thống kê ôn tập thành công",
                                response));
        }

        @GetMapping("/smart-review")
        @Operation(summary = "Gợi ý ôn tập thông minh (Rule-Based)", description = """
                        API gợi ý từ vựng nên ôn tập dựa trên thuật toán rule-based thông minh.

                        **Thuật toán tính Priority Score (0-100):**
                        - **Overdue Score (40 điểm)**: Từ quá hạn ôn tập → càng quá hạn lâu càng cao điểm
                        - **Status Score (30 điểm)**: UNKNOWN=30, NEW=25, KNOWN=15, MASTERED=5
                        - **Accuracy Score (20 điểm)**: Tỷ lệ đúng thấp → điểm cao hơn
                        - **Difficulty Score (10 điểm)**: Từ khó (C2, C1) → điểm cao hơn
                        - **Bonus (10 điểm)**: Lâu không ôn (>30 ngày) → +10 điểm

                        **Priority Level:**
                        - HIGH: Score >= 60 (cần ôn gấp)
                        - MEDIUM: Score 30-59 (nên ôn)
                        - LOW: Score < 30 (ôn khi rảnh)

                        **URL:** `GET /api/v1/learn-vocabs/smart-review?limit=20&topic=Animals`

                        **Query Parameters:**
                        - `limit` (optional, default=20): Số lượng gợi ý tối đa
                        - `topic` (optional): Lọc theo chủ đề
                        - `status` (optional): Lọc theo status (NEW, KNOWN, UNKNOWN, MASTERED)

                        **Response:**
                        - Danh sách từ vựng được sắp xếp theo priority score giảm dần
                        - Mỗi từ có: priorityScore, priorityLevel, reasons (lý do gợi ý)
                        - Summary: số từ HIGH/MEDIUM/LOW, số từ quá hạn, số từ chưa thuộc...

                        **Khi nào dùng:**
                        - Bắt đầu session ôn tập flashcard
                        - Xem từ nào cần ôn gấp nhất
                        - Lập kế hoạch ôn tập hàng ngày

                        **Ví dụ:**
                        - Ôn tập tổng quát: `/smart-review?limit=20`
                        - Ôn topic Animals: `/smart-review?topic=Animals&limit=15`
                        - Chỉ ôn từ UNKNOWN: `/smart-review?status=UNKNOWN&limit=10`
                        """, security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<SmartReviewResponse>> getSmartReview(
                        @AuthenticationPrincipal User user,
                        @Parameter(description = "Số lượng gợi ý (default: 20)", example = "20") @RequestParam(required = false, defaultValue = "20") Integer limit,
                        @Parameter(description = "Lọc theo topic", example = "Animals") @RequestParam(required = false) String topic,
                        @Parameter(description = "Lọc theo status (NEW, KNOWN, UNKNOWN, MASTERED)", example = "UNKNOWN") @RequestParam(required = false) String status) {

                SmartReviewResponse response = simpleRecommendationService.getRecommendations(
                                user, limit, topic, status);

                return ResponseEntity.ok(ApiResponse.success(
                                String.format("Tìm thấy %d từ cần ôn tập", response.getTotalRecommended()),
                                response));
        }
}
