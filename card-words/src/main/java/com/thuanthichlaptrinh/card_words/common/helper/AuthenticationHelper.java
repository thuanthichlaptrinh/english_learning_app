package com.thuanthichlaptrinh.card_words.common.helper;

import com.thuanthichlaptrinh.card_words.core.domain.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Helper class for extracting user information from Spring Security
 * Authentication
 * Reduces code duplication across controllers
 */
@Slf4j
@Component
public class AuthenticationHelper {

    /**
     * Extract user ID from Authentication object
     * 
     * @param authentication Spring Security Authentication
     * @return UUID of current user
     * @throws RuntimeException if unable to extract user ID
     */
    public UUID getCurrentUserId(Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            log.error("Xác thực hoặc principal là null");
            throw new RuntimeException("Không thể lấy user ID: chưa xác thực");
        }

        Object principal = authentication.getPrincipal();

        if (!(principal instanceof UserDetails)) {
            log.error("Principal không phải là UserDetails: {}", principal.getClass().getName());
            throw new RuntimeException("Không thể lấy user ID: loại principal không hợp lệ");
        }

        UserDetails userDetails = (UserDetails) principal;

        if (!(userDetails instanceof User)) {
            log.error("UserDetails không phải là User: {}", userDetails.getClass().getName());
            throw new RuntimeException("Không thể lấy user ID: loại user không hợp lệ");
        }

        User user = (User) userDetails;
        UUID userId = user.getId();

        log.debug("Đã lấy user ID từ xác thực: {}", userId);
        return userId;
    }

    /**
     * Extract full User object from Authentication
     * 
     * @param authentication Spring Security Authentication
     * @return Current User object
     * @throws RuntimeException if unable to extract user
     */
    public User getCurrentUser(Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            log.error("Xác thực hoặc principal là null");
            throw new RuntimeException("Không thể lấy user: chưa xác thực");
        }

        Object principal = authentication.getPrincipal();

        if (!(principal instanceof UserDetails)) {
            log.error("Principal không phải là UserDetails: {}", principal.getClass().getName());
            throw new RuntimeException("Không thể lấy user: loại principal không hợp lệ");
        }

        UserDetails userDetails = (UserDetails) principal;

        if (!(userDetails instanceof User)) {
            log.error("UserDetails không phải là User: {}", userDetails.getClass().getName());
            throw new RuntimeException("Không thể lấy user: loại user không hợp lệ");
        }

        User user = (User) userDetails;
        log.debug("Đã lấy user từ xác thực: email={}, id={}", user.getEmail(), user.getId());
        return user;
    }

    /**
     * Check if current user is authenticated
     * 
     * @param authentication Spring Security Authentication
     * @return true if authenticated, false otherwise
     */
    public boolean isAuthenticated(Authentication authentication) {
        return authentication != null &&
                authentication.isAuthenticated() &&
                authentication.getPrincipal() instanceof User;
    }

    /**
     * Get username (email) from Authentication
     * 
     * @param authentication Spring Security Authentication
     * @return Username/email of current user
     */
    public String getCurrentUsername(Authentication authentication) {
        User user = getCurrentUser(authentication);
        return user.getUsername(); // email
    }
}
