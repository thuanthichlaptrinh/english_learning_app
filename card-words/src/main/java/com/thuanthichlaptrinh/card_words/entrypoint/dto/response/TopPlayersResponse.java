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
@Schema(description = "Response chứa top 10 users của 3 game")
public class TopPlayersResponse {

    @Schema(description = "Top 10 players Quick Quiz", example = "[...]")
    private List<LeaderboardEntryResponse> quickQuizTop10;

    @Schema(description = "Top 10 players Image Matching", example = "[...]")
    private List<LeaderboardEntryResponse> imageMatchingTop10;

    @Schema(description = "Top 10 players Word Definition", example = "[...]")
    private List<LeaderboardEntryResponse> wordDefinitionTop10;

    @Schema(description = "Tổng số players đã tham gia ít nhất 1 game", example = "150")
    private Integer totalActivePlayers;

    @Schema(description = "Thời gian cache (giây)", example = "300")
    private Integer cacheExpirySeconds;

}
