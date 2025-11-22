package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.admin;

import com.thuanthichlaptrinh.card_words.core.usecase.user.NotificationService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.NotificationFilterRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.NotificationCategoryResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.NotificationResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping(path = "/api/v1/admin/notifications")
@RequiredArgsConstructor
@Tag(name = "Notifications Admin", description = "API quản lý thông báo cho admin")
@PreAuthorize("hasRole('ROLE_ADMIN')")
@SecurityRequirement(name = "Bearer Authentication")
public class NotificationAdminController {

        private final NotificationService notificationService;

        @GetMapping
        @Operation(summary = "[Admin] Lấy thông báo toàn hệ thống", description = "Lấy danh sách thông báo của tất cả users trong hệ thống, hỗ trợ filter isRead/type và phân trang."
                        + "\n\n**URL**: `GET /api/v1/admin/notifications`")
        public ResponseEntity<ApiResponse<Page<NotificationResponse>>> getAllNotifications(
                        @Valid @ModelAttribute NotificationFilterRequest request) {

                Page<NotificationResponse> response = notificationService.getAllNotifications(request);
                return ResponseEntity.ok(ApiResponse.success("Lấy danh sách thông báo toàn hệ thống thành công", response));
        }

        @GetMapping("/users/{userId}")
        @Operation(summary = "[Admin] Lấy thông báo của một user", description = "Lấy danh sách thông báo của user bất kỳ với đầy đủ filter giống API phía user\n\n"
                        +
                        "**URL**: `GET /api/v1/admin/notifications/users/{userId}`\n\n" +
                        "**Query Parameters:** isRead, type, page, size (tùy chọn)")
        public ResponseEntity<ApiResponse<Page<NotificationResponse>>> getUserNotifications(
                        @PathVariable UUID userId,
                        @Valid @ModelAttribute NotificationFilterRequest request) {

                Page<NotificationResponse> response = notificationService.getUserNotificationsAsAdmin(userId, request);
                return ResponseEntity.ok(ApiResponse.success("Lấy danh sách thông báo của user thành công", response));
        }

        @GetMapping("/users")
        @Operation(summary = "[Admin] Lấy thông báo của nhiều user", description = "Lấy danh sách thông báo của nhiều user trong cùng một feed, sắp xếp theo thời gian tạo gần nhất\n\n"
                        +
                        "**URL**: `GET /api/v1/admin/notifications/users?userIds={id1}&userIds={id2}`\n\n" +
                        "**Lưu ý:** truyền nhiều `userIds` bằng cách lặp lại query param. Hỗ trợ filter isRead/type/page/size.")
        public ResponseEntity<ApiResponse<Page<NotificationResponse>>> getNotificationsForUsers(
                        @RequestParam List<UUID> userIds,
                        @Valid @ModelAttribute NotificationFilterRequest request) {

                Page<NotificationResponse> response = notificationService.getNotificationsForUsers(userIds, request);
                return ResponseEntity.ok(ApiResponse.success("Lấy danh sách thông báo của nhiều user thành công", response));
        }

        @GetMapping("/categories")
        @Operation(summary = "[Admin] Lấy danh sách notification categories", description = "Lấy danh sách tất cả notification categories với số lượng thông báo trong hệ thống\n\n"
                        +
                        "**URL**: `GET http://localhost:8080/api/v1/admin/notifications/categories`\n\n" +
                        "**Response bao gồm:**\n" +
                        "- All Notifications: Tổng số thông báo toàn hệ thống\n" +
                        "- Unread: Số thông báo chưa đọc\n" +
                        "- Study Progress: Số thông báo về tiến trình học tập\n" +
                        "- Vocabulary Reminders: Số thông báo nhắc nhở từ vựng\n" +
                        "- Streak Reminders: Số thông báo nhắc nhở streak\n" +
                        "- Streak Milestones: Số thông báo cột mốc streak\n" +
                        "- Game Achievements: Số thông báo thành tích game\n" +
                        "- Achievements: Số thông báo thành tựu\n" +
                        "- New Features: Số thông báo tính năng mới\n" +
                        "- System Alerts: Số thông báo hệ thống")
        public ResponseEntity<ApiResponse<List<NotificationCategoryResponse>>> getCategories() {
                List<NotificationCategoryResponse> response = notificationService.getAllCategories();
                return ResponseEntity.ok(ApiResponse.success("Lấy danh sách categories thành công", response));
        }

