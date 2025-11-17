package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.admin;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.thuanthichlaptrinh.card_words.core.usecase.admin.TopicService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.BulkCreateTopicsRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.BulkUpdateTopicsRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateTopicRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.UpdateTopicRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.BulkTopicOperationResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.TopicResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping(path = "/api/v1/admin/topics")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ROLE_ADMIN')")
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
        @Operation(summary = "[Admin] Lấy thông tin chủ đề", description = "Lấy thông tin chi tiết một chủ đề theo ID\n\n"
                        +
                        "**URL**: `GET http://localhost:8080/api/v1/admin/topics/{id}`\n\n" +
                        "**Example**: `GET http://localhost:8080/api/v1/admin/topics/1`")
        public ResponseEntity<ApiResponse<TopicResponse>> getTopicById(@PathVariable Long id) {
                TopicResponse response = topicService.getTopicById(id);
                return ResponseEntity.ok(ApiResponse.success("Lấy thông tin chủ đề thành công", response));
        }

        @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
        @Operation(summary = "[Admin] Tạo chủ đề mới", description = "Tạo một chủ đề mới với hình ảnh (tùy chọn). Hình ảnh sẽ được upload lên Firebase Storage.\n\n"
                        +
                        "**URL**: `POST http://localhost:8080/api/v1/admin/topics`\n\n" +
                        "**Content-Type**: `multipart/form-data`\n\n" +
                        "**Form Data**:\n" +
                        "- `name` (required): Tên chủ đề (1-100 ký tự)\n" +
                        "- `description` (optional): Mô tả chủ đề (tối đa 500 ký tự)\n" +
                        "- `image` (optional): File hình ảnh (jpg, jpeg, png, gif, webp)", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<TopicResponse>> createTopic(
                        @Parameter(description = "Tên chủ đề (bắt buộc, 1-100 ký tự)") @RequestParam("name") String name,

                        @Parameter(description = "Mô tả chủ đề (tùy chọn, tối đa 500 ký tự)") @RequestParam(value = "description", required = false) String description,

                        @Parameter(description = "File hình ảnh (tùy chọn, định dạng: jpg, jpeg, png, gif, webp)") @RequestParam(value = "image", required = false) MultipartFile image) {

                log.info("Admin creating topic: {}", name);

                CreateTopicRequest request = CreateTopicRequest.builder()
                                .name(name)
                                .description(description)
                                .build();

                TopicResponse response = topicService.createTopic(request, image);
                return ResponseEntity.status(HttpStatus.CREATED)
                                .body(ApiResponse.success("Tạo chủ đề thành công", response));
        }

        @PutMapping(value = "/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
        @Operation(summary = "[Admin] Cập nhật chủ đề", description = "Cập nhật thông tin chủ đề (tên, mô tả, hình ảnh). Nếu upload hình mới, hình cũ sẽ bị xóa khỏi Firebase.\n\n"
                        +
                        "**URL**: `PUT http://localhost:8080/api/v1/admin/topics/{id}`\n\n" +
                        "**Content-Type**: `multipart/form-data`\n\n" +
                        "**Form Data**:\n" +
                        "- `name` (optional): Tên chủ đề mới (1-100 ký tự)\n" +
                        "- `description` (optional): Mô tả mới (tối đa 500 ký tự)\n" +
                        "- `image` (optional): File hình ảnh mới", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<TopicResponse>> updateTopic(
                        @Parameter(description = "ID của chủ đề cần cập nhật") @PathVariable Long id,

                        @Parameter(description = "Tên chủ đề mới (tùy chọn, 1-100 ký tự)") @RequestParam(value = "name", required = false) String name,

                        @Parameter(description = "Mô tả mới (tùy chọn, tối đa 500 ký tự)") @RequestParam(value = "description", required = false) String description,

                        @Parameter(description = "File hình ảnh mới (tùy chọn)") @RequestParam(value = "image", required = false) MultipartFile image) {

                log.info("Admin updating topic ID: {}", id);

                UpdateTopicRequest request = UpdateTopicRequest.builder()
                                .name(name)
                                .description(description)
                                .build();

                TopicResponse response = topicService.updateTopic(id, request, image);
                return ResponseEntity.ok(ApiResponse.success("Cập nhật chủ đề thành công", response));
        }

        @DeleteMapping("/{id}")
        @Operation(summary = "[Admin] Xóa chủ đề", description = "Xóa một chủ đề theo ID. Hình ảnh trên Firebase cũng sẽ bị xóa.\n\n"
                        +
                        "**URL**: `DELETE http://localhost:8080/api/v1/admin/topics/{id}`\n\n" +
                        "**Example**: `DELETE http://localhost:8080/api/v1/admin/topics/1`", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<Void>> deleteTopic(
                        @Parameter(description = "ID của chủ đề cần xóa") @PathVariable Long id) {
                log.info("Admin deleting topic ID: {}", id);
                topicService.deleteTopic(id);
                return ResponseEntity.ok(ApiResponse.success("Xóa chủ đề thành công", null));
        }

        @PostMapping("/bulk-create")
        @Operation(summary = "[Admin] Tạo nhiều chủ đề cùng lúc", description = "Tạo nhiều chủ đề trong một request. Trả về danh sách kết quả cho từng topic.\n\n"
                        +
                        "**URL**: `POST http://localhost:8080/api/v1/admin/topics/bulk-create`\n\n" +
                        "**Body**: ```json\n" +
                        "{\n" +
                        "  \"topics\": [\n" +
                        "    {\n" +
                        "      \"name\": \"Business\",\n" +
                        "      \"description\": \"Chủ đề kinh doanh\",\n" +
                        "      \"imageUrl\": \"https://firebase.../business.jpg\"\n" +
                        "    },\n" +
                        "    {\n" +
                        "      \"name\": \"Travel\",\n" +
                        "      \"description\": \"Chủ đề du lịch\",\n" +
                        "      \"imageUrl\": \"https://firebase.../travel.jpg\"\n" +
                        "    }\n" +
                        "  ]\n" +
                        "}```", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<BulkTopicOperationResponse>> bulkCreateTopics(
                        @Valid @org.springframework.web.bind.annotation.RequestBody BulkCreateTopicsRequest request) {
                log.info("Admin bulk creating {} topics", request.getTopics().size());
                BulkTopicOperationResponse response = topicService.bulkCreateTopics(request);
                return ResponseEntity.ok(ApiResponse.success(
                                String.format("Hoàn thành: %d thành công, %d thất bại",
                                                response.getSuccessCount(), response.getFailureCount()),
                                response));
        }

        @PutMapping("/bulk-update")
        @Operation(summary = "[Admin] Cập nhật nhiều chủ đề cùng lúc", description = "Cập nhật nhiều chủ đề trong một request. Chỉ cập nhật các field được cung cấp.\n\n"
                        +
                        "**URL**: `PUT http://localhost:8080/api/v1/admin/topics/bulk-update`\n\n" +
                        "**Body**: ```json\n" +
                        "{\n" +
                        "  \"topics\": [\n" +
                        "    {\n" +
                        "      \"id\": 1,\n" +
                        "      \"name\": \"Business Updated\",\n" +
                        "      \"description\": \"Mô tả mới\"\n" +
                        "    },\n" +
                        "    {\n" +
                        "      \"id\": 2,\n" +
                        "      \"imageUrl\": \"https://firebase.../new-image.jpg\"\n" +
                        "    }\n" +
                        "  ]\n" +
                        "}```\n\n" +
                        "**Note**: Các field không cung cấp sẽ giữ nguyên giá trị cũ.", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<BulkTopicOperationResponse>> bulkUpdateTopics(
                        @Valid @org.springframework.web.bind.annotation.RequestBody BulkUpdateTopicsRequest request) {
                log.info("Admin bulk updating {} topics", request.getTopics().size());
                BulkTopicOperationResponse response = topicService.bulkUpdateTopics(request);
                return ResponseEntity.ok(ApiResponse.success(
                                String.format("Hoàn thành: %d thành công, %d thất bại",
                                                response.getSuccessCount(), response.getFailureCount()),
                                response));
        }
}
