# API Gợi Ý Ôn Tập Thông Minh - Dựa Trên Dữ Liệu Game

## Phân Tích Cấu Trúc Database

### Entities Quan Trọng

```
User (users)
├── gameSessions (Set<GameSession>)
├── vocabProgress (Set<UserVocabProgress>)
├── currentStreak, longestStreak
├── totalStudyDays
└── currentLevel (CEFR)

GameSession (game_sessions)
├── user (User)
├── game (Game)
├── topic (Topic)
├── details (Set<GameSessionDetail>)
├── startedAt, finishedAt
├── totalQuestions, correctCount
├── accuracy, score
└── duration

GameSessionDetail (game_session_details)
├── session (GameSession)
├── vocab (Vocab)
├── isCorrect (Boolean)
└── timeTaken (Integer)

UserVocabProgress (user_vocab_progress)
├── user (User)
├── vocab (Vocab)
├── status (VocabStatus: NEW, KNOWN, UNKNOWN, MASTERED)
├── timesCorrect, timesWrong
├── efFactor, intervalDays, repetition
├── lastReviewed, nextReviewDate
└── createdAt, updatedAt

Vocab (vocab)
├── word, transcription, meaningVi
├── cefr (A1-C2)
├── topic (Topic)
└── types (Set<Type>)
```

### Insight Quan Trọng

**Khi user chơi 1 game:**
- Tạo 1 `GameSession`
- Tạo 5-10 `GameSessionDetail` (mỗi câu hỏi)
- Tạo/Update 5-10 `UserVocabProgress`

**Ví dụ:**
- 100 users
- Mỗi user chơi 20 games
- Mỗi game có 10 questions
- → **20,000 GameSessionDetail records** 🎉
- → **Đủ data để train ML model!**


## Chiến Lược Thu Thập Training Data

### Query 1: Lấy Dữ Liệu Từ Game Sessions

```sql
-- Training data từ game sessions
WITH user_stats AS (
    SELECT 
        u.id as user_id,
        COUNT(DISTINCT uvp.vocab_id) as total_vocabs_learned,
        AVG(CASE 
            WHEN uvp.times_correct + uvp.times_wrong > 0 
            THEN uvp.times_correct::float / (uvp.times_correct + uvp.times_wrong)
            ELSE 0 
        END) as user_accuracy,
        u.current_streak,
        u.total_study_days,
        u.current_level
    FROM users u
    LEFT JOIN user_vocab_progress uvp ON u.id = uvp.user_id
    GROUP BY u.id
),
game_vocab_history AS (
    SELECT 
        gs.user_id,
        gsd.vocab_id,
        gsd.is_correct,
        gsd.time_taken,
        gsd.created_at,
        v.cefr,
        v.word,
        LENGTH(v.word) as vocab_length,
        t.name as topic_name,
        gs.game_id,
        -- Lấy kết quả lần chơi TIẾP THEO để làm target
        LEAD(gsd.is_correct) OVER (
            PARTITION BY gs.user_id, gsd.vocab_id 
            ORDER BY gsd.created_at
        ) as next_is_correct,
        LEAD(gsd.created_at) OVER (
            PARTITION BY gs.user_id, gsd.vocab_id 
            ORDER BY gsd.created_at
        ) as next_attempt_time
    FROM game_session_details gsd
    JOIN game_sessions gs ON gsd.session_id = gs.id
    JOIN vocabs v ON gsd.vocab_id = v.id
    LEFT JOIN topics t ON v.topic_id = t.id
    WHERE gs.finished_at IS NOT NULL  -- Chỉ lấy game đã hoàn thành
),
vocab_progress_at_time AS (
    SELECT 
        gvh.*,
        COALESCE(uvp.times_correct, 0) as times_correct,
        COALESCE(uvp.times_wrong, 0) as times_wrong,
        COALESCE(uvp.repetition, 0) as repetition,
        COALESCE(uvp.ef_factor, 2.5) as ef_factor,
        COALESCE(uvp.interval_days, 1) as interval_days,
        COALESCE(uvp.status, 'NEW') as status,
        COALESCE(
            EXTRACT(DAY FROM (gvh.created_at::date - uvp.last_reviewed)), 
            999
        ) as days_since_last_review,
        COALESCE(
            EXTRACT(DAY FROM (uvp.next_review_date - gvh.created_at::date)), 
            0
        ) as days_until_next_review
    FROM game_vocab_history gvh
    LEFT JOIN user_vocab_progress uvp 
        ON gvh.user_id = uvp.user_id 
        AND gvh.vocab_id = uvp.vocab_id
        AND uvp.updated_at <= gvh.created_at  -- Progress tại thời điểm chơi
)
SELECT 
    vpt.user_id,
    vpt.vocab_id,
    vpt.word,
    
    -- User features
    us.total_vocabs_learned as user_total_vocabs,
    us.user_accuracy,
    us.current_streak as user_streak,
    us.total_study_days,
    
    -- Vocab features
    CASE vpt.cefr 
        WHEN 'A1' THEN 1 WHEN 'A2' THEN 2 
        WHEN 'B1' THEN 3 WHEN 'B2' THEN 4 
        WHEN 'C1' THEN 5 WHEN 'C2' THEN 6 
        ELSE 3 
    END as vocab_difficulty,
    vpt.vocab_length,
    vpt.topic_name,
    
    -- Progress features
    vpt.times_correct,
    vpt.times_wrong,
    CASE 
        WHEN vpt.times_correct + vpt.times_wrong > 0 
        THEN vpt.times_correct::float / (vpt.times_correct + vpt.times_wrong)
        ELSE 0 
    END as accuracy_rate,
    vpt.repetition,
    vpt.ef_factor,
    vpt.interval_days,
    vpt.days_since_last_review,
    vpt.days_until_next_review,
    CASE WHEN vpt.days_until_next_review < 0 THEN 1 ELSE 0 END as is_overdue,
    CASE 
        WHEN vpt.days_until_next_review < 0 
        THEN ABS(vpt.days_until_next_review) 
        ELSE 0 
    END as overdue_days,
    
    -- Current attempt features
    vpt.is_correct as current_is_correct,
    vpt.time_taken as current_time_taken,
    
    -- Temporal features
    EXTRACT(HOUR FROM vpt.created_at) as hour_of_day,
    EXTRACT(DOW FROM vpt.created_at) as day_of_week,
    CASE WHEN EXTRACT(DOW FROM vpt.created_at) IN (0, 6) THEN 1 ELSE 0 END as is_weekend,
    
    -- Target: Có quên ở lần chơi tiếp theo không?
    CASE 
        WHEN vpt.next_is_correct IS NULL THEN NULL  -- Chưa có lần chơi tiếp theo
        WHEN vpt.next_is_correct = false THEN 1     -- Quên (trả lời sai)
        ELSE 0                                       -- Nhớ (trả lời đúng)
    END as forgot,
    
    -- Metadata
    vpt.created_at as attempt_time,
    vpt.next_attempt_time,
    EXTRACT(DAY FROM (vpt.next_attempt_time - vpt.created_at)) as days_between_attempts
    
FROM vocab_progress_at_time vpt
JOIN user_stats us ON vpt.user_id = us.user_id
WHERE vpt.next_is_correct IS NOT NULL  -- Chỉ lấy records có target
    AND vpt.created_at >= NOW() - INTERVAL '6 months'  -- Data 6 tháng gần nhất
ORDER BY vpt.created_at DESC;
```

