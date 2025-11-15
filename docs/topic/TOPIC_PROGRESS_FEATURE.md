# Tính Năng Hiển Thị Tiến Độ Học Từ Vựng Theo Topic

## Tổng Quan

Feature này thêm khả năng hiển thị % tiến độ học từ vựng của user trong từng topic tại 2 API:

-   `GET /api/v1/topics` - Lấy danh sách tất cả topics
-   `GET /api/v1/topics/{id}` - Lấy thông tin một topic

## Công Thức Tính Toán

```
Progress (%) = (Số từ đã học / Tổng số từ trong topic) × 100
```

**Từ đã học**: Là từ vựng có trong bảng `user_vocab_progress` của user đó (bất kể status là gì)

## Kiến Trúc & Components

### 1. TopicProgressCalculator (Core Service)

**File**: `src/main/java/com/thuanthichlaptrinh/card_words/core/service/TopicProgressCalculator.java`

Component có thể tái sử dụng để tính toán tiến độ học từ vựng theo topic.

**Methods:**

```java
// Tính % tiến độ
Double calculateTopicProgress(UUID userId, Long topicId)

// Kiểm tra topic đã hoàn thành chưa
boolean isTopicCompleted(UUID userId, Long topicId)

// Lấy số lượng [learnedCount, totalCount]
long[] getTopicProgressCounts(UUID userId, Long topicId)
```

**Đặc điểm:**

-   ✅ Có thể tái sử dụng ở nhiều nơi khác nhau
-   ✅ Xử lý edge case: topic không có từ vựng → return 0.0
-   ✅ Làm tròn đến 2 chữ số thập phân
-   ✅ Có logging để debug

### 2. Repository Queries

#### UserVocabProgressRepository

Thêm query mới:

```java
@Query("SELECT COUNT(uvp) FROM UserVocabProgress uvp " +
       "JOIN uvp.vocab v " +
       "WHERE uvp.user.id = :userId " +
       "AND v.topic.id = :topicId")
long countLearnedVocabsByUserAndTopic(@Param("userId") UUID userId,
                                      @Param("topicId") Long topicId);
```

**Mục đích**: Đếm số từ vựng mà user đã học trong một topic cụ thể.

#### VocabRepository

Thêm query mới:

```java
@Query("SELECT COUNT(v) FROM Vocab v WHERE v.topic.id = :topicId")
long countByTopicId(@Param("topicId") Long topicId);
```

**Mục đích**: Đếm tổng số từ vựng trong một topic.

### 3. TopicResponse DTO

**File**: `src/main/java/com/thuanthichlaptrinh/card_words/entrypoint/dto/response/TopicResponse.java`

Thêm field mới:

```java
/**
 * Tiến độ học từ vựng của user trong topic này (%)
 * Giá trị từ 0.0 đến 100.0
 * Null nếu không có thông tin user hoặc user chưa đăng nhập
 */
private Double progress;
```

### 4. TopicService

**File**: `src/main/java/com/thuanthichlaptrinh/card_words/core/usecase/user/TopicService.java`

**Thay đổi:**

1. Inject `TopicProgressCalculator`
2. Cập nhật signatures của methods:
    - `getAllTopics(UUID userId)`
    - `getTopicById(Long id, UUID userId)`
3. Thêm helper method tái sử dụng:

```java
private TopicResponse buildTopicResponse(Topic topic, UUID userId) {
    Double progress = null;

    // Chỉ tính progress nếu user đã đăng nhập
    if (userId != null) {
        progress = topicProgressCalculator.calculateTopicProgress(userId, topic.getId());
    }

    return TopicResponse.builder()
            .id(topic.getId())
            .name(topic.getName())
            .description(topic.getDescription())
            .img(topic.getImg())
            .progress(progress)
            .build();
}
```

### 5. TopicController

**File**: `src/main/java/com/thuanthichlaptrinh/card_words/entrypoint/rest/v1/user/TopicController.java`

**Thay đổi:**

1. Thêm parameter `Authentication authentication` vào cả 2 endpoints
2. Extract userId từ Authentication
3. Thêm helper method:

```java
private UUID getUserIdFromAuth(Authentication authentication) {
    if (authentication == null || !authentication.isAuthenticated()) {
        return null;
    }

    try {
        return UUID.fromString(authentication.getName());
    } catch (Exception e) {
        return null;
    }
}
```

4. Cập nhật Swagger documentation với `@SecurityRequirement`

