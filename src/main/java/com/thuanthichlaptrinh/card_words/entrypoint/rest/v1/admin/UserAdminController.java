package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.admin;

import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import com.thuanthichlaptrinh.card_words.core.usecase.admin.UserAdminService;
import com.thuanthichlaptrinh.card_words.common.constants.PredefinedRole;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.user.UpdateRolesRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.UserAdminResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.UserStatisticsResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping(path = "/api/v1/admin/users")
@RequiredArgsConstructor
@Tag(name = "User Admin", description = "API quản lý người dùng cho admin")
@PreAuthorize("hasRole('" + PredefinedRole.ADMIN + "')")
@SecurityRequirement(name = "Bearer Authentication")
public class UserAdminController {

        private final UserAdminService userAdminService;

        @GetMapping
        @Operation(summary = "[Admin] Lấy danh sách người dùng", description = "Lấy danh sách tất cả người dùng với phân trang và sắp xếp\n\n"
                        +
                        "**URL**: `GET http://localhost:8080/api/v1/admin/users?page=0&size=20&sortBy=createdAt&sortDir=desc`")
        public ResponseEntity<ApiResponse<Page<UserAdminResponse>>> getAllUsers(
                        @Parameter(description = "Số trang (bắt đầu từ 0)") @RequestParam(defaultValue = "0") int page,
                        @Parameter(description = "Kích thước trang") @RequestParam(defaultValue = "20") int size,
                        @Parameter(description = "Sắp xếp theo trường") @RequestParam(defaultValue = "createdAt") String sortBy,
                        @Parameter(description = "Hướng sắp xếp (asc/desc)") @RequestParam(defaultValue = "desc") String sortDir) {
                Page<UserAdminResponse> response = userAdminService.getAllUsers(page, size, sortBy, sortDir);
                return ResponseEntity.ok(ApiResponse.success("Lấy danh sách người dùng thành công", response));
        }

        @GetMapping("/{id}")
        @Operation(summary = "[Admin] Lấy thông tin người dùng theo ID", description = "Lấy thông tin chi tiết của một người dùng theo UUID\n\n"
                        +
                        "**URL**: `GET http://localhost:8080/api/v1/admin/users/{id}`\n\n" +
                        "**Example**: `GET http://localhost:8080/api/v1/admin/users/123e4567-e89b-12d3-a456-426614174000`")
        public ResponseEntity<ApiResponse<UserAdminResponse>> getUserById(
                        @Parameter(description = "ID của người dùng (UUID)") @PathVariable UUID id) {
                UserAdminResponse response = userAdminService.getUserById(id);
                return ResponseEntity.ok(ApiResponse.success("Lấy thông tin người dùng thành công", response));
        }

        @GetMapping("/email/{email}")
        @Operation(summary = "[Admin] Lấy thông tin người dùng theo email", description = "Lấy thông tin chi tiết của một người dùng theo email\n\n"
                        +
                        "**URL**: `GET http://localhost:8080/api/v1/admin/users/email/{email}`\n\n" +
                        "**Example**: `GET http://localhost:8080/api/v1/admin/users/email/user@example.com`")
        public ResponseEntity<ApiResponse<UserAdminResponse>> getUserByEmail(
                        @Parameter(description = "Email của người dùng") @PathVariable String email) {
                UserAdminResponse response = userAdminService.getUserByEmail(email);
                return ResponseEntity.ok(ApiResponse.success("Lấy thông tin người dùng thành công", response));
        }

        @GetMapping("/search")
        @Operation(summary = "[Admin] Tìm kiếm người dùng", description = "Tìm kiếm người dùng theo tên hoặc email\n\n"
                        +
                        "**URL**: `GET http://localhost:8080/api/v1/admin/users/search?keyword={keyword}&page=0&size=20`\n\n"
                        +
                        "**Example**: `GET http://localhost:8080/api/v1/admin/users/search?keyword=john&page=0&size=20`")
        public ResponseEntity<ApiResponse<Page<UserAdminResponse>>> searchUsers(
                        @Parameter(description = "Từ khóa tìm kiếm") @RequestParam String keyword,
                        @Parameter(description = "Số trang") @RequestParam(defaultValue = "0") int page,
                        @Parameter(description = "Kích thước trang") @RequestParam(defaultValue = "20") int size) {
                Page<UserAdminResponse> response = userAdminService.searchUsers(keyword, page, size);
                return ResponseEntity.ok(ApiResponse.success("Tìm kiếm người dùng thành công", response));
        }

