package com.thuanthichlaptrinh.card_words.configuration.jwt;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import lombok.Data;

@Data
@Configuration
@ConfigurationProperties(prefix = "application.security.jwt")
public class JwtProperties {
    private String secretKey;
    private long expiration;
    private RefreshToken refreshToken;

    @Data
    public static class RefreshToken {
        private long expiration;
    }
}
