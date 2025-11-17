package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.usecase.user.LeaderboardService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.LeaderboardEntryResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.TopPlayersResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/v1/leaderboard")
@RequiredArgsConstructor
@Tag(name = "Leaderboard", description = "Leaderboard APIs - Bảng xếp hạng")
public class LeaderboardController {

        private final LeaderboardService leaderboardService;

        @GetMapping("/top-players")
        @Operation(summary = "Lấy 10 user có điểm cao nhất từ 3 game", description = "Lấy top 10 người chơi có điểm cao nhất từ cả 3 tựa game: Quick Quiz, Image Matching, và Word Definition")
        public ResponseEntity<ApiResponse<TopPlayersResponse>> getTopPlayersAllGames() {
                TopPlayersResponse response = leaderboardService.getTopPlayersAllGames();
                return ResponseEntity.ok(ApiResponse.success("Lấy 10 người chơi hàng đầu thành công", response));
        }

        @GetMapping("/quiz/global")
        @Operation(summary = "Lấy bảng xếp hạng Quick Quiz toàn cầu", description = "Lấy bảng xếp hạng Quick Quiz toàn cầu")
        public ResponseEntity<ApiResponse<List<LeaderboardEntryResponse>>> getQuizGlobalLeaderboard(
                        @RequestParam(defaultValue = "100") int limit) {
                log.info("🌍 GET /api/v1/leaderboard/quiz/global - limit={}", limit);

                List<LeaderboardEntryResponse> leaderboard = leaderboardService
                                .getQuizGlobalLeaderboard(Math.min(limit, 100));

                return ResponseEntity.ok(
                                ApiResponse.success("Lấy bảng xếp hạng Quick Quiz toàn cầu thành công", leaderboard));
        }

        @GetMapping("/quiz/daily")
        @Operation(summary = "Lấy bảng xếp hạng Quick Quiz theo ngày", description = "Lấy bảng xếp hạng Quick Quiz theo ngày")
        public ResponseEntity<ApiResponse<List<LeaderboardEntryResponse>>> getQuizDailyLeaderboard(
                        @RequestParam(required = false) LocalDate date,
                        @RequestParam(defaultValue = "50") int limit) {

                LocalDate targetDate = date != null ? date : LocalDate.now();

                List<LeaderboardEntryResponse> leaderboard = leaderboardService.getQuizDailyLeaderboard(targetDate,
                                Math.min(limit, 100));

                return ResponseEntity.ok(
                                ApiResponse.success("Lấy bảng xếp hạng Quick Quiz theo ngày thành công", leaderboard));
        }

        @GetMapping("/quiz/my-rank")
        @Operation(summary = "Lấy xếp hạng của tôi trong Quick Quiz", description = "Lấy xếp hạng của tôi trong Quick Quiz")
        public ResponseEntity<ApiResponse<LeaderboardEntryResponse>> getMyQuizRank(@AuthenticationPrincipal User user) {
                LeaderboardEntryResponse myRank = leaderboardService.getUserQuizRank(user.getId());

                return ResponseEntity
                                .ok(ApiResponse.success("Lấy xếp hạng của tôi trong Quick Quiz thành công", myRank));
        }

        @GetMapping("/streak/current")
        @Operation(summary = "Lấy bảng xếp hạng streak hiện tại", description = "Lấy bảng xếp hạng streak hiện tại")
        public ResponseEntity<ApiResponse<List<LeaderboardEntryResponse>>> getCurrentStreakLeaderboard(
                        @RequestParam(defaultValue = "50") int limit) {
                List<LeaderboardEntryResponse> leaderboard = leaderboardService
                                .getStreakLeaderboard(Math.min(limit, 100));

                return ResponseEntity
                                .ok(ApiResponse.success("Lấy bảng xếp hạng streak hiện tại thành công", leaderboard));
        }

        @GetMapping("/streak/best")
        @Operation(summary = "Lấy bảng xếp hạng streak tốt nhất", description = "Lấy bảng xếp hạng streak tốt nhất")
        public ResponseEntity<ApiResponse<List<LeaderboardEntryResponse>>> getBestStreakLeaderboard(
                        @RequestParam(defaultValue = "50") int limit) {
                List<LeaderboardEntryResponse> leaderboard = leaderboardService
                                .getBestStreakLeaderboard(Math.min(limit, 100));

                return ResponseEntity
                                .ok(ApiResponse.success("Lấy bảng xếp hạng streak tốt nhất thành công", leaderboard));
        }

        // ==================== OTHER GAME LEADERBOARDS ====================

        @GetMapping("/image-matching")
        @Operation(summary = "Lấy bảng xếp hạng Image Matching", description = "Lấy bảng xếp hạng Image Matching")
        public ResponseEntity<ApiResponse<List<LeaderboardEntryResponse>>> getImageMatchingLeaderboard(
                        @RequestParam(defaultValue = "50") int limit) {

                List<LeaderboardEntryResponse> leaderboard = leaderboardService
                                .getImageMatchingLeaderboard(Math.min(limit, 100));

                return ResponseEntity
                                .ok(ApiResponse.success("Lấy bảng xếp hạng Image Matching thành công", leaderboard));
        }

        @GetMapping("/word-definition")
        @Operation(summary = "Lấy bảng xếp hạng Word Definition", description = "Lấy bảng xếp hạng Word Definition")
        public ResponseEntity<ApiResponse<List<LeaderboardEntryResponse>>> getWordDefLeaderboard(
                        @RequestParam(defaultValue = "50") int limit) {

                List<LeaderboardEntryResponse> leaderboard = leaderboardService
                                .getWordDefLeaderboard(Math.min(limit, 100));

                return ResponseEntity
                                .ok(ApiResponse.success("Lấy bảng xếp hạng Word Definition thành công", leaderboard));
        }
}
