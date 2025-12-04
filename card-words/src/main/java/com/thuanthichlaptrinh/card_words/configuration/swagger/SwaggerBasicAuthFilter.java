package com.thuanthichlaptrinh.card_words.configuration.swagger;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

/**
 * Filter để bảo vệ Swagger UI và API docs bằng Basic Authentication
 */
@Slf4j
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class SwaggerBasicAuthFilter extends OncePerRequestFilter {

    @Value("${swagger.auth.username:cardwords_admin}")
    private String username;

    @Value("${swagger.auth.password:Cw@Swagger2025!}")
    private String password;

    @Override
    protected void doFilterInternal(HttpServletRequest request, 
                                    HttpServletResponse response, 
                                    FilterChain filterChain) throws ServletException, IOException {
        
        String requestURI = request.getRequestURI();
        
        // Chỉ áp dụng cho Swagger endpoints
        if (isSwaggerPath(requestURI)) {
            String authHeader = request.getHeader("Authorization");
            
            if (!isAuthenticated(authHeader)) {
                log.warn("Unauthorized access attempt to Swagger: {} from IP: {}", 
                        requestURI, request.getRemoteAddr());
                
                response.setHeader("WWW-Authenticate", "Basic realm=\"Swagger API Documentation\"");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(
                        "{\"status\":401,\"message\":\"Vui lòng đăng nhập để truy cập Swagger UI\",\"data\":null}");
                return;
            }
        }
        
        filterChain.doFilter(request, response);
    }

    /**
     * Kiểm tra xem request có phải là Swagger path không
     */
    private boolean isSwaggerPath(String uri) {
        return uri.contains("/swagger-ui") || 
               uri.contains("/v3/api-docs") || 
               uri.contains("/swagger-resources") ||
               uri.contains("/swagger-ui.html");
    }

    /**
     * Xác thực Basic Auth credentials
     */
    private boolean isAuthenticated(String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Basic ")) {
            return false;
        }

        try {
            String base64Credentials = authHeader.substring("Basic ".length()).trim();
            byte[] decodedBytes = Base64.getDecoder().decode(base64Credentials);
            String credentials = new String(decodedBytes, StandardCharsets.UTF_8);
            
            // Format: username:password
            String[] values = credentials.split(":", 2);
            if (values.length != 2) {
                return false;
            }

            String inputUsername = values[0];
            String inputPassword = values[1];

            return username.equals(inputUsername) && password.equals(inputPassword);
        } catch (Exception e) {
            log.error("Error decoding Basic Auth credentials: {}", e.getMessage());
            return false;
        }
    }
}
