package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.admin;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ResetPasswordResponse {
    private UUID userId;
    private String email;
    private String name;
    private String newPassword;
    private String message;
}
