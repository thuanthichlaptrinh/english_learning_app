package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game;

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
@Schema(description = "Response chứa điểm cao nhất của user cho các game")
public class UserHighScoresResponse {

    @Schema(description = "Danh sách điểm cao nhất của từng game", example = "[...]")
    private List<GameHighScore> highScores;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    @Schema(description = "Điểm cao nhất của 1 game")
    public static class GameHighScore {

        @Schema(description = "Tên game", example = "Quick Reflex Quiz")
        private String gameName;

        @Schema(description = "Điểm cao nhất", example = "850")
        private Integer highestScore;

    }
}
