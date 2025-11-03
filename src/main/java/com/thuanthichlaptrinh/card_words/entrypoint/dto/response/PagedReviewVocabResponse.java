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
@Schema(description = "Response phân trang danh sách từ vựng ôn tập")
public class PagedReviewVocabResponse {

    @Schema(description = "Danh sách từ vựng trong trang hiện tại")
    private List<ReviewVocabResponse> vocabs;

    @Schema(description = "Trang hiện tại (bắt đầu từ 0)", example = "0")
    private Integer currentPage;

    @Schema(description = "Số lượng từ trên mỗi trang", example = "10")
    private Integer pageSize;

    @Schema(description = "Tổng số trang", example = "5")
    private Integer totalPages;

    @Schema(description = "Tổng số từ vựng", example = "50")
    private Long totalElements;

    @Schema(description = "Có trang trước hay không")
    private Boolean hasPrevious;

    @Schema(description = "Có trang sau hay không")
    private Boolean hasNext;

    @Schema(description = "Số từ mới (chưa học)")
    private Integer newVocabs;

    @Schema(description = "Số từ đang học")
    private Integer learningVocabs;

    @Schema(description = "Số từ đã thành thạo")
    private Integer masteredVocabs;

    @Schema(description = "Số từ đến hạn ôn tập hôm nay")
    private Integer dueVocabs;
}