**Ước tính số lượng data:**
- 100 users × 20 games × 10 questions = 20,000 records
- Mỗi vocab được chơi 2-3 lần → ~10,000 training samples với target


### Query 2: Lấy Dữ Liệu Hiện Tại Để Predict

```sql
-- Lấy dữ liệu hiện tại của user để predict
WITH user_stats AS (
    SELECT 
        u.id as user_id,
        COUNT(DISTINCT uvp.vocab_id) as total_vocabs_learned,
        AVG(CASE 
            WHEN uvp.times_correct + uvp.times_wrong > 0 
            THEN uvp.times_correct::float / (uvp.times_correct + uvp.times_wrong)
            ELSE 0 
        END) as user_accuracy,
        u.current_streak,
        u.total_study_days
    FROM users u
    LEFT JOIN user_vocab_progress uvp ON u.id = uvp.user_id
    WHERE u.id = :userId
    GROUP BY u.id
)
SELECT 
    uvp.id as progress_id,
    uvp.vocab_id,
    v.word,
    
    -- User features
    us.total_vocabs_learned as user_total_vocabs,
    us.user_accuracy,
    us.current_streak as user_streak,
    us.total_study_days,
    
    -- Vocab features
    CASE v.cefr 
        WHEN 'A1' THEN 1 WHEN 'A2' THEN 2 
        WHEN 'B1' THEN 3 WHEN 'B2' THEN 4 
        WHEN 'C1' THEN 5 WHEN 'C2' THEN 6 
        ELSE 3 
    END as vocab_difficulty,
    LENGTH(v.word) as vocab_length,
    t.name as topic_name,
    v.cefr,
    v.transcription,
    v.meaning_vi,
    v.img,
    v.audio,
    
    -- Progress features
    uvp.times_correct,
    uvp.times_wrong,
    CASE 
        WHEN uvp.times_correct + uvp.times_wrong > 0 
        THEN uvp.times_correct::float / (uvp.times_correct + uvp.times_wrong)
        ELSE 0 
    END as accuracy_rate,
    uvp.repetition,
    uvp.ef_factor,
    uvp.interval_days,
    COALESCE(EXTRACT(DAY FROM (CURRENT_DATE - uvp.last_reviewed)), 999) as days_since_last_review,
    COALESCE(EXTRACT(DAY FROM (uvp.next_review_date - CURRENT_DATE)), 0) as days_until_next_review,
    CASE WHEN uvp.next_review_date < CURRENT_DATE THEN 1 ELSE 0 END as is_overdue,
    CASE 
        WHEN uvp.next_review_date < CURRENT_DATE 
        THEN EXTRACT(DAY FROM (CURRENT_DATE - uvp.next_review_date))
        ELSE 0 
    END as overdue_days,
    uvp.status,
    uvp.last_reviewed,
    uvp.next_review_date,
    
    -- Temporal features
    EXTRACT(HOUR FROM CURRENT_TIMESTAMP) as hour_of_day,
    EXTRACT(DOW FROM CURRENT_DATE) as day_of_week,
    CASE WHEN EXTRACT(DOW FROM CURRENT_DATE) IN (0, 6) THEN 1 ELSE 0 END as is_weekend

FROM user_vocab_progress uvp
JOIN vocabs v ON uvp.vocab_id = v.id
LEFT JOIN topics t ON v.topic_id = t.id
CROSS JOIN user_stats us
WHERE uvp.user_id = :userId
    AND uvp.status IN ('KNOWN', 'UNKNOWN', 'MASTERED')  -- Chỉ lấy từ đã học
ORDER BY uvp.next_review_date ASC NULLS FIRST;
```


