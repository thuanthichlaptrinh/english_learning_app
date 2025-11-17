package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BulkImportResponse {

    private int totalRequested; // Tổng số từ được gửi lên
    private int successCount; // Số từ được import thành công
    private int failedCount; // Số từ bị lỗi
    private int skippedCount; // Số từ bị skip (đã tồn tại)
    private java.util.List<ImportError> errors; // Danh sách lỗi

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ImportError {
        private String word;
        private String reason;
        private int lineNumber;
    }
}
