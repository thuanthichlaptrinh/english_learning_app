package com.thuanthichlaptrinh.card_words.entrypoint.dto.request.chat;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChatRequest {

    @NotBlank(message = "Message cannot be blank")
    @Size(max = 2000, message = "Message cannot exceed 2000 characters")
    private String message;

    private UUID sessionId;

    @Builder.Default
    private Boolean includeContext = true;

    @Builder.Default
    private Boolean searchFaq = true;
}
