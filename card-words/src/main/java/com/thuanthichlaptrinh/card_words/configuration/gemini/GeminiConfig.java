package com.thuanthichlaptrinh.card_words.configuration.gemini;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Data
@Configuration
@ConfigurationProperties(prefix = "gemini.api")
public class GeminiConfig {
    private String key;
    private String model;
    private String baseUrl;
    private Integer maxTokens;
    private Double temperature;
}
