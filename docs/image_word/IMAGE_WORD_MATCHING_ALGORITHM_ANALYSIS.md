# Phân Tích Thuật Toán Game Image-Word Matching

## Tổng quan

Game **Image-Word Matching** sử dụng thuật toán và design patterns đơn giản, tập trung vào CEFR-based scoring và time bonus để tạo trải nghiệm học từ vựng hiệu quả.

**Đặc điểm chính:**

-   Single mode (không có nhiều chế độ)
-   Random vocab selection (không filter theo topic)
-   CEFR-based scoring system
-   Time-based bonus calculation
-   Caffeine Cache với 30-minute TTL

---

## Các Thuật Toán Chính

### 1. **Random Sampling Algorithm** (Stream + filter + shuffle + limit)

**Vị trí sử dụng:**

```java
// ImageWordMatchingService.getRandomVocabsWithImages()
private List<Vocab> getRandomVocabsWithImages(int count, String cefr) {
    List<Vocab> vocabs;

    if (cefr != null && !cefr.isBlank()) {
        vocabs = vocabRepository.findAllByCefr(cefr);
    } else {
        vocabs = vocabRepository.findAll();
    }

    List<Vocab> vocabsWithImages = vocabs.stream()
        .filter(v -> v.getImg() != null && !v.getImg().isBlank())
        .collect(Collectors.toList());

    Collections.shuffle(vocabsWithImages);

    return vocabsWithImages.stream()
        .limit(count)
        .collect(Collectors.toList());
}
```

**Mục đích:**

-   Chọn ngẫu nhiên N từ vựng từ database
-   Đảm bảo vocab có image (không thể chơi game nếu không có ảnh)
-   Hỗ trợ filter theo CEFR level (optional)

**Thuật toán:**

1. **Query Phase:** Lấy vocabs từ DB (all hoặc filtered by CEFR)
2. **Filter Phase:** Chỉ giữ vocab có image không rỗng
3. **Shuffle Phase:** Trộn ngẫu nhiên (Fisher-Yates shuffle)
4. **Sample Phase:** Lấy N phần tử đầu tiên

**Time Complexity:** O(n log n) do shuffle
**Space Complexity:** O(n)

**Ví dụ:**

```
Input: count=5, cefr="A1"
DB: 100 A1 vocabs (50 có image, 50 không có)

Step 1 (Query): Lấy 100 A1 vocabs
Step 2 (Filter): Còn 50 vocabs có image
Step 3 (Shuffle): Trộn 50 vocabs ngẫu nhiên
Step 4 (Limit): Lấy 5 vocabs đầu tiên

Output: [apple, dog, cat, house, book]
```

---

### 2. **CEFR-Based Scoring Algorithm**

**Vị trí sử dụng:**

```java
// ImageWordMatchingService.getCefrPoints()
private int getCefrPoints(String cefr) {
    return switch (cefr.toUpperCase()) {
        case "A1" -> 1;
        case "A2" -> 2;
        case "B1" -> 3;
        case "B2" -> 4;
        case "C1" -> 5;
        case "C2" -> 6;
        default -> 1;
    };
}
```

**Mục đích:**

-   Tính điểm dựa trên độ khó của từ vựng
-   Từ khó hơn (C2) = điểm cao hơn (6 points)
-   Từ dễ hơn (A1) = điểm thấp hơn (1 point)

**Thuật toán:**

-   Simple lookup table (switch statement)
-   Constant time: O(1)
-   Không có logic phức tạp

**Mapping:**

```
CEFR Level → Points
A1 → 1 point
A2 → 2 points
B1 → 3 points
B2 → 4 points
C1 → 5 points
C2 → 6 points
```

---

### 3. **Time Bonus Calculation Algorithm**

**Vị trí sử dụng:**

