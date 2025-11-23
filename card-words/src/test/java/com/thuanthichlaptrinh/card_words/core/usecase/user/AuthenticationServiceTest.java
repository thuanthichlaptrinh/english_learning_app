package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.common.constants.PredefinedRole;
import com.thuanthichlaptrinh.card_words.core.domain.Role;
import com.thuanthichlaptrinh.card_words.core.domain.Token;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.service.redis.UserCacheService;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.RoleRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.TokenRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.auth.AuthenticationRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.auth.AuthenticationResponse;
import com.thuanthichlaptrinh.card_words.configuration.jwt.JwtService;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.stream.StreamSupport;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthenticationServiceTest {

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private JwtService jwtService;

    @Mock
    private AuthenticationManager authenticationManager;

    @Mock
    private UserRepository userRepository;

    @Mock
    private RoleRepository roleRepository;

    @Mock
    private TokenRepository tokenRepository;

    @Mock
    private EmailService emailService;

    @Mock
    private UserCacheService userCacheService;

    @Mock
    private SimpMessagingTemplate messagingTemplate;

    @InjectMocks
    private AuthenticationService authenticationService;

    @AfterEach
    void clearSecurityContext() {
        SecurityContextHolder.clearContext();
    }

    @Test
    @DisplayName("CF-01: login caches user profile and issues tokens")
    void login_whenCacheMiss_shouldCacheProfileAndReturnTokens() {
        // Given
        String email = "learner@example.com";
        UUID userId = UUID.randomUUID();
        User user = buildUser(userId, email);

        AuthenticationRequest request = AuthenticationRequest.builder()
                .email(email)
                .password("secret123")
                .build();

        Authentication springAuth = new UsernamePasswordAuthenticationToken(
                email,
                request.getPassword(),
                List.of(new SimpleGrantedAuthority("ROLE_USER")));

        when(authenticationManager.authenticate(any())).thenReturn(springAuth);
        when(userCacheService.getUserIdByEmail(email)).thenReturn(null); // cache miss path
        when(userRepository.findByEmail(email)).thenReturn(Optional.of(user));
        when(jwtService.generateToken(any(Map.class), eq(user))).thenReturn("access-token");
        when(jwtService.generateRefreshToken(user)).thenReturn("refresh-token");
        when(jwtService.getExpirationTime()).thenReturn(3600L);
        when(tokenRepository.findAllByUserId(userId)).thenReturn(List.of(buildToken(user)));
        when(userRepository.findById(userId)).thenReturn(Optional.of(user));
        when(userCacheService.getOnlineUsersCount()).thenReturn(10L);

        // When
        AuthenticationResponse response = authenticationService.login(request);

        // Then
        assertThat(response.getAccessToken()).isEqualTo("access-token");
        assertThat(response.getRefreshToken()).isEqualTo("refresh-token");
        assertThat(response.getExpiresIn()).isEqualTo(3600L);

        verify(userCacheService, atLeastOnce()).cacheEmailToUserId(email, userId);
        ArgumentCaptor<Map<String, String>> profileCaptor = ArgumentCaptor.forClass(Map.class);
        verify(userCacheService).cacheUserProfile(eq(userId), profileCaptor.capture());
        assertThat(profileCaptor.getValue()).containsEntry("email", email);

        verify(tokenRepository).save(any(Token.class));
        verify(tokenRepository).saveAll(anyList());
        verify(userCacheService).markUserOnline(userId);
    }

    @Test
    @DisplayName("CF-02: login propagates authentication failure")
    void login_whenAuthenticationFails_shouldSurfaceException() {
        AuthenticationRequest request = AuthenticationRequest.builder()
                .email("learner@example.com")
                .password("wrongpass")
                .build();

        when(authenticationManager.authenticate(any()))
                .thenThrow(new BadCredentialsException("Bad credentials"));

        assertThatThrownBy(() -> authenticationService.login(request))
                .isInstanceOf(BadCredentialsException.class)
                .hasMessageContaining("Bad credentials");

        verifyNoInteractions(userRepository, userCacheService, jwtService);
    }

    @Test
    @DisplayName("CF-03: logout revokes tokens and clears security context")
    void logout_whenAuthenticated_shouldRevokeTokensAndMarkOffline() {
        String email = "learner@example.com";
        UUID userId = UUID.randomUUID();
        User user = buildUser(userId, email);

        Token existingToken = buildToken(user);
        when(userRepository.findByEmail(email)).thenReturn(Optional.of(user));
        when(tokenRepository.findAllByUserId(userId)).thenReturn(List.of(existingToken));

        Authentication auth = mock(Authentication.class);
        when(auth.isAuthenticated()).thenReturn(true);
        when(auth.getName()).thenReturn(email);

        SecurityContext context = SecurityContextHolder.createEmptyContext();
        context.setAuthentication(auth);
        SecurityContextHolder.setContext(context);

        // When
        authenticationService.logout();

        // Then
        verify(userCacheService).markUserOffline(userId);
        verify(tokenRepository).saveAll(argThat(tokens -> StreamSupport.stream(tokens.spliterator(), false)
                .allMatch(t -> Boolean.TRUE.equals(t.getExpired()) && Boolean.TRUE.equals(t.getRevoked()))));
        assertThat(SecurityContextHolder.getContext().getAuthentication()).isNull();
    }

        private User buildUser(UUID userId, String email) {
                Role role = Role.builder().name(PredefinedRole.USER).build();
                User user = User.builder()
                                .email(email)
                                .name("Learner")
                                .password("hashed")
                                .activated(true)
                                .banned(false)
                                .roles(Set.of(role))
                                .build();
                user.setId(userId);
                return user;
    }

    private Token buildToken(User user) {
        Token token = Token.builder()
                .user(user)
                .token("existing-token")
                .refreshToken("existing-refresh")
                .expired(false)
                .revoked(false)
                .build();
        token.setId(UUID.randomUUID());
        return token;
    }
}