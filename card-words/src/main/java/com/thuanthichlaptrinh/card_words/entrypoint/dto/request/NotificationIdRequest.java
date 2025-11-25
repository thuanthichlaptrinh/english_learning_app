package com.thuanthichlaptrinh.card_words.entrypoint.dto.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Request đơn giản chứa ID của thông báo.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class NotificationIdRequest {

    @NotNull(message = "notificationId là bắt buộc")
    @Min(value = 1, message = "notificationId phải lớn hơn 0")
    private Long notificationId;
}
