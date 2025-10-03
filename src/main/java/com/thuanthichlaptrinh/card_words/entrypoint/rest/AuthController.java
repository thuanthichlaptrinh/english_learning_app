package com.thuanthichlaptrinh.card_words.entrypoint.rest;

import org.springframework.web.bind.annotation.*;

import com.thuanthichlaptrinh.card_words.core.usecase.AuthenticationService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.RegisterRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.RegisterResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping(path = "/api/v1/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication", description = "API xác thực và quản lý tài khoản")
public class AuthController {

    private final AuthenticationService authenticationService;

    @PostMapping("/register")
    @Operation(summary = "Đăng ký tài khoản mới", description = "Tạo tài khoản mới với email và tên. Mật khẩu sẽ được tự động tạo và gửi về email.")
    public ApiResponse<RegisterResponse> register(@Valid @RequestBody RegisterRequest request) {
        RegisterResponse response = authenticationService.register(request);

        return ApiResponse.<RegisterResponse>builder()
                .status("201")
                .message("Đăng ký thành công")
                .data(response)
                .build();
    }

}
