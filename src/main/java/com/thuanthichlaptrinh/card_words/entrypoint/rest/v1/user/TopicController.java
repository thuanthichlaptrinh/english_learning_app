package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import java.util.List;
import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.usecase.user.TopicService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.TopicResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping(path = "/api/v1/topics")
@RequiredArgsConstructor
@Tag(name = "Topic", description = "API quản lý chủ đề")
public class TopicController {

    private final TopicService topicService;

    @GetMapping
    @Operation(summary = "Lấy danh sách chủ đề", description = "Lấy danh sách tất cả chủ đề kèm theo tiến độ học (nếu đã đăng nhập)", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<List<TopicResponse>>> getAllTopics(Authentication authentication) {
        UUID userId = getUserIdFromAuth(authentication);
        List<TopicResponse> response = topicService.getAllTopics(userId);
        return ResponseEntity.ok(ApiResponse.success("Lấy danh sách chủ đề thành công", response));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Lấy thông tin chủ đề", description = "Lấy thông tin chi tiết một chủ đề theo ID kèm theo tiến độ học (nếu đã đăng nhập)", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<TopicResponse>> getTopicById(
            @PathVariable Long id,
            Authentication authentication) {
        UUID userId = getUserIdFromAuth(authentication);
        TopicResponse response = topicService.getTopicById(id, userId);
        return ResponseEntity.ok(ApiResponse.success("Lấy thông tin chủ đề thành công", response));
    }

    // ========== Helper Methods ==========

    /**
     * Lấy userId từ Authentication (giống OfflineSyncController)
     * Trả về null nếu user chưa đăng nhập
     */
    private UUID getUserIdFromAuth(Authentication authentication) {
        if (authentication != null && authentication.getPrincipal() instanceof UserDetails) {
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            if (userDetails instanceof User) {
                return ((User) userDetails).getId();
            }
        }
        return null; // Trả về null nếu không lấy được userId
    }

}