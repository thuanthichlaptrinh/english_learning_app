package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BulkUploadResponse {

    private int totalRequested;
    private int successCount;
    private int failedCount;
    private List<UploadResult> results;
    private List<UploadError> errors;

    @Getter
    @Setter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class UploadResult {
        private String originalFilename;
        private String url;
        private long fileSize;
        private String contentType;
    }

    @Getter
    @Setter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class UploadError {
        private String filename;
        private String reason;
        private int index;
    }
}
