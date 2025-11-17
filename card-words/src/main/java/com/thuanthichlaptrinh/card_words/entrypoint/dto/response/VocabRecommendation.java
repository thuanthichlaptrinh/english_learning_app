package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Gợi ý từ vựng cần ôn tập với priority score")
public class VocabRecommendation {
    
    @Schema(description = "ID của từ vựng")
    private UUID vocabId;
    
    @Schema(description = "Từ vựng (tiếng Anh)")
    private String word;
    
    @Schema(description = "Phiên âm")
    private String transcription;
    
    @Schema(description = "Nghĩa tiếng Việt")
    private String meaningVi;
    
    @Schema(description = "Cấp độ CEFR (A1, A2, B1, B2, C1, C2)")
    private String cefr;
    
    @Schema(description = "URL hình ảnh minh họa")
    private String img;
    
    @Schema(description = "URL file audio phát âm")
    private String audio;
    
    @Schema(description = "Tên chủ đề")
    private String topicName;
    
    // Priority info
    @Schema(description = "Điểm ưu tiên (0-100), càng cao càng cần ôn gấp")
    private Integer priorityScore;
    
    @Schema(description = "Mức độ ưu tiên: HIGH (>=60), MEDIUM (30-59), LOW (<30)")
    private String priorityLevel;
    
    @Schema(description = "Danh sách lý do gợi ý từ này")
    private List<String> reasons;
    
    // Progress info
    @Schema(description = "Trạng thái học tập")
    private VocabStatus status;
    
    @Schema(description = "Số lần trả lời đúng")
    private Integer timesCorrect;
    
    @Schema(description = "Số lần trả lời sai")
    private Integer timesWrong;
    
    @Schema(description = "Tỷ lệ đúng (0.0 - 1.0)")
    private Double accuracyRate;
    
    @Schema(description = "Ngày ôn tập lần cuối")
    private LocalDate lastReviewed;
    
    @Schema(description = "Ngày cần ôn tập tiếp theo")
    private LocalDate nextReviewDate;
    
    @Schema(description = "Số ngày kể từ lần ôn tập cuối")
    private Integer daysSinceLastReview;
    
    @Schema(description = "Số ngày quá hạn ôn tập (0 nếu chưa quá hạn)")
    private Integer daysOverdue;
}