```java
// ImageWordMatchingService.submitAnswer()
long seconds = timeTaken / 1000;
double bonusPercentage = 0;

if (seconds < 10) {
    bonusPercentage = 0.50;  // +50%
} else if (seconds < 20) {
    bonusPercentage = 0.30;  // +30%
} else if (seconds < 30) {
    bonusPercentage = 0.20;  // +20%
} else if (seconds < 60) {
    bonusPercentage = 0.10;  // +10%
}

int timeBonus = (int) Math.round(cefrScore * bonusPercentage);
int totalScore = cefrScore + timeBonus;

    // Perfect match bonus
    if (correctMatches == totalPairs) {
        baseScore += 15;
    }

    return baseScore;
}
```

**Công thức tính điểm:**

```
Score = Base Score + Time Bonus + Perfect Bonus

Base Score = correctMatches × 10

Time Bonus (chỉ SPEED_MATCH):
  - < 30s: +20 điểm
  - 30-45s: +10 điểm
  - > 45s: 0 điểm

Perfect Bonus:
  - 100% correct: +15 điểm
```

**Ví dụ:**

```
Mode: SPEED_MATCH
Correct: 5/5 pairs
Time: 25 seconds

Calculation:
Base: 5 × 10 = 50
Time bonus: 20 (< 30s)
Perfect bonus: 15 (5/5 correct)
Total: 50 + 20 + 15 = 85 điểm
```

---

### 4. **Accuracy Calculation Algorithm** (Thuật toán tính toán độ chính xác)

**Vị trí sử dụng:**

```java
// Line 161: Calculate accuracy
double accuracy = sessionData.getVocabs().size() > 0
    ? (correctMatches * 100.0 / sessionData.getVocabs().size())
    : 0;
```

**Công thức:**

```
Accuracy = (Correct Matches / Total Pairs) × 100%
```

**Đặc điểm:**

-   Phần trăm chính xác
-   Dùng để quyết định có thể lên level không (Progressive mode)
-   Yêu cầu ≥ 80% để progress

---

### 5. **Leaderboard Ranking Algorithm** (Group-by + Sort)

**Vị trí sử dụng:**

```java
// Line 597-641: Get leaderboard
public List<LeaderboardEntryResponse> getLeaderboard(String gameMode, int limit) {
    // 1. Lấy sessions
    Page<GameSession> sessionsPage = gameSessionRepository.findGlobalLeaderboard(pageable);

    // 2. Group by user
    Map<UUID, UserLeaderboardData> userStatsMap = new HashMap<>();
    for (GameSession session : sessions) {
        UUID userId = session.getUser().getId();
        UserLeaderboardData data = userStatsMap.computeIfAbsent(userId,
            k -> new UserLeaderboardData(session.getUser()));
        data.addSession(session);
    }

    // 3. Sort by total score
    List<LeaderboardEntryResponse> leaderboard = userStatsMap.values().stream()
        .sorted((a, b) -> Integer.compare(b.getTotalScore(), a.getTotalScore()))
        .limit(limit)
        .collect(Collectors.toList());

    // 4. Assign ranks
    for (int i = 0; i < leaderboard.size(); i++) {
        leaderboard.get(i).setRank(i + 1);
    }
}
```

**Các bước:**

1. **Aggregation Phase:**

    - Group sessions by user
    - Tính tổng score của mỗi user

2. **Sorting Phase:**

    - Sort descending by total score
    - Time Complexity: O(n log n)

3. **Ranking Phase:**
    - Gán rank từ 1 đến N
    - Linear: O(n)

**Total Complexity:** O(n log n)

---

### 6. **Progressive Difficulty Algorithm**

**Vị trí sử dụng:**

```java
// Line 216-268: Progress to next level
public ImageWordMatchingSessionResponse progressToNextLevel(Long sessionId) {
    // Increase level and pairs
    int nextLevel = sessionData.getCurrentLevel() + 1;
    int newPairs = PROGRESSIVE_START_PAIRS + (nextLevel - 1);

    // Get new vocabs with increased difficulty
    List<Vocab> vocabs = getRandomVocabsWithImages(newPairs, null, null);
}
```

