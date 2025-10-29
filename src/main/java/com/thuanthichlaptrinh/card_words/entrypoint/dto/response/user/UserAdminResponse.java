package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import com.thuanthichlaptrinh.card_words.common.enums.CEFRLevel;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserAdminResponse {
    private UUID id;
    private String email;
    private String name;
    private String avatar;
    private String gender;
    private LocalDate dateOfBirth;
    private CEFRLevel currentLevel;
    private Boolean activated;
    private Boolean banned;
    private String status;
    private List<String> roles;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
