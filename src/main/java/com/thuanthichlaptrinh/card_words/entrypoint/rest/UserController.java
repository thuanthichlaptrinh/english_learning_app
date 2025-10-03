package com.thuanthichlaptrinh.card_words.entrypoint.rest;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.thuanthichlaptrinh.card_words.core.usecase.UserService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.UpdateUserRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.UserProfileResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import java.security.Principal;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;

@RestController
@RequestMapping(path = "/api/v1/users")
@RequiredArgsConstructor
@Tag(name = "User", description = "API quản lý người dùng")
public class UserController {

    private final UserService userService;

    @GetMapping("/profile")
    @Operation(summary = "Lấy thông tin profile", description = "Lấy thông tin cá nhân của user đang đăng nhập.", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<UserProfileResponse>> getUserProfile(Principal principal) {
        UserProfileResponse response = userService.getUserProfile(principal.getName());
        return ResponseEntity.ok(ApiResponse.success("Lấy thông tin thành công", response));
    }

    @PutMapping("/profile")
    @Operation(summary = "Cập nhật thông tin profile", description = "Cập nhật thông tin cá nhân của user đang đăng nhập.", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<UserProfileResponse>> updateUserProfile(
            Principal principal,
            @Valid @RequestBody UpdateUserRequest request) {
        UserProfileResponse response = userService.updateUserProfile(principal.getName(), request);
        return ResponseEntity.ok(ApiResponse.success("Cập nhật thông tin thành công", response));
    }

}
