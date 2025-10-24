package com.thuanthichlaptrinh.card_words.entrypoint.dto.request;

import java.time.LocalDate;

import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import com.thuanthichlaptrinh.card_words.common.enums.CEFRLevel;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdateUserRequest {

    @Size(min = 2, max = 100, message = "Tên phải từ 2-100 ký tự")
    private String name;

    @Size(max = 10, message = "Giới tính tối đa 10 ký tự")
    private String gender;

    @Past(message = "Ngày sinh phải là ngày trong quá khứ")
    private LocalDate dateOfBirth;

    private CEFRLevel currentLevel;
}