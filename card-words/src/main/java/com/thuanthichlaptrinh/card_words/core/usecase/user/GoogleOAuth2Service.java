package com.thuanthichlaptrinh.card_words.core.usecase.user;

import java.io.IOException;
import java.security.GeneralSecurityException;
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
import com.thuanthichlaptrinh.card_words.core.domain.Token;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.usecase.admin.ActionLogService;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.RoleRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.TokenRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.auth.GoogleAuthResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class GoogleOAuth2Service {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final TokenRepository tokenRepository;
    private final JwtService jwtService;
    private final PasswordEncoder passwordEncoder;
    private final ActionLogService actionLogService;

    @Value("${google.oauth2.client-id:your-google-client-id}")
    private String googleClientId;

    // Android Client ID (nếu khác với Web Client ID)
    @Value("${google.oauth2.android-client-id:${google.oauth2.client-id}}")
    private String androidClientId;

    // iOS Client ID (nếu khác với Web Client ID)
    @Value("${google.oauth2.ios-client-id:${google.oauth2.client-id}}")
    private String iosClientId;

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

            // Lưu token vào database
            revokeAllUserTokens(user);
            saveUserToken(user, accessToken, refreshToken);

            log.info("Tạo và lưu tokens thành công cho user: {}", email);

            // ✅ Log action: GOOGLE_LOGIN
            try {
                String actionType = isNewUser ? "GOOGLE_REGISTER" : "GOOGLE_LOGIN";
                String description = isNewUser ? "New user registered via Google OAuth"
                        : "User logged in via Google OAuth";
                actionLogService.logAction(
                        user.getId(),
                        user.getEmail(),
                        user.getName(),
                        actionType,
                        "SYSTEM",
                        "Authentication System",
                        user.getId().toString(),
                        description,
                        "SUCCESS",
                        null,
                        null);
            } catch (Exception logError) {
                log.warn("Failed to log action: {}", logError.getMessage());
            }

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

        log.info("🔍 Verifying Google ID token...");
        log.info("🔑 Google Client IDs configured:");
        log.info("   - Web: {}", googleClientId);
        log.info("   - Android: {}", androidClientId);
        log.info("   - iOS: {}", iosClientId);
        log.info("📏 ID Token length: {}", idToken != null ? idToken.length() : 0);
        log.info("📝 ID Token first 50 chars: {}",
                idToken != null && idToken.length() > 50 ? idToken.substring(0, 50) + "..." : idToken);

        // Tạo danh sách tất cả Client IDs (Web, Android, iOS)
        java.util.List<String> allClientIds = new java.util.ArrayList<>();
        allClientIds.add(googleClientId);
        if (!androidClientId.equals(googleClientId)) {
            allClientIds.add(androidClientId);
        }
        if (!iosClientId.equals(googleClientId) && !iosClientId.equals(androidClientId)) {
            allClientIds.add(iosClientId);
        }
        log.info("📋 All valid audiences: {}", allClientIds);

        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                new NetHttpTransport(), JSON_FACTORY)
                .setAudience(allClientIds)
                .build();

        GoogleIdToken token = null;
        try {
            token = verifier.verify(idToken);
        } catch (Exception e) {
            log.error("Error parsing/verifying Google token: {}", e.getMessage());
            throw new ErrorException("Token Google không đúng định dạng hoặc không hợp lệ: " + e.getMessage());
        }

        if (token == null) {
            // Decode token để xem thêm thông tin (không verify)
            try {
                String[] parts = idToken.split("\\.");
                if (parts.length >= 2) {
                    String payload = new String(java.util.Base64.getUrlDecoder().decode(parts[1]));
                    log.error("🔍 Token payload (decoded, not verified): {}", payload);
                }
            } catch (Exception e) {
                log.error("Cannot decode token payload: {}", e.getMessage());
            }

            log.error("Token verification returned null. Possible reasons:");
            log.error("1. Token đã hết hạn");
            log.error("2. Google Client ID không khớp. Valid audiences: {}", allClientIds);
            log.error("3. Token không phải từ Google OAuth2 (có thể là access_token thay vì id_token)");
            log.error("4. Token đã bị thu hồi");
            throw new ErrorException("Token Google không hợp lệ - verify trả về null");
        }

        log.info("Google token verified successfully for email: {}", token.getPayload().getEmail());
        return token.getPayload();
    }

    private User createNewGoogleUser(String email, String fullName, String avatar) {
        // Lấy role USER mặc định
        Role userRole = roleRepository.findByName("ROLE_USER")
                .orElseThrow(() -> new ErrorException("Không tìm thấy role USER"));

        User user = User.builder()
                .email(email)
                .name(fullName != null && !fullName.isEmpty() ? fullName : "Google User")
                .avatar(avatar)
                .password(passwordEncoder.encode("google-oauth2-" + System.currentTimeMillis()))
                .activated(true)
                .banned(false)
                .currentLevel(CEFRLevel.A1)
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

    private void saveUserToken(User user, String accessToken, String refreshToken) {
        var token = Token.builder()
                .user(user)
                .token(accessToken)
                .refreshToken(refreshToken)
                .expired(false)
                .revoked(false)
                .build();
        tokenRepository.save(token);
        log.info("Đã lưu token vào database cho user: {}", user.getEmail());
    }

    private void revokeAllUserTokens(User user) {
        var validUserTokens = tokenRepository.findAllByUserId(user.getId());
        if (validUserTokens.isEmpty())
            return;
        validUserTokens.forEach(token -> {
            token.setExpired(true);
            token.setRevoked(true);
        });
        tokenRepository.saveAll(validUserTokens);
        log.info("Đã thu hồi {} token cũ của user: {}", validUserTokens.size(), user.getEmail());
    }

}