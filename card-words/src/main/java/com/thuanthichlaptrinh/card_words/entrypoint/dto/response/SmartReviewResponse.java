package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Response gợi ý ôn tập thông minh")
public class SmartReviewResponse {
    
    @Schema(description = "Danh sách từ vựng được gợi ý, sắp xếp theo priority score giảm dần")
    private List<VocabRecommendation> recommendations;
    
    @Schema(description = "Tổng số từ vựng đã phân tích")
    private Integer totalAnalyzed;
    
    @Schema(description = "Tổng số từ vựng được gợi ý (sau khi filter)")
    private Integer totalRecommended;
    
    @Schema(description = "Thống kê tổng quan")
    private RecommendationSummary summary;
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    @Schema(description = "Thống kê tổng quan về gợi ý")
    public static class RecommendationSummary {
        
        @Schema(description = "Số từ có priority HIGH (score >= 60)")
        private Integer highPriority;
        
        @Schema(description = "Số từ có priority MEDIUM (score 30-59)")
        private Integer mediumPriority;
        
        @Schema(description = "Số từ có priority LOW (score < 30)")
        private Integer lowPriority;
        
        @Schema(description = "Số từ quá hạn ôn tập")
        private Integer overdueCount;
        
        @Schema(description = "Số từ có status UNKNOWN (chưa thuộc)")
        private Integer unknownCount;
        
        @Schema(description = "Số từ có tỷ lệ đúng < 50%")
        private Integer lowAccuracyCount;
    }
}
