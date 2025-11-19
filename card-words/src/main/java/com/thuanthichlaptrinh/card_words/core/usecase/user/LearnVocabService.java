package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.domain.UserVocabProgress;
import com.thuanthichlaptrinh.card_words.core.domain.Vocab;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserVocabProgressRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.VocabRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.GetReviewVocabsRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.ReviewVocabRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.PagedReviewVocabResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ReviewResultResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ReviewVocabResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class LearnVocabService {

    private final UserVocabProgressRepository userVocabProgressRepository;
    private final VocabRepository vocabRepository;
    private final StreakService streakService;

    /**
     * Lấy danh sách từ vựng cần ôn tập với phân trang
     * - Có thể lọc theo topic
     * - Có thể lấy chỉ từ mới
     * - Có thể lấy chỉ từ đến hạn ôn tập
     */
    @Transactional(readOnly = true)
    public PagedReviewVocabResponse getReviewVocabsPaged(User user, GetReviewVocabsRequest request) {
        log.info("Getting paged review vocabs for user: {}, request: {}", user.getId(), request);

        // Convert 1-based page to 0-based for PageRequest
        int zeroBasedPage = Math.max(0, request.getPage() - 1);
        Pageable pageable = PageRequest.of(zeroBasedPage, request.getSize());

        Page<UserVocabProgress> progressPage;
        Page<Vocab> unlearnedPage = null;

        // Case 1: Lấy chỉ từ mới (từ CHƯA CÓ trong user_vocab_progress)
        if (Boolean.TRUE.equals(request.getOnlyNew())) {
            if (request.getTopicName() != null && !request.getTopicName().trim().isEmpty()) {
                // CHỈ lấy từ chưa học theo topic (không có trong user_vocab_progress)
                unlearnedPage = userVocabProgressRepository.findUnlearnedVocabsByTopicPaged(
                        user.getId(), request.getTopicName(), pageable);
            } else {
                // Lấy tất cả từ chưa học (không theo topic)
                unlearnedPage = userVocabProgressRepository.findAllUnlearnedVocabsPaged(
                        user.getId(), pageable);
            }
            // Tạo Page rỗng cho progressPage vì không cần lấy từ có status=NEW
            progressPage = Page.empty(pageable);
        }
        // Case 2: Lấy từ đang học (KNOWN hoặc UNKNOWN) - CHỈ dựa vào STATUS
        else if (Boolean.TRUE.equals(request.getOnlyDue())) {
            if (request.getTopicName() != null && !request.getTopicName().trim().isEmpty()) {
                // Từ đang học theo topic (KNOWN hoặc UNKNOWN)
                progressPage = userVocabProgressRepository.findLearningVocabsByTopicPaged(
                        user.getId(), request.getTopicName(), pageable);
            } else {
                // Tất cả từ đang học (KNOWN hoặc UNKNOWN)
                progressPage = userVocabProgressRepository.findLearningVocabsPaged(user.getId(), pageable);
            }
        }
        // Case 3: Lấy tất cả từ (mới + đang học)
        else {
            if (request.getTopicName() != null && !request.getTopicName().trim().isEmpty()) {
                // Ưu tiên lấy từ đang học (KNOWN/UNKNOWN) trước
                progressPage = userVocabProgressRepository.findLearningVocabsByTopicPaged(
                        user.getId(), request.getTopicName(), pageable);

                // Nếu không đủ, lấy thêm từ mới
                if (progressPage.getContent().size() < request.getSize()) {
                    int remaining = request.getSize() - progressPage.getContent().size();
                    Pageable newPageable = PageRequest.of(0, remaining);
                    unlearnedPage = userVocabProgressRepository.findUnlearnedVocabsByTopicPaged(
                            user.getId(), request.getTopicName(), newPageable);
                }
            } else {
                // Tất cả từ đang học
                progressPage = userVocabProgressRepository.findLearningVocabsPaged(user.getId(), pageable);
            }
        }

        // Map to response - Ưu tiên từ chưa học (unlearnedPage) trước
        List<ReviewVocabResponse> vocabs = new ArrayList<>();

        // Thêm từ chưa học trước (nếu có)
        if (unlearnedPage != null && !unlearnedPage.isEmpty()) {
            unlearnedPage.getContent().forEach(vocab -> vocabs.add(mapVocabToReviewResponse(vocab)));
        }

        // Sau đó mới thêm từ có status=NEW trong progress
        progressPage.getContent().stream()
                .map(this::mapToReviewVocabResponse)
                .forEach(vocabs::add);

        // Get stats
        ReviewStatsResponse stats = getReviewStats(user, request.getTopicName());

        // Tính tổng số elements (từ chưa học + từ có status=NEW)
        long totalElements = progressPage.getTotalElements();
        if (unlearnedPage != null) {
            totalElements += unlearnedPage.getTotalElements();
        }

        // Tính tổng số trang dựa trên totalElements
        int totalPages = (int) Math.ceil((double) totalElements / request.getSize());

        PagedReviewVocabResponse.PageMetadata meta = PagedReviewVocabResponse.PageMetadata.builder()
                .page(request.getPage())
                .pageSize(request.getSize())
                .totalItems(totalElements)
                .totalPages(totalPages)
                .hasNext(request.getPage() < totalPages - 1)
                .hasPrev(request.getPage() > 0)
                .newVocabs(stats.getNewVocabs())
                .learningVocabs(stats.getLearningVocabs())
                .masteredVocabs(stats.getMasteredVocabs())
                .dueVocabs(stats.getDueVocabs())
                .build();

        return PagedReviewVocabResponse.builder()
                .vocabs(vocabs)
                .meta(meta)
                .build();
    }

    /**
     * Lấy danh sách từ vựng cần ôn tập (non-paged - backward compatibility)
     * - Có thể lọc theo topic
     * - Có thể lấy chỉ từ mới
     * - Có thể lấy chỉ từ đến hạn ôn tập
     */
    @Transactional(readOnly = true)
    public List<ReviewVocabResponse> getReviewVocabs(User user, GetReviewVocabsRequest request) {
        log.info("Getting review vocabs for user: {}, request: {}", user.getId(), request);

        List<UserVocabProgress> progressList = new ArrayList<>();
        List<Vocab> unlearnedVocabs = new ArrayList<>();

        // Case 1: Lấy chỉ từ mới (chưa có trong user_vocab_progress)
        if (Boolean.TRUE.equals(request.getOnlyNew())) {
            if (request.getTopicName() != null && !request.getTopicName().trim().isEmpty()) {
                // Từ mới theo topic (chưa học)
                unlearnedVocabs = userVocabProgressRepository.findUnlearnedVocabsByTopic(user.getId(),
                        request.getTopicName());
            } else {
                // Tất cả từ mới (không có non-paged method cho tất cả từ chưa học)
                // Để trống - chỉ hỗ trợ theo topic
            }
        }
        // Case 2: Lấy từ đang học (KNOWN hoặc UNKNOWN) - CHỈ dựa vào STATUS
        else if (Boolean.TRUE.equals(request.getOnlyDue())) {
            if (request.getTopicName() != null && !request.getTopicName().trim().isEmpty()) {
                // Từ đang học theo topic (KNOWN hoặc UNKNOWN)
                progressList = userVocabProgressRepository.findLearningVocabsByTopic(user.getId(),
                        request.getTopicName());
            } else {
                // Tất cả từ đang học (KNOWN hoặc UNKNOWN)
                progressList = userVocabProgressRepository.findLearningVocabs(user.getId());
            }
        }
        // Case 3: Lấy tất cả từ (đang học + mới)
        else {
            if (request.getTopicName() != null && !request.getTopicName().trim().isEmpty()) {
                // Theo topic: từ đang học + từ chưa học
                progressList = userVocabProgressRepository.findLearningVocabsByTopic(
                        user.getId(), request.getTopicName());

                // Thêm từ chưa học
                unlearnedVocabs = userVocabProgressRepository.findUnlearnedVocabsByTopic(
                        user.getId(), request.getTopicName());
            } else {
                // Tất cả: từ đang học
                progressList = userVocabProgressRepository.findLearningVocabs(user.getId());
            }
        }

        // Map progress to response
        List<ReviewVocabResponse> responses = progressList.stream()
                .map(this::mapToReviewVocabResponse)
                .collect(Collectors.toList());

        // Thêm từ chưa học (nếu có)
        for (Vocab vocab : unlearnedVocabs) {
            responses.add(mapVocabToReviewResponse(vocab));
        }

        // Apply limit
        int limit = request.getSize() != null ? request.getSize() : 10;
        if (responses.size() > limit) {
            responses = responses.subList(0, limit);
        }

        log.info("Found {} review vocabs for user {}", responses.size(), user.getId());
        return responses;
    }

    /**
     * Ghi nhận kết quả ôn tập và cập nhật progress
     */
    @Transactional
    public ReviewResultResponse submitReview(User user, ReviewVocabRequest request) {
        log.info("Submitting review for user: {}, vocab: {}, isCorrect: {}",
                user.getId(), request.getVocabId(), request.getIsCorrect());

        // Get or create progress
        UserVocabProgress progress = userVocabProgressRepository
                .findByUserIdAndVocabId(user.getId(), request.getVocabId())
                .orElseGet(() -> createNewProgress(user, request.getVocabId()));

        // Update progress based on result
        if (Boolean.TRUE.equals(request.getIsCorrect())) {
            progress.setTimesCorrect(progress.getTimesCorrect() + 1);
            // User click "Đã thuộc" → Set status = KNOWN (nếu chưa phải MASTERED)
            if (progress.getStatus() != VocabStatus.MASTERED) {
                progress.setStatus(VocabStatus.KNOWN);
            }
        } else {
            progress.setTimesWrong(progress.getTimesWrong() + 1);
            // User click "Chưa thuộc" → Set status = UNKNOWN
            progress.setStatus(VocabStatus.UNKNOWN);
        }

        // Update using SM-2 algorithm if quality is provided
        if (request.getQuality() != null) {
            updateProgressWithSM2(progress, request.getQuality());
        } else {
            // Simple update without SM-2
            updateProgressSimple(progress, request.getIsCorrect());
        }

        progress.setLastReviewed(LocalDate.now());

        // Save
        progress = userVocabProgressRepository.save(progress);
        // Record streak activity
        try {
            streakService.recordActivity(user);
            log.info("Streak activity recorded for user: {}", user.getId());
        } catch (Exception e) {
            log.error("Failed to record streak activity: {}", e.getMessage());
        }

        String message = generateMessage(request.getIsCorrect(), progress.getStatus());

        return ReviewResultResponse.builder()
                .id(progress.getVocab().getId())
                .word(progress.getVocab().getWord())
                .status(progress.getStatus())
                .timesCorrect(progress.getTimesCorrect())
                .timesWrong(progress.getTimesWrong())
                .nextReviewDate(progress.getNextReviewDate())
                .intervalDays(progress.getIntervalDays())
                .efFactor(progress.getEfFactor())
                .repetition(progress.getRepetition())
                .message(message)
                .build();
    }

    /**
     * Lấy thống kê từ vựng - CHỈ dựa vào STATUS (không dùng nextReviewDate)
     */
    @Transactional(readOnly = true)
    public ReviewStatsResponse getReviewStats(User user, String topicName) {
        long totalVocabs;
        long newVocabs;
        long learningVocabs;
        long masteredVocabs;

        if (topicName != null && !topicName.trim().isEmpty()) {
            // Stats by topic - Lấy TẤT CẢ từ trong topic (cả đã học và chưa học)
            // Đếm từ chưa học (không có trong user_vocab_progress)
            List<Vocab> unlearnedVocabs = userVocabProgressRepository.findUnlearnedVocabsByTopic(
                    user.getId(), topicName);
            newVocabs = unlearnedVocabs.size();

            // Đếm từ đang học (KNOWN + UNKNOWN) trong topic
            List<UserVocabProgress> learningList = userVocabProgressRepository.findLearningVocabsByTopic(
                    user.getId(), topicName);
            learningVocabs = learningList.size();

            // Đếm MASTERED trong topic (cần query riêng vì findLearningVocabsByTopic chỉ
            // lấy KNOWN/UNKNOWN)
            List<UserVocabProgress> allProgress = userVocabProgressRepository.findByUserIdWithVocab(user.getId());
            masteredVocabs = allProgress.stream()
                    .filter(p -> VocabStatus.MASTERED.equals(p.getStatus()))
                    .filter(p -> p.getVocab().getTopic() != null
                            && p.getVocab().getTopic().getName().equalsIgnoreCase(topicName))
                    .count();

            // Tổng = Từ mới + Từ đang học + Từ thành thạo
            totalVocabs = newVocabs + learningVocabs + masteredVocabs;
        } else {
            // Overall stats - Đơn giản hơn
            long totalVocabsInDb = vocabRepository.count();

            // Đếm từ đã có trong user_vocab_progress
            long learnedCount = userVocabProgressRepository.count();

            // Từ mới = Tổng trong DB - Từ đã học
            newVocabs = totalVocabsInDb - learnedCount;

            // learningVocabs = KNOWN + UNKNOWN
            long knownVocabs = userVocabProgressRepository.countByUserIdAndStatus(user.getId(), VocabStatus.KNOWN);
            long unknownVocabs = userVocabProgressRepository.countByUserIdAndStatus(user.getId(), VocabStatus.UNKNOWN);
            learningVocabs = knownVocabs + unknownVocabs;

            masteredVocabs = userVocabProgressRepository.countByUserIdAndStatus(user.getId(), VocabStatus.MASTERED);

            totalVocabs = totalVocabsInDb;
        }

        return ReviewStatsResponse.builder()
                .totalVocabs((int) totalVocabs)
                .newVocabs((int) newVocabs)
                .learningVocabs((int) learningVocabs)
                .masteredVocabs((int) masteredVocabs)
                .dueVocabs(0) // API học từ không cần dueVocabs
                .build();
    }

    // ========== Helper Methods ==========

    private UserVocabProgress createNewProgress(User user, UUID vocabId) {
        Vocab vocab = vocabRepository.findById(vocabId)
                .orElseThrow(() -> new ErrorException("Không tìm thấy từ vựng với ID: " + vocabId));

        return UserVocabProgress.builder()
                .user(user)
                .vocab(vocab)
                .status(VocabStatus.KNOWN) // Mặc định là KNOWN khi user click "Đã thuộc" lần đầu
                .efFactor(2.5)
                .intervalDays(1)
                .repetition(0)
                .timesCorrect(0)
                .timesWrong(0)
                .nextReviewDate(LocalDate.now())
                .build();
    }

    private void updateProgressWithSM2(UserVocabProgress progress, int quality) {
        // SM-2 Algorithm
        if (quality >= 3) {
            // Correct answer
            if (progress.getRepetition() == 0) {
                progress.setIntervalDays(1);
            } else if (progress.getRepetition() == 1) {
                progress.setIntervalDays(6);
            } else {
                progress.setIntervalDays((int) Math.round(progress.getIntervalDays() * progress.getEfFactor()));
            }
            progress.setRepetition(progress.getRepetition() + 1);
        } else {
            // Wrong answer - reset
            progress.setRepetition(0);
            progress.setIntervalDays(1);
        }

        // Update EF Factor
        double newEF = progress.getEfFactor() + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
        progress.setEfFactor(Math.max(1.3, newEF));

        // Update next review date
        progress.setNextReviewDate(LocalDate.now().plusDays(progress.getIntervalDays()));

        // Update status
        updateStatus(progress);
    }

    private void updateProgressSimple(UserVocabProgress progress, boolean isCorrect) {
        if (isCorrect) {
            // Increase interval
            int newInterval = Math.min(progress.getIntervalDays() * 2, 30);
            progress.setIntervalDays(newInterval);
            progress.setRepetition(progress.getRepetition() + 1);
        } else {
            // Reset interval
            progress.setIntervalDays(1);
            progress.setRepetition(0);
        }

        progress.setNextReviewDate(LocalDate.now().plusDays(progress.getIntervalDays()));
        updateStatus(progress);
    }

    /**
     * Tự động cập nhật status dựa trên:
     * - MASTERED: timesCorrect >= 10 && timesWrong <= 2 && tỷ lệ đúng >= 80%
     * - KNOWN: User đã click "Đã thuộc" ít nhất 1 lần
     * - UNKNOWN: User click "Chưa thuộc"
     */
    private void updateStatus(UserVocabProgress progress) {
        int totalAttempts = progress.getTimesCorrect() + progress.getTimesWrong();
        double accuracy = totalAttempts > 0 ? (double) progress.getTimesCorrect() / totalAttempts : 0;

        // Điều kiện thành thạo: >= 10 lần đúng, sai tối đa 2 lần, độ chính xác >= 80%
        if (progress.getTimesCorrect() >= 10
                && progress.getTimesWrong() <= 2
                && accuracy >= 0.8) {
            progress.setStatus(VocabStatus.MASTERED);
        }
        // Nếu chưa đủ điều kiện MASTERED, giữ nguyên status hiện tại (KNOWN hoặc
        // UNKNOWN)
        // Không tự động thay đổi vì user đã chọn "Đã thuộc" hoặc "Chưa thuộc"
    }

    private String generateMessage(boolean isCorrect, VocabStatus status) {
        if (isCorrect) {
            return switch (status) {
                case MASTERED -> "Xuất sắc! Bạn đã thành thạo từ này! 🎉";
                case KNOWN -> "Tốt lắm! Bạn đã thuộc từ này! 💪";
                case UNKNOWN -> "Chính xác! Bước đầu tốt đẹp! 👍";
                default -> "Chính xác! 👍";
            };
        } else {
            return "Chưa thuộc! Cố gắng luyện tập thêm nhé! 📚";
        }
    }

    private ReviewVocabResponse mapToReviewVocabResponse(UserVocabProgress progress) {
        Vocab vocab = progress.getVocab();

        return ReviewVocabResponse.builder()
                .id(vocab.getId())
                .word(vocab.getWord())
                .transcription(vocab.getTranscription())
                .meaningVi(vocab.getMeaningVi())
                .interpret(vocab.getInterpret())
                .exampleSentence(vocab.getExampleSentence())
                .cefr(vocab.getCefr())
                .img(vocab.getImg())
                .audio(vocab.getAudio())
                .topic(vocab.getTopic() != null ? ReviewVocabResponse.TopicInfo.builder()
                        .id(vocab.getTopic().getId())
                        .name(vocab.getTopic().getName())
                        .build() : null)
                .types(vocab.getTypes().stream()
                        .map(type -> ReviewVocabResponse.TypeInfo.builder()
                                .id(type.getId())
                                .name(type.getName())
                                .build())
                        .collect(Collectors.toSet()))
                .status(progress.getStatus())
                .timesCorrect(progress.getTimesCorrect())
                .timesWrong(progress.getTimesWrong())
                .lastReviewed(progress.getLastReviewed())
                .nextReviewDate(progress.getNextReviewDate())
                .intervalDays(progress.getIntervalDays())
                .build();
    }

    private ReviewVocabResponse mapVocabToReviewResponse(Vocab vocab) {
        return ReviewVocabResponse.builder()
                .id(vocab.getId())
                .word(vocab.getWord())
                .transcription(vocab.getTranscription())
                .meaningVi(vocab.getMeaningVi())
                .interpret(vocab.getInterpret())
                .exampleSentence(vocab.getExampleSentence())
                .cefr(vocab.getCefr())
                .img(vocab.getImg())
                .audio(vocab.getAudio())
                .topic(vocab.getTopic() != null ? ReviewVocabResponse.TopicInfo.builder()
                        .id(vocab.getTopic().getId())
                        .name(vocab.getTopic().getName())
                        .build() : null)
                .types(vocab.getTypes().stream()
                        .map(type -> ReviewVocabResponse.TypeInfo.builder()
                                .id(type.getId())
                                .name(type.getName())
                                .build())
                        .collect(Collectors.toSet()))
                .status(VocabStatus.NEW) // Từ mới chưa có trong user_vocab_progress
                .timesCorrect(0)
                .timesWrong(0)
                .lastReviewed(null)
                .nextReviewDate(LocalDate.now())
                .intervalDays(1)
                .build();
    }

    @lombok.Data
    @lombok.Builder
    @lombok.NoArgsConstructor
    @lombok.AllArgsConstructor
    public static class ReviewStatsResponse {
        private Integer totalVocabs;
        private Integer newVocabs;
        private Integer learningVocabs;
        private Integer masteredVocabs;
        private Integer dueVocabs;
    }

    // ========== NEW METHODS FOR LEARNING VOCAB API ==========

    /**
     * Lấy từ vựng để học (không có trong UserVocabProgress hoặc status =
     * NEW/UNKNOWN)
     * Thuật toán:
     * 1. Lấy từ chưa có trong UserVocabProgress (từ mới hoàn toàn)
     * 2. Lấy từ có status = NEW hoặc UNKNOWN (ưu tiên UNKNOWN trước)
     * 3. Trộn hai nguồn này để tạo danh sách cuối cùng
     * 4. Từ NEW có thể hiển thị lại để người dùng học lại
     */
    @Transactional(readOnly = true)
    public PagedReviewVocabResponse getVocabsForLearning(User user, Integer page, Integer size) {
        log.info("Getting vocabs for learning - user: {}, page: {}, size: {}", user.getId(), page, size);

        // Convert 1-based page to 0-based for PageRequest
        int zeroBasedPage = Math.max(0, page - 1);

        // Đếm tổng số từ trước để validate page
        long totalProgressElements = userVocabProgressRepository.countNewOrUnknownVocabs(user.getId());
        long totalUnlearnedElements = userVocabProgressRepository.countAllUnlearnedVocabs(user.getId());
        long totalElements = totalProgressElements + totalUnlearnedElements;
        int totalPages = (int) Math.ceil((double) totalElements / size);

        // Nếu page vượt quá totalPages, trả về trang rỗng
        if (zeroBasedPage >= totalPages && totalPages > 0) {
            log.warn("Page {} exceeds total pages {}. Returning empty page.", page, totalPages);
            ReviewStatsResponse stats = getReviewStats(user, null);

            PagedReviewVocabResponse.PageMetadata meta = PagedReviewVocabResponse.PageMetadata.builder()
                    .page(page)
                    .pageSize(size)
                    .totalItems(totalElements)
                    .totalPages(totalPages)
                    .hasNext(false)
                    .hasPrev(page > 0)
                    .newVocabs(stats.getNewVocabs())
                    .learningVocabs(stats.getLearningVocabs())
                    .masteredVocabs(stats.getMasteredVocabs())
                    .dueVocabs(0)
                    .build();

            return PagedReviewVocabResponse.builder()
                    .vocabs(new ArrayList<>())
                    .meta(meta)
                    .build();
        }

        Pageable pageable = PageRequest.of(zeroBasedPage, size);

        // 1. Lấy từ có status = NEW hoặc UNKNOWN (ưu tiên UNKNOWN trước)
        Page<UserVocabProgress> progressPage = userVocabProgressRepository.findNewOrUnknownVocabsPaged(
                user.getId(), pageable);

        // 2. Nếu không đủ, lấy thêm từ chưa học (không có trong user_vocab_progress)
        Page<Vocab> unlearnedPage = null;
        if (progressPage.getContent().size() < size) {
            int remaining = size - progressPage.getContent().size();
            Pageable newPageable = PageRequest.of(0, remaining);
            unlearnedPage = userVocabProgressRepository.findAllUnlearnedVocabsPaged(user.getId(), newPageable);
        }

        // 3. Map to response - ưu tiên từ có progress (NEW/UNKNOWN) trước
        List<ReviewVocabResponse> vocabs = new ArrayList<>();

        // Thêm từ có status NEW/UNKNOWN
        progressPage.getContent().stream()
                .map(this::mapToReviewVocabResponse)
                .forEach(vocabs::add);

        // Sau đó thêm từ chưa học
        if (unlearnedPage != null && !unlearnedPage.isEmpty()) {
            unlearnedPage.getContent().forEach(vocab -> vocabs.add(mapVocabToReviewResponse(vocab)));
        }

        // Get stats
        ReviewStatsResponse stats = getReviewStats(user, null);

        PagedReviewVocabResponse.PageMetadata meta = PagedReviewVocabResponse.PageMetadata.builder()
                .page(page)
                .pageSize(size)
                .totalItems(totalElements)
                .totalPages(totalPages)
                .hasNext(zeroBasedPage < totalPages - 1)
                .hasPrev(page > 1)
                .newVocabs(stats.getNewVocabs())
                .learningVocabs(stats.getLearningVocabs())
                .masteredVocabs(stats.getMasteredVocabs())
                .dueVocabs(0)
                .build();

        return PagedReviewVocabResponse.builder()
                .vocabs(vocabs)
                .meta(meta)
                .build();
    }

    /**
     * Lấy từ vựng để học theo topic cụ thể
     * Thuật toán tương tự như getVocabsForLearning nhưng filter theo topic
     */
    @Transactional(readOnly = true)
    public PagedReviewVocabResponse getVocabsForLearningByTopic(User user, String topicName, Integer page,
            Integer size) {
        log.info("Getting vocabs for learning by topic - user: {}, topic: {}, page: {}, size: {}",
                user.getId(), topicName, page, size);

        // Convert 1-based page to 0-based for PageRequest
        int zeroBasedPage = Math.max(0, page - 1);

        // Đếm tổng số từ trước để validate page
        long totalProgressElements = userVocabProgressRepository.countNewOrUnknownVocabsByTopic(user.getId(),
                topicName);
        long totalUnlearnedElements = userVocabProgressRepository.countUnlearnedVocabsByTopic(user.getId(), topicName);
        long totalElements = totalProgressElements + totalUnlearnedElements;
        int totalPages = (int) Math.ceil((double) totalElements / size);

        // Nếu page vượt quá totalPages, trả về trang rỗng
        if (zeroBasedPage >= totalPages && totalPages > 0) {
            log.warn("Page {} exceeds total pages {} for topic {}. Returning empty page.", page, totalPages, topicName);
            ReviewStatsResponse stats = getReviewStats(user, topicName);

            PagedReviewVocabResponse.PageMetadata meta = PagedReviewVocabResponse.PageMetadata.builder()
                    .page(page)
                    .pageSize(size)
                    .totalItems(totalElements)
                    .totalPages(totalPages)
                    .hasNext(false)
                    .hasPrev(page > 1)
                    .newVocabs(stats.getNewVocabs())
                    .learningVocabs(stats.getLearningVocabs())
                    .masteredVocabs(stats.getMasteredVocabs())
                    .dueVocabs(0)
                    .build();

            return PagedReviewVocabResponse.builder()
                    .vocabs(new ArrayList<>())
                    .meta(meta)
                    .build();
        }

        Pageable pageable = PageRequest.of(zeroBasedPage, size);

        // 1. Lấy từ có status = NEW hoặc UNKNOWN theo topic (ưu tiên UNKNOWN trước)
        Page<UserVocabProgress> progressPage = userVocabProgressRepository.findNewOrUnknownVocabsByTopicPaged(
                user.getId(), topicName, pageable);

        // 2. Nếu không đủ, lấy thêm từ chưa học trong topic
        Page<Vocab> unlearnedPage = null;
        if (progressPage.getContent().size() < size) {
            int remaining = size - progressPage.getContent().size();
            Pageable newPageable = PageRequest.of(0, remaining);
            unlearnedPage = userVocabProgressRepository.findUnlearnedVocabsByTopicPaged(
                    user.getId(), topicName, newPageable);
        }

        // 3. Map to response
        List<ReviewVocabResponse> vocabs = new ArrayList<>();

        // Thêm từ có status NEW/UNKNOWN
        progressPage.getContent().stream()
                .map(this::mapToReviewVocabResponse)
                .forEach(vocabs::add);

        // Sau đó thêm từ chưa học
        if (unlearnedPage != null && !unlearnedPage.isEmpty()) {
            unlearnedPage.getContent().forEach(vocab -> vocabs.add(mapVocabToReviewResponse(vocab)));
        }

        // Get stats
        ReviewStatsResponse stats = getReviewStats(user, topicName);

        PagedReviewVocabResponse.PageMetadata meta = PagedReviewVocabResponse.PageMetadata.builder()
                .page(page)
                .pageSize(size)
                .totalItems(totalElements)
                .totalPages(totalPages)
                .hasNext(zeroBasedPage < totalPages - 1)
                .hasPrev(page > 1)
                .newVocabs(stats.getNewVocabs())
                .learningVocabs(stats.getLearningVocabs())
                .masteredVocabs(stats.getMasteredVocabs())
                .dueVocabs(0)
                .build();

        return PagedReviewVocabResponse.builder()
                .vocabs(vocabs)
                .meta(meta)
                .build();
    }
}