## Implementation: Spring Boot Service

### 1. Repository Method

```java
// UserVocabProgressRepository.java
public interface UserVocabProgressRepository extends JpaRepository<UserVocabProgress, UUID> {
    
    /**
     * Lấy tất cả vocab progress của user để predict
     */
    @Query("""
        SELECT uvp FROM UserVocabProgress uvp
        LEFT JOIN FETCH uvp.vocab v
        LEFT JOIN FETCH v.topic t
        WHERE uvp.user.id = :userId
        AND uvp.status IN ('KNOWN', 'UNKNOWN', 'MASTERED')
        ORDER BY uvp.nextReviewDate ASC NULLS FIRST
        """)
    List<UserVocabProgress> findAllLearnedVocabsForPrediction(@Param("userId") UUID userId);
    
    /**
     * Lấy training data từ game sessions
     */
    @Query(value = """
        WITH user_stats AS (
            SELECT 
                u.id as user_id,
                COUNT(DISTINCT uvp.vocab_id) as total_vocabs_learned,
                AVG(CASE 
                    WHEN uvp.times_correct + uvp.times_wrong > 0 
                    THEN uvp.times_correct::numeric / (uvp.times_correct + uvp.times_wrong)
                    ELSE 0 
                END) as user_accuracy
            FROM users u
            LEFT JOIN user_vocab_progress uvp ON u.id = uvp.user_id
            GROUP BY u.id
        ),
        game_vocab_history AS (
            SELECT 
                gs.user_id,
                gsd.vocab_id,
                gsd.is_correct,
                gsd.time_taken,
                gsd.created_at,
                v.cefr,
                LENGTH(v.word) as vocab_length,
                LEAD(gsd.is_correct) OVER (
                    PARTITION BY gs.user_id, gsd.vocab_id 
                    ORDER BY gsd.created_at
                ) as next_is_correct
            FROM game_session_details gsd
            JOIN game_sessions gs ON gsd.session_id = gs.id
            JOIN vocabs v ON gsd.vocab_id = v.id
            WHERE gs.finished_at IS NOT NULL
                AND gsd.created_at >= CURRENT_DATE - INTERVAL '6 months'
        )
        SELECT 
            gvh.user_id,
            gvh.vocab_id,
            us.total_vocabs_learned,
            us.user_accuracy,
            CASE gvh.cefr 
                WHEN 'A1' THEN 1 WHEN 'A2' THEN 2 
                WHEN 'B1' THEN 3 WHEN 'B2' THEN 4 
                WHEN 'C1' THEN 5 WHEN 'C2' THEN 6 
                ELSE 3 
            END as vocab_difficulty,
            gvh.vocab_length,
            gvh.is_correct as current_is_correct,
            CASE 
                WHEN gvh.next_is_correct = false THEN 1 
                ELSE 0 
            END as forgot
        FROM game_vocab_history gvh
        JOIN user_stats us ON gvh.user_id = us.user_id
        WHERE gvh.next_is_correct IS NOT NULL
        """, nativeQuery = true)
    List<Object[]> getTrainingDataFromGameSessions();
}
```


### 2. DTO Classes

```java
// SmartReviewRecommendationRequest.java
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SmartReviewRecommendationRequest {
    private String userId;
    private Integer limit;
    private String topicFilter;  // Optional: filter by topic
    private String difficultyFilter;  // Optional: A1, A2, B1, B2, C1, C2
}

// VocabRecommendation.java
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VocabRecommendation {
    private UUID vocabId;
    private String word;
    private String transcription;
    private String meaningVi;
    private String cefr;
    private String img;
    private String audio;
    private String topicName;
    
    // Prediction scores
    private Double forgotProbability;  // 0-1: Xác suất quên
    private Double priorityScore;      // 0-100: Điểm ưu tiên tổng hợp
    private String reason;             // Lý do gợi ý
    
    // Progress info
    private VocabStatus status;
    private Integer timesCorrect;
    private Integer timesWrong;
    private LocalDate lastReviewed;
    private LocalDate nextReviewDate;
    private Integer daysSinceLastReview;
    private Integer daysUntilNextReview;
}

// SmartReviewRecommendationResponse.java
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SmartReviewRecommendationResponse {
    private String userId;
    private List<VocabRecommendation> recommendations;
    private Integer totalAnalyzed;
    private Integer totalRecommended;
    private String modelVersion;
    private Boolean usingMlModel;  // true if ML, false if rule-based
    private RecommendationStats stats;
    
    @Data
    @Builder
    public static class RecommendationStats {
        private Integer overdueCount;
        private Integer dueTodayCount;
        private Integer difficultCount;
        private Integer lowAccuracyCount;
        private Double averageForgotProbability;
    }
}
```


