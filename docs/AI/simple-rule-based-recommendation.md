# Gợi Ý Ôn Tập Đơn Giản - Rule-Based

## Chiến Lược Đơn Giản & Hiệu Quả

### Không Cần ML, Chỉ Cần Rules! ✅

**Dựa vào các field có sẵn trong `user_vocab_progress`:**
- `status` (NEW, KNOWN, UNKNOWN, MASTERED)
- `times_correct` (số lần đúng)
- `times_wrong` (số lần sai)
- `next_review_date` (ngày ôn tập tiếp theo)
- `last_reviewed` (lần ôn tập cuối)
- `interval_days` (khoảng cách ôn tập)

## Thuật Toán Gợi Ý

### Priority Score Formula

```
Priority Score = 
    Overdue Score (40 điểm) +
    Status Score (30 điểm) +
    Accuracy Score (20 điểm) +
    Difficulty Score (10 điểm)
```

### Rule 1: Overdue Score (40 điểm)

**Ưu tiên từ quá hạn ôn tập:**

```java
if (daysUntilNextReview < 0) {
    int overdueDays = Math.abs(daysUntilNextReview);
    overdue_score = Math.min(overdueDays * 5, 40);
    // Quá hạn 1 ngày = 5 điểm
    // Quá hạn 8+ ngày = 40 điểm (max)
}
```

**Ví dụ:**
- Quá hạn 1 ngày → 5 điểm
- Quá hạn 3 ngày → 15 điểm
- Quá hạn 5 ngày → 25 điểm
- Quá hạn 8+ ngày → 40 điểm

---

### Rule 2: Status Score (30 điểm)

**Ưu tiên theo status:**

```java
switch (status) {
    case UNKNOWN:  // Chưa thuộc - ưu tiên cao nhất
        status_score = 30;
        break;
    case NEW:      // Mới - ưu tiên cao
        status_score = 25;
        break;
    case KNOWN:    // Đã thuộc - ưu tiên trung bình
        status_score = 15;
        break;
    case MASTERED: // Thành thạo - ưu tiên thấp
        status_score = 5;
        break;
}
```

**Logic:**
- UNKNOWN → Cần ôn gấp vì chưa thuộc
- NEW → Cần học để chuyển sang KNOWN
- KNOWN → Ôn tập duy trì
- MASTERED → Ít cần ôn tập

---

### Rule 3: Accuracy Score (20 điểm)

**Ưu tiên từ có tỷ lệ sai cao:**

```java
int totalAttempts = timesCorrect + timesWrong;

if (totalAttempts > 0) {
    double accuracy = (double) timesCorrect / totalAttempts;
    
    if (accuracy < 0.3) {
        accuracy_score = 20;  // Rất kém
    } else if (accuracy < 0.5) {
        accuracy_score = 15;  // Kém
    } else if (accuracy < 0.7) {
        accuracy_score = 10;  // Trung bình
    } else {
        accuracy_score = 5;   // Tốt
    }
}
```

**Ví dụ:**
- 1 đúng / 9 sai (11% accuracy) → 20 điểm
- 2 đúng / 5 sai (29% accuracy) → 20 điểm
- 3 đúng / 4 sai (43% accuracy) → 15 điểm
- 5 đúng / 2 sai (71% accuracy) → 5 điểm

---

### Rule 4: Difficulty Score (10 điểm)

**Ưu tiên từ khó:**

```java
switch (vocab.getCefr()) {
    case "C2":
        difficulty_score = 10;
        break;
    case "C1":
        difficulty_score = 8;
        break;
    case "B2":
        difficulty_score = 6;
        break;
    case "B1":
        difficulty_score = 4;
        break;
    case "A2":
        difficulty_score = 2;
        break;
    case "A1":
        difficulty_score = 1;
        break;
}
```

---

### Rule 5: Bonus - Long Time No Review

**Thêm điểm nếu lâu không ôn:**

```java
if (daysSinceLastReview > 30) {
    bonus_score = 10;
} else if (daysSinceLastReview > 14) {
    bonus_score = 5;
}
```


## Implementation: Spring Boot Service

### 1. DTO Classes

