package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
import com.thuanthichlaptrinh.card_words.core.domain.*;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.*;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.offline.*;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.offline.TopicProgressResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.offline.UserVocabProgressDownloadResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.offline.VocabWithProgressResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class OfflineSyncService {

    private final TopicRepository topicRepository;
    private final VocabRepository vocabRepository;
    private final UserVocabProgressRepository userVocabProgressRepository;
    private final GameSessionRepository gameSessionRepository;
    private final GameSessionDetailRepository gameSessionDetailRepository;
    private final GameRepository gameRepository;

    /**
     * Get all topics with learning progress percentage for user
     */
    @Transactional(readOnly = true)
    public List<TopicProgressResponse> getTopicsWithProgress(UUID userId) {
        log.info("Fetching topics with progress for user: {}", userId);

        List<Topic> topics = topicRepository.findAll();
        List<TopicProgressResponse> result = new ArrayList<>();

        for (Topic topic : topics) {
            // Get all vocabs in this topic
            List<Vocab> vocabs = vocabRepository.findByTopicNameIgnoreCase(topic.getName());
            int totalVocabs = vocabs.size();

            if (totalVocabs == 0) {
                result.add(buildTopicProgress(topic, 0, 0, 0.0));
                continue;
            }

            // Count learned vocabs (chỉ tính KNOWN và MASTERED)
            int learnedCount = 0;
            for (Vocab vocab : vocabs) {
                Optional<UserVocabProgress> progress = userVocabProgressRepository.findByUserIdAndVocabId(userId,
                        vocab.getId());

                if (progress.isPresent()) {
                    VocabStatus status = progress.get().getStatus();
                    // Chỉ tính KNOWN và MASTERED là đã thuộc
                    if (status == VocabStatus.KNOWN || status == VocabStatus.MASTERED) {
                        learnedCount++;
                    }
                }
            }

            // Calculate percentage
            double progressPercent = (totalVocabs > 0)
                    ? Math.round((learnedCount * 100.0 / totalVocabs) * 100.0) / 100.0
                    : 0.0;

            result.add(buildTopicProgress(topic, totalVocabs, learnedCount, progressPercent));
        }

        log.info("Retrieved {} topics with progress", result.size());
        return result;
    }

    /**
     * Get vocabs by topic with user progress
     */
    @Transactional(readOnly = true)
    public List<VocabWithProgressResponse> getVocabsByTopic(UUID userId, Long topicId) {
        log.info("Fetching vocabs for topic {} and user {}", topicId, userId);

        Topic topic = topicRepository.findById(topicId)
                .orElseThrow(() -> new IllegalArgumentException("Topic not found: " + topicId));

        List<Vocab> vocabs = vocabRepository.findByTopicNameIgnoreCase(topic.getName());

        return vocabs.stream()
                .map(vocab -> buildVocabWithProgress(vocab, userId))
                .collect(Collectors.toList());
    }

    /**
     * Get recently learned vocabs (last 30 days)
     */
    @Transactional(readOnly = true)
    public List<VocabWithProgressResponse> getRecentVocabs(UUID userId) {
        log.info("Fetching recent vocabs for user: {}", userId);

        LocalDateTime thirtyDaysAgo = LocalDateTime.now().minusDays(30);
        List<UserVocabProgress> recentProgress = userVocabProgressRepository.findByUserIdAndLastReviewedAtAfter(userId,
                thirtyDaysAgo);

        return recentProgress.stream()
                .map(progress -> buildVocabWithProgress(progress.getVocab(), userId))
                .collect(Collectors.toList());
    }

    /**
     * Batch sync: Upload game sessions, details, and vocab progress in one
     * transaction
     * 
     * Processing flow:
     * 1. Save game sessions (without details)
     * 2. Save game session details (linked by clientSessionId)
     * 3. Auto-update user_vocab_progress based on game performance
     * 4. Merge with explicit vocab progress updates (optional)
     */
    @Transactional
    public Map<String, Object> syncBatch(UUID userId, BatchSyncRequest request) {
        log.info("Starting batch sync for user: {}, clientId: {}", userId, request.getClientId());

        int syncedSessions = 0;
        int syncedDetails = 0;
        int syncedProgress = 0;
        int skippedDuplicates = 0;
        List<String> errors = new ArrayList<>();

        // Map to store clientSessionId -> saved GameSession
        Map<String, GameSession> sessionMap = new HashMap<>();

        // Step 1: Save game sessions first (without details)
        if (request.getGameSessions() != null) {
            for (OfflineGameSessionRequest sessionReq : request.getGameSessions()) {
                try {
                    if (isDuplicateSession(userId, sessionReq)) {
                        skippedDuplicates++;
                        log.debug("Skipped duplicate session: {}", sessionReq.getSessionId());
                        continue;
                    }

                    GameSession savedSession = saveGameSessionOnly(userId, sessionReq);
                    sessionMap.put(sessionReq.getSessionId(), savedSession);
                    syncedSessions++;
                } catch (Exception e) {
                    log.error("Failed to sync session: {}", sessionReq.getSessionId(), e);
                    errors.add("Session " + sessionReq.getSessionId() + ": " + e.getMessage());
                }
            }
        }

        // Step 2: Save game session details and auto-update vocab progress
        if (request.getGameSessionDetails() != null) {
            for (OfflineGameDetailRequest detail : request.getGameSessionDetails()) {
                try {
                    GameSession session = sessionMap.get(detail.getSessionId());
                    if (session == null) {
                        log.warn("Session not found for detail with sessionId: {}", detail.getSessionId());
                        errors.add("Detail for session " + detail.getSessionId() + ": Session not found");
                        continue;
                    }

                    syncGameSessionDetail(session, detail);
                    syncedDetails++;
                } catch (Exception e) {
                    log.error("Failed to sync detail for vocab: {}", detail.getVocabId(), e);
                    errors.add("Detail vocab " + detail.getVocabId() + ": " + e.getMessage());
                }
            }
        }

        // Step 3: Merge with explicit vocab progress (optional - for manual updates)
        if (request.getVocabProgress() != null) {
            for (OfflineVocabProgressRequest progressReq : request.getVocabProgress()) {
                try {
                    syncVocabProgress(userId, progressReq);
                    syncedProgress++;
                } catch (Exception e) {
                    log.error("Failed to sync progress for vocab: {}", progressReq.getVocabId(), e);
                    errors.add("Vocab " + progressReq.getVocabId() + ": " + e.getMessage());
                }
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("syncedGameSessions", syncedSessions);
        result.put("syncedGameSessionDetails", syncedDetails);
        result.put("syncedVocabProgress", syncedProgress);
        result.put("skippedDuplicates", skippedDuplicates);
        result.put("errors", errors);
        result.put("serverTimestamp", LocalDateTime.now().format(DateTimeFormatter.ISO_DATE_TIME));

        log.info("Batch sync completed: {} sessions, {} details, {} progress, {} skipped, {} errors",
                syncedSessions, syncedDetails, syncedProgress, skippedDuplicates, errors.size());

        return result;
    }

    /**
     * Upload game sessions individually
     */
    @Transactional
    public int syncGameSessions(UUID userId, List<OfflineGameSessionRequest> sessions) {
        log.info("Syncing {} game sessions for user: {}", sessions.size(), userId);

        int syncedCount = 0;
        for (OfflineGameSessionRequest sessionReq : sessions) {
            try {
                if (!isDuplicateSession(userId, sessionReq)) {
                    syncGameSession(userId, sessionReq);
                    syncedCount++;
                }
            } catch (Exception e) {
                log.error("Failed to sync session: {}", sessionReq.getSessionId(), e);
            }
        }

        return syncedCount;
    }

    /**
     * Upload vocab progress individually
     */
    @Transactional
    public int syncVocabProgress(UUID userId, List<OfflineVocabProgressRequest> progressList) {
        log.info("Syncing {} vocab progress for user: {}", progressList.size(), userId);

        int syncedCount = 0;
        for (OfflineVocabProgressRequest progressReq : progressList) {
            try {
                syncVocabProgress(userId, progressReq);
                syncedCount++;
            } catch (Exception e) {
                log.error("Failed to sync progress for vocab: {}", progressReq.getVocabId(), e);
            }
        }

        return syncedCount;
    }

    /**
     * Sync game session details individually
     * Use case: Upload details for an existing session, or batch upload details
     * only
     */
    @Transactional
    public int syncGameSessionDetails(UUID userId, UUID sessionId, List<OfflineGameDetailRequest> details) {
        log.info("Syncing {} game session details for session: {}", details.size(), sessionId);

        // Verify session exists and belongs to user
        GameSession session = gameSessionRepository.findById(sessionId)
                .orElseThrow(() -> new IllegalArgumentException("Game session not found: " + sessionId));

        if (!session.getUser().getId().equals(userId)) {
            throw new IllegalArgumentException("Session không thuộc về người dùng");
        }

        int syncedCount = 0;
        for (OfflineGameDetailRequest detail : details) {
            try {
                syncGameSessionDetail(session, detail);
                syncedCount++;
            } catch (Exception e) {
                log.error("Failed to sync detail for vocab: {}", detail.getVocabId(), e);
            }
        }

        log.info("Successfully synced {} details for session: {}", syncedCount, sessionId);
        return syncedCount;
    }

    /**
     * Check for updates since last sync
     */
    @Transactional(readOnly = true)
    public Map<String, Object> checkForUpdates(String lastSyncTime) {
        log.info("Checking for updates since: {}", lastSyncTime);

        LocalDateTime lastSync = LocalDateTime.parse(lastSyncTime, DateTimeFormatter.ISO_DATE_TIME);

        // Count new vocabs
        long newVocabsCount = vocabRepository.findAll().stream()
                .filter(v -> v.getCreatedAt() != null && v.getCreatedAt().isAfter(lastSync))
                .count();

        Map<String, Object> result = new HashMap<>();
        result.put("hasUpdates", newVocabsCount > 0);
        result.put("newVocabsCount", newVocabsCount);
        result.put("lastSyncTime", lastSyncTime);
        result.put("serverTime", LocalDateTime.now().format(DateTimeFormatter.ISO_DATE_TIME));

        return result;
    }

    // ==================== PRIVATE HELPER METHODS ====================

    private TopicProgressResponse buildTopicProgress(Topic topic, int vocabCount, int learnedCount,
            double progressPercent) {
        return TopicProgressResponse.builder()
                .id(topic.getId())
                .name(topic.getName())
                // .nameVi(null) // Topic doesn't have nameVi
                // .description(topic.getDescription())
                // .vocabCount(vocabCount)
                // .learnedCount(learnedCount)
                .progressPercent(progressPercent)
                // .cefr(null) // Topics don't have CEFR
                // .lastUpdated(topic.getUpdatedAt())
                // .createdAt(topic.getCreatedAt())
                .build();
    }

    private VocabWithProgressResponse buildVocabWithProgress(Vocab vocab, UUID userId) {
        VocabWithProgressResponse.VocabWithProgressResponseBuilder builder = VocabWithProgressResponse.builder()
                .id(vocab.getId())
                .word(vocab.getWord())
                .img(vocab.getImg())
                .audio(vocab.getAudio())
                .cefr(vocab.getCefr())
                .word(vocab.getWord())
                .meaningVi(vocab.getMeaningVi())
                .transcription(vocab.getTranscription())
                .interpret(vocab.getInterpret())
                .exampleSentence(vocab.getExampleSentence())
                .types(vocab.getTypes().stream()
                        .map(type -> VocabWithProgressResponse.TypeInfo.builder()
                                .id(type.getId())
                                .name(type.getName())
                                .build())
                        .collect(java.util.stream.Collectors.toSet()))
                .topic(vocab.getTopic() != null ? VocabWithProgressResponse.TopicInfo.builder()
                        .id(vocab.getTopic().getId())
                        .name(vocab.getTopic().getName())
                        .build() : null)
                .credit(vocab.getCredit());

        // // Add user progress if exists
        // Optional<UserVocabProgress> progress =
        // userVocabProgressRepository.findByUserIdAndVocabId(userId,
        // vocab.getId());

        // if (progress.isPresent()) {
        // UserVocabProgress p = progress.get();
        // // Convert LocalDate to LocalDateTime for compatibility
        // builder.status(p.getStatus())
        // .lastReviewedAt(p.getLastReviewed() != null ?
        // p.getLastReviewed().atStartOfDay() : null)
        // .nextReviewAt(p.getNextReviewDate() != null ?
        // p.getNextReviewDate().atStartOfDay() : null)
        // .easeFactor(p.getEfFactor())
        // .repetitions(p.getRepetition())
        // .interval(p.getIntervalDays());
        // }

        return builder.build();
    }

    private boolean isDuplicateSession(UUID userId, OfflineGameSessionRequest request) {
        LocalDateTime startTime = LocalDateTime.parse(request.getStartedAt(),
                DateTimeFormatter.ISO_DATE_TIME);

        // Check by userId + gameId + startedAt (within 1 second tolerance)
        List<GameSession> existingSessions = gameSessionRepository
                .findByGameIdAndUserIdOrderByStartedAtDesc(request.getGameId(), userId);

        return existingSessions.stream()
                .anyMatch(session -> Math.abs(
                        java.time.Duration.between(session.getStartedAt(), startTime).getSeconds()) < 1);
    }

    private void syncGameSession(UUID userId, OfflineGameSessionRequest request) {
        GameSession session = saveGameSessionOnly(userId, request);

        // Save details
        if (request.getDetails() != null) {
            for (OfflineGameDetailRequest detail : request.getDetails()) {
                syncGameSessionDetail(session, detail);
            }
        }

        log.info("Synced game session with {} details: {}",
                request.getDetails() != null ? request.getDetails().size() : 0, session.getId());
    }

    /**
     * Save game session without details (used in batch sync)
     */
    private GameSession saveGameSessionOnly(UUID userId, OfflineGameSessionRequest request) {
        User user = new User();
        user.setId(userId);

        Game game = gameRepository.findById(request.getGameId())
                .orElseThrow(() -> new IllegalArgumentException("Game not found: " + request.getGameId()));

        LocalDateTime startTime = LocalDateTime.parse(request.getStartedAt(),
                DateTimeFormatter.ISO_DATE_TIME);
        LocalDateTime finishTime = request.getFinishedAt() != null
                ? LocalDateTime.parse(request.getFinishedAt(), DateTimeFormatter.ISO_DATE_TIME)
                : null;

        GameSession session = GameSession.builder()
                .user(user)
                .game(game)
                .topic(null)
                .startedAt(startTime)
                .finishedAt(finishTime)
                .totalQuestions(request.getTotalQuestions())
                .correctCount(request.getCorrectCount())
                .score(request.getScore())
                .build();

        session = gameSessionRepository.save(session);
        log.debug("Saved game session: {}", session.getId());

        return session;
    }

    private void syncVocabProgress(UUID userId, OfflineVocabProgressRequest request) {
        User user = new User();
        user.setId(userId);

        Vocab vocab = vocabRepository.findById(request.getVocabId())
                .orElseThrow(() -> new IllegalArgumentException("Vocab not found: " + request.getVocabId()));

        Optional<UserVocabProgress> existingProgress = userVocabProgressRepository.findByUserIdAndVocabId(userId,
                request.getVocabId());

        // Validate and parse dates - skip if invalid or "string"
        if (request.getLastReviewedAt() == null || request.getLastReviewedAt().isEmpty()
                || "string".equalsIgnoreCase(request.getLastReviewedAt().trim())
                || request.getNextReviewAt() == null || request.getNextReviewAt().isEmpty()
                || "string".equalsIgnoreCase(request.getNextReviewAt().trim())) {
            log.warn("Skipping vocab progress sync for {} - invalid date format: lastReviewed={}, nextReview={}",
                    request.getVocabId(), request.getLastReviewedAt(), request.getNextReviewAt());
            return;
        }

        // Convert LocalDateTime to LocalDate
        LocalDate lastReviewed;
        LocalDate nextReview;

        try {
            LocalDateTime lastReviewedDT = LocalDateTime.parse(request.getLastReviewedAt(),
                    DateTimeFormatter.ISO_DATE_TIME);
            LocalDateTime nextReviewDT = LocalDateTime.parse(request.getNextReviewAt(),
                    DateTimeFormatter.ISO_DATE_TIME);

            lastReviewed = lastReviewedDT.toLocalDate();
            nextReview = nextReviewDT.toLocalDate();
        } catch (Exception e) {
            log.error("Failed to parse dates for vocab {}: lastReviewed={}, nextReview={}",
                    request.getVocabId(), request.getLastReviewedAt(), request.getNextReviewAt(), e);
            throw new IllegalArgumentException(
                    String.format(
                            "Định dạng ngày tháng không hợp lệ cho từ vựng %s. Định dạng ISO 8601 ​​(ví dụ: 2025-11-21T10:30:00)",
                            request.getVocabId()));
        }

        UserVocabProgress progress;
        if (existingProgress.isPresent()) {
            // Update existing (merge strategy: client data wins if newer)
            progress = existingProgress.get();
            LocalDate serverLastReviewed = progress.getLastReviewed();

            if (serverLastReviewed == null || lastReviewed.isAfter(serverLastReviewed)) {
                updateProgress(progress, request, lastReviewed, nextReview);
            } else {
                log.debug("Server data is newer, skipping update for vocab: {}", request.getVocabId());
            }
        } else {
            // Create new
            progress = UserVocabProgress.builder()
                    .user(user)
                    .vocab(vocab)
                    .status(request.getStatus())
                    .lastReviewed(lastReviewed)
                    .nextReviewDate(nextReview)
                    .efFactor(request.getEaseFactor())
                    .repetition(request.getRepetitions())
                    .intervalDays(request.getInterval())
                    .timesCorrect(request.getTimesCorrect() != null ? request.getTimesCorrect() : 0)
                    .timesWrong(request.getTimesWrong() != null ? request.getTimesWrong() : 0)
                    .build();
        }

        userVocabProgressRepository.save(progress);
        log.debug("Synced vocab progress: {}", request.getVocabId());
    }

    /**
     * Smart merge strategy for UserVocabProgress update
     * 
     * Rules:
     * 1. timesCorrect & timesWrong: Lấy MAX (ngăn ngừa mất dữ liệu khi ngoại tuyến
     * xung đột)
     * 2. status: Sử dụng client nếu nó thể hiện mức độ thành thạo cao hơn
     * 3. lastReviewed: Sử dụng ngày gần nhất
     * 4. nextReviewDate: Sử dụng client (tính toán mới hơn)
     * 5. efFactor: Sử dụng client nếu repetition > server (thể hiện mức độ học tập
     * gần đây hơn)
     * 6. repetition: Lấy MAX (luyện tập càng nhiều càng tốt)
     * 7. intervalDays: Sử dụng client (tính toán lại dựa trên lần đánh giá gần
     * nhất)
     */
    private void updateProgress(UserVocabProgress progress, OfflineVocabProgressRequest request,
            LocalDate lastReviewed, LocalDate nextReview) {

        // 1. Status: Upgrade to higher mastery level only
        VocabStatus currentStatus = progress.getStatus();
        VocabStatus newStatus = request.getStatus();

        if (shouldUpgradeStatus(currentStatus, newStatus)) {
            progress.setStatus(newStatus);
            log.debug("Upgraded status from {} to {} for vocab {}", currentStatus, newStatus, request.getVocabId());
        } else {
            log.debug("Keeping current status {} (client: {}) for vocab {}", currentStatus, newStatus,
                    request.getVocabId());
        }

        // 2. lastReviewed: Always use latest date
        if (progress.getLastReviewed() == null || lastReviewed.isAfter(progress.getLastReviewed())) {
            progress.setLastReviewed(lastReviewed);
        }

        // 3. nextReviewDate: Use client data (represents latest calculation)
        progress.setNextReviewDate(nextReview);

        // 4. Repetition: Take MAX (more practice = better retention)
        int currentRepetition = progress.getRepetition() != null ? progress.getRepetition() : 0;
        int newRepetition = request.getRepetitions() != null ? request.getRepetitions() : 0;
        progress.setRepetition(Math.max(currentRepetition, newRepetition));

        // 5. efFactor: Use client if they have more repetitions (newer learning data)
        if (newRepetition >= currentRepetition && request.getEaseFactor() != null) {
            progress.setEfFactor(request.getEaseFactor());
        }

        // 6. intervalDays: Use client (represents latest SM-2 calculation)
        if (request.getInterval() != null) {
            progress.setIntervalDays(request.getInterval());
        }

        // 7. timesCorrect: Take MAX to prevent data loss
        if (request.getTimesCorrect() != null) {
            int currentCorrect = progress.getTimesCorrect() != null ? progress.getTimesCorrect() : 0;
            int newCorrect = request.getTimesCorrect();
            int maxCorrect = Math.max(currentCorrect, newCorrect);
            progress.setTimesCorrect(maxCorrect);

            if (newCorrect > currentCorrect) {
                log.debug("Updated timesCorrect from {} to {} for vocab {}", currentCorrect, newCorrect,
                        request.getVocabId());
            }
        }

        // 8. timesWrong: Take MAX to prevent data loss
        if (request.getTimesWrong() != null) {
            int currentWrong = progress.getTimesWrong() != null ? progress.getTimesWrong() : 0;
            int newWrong = request.getTimesWrong();
            int maxWrong = Math.max(currentWrong, newWrong);
            progress.setTimesWrong(maxWrong);

            if (newWrong > currentWrong) {
                log.debug("Updated timesWrong from {} to {} for vocab {}", currentWrong, newWrong,
                        request.getVocabId());
            }
        }
    }

    /**
     * Check if status should be upgraded based on mastery level
     * 
     * Mastery hierarchy: NEW < UNKNOWN < KNOWN < MASTERED
     */
    private boolean shouldUpgradeStatus(VocabStatus current, VocabStatus newStatus) {
        if (current == null || newStatus == null) {
            return newStatus != null;
        }

        // Define mastery levels
        Map<VocabStatus, Integer> masteryLevel = Map.of(
                VocabStatus.NEW, 0,
                VocabStatus.UNKNOWN, 1,
                VocabStatus.KNOWN, 2,
                VocabStatus.MASTERED, 3);

        int currentLevel = masteryLevel.getOrDefault(current, 0);
        int newLevel = masteryLevel.getOrDefault(newStatus, 0);

        // Only upgrade, never downgrade
        return newLevel > currentLevel;
    }

    private void syncGameSessionDetail(GameSession session, OfflineGameDetailRequest detail) {
        Vocab vocab = vocabRepository.findById(detail.getVocabId())
                .orElseThrow(() -> new IllegalArgumentException("Vocab not found: " + detail.getVocabId()));

        GameSessionDetail detailEntity = GameSessionDetail.builder()
                .session(session)
                .vocab(vocab)
                .isCorrect(detail.getIsCorrect())
                .timeTaken(detail.getTimeTaken())
                .build();

        gameSessionDetailRepository.save(detailEntity);
        log.debug("Synced game session detail for vocab: {}", detail.getVocabId());

        // Update user vocab progress based on game result
        updateUserVocabProgressFromGameResult(session.getUser().getId(), vocab, detail.getIsCorrect());
    }

    /**
     * Update user vocab progress based on game performance
     * Implements Spaced Repetition (SM-2 algorithm)
     */
    private void updateUserVocabProgressFromGameResult(UUID userId, Vocab vocab, Boolean isCorrect) {
        Optional<UserVocabProgress> existingProgress = userVocabProgressRepository.findByUserIdAndVocabId(userId,
                vocab.getId());

        UserVocabProgress progress;
        if (existingProgress.isPresent()) {
            progress = existingProgress.get();
        } else {
            // Create new progress entry
            User user = new User();
            user.setId(userId);

            progress = UserVocabProgress.builder()
                    .user(user)
                    .vocab(vocab)
                    .status(VocabStatus.UNKNOWN)
                    .timesCorrect(0)
                    .timesWrong(0)
                    .efFactor(2.5)
                    .intervalDays(1)
                    .repetition(0)
                    .lastReviewed(LocalDate.now())
                    .nextReviewDate(LocalDate.now().plusDays(1))
                    .build();
        }

        // Update times correct/wrong
        if (Boolean.TRUE.equals(isCorrect)) {
            progress.setTimesCorrect(progress.getTimesCorrect() + 1);
        } else {
            progress.setTimesWrong(progress.getTimesWrong() + 1);
        }

        // Apply SM-2 algorithm for spaced repetition
        applySpacedRepetition(progress, isCorrect);

        // Update last reviewed date
        progress.setLastReviewed(LocalDate.now());

        userVocabProgressRepository.save(progress);
        log.debug("Updated vocab progress for vocab {} - correct: {}, total correct: {}, total wrong: {}",
                vocab.getId(), isCorrect, progress.getTimesCorrect(), progress.getTimesWrong());
    }

    /**
     * Apply SM-2 Spaced Repetition Algorithm
     * Quality: 5 (perfect) for correct, 1 for incorrect
     * 
     * Note: EF is only updated when quality >= 3 (per original SM-2 algorithm)
     */
    private void applySpacedRepetition(UserVocabProgress progress, Boolean isCorrect) {
        int quality = Boolean.TRUE.equals(isCorrect) ? 5 : 1; // 5 = perfect recall, 1 = incorrect

        if (quality >= 3) {
            // Correct answer - update EF and calculate interval
            // SM-2 EF formula: EF' = EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
            double newEF = progress.getEfFactor() + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
            if (newEF < 1.3) {
                newEF = 1.3; // Minimum EF
            }
            progress.setEfFactor(newEF);

            // Calculate interval based on repetition count
            if (progress.getRepetition() == 0) {
                progress.setIntervalDays(1);
            } else if (progress.getRepetition() == 1) {
                progress.setIntervalDays(6);
            } else {
                int newInterval = (int) Math.round(progress.getIntervalDays() * newEF);
                if (newInterval < 1)
                    newInterval = 1;
                progress.setIntervalDays(newInterval);
            }

            progress.setRepetition(progress.getRepetition() + 1);

            // Update status based on performance metrics
            int totalAttempts = progress.getTimesCorrect() + progress.getTimesWrong();
            double accuracy = totalAttempts > 0 ? (progress.getTimesCorrect() * 100.0 / totalAttempts) : 0;

            if (progress.getTimesCorrect() >= 10 && progress.getTimesWrong() <= 2 && accuracy >= 80.0) {
                progress.setStatus(VocabStatus.MASTERED);
            } else if (progress.getTimesCorrect() >= 3 && accuracy >= 60.0) {
                progress.setStatus(VocabStatus.KNOWN);
            } else {
                progress.setStatus(VocabStatus.UNKNOWN);
            }
        } else {
            // Incorrect answer - reset repetition and interval, but keep EF unchanged (SM-2
            // standard)
            progress.setRepetition(0);
            progress.setIntervalDays(1);
            progress.setStatus(VocabStatus.UNKNOWN);
        }

        // Calculate next review date
        progress.setNextReviewDate(LocalDate.now().plusDays(progress.getIntervalDays()));
    }

    /**
     * Get all UserVocabProgress for a user with full details
     */
    @Transactional(readOnly = true)
    public List<UserVocabProgressDownloadResponse> getAllUserVocabProgress(UUID userId) {
        log.info("Fetching all UserVocabProgress for user: {}", userId);

        List<UserVocabProgress> progressList = userVocabProgressRepository.findAllByUserIdForDownload(userId);

        return progressList.stream()
                .map(this::convertToDownloadResponse)
                .collect(Collectors.toList());
    }

    /**
     * Get UserVocabProgress by topic
     */
    @Transactional(readOnly = true)
    public List<UserVocabProgressDownloadResponse> getUserVocabProgressByTopic(UUID userId, Long topicId) {
        log.info("Fetching UserVocabProgress for user: {} and topic: {}", userId, topicId);

        Topic topic = topicRepository.findById(topicId)
                .orElseThrow(() -> new IllegalArgumentException("Topic not found: " + topicId));

        // Get all vocabs in topic
        List<Vocab> vocabs = vocabRepository.findByTopicNameIgnoreCase(topic.getName());

        // Get progress for these vocabs
        List<UserVocabProgressDownloadResponse> result = new ArrayList<>();
        for (Vocab vocab : vocabs) {
            Optional<UserVocabProgress> progress = userVocabProgressRepository.findByUserIdAndVocabId(userId,
                    vocab.getId());
            progress.ifPresent(p -> result.add(convertToDownloadResponse(p)));
        }

        log.info("Retrieved {} vocab progress records for topic {}", result.size(), topicId);
        return result;
    }

    /**
     * Get UserVocabProgress that are due for review (nextReviewDate <= today)
     */
    @Transactional(readOnly = true)
    public List<UserVocabProgressDownloadResponse> getDueUserVocabProgress(UUID userId) {
        log.info("Fetching due UserVocabProgress for user: {}", userId);

        List<UserVocabProgress> dueProgress = userVocabProgressRepository.findDueForReview(userId, LocalDate.now());

        return dueProgress.stream()
                .map(this::convertToDownloadResponse)
                .collect(Collectors.toList());
    }

    /**
     * Convert UserVocabProgress entity to DownloadResponse DTO
     * Chỉ map các trường có trong database
     */
    private UserVocabProgressDownloadResponse convertToDownloadResponse(UserVocabProgress progress) {
        return UserVocabProgressDownloadResponse.builder()
                .id(progress.getId())
                .user_id(progress.getUser().getId())
                .vocab_id(progress.getVocab().getId())
                .status(progress.getStatus())
                .last_reviewed(progress.getLastReviewed())
                .times_correct(progress.getTimesCorrect())
                .times_wrong(progress.getTimesWrong())
                .ef_factor(progress.getEfFactor())
                .interval_days(progress.getIntervalDays())
                .repetition(progress.getRepetition())
                .next_review_date(progress.getNextReviewDate())
                .created_at(progress.getCreatedAt())
                .updated_at(progress.getUpdatedAt())
                .build();
    }
}
