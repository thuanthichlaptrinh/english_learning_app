package com.thuanthichlaptrinh.card_words.entrypoint.dto.request;

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
public class CreateNotificationRequest {

    private UUID userId;

    @NotBlank(message = "Tiêu đề không được để trống")
    @Size(max = 255)
    private String title;

    @Size(max = 5000)
    private String content;

    @Size(max = 50)
    private String type; // vocab_reminder, new_feature, achievement, system_alert, study_progress
}
