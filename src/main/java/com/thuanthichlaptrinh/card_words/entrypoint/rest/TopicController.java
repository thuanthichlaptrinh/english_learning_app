package com.thuanthichlaptrinh.card_words.entrypoint.rest;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.thuanthichlaptrinh.card_words.core.usecase.TopicService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateTopicRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.TopicResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping(path = "/api/v1/topics")
@RequiredArgsConstructor
@Tag(name = "Topic", description = "API quản lý chủ đề")
public class TopicController {

    private final TopicService topicService;

    @PostMapping
    @Operation(summary = "Tạo chủ đề mới", description = "Tạo một chủ đề mới (Business, Travel, Food...)", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<TopicResponse>> createTopic(@Valid @RequestBody CreateTopicRequest request) {
        TopicResponse response = topicService.createTopic(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Tạo chủ đề thành công", response));
    }

    @GetMapping
    @Operation(summary = "Lấy danh sách chủ đề", description = "Lấy danh sách tất cả chủ đề")
    public ResponseEntity<ApiResponse<List<TopicResponse>>> getAllTopics() {
        List<TopicResponse> response = topicService.getAllTopics();
        return ResponseEntity.ok(ApiResponse.success("Lấy danh sách chủ đề thành công", response));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Lấy thông tin chủ đề", description = "Lấy thông tin chi tiết một chủ đề theo ID")
    public ResponseEntity<ApiResponse<TopicResponse>> getTopicById(@PathVariable Long id) {
        TopicResponse response = topicService.getTopicById(id);
        return ResponseEntity.ok(ApiResponse.success("Lấy thông tin chủ đề thành công", response));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Xóa chủ đề", description = "Xóa một chủ đề theo ID", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<Void>> deleteTopic(@PathVariable Long id) {
        topicService.deleteTopic(id);
        return ResponseEntity.ok(ApiResponse.success("Xóa chủ đề thành công", null));
    }
}