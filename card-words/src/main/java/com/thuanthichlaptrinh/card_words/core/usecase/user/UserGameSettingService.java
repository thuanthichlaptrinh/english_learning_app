package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.common.enums.CEFRLevel;
import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.domain.UserGameSetting;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserGameSettingRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.game.UpdateGameSettingRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game.GameSettingResponse;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserGameSettingService {

    private final UserGameSettingRepository userGameSettingRepository;
    private final UserRepository userRepository;

    @Transactional
    public GameSettingResponse updateGameSetting(UUID userId, UpdateGameSettingRequest request) {
        log.info("Updating game settings for user: {}", userId);

        // ⭐ Optional: Double-check validation
        validateGameSettings(request);

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ErrorException("User không tồn tại"));

        // Tìm hoặc tạo mới setting
        UserGameSetting setting = userGameSettingRepository
                .findByUserId(userId)
                .orElseGet(() -> {
                    UserGameSetting newSetting = new UserGameSetting();
                    newSetting.setUser(user);
                    return newSetting;
                });

        // Chỉ cập nhật các trường có dữ liệu
        if (request.getQuickQuizTotalQuestions() != null) {
            setting.setQuickQuizTotalQuestions(request.getQuickQuizTotalQuestions());
        }
        if (request.getQuickQuizTimePerQuestion() != null) {
            setting.setQuickQuizTimePerQuestion(request.getQuickQuizTimePerQuestion());
        }
        if (request.getImageWordTotalPairs() != null) {
            setting.setImageWordTotalPairs(request.getImageWordTotalPairs());
        }
        if (request.getWordDefinitionTotalPairs() != null) {
            setting.setWordDefinitionTotalPairs(request.getWordDefinitionTotalPairs());
        }

        setting = userGameSettingRepository.save(setting);

        return mapToResponse(setting);
    }

    public GameSettingResponse getGameSetting(UUID userId) {
        log.info("Getting game settings for user: {}", userId);

        return userGameSettingRepository
                .findByUserId(userId)
                .map(this::mapToResponse)
                .orElseGet(this::getDefaultSetting);
    }

    private GameSettingResponse mapToResponse(UserGameSetting setting) {
        return GameSettingResponse.builder()
                .quickQuizTotalQuestions(
                        setting.getQuickQuizTotalQuestions() != null ? setting.getQuickQuizTotalQuestions() : 10)
                .quickQuizTimePerQuestion(
                        setting.getQuickQuizTimePerQuestion() != null ? setting.getQuickQuizTimePerQuestion() : 3)
                .imageWordTotalPairs(setting.getImageWordTotalPairs() != null ? setting.getImageWordTotalPairs() : 5)
                .wordDefinitionTotalPairs(
                        setting.getWordDefinitionTotalPairs() != null ? setting.getWordDefinitionTotalPairs() : 5)
                .build();
    }

    private GameSettingResponse getDefaultSetting() {
        return GameSettingResponse.builder()
                .quickQuizTotalQuestions(10)
                .quickQuizTimePerQuestion(3)
                .imageWordTotalPairs(5)
                .wordDefinitionTotalPairs(5)
                .build();
    }

    // Helper methods để lấy setting cho auto-start game
    public Integer getQuickQuizTotalQuestions(UUID userId) {
        return userGameSettingRepository
                .findByUserId(userId)
                .map(s -> s.getQuickQuizTotalQuestions() != null ? s.getQuickQuizTotalQuestions() : 10)
                .orElse(10);
    }

    public Integer getQuickQuizTimePerQuestion(UUID userId) {
        return userGameSettingRepository
                .findByUserId(userId)
                .map(s -> s.getQuickQuizTimePerQuestion() != null ? s.getQuickQuizTimePerQuestion() : 3)
                .orElse(3);
    }

    public Integer getImageWordTotalPairs(UUID userId) {
        return userGameSettingRepository
                .findByUserId(userId)
                .map(s -> s.getImageWordTotalPairs() != null ? s.getImageWordTotalPairs() : 5)
                .orElse(5);
    }

    public Integer getWordDefinitionTotalPairs(UUID userId) {
        return userGameSettingRepository
                .findByUserId(userId)
                .map(s -> s.getWordDefinitionTotalPairs() != null ? s.getWordDefinitionTotalPairs() : 5)
                .orElse(5);
    }

    public String getUserCEFR(UUID userId) {
        return userRepository.findById(userId)
                .map(User::getCurrentLevel)
                .map(CEFRLevel::name)
                .orElse(null);
    }

    /**
     * Validate game settings (double-check)
     */
    private void validateGameSettings(UpdateGameSettingRequest request) {
        if (request.getQuickQuizTotalQuestions() != null) {
            if (request.getQuickQuizTotalQuestions() < 2 || request.getQuickQuizTotalQuestions() > 40) {
                throw new ErrorException("Quick Quiz total questions phải trong khoảng 2-40");
            }
        }
        if (request.getQuickQuizTimePerQuestion() != null) {
            if (request.getQuickQuizTimePerQuestion() < 3 || request.getQuickQuizTimePerQuestion() > 60) {
                throw new ErrorException("Quick Quiz time per question phải trong khoảng 3-60 giây");
            }
        }
        if (request.getImageWordTotalPairs() != null) {
            if (request.getImageWordTotalPairs() < 2 || request.getImageWordTotalPairs() > 5) {
                throw new ErrorException("Image Word total pairs phải trong khoảng 2-5");
            }
        }
        if (request.getWordDefinitionTotalPairs() != null) {
            if (request.getWordDefinitionTotalPairs() < 2 || request.getWordDefinitionTotalPairs() > 5) {
                throw new ErrorException("Word Definition total pairs phải trong khoảng 2-5");
            }
        }
    }
}
