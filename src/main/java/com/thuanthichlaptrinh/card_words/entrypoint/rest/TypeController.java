package com.thuanthichlaptrinh.card_words.entrypoint.rest;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.thuanthichlaptrinh.card_words.core.usecase.TypeService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateTypeRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.TypeResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping(path = "/api/v1/types")
@RequiredArgsConstructor
@Tag(name = "Type", description = "API quản lý loại từ")
public class TypeController {

    private final TypeService typeService;

    @PostMapping
    @Operation(summary = "Tạo loại từ mới", description = "Tạo một loại từ mới (noun, verb, adjective...)", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<TypeResponse>> createType(@Valid @RequestBody CreateTypeRequest request) {
        TypeResponse response = typeService.createType(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Tạo loại từ thành công", response));
    }

    @GetMapping
    @Operation(summary = "Lấy danh sách loại từ", description = "Lấy danh sách tất cả loại từ")
    public ResponseEntity<ApiResponse<List<TypeResponse>>> getAllTypes() {
        List<TypeResponse> response = typeService.getAllTypes();
        return ResponseEntity.ok(ApiResponse.success("Lấy danh sách loại từ thành công", response));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Lấy thông tin loại từ", description = "Lấy thông tin chi tiết một loại từ theo ID")
    public ResponseEntity<ApiResponse<TypeResponse>> getTypeById(@PathVariable Long id) {
        TypeResponse response = typeService.getTypeById(id);
        return ResponseEntity.ok(ApiResponse.success("Lấy thông tin loại từ thành công", response));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Xóa loại từ", description = "Xóa một loại từ theo ID", security = @SecurityRequirement(name = "Bearer Authentication"))
    public ResponseEntity<ApiResponse<Void>> deleteType(@PathVariable Long id) {
        typeService.deleteType(id);
        return ResponseEntity.ok(ApiResponse.success("Xóa loại từ thành công", null));
    }
}