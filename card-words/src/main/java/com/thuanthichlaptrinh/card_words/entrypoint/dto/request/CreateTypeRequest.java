package com.thuanthichlaptrinh.card_words.entrypoint.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateTypeRequest {

    @NotBlank(message = "Tên loại từ không được để trống")
    @Size(min = 1, max = 50, message = "Tên loại từ phải từ 1-50 ký tự")
    private String name;
}