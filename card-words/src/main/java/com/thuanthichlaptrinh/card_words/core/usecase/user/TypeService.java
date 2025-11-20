package com.thuanthichlaptrinh.card_words.core.usecase.user;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.Type;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.TypeRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateTypeRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.UpdateTypeRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.UpdateMultipleTypesRequest;
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

    @Transactional
    public TypeResponse updateType(Long id, UpdateTypeRequest request) {
        log.info("Cập nhật loại từ: {}, tên mới: {}", id, request.getName());

        Type type = typeRepository.findById(id)
                .orElseThrow(() -> new ErrorException("Không tìm thấy loại từ với ID: " + id));

        // Kiểm tra tên mới có trùng với type khác không
        if (!type.getName().equals(request.getName()) && typeRepository.existsByName(request.getName())) {
            throw new ErrorException("Tên loại từ đã tồn tại: " + request.getName());
        }

        type.setName(request.getName());
        type = typeRepository.save(type);

        log.info("Đã cập nhật loại từ thành công: {}", type.getName());

        return TypeResponse.builder()
                .id(type.getId())
                .name(type.getName())
                .build();
    }

    @Transactional
    public List<TypeResponse> updateMultipleTypes(UpdateMultipleTypesRequest request) {
        log.info("Cập nhật nhiều loại từ, số lượng: {}", request.getTypes().size());

        List<TypeResponse> responses = new java.util.ArrayList<>();

        for (UpdateMultipleTypesRequest.TypeUpdateItem item : request.getTypes()) {
            Type type = typeRepository.findById(item.getId())
                    .orElseThrow(() -> new ErrorException("Không tìm thấy loại từ với ID: " + item.getId()));

            // Kiểm tra tên mới có trùng với type khác không
            if (!type.getName().equals(item.getName()) && typeRepository.existsByName(item.getName())) {
                throw new ErrorException("Tên loại từ đã tồn tại: " + item.getName());
            }

            type.setName(item.getName());
            type = typeRepository.save(type);

            responses.add(TypeResponse.builder()
                    .id(type.getId())
                    .name(type.getName())
                    .build());
        }

        log.info("Đã cập nhật {} loại từ thành công", responses.size());

        return responses;
    }

}