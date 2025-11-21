package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import com.thuanthichlaptrinh.card_words.common.helper.AuthenticationHelper;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.core.usecase.user.OfflineSyncService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.offline.*;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.offline.TopicProgressResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.offline.UserVocabProgressDownloadResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.offline.VocabWithProgressResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/offline")
@RequiredArgsConstructor
@Tag(name = "Offline Sync", description = "API để hỗ trợ chơi game và học từ vựng offline")
public class OfflineSyncController {

        private final OfflineSyncService offlineSyncService;
        private final AuthenticationHelper authHelper;

        // ==================== DOWNLOAD APIs ====================

        @GetMapping("/topics")
        @Operation(summary = "Lấy danh sách topics", description = "Trả về tất cả topics kèm thông tin:\n"
                        +
                        "- Tổng số từ vựng trong topic\n" +
                        "- Số từ đã học (LEARNED/REVIEWING)\n" +
                        "- Phần trăm hoàn thành (0-100%)\n\n" +
                        "**Use case:** User chọn topic để download về học offline")
        public ResponseEntity<ApiResponse<List<TopicProgressResponse>>> getTopicsWithProgress(
                        Authentication authentication) {

                UUID userId = authHelper.getCurrentUserId(authentication);
                List<TopicProgressResponse> topics = offlineSyncService.getTopicsWithProgress(userId);

                return ResponseEntity.ok(ApiResponse.success(
                                String.format("Retrieved %d topics with progress", topics.size()),
                                topics));
        }

        @GetMapping("/topics/{topicId}/vocabs")
        @Operation(summary = "Download từ vựng của 1 topic cụ thể", description = "Trả về tất cả vocabs trong topic kèm user progress (nếu có).\n\n"
                        +
                        "**Response bao gồm:**\n" +
                        "- Thông tin vocab: word, meaning, audio, img, example\n" +
                        "- User progress: status, lastReviewed, nextReview, easeFactor\n\n" +
                        "**Use case:** User chọn 1 topic và download về để học offline")
        public ResponseEntity<ApiResponse<List<VocabWithProgressResponse>>> getVocabsByTopic(
                        Authentication authentication,
                        @PathVariable Long topicId) {

                UUID userId = authHelper.getCurrentUserId(authentication);
                List<VocabWithProgressResponse> vocabs = offlineSyncService.getVocabsByTopic(userId, topicId);

                return ResponseEntity.ok(ApiResponse.success(
                                String.format("Downloaded %d vocabs from topic %d", vocabs.size(), topicId),
                                vocabs));
        }

        @GetMapping("/vocabs/recent")
        @Operation(summary = "Lấy từ vựng đã học gần đây (30 ngày)", description = "Trả về các vocabs mà user đã review trong 30 ngày qua.\n\n"
                        +
                        "**Use case:** Quick sync - chỉ tải những từ đang học, không cần tải hết topic")
        public ResponseEntity<ApiResponse<List<VocabWithProgressResponse>>> getRecentVocabs(
                        Authentication authentication) {

                UUID userId = authHelper.getCurrentUserId(authentication);
                List<VocabWithProgressResponse> vocabs = offlineSyncService.getRecentVocabs(userId);

                return ResponseEntity.ok(ApiResponse.success(
                                String.format("Retrieved %d recent vocabs", vocabs.size()),
                                vocabs));
        }

        @GetMapping("/check-updates")
        @Operation(summary = "Kiểm tra có dữ liệu mới không", description = "Kiểm tra xem có vocab mới được thêm sau lần sync cuối không.\n\n"
                        +
                        "**Request:** `lastSyncTime` (ISO 8601 format)\n" +
                        "**Response:** Có updates không + số lượng vocab mới")
        public ResponseEntity<ApiResponse<Map<String, Object>>> checkForUpdates(
                        @Parameter(description = "Thời gian sync cuối (ISO 8601)", example = "2025-11-09T10:00:00") @RequestParam String lastSyncTime) {

                Map<String, Object> updateInfo = offlineSyncService.checkForUpdates(lastSyncTime);

                return ResponseEntity.ok(ApiResponse.success(
                                "Update check completed",
                                updateInfo));
        }

        @GetMapping("/user-vocab-progress")
        @Operation(summary = "Download tất cả UserVocabProgress của user", description = "Trả về tất cả tiến trình học từ vựng của user với đầy đủ các trường từ database.")
        public ResponseEntity<ApiResponse<List<UserVocabProgressDownloadResponse>>> getAllUserVocabProgress(
                        Authentication authentication) {

                UUID userId = authHelper.getCurrentUserId(authentication);
                List<UserVocabProgressDownloadResponse> progressList = offlineSyncService
                                .getAllUserVocabProgress(userId);

                return ResponseEntity.ok(ApiResponse.success(
                                String.format("Downloaded %d vocab progress records", progressList.size()),
                                progressList));
        }

        // ==================== UPLOAD APIs - Batch ====================

        @PostMapping("/sync/batch")
        @Operation(summary = "Batch upload - Upload TẤT CẢ trong 1 request (RECOMMENDED)", description = "Upload game sessions + details + vocab progress trong 1 transaction.\n\n"
                        +
                        "**Ưu điểm:**\n" +
                        "- Chỉ 1 request thay vì nhiều requests\n" +
                        "- Transaction safety (all-or-nothing)\n" +
                        "- Tự động xử lý duplicates\n" +
                        "- Merge conflicts (client data mới hơn thì update)\n\n" +
                        "**Use case:** Khi có mạng trở lại, auto sync tất cả dữ liệu offline")
        public ResponseEntity<ApiResponse<Map<String, Object>>> batchSync(
                        Authentication authentication,
                        @RequestBody BatchSyncRequest request) {

                UUID userId = authHelper.getCurrentUserId(authentication);
                Map<String, Object> result = offlineSyncService.syncBatch(userId, request);

                return ResponseEntity.ok(ApiResponse.success(
                                "Batch sync completed",
                                result));
        }

