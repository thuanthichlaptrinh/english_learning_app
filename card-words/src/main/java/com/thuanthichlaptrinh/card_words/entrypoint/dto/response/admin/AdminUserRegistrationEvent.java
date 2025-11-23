package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.admin;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Payload realtime gửi qua WebSocket cho admin khi có user mới đăng ký.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminUserRegistrationEvent {

    private String message;
    private Long totalUsers;
    private String recentUserName;
    private String recentUserEmail;
    private LocalDateTime registeredAt;
}
