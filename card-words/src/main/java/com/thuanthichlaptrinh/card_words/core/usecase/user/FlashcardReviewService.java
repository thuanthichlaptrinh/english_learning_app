package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.domain.UserVocabProgress;
import com.thuanthichlaptrinh.card_words.core.domain.Vocab;
import com.thuanthichlaptrinh.card_words.core.usecase.admin.ActionLogService;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserVocabProgressRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.VocabRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.ReviewFlashcardRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.FlashcardResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ReviewResultResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ReviewSessionResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class FlashcardReviewService {

    private final UserVocabProgressRepository userVocabProgressRepository;
    private final VocabRepository vocabRepository;
    private final NotificationService notificationService;
    private final ActionLogService actionLogService;
    private final CEFRUpgradeService cefrUpgradeService;

    // Get all flashcards due for review today
    @Transactional(readOnly = true)
    public ReviewSessionResponse getDueFlashcards(User user, Integer limit) {
        log.info("Getting due flashcards for user: {}, limit: {}", user.getId(), limit);

        LocalDate today = LocalDate.now();

        // Lấy tất cả từ đến hạn (chưa cắt) để tính tổng thực tế
        List<UserVocabProgress> allDueProgress = userVocabProgressRepository.findDueForReview(user.getId(), today);
        int totalDue = allDueProgress.size();

        // Đếm số từ đã ôn tập hôm nay
        long reviewedToday = userVocabProgressRepository.countReviewedToday(user.getId(), today);

        // Apply limit nếu có
        List<UserVocabProgress> dueProgress = allDueProgress;
        if (limit != null && limit > 0 && totalDue > limit) {
            dueProgress = allDueProgress.subList(0, limit);
        }

        List<FlashcardResponse> flashcards = dueProgress.stream()
                .map(this::mapToFlashcardResponse)
                .collect(Collectors.toList());

        // Tính số còn lại = tổng - số đã trả về trong response này
        int remaining = Math.max(0, totalDue - dueProgress.size());

        return ReviewSessionResponse.builder()
                .totalDueCards(totalDue)
                .reviewedToday((int) reviewedToday)
                .remainingCards(remaining)
                .flashcards(flashcards)
                .build();
    }

    /**
     * Get a single flashcard by vocab ID
     */
    @Transactional(readOnly = true)
    public FlashcardResponse getFlashcard(User user, UUID vocabId) {
        log.info("Getting flashcard for user: {}, vocab: {}", user.getId(), vocabId);

        UserVocabProgress progress = userVocabProgressRepository
                .findByUserIdAndVocabId(user.getId(), vocabId)
                .orElseGet(() -> {
                    // Create new progress if not exists
                    Vocab vocab = vocabRepository.findById(vocabId)
                            .orElseThrow(() -> new ErrorException("Vocab not found with id: " + vocabId));

                    UserVocabProgress newProgress = UserVocabProgress.builder()
                            .user(user)
                            .vocab(vocab)
                            .status(VocabStatus.KNOWN) // Flashcard review → KNOWN
                            .efFactor(2.5)
                            .intervalDays(1)
                            .repetition(0)
                            .timesCorrect(0)
                            .timesWrong(0)
                            .nextReviewDate(LocalDate.now())
                            .build();

                    return userVocabProgressRepository.save(newProgress);
                });

        return mapToFlashcardResponse(progress);
    }

    /**
     * Submit review and update progress using SM-2 algorithm
     */
    @Transactional
    public ReviewResultResponse submitReview(User user, ReviewFlashcardRequest request) {
        log.info("Submitting review for user: {}, vocab: {}, quality: {}",
                user.getId(), request.getVocabId(), request.getQuality());

        // Get or create progress
        UserVocabProgress progress = userVocabProgressRepository
                .findByUserIdAndVocabId(user.getId(), request.getVocabId())
                .orElseGet(() -> {
                    Vocab vocab = vocabRepository.findById(request.getVocabId())
                            .orElseThrow(() -> new ErrorException("Vocab not found with id: " + request.getVocabId()));

                    return UserVocabProgress.builder()
                            .user(user)
                            .vocab(vocab)
                            .status(VocabStatus.KNOWN) // Flashcard review là ôn tập → mặc định KNOWN
                            .efFactor(2.5)
                            .intervalDays(1)
                            .repetition(0)
                            .timesCorrect(0)
                            .timesWrong(0)
                            .nextReviewDate(LocalDate.now())
                            .build();
                });

        // Update progress using SM-2 algorithm
        updateProgressWithSM2(progress, request.getQuality());

        // Save updated progress
        progress = userVocabProgressRepository.save(progress);

        // Send notification for review completion
        sendFlashcardReviewNotification(user, request.getQuality(), progress);

        // ✅ Log action: FLASHCARD_REVIEW
        try {
            actionLogService.logAction(
                    user.getId(),
                    user.getEmail(),
                    user.getName(),
                    "FLASHCARD_REVIEW",
                    "LEARNING",
                    "Flashcard Review",
                    progress.getVocab().getId().toString(),
                    "Reviewed flashcard: " + progress.getVocab().getWord() + " with quality " + request.getQuality(),
                    "SUCCESS",
                    null,
                    null);
        } catch (Exception e) {
            log.warn("Failed to log action: {}", e.getMessage());
        }

        try {
            boolean upgraded = cefrUpgradeService.checkAndUpgradeCEFR(user.getId());
            if (upgraded) {
                log.info("🎉 User {} CEFR level upgraded after Flashcard Review!", user.getId());
            }
        } catch (Exception e) {
            log.error("❌ Failed to check CEFR upgrade: {}", e.getMessage(), e);
        }

        // Get remaining due cards
        int remainingDue = userVocabProgressRepository
                .findDueForReview(user.getId(), LocalDate.now()).size();

        String message = generateReviewMessage(request.getQuality(), progress.getIntervalDays());

        return ReviewResultResponse.builder()
                .id(progress.getVocab().getId())
                .word(progress.getVocab().getWord())
                .quality(request.getQuality())
                .timesCorrect(progress.getTimesCorrect())
                .timesWrong(progress.getTimesWrong())
                .repetition(progress.getRepetition())
                .efFactor(progress.getEfFactor())
                .intervalDays(progress.getIntervalDays())
                .nextReviewDate(progress.getNextReviewDate())
                .status(progress.getStatus())
                .remainingDueCards(remainingDue)
                .totalReviewedToday(0) // Can be tracked separately
                .message(message)
                .build();
    }

    /**
     * SM-2 Algorithm Implementation
     * Based on SuperMemo 2 algorithm
     * 
     * Quality ratings:
     * - 5: Perfect response, no hesitation
     * - 4: Correct response after hesitation
     * - 3: Correct response with difficulty
     * - 2: Incorrect response, but upon seeing answer it was easy to recall
     * - 1: Incorrect response, but upon seeing answer it seemed familiar
     * - 0: Complete blackout, no recall
     */
    private void updateProgressWithSM2(UserVocabProgress progress, int quality) {
        // Update review date
        progress.setLastReviewed(LocalDate.now());

        // Update correct/wrong counts
        if (quality >= 3) {
            progress.setTimesCorrect(progress.getTimesCorrect() + 1);
        } else {
            progress.setTimesWrong(progress.getTimesWrong() + 1);
        }

        // Calculate new interval and repetition
        int newInterval;
        int newRepetition;
        double currentEF = progress.getEfFactor();

        if (quality < 3) {
            // Incorrect response - reset repetition but keep EF unchanged (SM-2 standard)
            newRepetition = 0;
            newInterval = 1;
            progress.setStatus(VocabStatus.UNKNOWN);
            // Note: EF is NOT updated when quality < 3 (per original SM-2)
        } else {
            // Correct response - update EF and calculate new interval
            // SM-2 EF formula: EF' = EF + (0.1 - (5-q) * (0.08 + (5-q) * 0.02))
            double newEF = currentEF + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));

            // EF should not be less than 1.3
            if (newEF < 1.3) {
                newEF = 1.3;
            }
            progress.setEfFactor(newEF);
            currentEF = newEF;

            newRepetition = progress.getRepetition() + 1;

            if (newRepetition == 1) {
                newInterval = 1;
                progress.setStatus(VocabStatus.KNOWN);
            } else if (newRepetition == 2) {
                newInterval = 6;
                progress.setStatus(VocabStatus.KNOWN);
            } else {
                // For repetition >= 3: interval = previous_interval * EF
                newInterval = (int) Math.round(progress.getIntervalDays() * currentEF);

                // Ensure minimum interval of 1 day
                if (newInterval < 1) {
                    newInterval = 1;
                }

                // Mark as MASTERED if interval is greater than 21 days
                if (newInterval > 21) {
                    progress.setStatus(VocabStatus.MASTERED);
                } else {
                    progress.setStatus(VocabStatus.KNOWN);
                }
            }
        }

        progress.setRepetition(newRepetition);
        progress.setIntervalDays(newInterval);
        progress.setNextReviewDate(LocalDate.now().plusDays(newInterval));

        log.info("SM-2 Update - Quality: {}, EF: {:.2f}, Repetition: {}, Interval: {} days, Next: {}, Status: {}",
                quality, currentEF, newRepetition, newInterval, progress.getNextReviewDate(), progress.getStatus());
    }

    /**
     * Generate encouraging message based on quality rating
     */
    private String generateReviewMessage(int quality, int intervalDays) {
        String message;
        switch (quality) {
            case 5:
                message = "Perfect! 🌟 You'll see this again in " + intervalDays + " day(s).";
                break;
            case 4:
                message = "Great job! 👍 Review scheduled in " + intervalDays + " day(s).";
                break;
            case 3:
                message = "Good! Keep practicing. Next review in " + intervalDays + " day(s).";
                break;
            case 2:
                message = "Almost there! 💪 You'll review this soon.";
                break;
            case 1:
                message = "Don't worry, practice makes perfect! 📚";
                break;
            case 0:
                message = "Let's review this again tomorrow! 🎯";
                break;
            default:
                message = "Review submitted successfully!";
        }
        return message;
    }

    /**
     * Map UserVocabProgress to FlashcardResponse
     */
    private FlashcardResponse mapToFlashcardResponse(UserVocabProgress progress) {
        Vocab vocab = progress.getVocab();
        return FlashcardResponse.builder()
                .id(vocab.getId())
                .word(vocab.getWord())
                .transcription(vocab.getTranscription())
                .meaningVi(vocab.getMeaningVi())
                .interpret(vocab.getInterpret())
                .exampleSentence(vocab.getExampleSentence())
                .img(vocab.getImg())
                .audio(vocab.getAudio())
                .cefr(vocab.getCefr())
                .lastReviewed(progress.getLastReviewed())
                .nextReviewDate(progress.getNextReviewDate())
                .timesCorrect(progress.getTimesCorrect())
                .timesWrong(progress.getTimesWrong())
                .repetition(progress.getRepetition())
                .efFactor(progress.getEfFactor())
                .intervalDays(progress.getIntervalDays())
                .status(progress.getStatus())
                .build();
    }

    /**
     * Send notification for flashcard review performance
     */
    private void sendFlashcardReviewNotification(User user, int quality, UserVocabProgress progress) {
        try {
            // Send notification for excellent performance (quality 3 or higher)
            if (quality >= 3) {
                String qualityText = quality == 5 ? "Hoàn Hảo" : "Xuất Sắc";
                com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest request = com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateNotificationRequest
                        .builder()
                        .userId(user.getId())
                        .title(String.format("🌟 %s!", qualityText))
                        .content(String.format("Bạn đã nhớ từ '%s' rất tốt! Độ khó hiện tại: %.2f",
                                progress.getVocab().getWord(), progress.getEfFactor()))
                        .type(com.thuanthichlaptrinh.card_words.common.constants.NotificationConstants.STUDY_PROGRESS)
                        .build();
                notificationService.createNotification(request);
            }
        } catch (Exception e) {
            log.error("❌ Failed to send flashcard review notification: {}", e.getMessage(), e);
        }
    }
}
