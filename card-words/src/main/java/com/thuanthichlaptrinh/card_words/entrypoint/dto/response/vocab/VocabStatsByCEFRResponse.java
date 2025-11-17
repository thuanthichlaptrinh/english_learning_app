package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.vocab;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Thống kê số từ vựng đã học theo cấp bậc CEFR")
public class VocabStatsByCEFRResponse {

    @Schema(description = "Map cấp bậc CEFR và số lượng từ đã học", example = "{\"A1\": 30, \"A2\": 25, \"B1\": 32, \"B2\": 10, \"C1\": 11, \"C2\": 5}")
    private Map<String, Long> stats;

    @Schema(description = "Tổng số từ đã học", example = "113")
    private Long total;
}
