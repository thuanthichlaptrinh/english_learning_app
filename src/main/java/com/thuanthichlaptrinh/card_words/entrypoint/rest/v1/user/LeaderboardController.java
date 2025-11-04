package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.usecase.user.LeaderboardService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.LeaderboardEntryResponse;
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

        // ==================== QUICK QUIZ LEADERBOARDS ====================

        @GetMapping("/quiz/global")
        @Operation(summary = "Get Quick Quiz global leaderboard", description = "Lấy bảng xếp hạng Quick Quiz toàn cầu")
        public ResponseEntity<List<LeaderboardEntryResponse>> getQuizGlobalLeaderboard(
                        @RequestParam(defaultValue = "100") int limit) {
                log.info("🌍 GET /api/v1/leaderboard/quiz/global - limit={}", limit);

                List<LeaderboardEntryResponse> leaderboard = leaderboardService
                                .getQuizGlobalLeaderboard(Math.min(limit, 100));

                return ResponseEntity.ok(leaderboard);
        }

        @GetMapping("/quiz/daily")
        @Operation(summary = "Get Quick Quiz daily leaderboard", description = "Lấy bảng xếp hạng Quick Quiz theo ngày")
        public ResponseEntity<List<LeaderboardEntryResponse>> getQuizDailyLeaderboard(
                        @RequestParam(required = false) LocalDate date,
                        @RequestParam(defaultValue = "50") int limit) {

                LocalDate targetDate = date != null ? date : LocalDate.now();
                log.info("📅 GET /api/v1/leaderboard/quiz/daily - date={}, limit={}", targetDate, limit);

                List<LeaderboardEntryResponse> leaderboard = leaderboardService.getQuizDailyLeaderboard(targetDate,
                                Math.min(limit, 100));

                return ResponseEntity.ok(leaderboard);
        }

        @GetMapping("/quiz/my-rank")
        @Operation(summary = "Get my rank in Quick Quiz", description = "Lấy xếp hạng của tôi trong Quick Quiz")
        public ResponseEntity<LeaderboardEntryResponse> getMyQuizRank(
                        @AuthenticationPrincipal User user) {
                log.info("🎯 GET /api/v1/leaderboard/quiz/my-rank - userId={}", user.getId());

                LeaderboardEntryResponse myRank = leaderboardService.getUserQuizRank(user.getId());

                if (myRank == null) {
                        return ResponseEntity.noContent().build();
                }

                return ResponseEntity.ok(myRank);
        }

        // ==================== STREAK LEADERBOARDS ====================

        @GetMapping("/streak/current")
        @Operation(summary = "Get current streak leaderboard", description = "Lấy bảng xếp hạng streak hiện tại")
        public ResponseEntity<List<LeaderboardEntryResponse>> getCurrentStreakLeaderboard(
                        @RequestParam(defaultValue = "50") int limit) {
                log.info("🔥 GET /api/v1/leaderboard/streak/current - limit={}", limit);

                List<LeaderboardEntryResponse> leaderboard = leaderboardService
                                .getStreakLeaderboard(Math.min(limit, 100));

                return ResponseEntity.ok(leaderboard);
        }

        @GetMapping("/streak/best")
        @Operation(summary = "Get best streak leaderboard", description = "Lấy bảng xếp hạng streak tốt nhất")
        public ResponseEntity<List<LeaderboardEntryResponse>> getBestStreakLeaderboard(
                        @RequestParam(defaultValue = "50") int limit) {
                log.info("🏆 GET /api/v1/leaderboard/streak/best - limit={}", limit);

                List<LeaderboardEntryResponse> leaderboard = leaderboardService
                                .getBestStreakLeaderboard(Math.min(limit, 100));

                return ResponseEntity.ok(leaderboard);
        }

        // ==================== OTHER GAME LEADERBOARDS ====================

        @GetMapping("/image-matching")
        @Operation(summary = "Get Image Matching leaderboard", description = "Lấy bảng xếp hạng Image Matching")
        public ResponseEntity<List<LeaderboardEntryResponse>> getImageMatchingLeaderboard(
                        @RequestParam(defaultValue = "50") int limit) {
                log.info("🖼️ GET /api/v1/leaderboard/image-matching - limit={}", limit);

                List<LeaderboardEntryResponse> leaderboard = leaderboardService
                                .getImageMatchingLeaderboard(Math.min(limit, 100));

                return ResponseEntity.ok(leaderboard);
        }

        @GetMapping("/word-definition")
        @Operation(summary = "Get Word Definition leaderboard", description = "Lấy bảng xếp hạng Word Definition")
        public ResponseEntity<List<LeaderboardEntryResponse>> getWordDefLeaderboard(
                        @RequestParam(defaultValue = "50") int limit) {
                log.info("📖 GET /api/v1/leaderboard/word-definition - limit={}", limit);

                List<LeaderboardEntryResponse> leaderboard = leaderboardService
                                .getWordDefLeaderboard(Math.min(limit, 100));

                return ResponseEntity.ok(leaderboard);
        }
}
