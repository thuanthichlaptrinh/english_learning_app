package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.auth;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AuthenticationResponse {
    private String tokenType;
    private Long expiresIn;
    private String accessToken;
    private String refreshToken;
}
