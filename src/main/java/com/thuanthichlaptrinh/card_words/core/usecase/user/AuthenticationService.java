package com.thuanthichlaptrinh.card_words.core.usecase.user;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.thuanthichlaptrinh.card_words.common.constants.PatternConstants;
import com.thuanthichlaptrinh.card_words.common.constants.PredefinedRole;
import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.common.utils.PasswordGenerator;
import com.thuanthichlaptrinh.card_words.configuration.jwt.JwtService;
import com.thuanthichlaptrinh.card_words.core.domain.Role;
import com.thuanthichlaptrinh.card_words.core.domain.Token;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.service.redis.UserCacheService;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.RoleRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.TokenRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.auth.AuthenticationRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.auth.ForgotPasswordRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.auth.RefreshTokenRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.auth.RegisterRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.auth.AuthenticationResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.auth.ForgotPasswordResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.auth.RegisterResponse;
import com.thuanthichlaptrinh.card_words.common.enums.CEFRLevel;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthenticationService {
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final TokenRepository tokenRepository;
    private final EmailService emailService;
    private final UserCacheService userCacheService; // ← Thêm cache service

    private static final String ROLE_USER = PredefinedRole.USER;
    private static final Pattern EMAIL_PATTERN = Pattern.compile(PatternConstants.EMAIL_REGEX);

    @Value("${activation.expired-time}")
    private Long activationExpiredTime;

    @Value("${activation.resend-interval}")
    private Long activationResendInterval;

    @Transactional
    public RegisterResponse register(final RegisterRequest request) {
        if (!EMAIL_PATTERN.matcher(request.getEmail()).matches()) {
            throw new ErrorException("Email không hợp lệ");
        }

        if (userRepository.existsByEmail(request.getEmail())) {
            throw new ErrorException("Email đã được sử dụng");
        }

        Role userRole = roleRepository.findByName(ROLE_USER)
                .orElseThrow(() -> new ErrorException("Role USER không tồn tại"));

        String generatedPassword = PasswordGenerator.generatePassword(); // Tạo mật khẩu ngẫu nhiên

        Set<Role> roles = new HashSet<>();
        roles.add(userRole);

        User user = User.builder()
                .name(request.getName())
                .email(request.getEmail())
                .password(passwordEncoder.encode(generatedPassword))
                .avatar(null)
                .gender(request.getGender() != null ? request.getGender() : null)
                .dateOfBirth(request.getDateOfBirth())
                .currentLevel(request.getCurrentLevel() != null ? request.getCurrentLevel() : CEFRLevel.A1)
                .activated(true)
                .roles(roles)
                .status("ACTIVE")
                .build();

        user = userRepository.save(user);

        // ✅ Cache user ngay sau khi đăng ký
        cacheUserData(user);

        try {
            emailService.sendWelcomeEmailWithPassword(user.getEmail(), user.getName(), generatedPassword);
        } catch (Exception e) {
            log.warn("Không thể gửi email, nhưng user đã được tạo: {}", e.getMessage());
        }

        return RegisterResponse.builder()
                .email(user.getEmail())
                .name(user.getName())
                .avatar(user.getAvatar())
                .gender(user.getGender() != null ? user.getGender() : null)
                .dateOfBirth(user.getDateOfBirth())
                .currentLevel(user.getCurrentLevel())
                .message("Đăng ký thành công! Mật khẩu đã được gửi về email của bạn.")
                .build();
    }

    @Transactional
    public AuthenticationResponse login(final AuthenticationRequest request) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword()));

        // ✅ Cache-aside pattern: Try cache first
        UUID cachedUserId = userCacheService.getUserIdByEmail(request.getEmail());

        User user;
        if (cachedUserId != null) {
            // Cache HIT - 5ms (Nhanh hơn 95%!)
            log.debug("✅ CACHE HIT: Email lookup for {}", request.getEmail());
            user = userRepository.findById(cachedUserId)
                    .orElseThrow(() -> new ErrorException("Email không tồn tại"));
        } else {
            // Cache MISS - 100ms (chỉ lần đầu)
            log.debug("⚠️ CACHE MISS: Email lookup for {}, querying DB...", request.getEmail());
            user = userRepository.findByEmail(request.getEmail())
                    .orElseThrow(() -> new ErrorException("Email không tồn tại"));

            // Cache email lookup cho lần sau
            userCacheService.cacheEmailToUserId(user.getEmail(), user.getId());
            log.debug("📝 Cached email lookup: {} -> {}", user.getEmail(), user.getId());
        }

        if (Boolean.TRUE.equals(user.getBanned())) {
            throw new ErrorException("Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.");
        }

        // Cache user profile nếu chưa có
        cacheUserData(user);

        // Mark user as online
        userCacheService.markUserOnline(user.getId());
        log.debug("✅ User online: {}, total online: {}",
                user.getId(), userCacheService.getOnlineUsersCount());

        var accessToken = jwtService.generateToken(Map.of(
                "authorities", authentication.getAuthorities().stream()
                        .map(GrantedAuthority::getAuthority)
                        .toList(),
                "userId", user.getId().toString(),
                "name", user.getName()),
                user);

        var refreshToken = jwtService.generateRefreshToken(user);

        revokeAllUserTokens(user.getId().toString());
        saveUserToken(user, accessToken, refreshToken);

        return AuthenticationResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
    }

    @Transactional
    public void logout() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()) {
            throw new ErrorException("Người dùng chưa đăng nhập");
        }

        String userEmail = authentication.getName();
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new ErrorException("Không tìm thấy người dùng"));

        revokeAllUserTokens(user.getId().toString()); // Thu hồi tất cả token của user

        // ✅ Mark user as offline
        userCacheService.markUserOffline(user.getId());
        log.debug("✅ User offline: {}, total online: {}",
                user.getId(), userCacheService.getOnlineUsersCount());

        SecurityContextHolder.clearContext();
        log.info("Đăng xuất thành công cho user: {}", userEmail);
    }

    // Xác thực email với activation key
    @Transactional
    public String verifyEmail(String activationKey) {
        log.info("Xác thực email với key: {}", activationKey);

        User user = userRepository.findByActivationKey(activationKey)
                .orElseThrow(() -> new ErrorException("Mã xác thực không hợp lệ"));

        if (user.getActivated()) {
            throw new ErrorException("Tài khoản đã được kích hoạt trước đó");
        }

        if (user.getActivationExpiredDate().isBefore(LocalDateTime.now())) {
            throw new ErrorException("Mã xác thực đã hết hạn. Vui lòng yêu cầu gửi lại email kích hoạt.");
        }

        user.setActivated(true);
        user.setActivationKey(null);
        user.setActivationExpiredDate(null);
        userRepository.save(user);

        log.info("Đã kích hoạt tài khoản: {}", user.getEmail());

        emailService.sendActivationSuccessEmail(user.getEmail(), user.getName());

        return "Kích hoạt tài khoản thành công! Bạn có thể đăng nhập ngay bây giờ.";
    }

    // Gửi lại email kích hoạt
    @Transactional
    public String resendActivationEmail(String email) {
        log.info("Gửi lại email kích hoạt cho: {}", email);

        // 1. Tìm user theo email
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ErrorException("Email không tồn tại"));

        // 2. Check user đã kích hoạt chưa
        if (user.getActivated()) {
            throw new ErrorException("Tài khoản đã được kích hoạt");
        }

        // 3. Check xem có đang trong thời gian chờ gửi lại không
        if (user.getActivationExpiredDate() != null) {
            LocalDateTime nextAllowedResend = user.getActivationExpiredDate()
                    .minusSeconds(activationExpiredTime / 1000)
                    .plusSeconds(activationResendInterval / 1000);

            if (LocalDateTime.now().isBefore(nextAllowedResend)) {
                throw new ErrorException("Vui lòng đợi " + activationResendInterval / 1000 / 60
                        + " phút trước khi gửi lại email");
            }
        }

        // 4. Tạo activation key mới
        String newActivationKey = UUID.randomUUID().toString();
        LocalDateTime newExpiredDate = LocalDateTime.now().plusSeconds(activationExpiredTime / 1000);

        user.setActivationKey(newActivationKey);
        user.setActivationExpiredDate(newExpiredDate);
        userRepository.save(user);

        log.info("Đã tạo activation key mới cho: {}", email);

        // 5. Gửi email
        emailService.sendActivationEmail(user.getEmail(), user.getName(), newActivationKey);

        return "Email kích hoạt đã được gửi lại. Vui lòng kiểm tra hộp thư.";
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
    }

    public void revokeAllUserTokens(String userId) {
        var validUserTokens = tokenRepository.findAllByUserId(UUID.fromString(userId));
        if (validUserTokens.isEmpty())
            return;
        validUserTokens.forEach(
                token -> {
                    token.setExpired(true);
                    token.setRevoked(true);
                });
        tokenRepository.saveAll(validUserTokens);
    }

    // Xử lý quên mật khẩu - tạo mật khẩu mới và gửi về email
    @Transactional
    public ForgotPasswordResponse forgotPassword(final ForgotPasswordRequest request) {
        log.info("Xử lý quên mật khẩu cho email: {}", request.getEmail());

        if (!EMAIL_PATTERN.matcher(request.getEmail()).matches()) {
            throw new ErrorException("Email không hợp lệ");
        }

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new ErrorException("Email không tồn tại trong hệ thống"));

        if (Boolean.TRUE.equals(user.getBanned())) {
            throw new ErrorException("Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.");
        }

        // Tạo mật khẩu mới
        String newPassword = PasswordGenerator.generatePassword();

        // Cập nhật mật khẩu mới
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        // Thu hồi tất cả token hiện tại
        revokeAllUserTokens(user.getId().toString());

        // Gửi email với mật khẩu mới
        try {
            emailService.sendNewPasswordEmail(user.getEmail(), user.getName(), newPassword);
            log.info("Đã gửi mật khẩu mới về email: {}", user.getEmail());
        } catch (Exception e) {
            log.error("Lỗi khi gửi email mật khẩu mới: {}", e.getMessage());
            throw new ErrorException("Có lỗi xảy ra khi gửi email. Vui lòng thử lại sau.");
        }

        return ForgotPasswordResponse.builder()
                .email(user.getEmail())
                .message("Mật khẩu mới đã được gửi về email của bạn. Vui lòng kiểm tra hộp thư.")
                .build();
    }

    // Làm mới access token bằng refresh token
    @Transactional
    public AuthenticationResponse refreshToken(final RefreshTokenRequest request) {
        log.info("Làm mới token với refresh token");

        // Tìm token trong database
        Token storedToken = tokenRepository.findByRefreshToken(request.getRefreshToken())
                .orElseThrow(() -> new ErrorException("Refresh token không hợp lệ"));

        // Kiểm tra token đã bị thu hồi hoặc hết hạn chưa
        if (storedToken.getExpired() || storedToken.getRevoked()) {
            throw new ErrorException("Refresh token đã hết hạn hoặc bị thu hồi");
        }

        // Lấy user từ token
        User user = storedToken.getUser();

        // Kiểm tra refresh token có hợp lệ không
        if (!jwtService.isTokenValid(request.getRefreshToken(), user)) {
            throw new ErrorException("Refresh token không hợp lệ");
        }

        // Tạo access token mới
        var newAccessToken = jwtService.generateToken(Map.of(
                "authorities", user.getAuthorities().stream()
                        .map(authority -> authority.getAuthority())
                        .toList(),
                "userId", user.getId().toString(),
                "name", user.getName()),
                user);

        // Tạo refresh token mới
        var newRefreshToken = jwtService.generateRefreshToken(user);

        // Thu hồi token cũ
        storedToken.setExpired(true);
        storedToken.setRevoked(true);
        tokenRepository.save(storedToken);

        // Lưu token mới
        saveUserToken(user, newAccessToken, newRefreshToken);

        log.info("Đã làm mới token thành công cho user: {}", user.getEmail());

        return AuthenticationResponse.builder()
                .accessToken(newAccessToken)
                .refreshToken(newRefreshToken)
                .build();
    }

    // ==================== Helper Methods for Caching ====================

    /**
     * Cache user data (profile + email lookup)
     * Called after register and login to ensure cache is fresh
     */
    private void cacheUserData(User user) {
        try {
            // Cache email -> userId mapping (CRITICAL for authentication performance)
            userCacheService.cacheEmailToUserId(user.getEmail(), user.getId());

            // Cache user profile
            Map<String, String> profileFields = new java.util.HashMap<>();
            profileFields.put("id", user.getId().toString());
            profileFields.put("email", user.getEmail());
            profileFields.put("name", user.getName());
            profileFields.put("avatar", user.getAvatar() != null ? user.getAvatar() : "");
            profileFields.put("currentLevel", user.getCurrentLevel() != null ? user.getCurrentLevel().name() : "A1");
            profileFields.put("banned", String.valueOf(user.getBanned() != null && user.getBanned()));
            profileFields.put("activated", String.valueOf(user.getActivated() != null && user.getActivated()));

            if (user.getCurrentStreak() != null) {
                profileFields.put("currentStreak", String.valueOf(user.getCurrentStreak()));
            }
            if (user.getLongestStreak() != null) {
                profileFields.put("longestStreak", String.valueOf(user.getLongestStreak()));
            }
            if (user.getCreatedAt() != null) {
                profileFields.put("createdAt", user.getCreatedAt().toString());
            }

            userCacheService.cacheUserProfile(user.getId(), profileFields);

            log.debug("📝 Cached user data: email={}, userId={}", user.getEmail(), user.getId());
        } catch (Exception e) {
            log.error("❌ Error caching user data for {}: {}", user.getEmail(), e.getMessage());
            // Don't throw - caching failure shouldn't break authentication
        }
    }

}
