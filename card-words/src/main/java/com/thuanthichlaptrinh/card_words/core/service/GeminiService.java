package com.thuanthichlaptrinh.card_words.core.service;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.thuanthichlaptrinh.card_words.configuration.GeminiConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import okhttp3.*;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

@Slf4j
@Service
@RequiredArgsConstructor
public class GeminiService {

    private final GeminiConfig geminiConfig;
    private final Gson gson = new Gson();

    private final OkHttpClient httpClient = new OkHttpClient.Builder()
            .connectTimeout(30, TimeUnit.SECONDS)
            .readTimeout(60, TimeUnit.SECONDS)
            .writeTimeout(30, TimeUnit.SECONDS)
            .build();

    /**
     * Generate response from Gemini API with conversation history
     */
    public String generateResponse(List<Message> messages) {
        try {
            String url = String.format("%s/%s:generateContent?key=%s",
                    geminiConfig.getBaseUrl(),
                    geminiConfig.getModel(),
                    geminiConfig.getKey());

            JsonObject requestBody = buildRequestBody(messages);

            RequestBody body = RequestBody.create(
                    requestBody.toString(),
                    MediaType.parse("application/json"));

            Request request = new Request.Builder()
                    .url(url)
                    .post(body)
                    .addHeader("Content-Type", "application/json")
                    .build();

            try (Response response = httpClient.newCall(request).execute()) {
                if (!response.isSuccessful()) {
                    log.error("Gemini API error: {}", response.code());
                    String errorBody = response.body() != null ? response.body().string() : "No error body";
                    log.error("Error body: {}", errorBody);
                    throw new IOException("Mã phản hồi không mong đợi: " + response.code());
                }

                String responseBody = response.body().string();
                return parseResponse(responseBody);
            }
        } catch (Exception e) {
            log.error("Error calling Gemini API", e);
            return "Xin lỗi, tôi đang gặp sự cố kỹ thuật. Vui lòng thử lại sau.";
        }
    }

    /**
     * Generate simple response with single prompt
     */
    public String generateSimpleResponse(String prompt) {
        List<Message> messages = new ArrayList<>();
        messages.add(Message.builder()
                .role("user")
                .content(prompt)
                .build());

        return generateResponse(messages);
    }

    private JsonObject buildRequestBody(List<Message> messages) {
        JsonObject requestBody = new JsonObject();

        // Build contents array
        JsonArray contents = new JsonArray();
        for (Message message : messages) {
            JsonObject content = new JsonObject();

            // Gemini API uses "user" and "model" roles
            String role = message.getRole().equals("assistant") ? "model" : "user";
            content.addProperty("role", role);

            JsonArray parts = new JsonArray();
            JsonObject textPart = new JsonObject();
            textPart.addProperty("text", message.getContent());
            parts.add(textPart);

            content.add("parts", parts);
            contents.add(content);
        }

        requestBody.add("contents", contents);

        // Add generation config
        JsonObject generationConfig = new JsonObject();
        generationConfig.addProperty("temperature", geminiConfig.getTemperature());
        generationConfig.addProperty("maxOutputTokens", geminiConfig.getMaxTokens());
        generationConfig.addProperty("topP", 0.95);
        generationConfig.addProperty("topK", 40);

        requestBody.add("generationConfig", generationConfig);

        // Add safety settings
        JsonArray safetySettings = new JsonArray();
        String[] categories = {
                "HARM_CATEGORY_HARASSMENT",
                "HARM_CATEGORY_HATE_SPEECH",
                "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                "HARM_CATEGORY_DANGEROUS_CONTENT"
        };

        for (String category : categories) {
            JsonObject setting = new JsonObject();
            setting.addProperty("category", category);
            setting.addProperty("threshold", "BLOCK_MEDIUM_AND_ABOVE");
            safetySettings.add(setting);
        }

        requestBody.add("safetySettings", safetySettings);

        return requestBody;
    }

    private String parseResponse(String responseBody) {
        try {
            JsonObject jsonResponse = gson.fromJson(responseBody, JsonObject.class);

            if (jsonResponse.has("candidates") && jsonResponse.getAsJsonArray("candidates").size() > 0) {
                JsonObject candidate = jsonResponse.getAsJsonArray("candidates").get(0).getAsJsonObject();

                if (candidate.has("content")) {
                    JsonObject content = candidate.getAsJsonObject("content");
                    if (content.has("parts") && content.getAsJsonArray("parts").size() > 0) {
                        JsonObject part = content.getAsJsonArray("parts").get(0).getAsJsonObject();
                        if (part.has("text")) {
                            return part.get("text").getAsString();
                        }
                    }
                }
            }

            log.warn("Could not parse response: {}", responseBody);
            return "Xin lỗi, tôi không thể tạo câu trả lời lúc này.";
        } catch (Exception e) {
            log.error("Error parsing Gemini response", e);
            return "Xin lỗi, tôi gặp lỗi khi xử lý câu trả lời.";
        }
    }

    @lombok.Data
    @lombok.Builder
    @lombok.NoArgsConstructor
    @lombok.AllArgsConstructor
    public static class Message {
        private String role; // "user", "assistant", or "system"
        private String content;
    }
}
