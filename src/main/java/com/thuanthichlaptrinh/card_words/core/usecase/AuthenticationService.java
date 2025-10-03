package com.thuanthichlaptrinh.card_words.core.usecase;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.thuanthichlaptrinh.card_words.common.constants.PatternConstants;
import com.thuanthichlaptrinh.card_words.common.constants.PredefinedRole;
import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.common.utils.PasswordGenerator;
import com.thuanthichlaptrinh.card_words.configuration.jwt.JwtService;
import com.thuanthichlaptrinh.card_words.core.domain.Role;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.RoleRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.TokenRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.RegisterRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.RegisterResponse;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthenticationService {
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final TokenRepository tokenRepository;
    private final EmailService emailService;

    private static final String ROLE_USER = PredefinedRole.USER;
    private static final Pattern EMAIL_PATTERN = Pattern.compile(PatternConstants.EMAIL_REGEX);

    @Value("${activation.expired-time}")
    private Long activationExpiredTime;

    @Value("${activation.resend-interval}")
    private Long activationResendInterval;

    @Transactional
    public RegisterResponse register(final RegisterRequest request) {
        log.info("Đăng ký tài khoản mới: {}", request.getEmail());

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
                .activated(true)
                .roles(roles)
                .status("ACTIVE")
                .build();

        user = userRepository.save(user);

        try {
            emailService.sendWelcomeEmailWithPassword(user.getEmail(), user.getName(), generatedPassword);
        } catch (Exception e) {
            log.warn("Không thể gửi email, nhưng user đã được tạo: {}", e.getMessage());
        }

        return RegisterResponse.builder()
                .email(user.getEmail())
                .name(user.getName())
                .message("Đăng ký thành công! Mật khẩu đã được gửi về email của bạn.")
                .build();
    }

    /**
     * Xác thực email với activation key
     */
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

    /**
     * Gửi lại email kích hoạt
     */
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

}
