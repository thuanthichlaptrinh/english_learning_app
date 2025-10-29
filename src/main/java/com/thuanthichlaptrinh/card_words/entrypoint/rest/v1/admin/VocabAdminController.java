package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.admin;

import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
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

import com.thuanthichlaptrinh.card_words.core.usecase.user.VocabService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.vocab.BulkCreateVocabRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.vocab.CreateVocabRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.vocab.UpdateVocabRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.BulkImportResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.vocab.VocabResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.parameters.RequestBody;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping(path = "/api/v1/admin/vocabs")
@RequiredArgsConstructor
@Tag(name = "Vocab Admin", description = "API quản lý từ vựng cho admin")
@PreAuthorize("hasRole('ADMIN')")
@SecurityRequirement(name = "Bearer Authentication")
public class VocabAdminController {
        private final VocabService vocabService;

        @GetMapping("/{id}")
        @Operation(summary = "[Admin] Lấy từ vựng theo ID", description = "Lấy thông tin chi tiết của một từ vựng theo ID.\n\n"
                        +
                        "**URL**: `GET http://localhost:8080/api/v1/admin/vocabs/{id}`\n\n" +
                        "**Example**: `GET http://localhost:8080/api/v1/admin/vocabs/123e4567-e89b-12d3-a456-426614174000`")
        public ResponseEntity<ApiResponse<VocabResponse>> getVocabById(
                        @Parameter(description = "ID của từ vựng") @PathVariable UUID id) {
                VocabResponse response = vocabService.getVocabById(id);
                return ResponseEntity.ok(ApiResponse.success("Lấy thông tin từ vựng thành công", response));
        }

        @GetMapping("/word/{word}")
        @Operation(summary = "[Admin] Lấy từ vựng theo từ", description = "Lấy thông tin chi tiết của một từ vựng theo từ khóa.\n\n"
                        +
                        "**URL**: `GET http://localhost:8080/api/v1/admin/vocabs/word/{word}`\n\n" +
                        "**Example**: `GET http://localhost:8080/api/v1/admin/vocabs/word/hello`")
        public ResponseEntity<ApiResponse<VocabResponse>> getVocabByWord(
                        @Parameter(description = "Từ vựng cần tìm") @PathVariable String word) {
                VocabResponse response = vocabService.getVocabByWord(word);
                return ResponseEntity.ok(ApiResponse.success("Lấy thông tin từ vựng thành công", response));
        }

        @GetMapping
        @Operation(summary = "[Admin] Lấy danh sách từ vựng", description = "Lấy danh sách tất cả từ vựng với phân trang.\n\n"
                        +
                        "**URL**: `GET http://localhost:8080/api/v1/admin/vocabs?page=0&size=20&sortBy=createdAt&sortDir=desc`")
        public ResponseEntity<ApiResponse<Page<VocabResponse>>> getAllVocabs(
                        @Parameter(description = "Số trang (bắt đầu từ 0)") @RequestParam(defaultValue = "0") int page,
                        @Parameter(description = "Kích thước trang") @RequestParam(defaultValue = "20") int size,
                        @Parameter(description = "Sắp xếp theo trường") @RequestParam(defaultValue = "createdAt") String sortBy,
                        @Parameter(description = "Hướng sắp xếp (asc/desc)") @RequestParam(defaultValue = "desc") String sortDir) {

                Sort sort = sortDir.equalsIgnoreCase("desc") ? Sort.by(sortBy).descending()
                                : Sort.by(sortBy).ascending();
                Pageable pageable = PageRequest.of(page, size, sort);

                Page<VocabResponse> response = vocabService.getAllVocabs(pageable);
                return ResponseEntity.ok(ApiResponse.success("Lấy danh sách từ vựng thành công", response));
        }

        @GetMapping("/search")
        @Operation(summary = "[Admin] Tìm kiếm từ vựng", description = "Tìm kiếm từ vựng theo từ khóa trong từ hoặc nghĩa.\n\n"
                        +
                        "**URL**: `GET http://localhost:8080/api/v1/admin/vocabs/search?keyword={keyword}&page=0&size=20`\n\n"
                        +
                        "**Example**: `GET http://localhost:8080/api/v1/admin/vocabs/search?keyword=hello&page=0&size=20`")
        public ResponseEntity<ApiResponse<Page<VocabResponse>>> searchVocabs(
                        @Parameter(description = "Từ khóa tìm kiếm") @RequestParam String keyword,
                        @Parameter(description = "Số trang (bắt đầu từ 0)") @RequestParam(defaultValue = "0") int page,
                        @Parameter(description = "Kích thước trang") @RequestParam(defaultValue = "20") int size) {

                Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
                Page<VocabResponse> response = vocabService.searchVocabs(keyword, pageable);
                return ResponseEntity.ok(ApiResponse.success("Tìm kiếm từ vựng thành công", response));
        }