```java
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
    
    // Priority info
    private Integer priorityScore;      // 0-100
    private String priorityLevel;       // HIGH, MEDIUM, LOW
    private List<String> reasons;       // Lý do gợi ý
    
    // Progress info
    private VocabStatus status;
    private Integer timesCorrect;
    private Integer timesWrong;
    private Double accuracyRate;
    private LocalDate lastReviewed;
    private LocalDate nextReviewDate;
    private Integer daysSinceLastReview;
    private Integer daysOverdue;
}

// SmartReviewResponse.java
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SmartReviewResponse {
    private List<VocabRecommendation> recommendations;
    private Integer totalAnalyzed;
    private Integer totalRecommended;
    private RecommendationSummary summary;
    
    @Data
    @Builder
    public static class RecommendationSummary {
        private Integer highPriority;    // Score >= 60
        private Integer mediumPriority;  // Score 30-59
        private Integer lowPriority;     // Score < 30
        private Integer overdueCount;
        private Integer unknownCount;
        private Integer lowAccuracyCount;
    }
}
```

### 2. Service Implementation

```java
// SimpleRecommendationService.java
@Service
@RequiredArgsConstructor
@Slf4j
public class SimpleRecommendationService {
    
    private final UserVocabProgressRepository userVocabProgressRepository;
    
    @Transactional(readOnly = true)
    public SmartReviewResponse getRecommendations(
            User user, 
            Integer limit,
            String topicFilter,
            String statusFilter) {
        
        log.info("Getting recommendations for user: {}", user.getId());
        
        // 1. Lấy tất cả vocab progress
        List<UserVocabProgress> allProgress = userVocabProgressRepository
            .findAllLearnedVocabsForPrediction(user.getId());
        
        if (allProgress.isEmpty()) {
            return buildEmptyResponse();
        }
        
        // 2. Apply filters
        List<UserVocabProgress> filteredProgress = applyFilters(
            allProgress, topicFilter, statusFilter
        );
        
        // 3. Calculate priority for each vocab
        List<VocabRecommendation> recommendations = filteredProgress.stream()
            .map(this::calculatePriority)
            .filter(r -> r.getPriorityScore() > 0)  // Chỉ lấy có priority
            .sorted((a, b) -> b.getPriorityScore().compareTo(a.getPriorityScore()))
            .collect(Collectors.toList());
        
        // 4. Apply limit
        if (limit != null && limit > 0 && recommendations.size() > limit) {
            recommendations = recommendations.subList(0, limit);
        }
        
        // 5. Build summary
        RecommendationSummary summary = buildSummary(recommendations);
        
        return SmartReviewResponse.builder()
            .recommendations(recommendations)
            .totalAnalyzed(filteredProgress.size())
            .totalRecommended(recommendations.size())
            .summary(summary)
            .build();
    }
    
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
    
    private List<UserVocabProgress> applyFilters(
            List<UserVocabProgress> progressList,
            String topicFilter,
            String statusFilter) {
        
        return progressList.stream()
            .filter(p -> topicFilter == null || 
                (p.getVocab().getTopic() != null && 
                 p.getVocab().getTopic().getName().equalsIgnoreCase(topicFilter)))
            .filter(p -> statusFilter == null || 
                p.getStatus().name().equalsIgnoreCase(statusFilter))
            .collect(Collectors.toList());
    }
    
    private RecommendationSummary buildSummary(List<VocabRecommendation> recommendations) {
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
        
        return RecommendationSummary.builder()
            .highPriority(highPriority)
            .mediumPriority(mediumPriority)
            .lowPriority(lowPriority)
            .overdueCount(overdueCount)
            .unknownCount(unknownCount)
            .lowAccuracyCount(lowAccuracyCount)
            .build();
    }
    
    private SmartReviewResponse buildEmptyResponse() {
        return SmartReviewResponse.builder()
            .recommendations(new ArrayList<>())
            .totalAnalyzed(0)
            .totalRecommended(0)
            .summary(RecommendationSummary.builder()
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
```


### 3. Controller

