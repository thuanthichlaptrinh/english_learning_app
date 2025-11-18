package com.thuanthichlaptrinh.card_words.configuration.websocket;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

/**
 * WebSocket configuration for real-time notifications
 * 
 * Endpoints:
 * - /ws: WebSocket connection endpoint (with SockJS fallback)
 * 
 * Message destinations:
 * - /topic/*: Broadcast messages (e.g., /topic/notifications for all users)
 * - /queue/*: Personal messages (e.g., /queue/notifications for specific user)
 * - /app/*: Application destination prefix for client messages
 */
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        // Enable simple in-memory message broker
        // /topic for broadcasting, /queue for point-to-point
        config.enableSimpleBroker("/topic", "/queue");

        // Prefix for messages bound for @MessageMapping methods
        config.setApplicationDestinationPrefixes("/app");

        // Prefix for user-specific destinations
        config.setUserDestinationPrefix("/user");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // Register WebSocket endpoint that clients will connect to
        registry.addEndpoint("/ws")
                .setAllowedOriginPatterns("*") // Allow all origins (configure properly in production)
                .withSockJS(); // Enable SockJS fallback for browsers that don't support WebSocket
    }
}