**Công thức tăng độ khó:**

```
Level 1: 3 pairs  (PROGRESSIVE_START_PAIRS = 3)
Level 2: 4 pairs  (3 + 1)
Level 3: 5 pairs  (3 + 2)
Level 4: 6 pairs  (3 + 3)
...
Level N: (3 + N - 1) pairs
```

**Điều kiện lên level:**

```java
boolean canProgress = sessionData.getGameMode() == GameMode.PROGRESSIVE
    && accuracy >= 80.0;
```

**Thuật toán:**

-   Linear progression: +1 pair mỗi level
-   Yêu cầu accuracy ≥ 80% để tiếp tục
-   Tạo cảm giác thành tựu khi lên level

---

### 7. **Card Generation Algorithm** (Thuật toán tạo thẻ)

**Vị trí sử dụng:**

```java
// Line 364-386: Create shuffled cards
private List<ImageWordMatchingSessionResponse.CardItem> createShuffledCards(List<Vocab> vocabs) {
    List<ImageWordMatchingSessionResponse.CardItem> cards = new ArrayList<>();

    // Create image cards
    for (Vocab vocab : vocabs) {
        cards.add(CardItem.builder()
            .id(UUID.randomUUID().toString())
            .type("IMAGE")
            .content(vocab.getImg())
            .vocabId(vocab.getId().toString())
            .build());
    }

    // Create word cards
    for (Vocab vocab : vocabs) {
        cards.add(CardItem.builder()
            .id(UUID.randomUUID().toString())
            .type("WORD")
            .content(vocab.getWord())
            .vocabId(vocab.getId().toString())
            .build());
    }

    // Shuffle all cards
    Collections.shuffle(cards);
    return cards;
}
```

**Quy trình:**

1. **Generation Phase:**

    ```
    Input: N vocabs
    Output: 2N cards (N images + N words)
    ```

2. **Card Structure:**

    ```
    {
      id: UUID (unique for each card),
      type: "IMAGE" or "WORD",
      content: image URL or word text,
      vocabId: reference to original vocab
    }
    ```

3. **Shuffle Phase:**
    - Trộn tất cả 2N cards
    - Đảm bảo ngẫu nhiên vị trí

**Time Complexity:** O(n)

---

### 8. **Match Validation Algorithm** (Thuật toán xác thực khớp)

**Vị trí sử dụng:**

```java
// Line 126-166: Validate answers
for (ImageWordMatchingAnswerRequest.MatchPair match : request.getMatches()) {
    Vocab vocab = sessionData.getVocabs().stream()
        .filter(v -> v.getId().toString().equals(match.getVocabId()))
        .findFirst()
        .orElse(null);

    if (vocab == null) continue;

    boolean isCorrect = vocab.getWord().equalsIgnoreCase(match.getMatchedWord().trim());

    if (isCorrect) {
        correctMatches++;
    } else {
        incorrectMatches++;
    }

    results.add(MatchResult.builder()
        .vocabId(vocab.getId().toString())
        .word(vocab.getWord())
        .image(vocab.getImg())
        .userAnswer(match.getMatchedWord())
        .correct(isCorrect)
        .build());
}
```

**Logic:**

1. **Lookup Phase:**

    - Tìm vocab theo vocabId
    - Stream filter: O(n) per match

2. **Comparison Phase:**

    - Case-insensitive comparison
    - Trim whitespace

    ```java
    vocab.getWord().equalsIgnoreCase(match.getMatchedWord().trim())
    ```

3. **Result Aggregation:**
    - Count correct/incorrect
    - Build detailed result list

**Total Complexity:** O(n × m)

-   n = số vocabs trong session
-   m = số matches từ user

---

### 9. **Session Caching Strategy** (In-Memory Cache)