        @PostMapping("/sync/complete")
        @Operation(summary = "Complete Sync - Upload game sessions + details + vocab progress", description = "**API đầy đủ nhất - Upload 3 list cùng lúc:**\n\n"
                        +
                        "1. **gameSessions** - Danh sách các lần chơi game (3 sessions)\n" +
                        "2. **gameSessionDetails** - Chi tiết từng câu hỏi (15 details = 3×5 câu)\n" +
                        "3. **userVocabProgress** - Tiến trình học từ vựng (optional)\n\n" +
                        "**Processing flow:**\n" +
                        "- Step 1: Lưu game sessions\n" +
                        "- Step 2: Lưu game session details → **Tự động cập nhật user_vocab_progress**\n" +
                        "  - isCorrect = true → timesCorrect++\n" +
                        "  - isCorrect = false → timesWrong++\n" +
                        "  - Áp dụng SM-2 algorithm (Spaced Repetition)\n" +
                        "  - Update status: UNKNOWN → KNOWN → MASTERED\n" +
                        "- Step 3: Merge với userVocabProgress manual updates (nếu có)\n\n" +
                        "**Response:**\n" +
                        "```json\n" +
                        "{\n" +
                        "  \"syncedGameSessions\": 3,\n" +
                        "  \"syncedGameSessionDetails\": 15,\n" +
                        "  \"syncedVocabProgress\": 0,\n" +
                        "  \"errors\": []\n" +
                        "}\n" +
                        "```\n\n" +
                        "**Use case:** Offline mode - User chơi 3 game × 5 câu, khi có mạng gửi tất cả lên")
        public ResponseEntity<ApiResponse<Map<String, Object>>> completeSyncAll(
                        Authentication authentication,
                        @RequestBody BatchSyncRequest request) {

                UUID userId = authHelper.getCurrentUserId(authentication);

                // Validate request
                if (request.getGameSessions() == null || request.getGameSessions().isEmpty()) {
                        return ResponseEntity.badRequest().body(
                                        ApiResponse.error("400", "gameSessions is required"));
                }

                if (request.getGameSessionDetails() == null || request.getGameSessionDetails().isEmpty()) {
                        return ResponseEntity.badRequest().body(
                                        ApiResponse.error("400", "gameSessionDetails is required"));
                }

                Map<String, Object> result = offlineSyncService.syncBatch(userId, request);

                return ResponseEntity.ok(ApiResponse.success(
                                String.format("Complete sync finished: %d sessions, %d details, %d progress updates",
                                                result.get("syncedGameSessions"),
                                                result.get("syncedGameSessionDetails"),
                                                result.get("syncedVocabProgress")),
                                result));
        }

        @PostMapping("/game-sessions")
        @Operation(summary = "Upload game sessions riêng lẻ", description = "Upload game sessions và details (fallback nếu batch sync fail).\n\n"
                        +
                        "**Note:** Nên dùng `/sync/batch` thay vì endpoint này")
        public ResponseEntity<ApiResponse<String>> uploadGameSessions(
                        Authentication authentication,
                        @RequestBody List<OfflineGameSessionRequest> sessions) {

                UUID userId = authHelper.getCurrentUserId(authentication);
                int syncedCount = offlineSyncService.syncGameSessions(userId, sessions);

                return ResponseEntity.ok(ApiResponse.success(
                                String.format("Synced %d game sessions", syncedCount),
                                null));
        }

        @PostMapping("/user-vocab-progress")
        @Operation(summary = "Upload learning progress riêng lẻ", description = "Upload vocab progress (fallback nếu batch sync fail).\n\n"
                        +
                        "**Note:** Nên dùng `/sync/batch` thay vì endpoint này")
        public ResponseEntity<ApiResponse<String>> uploadVocabProgress(
                        Authentication authentication,
                        @RequestBody List<OfflineVocabProgressRequest> progressList) {

                UUID userId = authHelper.getCurrentUserId(authentication);
                int syncedCount = offlineSyncService.syncVocabProgress(userId, progressList);

                return ResponseEntity.ok(ApiResponse.success(
                                String.format("Synced %d vocab progress", syncedCount),
                                null));
        }

        @PostMapping("/game-session-details")
        @Operation(summary = "Upload game session details riêng lẻ", description = "Upload chi tiết câu hỏi của một game session (fallback nếu batch sync fail).\\n\\n"
                        +
                        "**Use case:** Upload details cho session đã tồn tại, hoặc upload details riêng\\n\\n" +
                        "**Note:** Nên dùng `/sync/batch` hoặc `/game-sessions` (đã bao gồm details) thay vì endpoint này")
        public ResponseEntity<ApiResponse<String>> uploadGameSessionDetails(
                        Authentication authentication,
                        @Parameter(description = "ID của game session", required = true) @RequestParam UUID sessionId,
                        @RequestBody List<OfflineGameDetailRequest> details) {

                UUID userId = authHelper.getCurrentUserId(authentication);
                int syncedCount = offlineSyncService.syncGameSessionDetails(userId, sessionId, details);

                return ResponseEntity.ok(ApiResponse.success(
                                String.format("Synced %d game session details", syncedCount),
                                null));
        }

}
