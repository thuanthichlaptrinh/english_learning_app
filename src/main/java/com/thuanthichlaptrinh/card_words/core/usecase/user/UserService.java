package com.thuanthichlaptrinh.card_words.core.usecase.user;

import java.io.IOException;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.usecase.admin.FirebaseStorageService;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.user.UpdateUserRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.UserProfileResponse;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final FirebaseStorageService firebaseStorageService;

    @Transactional
    public UserProfileResponse updateUserProfile(String userEmail, UpdateUserRequest request,
            MultipartFile avatarFile) {
        log.info("Cập nhật thông tin user: {}", userEmail);

        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new ErrorException("User không tồn tại"));

        // Upload avatar nếu có file
        if (avatarFile != null && !avatarFile.isEmpty()) {
            try {
                String avatarUrl = firebaseStorageService.uploadUserAvatar(avatarFile);
                user.setAvatar(avatarUrl);
                log.info("Đã upload avatar mới cho user: {}", userEmail);
            } catch (IOException e) {
                log.error("Lỗi khi upload avatar: {}", e.getMessage());
                throw new ErrorException("Không thể upload avatar: " + e.getMessage());
            }
        }

        // Cập nhật thông tin user nếu có request
        if (request != null) {
            if (request.getName() != null && !request.getName().trim().isEmpty()) {
                user.setName(request.getName());
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
