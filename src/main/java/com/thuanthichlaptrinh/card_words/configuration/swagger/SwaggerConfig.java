package com.thuanthichlaptrinh.card_words.configuration.swagger;

import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.servers.Server;

@Configuration
public class SwaggerConfig {
    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Card Words API")
                        .version("1.0.0")
                        .description(
                                "API Documentation cho ứng dụng Card Words - Học từ vựng Tiếng Anh bằng trò chơi ghép thẻ"))
                .servers(List.of(
                        new Server()
                                .url("http://localhost:8080")
                                .description("Local Development Server"),
                        new Server()
                                .url("https://api.cardwords.com")
                                .description("Production Server")));
    }
}
