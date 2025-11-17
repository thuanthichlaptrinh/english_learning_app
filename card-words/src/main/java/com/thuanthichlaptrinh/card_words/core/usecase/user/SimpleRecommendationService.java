package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.domain.UserVocabProgress;
import com.thuanthichlaptrinh.card_words.core.domain.Vocab;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserVocabProgressRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.SmartReviewResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.VocabRecommendation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class SimpleRecommendationService {
    
    private final UserVocabProgressRepository userVocabProgressRepository;
    
    /**
     * Lấy gợi ý ôn tập thông minh dựa trên rule-based algorithm
     * 
     * @param user User hiện tại
     * @param limit Số lượng gợi ý tối đa (default: 20)
     * @param topicFilter Lọc theo topic (optional)
     * @param statusFilter Lọc theo status (optional)
     * @return SmartReviewResponse với danh sách gợi ý và summary
     */
    @Transactional(readOnly = true)
    public SmartReviewResponse getRecommendations(
            User user, 
            Integer limit,
            String topicFilter,
            String statusFilter) {
        
        log.info("Getting smart recommendations for user: {}, limit: {}, topic: {}, status: {}", 
                user.getId(), limit, topicFilter, statusFilter);
        
        // 1. Lấy tất cả vocab progress của user
        List<UserVocabProgress> allProgress = userVocabProgressRepository.findByUserIdWithVocab(user.getId());
        
        if (allProgress.isEmpty()) {
            log.info("User {} has no vocab progress yet", user.getId());
            return buildEmptyResponse();
        }
        
        // 2. Apply filters
        List<UserVocabProgress> filteredProgress = applyFilters(allProgress, topicFilter, statusFilter);
        
        log.info("Filtered {} vocabs from {} total", filteredProgress.size(), allProgress.size());
        
        // 3. Calculate priority for each vocab
        List<VocabRecommendation> recommendations = filteredProgress.stream()
                .map(this::calculatePriority)
                .filter(r -> r.getPriorityScore() > 0)  // Chỉ lấy có priority
                .sorted((a, b) -> b.getPriorityScore().compareTo(a.getPriorityScore()))
                .collect(Collectors.toList());
        
        // 4. Apply limit
        int finalLimit = (limit != null && limit > 0) ? limit : 20;
        if (recommendations.size() > finalLimit) {
            recommendations = recommendations.subList(0, finalLimit);
        }
        
        // 5. Build summary
        SmartReviewResponse.RecommendationSummary summary = buildSummary(recommendations);
        
        log.info("Generated {} recommendations for user {}", recommendations.size(), user.getId());
        
        return SmartReviewResponse.builder()
                .recommendations(recommendations)
                .totalAnalyzed(filteredProgress.size())
                .totalRecommended(recommendations.size())
                .summary(summary)
                .build();
    }
    
    /**
     * Tính priority score cho một vocab progress
     * Priority Score = Overdue (40) + Status (30) + Accuracy (20) + Difficulty (10) + Bonus (10)
     */
    private VocabRecommendation calculatePriority(UserVocabProgress progress) {
        LocalDate today = LocalDate.now();
        Vocab vocab = progress.getVocab();
        
        int priorityScore = 0;
        List<String> reasons = new ArrayList<>();
        
        // Calculate time metrics
        int daysSinceLastReview = progress.getLastReviewed() != null
                ? (int) ChronoUnit.DAYS.between(progress.getLastReviewed(), today)
                : 999;
        
        int daysUntilNextReview = progress.getNextReviewDate() != null
                ? (int) ChronoUnit.DAYS.between(today, progress.getNextReviewDate())
                : 0;
        
        int daysOverdue = daysUntilNextReview < 0 ? Math.abs(daysUntilNextReview) : 0;
        
        // ===== RULE 1: OVERDUE SCORE (40 điểm) =====
        if (daysOverdue > 0) {
            int overdueScore = Math.min(daysOverdue * 5, 40);
            priorityScore += overdueScore;
            reasons.add(String.format("Quá hạn %d ngày", daysOverdue));
        } else if (daysUntilNextReview == 0) {
            priorityScore += 10;
            reasons.add("Đến hạn ôn tập hôm nay");
        }
        
        // ===== RULE 2: STATUS SCORE (30 điểm) =====
        int statusScore = 0;
        switch (progress.getStatus()) {
            case UNKNOWN:
                statusScore = 30;
                reasons.add("Chưa thuộc từ này");
                break;
            case NEW:
                statusScore = 25;
                reasons.add("Từ mới cần học");
                break;
            case KNOWN:
                statusScore = 15;
                break;
            case MASTERED:
                statusScore = 5;
                break;
        }
        priorityScore += statusScore;
        
        // ===== RULE 3: ACCURACY SCORE (20 điểm) =====
        int totalAttempts = progress.getTimesCorrect() + progress.getTimesWrong();
        double accuracyRate = 0;
        
        if (totalAttempts > 0) {
            accuracyRate = (double) progress.getTimesCorrect() / totalAttempts;
            
            int accuracyScore = 0;
            if (accuracyRate < 0.3) {
                accuracyScore = 20;
                reasons.add(String.format("Tỷ lệ đúng rất thấp (%.0f%%)", accuracyRate * 100));
            } else if (accuracyRate < 0.5) {
                accuracyScore = 15;
                reasons.add(String.format("Tỷ lệ đúng thấp (%.0f%%)", accuracyRate * 100));
            } else if (accuracyRate < 0.7) {
                accuracyScore = 10;
            } else {
                accuracyScore = 5;
            }
            priorityScore += accuracyScore;
        }
        
        // ===== RULE 4: DIFFICULTY SCORE (10 điểm) =====
        String cefr = vocab.getCefr();
        int difficultyScore = 0;
        if ("C2".equals(cefr)) {
            difficultyScore = 10;
            reasons.add("Từ rất khó (C2)");
        } else if ("C1".equals(cefr)) {
            difficultyScore = 8;
            reasons.add("Từ khó (C1)");
        } else if ("B2".equals(cefr)) {
            difficultyScore = 6;
        } else if ("B1".equals(cefr)) {
            difficultyScore = 4;
        } else if ("A2".equals(cefr)) {
            difficultyScore = 2;
        } else {
            difficultyScore = 1;
        }
        priorityScore += difficultyScore;
        
        // ===== RULE 5: BONUS - LONG TIME NO REVIEW =====
        if (daysSinceLastReview > 30) {
            priorityScore += 10;
            reasons.add(String.format("Đã lâu không ôn (%d ngày)", daysSinceLastReview));
        } else if (daysSinceLastReview > 14) {
            priorityScore += 5;
        }
        
        // Determine priority level
        String priorityLevel;
        if (priorityScore >= 60) {
            priorityLevel = "HIGH";
        } else if (priorityScore >= 30) {
            priorityLevel = "MEDIUM";
        } else {
            priorityLevel = "LOW";
        }
        
        return VocabRecommendation.builder()
                .vocabId(vocab.getId())
                .word(vocab.getWord())
                .transcription(vocab.getTranscription())
                .meaningVi(vocab.getMeaningVi())
                .cefr(vocab.getCefr())
                .img(vocab.getImg())
                .audio(vocab.getAudio())
                .topicName(vocab.getTopic() != null ? vocab.getTopic().getName() : null)
                .priorityScore(priorityScore)
                .priorityLevel(priorityLevel)
                .reasons(reasons)
                .status(progress.getStatus())
                .timesCorrect(progress.getTimesCorrect())
                .timesWrong(progress.getTimesWrong())
                .accuracyRate(accuracyRate)
                .lastReviewed(progress.getLastReviewed())
                .nextReviewDate(progress.getNextReviewDate())
                .daysSinceLastReview(daysSinceLastReview)
                .daysOverdue(daysOverdue)
                .build();
    }
    
    /**
     * Apply filters (topic, status) to vocab progress list
     */
    private List<UserVocabProgress> applyFilters(
            List<UserVocabProgress> progressList,
            String topicFilter,
            String statusFilter) {
        
        return progressList.stream()
                .filter(p -> topicFilter == null || topicFilter.trim().isEmpty() ||
                        (p.getVocab().getTopic() != null && 
                         p.getVocab().getTopic().getName().equalsIgnoreCase(topicFilter)))
                .filter(p -> statusFilter == null || statusFilter.trim().isEmpty() ||
                        p.getStatus().name().equalsIgnoreCase(statusFilter))
                .collect(Collectors.toList());
    }
    
    /**
     * Build summary statistics from recommendations
     */
    private SmartReviewResponse.RecommendationSummary buildSummary(List<VocabRecommendation> recommendations) {
        int highPriority = (int) recommendations.stream()
                .filter(r -> r.getPriorityScore() >= 60)
                .count();
        
        int mediumPriority = (int) recommendations.stream()
                .filter(r -> r.getPriorityScore() >= 30 && r.getPriorityScore() < 60)
                .count();
        
        int lowPriority = (int) recommendations.stream()
                .filter(r -> r.getPriorityScore() < 30)
                .count();
        
        int overdueCount = (int) recommendations.stream()
                .filter(r -> r.getDaysOverdue() > 0)
                .count();
        
        int unknownCount = (int) recommendations.stream()
                .filter(r -> r.getStatus() == VocabStatus.UNKNOWN)
                .count();
        
        int lowAccuracyCount = (int) recommendations.stream()
                .filter(r -> r.getAccuracyRate() != null && r.getAccuracyRate() < 0.5)
                .count();
        
        return SmartReviewResponse.RecommendationSummary.builder()
                .highPriority(highPriority)
                .mediumPriority(mediumPriority)
                .lowPriority(lowPriority)
                .overdueCount(overdueCount)
                .unknownCount(unknownCount)
                .lowAccuracyCount(lowAccuracyCount)
                .build();
    }
    
    /**
     * Build empty response when user has no vocab progress
     */
    private SmartReviewResponse buildEmptyResponse() {
        return SmartReviewResponse.builder()
                .recommendations(new ArrayList<>())
                .totalAnalyzed(0)
                .totalRecommended(0)
                .summary(SmartReviewResponse.RecommendationSummary.builder()
                        .highPriority(0)
                        .mediumPriority(0)
                        .lowPriority(0)
                        .overdueCount(0)
                        .unknownCount(0)
                        .lowAccuracyCount(0)
                        .build())
                .build();
    }
}
