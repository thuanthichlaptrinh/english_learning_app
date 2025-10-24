package com.thuanthichlaptrinh.card_words.configuration;

import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import com.thuanthichlaptrinh.card_words.configuration.jwt.JwtAuthenticationFilter;

import lombok.RequiredArgsConstructor;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@RequiredArgsConstructor
public class SecurityConfiguration {
        private static final String[] WHITE_LIST_URL = {
                        "/login/oauth2/**",
                        "/api/v1/auth/signin",
                        "/api/v1/auth/signup",
                        "/api/v1/auth/google",
                        "/api/v1/auth/forgot-password",
                        "/api/v1/auth/refresh-token",
                        "/favicon.ico",
                        "/static/**",
                        "/css/**",
                        "/js/**",
                        "/images/**",
                        "/webjars/**",
                        "/v2/api-docs",
                        "/v3/api-docs",
                        "/v3/api-docs/**",
                        "/swagger-resources",
                        "/swagger-resources/**",
                        "/configuration/ui",
                        "/configuration/security",
                        "/swagger-ui/**",
                        "/swagger-ui.html",
                        "/swagger-ui.html/**",
                        "/swagger-ui/index.html/**",
                        "/api-test.html",
                        "/google-test.html",
                        "https://accounts.google.com/signin/oauth2/**",
                        "https://developers.google.com/oauthplayground/**"
        };
        private final JwtAuthenticationFilter jwtAuthFilter;
        private final AuthenticationProvider authenticationProvider;

        @Bean
        public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
                http.csrf(AbstractHttpConfigurer::disable)
                                .authorizeHttpRequests(req -> req.requestMatchers(WHITE_LIST_URL).permitAll()
                                                .anyRequest()
                                                .authenticated())
                                .cors(cors -> cors.configurationSource(
                                                request -> {
                                                        CorsConfiguration configuration = new CorsConfiguration();
                                                        configuration.setAllowedOrigins(List.of("*"));
                                                        configuration.setAllowedMethods(List.of("*"));
                                                        configuration.setAllowedHeaders(List.of("*"));
                                                        return configuration;
                                                }))
                                .sessionManagement(session -> session
                                                .sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                                .authenticationProvider(authenticationProvider)
                                .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class)
                                .exceptionHandling(exceptionHandling -> exceptionHandling
                                                .authenticationEntryPoint((request, response, authException) -> {
                                                        response.setStatus(HttpStatus.FORBIDDEN.value());
                                                        response.setContentType("application/json");
                                                        response.getWriter()
                                                                        .write("{\"status\":\"403\",\"message\":\"Access Denied\",\"data\":null}");
                                                })
                                                .accessDeniedHandler((request, response, accessDeniedException) -> {
                                                        response.setStatus(HttpStatus.FORBIDDEN.value());
                                                        response.setContentType("application/json");
                                                        response.getWriter()
                                                                        .write("{\"status\":\"403\",\"message\":\"Access Denied\",\"data\":null}");
                                                }))
                                .logout(AbstractHttpConfigurer::disable);

                return http.build();
        }

        @Bean
        public CorsFilter corsFilter() {
                final UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
                final CorsConfiguration config = new CorsConfiguration();
                config.addAllowedOrigin("*");
                config.addAllowedHeader("*");
                config.addAllowedMethod("*");
                source.registerCorsConfiguration("/**", config);
                return new CorsFilter(source);
        }
}
