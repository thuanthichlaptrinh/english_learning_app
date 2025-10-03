package com.thuanthichlaptrinh.card_words.core.usecase;

import org.springframework.stereotype.Service;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.UpdateUserRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.UserProfileResponse;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    @Transactional
    public UserProfileResponse updateUserProfile(String userEmail, UpdateUserRequest request) {
        log.info("Cập nhật thông tin user: {}", userEmail);

        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new ErrorException("User không tồn tại"));

        // Cập nhật thông tin - chỉ cập nhật những trường không null
        if (request.getName() != null && !request.getName().trim().isEmpty()) {
            user.setName(request.getName());
        }
        if (request.getAvatar() != null) {
            user.setAvatar(request.getAvatar());
        }
        if (request.getGender() != null) {
            user.setGender(request.getGender());
        }
        if (request.getDateOfBirth() != null) {
            user.setDateOfBirth(request.getDateOfBirth());
        }
        if (request.getCurrentLevel() != null) {
            user.setCurrentLevel(request.getCurrentLevel());
        }

        user = userRepository.save(user);

        return UserProfileResponse.builder()
                .email(user.getEmail())
                .name(user.getName())
                .avatar(user.getAvatar())
                .gender(user.getGender())
                .dateOfBirth(user.getDateOfBirth())
                .currentLevel(user.getCurrentLevel())
                .build();
    }

    public UserProfileResponse getUserProfile(String userEmail) {
        log.info("Lấy thông tin user: {}", userEmail);

        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new ErrorException("User không tồn tại"));

        return UserProfileResponse.builder()
                .email(user.getEmail())
                .name(user.getName())
                .avatar(user.getAvatar())
                .gender(user.getGender())
                .dateOfBirth(user.getDateOfBirth())
                .currentLevel(user.getCurrentLevel())
                .build();
    }

}
