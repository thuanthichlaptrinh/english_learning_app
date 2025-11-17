package com.thuanthichlaptrinh.card_words.entrypoint.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Request lấy danh sách từ vựng cần ôn tập")
public class GetReviewVocabsRequest {

    @Schema(description = "Tên của topic (tùy chọn, để lấy từ vựng theo chủ đề)", example = "Animals")
    private String topicName;

    @Min(value = 0, message = "Số trang phải lớn hơn hoặc bằng 0")
    @Builder.Default
    @Schema(description = "Số trang (bắt đầu từ 0)", example = "0", defaultValue = "0")
    private Integer page = 0;

    @Min(value = 1, message = "Kích thước trang phải lớn hơn 0")
    @Max(value = 100, message = "Kích thước trang tối đa là 100")
    @Builder.Default
    @Schema(description = "Số lượng từ trên mỗi trang", example = "10", defaultValue = "10")
    private Integer size = 10;

    @Schema(description = "Chỉ lấy từ chưa thuộc (NEW hoặc chưa học)", example = "false", defaultValue = "false")
    @Builder.Default
    private Boolean onlyNew = false;

    @Schema(description = "Chỉ lấy từ cần ôn tập lại (đến ngày review)", example = "false", defaultValue = "false")
    @Builder.Default
    private Boolean onlyDue = false;
}