        @PutMapping("/{id}/ban")
        @Operation(summary = "[Admin] Khóa tài khoản người dùng", description = "Khóa/mở khóa tài khoản người dùng\n\n"
                        +
                        "**URL**: `PUT http://localhost:8080/api/v1/admin/users/{id}/ban?banned={true|false}`\n\n" +
                        "**Example**: `PUT http://localhost:8080/api/v1/admin/users/123e4567-e89b-12d3-a456-426614174000/ban?banned=true`")
        public ResponseEntity<ApiResponse<UserAdminResponse>> toggleBanUser(
                        @Parameter(description = "ID người dùng") @PathVariable UUID id,
                        @Parameter(description = "true = khóa, false = mở khóa") @RequestParam boolean banned) {
                UserAdminResponse response = userAdminService.toggleBanUser(id, banned);
                String message = banned ? "Đã khóa tài khoản người dùng" : "Đã mở khóa tài khoản người dùng";
                return ResponseEntity.ok(ApiResponse.success(message, response));
        }

        @PutMapping("/{id}/activate")
        @Operation(summary = "[Admin] Kích hoạt tài khoản người dùng", description = "Kích hoạt/vô hiệu hóa tài khoản người dùng\n\n"
                        +
                        "**URL**: `PUT http://localhost:8080/api/v1/admin/users/{id}/activate?activated={true|false}`\n\n"
                        +
                        "**Example**: `PUT http://localhost:8080/api/v1/admin/users/123e4567-e89b-12d3-a456-426614174000/activate?activated=true`")
        public ResponseEntity<ApiResponse<UserAdminResponse>> toggleActivateUser(
                        @Parameter(description = "ID người dùng") @PathVariable UUID id,
                        @Parameter(description = "true = kích hoạt, false = vô hiệu hóa") @RequestParam boolean activated) {
                UserAdminResponse response = userAdminService.toggleActivateUser(id, activated);
                String message = activated ? "Đã kích hoạt tài khoản" : "Đã vô hiệu hóa tài khoản";
                return ResponseEntity.ok(ApiResponse.success(message, response));
        }

        @PutMapping("/{id}/roles")
        @Operation(summary = "[Admin] Cập nhật role cho người dùng", description = "Thêm hoặc xóa role của người dùng (ROLE_USER, ROLE_ADMIN)\n\n"
                        +
                        "**URL**: `PUT http://localhost:8080/api/v1/admin/users/{id}/roles`\n\n" +
                        "**Example**: `PUT http://localhost:8080/api/v1/admin/users/123e4567-e89b-12d3-a456-426614174000/roles`\n\n"
                        +
                        "**Body**: `{\"roleNames\": [\"ROLE_ADMIN\", \"ROLE_USER\"]}`")
        public ResponseEntity<ApiResponse<UserAdminResponse>> updateUserRoles(
                        @Parameter(description = "ID người dùng") @PathVariable UUID id,
                        @Valid @RequestBody UpdateRolesRequest request) {
                UserAdminResponse response = userAdminService.updateUserRoles(id, request);
                return ResponseEntity.ok(ApiResponse.success("Cập nhật role thành công", response));
        }

        @DeleteMapping("/{id}")
        @Operation(summary = "[Admin] Xóa người dùng", description = "Xóa vĩnh viễn người dùng khỏi hệ thống\n\n" +
                        "**URL**: `DELETE http://localhost:8080/api/v1/admin/users/{id}`\n\n" +
                        "**Example**: `DELETE http://localhost:8080/api/v1/admin/users/123e4567-e89b-12d3-a456-426614174000`")
        public ResponseEntity<ApiResponse<Void>> deleteUser(
                        @Parameter(description = "ID người dùng") @PathVariable UUID id) {
                userAdminService.deleteUser(id);
                return ResponseEntity.ok(ApiResponse.success("Xóa người dùng thành công", null));
        }

        @GetMapping("/statistics")
        @Operation(summary = "[Admin] Thống kê người dùng", description = "Lấy thống kê tổng quan về người dùng trong hệ thống\n\n"
                        +
                        "**URL**: `GET http://localhost:8080/api/v1/admin/users/statistics`")
        public ResponseEntity<ApiResponse<UserStatisticsResponse>> getUserStatistics() {
                UserStatisticsResponse stats = userAdminService.getUserStatistics();
                return ResponseEntity.ok(ApiResponse.success("Lấy thống kê thành công", stats));
        }

}
