package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.auth;

import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import com.thuanthichlaptrinh.card_words.common.enums.CEFRLevel;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RegisterResponse {
    private String email;
    private String name;
    private String avatar;
    private String gender;
    private LocalDate dateOfBirth;
    private CEFRLevel currentLevel;
    private String message;
}