### 3. Smart Review Service

```java
// SmartReviewService.java
@Service
@RequiredArgsConstructor
@Slf4j
public class SmartReviewService {
    
    private final UserVocabProgressRepository userVocabProgressRepository;
    private final UserRepository userRepository;
    private final AIServiceClient aiServiceClient;  // Optional: ML service
    
    private static final int MIN_SAMPLES_FOR_ML = 1000;
    
    @Transactional(readOnly = true)
    public SmartReviewRecommendationResponse getSmartRecommendations(
            User user, 
            Integer limit,
            String topicFilter,
            String difficultyFilter) {
        
        log.info("Getting smart recommendations for user: {}", user.getId());
        
        // 1. Lấy tất cả vocab progress của user
        List<UserVocabProgress> allProgress = userVocabProgressRepository
            .findAllLearnedVocabsForPrediction(user.getId());
        
        if (allProgress.isEmpty()) {
            return buildEmptyResponse(user.getId());
        }
        
        // 2. Apply filters
        List<UserVocabProgress> filteredProgress = applyFilters(
            allProgress, topicFilter, difficultyFilter
        );
        
        // 3. Calculate user stats
        UserStats userStats = calculateUserStats(allProgress);
        
        // 4. Decide: ML or Rule-based
        boolean useMl = shouldUseMlModel(allProgress.size());
        
        List<VocabRecommendation> recommendations;
        if (useMl) {
            log.info("Using ML model for recommendations");
            recommendations = getMlRecommendations(filteredProgress, userStats);
        } else {
            log.info("Using rule-based recommendations");
            recommendations = getRuleBasedRecommendations(filteredProgress, userStats);
        }
        
        // 5. Sort and limit
        recommendations.sort((a, b) -> 
            Double.compare(b.getPriorityScore(), a.getPriorityScore())
        );
        
        if (limit != null && limit > 0 && recommendations.size() > limit) {
            recommendations = recommendations.subList(0, limit);
        }
        
        // 6. Calculate stats
        RecommendationStats stats = calculateStats(recommendations);
        
        return SmartReviewRecommendationResponse.builder()
            .userId(user.getId().toString())
            .recommendations(recommendations)
            .totalAnalyzed(filteredProgress.size())
            .totalRecommended(recommendations.size())
            .modelVersion("1.0.0")
            .usingMlModel(useMl)
            .stats(stats)
            .build();
    }
    
    private boolean shouldUseMlModel(int dataSize) {
        // Chỉ dùng ML nếu có đủ data
        return dataSize >= MIN_SAMPLES_FOR_ML && aiServiceClient.isHealthy();
    }
    
    private List<VocabRecommendation> getRuleBasedRecommendations(
            List<UserVocabProgress> progressList,
            UserStats userStats) {
        
        List<VocabRecommendation> recommendations = new ArrayList<>();
        LocalDate today = LocalDate.now();
        
        for (UserVocabProgress progress : progressList) {
            double priorityScore = 0;
            double forgotProbability = 0;
            List<String> reasons = new ArrayList<>();
            
            // Calculate days
            int daysSinceLastReview = progress.getLastReviewed() != null
                ? (int) ChronoUnit.DAYS.between(progress.getLastReviewed(), today)
                : 999;
            
            int daysUntilNextReview = progress.getNextReviewDate() != null
                ? (int) ChronoUnit.DAYS.between(today, progress.getNextReviewDate())
                : 0;
            
            // Rule 1: Overdue (40 points)
            if (daysUntilNextReview < 0) {
                int overdueDays = Math.abs(daysUntilNextReview);
                priorityScore += Math.min(overdueDays * 4, 40);
                forgotProbability += 0.4;
                reasons.add(String.format("Quá hạn %d ngày", overdueDays));
            }
            
            // Rule 2: Low accuracy (30 points)
            int totalAttempts = progress.getTimesCorrect() + progress.getTimesWrong();
            if (totalAttempts > 0) {
                double accuracy = (double) progress.getTimesCorrect() / totalAttempts;
                if (accuracy < 0.5) {
                    priorityScore += 30;
                    forgotProbability += 0.3;
                    reasons.add(String.format("Tỷ lệ đúng thấp (%.0f%%)", accuracy * 100));
                } else if (accuracy < 0.7) {
                    priorityScore += 15;
                    forgotProbability += 0.15;
                }
            }
            
            // Rule 3: Difficult vocab (20 points)
            String cefr = progress.getVocab().getCefr();
            if ("C1".equals(cefr) || "C2".equals(cefr)) {
                priorityScore += 20;
                forgotProbability += 0.2;
                reasons.add("Từ khó (C1-C2)");
            } else if ("B2".equals(cefr)) {
                priorityScore += 10;
                forgotProbability += 0.1;
            }
            
            // Rule 4: Due today (10 points)
            if (daysUntilNextReview == 0) {
                priorityScore += 10;
                forgotProbability += 0.1;
                reasons.add("Đến hạn ôn tập hôm nay");
            }
            
            // Rule 5: Long time since last review
            if (daysSinceLastReview > 30) {
                priorityScore += 15;
                forgotProbability += 0.15;
                reasons.add(String.format("Đã lâu không ôn (%d ngày)", daysSinceLastReview));
            }
            
            // Normalize forgot probability
            forgotProbability = Math.min(forgotProbability, 1.0);
            
            // Only recommend if priority > 0
            if (priorityScore > 0) {
                recommendations.add(buildRecommendation(
                    progress, 
                    forgotProbability, 
                    priorityScore,
                    String.join(" • ", reasons),
                    daysSinceLastReview,
                    daysUntilNextReview
                ));
            }
        }
        
        return recommendations;
    }
    
    private List<VocabRecommendation> getMlRecommendations(
            List<UserVocabProgress> progressList,
            UserStats userStats) {
        
        try {
            // Call AI service
            SmartReviewRequest request = buildAiRequest(progressList, userStats);
            SmartReviewResponse aiResponse = aiServiceClient.getSmartRecommendations(request);
            
            // Convert to recommendations
            return aiResponse.getRecommendations().stream()
                .map(this::convertToVocabRecommendation)
                .collect(Collectors.toList());
                
        } catch (Exception e) {
            log.error("ML prediction failed, falling back to rule-based: {}", e.getMessage());
            return getRuleBasedRecommendations(progressList, userStats);
        }
    }
    
    private VocabRecommendation buildRecommendation(
            UserVocabProgress progress,
            double forgotProbability,
            double priorityScore,
            String reason,
            int daysSinceLastReview,
            int daysUntilNextReview) {
        
        Vocab vocab = progress.getVocab();
        
        return VocabRecommendation.builder()
            .vocabId(vocab.getId())
            .word(vocab.getWord())
            .transcription(vocab.getTranscription())
            .meaningVi(vocab.getMeaningVi())
            .cefr(vocab.getCefr())
            .img(vocab.getImg())
            .audio(vocab.getAudio())
            .topicName(vocab.getTopic() != null ? vocab.getTopic().getName() : null)
            .forgotProbability(forgotProbability)
            .priorityScore(priorityScore)
            .reason(reason)
            .status(progress.getStatus())
            .timesCorrect(progress.getTimesCorrect())
            .timesWrong(progress.getTimesWrong())
            .lastReviewed(progress.getLastReviewed())
            .nextReviewDate(progress.getNextReviewDate())
            .daysSinceLastReview(daysSinceLastReview)
            .daysUntilNextReview(daysUntilNextReview)
            .build();
    }
    
    // Helper methods...
    private List<UserVocabProgress> applyFilters(
            List<UserVocabProgress> progressList,
            String topicFilter,
            String difficultyFilter) {
        
        return progressList.stream()
            .filter(p -> topicFilter == null || 
                (p.getVocab().getTopic() != null && 
                 p.getVocab().getTopic().getName().equalsIgnoreCase(topicFilter)))
            .filter(p -> difficultyFilter == null || 
                difficultyFilter.equalsIgnoreCase(p.getVocab().getCefr()))
            .collect(Collectors.toList());
    }
    
    private UserStats calculateUserStats(List<UserVocabProgress> progressList) {
        long totalCorrect = progressList.stream()
            .mapToLong(UserVocabProgress::getTimesCorrect)
            .sum();
        
        long totalWrong = progressList.stream()
            .mapToLong(UserVocabProgress::getTimesWrong)
            .sum();
        
        double accuracy = (totalCorrect + totalWrong) > 0
            ? (double) totalCorrect / (totalCorrect + totalWrong)
            : 0.0;
        
        return new UserStats(progressList.size(), accuracy);
    }
    
    private RecommendationStats calculateStats(List<VocabRecommendation> recommendations) {
        LocalDate today = LocalDate.now();
        
        int overdueCount = (int) recommendations.stream()
            .filter(r -> r.getDaysUntilNextReview() < 0)
            .count();
        
        int dueTodayCount = (int) recommendations.stream()
            .filter(r -> r.getDaysUntilNextReview() == 0)
            .count();
        
        int difficultCount = (int) recommendations.stream()
            .filter(r -> "C1".equals(r.getCefr()) || "C2".equals(r.getCefr()))
            .count();
        
        int lowAccuracyCount = (int) recommendations.stream()
            .filter(r -> {
                int total = r.getTimesCorrect() + r.getTimesWrong();
                return total > 0 && ((double) r.getTimesCorrect() / total) < 0.5;
            })
            .count();
        
        double avgForgotProb = recommendations.stream()
            .mapToDouble(VocabRecommendation::getForgotProbability)
            .average()
            .orElse(0.0);
        
        return RecommendationStats.builder()
            .overdueCount(overdueCount)
            .dueTodayCount(dueTodayCount)
            .difficultCount(difficultCount)
            .lowAccuracyCount(lowAccuracyCount)
            .averageForgotProbability(avgForgotProb)
            .build();
    }
    
    private SmartReviewRecommendationResponse buildEmptyResponse(UUID userId) {
        return SmartReviewRecommendationResponse.builder()
            .userId(userId.toString())
            .recommendations(new ArrayList<>())
            .totalAnalyzed(0)
            .totalRecommended(0)
            .modelVersion("1.0.0")
            .usingMlModel(false)
            .stats(RecommendationStats.builder()
                .overdueCount(0)
                .dueTodayCount(0)
                .difficultCount(0)
                .lowAccuracyCount(0)
                .averageForgotProbability(0.0)
                .build())
            .build();
    }
    
    @Data
    @AllArgsConstructor
    private static class UserStats {
        private int totalVocabs;
        private double accuracy;
    }
}
```


