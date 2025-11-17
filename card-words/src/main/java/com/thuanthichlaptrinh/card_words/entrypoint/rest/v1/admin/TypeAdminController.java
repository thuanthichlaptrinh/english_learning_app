package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.admin;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.thuanthichlaptrinh.card_words.core.usecase.user.TypeService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateTypeRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.TypeResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.parameters.RequestBody;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping(path = "/api/v1/admin/types")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ROLE_ADMIN')")
@SecurityRequirement(name = "Bearer Authentication")
@Tag(name = "Type Admin", description = "API quản lý loại từ cho admin")
public class TypeAdminController {
    private final TypeService typeService;

    @PostMapping
    @Operation(summary = "[Admin] Tạo loại từ mới", description = "Tạo một loại từ mới (noun, verb, adjective...)\n\n" +
            "**URL**: `POST http://localhost:8080/api/v1/admin/types`\n\n" +
            "**Body**: `{\"name\": \"noun\", \"description\": \"Danh từ\"}`", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<TypeResponse>> createType(@Valid @RequestBody CreateTypeRequest request) {
        TypeResponse response = typeService.createType(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Tạo loại từ thành công", response));
    }

    @GetMapping
    @Operation(summary = "[Admin] Lấy danh sách loại từ", description = "Lấy danh sách tất cả loại từ\n\n" +
            "**URL**: `GET http://localhost:8080/api/v1/admin/types`")
    public ResponseEntity<ApiResponse<List<TypeResponse>>> getAllTypes() {
        List<TypeResponse> response = typeService.getAllTypes();
        return ResponseEntity.ok(ApiResponse.success("Lấy danh sách loại từ thành công", response));
    }

    @GetMapping("/{id}")
    @Operation(summary = "[Admin] Lấy thông tin loại từ", description = "Lấy thông tin chi tiết một loại từ theo ID\n\n"
            +
            "**URL**: `GET http://localhost:8080/api/v1/admin/types/{id}`\n\n" +
            "**Example**: `GET http://localhost:8080/api/v1/admin/types/1`")
    public ResponseEntity<ApiResponse<TypeResponse>> getTypeById(@PathVariable Long id) {
        TypeResponse response = typeService.getTypeById(id);
        return ResponseEntity.ok(ApiResponse.success("Lấy thông tin loại từ thành công", response));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "[Admin] Xóa loại từ", description = "Xóa một loại từ theo ID\n\n" +
            "**URL**: `DELETE http://localhost:8080/api/v1/admin/types/{id}`\n\n" +
            "**Example**: `DELETE http://localhost:8080/api/v1/admin/types/1`", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<Void>> deleteType(@PathVariable Long id) {
        typeService.deleteType(id);
        return ResponseEntity.ok(ApiResponse.success("Xóa loại từ thành công", null));
    }
}
