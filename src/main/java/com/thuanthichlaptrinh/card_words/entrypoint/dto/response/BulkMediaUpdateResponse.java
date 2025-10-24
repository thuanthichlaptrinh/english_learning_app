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
public class BulkMediaUpdateResponse {

    private Integer totalFiles;
    private Integer successCount;
    private Integer failedCount;
    private Integer skippedCount;
    private List<MediaUpdateResult> results;
    private List<MediaUpdateError> errors;

    @Getter
    @Setter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class MediaUpdateResult {
        private String fileName;
        private String word;
        private String mediaType; // "image" or "audio"
        private String uploadedUrl;
        private String status; // "success", "word_not_found", "failed"
    }

    @Getter
    @Setter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class MediaUpdateError {
        private String fileName;
        private String reason;
    }
}
