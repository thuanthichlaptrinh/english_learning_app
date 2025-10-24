package com.thuanthichlaptrinh.card_words.configuration;

import java.util.HashSet;
import java.util.Set;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import com.thuanthichlaptrinh.card_words.core.domain.Role;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.RoleRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class DataInitializer {
    private final RoleRepository roleRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @PostConstruct
    public void initData() {
        initRoles();
        // initAdminAccounts();
    }

    private void initRoles() {
        createRoleIfNotExists("ROLE_ADMIN", "Quản trị hệ thống");
        createRoleIfNotExists("ROLE_USER", "Người dùng");
    }

    // private void initAdminAccounts() {
    // createAdminIfNotExists("admin1@cardwords.com", "Quản trị viên 1");
    // createAdminIfNotExists("admin2@cardwords.com", "Quản trị viên 2");
    // createAdminIfNotExists("admin3@cardwords.com", "Quản trị viên 3");
    // }

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

    private void createAdminIfNotExists(String email, String name) {
        userRepository.findByEmail(email).ifPresentOrElse(
                user -> {
                    // Admin account already exists
                },
                () -> {
                    // Get ADMIN and USER roles
                    Role adminRole = roleRepository.findByName("ROLE_ADMIN")
                            .orElseThrow(() -> new RuntimeException("ROLE_ADMIN not found"));
                    Role userRole = roleRepository.findByName("ROLE_USER")
                            .orElseThrow(() -> new RuntimeException("ROLE_USER not found"));

                    Set<Role> roles = new HashSet<>();
                    roles.add(adminRole);
                    roles.add(userRole);

                    // Create admin user with default password "Admin@123"
                    User adminUser = User.builder()
                            .email(email)
                            .name(name)
                            .password(passwordEncoder.encode("Admin@123"))
                            .activated(true)
                            .banned(false)
                            .roles(roles)
                            .build();

                    userRepository.save(adminUser);
                    System.out.println("Đã tạo admin account: " + email + " (mật khẩu: Admin@123)");
                });
    }
}
