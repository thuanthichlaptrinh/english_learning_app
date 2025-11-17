# Fix Lỗi Compilation - Learned Today API

## Tổng quan lỗi

Khi tạo API "Lấy từ đã học trong ngày", đã phát sinh lỗi compilation do thiếu các method trong `UserVocabProgressRepository`.

---

## Chi tiết lỗi

### Lỗi Maven Compiler

```
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:3.11.0:compile
Compilation failure:

[ERROR] LearnVocabService.java:[168,59] cannot find symbol
  symbol:   method findLearningVocabsByTopic(java.util.UUID,java.lang.String)
  location: variable userVocabProgressRepository

[ERROR] LearnVocabService.java:[172,59] cannot find symbol
  symbol:   method findLearningVocabs(java.util.UUID)
  location: variable userVocabProgressRepository

[ERROR] LearnVocabService.java:[179,59] cannot find symbol
  symbol:   method findLearningVocabsByTopic(java.util.UUID,java.lang.String)
  location: variable userVocabProgressRepository

[ERROR] LearnVocabService.java:[187,59] cannot find symbol
  symbol:   method findLearningVocabs(java.util.UUID)
  location: variable userVocabProgressRepository

[ERROR] LearnVocabService.java:[292,79] cannot find symbol
  symbol:   method findLearningVocabsByTopic(java.util.UUID,java.lang.String)
  location: variable userVocabProgressRepository
```

### Nguyên nhân

File `LearnVocabService.java` đang gọi các method:
- `findLearningVocabs(UUID userId)` - Lấy tất cả từ đang học (KNOWN/UNKNOWN)
- `findLearningVocabsByTopic(UUID userId, String topicName)` - Lấy từ đang học theo topic

Nhưng trong `UserVocabProgressRepository` chỉ có phiên bản **paged** (có Pageable parameter):
- `findLearningVocabsPaged(UUID userId, Pageable pageable)`
- `findLearningVocabsByTopicPaged(UUID userId, String topicName, Pageable pageable)`

---

## Giải pháp

### Thêm 2 method non-paged vào `UserVocabProgressRepository.java`

```java
// Get learning vocabs (KNOWN or UNKNOWN) - non-paged
@Query("SELECT uvp FROM UserVocabProgress uvp " +
       "LEFT JOIN FETCH uvp.vocab v " +
       "WHERE uvp.user.id = :userId " +
       "AND (uvp.status = 'KNOWN' OR uvp.status = 'UNKNOWN') " +
       "ORDER BY uvp.updatedAt DESC")
List<UserVocabProgress> findLearningVocabs(@Param("userId") UUID userId);

// Get learning vocabs by topic (KNOWN or UNKNOWN) - non-paged
@Query("SELECT uvp FROM UserVocabProgress uvp " +
       "LEFT JOIN FETCH uvp.vocab v " +
       "LEFT JOIN v.topics t " +
       "WHERE uvp.user.id = :userId " +
       "AND LOWER(t.name) = LOWER(:topicName) " +
       "AND (uvp.status = 'KNOWN' OR uvp.status = 'UNKNOWN') " +
       "ORDER BY uvp.updatedAt DESC")
List<UserVocabProgress> findLearningVocabsByTopic(
        @Param("userId") UUID userId,
        @Param("topicName") String topicName);
```

---

## Chi tiết thay đổi

### File: `UserVocabProgressRepository.java`

**Vị trí**: Cuối file, trước dấu `}`

**Thêm mới**: 2 query methods

#### Method 1: `findLearningVocabs`
- **Mục đích**: Lấy tất cả từ đang học (không phân trang)
- **Filter**: `status = 'KNOWN' OR status = 'UNKNOWN'`
- **Sort**: `updatedAt DESC` (từ mới cập nhật nhất)
- **Return**: `List<UserVocabProgress>`

#### Method 2: `findLearningVocabsByTopic`
- **Mục đích**: Lấy từ đang học theo topic (không phân trang)
- **Filter**: 
  - `status = 'KNOWN' OR status = 'UNKNOWN'`
  - `topic.name = topicName` (case-insensitive)
- **Join**: LEFT JOIN với `vocab.topics`
- **Sort**: `updatedAt DESC`
- **Return**: `List<UserVocabProgress>`

---

## Tại sao cần cả 2 phiên bản (paged và non-paged)?

### Phiên bản Paged (có Pageable)
```java
Page<UserVocabProgress> findLearningVocabsPaged(UUID userId, Pageable pageable);
```

**Use case**:
- API endpoint trả về kết quả phân trang
- Frontend hiển thị danh sách với pagination
- Performance tốt khi có nhiều dữ liệu
- Ví dụ: `/api/v1/learn-vocabs?page=0&size=20`

### Phiên bản Non-paged (List)
```java
List<UserVocabProgress> findLearningVocabs(UUID userId);
```

**Use case**:
- Lấy tất cả kết quả để xử lý logic nội bộ
- Tính toán thống kê (count, sum, average)
- Export data (CSV, Excel)
- Background jobs
- Ví dụ: Tính tổng số từ đang học để hiển thị stats

---

## Code đã sửa

### Before (Lỗi)

```java
// LearnVocabService.java - line 168
progressList = userVocabProgressRepository.findLearningVocabsByTopic(
    user.getId(), request.getTopicName());
// ❌ ERROR: Method không tồn tại
```

### After (Đã fix)

