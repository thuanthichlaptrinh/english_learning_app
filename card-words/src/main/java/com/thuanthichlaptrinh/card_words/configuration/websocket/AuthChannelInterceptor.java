package com.thuanthichlaptrinh.card_words.configuration.websocket;

import com.thuanthichlaptrinh.card_words.configuration.jwt.JwtService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.messaging.support.MessageHeaderAccessor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Component;

/**
 * Interceptor to authenticate WebSocket connections using JWT token
 * 
 * Flow:
 * 1. Client sends CONNECT frame with Authorization header
 * 2. Extract JWT token from header
 * 3. Validate token and load user details
 * 4. Set user principal in WebSocket session
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class AuthChannelInterceptor implements ChannelInterceptor {

    private final JwtService jwtService;
    private final UserDetailsService userDetailsService;

    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {
        StompHeaderAccessor accessor = MessageHeaderAccessor.getAccessor(message, StompHeaderAccessor.class);

        if (accessor != null && StompCommand.CONNECT.equals(accessor.getCommand())) {
            // Get Authorization header from WebSocket handshake
            String authHeader = accessor.getFirstNativeHeader("Authorization");

            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                String token = authHeader.substring(7);

                try {
                    // Extract username from JWT token
                    String username = jwtService.extractUsername(token);

                    if (username != null) {
                        // Load user details
                        UserDetails userDetails = userDetailsService.loadUserByUsername(username);

                        // Validate token
                        if (jwtService.isTokenValid(token, userDetails)) {
                            // Create authentication token
                            UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                                    userDetails,
                                    null,
                                    userDetails.getAuthorities());

                            // Set user principal in WebSocket session
                            accessor.setUser(authentication);

                            log.info("WebSocket authenticated for user: {}", username);
                        } else {
                            log.warn("Invalid JWT token for WebSocket connection");
                        }
                    }
                } catch (Exception e) {
                    log.error("WebSocket authentication error: {}", e.getMessage());
                }
            } else {
                log.warn("WebSocket connection without Authorization header");
            }
        }

        return message;
    }
}
