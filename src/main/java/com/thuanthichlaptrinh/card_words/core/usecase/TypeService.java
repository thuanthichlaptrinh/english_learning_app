package com.thuanthichlaptrinh.card_words.core.usecase;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.Type;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.TypeRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateTypeRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.TypeResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class TypeService {

    private final TypeRepository typeRepository;

    @Transactional
    public TypeResponse createType(CreateTypeRequest request) {
        log.info("Tạo loại từ mới: {}", request.getName());

        // Kiểm tra trùng tên
        if (typeRepository.existsByName(request.getName())) {
            throw new ErrorException("Loại từ đã tồn tại: " + request.getName());
        }

        Type type = Type.builder()
                .name(request.getName())
                .build();

        type = typeRepository.save(type);

        log.info("Đã tạo loại từ thành công: {}", type.getName());

        return TypeResponse.builder()
                .id(type.getId())
                .name(type.getName())
                .build();
    }

    public List<TypeResponse> getAllTypes() {
        log.info("Lấy danh sách tất cả loại từ");

        return typeRepository.findAll().stream()
                .map(type -> TypeResponse.builder()
                        .id(type.getId())
                        .name(type.getName())
                        .build())
                .collect(Collectors.toList());
    }

    public TypeResponse getTypeById(Long id) {
        log.info("Lấy thông tin loại từ: {}", id);

        Type type = typeRepository.findById(id)
                .orElseThrow(() -> new ErrorException("Không tìm thấy loại từ với ID: " + id));

        return TypeResponse.builder()
                .id(type.getId())
                .name(type.getName())
                .build();
    }

    @Transactional
    public void deleteType(Long id) {
        log.info("Xóa loại từ: {}", id);

        if (!typeRepository.existsById(id)) {
            throw new ErrorException("Không tìm thấy loại từ với ID: " + id);
        }

        typeRepository.deleteById(id);
        log.info("Đã xóa loại từ thành công: {}", id);
    }
}