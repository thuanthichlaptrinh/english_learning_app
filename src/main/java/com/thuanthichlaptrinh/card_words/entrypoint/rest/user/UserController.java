package com.thuanthichlaptrinh.card_words.entrypoint.rest.user;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.thuanthichlaptrinh.card_words.core.usecase.user.UserService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.UpdateUserRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.UserProfileResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import java.security.Principal;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;

@RestController
@RequestMapping(path = "/api/v1/users")
@RequiredArgsConstructor
@Tag(name = "User", description = "API quản lý người dùng")
public class UserController {

    private final UserService userService;

    @GetMapping
    @Operation(summary = "Lấy thông tin profile", description = "Lấy thông tin cá nhân của user đang đăng nhập.", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<UserProfileResponse>> getUserProfile(Principal principal) {
        UserProfileResponse response = userService.getUserProfile(principal.getName());
        return ResponseEntity.ok(ApiResponse.success("Lấy thông tin thành công", response));
    }

    @PutMapping(consumes = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "Cập nhật thông tin profile", description = "Cập nhật thông tin cá nhân của user đang đăng nhập (name, gender, dateOfBirth, currentLevel).", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<UserProfileResponse>> updateUserProfile(
            Principal principal,
            @Valid @RequestBody UpdateUserRequest request) {
        UserProfileResponse response = userService.updateUserProfile(principal.getName(), request, null);
        return ResponseEntity.ok(ApiResponse.success("Cập nhật thông tin thành công", response));
    }

    @PutMapping(value = "/avatar", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "Cập nhật avatar", description = "Upload và cập nhật ảnh avatar của user.", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<UserProfileResponse>> updateAvatar(
            Principal principal,
            @Parameter(description = "File ảnh avatar (chấp nhận: jpg, jpeg, png, gif, webp)") @RequestPart(value = "avatar") MultipartFile avatarFile) {
        UserProfileResponse response = userService.updateUserProfile(principal.getName(), null, avatarFile);
        return ResponseEntity.ok(ApiResponse.success("Cập nhật avatar thành công", response));
    }

}