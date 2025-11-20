package com.thuanthichlaptrinh.card_words.entrypoint.dto.request;

import java.util.List;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdateMultipleTypesRequest {

    @NotEmpty(message = "Danh sách loại từ không được rỗng")
    @Valid
    private List<TypeUpdateItem> types;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TypeUpdateItem {

        private Long id;

        private String name;
    }
}