        @GetMapping("/summary")
        @Operation(summary = "[Admin] Lấy tổng quan thông báo toàn hệ thống", description = "Lấy tổng số thông báo, unread và read trong toàn hệ thống\n\n"
                        +
                        "**URL**: `GET http://localhost:8080/api/v1/admin/notifications/summary`\n\n" +
                        "**Response:**\n" +
                        "- Total: Tổng số thông báo\n" +
                        "- Unread: Số thông báo chưa đọc\n" +
                        "- Read: Số thông báo đã đọc")
        public ResponseEntity<ApiResponse<List<NotificationCategoryResponse>>> getSummary() {
                List<NotificationCategoryResponse> response = notificationService.getAdminSummary();
                return ResponseEntity.ok(ApiResponse.success("Lấy tổng quan thành công", response));
        }

        @PostMapping
        @Operation(summary = "[Admin] Tạo thông báo cho một user", description = "Tạo thông báo mới cho một user cụ thể\n\n"
                        +
                        "**URL**: `POST http://localhost:8080/api/v1/admin/notifications`\n\n" +
                        "**Request Body:**\n" +
                        "```json\n" +
                        "{\n" +
                        "  \"userId\": \"uuid-here\",\n" +
                        "  \"title\": \"Vocabulary Review Reminder\",\n" +
                        "  \"content\": \"Your vocabulary review session is scheduled...\",\n" +
                        "  \"type\": \"vocab_reminder\"\n" +
                        "}\n" +
                        "```\n\n" +
                        "**Types:** vocab_reminder, new_feature, achievement, system_alert, study_progress")
        public ResponseEntity<ApiResponse<NotificationResponse>> createNotification(
                        @Valid @RequestBody CreateNotificationRequest request) {

                NotificationResponse response = notificationService.createNotification(request);
                return ResponseEntity.ok(ApiResponse.success("Tạo thông báo thành công", response));
        }

        @PostMapping("/broadcast")
        @Operation(summary = "[Admin] Tạo thông báo cho tất cả users", description = "Tạo thông báo cho tất cả users trong hệ thống\n\n"
                        +
                        "**URL**: `POST http://localhost:8080/api/v1/admin/notifications/broadcast`\n\n" +
                        "**Request Body:**\n" +
                        "```json\n" +
                        "{\n" +
                        "  \"title\": \"New Vocabulary Package Available\",\n" +
                        "  \"content\": \"New vocabulary package has been added...\",\n" +
                        "  \"type\": \"new_feature\"\n" +
                        "}\n" +
                        "```\n\n" +
                        "**Lưu ý:** userId sẽ bị bỏ qua trong request này")
        public ResponseEntity<ApiResponse<Void>> createNotificationForAll(
                        @Valid @RequestBody CreateNotificationRequest request) {

                notificationService.createNotificationForAll(request);
                return ResponseEntity.ok(ApiResponse.success("Tạo thông báo cho tất cả users thành công", null));
        }

        @DeleteMapping("/{userId}/{notificationId}")
        @Operation(summary = "[Admin] Xóa thông báo của user", description = "Xóa một thông báo cụ thể của user\n\n"
                        +
                        "**URL**: `DELETE http://localhost:8080/api/v1/admin/notifications/{userId}/{notificationId}`\n\n"
                        +
                        "**Ví dụ:** `DELETE http://localhost:8080/api/v1/admin/notifications/550e8400-e29b-41d4-a716-446655440000/123`")
        public ResponseEntity<ApiResponse<Void>> deleteNotification(
                        @PathVariable UUID userId,
                        @PathVariable Long notificationId) {

                notificationService.deleteNotification(userId, notificationId);
                return ResponseEntity.ok(ApiResponse.success("Xóa thông báo thành công", null));
        }

        @DeleteMapping("/{userId}/batch")
        @Operation(summary = "[Admin] Xóa nhiều thông báo của user", description = "Xóa nhiều thông báo cùng lúc của một user\n\n"
                        +
                        "**URL**: `DELETE http://localhost:8080/api/v1/admin/notifications/{userId}/batch`\n\n" +
                        "**Request Params:** `ids=123,456,789`\n\n" +
                        "**Ví dụ:** `DELETE http://localhost:8080/api/v1/admin/notifications/550e8400-e29b-41d4-a716-446655440000/batch?ids=123,456,789`")
        public ResponseEntity<ApiResponse<Void>> deleteNotifications(
                        @PathVariable UUID userId,
                        @RequestParam List<Long> ids) {

                notificationService.deleteNotifications(userId, ids);
                return ResponseEntity.ok(ApiResponse.success("Xóa " + ids.size() + " thông báo thành công", null));
        }
}
