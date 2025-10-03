package com.thuanthichlaptrinh.card_words.configuration;

import org.springframework.stereotype.Component;

import com.thuanthichlaptrinh.card_words.core.domain.Role;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.RoleRepository;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class DataInitializer {
    private final RoleRepository roleRepository;

    @PostConstruct
    public void initRoles() {
        createRoleIfNotExists("ROLE_ADMIN", "Quản trị hệ thống");
        createRoleIfNotExists("ROLE_USER", "Người dùng");
    }

    private void createRoleIfNotExists(String roleName, String description) {
        roleRepository.findByName(roleName).ifPresentOrElse(
                role -> {
                },
                () -> {
                    Role role = Role.builder()
                            .name(roleName)
                            .description(description)
                            .build();
                    roleRepository.save(role);
                    System.out.println("Đã tạo role: " + roleName);
                });
    }
}
