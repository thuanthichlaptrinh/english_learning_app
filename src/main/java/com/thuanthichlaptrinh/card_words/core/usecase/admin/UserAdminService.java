package com.thuanthichlaptrinh.card_words.core.usecase.admin;

import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.Role;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.mapper.UserAdminMapper;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.RoleRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.user.UpdateRolesRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.UserAdminResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.UserStatisticsResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserAdminService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final UserAdminMapper userMapper;

    public Page<UserAdminResponse> getAllUsers(int page, int size, String sortBy, String sortDir) {
        log.info("Admin: Lấy danh sách người dùng - page: {}, size: {}, sortBy: {}, sortDir: {}",
                page, size, sortBy, sortDir);

        Sort sort = sortDir.equalsIgnoreCase("desc")
                ? Sort.by(sortBy).descending()
                : Sort.by(sortBy).ascending();
        Pageable pageable = PageRequest.of(page, size, sort);

        Page<User> users = userRepository.findAll(pageable);
        return users.map(userMapper::toUserAdminResponse);
    }

    public UserAdminResponse getUserById(UUID id) {
        log.info("Admin: Lấy thông tin người dùng theo ID: {}", id);

        User user = userRepository.findById(id)
                .orElseThrow(() -> new ErrorException("Không tìm thấy người dùng với ID: " + id));

        return userMapper.toUserAdminResponse(user);
    }

    public UserAdminResponse getUserByEmail(String email) {
        log.info("Admin: Lấy thông tin người dùng theo email: {}", email);

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ErrorException("Không tìm thấy người dùng với email: " + email));

        return userMapper.toUserAdminResponse(user);
    }

    public Page<UserAdminResponse> searchUsers(String keyword, int page, int size) {
        log.info("Admin: Tìm kiếm người dùng với keyword: {}", keyword);

        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<User> users = userRepository.findByNameContainingIgnoreCaseOrEmailContainingIgnoreCase(
                keyword, keyword, pageable);

        return users.map(userMapper::toUserAdminResponse);
    }

    @Transactional
    public UserAdminResponse toggleBanUser(UUID id, boolean banned) {
        log.info("Admin: {} tài khoản người dùng ID: {}", banned ? "Khóa" : "Mở khóa", id);

        User user = userRepository.findById(id)
                .orElseThrow(() -> new ErrorException("Không tìm thấy người dùng"));

        user.setBanned(banned);
        user = userRepository.save(user);

        return userMapper.toUserAdminResponse(user);
    }

    @Transactional
    public UserAdminResponse toggleActivateUser(UUID id, boolean activated) {
        log.info("Admin: {} tài khoản người dùng ID: {}", activated ? "Kích hoạt" : "Vô hiệu hóa", id);

        User user = userRepository.findById(id)
                .orElseThrow(() -> new ErrorException("Không tìm thấy người dùng"));

        user.setActivated(activated);
        user = userRepository.save(user);

        return userMapper.toUserAdminResponse(user);
    }

    @Transactional
    public UserAdminResponse updateUserRoles(UUID id, UpdateRolesRequest request) {
        log.info("Admin: Cập nhật role cho người dùng ID: {}", id);

        User user = userRepository.findById(id)
                .orElseThrow(() -> new ErrorException("Không tìm thấy người dùng"));

        user.getRoles().clear();

        for (String roleName : request.getRoleNames()) {
            Role role = roleRepository.findByName(roleName)
                    .orElseThrow(() -> new ErrorException("Không tìm thấy role: " + roleName));
            user.getRoles().add(role);
        }

        user = userRepository.save(user);

        return userMapper.toUserAdminResponse(user);
    }

    @Transactional
    public void deleteUser(UUID id) {
        log.info("Admin: Xóa người dùng ID: {}", id);

        if (!userRepository.existsById(id)) {
            throw new ErrorException("Không tìm thấy người dùng");
        }

        userRepository.deleteById(id);
    }

    public UserStatisticsResponse getUserStatistics() {
        log.info("Admin: Lấy thống kê người dùng");

        long totalUsers = userRepository.count();
        long activatedUsers = userRepository.countByActivated(true);
        long bannedUsers = userRepository.countByBanned(true);
        long adminUsers = userRepository.countByRoles_Name("ROLE_ADMIN");

        return UserStatisticsResponse.builder()
                .totalUsers(totalUsers)
                .activatedUsers(activatedUsers)
                .bannedUsers(bannedUsers)
                .adminUsers(adminUsers)
                .normalUsers(totalUsers - adminUsers)
                .build();
    }
}
