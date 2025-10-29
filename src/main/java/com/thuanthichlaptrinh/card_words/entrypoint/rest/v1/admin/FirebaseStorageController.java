package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.admin;

import com.thuanthichlaptrinh.card_words.core.usecase.admin.FirebaseStorageService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.BulkUploadResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping(path = "/api/v1/storage")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
@SecurityRequirement(name = "Bearer Authentication")
@Tag(name = "Firebase Storage", description = "API upload file (image, audio) lên Firebase Storage")
public class FirebaseStorageController {

    private final FirebaseStorageService firebaseStorageService;

    @PostMapping(value = "/upload/image", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "Upload ảnh lên Firebase Storage", description = "Upload ảnh cho từ vựng. Hỗ trợ: jpg, png, gif, webp. Max size: 5MB", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<Map<String, String>>> uploadImage(
            @Parameter(description = "File ảnh cần upload") @RequestParam("file") MultipartFile file) {

        try {
            log.info("Uploading image: {}, size: {} bytes", file.getOriginalFilename(), file.getSize());

            String imageUrl = firebaseStorageService.uploadVocabImage(file);

            Map<String, String> response = new HashMap<>();
            response.put("url", imageUrl);
            response.put("filename", file.getOriginalFilename());
            response.put("size", String.valueOf(file.getSize()));

            return ResponseEntity.ok(ApiResponse.success(
                    "Upload ảnh thành công",
                    response));

        } catch (IllegalArgumentException e) {
            log.error("Invalid image file: {}", e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("400", e.getMessage()));
        } catch (IOException e) {
            log.error("Failed to upload image: {}", e.getMessage());
            return ResponseEntity.internalServerError().body(
                    ApiResponse.error("500", "Upload ảnh thất bại: " + e.getMessage()));
        }
    }

    @PostMapping(value = "/upload/audio", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "Upload audio lên Firebase Storage", description = "Upload audio phát âm cho từ vựng. Hỗ trợ: mp3, wav, ogg. Max size: 10MB", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<Map<String, String>>> uploadAudio(
            @Parameter(description = "File audio cần upload") @RequestParam("file") MultipartFile file) {

        try {
            log.info("Uploading audio: {}, size: {} bytes", file.getOriginalFilename(), file.getSize());

            String audioUrl = firebaseStorageService.uploadVocabAudio(file);

            Map<String, String> response = new HashMap<>();
            response.put("url", audioUrl);
            response.put("filename", file.getOriginalFilename());
            response.put("size", String.valueOf(file.getSize()));

            return ResponseEntity.ok(ApiResponse.success(
                    "Upload audio thành công",
                    response));

        } catch (IllegalArgumentException e) {
            log.error("Invalid audio file: {}", e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("400", e.getMessage()));
        } catch (IOException e) {
            log.error("Failed to upload audio: {}", e.getMessage());
            return ResponseEntity.internalServerError().body(
                    ApiResponse.error("500", "Upload audio thất bại: " + e.getMessage()));
        }
    }

    @DeleteMapping("/delete")
    @Operation(summary = "Xóa file trên Firebase Storage", description = "Xóa file dựa trên URL", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<Void>> deleteFile(
            @Parameter(description = "URL của file cần xóa") @RequestParam("url") String fileUrl) {

        try {
            firebaseStorageService.deleteFile(fileUrl);
            return ResponseEntity.ok(ApiResponse.success("Xóa file thành công", null));
        } catch (Exception e) {
            log.error("Failed to delete file: {}", e.getMessage());
            return ResponseEntity.internalServerError().body(
                    ApiResponse.error("500", "Xóa file thất bại: " + e.getMessage()));
        }
    }

    @PostMapping(value = "/upload/images/bulk", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "Upload nhiều ảnh cùng lúc", description = "Upload nhiều ảnh cho từ vựng trong một request. Upload song song để tăng tốc độ. Hỗ trợ: jpg, png, gif, webp. Max size mỗi ảnh: 5MB", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<BulkUploadResponse>> uploadMultipleImages(
            @Parameter(description = "Mảng các file ảnh cần upload") @RequestParam("files") MultipartFile[] files) {

        try {
            log.info("Starting bulk upload of {} images", files.length);

            BulkUploadResponse response = firebaseStorageService.uploadMultipleVocabImages(files);

            String message = String.format(
                    "Upload hoàn tất. Thành công: %d/%d, Thất bại: %d",
                    response.getSuccessCount(),
                    response.getTotalRequested(),
                    response.getFailedCount());

            return ResponseEntity.ok(ApiResponse.success(message, response));

        } catch (IllegalArgumentException e) {
            log.error("Invalid request: {}", e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("400", e.getMessage()));
        } catch (Exception e) {
            log.error("Failed to upload images: {}", e.getMessage());
            return ResponseEntity.internalServerError().body(
                    ApiResponse.error("500", "Upload ảnh thất bại: " + e.getMessage()));
        }
    }

    @PostMapping(value = "/upload/audios/bulk", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "Upload nhiều audio cùng lúc", description = "Upload nhiều file audio cho từ vựng trong một request. Upload song song để tăng tốc độ. Hỗ trợ: mp3, wav, ogg. Max size mỗi file: 10MB", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<BulkUploadResponse>> uploadMultipleAudios(
            @Parameter(description = "Mảng các file audio cần upload") @RequestParam("files") MultipartFile[] files) {

        try {
            log.info("Starting bulk upload of {} audio files", files.length);

            BulkUploadResponse response = firebaseStorageService.uploadMultipleVocabAudios(files);

            String message = String.format(
                    "Upload hoàn tất. Thành công: %d/%d, Thất bại: %d",
                    response.getSuccessCount(),
                    response.getTotalRequested(),
                    response.getFailedCount());

            return ResponseEntity.ok(ApiResponse.success(message, response));

        } catch (IllegalArgumentException e) {
            log.error("Invalid request: {}", e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("400", e.getMessage()));
        } catch (Exception e) {
            log.error("Failed to upload audios: {}", e.getMessage());
            return ResponseEntity.internalServerError().body(
                    ApiResponse.error("500", "Upload audio thất bại: " + e.getMessage()));
        }
    }

    @PostMapping(value = "/upload/media-and-update-vocab", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "Upload media và tự động cập nhật vocab", description = "Upload nhiều file (images + audios) và tự động cập nhật vào từ vựng tương ứng. "
            +
            "Tên file phải có format: [số].[tên_từ].[extension] (ví dụ: '2.bread.jpg', '3.milk.mp3'). " +
            "Hệ thống sẽ tự động extract tên từ, upload lên Firebase, và cập nhật vào database. " +
            "Hỗ trợ images (jpg, png, gif, webp, max 5MB) và audios (mp3, wav, ogg, max 10MB)", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<com.thuanthichlaptrinh.card_words.entrypoint.dto.response.BulkMediaUpdateResponse>> uploadMediaAndUpdateVocab(
            @Parameter(description = "Mảng các file media (images + audios) cần upload") @RequestParam("files") MultipartFile[] files) {

        try {
            log.info("Starting bulk media upload and vocab update for {} files", files.length);

            com.thuanthichlaptrinh.card_words.entrypoint.dto.response.BulkMediaUpdateResponse response = firebaseStorageService
                    .uploadMediaAndUpdateVocabs(files);

            String message = String.format(
                    "Xử lý hoàn tất. Thành công: %d/%d, Thất bại: %d, Bỏ qua: %d",
                    response.getSuccessCount(),
                    response.getTotalFiles(),
                    response.getFailedCount(),
                    response.getSkippedCount());

            return ResponseEntity.ok(ApiResponse.success(message, response));

        } catch (IllegalArgumentException e) {
            log.error("Invalid request: {}", e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("400", e.getMessage()));
        } catch (Exception e) {
            log.error("Failed to upload media and update vocab: {}", e.getMessage());
            return ResponseEntity.internalServerError().body(
                    ApiResponse.error("500", "Upload và cập nhật thất bại: " + e.getMessage()));
        }
    }
}
