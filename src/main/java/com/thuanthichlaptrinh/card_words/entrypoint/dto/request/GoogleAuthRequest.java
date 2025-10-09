package com.thuanthichlaptrinh.card_words.entrypoint.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GoogleAuthRequest {

    @NotBlank(message = "Google ID token không được để trống")
    private String idToken;

}