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

@RestController
@RequestMapping(path = "/api/v1/admin/notifications")
@RequiredArgsConstructor
@Tag(name = "Notifications Admin", description = "API quản lý thông báo cho admin")
@PreAuthorize("hasRole('ROLE_ADMIN')")
@SecurityRequirement(name = "Bearer Authentication")
public class NotificationAdminController {

    private final NotificationService notificationService;

    @PostMapping
    @Operation(summary = "[Admin] Tạo thông báo cho một user", description = "Tạo thông báo mới cho một user cụ thể\n\n" +
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
    @Operation(summary = "[Admin] Tạo thông báo cho tất cả users", description = "Tạo thông báo cho tất cả users trong hệ thống\n\n" +
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
}
