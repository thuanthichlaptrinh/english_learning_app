package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "API Response với data và meta riêng biệt")
public class ApiResponse2<T> {

    @JsonProperty("status")
    @Schema(description = "HTTP status code", example = "200")
    private Integer status;

    @JsonProperty("message")
    @Schema(description = "Response message", example = "Success")
    private String message;

    @JsonProperty("data")
    @Schema(description = "Response data (array hoặc object)")
    private T data;

    @JsonProperty("meta")
    @Schema(description = "Metadata về phân trang và thống kê")
    private Object meta;

    public static <T> ApiResponse2<T> success(String message, T data, Object meta) {
        return ApiResponse2.<T>builder()
                .status(200)
                .message(message)
                .data(data)
                .meta(meta)
                .build();
    }

    public static <T> ApiResponse2<T> success(String message, T data) {
        return ApiResponse2.<T>builder()
                .status(200)
                .message(message)
                .data(data)
                .meta(null)
                .build();
    }

    public static <T> ApiResponse2<T> error(Integer status, String message) {
        return ApiResponse2.<T>builder()
                .status(status)
                .message(message)
                .data(null)
                .meta(null)
                .build();
    }
}