## API Response Examples

### GET /api/v1/topics (User đã đăng nhập)

```json
{
    "success": true,
    "message": "Lấy danh sách chủ đề thành công",
    "data": [
        {
            "id": 1,
            "name": "Animals",
            "description": "Từ vựng về động vật",
            "img": null,
            "progress": 45.67
        },
        {
            "id": 2,
            "name": "Food",
            "description": "Từ vựng về đồ ăn",
            "img": null,
            "progress": 100.0
        },
        {
            "id": 3,
            "name": "Travel",
            "description": "Từ vựng về du lịch",
            "img": null,
            "progress": 0.0
        }
    ]
}
```

### GET /api/v1/topics (User chưa đăng nhập)

```json
{
    "success": true,
    "message": "Lấy danh sách chủ đề thành công",
    "data": [
        {
            "id": 1,
            "name": "Animals",
            "description": "Từ vựng về động vật",
            "img": null,
            "progress": null
        }
    ]
}
```

## Ưu Điểm Của Thiết Kế

### 1. Tái Sử Dụng (Reusability)

✅ `TopicProgressCalculator` là một component độc lập có thể được sử dụng ở:

-   Topic APIs (hiện tại)
-   Dashboard/Statistics APIs
-   User profile APIs
-   Admin reports
-   Gamification features

### 2. Separation of Concerns

✅ **Controller**: Xử lý HTTP request, extract user info
✅ **Service**: Business logic, orchestration
✅ **Calculator**: Pure calculation logic
✅ **Repository**: Data access

### 3. Null Safety

✅ Xử lý trường hợp user chưa đăng nhập → progress = null
✅ Xử lý trường hợp topic không có từ vựng → progress = 0.0

### 4. Performance

✅ Sử dụng COUNT queries - efficient
✅ Không load toàn bộ entities vào memory
✅ Có thể thêm caching sau này nếu cần

## Testing Scenarios

### Test Cases

1. **User đã đăng nhập, có tiến độ học**

    - Expected: progress = % chính xác

2. **User đã đăng nhập, chưa học từ nào**

    - Expected: progress = 0.0

3. **User đã đăng nhập, đã học hết**

    - Expected: progress = 100.0

4. **User chưa đăng nhập**

    - Expected: progress = null

5. **Topic không có từ vựng**
    - Expected: progress = 0.0

### Example Test Data

```sql
-- Topic có 10 từ vựng
-- User đã học 3 từ
-- Expected progress: 30.0%

SELECT COUNT(*) FROM vocab WHERE topic_id = 1;  -- 10
SELECT COUNT(*) FROM user_vocab_progress WHERE user_id = 'xxx' AND vocab_id IN
    (SELECT id FROM vocab WHERE topic_id = 1);  -- 3
```

## Migration Path

Nếu có data cũ cần migrate, không cần thay đổi gì vì:

-   Progress được tính real-time từ database
-   Không lưu progress vào database
-   API tương thích ngược (progress = null khi chưa login)

## Future Enhancements

1. **Caching**: Cache progress values với Redis

    ```java
    @Cacheable(value = "topicProgress", key = "#userId + ':' + #topicId")
    public Double calculateTopicProgress(UUID userId, Long topicId)
    ```

2. **Batch calculation**: Tính progress cho nhiều topics cùng lúc

    ```java
    Map<Long, Double> calculateBatchProgress(UUID userId, List<Long> topicIds)
    ```

3. **Progress history**: Track progress theo thời gian
4. **Progress goals**: Set mục tiêu % hoàn thành
5. **Badges/Achievements**: Award khi đạt milestone

## Performance Considerations

### Current Implementation

-   **Time Complexity**: O(1) per topic - 2 COUNT queries
-   **Space Complexity**: O(1) - không load entities

### Optimization Options

1. **Use native queries** nếu cần faster
2. **Add database indexes**:
    ```sql
    CREATE INDEX idx_vocab_topic_id ON vocab(topic_id);
    CREATE INDEX idx_uvp_user_vocab ON user_vocab_progress(user_id, vocab_id);
    ```
3. **Redis caching** for frequently accessed data

## Conclusion

Implementation này:

-   ✅ Đáp ứng yêu cầu hiển thị tiến độ
-   ✅ Sử dụng thuật toán và hàm có thể tái sử dụng
-   ✅ Clean code, dễ maintain
-   ✅ Extensible cho future features
-   ✅ Performance tốt với COUNT queries
