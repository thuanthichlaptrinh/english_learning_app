package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import com.thuanthichlaptrinh.card_words.common.helper.AuthenticationHelper;
import com.thuanthichlaptrinh.card_words.core.usecase.user.NotificationService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.NotificationFilterRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.NotificationResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.NotificationSummaryResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping(path = "/api/v1/notifications")
@RequiredArgsConstructor
@Tag(name = "Notifications", description = "API quản lý thông báo cho user")
@SecurityRequirement(name = "Bearer Authentication")
public class NotificationController {

        private final NotificationService notificationService;
        private final AuthenticationHelper authHelper;

        @GetMapping
        @Operation(summary = "Lấy danh sách thông báo", description = "Lấy danh sách thông báo của user với filters\n\n"
                        +
                        "**URL**: `GET http://localhost:8080/api/v1/notifications`\n\n" +
                        "**Query Parameters:**\n" +
                        "- isRead: Lọc theo trạng thái đã đọc (true/false)\n" +
                        "- type: Lọc theo loại thông báo (vocab_reminder, new_feature, achievement, system_alert, study_progress)\n"
                        +
                        "- page: Số trang (default 0)\n" +
                        "- size: Kích thước trang (default 10)\n\n" +
                        "**Example**: `GET http://localhost:8080/api/v1/notifications?isRead=false&page=0&size=10`")
        public ResponseEntity<ApiResponse<Page<NotificationResponse>>> getNotifications(
                        Authentication authentication,
                        @Valid @ModelAttribute NotificationFilterRequest request) {

                UUID userId = authHelper.getCurrentUserId(authentication);
                Page<NotificationResponse> response = notificationService.getNotifications(userId, request);
                return ResponseEntity.ok(ApiResponse.success("Lấy danh sách thông báo thành công", response));
        }

        @GetMapping("/summary")
        @Operation(summary = "Lấy tổng quan thông báo", description = "Lấy tổng quan về thông báo của user\n\n" +
                        "**URL**: `GET http://localhost:8080/api/v1/notifications/summary`\n\n" +
                        "**Response bao gồm:**\n" +
                        "- totalNotifications: Tổng số thông báo\n" +
                        "- unreadNotifications: Số thông báo chưa đọc\n" +
                        "- readNotifications: Số thông báo đã đọc")
        public ResponseEntity<ApiResponse<NotificationSummaryResponse>> getSummary(Authentication authentication) {
                UUID userId = authHelper.getCurrentUserId(authentication);
                NotificationSummaryResponse response = notificationService.getSummary(userId);
                return ResponseEntity.ok(ApiResponse.success("Lấy tổng quan thành công", response));
        }

        @PutMapping("/{id}/read")
        @Operation(summary = "Đánh dấu thông báo đã đọc", description = "Đánh dấu một thông báo là đã đọc\n\n" +
                        "**URL**: `PUT http://localhost:8080/api/v1/notifications/{id}/read`\n\n" +
                        "**Example**: `PUT http://localhost:8080/api/v1/notifications/1/read`")
        public ResponseEntity<ApiResponse<Void>> markAsRead(
                        Authentication authentication,
                        @Parameter(description = "ID của thông báo") @PathVariable Long id) {

                UUID userId = authHelper.getCurrentUserId(authentication);
                notificationService.markAsRead(userId, id);
                return ResponseEntity.ok(ApiResponse.success("Đánh dấu đã đọc thành công", null));
        }

        @PutMapping("/read-all")
        @Operation(summary = "Đánh dấu tất cả thông báo đã đọc", description = "Đánh dấu tất cả thông báo của user là đã đọc\n\n"
                        +
                        "**URL**: `PUT http://localhost:8080/api/v1/notifications/read-all`")
        public ResponseEntity<ApiResponse<Integer>> markAllAsRead(Authentication authentication) {
                UUID userId = authHelper.getCurrentUserId(authentication);
                int count = notificationService.markAllAsRead(userId);
                return ResponseEntity.ok(ApiResponse.success("Đã đánh dấu " + count + " thông báo", count));
        }

        @DeleteMapping("/{id}")
        @Operation(summary = "Xóa thông báo", description = "Xóa một thông báo\n\n" +
                        "**URL**: `DELETE http://localhost:8080/api/v1/notifications/{id}`\n\n" +
                        "**Example**: `DELETE http://localhost:8080/api/v1/notifications/1`")
        public ResponseEntity<ApiResponse<Void>> deleteNotification(
                        Authentication authentication,
                        @Parameter(description = "ID của thông báo") @PathVariable Long id) {

                UUID userId = authHelper.getCurrentUserId(authentication);
                notificationService.deleteNotification(userId, id);
                return ResponseEntity.ok(ApiResponse.success("Xóa thông báo thành công", null));
        }

        @DeleteMapping("/selected")
        @Operation(summary = "Xóa nhiều thông báo", description = "Xóa nhiều thông báo đã chọn\n\n" +
                        "**URL**: `DELETE http://localhost:8080/api/v1/notifications/selected`\n\n" +
                        "**Request Body**: [1, 2, 3]")
        public ResponseEntity<ApiResponse<Void>> deleteNotifications(
                        Authentication authentication,
                        @RequestBody List<Long> notificationIds) {

                UUID userId = authHelper.getCurrentUserId(authentication);
                notificationService.deleteNotifications(userId, notificationIds);
                return ResponseEntity.ok(ApiResponse.success("Xóa thông báo thành công", null));
        }
}