**Vị trí sử dụng:**

```java
// Line 47: Session cache declaration
private final Map<Long, SessionData> sessionCache = new ConcurrentHashMap<>();

// Line 103: Store in cache
SessionData sessionData = new SessionData(session.getId(), gameMode, vocabs, 1);
sessionCache.put(session.getId(), sessionData);

// Line 119: Retrieve from cache
SessionData sessionData = sessionCache.get(request.getSessionId());
```

**Cấu trúc:**

```java
@AllArgsConstructor
private static class SessionData {
    private final Long sessionId;
    private final GameMode gameMode;
    private final List<Vocab> vocabs;
    private final int currentLevel;
}
```

**Mục đích:**

-   **Performance:** Tránh query database mỗi lần validate
-   **State Management:** Lưu trạng thái game session
-   **Fast Lookup:** O(1) access time

**Lifecycle:**

```
1. Session Start → Add to cache
2. Playing → Read from cache (validation, scoring)
3. Session End → Remove from cache
4. Progress (Progressive mode) → Update cache
```

**Trade-offs:**

-   ✅ **Pros:** Very fast, reduced DB load
-   ❌ **Cons:** Lost on server restart, memory usage

---

### 10. **User Progress Tracking Algorithm** (Thuật toán theo dõi tiến trình của người dùng)

**Vị trí sử dụng:**

```java
// Line 412-432: Update user vocab progress
private void updateUserVocabProgress(User user, Vocab vocab, boolean isCorrect) {
    Optional<UserVocabProgress> progressOpt = userVocabProgressRepository
        .findByUserIdAndVocabId(user.getId(), vocab.getId());

    UserVocabProgress progress;
    if (progressOpt.isPresent()) {
        progress = progressOpt.get();
        if (isCorrect) {
            progress.setTimesCorrect(progress.getTimesCorrect() + 1);
        } else {
            progress.setTimesWrong(progress.getTimesWrong() + 1);
        }
    } else {
        progress = UserVocabProgress.builder()
            .user(user)
            .vocab(vocab)
            .timesCorrect(isCorrect ? 1 : 0)
            .timesWrong(isCorrect ? 0 : 1)
            .build();
    }

    userVocabProgressRepository.save(progress);
}
```

**Thuật toán:**

1. **Lookup or Create:**

    ```
    IF progress exists:
        UPDATE counters
    ELSE:
        CREATE new progress record
    ```

2. **Counter Increment:**

    ```
    IF correct:
        timesCorrect++
    ELSE:
        timesWrong++
    ```

3. **Persistence:**
    - Save to database
    - Dùng cho spaced repetition sau này

**Use Cases:**

-   Track learning progress
-   Identify weak vocabs
-   Personalized review (future feature)

---

## Design Patterns Được Sử Dụng

### 1. **Strategy Pattern** (Game Modes)

```java
private int determineTotalPairs(GameMode mode, Integer requestedPairs) {
    return switch (mode) {
        case CLASSIC -> CLASSIC_DEFAULT_PAIRS;      // 8 pairs
        case SPEED_MATCH -> SPEED_MATCH_DEFAULT_PAIRS; // 5 pairs
        case PROGRESSIVE -> PROGRESSIVE_START_PAIRS;   // 3 pairs
    };
}
```

**Benefit:** Dễ dàng thêm game mode mới

---

### 2. **Builder Pattern** (Response DTOs)

```java
return ImageWordMatchingSessionResponse.builder()
    .sessionId(session.getId())
    .gameMode(gameMode.name())
    .currentLevel(1)
    .totalPairs(totalPairs)
    .cards(cards)
    .build();
```

**Benefit:** Clean code, immutable objects

---

### 3. **Repository Pattern** (Data Access)

```java
private final GameRepository gameRepository;
private final GameSessionRepository gameSessionRepository;
private final VocabRepository vocabRepository;
```

**Benefit:** Separation of concerns, testable