### 4. Controller

```java
// SmartReviewController.java
@RestController
@RequestMapping("/api/v1/smart-review")
@RequiredArgsConstructor
@Tag(name = "Smart Review", description = "API gợi ý ôn tập thông minh")
public class SmartReviewController {
    
    private final SmartReviewService smartReviewService;
    
    @GetMapping("/recommendations")
    @Operation(
        summary = "Lấy gợi ý ôn tập thông minh",
        description = "Gợi ý từ vựng nên ôn tập dựa trên AI/ML hoặc rule-based algorithm",
        security = @SecurityRequirement(name = "Bearer Authentication")
    )
    public ResponseEntity<ApiResponse<SmartReviewRecommendationResponse>> getRecommendations(
            @AuthenticationPrincipal User user,
            @Parameter(description = "Số lượng gợi ý tối đa") 
            @RequestParam(required = false, defaultValue = "20") Integer limit,
            @Parameter(description = "Lọc theo topic") 
            @RequestParam(required = false) String topic,
            @Parameter(description = "Lọc theo độ khó (A1-C2)") 
            @RequestParam(required = false) String difficulty) {
        
        SmartReviewRecommendationResponse response = smartReviewService
            .getSmartRecommendations(user, limit, topic, difficulty);
        
        String message = response.getUsingMlModel()
            ? "Gợi ý ôn tập thông minh (AI-powered)"
            : "Gợi ý ôn tập thông minh (Rule-based)";
        
        return ResponseEntity.ok(ApiResponse.success(message, response));
    }
    
    @GetMapping("/stats")
    @Operation(
        summary = "Thống kê gợi ý ôn tập",
        description = "Xem thống kê về các từ cần ôn tập",
        security = @SecurityRequirement(name = "Bearer Authentication")
    )
    public ResponseEntity<ApiResponse<RecommendationStats>> getStats(
            @AuthenticationPrincipal User user) {
        
        SmartReviewRecommendationResponse response = smartReviewService
            .getSmartRecommendations(user, null, null, null);
        
        return ResponseEntity.ok(ApiResponse.success(
            "Lấy thống kê thành công",
            response.getStats()
        ));
    }
}
```