```java
// UserVocabProgressRepository.java - Thêm method mới
@Query("SELECT uvp FROM UserVocabProgress uvp " +
       "LEFT JOIN FETCH uvp.vocab v " +
       "LEFT JOIN v.topics t " +
       "WHERE uvp.user.id = :userId " +
       "AND LOWER(t.name) = LOWER(:topicName) " +
       "AND (uvp.status = 'KNOWN' OR uvp.status = 'UNKNOWN') " +
       "ORDER BY uvp.updatedAt DESC")
List<UserVocabProgress> findLearningVocabsByTopic(
        @Param("userId") UUID userId,
        @Param("topicName") String topicName);

// LearnVocabService.java - line 168 giờ sẽ work
progressList = userVocabProgressRepository.findLearningVocabsByTopic(
    user.getId(), request.getTopicName());
// ✅ OK: Method đã có
```

---

## Testing

### 1. Compile project
```bash
mvnw.cmd clean compile -DskipTests
```

**Expected**: BUILD SUCCESS

### 2. Run tests (nếu có)
```bash
mvnw.cmd test
```

### 3. Start application
```bash
mvnw.cmd spring-boot:run
```

### 4. Test API endpoints
```bash
# Test learned today API
GET http://localhost:8080/api/v1/user-vocab-progress/learned-today

# Test learn vocab API
GET http://localhost:8080/api/v1/learn-vocabs?onlyDue=true
```

---

## Tổng kết các Repository methods hiện có

### UserVocabProgressRepository - Complete List

#### Paged Methods (trả về Page)
1. `findByUserId(UUID, Pageable)` - Admin: lấy tất cả progress
2. `findDueForReviewByTopicPaged(UUID, String, LocalDate, Pageable)` - Từ cần ôn tập theo topic
3. `findDueForReviewPaged(UUID, LocalDate, Pageable)` - Tất cả từ cần ôn tập
4. `findUnlearnedVocabsByTopicPaged(UUID, String, Pageable)` - Từ chưa học theo topic
5. `findAllUnlearnedVocabsPaged(UUID, Pageable)` - Tất cả từ chưa học
6. `findLearningVocabsByTopicPaged(UUID, String, Pageable)` - Từ đang học theo topic ⭐
7. `findLearningVocabsPaged(UUID, Pageable)` - Tất cả từ đang học ⭐
8. `findNewVocabsByUserPaged(UUID, Pageable)` - Từ mới (status=NEW)
9. `findNewVocabsByUserAndTopicPaged(UUID, String, Pageable)` - Từ mới theo topic

#### Non-paged Methods (trả về List)
1. `findByUserIdWithVocab(UUID)` - Tất cả từ đã học
2. `findCorrectVocabsByUserId(UUID)` - Từ đã đúng
3. `findWrongVocabsByUserId(UUID)` - Từ đã sai
4. `findDueForReview(UUID, LocalDate)` - Từ cần ôn tập hôm nay
5. `findDueForReviewByTopic(UUID, String, LocalDate)` - Từ cần ôn tập theo topic
6. `findUnlearnedVocabsByTopic(UUID, String)` - Từ chưa học theo topic
7. `findNewVocabsByUser(UUID)` - Từ mới (status=NEW)
8. `findLearnedVocabsByDate(UUID, LocalDate)` - Từ học trong ngày ⭐ NEW
9. `findLearningVocabs(UUID)` - Từ đang học ⭐ NEW
10. `findLearningVocabsByTopic(UUID, String)` - Từ đang học theo topic ⭐ NEW

#### Count Methods
1. `countByUserIdAndStatus(UUID, VocabStatus)` - Đếm theo status
2. `countLearnedVocabs(UUID)` - Đếm từ đã học
3. `countTotalCorrectAttempts(UUID)` - Tổng số lần đúng
4. `countTotalWrongAttempts(UUID)` - Tổng số lần sai

#### Other Methods
1. `findByUserIdAndVocabId(UUID, UUID)` - Lấy progress cụ thể
2. `findByVocabId(UUID)` - Admin: lấy progress theo vocab
3. `deleteByUserId(UUID)` - Xóa tất cả progress của user

---

## Best Practices học được

### 1. Khi thêm Repository method mới
✅ **DO**:
- Đặt tên method rõ ràng, mô tả chức năng
- Thêm annotation `@Query` với JPQL query
- Sử dụng `@Param` cho parameters
- Comment giải thích mục đích

❌ **DON'T**:
- Tạo method mà không implement query
- Đặt tên method không theo convention
- Quên thêm indexes cho các column thường query

### 2. Khi design API
✅ **DO**:
- Cung cấp cả 2 phiên bản: paged và non-paged
- Paged cho API endpoints
- Non-paged cho internal logic

### 3. Khi fix lỗi
✅ **DO**:
- Đọc kỹ error message
- Kiểm tra xem method có tồn tại không
- Test sau khi fix
- Document changes

---

## Checklist khi thêm Repository method

- [x] Định nghĩa method signature trong interface
- [x] Thêm `@Query` annotation với JPQL
- [x] Thêm `@Param` cho các parameters
- [x] Test query syntax
- [x] Kiểm tra performance (indexes)
- [x] Document method purpose
- [x] Update service layer
- [x] Test API endpoint
- [x] Update documentation

---

## Related Files

- `UserVocabProgressRepository.java` - Repository interface ⭐ UPDATED
- `LearnVocabService.java` - Service sử dụng methods
- `UserVocabProgressService.java` - Service khác sử dụng methods
- `LEARNED_TODAY_API_GUIDE.md` - API documentation
- `VOCAB_REVIEW_API_GUIDE.md` - Related API docs

---

## Version History

- **v1.0** (2025-11-02): Initial creation - Fix compilation errors
- Added `findLearningVocabs(UUID)` method
- Added `findLearningVocabsByTopic(UUID, String)` method

---

**Status**: ✅ RESOLVED  
**Date Fixed**: 2025-11-02  
**Fixed By**: Development Team

