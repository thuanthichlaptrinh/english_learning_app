package com.thuanthichlaptrinh.card_words.entrypoint.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BulkUpdateTopicsRequest {

    private List<TopicItem> topics;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TopicItem {
        @NotNull(message = "ID chủ đề không được null")
        private Long id;

        @Size(min = 1, max = 100, message = "Tên chủ đề phải từ 1-100 ký tự")
        private String name;

        @Size(max = 500, message = "Mô tả chủ đề tối đa 500 ký tự")
        private String description;

        @Size(max = 500, message = "URL hình ảnh tối đa 500 ký tự")
        private String imageUrl;
    }
}
