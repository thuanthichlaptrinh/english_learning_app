package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import java.time.Duration;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.service.redis.RateLimitingService;
import com.thuanthichlaptrinh.card_words.core.service.redis.RateLimitingService.RateLimitResult;
import com.thuanthichlaptrinh.card_words.core.usecase.user.AuthenticationService;
import com.thuanthichlaptrinh.card_words.core.usecase.user.GoogleOAuth2Service;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.auth.AuthenticationRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.auth.ForgotPasswordRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.auth.GoogleAuthRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.auth.RefreshTokenRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.auth.RegisterRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.auth.AuthenticationResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.auth.ForgotPasswordResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.auth.GoogleAuthResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.auth.RegisterResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping(path = "/api/v1/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication", description = "API xác thực và quản lý tài khoản")
public class AuthController {

        private final AuthenticationService authenticationService;
        private final GoogleOAuth2Service googleOAuth2Service;
        private final RateLimitingService rateLimitingService;

        // Rate limiting configurations
        private static final int MAX_LOGIN_ATTEMPTS = 5;
        private static final Duration LOGIN_WINDOW = Duration.ofMinutes(15);
        private static final int MAX_REGISTER_ATTEMPTS = 3;
        private static final Duration REGISTER_WINDOW = Duration.ofHours(1);
        private static final int MAX_FORGOT_PASSWORD_ATTEMPTS = 3;
        private static final Duration FORGOT_PASSWORD_WINDOW = Duration.ofHours(1);

        @PostMapping("/signup")
        @Operation(summary = "Đăng ký tài khoản", description = "Tạo tài khoản mới với email và tên. Mật khẩu sẽ được tự động tạo và gửi về email.")
        public ResponseEntity<ApiResponse<RegisterResponse>> register(
                        @Valid @RequestBody RegisterRequest request,
                        HttpServletRequest httpRequest) {

                // Check rate limit by email
                RateLimitResult rateLimitResult = rateLimitingService.checkCustomRateLimit(
                                request.getEmail(), "register", MAX_REGISTER_ATTEMPTS, REGISTER_WINDOW);

                if (!rateLimitResult.isAllowed()) {
                        log.warn("Register rate limit exceeded for email: {}", request.getEmail());
                        throw new ErrorException(
                                        String.format("Too many registration attempts. Please try again in %d seconds.",
                                                        rateLimitResult.getResetInSeconds()));
                }

                RegisterResponse response = authenticationService.register(request);
                return ResponseEntity.status(HttpStatus.CREATED)
                                .body(ApiResponse.success("Đăng ký thành công", response));
        }

        @PostMapping("/signin")
        @Operation(summary = "Đăng nhập", description = "Đăng nhập bằng email và mật khẩu.")
        public ResponseEntity<ApiResponse<AuthenticationResponse>> login(
                        @Valid @RequestBody AuthenticationRequest request,
                        HttpServletRequest httpRequest) {

                // Check rate limit by email to prevent brute force attacks
                RateLimitResult rateLimitResult = rateLimitingService.checkCustomRateLimit(
                                request.getEmail(), "login", MAX_LOGIN_ATTEMPTS, LOGIN_WINDOW);

                if (!rateLimitResult.isAllowed()) {
                        log.warn("Login rate limit exceeded for email: {}", request.getEmail());
                        throw new ErrorException(
                                        String.format("Too many login attempts. Please try again in %d minutes.",
                                                        rateLimitResult.getResetInSeconds() / 60));
                }

                AuthenticationResponse response = authenticationService.login(request);
                return ResponseEntity.ok(ApiResponse.success("Đăng nhập thành công", response));
        }

        @PostMapping("/signout")
        @Operation(summary = "Đăng xuất", description = "Đăng xuất khỏi hệ thống.", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<Void>> logout() {
                authenticationService.logout();
                return ResponseEntity.ok(ApiResponse.success("Đăng xuất thành công", null));
        }

        @PostMapping("/forgot-password")
        @Operation(summary = "Quên mật khẩu", description = "Xử lý quên mật khẩu - tạo mật khẩu mới và gửi về email.")
        public ResponseEntity<ApiResponse<ForgotPasswordResponse>> forgotPassword(
                        @Valid @RequestBody ForgotPasswordRequest request,
                        HttpServletRequest httpRequest) {

                // Check rate limit to prevent email spam
                RateLimitResult rateLimitResult = rateLimitingService.checkCustomRateLimit(
                                request.getEmail(), "forgot-password", MAX_FORGOT_PASSWORD_ATTEMPTS,
                                FORGOT_PASSWORD_WINDOW);

                if (!rateLimitResult.isAllowed()) {
                        log.warn("Forgot password rate limit exceeded for email: {}", request.getEmail());
                        throw new ErrorException(
                                        String.format("Too many password reset requests. Please try again in %d minutes.",
                                                        rateLimitResult.getResetInSeconds() / 60));
                }

                ForgotPasswordResponse response = authenticationService.forgotPassword(request);
                return ResponseEntity.ok(ApiResponse.success("Đã gửi mật khẩu mới về email của bạn", response));
        }

        @PostMapping("/refresh-token")
        @Operation(summary = "Làm mới token", description = "Làm mới token truy cập bằng refresh token.")
        public ResponseEntity<ApiResponse<AuthenticationResponse>> refreshToken(
                        @Valid @RequestBody RefreshTokenRequest request) {
                AuthenticationResponse response = authenticationService.refreshToken(request);
                return ResponseEntity.ok(ApiResponse.success("Làm mới token thành công", response));
        }

        @PostMapping("/google")
        @Operation(summary = "Đăng nhập bằng Google", description = "Xác thực và đăng nhập bằng Google OAuth2 ID Token.")
        public ResponseEntity<ApiResponse<GoogleAuthResponse>> loginWithGoogle(
                        @Valid @RequestBody GoogleAuthRequest request) {
                GoogleAuthResponse response = googleOAuth2Service.authenticateWithGoogle(request.getIdToken());
                return ResponseEntity.ok(ApiResponse.success("Đăng nhập Google thành công", response));
        }

}
