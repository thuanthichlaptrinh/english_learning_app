package com.thuanthichlaptrinh.card_words.entrypoint.dto.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * Request chứa danh sách các notificationId.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class NotificationBatchRequest {

    @NotEmpty(message = "Danh sách notificationId không được để trống")
    private List<@NotNull(message = "notificationId không được null") @Min(value = 1, message = "notificationId phải lớn hơn 0") Long> notificationIds;
}
