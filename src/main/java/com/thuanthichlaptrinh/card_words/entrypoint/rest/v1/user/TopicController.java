package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.thuanthichlaptrinh.card_words.core.usecase.user.TopicService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.TopicResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping(path = "/api/v1/topics")
@RequiredArgsConstructor
@Tag(name = "Topic", description = "API quản lý chủ đề")
public class TopicController {

    private final TopicService topicService;

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

}