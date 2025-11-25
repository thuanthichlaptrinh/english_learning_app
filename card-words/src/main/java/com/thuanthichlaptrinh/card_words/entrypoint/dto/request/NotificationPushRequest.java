package com.thuanthichlaptrinh.card_words.entrypoint.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

/**
 * Payload nhận từ client khi gửi thông báo qua WebSocket.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class NotificationPushRequest {

    /**
     * Cho phép client chỉ định người nhận cụ thể; nếu để trống sẽ mặc định là chính chủ.
     */
    private UUID userId;

    @NotBlank(message = "Tiêu đề không được để trống")
    @Size(max = 255)
    private String title;

    @Size(max = 5000)
    private String content;

    @Size(max = 50, message = "Type không quá 50 ký tự")
    private String type;
}