## API Response Examples

### Example 1: Rule-Based Response (Ít data)

```json
{
  "success": true,
  "message": "Gợi ý ôn tập thông minh (Rule-based)",
  "data": {
    "userId": "123e4567-e89b-12d3-a456-426614174000",
    "recommendations": [
      {
        "vocabId": "vocab-uuid-1",
        "word": "abandon",
        "transcription": "/əˈbændən/",
        "meaningVi": "từ bỏ, bỏ rơi",
        "cefr": "B2",
        "img": "https://example.com/abandon.jpg",
        "audio": "https://example.com/abandon.mp3",
        "topicName": "Daily Life",
        "forgotProbability": 0.75,
        "priorityScore": 65,
        "reason": "Quá hạn 5 ngày • Tỷ lệ đúng thấp (40%)",
        "status": "UNKNOWN",
        "timesCorrect": 2,
        "timesWrong": 3,
        "lastReviewed": "2024-11-10",
        "nextReviewDate": "2024-11-12",
        "daysSinceLastReview": 7,
        "daysUntilNextReview": -5
      },
      {
        "vocabId": "vocab-uuid-2",
        "word": "sophisticated",
        "transcription": "/səˈfɪstɪkeɪtɪd/",
        "meaningVi": "tinh vi, phức tạp",
        "cefr": "C1",
        "img": null,
        "audio": "https://example.com/sophisticated.mp3",
        "topicName": "Academic",
        "forgotProbability": 0.6,
        "priorityScore": 50,
        "reason": "Từ khó (C1-C2) • Đến hạn ôn tập hôm nay",
        "status": "KNOWN",
        "timesCorrect": 5,
        "timesWrong": 2,
        "lastReviewed": "2024-11-10",
        "nextReviewDate": "2024-11-17",
        "daysSinceLastReview": 7,
        "daysUntilNextReview": 0
      }
    ],
    "totalAnalyzed": 45,
    "totalRecommended": 2,
    "modelVersion": "1.0.0",
    "usingMlModel": false,
    "stats": {
      "overdueCount": 1,
      "dueTodayCount": 1,
      "difficultCount": 1,
      "lowAccuracyCount": 1,
      "averageForgotProbability": 0.675
    }
  }
}
```

