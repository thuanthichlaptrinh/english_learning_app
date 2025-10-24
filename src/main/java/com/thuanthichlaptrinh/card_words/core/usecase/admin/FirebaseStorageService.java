package com.thuanthichlaptrinh.card_words.core.usecase.admin;

import com.google.cloud.storage.Blob;
import com.google.cloud.storage.Bucket;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.BulkUploadResponse;
import com.thuanthichlaptrinh.card_words.core.usecase.user.VocabService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.BulkMediaUpdateResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Slf4j
@Service
@RequiredArgsConstructor
public class FirebaseStorageService {

    private final Bucket bucket;
    private final VocabService vocabService;

    @Value("${firebase.storage.bucket-name}")
    private String bucketName;

    /**
     * Upload file to Firebase Storage
     * 
     * @param file   MultipartFile to upload
     * @param folder Folder path (e.g., "vocab/images", "vocab/audios")
     * @return Public download URL
     */
    public String uploadFile(MultipartFile file, String folder) throws IOException {
        if (bucket == null) {
            throw new IllegalStateException("Firebase storage bucket is not configured or could not be resolved. " +
                    "Check FIREBASE_STORAGE_BUCKET in your configuration and ensure the service account has access.");
        }

        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("File is empty or null");
        }

        // Generate unique filename
        String originalFilename = file.getOriginalFilename();
        String extension = getFileExtension(originalFilename);
        String fileName = folder + "/" + UUID.randomUUID().toString() + extension;

        log.info("Uploading file: {} to Firebase Storage", fileName);

        // Upload file
        Blob blob = bucket.create(fileName, file.getBytes(), file.getContentType());

        // Make file publicly accessible
        blob.createAcl(com.google.cloud.storage.Acl.of(
                com.google.cloud.storage.Acl.User.ofAllUsers(),
                com.google.cloud.storage.Acl.Role.READER));

        // Generate public URL
        String publicUrl = String.format(
                "https://firebasestorage.googleapis.com/v0/b/%s/o/%s?alt=media",
                bucketName,
                fileName.replace("/", "%2F"));

