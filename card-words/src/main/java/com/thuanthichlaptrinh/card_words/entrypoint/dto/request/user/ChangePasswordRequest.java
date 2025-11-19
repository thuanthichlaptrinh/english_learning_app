package com.thuanthichlaptrinh.card_words.entrypoint.dto.request.user;

import static com.thuanthichlaptrinh.card_words.common.constants.PasswordConstants.MIN_LENGTH;
import static com.thuanthichlaptrinh.card_words.common.constants.PasswordConstants.MAX_LENGTH;
import static com.thuanthichlaptrinh.card_words.common.constants.PasswordConstants.LENGTH_MESSAGE;

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
public class ChangePasswordRequest {

    @NotBlank(message = "Mật khẩu hiện tại không được để trống")
    private String currentPassword;

    @NotBlank(message = "Mật khẩu mới không được để trống")
    @Size(min = MIN_LENGTH, max = MAX_LENGTH, message = LENGTH_MESSAGE)
    private String newPassword;

    @NotBlank(message = "Xác nhận mật khẩu không được để trống")
    private String confirmPassword;
}
