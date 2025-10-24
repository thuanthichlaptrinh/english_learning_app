package com.thuanthichlaptrinh.card_words.entrypoint.rest.admin;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.thuanthichlaptrinh.card_words.core.usecase.user.TopicService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateTopicRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.TopicResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.parameters.RequestBody;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping(path = "/api/v1/admin/topics")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
@SecurityRequirement(name = "Bearer Authentication")
@Tag(name = "Topic Admin", description = "API quản lý chủ đề cho admin")
public class TopicAdminController {
    private final TopicService topicService;

    @GetMapping
    @Operation(summary = "[Admin] Lấy danh sách chủ đề", description = "Lấy danh sách tất cả chủ đề\n\n" +
            "**URL**: `GET http://localhost:8080/api/v1/admin/topics`")
    public ResponseEntity<ApiResponse<List<TopicResponse>>> getAllTopics() {
        List<TopicResponse> response = topicService.getAllTopics();
        return ResponseEntity.ok(ApiResponse.success("Lấy danh sách chủ đề thành công", response));
    }

    @GetMapping("/{id}")
    @Operation(summary = "[Admin] Lấy thông tin chủ đề", description = "Lấy thông tin chi tiết một chủ đề theo ID\n\n" +
            "**URL**: `GET http://localhost:8080/api/v1/admin/topics/{id}`\n\n" +
            "**Example**: `GET http://localhost:8080/api/v1/admin/topics/1`")
    public ResponseEntity<ApiResponse<TopicResponse>> getTopicById(@PathVariable Long id) {
        TopicResponse response = topicService.getTopicById(id);
        return ResponseEntity.ok(ApiResponse.success("Lấy thông tin chủ đề thành công", response));
    }

    @PostMapping
    @Operation(summary = "[Admin] Tạo chủ đề mới", description = "Tạo một chủ đề mới (Business, Travel, Food...)\n\n" +
            "**URL**: `POST http://localhost:8080/api/v1/admin/topics`\n\n" +
            "**Body**: `{\"name\": \"Business\", \"description\": \"Chủ đề kinh doanh\"}`", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<TopicResponse>> createTopic(@Valid @RequestBody CreateTopicRequest request) {
        TopicResponse response = topicService.createTopic(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Tạo chủ đề thành công", response));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "[Admin] Xóa chủ đề", description = "Xóa một chủ đề theo ID\n\n" +
            "**URL**: `DELETE http://localhost:8080/api/v1/admin/topics/{id}`\n\n" +
            "**Example**: `DELETE http://localhost:8080/api/v1/admin/topics/1`", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<Void>> deleteTopic(@PathVariable Long id) {
        topicService.deleteTopic(id);
        return ResponseEntity.ok(ApiResponse.success("Xóa chủ đề thành công", null));
    }
}
