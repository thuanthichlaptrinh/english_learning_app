package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.common.constants.NotificationConstants;
import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.Notification;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.NotificationRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.NotificationResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.messaging.simp.SimpMessagingTemplate;

import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class NotificationServiceTest {

    @Mock
    private NotificationRepository notificationRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private SimpMessagingTemplate messagingTemplate;

    @InjectMocks
    private NotificationService notificationService;

    @BeforeEach
    void setupDefaults() {
        // Mockito @InjectMocks khởi tạo service với các mock trên
    }

    @Test
    void createNotification_shouldPersistAndPublish() {
        UUID userId = UUID.randomUUID();
        User user = User.builder()
                .name("Tester")
                .email("tester@example.com")
                .password("secret")
                .build();
        user.setId(userId);

        CreateNotificationRequest request = CreateNotificationRequest.builder()
                .userId(userId)
                .title("Hello")
                .content("You have a reminder")
                .type(NotificationConstants.VOCAB_REMINDER)
                .build();

        when(userRepository.findById(userId)).thenReturn(Optional.of(user));
        when(notificationRepository.save(any(Notification.class))).thenAnswer(invocation -> {
            Notification saved = invocation.getArgument(0);
            saved.setId(1L);
            return saved;
        });

        NotificationResponse response = notificationService.createNotification(request);

        assertThat(response.getTitle()).isEqualTo("Hello");
        ArgumentCaptor<NotificationResponse> captor = ArgumentCaptor.forClass(NotificationResponse.class);
        verify(messagingTemplate).convertAndSendToUser(eq(userId.toString()), eq("/queue/notifications"), captor.capture());
        assertThat(captor.getValue().getContent()).isEqualTo("You have a reminder");
    }

    @Test
    void markAsRead_whenRepositoryReturnsZero_shouldThrow() {
        UUID userId = UUID.randomUUID();
        when(notificationRepository.markAsRead(1L, userId)).thenReturn(0);

        assertThatThrownBy(() -> notificationService.markAsRead(userId, 1L))
                .isInstanceOf(ErrorException.class)
                .hasMessageContaining("Không tìm thấy notification");

        verify(messagingTemplate, never()).convertAndSendToUser(anyString(), anyString(), any());
    }

    @Test
    void markAsRead_whenSuccess_shouldPublishWebSocketEvent() {
        UUID userId = UUID.randomUUID();
        when(notificationRepository.markAsRead(5L, userId)).thenReturn(1);

        notificationService.markAsRead(userId, 5L);

        verify(messagingTemplate).convertAndSendToUser(userId.toString(), "/queue/notifications/read", 5L);
    }

    @Test
    void deleteNotification_withDifferentOwner_shouldThrow() {
        UUID ownerId = UUID.randomUUID();
        UUID requestUserId = UUID.randomUUID();

        User owner = User.builder()
                .name("Owner")
                .email("owner@example.com")
                .password("secret")
                .build();
        owner.setId(ownerId);

        Notification notification = Notification.builder()
                .user(owner)
                .title("Title")
                .content("Content")
                .type(NotificationConstants.SYSTEM_ALERT)
                .build();
        notification.setId(99L);

        when(notificationRepository.findById(99L)).thenReturn(Optional.of(notification));

        assertThatThrownBy(() -> notificationService.deleteNotification(requestUserId, 99L))
                .isInstanceOf(ErrorException.class)
                .hasMessageContaining("Không có quyền xóa");

        verify(notificationRepository, never()).delete(any(Notification.class));
        verifyNoInteractions(messagingTemplate);
    }
}
