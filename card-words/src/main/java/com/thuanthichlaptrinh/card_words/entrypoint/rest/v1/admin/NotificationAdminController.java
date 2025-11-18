package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.admin;

import com.thuanthichlaptrinh.card_words.core.usecase.user.NotificationService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.NotificationResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
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
            "**URL**: `DELETE http://localhost:8080/api/v1/admin/notifications/{userId}/{notificationId}`\n\n" +
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