---

### 4. **Cache-Aside Pattern** (Session Cache)

```
Client → Check cache
  ↓ miss
  ↓
Database → Load data → Update cache → Return
```

**Benefit:** Reduced DB load, faster response

---

## Độ Phức Tạp Thuật Toán

| Operation        | Time Complexity | Space Complexity |
| ---------------- | --------------- | ---------------- |
| Start Game       | O(n log n)      | O(n)             |
| Shuffle Cards    | O(n)            | O(1)             |
| Validate Answers | O(n × m)        | O(n)             |
| Calculate Score  | O(1)            | O(1)             |
| Leaderboard      | O(n log n)      | O(n)             |
| Progress Level   | O(n log n)      | O(n)             |

**Giải thích:**

-   n = số vocabs
-   m = số matches cần validate

---

## Optimizations Có Thể Cải Thiện

### 1. **Validation Algorithm**

**Current:** O(n × m) - stream filter for each match

```java
Vocab vocab = sessionData.getVocabs().stream()
    .filter(v -> v.getId().toString().equals(match.getVocabId()))
    .findFirst()
    .orElse(null);
```

**Optimized:** O(m) - pre-build HashMap

```java
// In SessionData constructor:
Map<String, Vocab> vocabMap = vocabs.stream()
    .collect(Collectors.toMap(
        v -> v.getId().toString(),
        v -> v
    ));

// In validation:
Vocab vocab = vocabMap.get(match.getVocabId()); // O(1)
```

**Improvement:** n times faster!

---

### 2. **Leaderboard Caching**

**Current:** Query + aggregate every time

**Optimized:** Cache leaderboard, invalidate on game completion

```java
@Cacheable(value = "leaderboard", key = "#gameMode + '_' + #limit")
public List<LeaderboardEntryResponse> getLeaderboard(String gameMode, int limit) {
    // ...
}

@CacheEvict(value = "leaderboard", allEntries = true)
public void onGameCompleted(GameSession session) {
    // Clear cache when new high score
}
```

---

### 3. **Database Query Optimization**

**Current:** Multiple queries for session details

**Optimized:** Use JOIN FETCH

```java
@Query("SELECT s FROM GameSession s " +
       "LEFT JOIN FETCH s.details " +
       "WHERE s.user.id = :userId")
List<GameSession> findByUserIdWithDetails(@Param("userId") UUID userId);
```

---

## So Sánh Với Các Game Khác

| Feature     | Your Game     | Memory Game  | Quiz Game     |
| ----------- | ------------- | ------------ | ------------- |
| Shuffle     | Fisher-Yates  | Fisher-Yates | Random        |
| Scoring     | Weighted      | Simple       | Time-based    |
| Difficulty  | Progressive   | Fixed        | Adaptive      |
| Caching     | Session-based | None         | Question pool |
| Leaderboard | Aggregate     | Simple       | Realtime      |

---

## Kết Luận

Game **Image-Word Matching** của bạn sử dụng:

### Thuật toán chính:

1. ✅ **Fisher-Yates Shuffle** - Trộn cards
2. ✅ **Random Sampling** - Chọn vocabs
3. ✅ **Weighted Scoring** - Tính điểm thông minh
4. ✅ **Progressive Difficulty** - Tăng độ khó tự động
5. ✅ **Group-by + Sort** - Leaderboard ranking
6. ✅ **Cache-Aside** - Session management

### Điểm mạnh:

-   ⚡ Performance tốt với caching
-   🎯 Logic chấm điểm công bằng
-   📈 Progressive mode thú vị
-   🏆 Leaderboard động

### Có thể cải thiện:

-   Optimize validation từ O(n×m) → O(m)
-   Cache leaderboard
-   Use database JOIN FETCH
-   Add Redis cho distributed caching

**Overall Rating:** 8/10 - Thuật toán tốt, có thể optimize thêm! 🚀