        @GetMapping("/cefr/{cefr}")
        @Operation(summary = "[Admin] Lấy từ vựng theo CEFR", description = "Lấy danh sách từ vựng theo mức độ CEFR.\n\n"
                        +
                        "**URL**: `GET http://localhost:8080/api/v1/admin/vocabs/cefr/{cefr}?page=0&size=20`\n\n" +
                        "**Example**: `GET http://localhost:8080/api/v1/admin/vocabs/cefr/B1?page=0&size=20`")
        public ResponseEntity<ApiResponse<Page<VocabResponse>>> getVocabsByCefr(
                        @Parameter(description = "Mức CEFR (A1, A2, B1, B2, C1, C2)") @PathVariable String cefr,
                        @Parameter(description = "Số trang (bắt đầu từ 0)") @RequestParam(defaultValue = "0") int page,
                        @Parameter(description = "Kích thước trang") @RequestParam(defaultValue = "20") int size) {

                Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
                Page<VocabResponse> response = vocabService.getVocabsByCefr(cefr, pageable);
                return ResponseEntity.ok(ApiResponse.success("Lấy từ vựng theo CEFR thành công", response));
        }

        @PostMapping
        @Operation(summary = "Thêm từ vựng mới", description = "Tạo một từ vựng mới trong hệ thống.", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<VocabResponse>> createVocab(
                        @Valid @RequestBody CreateVocabRequest request) {
                VocabResponse response = vocabService.createVocab(request);
                return ResponseEntity.status(HttpStatus.CREATED)
                                .body(ApiResponse.success("Thêm từ vựng thành công", response));
        }

        @PostMapping("/bulk-import")
        @Operation(summary = "Thêm hàng loạt từ vựng", description = "Thêm nhiều từ vựng cùng lúc vào hệ thống.", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<BulkImportResponse>> bulkImportVocabs(
                        @Valid @RequestBody BulkCreateVocabRequest request) {
                BulkImportResponse response = vocabService.bulkCreateVocabs(request);

                String message = String.format(
                                "Thêm hoàn tất. Thành công: %d, Thất bại: %d, Bỏ qua: %d",
                                response.getSuccessCount(),
                                response.getFailedCount(),
                                response.getSkippedCount());

                return ResponseEntity.status(HttpStatus.CREATED)
                                .body(ApiResponse.success(message, response));
        }

        @DeleteMapping("/{id}")
        @Operation(summary = "Xóa từ vựng", description = "Xóa một từ vựng khỏi hệ thống.", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<Void>> deleteVocab(
                        @Parameter(description = "ID của từ vựng cần xóa") @PathVariable UUID id) {
                vocabService.deleteVocab(id);
                return ResponseEntity.ok(ApiResponse.success("Xóa từ vựng thành công", null));
        }

        @PutMapping("/{id}")
        @Operation(summary = "Cập nhật từ vựng theo ID", description = "Cập nhật thông tin của một từ vựng theo ID, bao gồm img và audio URLs.", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<VocabResponse>> updateVocab(
                        @Parameter(description = "ID của từ vựng cần cập nhật") @PathVariable UUID id,
                        @Valid @RequestBody UpdateVocabRequest request) {
                VocabResponse response = vocabService.updateVocab(id, request);
                return ResponseEntity.ok(ApiResponse.success("Cập nhật từ vựng thành công", response));
        }

        @PutMapping("/word/{word}")
        @Operation(summary = "Cập nhật từ vựng theo tên từ", description = "Cập nhật thông tin của một từ vựng theo tên từ, bao gồm img và audio URLs. Chỉ cập nhật các field có giá trị.", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<VocabResponse>> updateVocabByWord(
                        @Parameter(description = "Tên từ vựng cần cập nhật") @PathVariable String word,
                        @Valid @RequestBody UpdateVocabRequest request) {
                VocabResponse response = vocabService.updateVocabByWord(word, request);
                return ResponseEntity.ok(ApiResponse.success("Cập nhật từ vựng thành công", response));
        }
}