        log.info("File uploaded successfully: {}", publicUrl);
        return publicUrl;
    }

    // Upload vocabulary image
    public String uploadVocabImage(MultipartFile file) throws IOException {
        validateImageFile(file);
        return uploadFile(file, "vocab/images");
    }

    // Upload vocabulary audio
    public String uploadVocabAudio(MultipartFile file) throws IOException {
        validateAudioFile(file);
        return uploadFile(file, "vocab/audios");
    }

    // Upload user avatar
    public String uploadUserAvatar(MultipartFile file) throws IOException {
        validateImageFile(file);
        return uploadFile(file, "users/avatars");
    }

    /**
     * Upload multiple images in parallel
     * 
     * @param files  Array of image files to upload
     * @param folder Folder path (e.g., "vocab/images")
     * @return BulkUploadResponse with results and errors
     */
    public BulkUploadResponse uploadMultipleImages(MultipartFile[] files, String folder) {
        if (bucket == null) {
            throw new IllegalStateException("Firebase storage bucket is not configured or could not be resolved. " +
                    "Check FIREBASE_STORAGE_BUCKET in your configuration and ensure the service account has access.");
        }

        if (files == null || files.length == 0) {
            throw new IllegalArgumentException("No files provided");
        }

        log.info("Starting bulk upload of {} images", files.length);

        int successCount = 0;
        int failedCount = 0;
        List<BulkUploadResponse.UploadResult> results = new ArrayList<>();
        List<BulkUploadResponse.UploadError> errors = new ArrayList<>();

        // Create a thread pool for parallel uploads (max 5 concurrent uploads)
        ExecutorService executor = Executors.newFixedThreadPool(Math.min(5, files.length));

        try {
            // Create list of CompletableFutures for parallel processing
            List<CompletableFuture<Void>> futures = new ArrayList<>();

            for (int i = 0; i < files.length; i++) {
                final int index = i;
                final MultipartFile file = files[i];

                CompletableFuture<Void> future = CompletableFuture.runAsync(() -> {
                    try {
                        // Validate image file
                        validateImageFile(file);

                        // Generate unique filename
                        String originalFilename = file.getOriginalFilename();
                        String extension = getFileExtension(originalFilename);
                        String fileName = folder + "/" + UUID.randomUUID().toString() + extension;

                        log.debug("Uploading file {}: {} to Firebase Storage", index + 1, fileName);

                        // Upload file
                        Blob blob = bucket.create(fileName, file.getBytes(), file.getContentType());

                        // Make file publicly accessible
                        blob.createAcl(com.google.cloud.storage.Acl.of(
                                com.google.cloud.storage.Acl.User.ofAllUsers(),
                                com.google.cloud.storage.Acl.Role.READER));

                        // Generate public URL
                        String publicUrl = String.format(
                                "https://firebasestorage.googleapis.com/v0/b/%s/o/%s?alt=media",
                                bucketName,
                                fileName.replace("/", "%2F"));

                        synchronized (results) {
                            results.add(BulkUploadResponse.UploadResult.builder()
                                    .originalFilename(originalFilename)
                                    .url(publicUrl)
                                    .fileSize(file.getSize())
                                    .contentType(file.getContentType())
                                    .build());
                        }

                        log.debug("File {} uploaded successfully: {}", index + 1, publicUrl);

                    } catch (Exception e) {
                        synchronized (errors) {
                            errors.add(BulkUploadResponse.UploadError.builder()
                                    .filename(file.getOriginalFilename())
                                    .reason(e.getMessage())
                                    .index(index)
                                    .build());
                        }
                        log.error("Failed to upload file {}: {}", index + 1, e.getMessage());
                    }
                }, executor);

                futures.add(future);
            }

            // Wait for all uploads to complete
            CompletableFuture.allOf(futures.toArray(new CompletableFuture[0])).join();

            successCount = results.size();
            failedCount = errors.size();

            log.info("Bulk upload completed. Success: {}, Failed: {}", successCount, failedCount);

        } finally {
            executor.shutdown();
        }

        return BulkUploadResponse.builder()
                .totalRequested(files.length)
                .successCount(successCount)
                .failedCount(failedCount)
                .results(results)
                .errors(errors)
                .build();
    }

    // Upload vocabulary images
    public BulkUploadResponse uploadMultipleVocabImages(MultipartFile[] files) {
        return uploadMultipleImages(files, "vocab/images");
    }

    // Upload multiple audio files in parallel
    public BulkUploadResponse uploadMultipleAudios(MultipartFile[] files, String folder) {
        if (bucket == null) {
            throw new IllegalStateException("Firebase storage bucket is not configured or could not be resolved. " +
                    "Check FIREBASE_STORAGE_BUCKET in your configuration and ensure the service account has access.");
        }

        if (files == null || files.length == 0) {
            throw new IllegalArgumentException("No files provided");
        }

        log.info("Starting bulk upload of {} audio files", files.length);

        int successCount = 0;
        int failedCount = 0;
        List<BulkUploadResponse.UploadResult> results = new ArrayList<>();
        List<BulkUploadResponse.UploadError> errors = new ArrayList<>();

        // Create a thread pool for parallel uploads
        ExecutorService executor = Executors.newFixedThreadPool(Math.min(5, files.length));

        try {
            List<CompletableFuture<Void>> futures = new ArrayList<>();

            for (int i = 0; i < files.length; i++) {
                final int index = i;
                final MultipartFile file = files[i];

                CompletableFuture<Void> future = CompletableFuture.runAsync(() -> {
                    try {
                        // Validate audio file
                        validateAudioFile(file);

                        // Generate unique filename
                        String originalFilename = file.getOriginalFilename();
                        String extension = getFileExtension(originalFilename);
                        String fileName = folder + "/" + UUID.randomUUID().toString() + extension;

                        log.debug("Uploading audio {}: {} to Firebase Storage", index + 1, fileName);

                        // Upload file
                        Blob blob = bucket.create(fileName, file.getBytes(), file.getContentType());

                        // Make file publicly accessible
                        blob.createAcl(com.google.cloud.storage.Acl.of(
                                com.google.cloud.storage.Acl.User.ofAllUsers(),
                                com.google.cloud.storage.Acl.Role.READER));

                        // Generate public URL
                        String publicUrl = String.format(
                                "https://firebasestorage.googleapis.com/v0/b/%s/o/%s?alt=media",
                                bucketName,
                                fileName.replace("/", "%2F"));

                        synchronized (results) {
                            results.add(BulkUploadResponse.UploadResult.builder()
                                    .originalFilename(originalFilename)
                                    .url(publicUrl)
                                    .fileSize(file.getSize())
                                    .contentType(file.getContentType())
                                    .build());
                        }

                        log.debug("Audio {} uploaded successfully: {}", index + 1, publicUrl);

                    } catch (Exception e) {
                        synchronized (errors) {
                            errors.add(BulkUploadResponse.UploadError.builder()
                                    .filename(file.getOriginalFilename())
                                    .reason(e.getMessage())
                                    .index(index)
                                    .build());
                        }
                        log.error("Failed to upload audio {}: {}", index + 1, e.getMessage());
                    }
                }, executor);

                futures.add(future);
            }

            // Wait for all uploads to complete
            CompletableFuture.allOf(futures.toArray(new CompletableFuture[0])).join();

            successCount = results.size();
            failedCount = errors.size();

            log.info("Bulk audio upload completed. Success: {}, Failed: {}", successCount, failedCount);

        } finally {
            executor.shutdown();
        }

        return BulkUploadResponse.builder()
                .totalRequested(files.length)
                .successCount(successCount)
                .failedCount(failedCount)
                .results(results)
                .errors(errors)
                .build();
    }

    // Upload multiple vocabulary audios
    public BulkUploadResponse uploadMultipleVocabAudios(MultipartFile[] files) {
        return uploadMultipleAudios(files, "vocab/audios");
    }

    // Delete file from Firebase Storage
    public void deleteFile(String fileUrl) {
        if (bucket == null) {
            throw new IllegalStateException("Firebase storage bucket is not configured or could not be resolved. " +
                    "Check FIREBASE_STORAGE_BUCKET in your configuration and ensure the service account has access.");
        }
        try {
            // Extract filename from URL
            String fileName = extractFileNameFromUrl(fileUrl);

            if (fileName != null) {
                Blob blob = bucket.get(fileName);
                if (blob != null) {
                    blob.delete();
                    log.info("File deleted successfully: {}", fileName);
                } else {
                    log.warn("File not found: {}", fileName);
                }
            }
        } catch (Exception e) {
            log.error("Failed to delete file: {}", e.getMessage());
        }
    }

    // Extract filename from Firebase Storage URL
    private String extractFileNameFromUrl(String url) {
        if (url == null || !url.contains("%2F")) {
            return null;
        }

        try {
            // URL format:
            // https://firebasestorage.googleapis.com/v0/b/bucket/o/folder%2Ffile.ext?alt=media
            String[] parts = url.split("/o/");
            if (parts.length > 1) {
                String encodedPath = parts[1].split("\\?")[0];
                return encodedPath.replace("%2F", "/");
            }
        } catch (Exception e) {
            log.error("Failed to extract filename from URL: {}", e.getMessage());
        }
        return null;
    }

    // Get file extension
    private String getFileExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            return "";
        }
        return filename.substring(filename.lastIndexOf("."));
    }

    //
    private void validateImageFile(MultipartFile file) {
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new IllegalArgumentException("File must be an image (jpg, png, gif, webp)");
        }

        // Check file size (max 5MB)
        if (file.getSize() > 5 * 1024 * 1024) {
            throw new IllegalArgumentException("Image size must not exceed 5MB");
        }
    }

    // Xác thực tập tin âm thanh
    private void validateAudioFile(MultipartFile file) {
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("audio/")) {
            throw new IllegalArgumentException("File must be an audio (mp3, wav, ogg)");
        }

        if (file.getSize() > 10 * 1024 * 1024) {
            throw new IllegalArgumentException("Audio size must not exceed 10MB");
        }
    }

    /**
     * Extract word from filename
     * 
     * Hỗ trợ 2 format:
     * - Format 1: [word].[extension] → trả về "word" (e.g., "bread.jpg" → "bread")
     * - Format 2: [number].[word].[extension] → trả về "word" (e.g., "2.bread.jpg"
     * → "bread")
     * 
     * @param filename Tên file cần extract
     * @return Tên từ vựng (lowercase, trimmed) hoặc null nếu không extract được
     */
    public String extractWordFromFilename(String filename) {
        if (filename == null || filename.isEmpty()) {
            return null;
        }

        try {
            // Remove extension (phần sau dấu chấm cuối cùng)
            String nameWithoutExt = filename;
            int lastDotIndex = filename.lastIndexOf('.');
            if (lastDotIndex > 0) {
                nameWithoutExt = filename.substring(0, lastDotIndex);
            }

            // Check if there's a number prefix (Format 2: [number].[word])
            int firstDotIndex = nameWithoutExt.indexOf('.');
            if (firstDotIndex > 0) {
                // Format 2: Lấy phần sau dấu chấm đầu tiên
                String word = nameWithoutExt.substring(firstDotIndex + 1);
                return word.trim().toLowerCase();
            }

            // Format 1: Lấy toàn bộ tên (không có số prefix)
            return nameWithoutExt.trim().toLowerCase();
        } catch (Exception e) {
            log.error("Failed to extract word from filename '{}': {}", filename, e.getMessage());
            return null;
        }
    }

    // Xác định xem tệp là hình ảnh hay âm thanh dựa trên loại nội dung
    public String determineMediaType(String contentType) {
        if (contentType == null) {
            return "unknown";
        }
        if (contentType.startsWith("image/")) {
            return "image";
        }
        if (contentType.startsWith("audio/")) {
            return "audio";
        }
        return "unknown";
    }

    /**
     * Upload multiple media files (images + audios) and automatically update
     * corresponding vocabs
     * 
     * Filename format (hỗ trợ cả 2 format):
     * - Format 1: [word].[extension] (e.g., "bread.jpg", "milk.mp3")
     * - Format 2: [number].[word].[extension] (e.g., "2.bread.jpg", "3.milk.mp3")
     * 
     * Process:
     * 1. Extract word name from filename
     * 2. Upload file to Firebase Storage
     * 3. Update vocab with new URL (if word exists in database)
     * 
     * @param files Array of image and audio files
     * @return BulkMediaUpdateResponse with detailed results
     */
    public BulkMediaUpdateResponse uploadMediaAndUpdateVocabs(MultipartFile[] files) {
        if (bucket == null) {
            throw new IllegalStateException("Firebase storage bucket is not configured");
        }

        if (files == null || files.length == 0) {
            throw new IllegalArgumentException("No files provided");
        }

        log.info("Starting bulk media upload and vocab update for {} files", files.length);

        List<BulkMediaUpdateResponse.MediaUpdateResult> results = new ArrayList<>();
        List<BulkMediaUpdateResponse.MediaUpdateError> errors = new ArrayList<>();
        int successCount = 0;
        int failedCount = 0;
        int skippedCount = 0;

        // Use ExecutorService for parallel processing (max 5 concurrent)
        ExecutorService executor = Executors.newFixedThreadPool(Math.min(5, files.length));
        List<CompletableFuture<Void>> futures = new ArrayList<>();

        for (MultipartFile file : files) {
            CompletableFuture<Void> future = CompletableFuture.runAsync(() -> {
                String filename = file.getOriginalFilename();
                log.info("Processing file: {}", filename);

                try {
                    // Extract word from filename
                    String word = extractWordFromFilename(filename);
                    if (word == null || word.isEmpty()) {
                        synchronized (errors) {
                            errors.add(BulkMediaUpdateResponse.MediaUpdateError.builder()
                                    .fileName(filename)
                                    .reason("Không thể extract tên từ từ filename. Format hỗ trợ: [word].[extension] hoặc [số].[word].[extension]")
                                    .build());
                        }
                        return;
                    }

                    // Determine media type
                    String mediaType = determineMediaType(file.getContentType());
                    if ("unknown".equals(mediaType)) {
                        synchronized (errors) {
                            errors.add(BulkMediaUpdateResponse.MediaUpdateError.builder()
                                    .fileName(filename)
                                    .reason("File type không được hỗ trợ. Chỉ hỗ trợ images và audios")
                                    .build());
                        }
                        return;
                    }

                    // Upload to Firebase Storage
                    String uploadedUrl;
                    if ("image".equals(mediaType)) {
                        uploadedUrl = uploadVocabImage(file);
                    } else {
                        uploadedUrl = uploadVocabAudio(file);
                    }

                    log.info("Uploaded {} for word '{}': {}", mediaType, word, uploadedUrl);

                    // Update vocab in database
                    if ("image".equals(mediaType)) {
                        vocabService.bulkUpdateMediaUrls(word, uploadedUrl, null);
                    } else {
                        vocabService.bulkUpdateMediaUrls(word, null, uploadedUrl);
                    }

                    synchronized (results) {
                        results.add(BulkMediaUpdateResponse.MediaUpdateResult.builder()
                                .fileName(filename)
                                .word(word)
                                .mediaType(mediaType)
                                .uploadedUrl(uploadedUrl)
                                .status("success")
                                .build());
                    }

                } catch (Exception e) {
                    log.error("Failed to process file '{}': {}", filename, e.getMessage());
                    synchronized (errors) {
                        errors.add(BulkMediaUpdateResponse.MediaUpdateError.builder()
                                .fileName(filename)
                                .reason(e.getMessage())
                                .build());
                    }
                }
            }, executor);

            futures.add(future);
        }

        // Wait for all uploads to complete
        CompletableFuture.allOf(futures.toArray(new CompletableFuture[0])).join();
        executor.shutdown();

        successCount = results.size();
        failedCount = errors.size();
        skippedCount = files.length - successCount - failedCount;

        log.info("Bulk media upload and vocab update completed. Success: {}, Failed: {}, Skipped: {}",
                successCount, failedCount, skippedCount);

        return BulkMediaUpdateResponse.builder()
                .totalFiles(files.length)
                .successCount(successCount)
                .failedCount(failedCount)
                .skippedCount(skippedCount)
                .results(results)
                .errors(errors)
                .build();
    }
}
