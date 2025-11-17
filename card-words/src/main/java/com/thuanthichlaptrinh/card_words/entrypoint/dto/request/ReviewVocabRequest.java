package com.thuanthichlaptrinh.card_words.entrypoint.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Request ghi nhận kết quả ôn tập từ vựng")
public class ReviewVocabRequest {

    @NotNull(message = "Vocab ID không được để trống")
    @Schema(description = "ID của từ vựng được ôn tập", example = "123e4567-e89b-12d3-a456-426614174000")
    private UUID vocabId;

    @NotNull(message = "Kết quả không được để trống")
    @Schema(description = "Kết quả ôn tập: true = đúng, false = sai", example = "true")
    private Boolean isCorrect;

    @Min(value = 0, message = "Điểm chất lượng phải từ 0-5")
    @Max(value = 5, message = "Điểm chất lượng phải từ 0-5")
    @Schema(description = "Điểm chất lượng (0-5): 0=hoàn toàn quên, 3=khó nhớ, 5=rất dễ nhớ", example = "4")
    private Integer quality;
}