```java
// SmartReviewController.java
@RestController
@RequestMapping("/api/v1/smart-review")
@RequiredArgsConstructor
@Tag(name = "Smart Review", description = "API gợi ý ôn tập thông minh")
public class SmartReviewController {
    
    private final SimpleRecommendationService recommendationService;
    
    @GetMapping("/recommendations")
    @Operation(
        summary = "Lấy gợi ý ôn tập",
        description = "Gợi ý từ vựng nên ôn tập dựa trên status, accuracy, overdue",
        security = @SecurityRequirement(name = "Bearer Authentication")
    )
    public ResponseEntity<ApiResponse<SmartReviewResponse>> getRecommendations(
            @AuthenticationPrincipal User user,
            @Parameter(description = "Số lượng gợi ý (default: 20)") 
            @RequestParam(required = false, defaultValue = "20") Integer limit,
            @Parameter(description = "Lọc theo topic") 
            @RequestParam(required = false) String topic,
            @Parameter(description = "Lọc theo status (NEW, KNOWN, UNKNOWN, MASTERED)") 
            @RequestParam(required = false) String status) {
        
        SmartReviewResponse response = recommendationService.getRecommendations(
            user, limit, topic, status
        );
        
        return ResponseEntity.ok(ApiResponse.success(
            String.format("Tìm thấy %d từ cần ôn tập", response.getTotalRecommended()),
            response
        ));
    }
}
```


## API Response Example

### Request

```bash
GET /api/v1/smart-review/recommendations?limit=5
Authorization: Bearer YOUR_JWT_TOKEN
```

### Response

```json
{
  "success": true,
  "message": "Tìm thấy 5 từ cần ôn tập",
  "data": {
    "recommendations": [
      {
        "vocabId": "uuid-1",
        "word": "abandon",
        "transcription": "/əˈbændən/",
        "meaningVi": "từ bỏ, bỏ rơi",
        "cefr": "B2",
        "img": "https://example.com/abandon.jpg",
        "audio": "https://example.com/abandon.mp3",
        "topicName": "Daily Life",
        
        "priorityScore": 75,
        "priorityLevel": "HIGH",
        "reasons": [
          "Quá hạn 5 ngày",
          "Chưa thuộc từ này",
          "Tỷ lệ đúng thấp (40%)"
        ],
        
        "status": "UNKNOWN",
        "timesCorrect": 2,
        "timesWrong": 3,
        "accuracyRate": 0.4,
        "lastReviewed": "2024-11-10",
        "nextReviewDate": "2024-11-12",
        "daysSinceLastReview": 7,
        "daysOverdue": 5
      },
      {
        "vocabId": "uuid-2",
        "word": "sophisticated",
        "transcription": "/səˈfɪstɪkeɪtɪd/",
        "meaningVi": "tinh vi, phức tạp",
        "cefr": "C1",
        "img": null,
        "audio": "https://example.com/sophisticated.mp3",
        "topicName": "Academic",
        
        "priorityScore": 53,
        "priorityLevel": "MEDIUM",
        "reasons": [
          "Đến hạn ôn tập hôm nay",
          "Từ khó (C1)"
        ],
        
        "status": "KNOWN",
        "timesCorrect": 5,
        "timesWrong": 2,
        "accuracyRate": 0.71,
        "lastReviewed": "2024-11-10",
        "nextReviewDate": "2024-11-17",
        "daysSinceLastReview": 7,
        "daysOverdue": 0
      },
      {
        "vocabId": "uuid-3",
        "word": "procrastinate",
        "transcription": "/prəˈkræstɪneɪt/",
        "meaningVi": "trì hoãn",
        "cefr": "C1",
        "img": null,
        "audio": "https://example.com/procrastinate.mp3",
        "topicName": "Work",
        
        "priorityScore": 48,
        "priorityLevel": "MEDIUM",
        "reasons": [
          "Quá hạn 2 ngày",
          "Từ khó (C1)"
        ],
        
        "status": "KNOWN",
        "timesCorrect": 6,
        "timesWrong": 1,
        "accuracyRate": 0.86,
        "lastReviewed": "2024-11-08",
        "nextReviewDate": "2024-11-15",
        "daysSinceLastReview": 9,
        "daysOverdue": 2
      }
    ],
    "totalAnalyzed": 45,
    "totalRecommended": 5,
    "summary": {
      "highPriority": 1,
      "mediumPriority": 4,
      "lowPriority": 0,
      "overdueCount": 3,
      "unknownCount": 1,
      "lowAccuracyCount": 1
    }
  }
}
```

