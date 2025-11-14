package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.usecase.user.LearnVocabService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.GetReviewVocabsRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.ReviewVocabRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse2;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.PageMeta;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.PagedReviewVocabResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ReviewResultResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ReviewVocabResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(path = "/api/v1/learn-vocabs")
@RequiredArgsConstructor
@Tag(name = "Learn Vocabs", description = "API học từ vựng")
public class LearnVocabController {

        private final LearnVocabService learnVocabService;

        @GetMapping("/vocabs")
        @Operation(summary = "Lấy từ vựng để học (tất cả topics)", description = """
                                API lấy từ vựng để HỌC từ TẤT CẢ các topics.

                                **Thuật toán phân phối từ:**
                                1. Ưu tiên từ có status = UNKNOWN (đã học nhưng chưa thuộc) → để ôn lại
                                2. Từ có status = NEW (đã có trong progress nhưng chưa học kỹ) → có thể hiển thị lại
                                3. Từ chưa có trong UserVocabProgress (từ mới hoàn toàn)
                                4. Trộn các nguồn trên để tạo danh sách đa dạng

                                **URL:** `GET /api/v1/learn-vocabs/vocabs?page=0&size=20`

                                **Query Parameters:**
                                - `page` (optional, default=0): Số trang (bắt đầu từ 0)
                                - `size` (optional, default=20): Số từ trên mỗi trang

                                **Response:**
                                - Danh sách từ vựng để học với metadata phân trang
                                - Status của từ: NEW, UNKNOWN (KNOWN và MASTERED không hiển thị)

                                **Khi nào dùng:**
                                - Học từ vựng tổng quát, không theo chủ đề cụ thể
                                - Ôn lại các từ chưa thuộc
                        - Mở rộng vốn từ vựng
                        """, security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse2<java.util.List<ReviewVocabResponse>>> getLearnVocabs(
                        @AuthenticationPrincipal User user,
                        @Parameter(description = "Số trang (bắt đầu từ 0)", example = "0") @RequestParam(defaultValue = "0") Integer page,
                        @Parameter(description = "Số lượng từ trên mỗi trang", example = "20") @RequestParam(defaultValue = "20") Integer size) {

                PagedReviewVocabResponse response = learnVocabService.getVocabsForLearning(user, page, size);

                // Tạo meta
                PageMeta meta = PageMeta.builder()
                                .page(response.getMeta().getPage())
                                .pageSize(response.getMeta().getPageSize())
                                .totalItems(response.getMeta().getTotalItems())
                                .totalPages(response.getMeta().getTotalPages())
                                .hasNext(response.getMeta().getHasNext())
                                .hasPrev(response.getMeta().getHasPrev())
                                .newVocabs(response.getMeta().getNewVocabs())
                                .learningVocabs(response.getMeta().getLearningVocabs())
                                .masteredVocabs(response.getMeta().getMasteredVocabs())
                                .dueVocabs(response.getMeta().getDueVocabs())
                                .build();

                return ResponseEntity.ok(ApiResponse2.success(
                                "Lấy danh sách từ vựng để học thành công",
                                response.getVocabs(),
                                meta));
        }

        @GetMapping("/vocabs/topic/{topicName}")
        @Operation(summary = "Lấy từ vựng để học theo topic cụ thể", description = """
                                API lấy từ vựng để HỌC theo một TOPIC cụ thể (ví dụ: Animals, Sports, Technology).

                                **Thuật toán phân phối từ:**
                                1. Ưu tiên từ có status = UNKNOWN (đã học nhưng chưa thuộc) trong topic → để ôn lại
                                2. Từ có status = NEW (đã có trong progress nhưng chưa học kỹ) trong topic → có thể hiển thị lại
                                3. Từ chưa có trong UserVocabProgress trong topic (từ mới hoàn toàn)
                                4. Trộn các nguồn trên để tạo danh sách đa dạng

                                **URL:** `GET /api/v1/learn-vocabs/vocabs/topic/{topicName}?page=0&size=20`

                                **Path Parameters:**
                                - `topicName` (required): Tên topic (ví dụ: "Animals", "Sports", "Technology")

                                **Query Parameters:**
                                - `page` (optional, default=0): Số trang (bắt đầu từ 0)
                                - `size` (optional, default=20): Số từ trên mỗi trang

                                **Ví dụ:**
                                - Học topic Animals: `/vocabs/topic/Animals?page=0&size=15`
                                - Học topic Sports: `/vocabs/topic/Sports?page=1&size=20`
                                - Học topic Technology: `/vocabs/topic/Technology?page=0&size=25`

                                **Response:**
                                - Danh sách từ vựng của topic để học với metadata phân trang
                                - Status của từ: NEW, UNKNOWN (KNOWN và MASTERED không hiển thị)

                                **Khi nào dùng:**
                                - Học từ vựng theo chủ đề cụ thể
                                - Chuẩn bị cho các tình huống cụ thể (du lịch, công việc...)
                        - Tập trung ôn tập một lĩnh vực
                        """, security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse2<java.util.List<ReviewVocabResponse>>> getLearnVocabsByTopic(
                        @AuthenticationPrincipal User user,
                        @Parameter(description = "Tên của topic", example = "Animals") @PathVariable String topicName,
                        @Parameter(description = "Số trang (bắt đầu từ 0)", example = "0") @RequestParam(defaultValue = "0") Integer page,
                        @Parameter(description = "Số lượng từ trên mỗi trang", example = "20") @RequestParam(defaultValue = "20") Integer size) {

                PagedReviewVocabResponse response = learnVocabService.getVocabsForLearningByTopic(user, topicName,
                                page, size);

                // Tạo meta
                PageMeta meta = PageMeta.builder()
                                .page(response.getMeta().getPage())
                                .pageSize(response.getMeta().getPageSize())
                                .totalItems(response.getMeta().getTotalItems())
                                .totalPages(response.getMeta().getTotalPages())
                                .hasNext(response.getMeta().getHasNext())
                                .hasPrev(response.getMeta().getHasPrev())
                                .newVocabs(response.getMeta().getNewVocabs())
                                .learningVocabs(response.getMeta().getLearningVocabs())
                                .masteredVocabs(response.getMeta().getMasteredVocabs())
                                .dueVocabs(response.getMeta().getDueVocabs())
                                .build();

                return ResponseEntity.ok(ApiResponse2.success(
                                "Lấy danh sách từ vựng để học theo topic thành công",
                                response.getVocabs(),
                                meta));
        }

        @GetMapping("/vocabs/new")
        @Operation(summary = "Lấy từ vựng mới chưa học (có phân trang)", description = """
                        Lấy danh sách từ vựng MỚI mà user CHƯA HỌC hoặc có status="NEW".

                        **URL:** `GET /api/v1/learn-vocabs/vocabs/new?topicName=Animals&page=0&size=10`

                        **Response:**
                        - Chỉ trả về từ có status="NEW" hoặc chưa được học
                        - Bao gồm metadata phân trang và thống kê

                        **Khi nào dùng:**
                        - User muốn HỌC từ mới lần đầu
                        - Bắt đầu học một chủ đề mới
                        - Mở rộng vốn từ vựng
                        """, security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<PagedReviewVocabResponse>> getNewVocabs(
                        @AuthenticationPrincipal User user,
                        @Parameter(description = "Tên của topic (tùy chọn)", example = "Animals") @RequestParam(required = false) String topicName,
                        @Parameter(description = "Số trang (bắt đầu từ 0)", example = "0") @RequestParam(defaultValue = "0") Integer page,
                        @Parameter(description = "Số lượng từ trên mỗi trang", example = "10") @RequestParam(defaultValue = "10") Integer size) {

                GetReviewVocabsRequest request = GetReviewVocabsRequest.builder()
                                .topicName(topicName)
                                .page(page)
                                .size(size)
                                .onlyNew(true)
                                .onlyDue(false)
                                .build();

                PagedReviewVocabResponse response = learnVocabService.getReviewVocabsPaged(user, request);

                return ResponseEntity.ok(ApiResponse.success(
                                "Lấy danh sách từ vựng mới chưa học thành công",
                                response));
        }

        @GetMapping("/vocabs/topics/{topicName}")
        @Operation(summary = "Lấy từ vựng để học theo topic (có phân trang)", description = """
                        Lấy danh sách từ vựng để HỌC theo một chủ đề cụ thể (bao gồm cả từ mới và từ cần ôn lại).

                        **URL:** `GET /api/v1/learn-vocabs/vocabs/topics/{topicName}?page=0&size=20`
                        **Path Parameters:**
                        - `topicName` (required): Tên topic (ví dụ: "Animals", "Sports", "Technology")

                        **Query Parameters:**
                        - `page` (optional, default=0): Số trang (bắt đầu từ 0)
                        - `size` (optional, default=20): Số từ trên mỗi trang (max=100)

                        **Ví dụ:**
                        - Học chủ đề Animals: `/vocabs/by-topic/Animals?page=0&size=15`
                        - Ôn tập Sports (trang 2): `/vocabs/by-topic/Sports?page=1&size=20`
                        - Topic Technology: `/vocabs/by-topic/Technology?page=0&size=25`

                        **Response:**
                        - Kết hợp từ đang học (KNOWN/UNKNOWN) + từ mới chưa học
                        - Ưu tiên từ đang học trước
                        - Bao gồm tất cả status: NEW, KNOWN, UNKNOWN, MASTERED
                        - **LƯU Ý**: API này CHỈ dựa vào STATUS, KHÔNG dùng nextReviewDate

                        **Khi nào dùng:**
                        - Học tập tập trung vào một chủ đề
                        - Học từ vựng theo ngữ cảnh
                        - Chuẩn bị cho các tình huống cụ thể (du lịch, công việc, học tập...)

                        **Tip:** Kết hợp với API `/stats?topicName=...` để xem tiến độ học tập của topic!
                        """, security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<PagedReviewVocabResponse>> getVocabsByTopic(
                        @AuthenticationPrincipal User user,
                        @Parameter(description = "Tên của topic", example = "Animals") @PathVariable String topicName,
                        @Parameter(description = "Số trang (bắt đầu từ 0)", example = "0") @RequestParam(defaultValue = "0") Integer page,
                        @Parameter(description = "Số lượng từ trên mỗi trang", example = "20") @RequestParam(defaultValue = "20") Integer size) {

                GetReviewVocabsRequest request = GetReviewVocabsRequest.builder()
                                .topicName(topicName)
                                .page(page)
                                .size(size)
                                .onlyNew(false)
                                .onlyDue(false)
                                .build();

                PagedReviewVocabResponse response = learnVocabService.getReviewVocabsPaged(user, request);

                return ResponseEntity.ok(ApiResponse.success(
                                "Lấy danh sách từ vựng để học theo topic thành công",
                                response));
        }

        @PostMapping("/submit")
        @Operation(summary = "Ghi nhận kết quả học từ vựng", description = """
                        Gửi kết quả HỌC từ vựng (click "Đã thuộc" hoặc "Chưa thuộc") và cập nhật tiến độ.

                        **URL:** `POST /api/v1/learn-vocabs/submit`

                        **Request Body:**
                        ```json
                        {
                          "vocabId": "uuid-here",
                          "isCorrect": true,
                          "quality": null
                        }
                        ```

                        **Parameters:**
                        - `vocabId` (required): UUID của từ vựng vừa học
                        - `isCorrect` (required):
                          - `true` = Click "Đã thuộc" → status = KNOWN
                          - `false` = Click "Chưa thuộc" → status = UNKNOWN
                        - `quality` (optional, 0-5): Đánh giá mức độ dễ nhớ (dùng cho SM-2)

                        **Quality Scale (0-5) - TÙY CHỌN:**
                        - 0️⃣ **Hoàn toàn không nhớ** - Quên sạch
                        - 1️⃣ **Sai nhưng có ấn tượng** - Nhớ mang máng
                        - 2️⃣ **Sai nhưng gần đúng** - Nhớ được một phần
                        - 3️⃣ **Đúng nhưng khó nhớ** - Phải suy nghĩ lâu
                        - 4️⃣ **Đúng và hơi dễ** - Nhớ khá nhanh
                        - 5️⃣ **Hoàn hảo, rất dễ** - Nhớ ngay lập tức

                        **Thuật toán:**
                        - Click "Đã thuộc" → timesCorrect++, status = KNOWN
                        - Click "Chưa thuộc" → timesWrong++, status = UNKNOWN
                        - Khi đủ điều kiện → status tự động chuyển MASTERED
                          (timesCorrect >= 10 && timesWrong <= 2 && accuracy >= 80%)

                        **Response:**
                        - Status mới: NEW → KNOWN/UNKNOWN → MASTERED
                        - Ngày học/ôn lại tiếp theo (nextReviewDate)
                        - Số lần đúng/sai cập nhật
                        - Thông báo khuyến khích

                        **Ví dụ:**
                        - Click "Đã thuộc": `isCorrect=true`
                        - Click "Chưa thuộc": `isCorrect=false`

                        **Lưu ý:** Gọi API này sau mỗi lần học để cập nhật tiến độ!
                        """, security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<ReviewResultResponse>> submitReview(
                        @AuthenticationPrincipal User user,
                        @Valid @RequestBody ReviewVocabRequest request) {

                ReviewResultResponse response = learnVocabService.submitReview(user, request);

                return ResponseEntity.ok(ApiResponse.success(
                                "Ghi nhận kết quả học từ vựng thành công",
                                response));
        }

        @GetMapping("/stats")
        @Operation(summary = "Thống kê tiến độ học tập", description = """
                        Lấy thống kê tổng quan về tiến độ HỌC từ vựng của user.

                        **URL:** `GET /api/v1/learn-vocabs/stats?topicName=Animals`

                        **Query Parameters:**
                        - `topicName` (optional): Tên topic để xem stats theo chủ đề
                          - Nếu có: Thống kê chỉ cho topic đó
                          - Nếu không: Thống kê toàn bộ

                        **Ví dụ:**
                        - Thống kê tổng thể: `/stats`
                        - Thống kê topic Animals: `/stats?topicName=Animals`
                        - Thống kê topic Business: `/stats?topicName=Business`

                        **Response:**
                        ```json
                        {
                          "totalVocabs": 150,      // Tổng số từ đã học
                          "newVocabs": 30,         // Số từ mới (NEW) chưa học
                          "learningVocabs": 80,    // Số từ đang học (KNOWN + UNKNOWN)
                          "masteredVocabs": 40,    // Số từ đã thành thạo (MASTERED)
                          "dueVocabs": 25          // Số từ cần ôn lại hôm nay
                        }
                        ```

                        **Giải thích Status:**
                        - **NEW**: Từ mới chưa học lần nào
                        - **KNOWN**: Đã thuộc (click "Đã thuộc")
                        - **UNKNOWN**: Chưa thuộc (click "Chưa thuộc")
                        - **MASTERED**: Đã thành thạo (timesCorrect >= 10, timesWrong <= 2, accuracy >= 80%)
                        - **learningVocabs**: Tổng của KNOWN + UNKNOWN

                        **Khi nào dùng:**
                        - Dashboard hiển thị tiến độ
                        - Kiểm tra số từ cần học/ôn hôm nay
                        - Theo dõi mục tiêu học tập
                        - So sánh tiến độ giữa các topic

                        **Use Cases:**
                        - Hiển thị progress bar: `masteredVocabs / totalVocabs * 100%`
                        - Badge notification: `dueVocabs` (số từ cần ôn)
                        - Motivational message: Dựa vào `learningVocabs` và `masteredVocabs`

                        **Tip:** Gọi API này trước khi bắt đầu session học để biết có bao nhiêu từ cần học!
                        """, security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<LearnVocabService.ReviewStatsResponse>> getReviewStats(
                        @AuthenticationPrincipal User user,
                        @Parameter(description = "Tên của topic (tùy chọn, để xem stats theo topic)", example = "Animals") @RequestParam(required = false) String topicName) {

                LearnVocabService.ReviewStatsResponse response = learnVocabService.getReviewStats(user, topicName);

                return ResponseEntity.ok(ApiResponse.success(
                                "Lấy thống kê tiến độ học tập thành công",
                                response));
        }
}
