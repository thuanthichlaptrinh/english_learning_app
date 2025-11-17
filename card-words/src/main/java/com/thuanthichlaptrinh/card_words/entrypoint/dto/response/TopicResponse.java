package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TopicResponse {
    private Long id;
    private String name;
    private String description;
    private String img;

    /**
     * Tiến độ học từ vựng của user trong topic này (%)
     * Giá trị từ 0.0 đến 100.0
     * Null nếu không có thông tin user hoặc user chưa đăng nhập
     */
    private Double progress;
}