### Example 2: ML-Powered Response (Nhiều data)

```json
{
  "success": true,
  "message": "Gợi ý ôn tập thông minh (AI-powered)",
  "data": {
    "userId": "123e4567-e89b-12d3-a456-426614174000",
    "recommendations": [
      {
        "vocabId": "vocab-uuid-3",
        "word": "procrastinate",
        "transcription": "/prəˈkræstɪneɪt/",
        "meaningVi": "trì hoãn",
        "cefr": "C1",
        "img": null,
        "audio": "https://example.com/procrastinate.mp3",
        "topicName": "Work",
        "forgotProbability": 0.89,
        "priorityScore": 92,
        "reason": "AI dự đoán xác suất quên cao • Quá hạn 3 ngày",
        "status": "KNOWN",
        "timesCorrect": 3,
        "timesWrong": 4,
        "lastReviewed": "2024-11-08",
        "nextReviewDate": "2024-11-14",
        "daysSinceLastReview": 9,
        "daysUntilNextReview": -3
      }
    ],
    "totalAnalyzed": 150,
    "totalRecommended": 20,
    "modelVersion": "1.0.0",
    "usingMlModel": true,
    "stats": {
      "overdueCount": 8,
      "dueTodayCount": 5,
      "difficultCount": 12,
      "lowAccuracyCount": 6,
      "averageForgotProbability": 0.72
    }
  }
}
```


## Data Collection Script

### Python Script: Export Training Data

```python
# export_training_data.py
import psycopg2
import pandas as pd
from datetime import datetime

def export_training_data():
    """
    Export training data từ database
    """
    # Database connection
    conn = psycopg2.connect(
        host="localhost",
        database="card_words",
        user="postgres",
        password="your_password"
    )
    
    # Query training data
    query = """
    WITH user_stats AS (
        SELECT 
            u.id as user_id,
            COUNT(DISTINCT uvp.vocab_id) as total_vocabs_learned,
            AVG(CASE 
                WHEN uvp.times_correct + uvp.times_wrong > 0 
                THEN uvp.times_correct::numeric / (uvp.times_correct + uvp.times_wrong)
                ELSE 0 
            END) as user_accuracy,
            u.current_streak,
            u.total_study_days
        FROM users u
        LEFT JOIN user_vocab_progress uvp ON u.id = uvp.user_id
        GROUP BY u.id
    ),
    game_vocab_history AS (
        SELECT 
            gs.user_id,
            gsd.vocab_id,
            gsd.is_correct,
            gsd.time_taken,
            gsd.created_at,
            v.cefr,
            v.word,
            LENGTH(v.word) as vocab_length,
            LEAD(gsd.is_correct) OVER (
                PARTITION BY gs.user_id, gsd.vocab_id 
                ORDER BY gsd.created_at
            ) as next_is_correct,
            LEAD(gsd.created_at) OVER (
                PARTITION BY gs.user_id, gsd.vocab_id 
                ORDER BY gsd.created_at
            ) as next_attempt_time
        FROM game_session_details gsd
        JOIN game_sessions gs ON gsd.session_id = gs.id
        JOIN vocabs v ON gsd.vocab_id = v.id
        WHERE gs.finished_at IS NOT NULL
            AND gsd.created_at >= CURRENT_DATE - INTERVAL '6 months'
    ),
    vocab_progress_at_time AS (
        SELECT 
            gvh.*,
            COALESCE(uvp.times_correct, 0) as times_correct,
            COALESCE(uvp.times_wrong, 0) as times_wrong,
            COALESCE(uvp.repetition, 0) as repetition,
            COALESCE(uvp.ef_factor, 2.5) as ef_factor,
            COALESCE(uvp.interval_days, 1) as interval_days,
            COALESCE(
                EXTRACT(DAY FROM (gvh.created_at::date - uvp.last_reviewed)), 
                999
            ) as days_since_last_review,
            COALESCE(
                EXTRACT(DAY FROM (uvp.next_review_date - gvh.created_at::date)), 
                0
            ) as days_until_next_review
        FROM game_vocab_history gvh
        LEFT JOIN user_vocab_progress uvp 
            ON gvh.user_id = uvp.user_id 
            AND gvh.vocab_id = uvp.vocab_id
            AND uvp.updated_at <= gvh.created_at
    )
    SELECT 
        vpt.user_id,
        vpt.vocab_id,
        vpt.word,
        us.total_vocabs_learned as user_total_vocabs,
        us.user_accuracy,
        us.current_streak as user_streak,
        us.total_study_days,
        CASE vpt.cefr 
            WHEN 'A1' THEN 1 WHEN 'A2' THEN 2 
            WHEN 'B1' THEN 3 WHEN 'B2' THEN 4 
            WHEN 'C1' THEN 5 WHEN 'C2' THEN 6 
            ELSE 3 
        END as vocab_difficulty,
        vpt.vocab_length,
        vpt.times_correct,
        vpt.times_wrong,
        CASE 
            WHEN vpt.times_correct + vpt.times_wrong > 0 
            THEN vpt.times_correct::numeric / (vpt.times_correct + vpt.times_wrong)
            ELSE 0 
        END as accuracy_rate,
        vpt.repetition,
        vpt.ef_factor,
        vpt.interval_days,
        vpt.days_since_last_review,
        vpt.days_until_next_review,
        CASE WHEN vpt.days_until_next_review < 0 THEN 1 ELSE 0 END as is_overdue,
        CASE 
            WHEN vpt.days_until_next_review < 0 
            THEN ABS(vpt.days_until_next_review) 
            ELSE 0 
        END as overdue_days,
        vpt.is_correct as current_is_correct,
        vpt.time_taken as current_time_taken,
        EXTRACT(HOUR FROM vpt.created_at) as hour_of_day,
        EXTRACT(DOW FROM vpt.created_at) as day_of_week,
        CASE WHEN EXTRACT(DOW FROM vpt.created_at) IN (0, 6) THEN 1 ELSE 0 END as is_weekend,
        CASE 
            WHEN vpt.next_is_correct = false THEN 1 
            ELSE 0 
        END as forgot,
        vpt.created_at as attempt_time,
        vpt.next_attempt_time,
        EXTRACT(DAY FROM (vpt.next_attempt_time - vpt.created_at)) as days_between_attempts
    FROM vocab_progress_at_time vpt
    JOIN user_stats us ON vpt.user_id = us.user_id
    WHERE vpt.next_is_correct IS NOT NULL
    ORDER BY vpt.created_at DESC
    """
    
    # Execute query
    df = pd.read_sql_query(query, conn)
    
    # Save to CSV
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"training_data_{timestamp}.csv"
    df.to_csv(filename, index=False)
    
    print(f"✅ Exported {len(df)} training samples to {filename}")
    print(f"📊 Data shape: {df.shape}")
    print(f"🎯 Target distribution:")
    print(df['forgot'].value_counts())
    print(f"\n📈 Sample statistics:")
    print(df.describe())
    
    conn.close()
    
    return df

if __name__ == "__main__":
    df = export_training_data()
```


