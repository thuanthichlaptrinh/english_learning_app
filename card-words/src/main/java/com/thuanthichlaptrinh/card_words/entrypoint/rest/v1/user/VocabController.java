package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.thuanthichlaptrinh.card_words.core.usecase.user.VocabService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.vocab.VocabMediaUrlResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.vocab.VocabResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping(path = "/api/v1/vocabs")
@RequiredArgsConstructor
@Tag(name = "Vocabulary", description = "API quản lý từ vựng")
public class VocabController {

    private final VocabService vocabService;

    @GetMapping("/{id}")
    @Operation(summary = "Lấy từ vựng theo ID", description = "Lấy thông tin chi tiết của một từ vựng theo ID.")
    public ResponseEntity<ApiResponse<VocabResponse>> getVocabById(
            @Parameter(description = "ID của từ vựng") @PathVariable UUID id) {
        VocabResponse response = vocabService.getVocabById(id);
        return ResponseEntity.ok(ApiResponse.success("Lấy thông tin từ vựng thành công", response));
    }

    @GetMapping("/word/{word}")
    @Operation(summary = "Lấy từ vựng theo từ", description = "Lấy thông tin chi tiết của một từ vựng theo từ khóa.")
    public ResponseEntity<ApiResponse<VocabResponse>> getVocabByWord(
            @Parameter(description = "Từ vựng cần tìm") @PathVariable String word) {
        VocabResponse response = vocabService.getVocabByWord(word);
        return ResponseEntity.ok(ApiResponse.success("Lấy thông tin từ vựng thành công", response));
    }

    @GetMapping
    @Operation(summary = "Lấy danh sách từ vựng", description = "Lấy danh sách tất cả từ vựng với phân trang.")
    public ResponseEntity<ApiResponse<Page<VocabResponse>>> getAllVocabs(
            @Parameter(description = "Số trang (bắt đầu từ 0)") @RequestParam(defaultValue = "0") int page,
            @Parameter(description = "Kích thước trang") @RequestParam(defaultValue = "20") int size,
            @Parameter(description = "Sắp xếp theo trường") @RequestParam(defaultValue = "createdAt") String sortBy,
            @Parameter(description = "Hướng sắp xếp (asc/desc)") @RequestParam(defaultValue = "desc") String sortDir) {

        Sort sort = sortDir.equalsIgnoreCase("desc") ? Sort.by(sortBy).descending() : Sort.by(sortBy).ascending();
        Pageable pageable = PageRequest.of(page, size, sort);

        Page<VocabResponse> response = vocabService.getAllVocabs(pageable);
        return ResponseEntity.ok(ApiResponse.success("Lấy danh sách từ vựng thành công", response));
    }

    @GetMapping("/search")
    @Operation(summary = "Tìm kiếm từ vựng", description = "Tìm kiếm từ vựng theo từ khóa trong từ hoặc nghĩa.")
    public ResponseEntity<ApiResponse<Page<VocabResponse>>> searchVocabs(
            @Parameter(description = "Từ khóa tìm kiếm") @RequestParam String keyword,
            @Parameter(description = "Số trang (bắt đầu từ 0)") @RequestParam(defaultValue = "0") int page,
            @Parameter(description = "Kích thước trang") @RequestParam(defaultValue = "20") int size) {

        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<VocabResponse> response = vocabService.searchVocabs(keyword, pageable);
        return ResponseEntity.ok(ApiResponse.success("Tìm kiếm từ vựng thành công", response));
    }

    @GetMapping("/cefr/{cefr}")
    @Operation(summary = "Lấy từ vựng theo CEFR", description = "Lấy danh sách từ vựng theo mức độ CEFR.")
    public ResponseEntity<ApiResponse<Page<VocabResponse>>> getVocabsByCefr(
            @Parameter(description = "Mức CEFR (A1, A2, B1, B2, C1, C2)") @PathVariable String cefr,
            @Parameter(description = "Số trang (bắt đầu từ 0)") @RequestParam(defaultValue = "0") int page,
            @Parameter(description = "Kích thước trang") @RequestParam(defaultValue = "20") int size) {

        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<VocabResponse> response = vocabService.getVocabsByCefr(cefr, pageable);
        return ResponseEntity.ok(ApiResponse.success("Lấy từ vựng theo CEFR thành công", response));
    }

    @GetMapping("/{id}/media")
    @Operation(summary = "Lấy URL hình ảnh và âm thanh của từ vựng", description = "Lấy URL của hình ảnh và file âm thanh cho một từ vựng cụ thể")
    public ResponseEntity<ApiResponse<VocabMediaUrlResponse>> getVocabMediaUrls(
            @Parameter(description = "ID của từ vựng") @PathVariable UUID id) {
        VocabMediaUrlResponse response = vocabService.getVocabMediaUrls(id);
        return ResponseEntity.ok(ApiResponse.success("Lấy media URLs thành công", response));
    }

    @GetMapping("/word/{word}/media")
    @Operation(summary = "Lấy URL hình ảnh và âm thanh theo từ", description = "Lấy URL của hình ảnh và file âm thanh cho một từ vựng cụ thể bằng từ khóa")
    public ResponseEntity<ApiResponse<VocabMediaUrlResponse>> getVocabMediaUrlsByWord(
            @Parameter(description = "Từ vựng cần tìm") @PathVariable String word) {
        VocabMediaUrlResponse response = vocabService.getVocabMediaUrlsByWord(word);
        return ResponseEntity.ok(ApiResponse.success("Lấy media URLs thành công", response));
    }

}