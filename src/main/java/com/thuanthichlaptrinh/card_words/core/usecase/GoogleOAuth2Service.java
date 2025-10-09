package com.thuanthichlaptrinh.card_words.core.usecase;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.Collections;
import java.util.Optional;
import java.util.Set;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.gson.GsonFactory;
import com.thuanthichlaptrinh.card_words.common.enums.CEFRLevel;
import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.configuration.jwt.JwtService;
import com.thuanthichlaptrinh.card_words.core.domain.Role;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.RoleRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.GoogleAuthResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class GoogleOAuth2Service {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final JwtService jwtService;
    private final PasswordEncoder passwordEncoder;

    @Value("${google.oauth2.client-id}")
    private String googleClientId;

    private static final JsonFactory JSON_FACTORY = GsonFactory.getDefaultInstance();

    @Transactional
    public GoogleAuthResponse authenticateWithGoogle(String idToken) {
        try {
            log.info("Bắt đầu xác thực Google với ID token");

            // Verify Google ID token
            GoogleIdToken.Payload payload = verifyGoogleToken(idToken);

            String email = payload.getEmail();
            String firstName = (String) payload.get("given_name");
            String lastName = (String) payload.get("family_name");
            String fullName = (firstName != null ? firstName : "") +
                    (lastName != null ? " " + lastName : "");
            String avatar = (String) payload.get("picture");

            log.info("Xác thực Google thành công cho email: {}", email);

            // Tìm hoặc tạo user
            Optional<User> existingUser = userRepository.findByEmail(email);
            User user;
            boolean isNewUser = false;

            if (existingUser.isPresent()) {
                user = existingUser.get();
                // Cập nhật thông tin từ Google nếu cần
                updateUserFromGoogle(user, fullName.trim(), avatar);
                log.info("Đăng nhập với user hiện có: {}", email);
            } else {
                user = createNewGoogleUser(email, fullName.trim(), avatar);
                isNewUser = true;
                log.info("Tạo user mới từ Google: {}", email);
            }

            // Tạo JWT tokens
            String accessToken = jwtService.generateToken(user);
            String refreshToken = jwtService.generateRefreshToken(user);

            log.info("Tạo tokens thành công cho user: {}", email);

            // Tách tên từ fullName để hiển thị
            String[] nameParts = user.getName().split(" ", 2);
            String displayFirstName = nameParts.length > 0 ? nameParts[0] : "";
            String displayLastName = nameParts.length > 1 ? nameParts[1] : "";

            return GoogleAuthResponse.builder()
                    .accessToken(accessToken)
                    .refreshToken(refreshToken)
                    .tokenType("Bearer")
                    .expiresIn(86400L) // 24 hours in seconds
                    .isNewUser(isNewUser)
                    .user(GoogleAuthResponse.UserInfo.builder()
                            .id(user.getId().toString())
                            .email(user.getEmail())
                            .firstName(displayFirstName)
                            .lastName(displayLastName)
                            .avatar(user.getAvatar())
                            .currentLevel(user.getCurrentLevel().name())
                            .build())
                    .build();

        } catch (Exception e) {
            log.error("Lỗi xác thực Google: ", e);
            throw new ErrorException("Xác thực Google thất bại: " + e.getMessage());
        }
    }

    private GoogleIdToken.Payload verifyGoogleToken(String idToken)
            throws GeneralSecurityException, IOException {

        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                new NetHttpTransport(), JSON_FACTORY)
                .setAudience(Collections.singletonList(googleClientId))
                .build();

        GoogleIdToken token = verifier.verify(idToken);
        if (token == null) {
            throw new ErrorException("Token Google không hợp lệ");
        }

        return token.getPayload();
    }

    private User createNewGoogleUser(String email, String fullName, String avatar) {
        // Lấy role USER mặc định
        Role userRole = roleRepository.findByName("USER")
                .orElseThrow(() -> new ErrorException("Không tìm thấy role USER"));

        User user = User.builder()
                .email(email)
                .name(fullName != null && !fullName.isEmpty() ? fullName : "Google User")
                .avatar(avatar)
                .password(passwordEncoder.encode("google-oauth2-" + System.currentTimeMillis())) // Random password
                .activated(true) // Google users are automatically activated
                .banned(false)
                .currentLevel(CEFRLevel.A1) // Mặc định level A1
                .roles(Set.of(userRole))
                .build();

        return userRepository.save(user);
    }

    private void updateUserFromGoogle(User user, String fullName, String avatar) {
        boolean updated = false;

        if (fullName != null && !fullName.equals(user.getName())) {
            user.setName(fullName);
            updated = true;
        }

        if (avatar != null && !avatar.equals(user.getAvatar())) {
            user.setAvatar(avatar);
            updated = true;
        }

        if (updated) {
            userRepository.save(user);
            log.info("Cập nhật thông tin user từ Google: {}", user.getEmail());
        }
    }
}