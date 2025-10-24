package com.thuanthichlaptrinh.card_words.entrypoint.rest.user;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.thuanthichlaptrinh.card_words.core.usecase.user.TypeService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.TypeResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping(path = "/api/v1/types")
@RequiredArgsConstructor
@Tag(name = "Type", description = "API quản lý loại từ")
public class TypeController {

    private final TypeService typeService;

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

}