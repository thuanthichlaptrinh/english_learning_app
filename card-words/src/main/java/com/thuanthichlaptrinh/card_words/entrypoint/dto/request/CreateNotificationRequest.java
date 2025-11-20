package com.thuanthichlaptrinh.card_words.entrypoint.dto.request;

import com.thuanthichlaptrinh.card_words.common.constants.NotificationConstants;
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
    private String type; // Must be one of NotificationConstants.VALID_TYPES

    /**
     * Validate type if provided
     */
    public void validateType() {
        if (type != null && !type.isEmpty() && !NotificationConstants.VALID_TYPES.contains(type)) {
            throw new IllegalArgumentException(
                    "Invalid notification type: " + type + ". Valid types: " + NotificationConstants.VALID_TYPES);
        }
    }
}
