package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Response thông tin category thông báo với số lượng")
public class NotificationCategoryResponse {

    @Schema(description = "Tên category", example = "Study Progress")
    private String category;

    @Schema(description = "Số lượng thông báo trong category", example = "5")
    private Long count;

    @Schema(description = "Type tương ứng (nếu có)", example = "study_progress")
    private String type;
}
