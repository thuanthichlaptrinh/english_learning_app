package com.thuanthichlaptrinh.card_words.entrypoint.rest.user;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.thuanthichlaptrinh.card_words.core.usecase.user.AuthenticationService;
import com.thuanthichlaptrinh.card_words.core.usecase.user.GoogleOAuth2Service;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.AuthenticationRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.ForgotPasswordRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.GoogleAuthRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.RefreshTokenRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.RegisterRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.AuthenticationResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ForgotPasswordResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.GoogleAuthResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.RegisterResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping(path = "/api/v1/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication", description = "API xác thực và quản lý tài khoản")
public class AuthController {

    private final AuthenticationService authenticationService;
    private final GoogleOAuth2Service googleOAuth2Service;

    @PostMapping("/signup")
    @Operation(summary = "Đăng ký tài khoản", description = "Tạo tài khoản mới với email và tên. Mật khẩu sẽ được tự động tạo và gửi về email.")
    public ResponseEntity<ApiResponse<RegisterResponse>> register(@Valid @RequestBody RegisterRequest request) {
        RegisterResponse response = authenticationService.register(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Đăng ký thành công", response));
    }

    @PostMapping("/signin")
    @Operation(summary = "Đăng nhập", description = "Đăng nhập bằng email và mật khẩu.")
    public ResponseEntity<ApiResponse<AuthenticationResponse>> login(
            @Valid @RequestBody AuthenticationRequest request) {
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
            @Valid @RequestBody ForgotPasswordRequest request) {
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
