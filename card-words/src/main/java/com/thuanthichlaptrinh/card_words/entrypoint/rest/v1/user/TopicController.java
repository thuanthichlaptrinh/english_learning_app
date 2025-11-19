package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import java.util.List;
import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import com.thuanthichlaptrinh.card_words.common.helper.AuthenticationHelper;
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
    private final AuthenticationHelper authHelper;

    @GetMapping
    @Operation(summary = "Lấy danh sách chủ đề", description = "Lấy danh sách tất cả chủ đề kèm theo tiến độ học (nếu đã đăng nhập)", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<List<TopicResponse>>> getAllTopics(Authentication authentication) {
        UUID userId = authHelper.getCurrentUserId(authentication);
        List<TopicResponse> response = topicService.getAllTopics(userId);
        return ResponseEntity.ok(ApiResponse.success("Lấy danh sách chủ đề thành công", response));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Lấy thông tin chủ đề", description = "Lấy thông tin chi tiết một chủ đề theo ID kèm theo tiến độ học (nếu đã đăng nhập)", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<TopicResponse>> getTopicById(
            @PathVariable Long id,
            Authentication authentication) {
        UUID userId = authHelper.getCurrentUserId(authentication);
        TopicResponse response = topicService.getTopicById(id, userId);
        return ResponseEntity.ok(ApiResponse.success("Lấy thông tin chủ đề thành công", response));
    }

}