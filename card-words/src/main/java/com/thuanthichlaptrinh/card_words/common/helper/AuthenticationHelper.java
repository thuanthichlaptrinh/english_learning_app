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
            log.error("Authentication or principal is null");
            throw new RuntimeException("Unable to get user ID: not authenticated");
        }

        Object principal = authentication.getPrincipal();

        if (!(principal instanceof UserDetails)) {
            log.error("Principal is not an instance of UserDetails: {}", principal.getClass().getName());
            throw new RuntimeException("Unable to get user ID: invalid principal type");
        }

        UserDetails userDetails = (UserDetails) principal;

        if (!(userDetails instanceof User)) {
            log.error("UserDetails is not an instance of User: {}", userDetails.getClass().getName());
            throw new RuntimeException("Unable to get user ID: invalid user type");
        }

        User user = (User) userDetails;
        UUID userId = user.getId();

        log.debug("Extracted user ID from authentication: {}", userId);
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
            log.error("Authentication or principal is null");
            throw new RuntimeException("Unable to get user: not authenticated");
        }

        Object principal = authentication.getPrincipal();

        if (!(principal instanceof UserDetails)) {
            log.error("Principal is not an instance of UserDetails: {}", principal.getClass().getName());
            throw new RuntimeException("Unable to get user: invalid principal type");
        }

        UserDetails userDetails = (UserDetails) principal;

        if (!(userDetails instanceof User)) {
            log.error("UserDetails is not an instance of User: {}", userDetails.getClass().getName());
            throw new RuntimeException("Unable to get user: invalid user type");
        }

        User user = (User) userDetails;
        log.debug("Extracted user from authentication: email={}, id={}", user.getEmail(), user.getId());
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
