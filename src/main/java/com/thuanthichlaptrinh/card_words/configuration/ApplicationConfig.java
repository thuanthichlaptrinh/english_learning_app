package com.thuanthichlaptrinh.card_words.configuration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.client.RestTemplate;
import org.modelmapper.ModelMapper;

import com.thuanthichlaptrinh.card_words.common.exceptions.GlobalExceptionHandler;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;

@Configuration
public class ApplicationConfig {
    private final UserRepository userRepository;
    private final GlobalExceptionHandler globalExceptionHandler;

    public ApplicationConfig(
            UserRepository userRepository,
            GlobalExceptionHandler globalExceptionHandler) {
        this.userRepository = userRepository;
        this.globalExceptionHandler = globalExceptionHandler;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public UserDetailsService userDetailsService() {
        return username -> userRepository
                .findByEmailOrPhone(username)
                .orElseThrow(
                        () -> new org.springframework.security.core.userdetails.UsernameNotFoundException(
                                "User not found: " + username));
    }

    @Bean
    public AuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService());
        authProvider.setPasswordEncoder(passwordEncoder());
        return authProvider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config)
            throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }

    @Bean
    public ModelMapper modelMapper() {
        return new ModelMapper();
    }

}