## Implementation Roadmap

### Phase 1: Rule-Based (Week 1) ✅ Ngay lập tức

**Mục tiêu:** Deploy API gợi ý cơ bản không cần ML

**Tasks:**
1. ✅ Implement `SmartReviewService` với rule-based logic
2. ✅ Implement `SmartReviewController`
3. ✅ Test với data hiện tại
4. ✅ Deploy to production

**Expected Results:**
- API hoạt động ngay với data ít
- Accuracy: ~60-70% (dựa trên rules)
- Response time: < 100ms

---

### Phase 2: Data Collection (Week 2-4) 📊

**Mục tiêu:** Thu thập đủ training data

**Tasks:**
1. ✅ Implement data export script
2. ✅ Run export weekly
3. ✅ Monitor data quality
4. ✅ Target: 5,000+ samples

**Expected Results:**
- 5,000-10,000 training samples
- Balanced target distribution
- Clean, validated data

---

### Phase 3: ML Model Training (Week 5-6) 🤖

**Mục tiêu:** Train XGBoost model

**Tasks:**
1. ✅ Feature engineering
2. ✅ Train XGBoost model
3. ✅ Evaluate performance (target AUC > 0.80)
4. ✅ Save model

**Expected Results:**
- AUC-ROC: 0.80-0.85
- Better than rule-based
- Model size: < 30MB

---

### Phase 4: ML Integration (Week 7) 🔗

**Mục tiêu:** Integrate ML model vào API

**Tasks:**
1. ✅ Deploy FastAPI AI service
2. ✅ Implement `AIServiceClient`
3. ✅ Update `SmartReviewService` để dùng ML
4. ✅ A/B testing: ML vs Rule-based

**Expected Results:**
- Hybrid system: ML + Rule-based fallback
- Accuracy improvement: +15-20%
- Response time: < 200ms

---

### Phase 5: Monitoring & Optimization (Week 8+) 📈

**Mục tiêu:** Monitor và improve

**Tasks:**
1. ✅ Monitor prediction accuracy
2. ✅ Collect user feedback
3. ✅ Retrain model monthly
4. ✅ Optimize performance

**Expected Results:**
- Continuous improvement
- User satisfaction > 80%
- Model accuracy > 0.85

