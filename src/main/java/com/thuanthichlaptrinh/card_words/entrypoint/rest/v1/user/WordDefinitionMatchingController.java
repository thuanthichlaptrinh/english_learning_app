package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import com.thuanthichlaptrinh.card_words.core.usecase.user.GameHistoryService;
import com.thuanthichlaptrinh.card_words.core.usecase.user.WordDefinitionMatchingService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game.WordDefinitionMatchingAnswerRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game.WordDefinitionMatchingStartRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.LeaderboardEntryResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameInstructionResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.WordDefinitionMatchingResultResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.WordDefinitionMatchingSessionResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.List;
import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/v1/games/word-definition-matching")
@RequiredArgsConstructor
@Tag(name = "Word-Definition Matching Game", description = "API cho game ghép thẻ từ vựng với nghĩa")
public class WordDefinitionMatchingController {

        private final WordDefinitionMatchingService wordDefinitionMatchingService;
        private final GameHistoryService gameHistoryService;

        @GetMapping("/instructions")
        @Operation(summary = "Hướng dẫn chơi", description = "Lấy thông tin chi tiết về cách chơi và cách tính điểm")
        public ResponseEntity<GameInstructionResponse> getInstructions() {
                GameInstructionResponse instructions = GameInstructionResponse.builder()
                                .gameName("Word-Definition Matching")
                                .description("Ghép thẻ từ vựng với nghĩa tương ứng")
                                .rules(List.of(
                                                "Người chơi ghép các cặp từ vựng - nghĩa",
                                                "Từ vựng được chọn ngẫu nhiên theo CEFR (nếu có)",
                                                "Không cần hình ảnh, chỉ dựa vào từ và nghĩa",
                                                "Điểm được tính theo CEFR và thời gian hoàn thành"))
                                .scoring(List.of(
                                                "Điểm CEFR: A1=1, A2=2, B1=3, B2=4, C1=5, C2=6",
                                                "Time Bonus: < 10s = +50%, < 20s = +30%, < 30s = +20%, < 60s = +10%",
                                                "Tổng điểm = Tổng điểm CEFR + Time Bonus",
                                                "Ví dụ: 5 từ B2 (20đ) hoàn thành 18s → 20 + 6 = 26đ"))
                                .build();

                return ResponseEntity.ok(instructions);
        }

        @PostMapping("/start")
        @PreAuthorize("isAuthenticated()")
        @Operation(summary = "Bắt đầu game ghép thẻ", description = "Khởi tạo phiên chơi mới. Từ vựng được random ngẫu nhiên (không giới hạn topic). Trả về danh sách từ vựng với word và meaningVi. Frontend tự clone và tạo cards để ghép.")
        public ResponseEntity<WordDefinitionMatchingSessionResponse> startGame(
                        @RequestBody WordDefinitionMatchingStartRequest request) {
                log.info("API: Start Word-Definition Matching game - pairs: {}, cefr: {}",
                                request.getTotalPairs(), request.getCefr());

                WordDefinitionMatchingSessionResponse response = wordDefinitionMatchingService.startGame(request);
                return ResponseEntity.ok(response);
        }

        @PostMapping("/submit")
        @PreAuthorize("isAuthenticated()")
        @Operation(summary = "Nộp kết quả ghép thẻ", description = "Gửi danh sách vocab IDs đã ghép đúng. Điểm = CEFR score + time bonus. Càng nhanh càng cao điểm: <10s +50%, <20s +30%, <30s +20%, <60s +10%")
        public ResponseEntity<WordDefinitionMatchingResultResponse> submitAnswer(
                        @RequestBody WordDefinitionMatchingAnswerRequest request) {
                log.info("API: Submit Word-Definition Matching answer - sessionId: {}, matched: {}",
                                request.getSessionId(), request.getMatchedVocabIds().size());

                WordDefinitionMatchingResultResponse response = wordDefinitionMatchingService.submitAnswer(request);
                return ResponseEntity.ok(response);
        }

        @GetMapping("/session/{sessionId}")
        @PreAuthorize("isAuthenticated()")
        @Operation(summary = "Lấy thông tin session", description = "Lấy thông tin chi tiết của session hiện tại")
        public ResponseEntity<WordDefinitionMatchingSessionResponse> getSession(
                        @PathVariable Long sessionId) {
                log.info("API: Get session info - sessionId: {}", sessionId);

                WordDefinitionMatchingSessionResponse response = wordDefinitionMatchingService.getSession(sessionId);
                return ResponseEntity.ok(response);
        }

        @GetMapping("/leaderboard")
        @PreAuthorize("isAuthenticated()")
        @Operation(summary = "Bảng xếp hạng Word-Definition Matching", description = "Lấy danh sách top người chơi có điểm cao nhất trong game Word-Definition Matching. "
                        +
                        "Kết quả sẽ highlight người chơi hiện tại (nếu có trong bảng xếp hạng).")
        public ResponseEntity<List<LeaderboardEntryResponse>> getLeaderboard(
                        Authentication authentication,
                        @RequestParam(defaultValue = "100") int limit) {
                log.info("API: Get Word-Definition Matching leaderboard - limit: {}", limit);

                UUID userId = getUserIdFromAuth(authentication);
                Long gameId = 3L; // Word-Definition Matching game ID
                List<LeaderboardEntryResponse> response = gameHistoryService.getGameLeaderboard(gameId, userId, limit);
                return ResponseEntity.ok(response);
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
