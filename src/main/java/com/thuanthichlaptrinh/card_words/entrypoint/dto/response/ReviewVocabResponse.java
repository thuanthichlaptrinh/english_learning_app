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
@Schema(description = "Response thông tin từ vựng để ôn tập")
public class ReviewVocabResponse {

    @Schema(description = "ID của từ vựng")
    private UUID vocabId;

    @Schema(description = "Từ vựng (tiếng Anh)")
    private String word;

    @Schema(description = "Phiên âm")
    private String transcription;

    @Schema(description = "Nghĩa tiếng Việt")
    private String meaningVi;

    @Schema(description = "Giải thích chi tiết")
    private String interpret;

    @Schema(description = "Câu ví dụ")
    private String exampleSentence;

    @Schema(description = "Cấp độ CEFR (A1, A2, B1, B2, C1, C2)")
    private String cefr;

    @Schema(description = "URL hình ảnh minh họa")
    private String img;

    @Schema(description = "URL file audio phát âm")
    private String audio;

    @Schema(description = "Danh sách chủ đề của từ vựng")
    private List<String> topics;

    @Schema(description = "Danh sách loại từ (noun, verb, adjective...)")
    private List<String> types;

    @Schema(description = "Trạng thái học tập (NEW, KNOWN, UNKNOWN, MASTERED)")
    private VocabStatus status;

    @Schema(description = "Số lần trả lời đúng")
    private Integer timesCorrect;

    @Schema(description = "Số lần trả lời sai")
    private Integer timesWrong;

    @Schema(description = "Ngày ôn tập lần cuối")
    private LocalDate lastReviewed;

    @Schema(description = "Ngày cần ôn tập tiếp theo")
    private LocalDate nextReviewDate;

    @Schema(description = "Số ngày đến lần ôn tập tiếp theo")
    private Integer intervalDays;
}
