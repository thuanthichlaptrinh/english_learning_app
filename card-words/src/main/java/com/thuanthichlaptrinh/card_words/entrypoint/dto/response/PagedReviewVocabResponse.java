package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
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
@Schema(description = "Response phân trang danh sách từ vựng ôn tập")
public class PagedReviewVocabResponse {

    @JsonProperty("vocabs")
    @Schema(description = "Danh sách từ vựng trong trang hiện tại")
    private List<ReviewVocabResponse> vocabs;

    @JsonProperty("meta")
    @Schema(description = "Metadata về phân trang và thống kê")
    private PageMetadata meta;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class PageMetadata {
        @JsonProperty("page")
        @Schema(description = "Trang hiện tại (bắt đầu từ 1)", example = "1")
        private Integer page;

        @JsonProperty("pageSize")
        @Schema(description = "Số lượng từ trên mỗi trang", example = "20")
        private Integer pageSize;

        @JsonProperty("totalItems")
        @Schema(description = "Tổng số từ vựng", example = "320")
        private Long totalItems;

        @JsonProperty("totalPages")
        @Schema(description = "Tổng số trang", example = "16")
        private Integer totalPages;

        @JsonProperty("hasNext")
        @Schema(description = "Có trang sau hay không")
        private Boolean hasNext;

        @JsonProperty("hasPrev")
        @Schema(description = "Có trang trước hay không")
        private Boolean hasPrev;

        @JsonProperty("newVocabs")
        @Schema(description = "Số từ mới (chưa học)")
        private Integer newVocabs;

        @JsonProperty("learningVocabs")
        @Schema(description = "Số từ đang học")
        private Integer learningVocabs;

        @JsonProperty("masteredVocabs")
        @Schema(description = "Số từ đã thành thạo")
        private Integer masteredVocabs;

        @JsonProperty("dueVocabs")
        @Schema(description = "Số từ đến hạn ôn tập hôm nay")
        private Integer dueVocabs;
    }
}
