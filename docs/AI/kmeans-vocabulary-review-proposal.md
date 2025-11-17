# Đề xuất: API Ôn tập Từ vựng Thông minh sử dụng K-means Clustering

## 1. Tổng quan

### 1.1. Mục tiêu
Xây dựng API ôn tập từ vựng thông minh sử dụng thuật toán K-means clustering để nhóm các từ vựng cần ôn tập dựa trên:
- Mức độ thành thạo của người dùng
- Thời gian ôn tập
- Tỷ lệ đúng/sai
- Độ khó của từ (CEFR level)

### 1.2. Phạm vi
- Chỉ áp dụng cho từ vựng có status: `NEW`, `UNKNOWN`, `KNOWN` (không bao gồm `MASTERED`)
- Tạo các nhóm từ vựng để ưu tiên ôn tập hiệu quả
- Cá nhân hóa trải nghiệm học tập cho từng người dùng

## 2. Phân tích Dữ liệu Hiện tại

### 2.1. Entity: UserVocabProgress
```java
- status: VocabStatus (NEW, UNKNOWN, KNOWN, MASTERED)
- lastReviewed: LocalDate
- timesCorrect: Integer
- timesWrong: Integer
- efFactor: Double (Easiness Factor - SM-2 algorithm)
- intervalDays: Integer
- repetition: Integer
- nextReviewDate: LocalDate
```

### 2.2. Entity: Vocab
```java
- cefr: String (A1, A2, B1, B2, C1, C2)
- word: String
- meaningVi: String
- topic: Topic
```

## 3. Thiết kế Thuật toán K-means

### 3.1. Feature Engineering

Để áp dụng K-means, cần chuyển đổi dữ liệu từ vựng thành vector số với các đặc trưng sau:

#### **Feature 1: Mastery Score (Điểm thành thạo)** - Trọng số: 35%
```
masteryScore = (timesCorrect / (timesCorrect + timesWrong)) * 100
- Giá trị: 0-100
- Ý nghĩa: Tỷ lệ trả lời đúng
```

#### **Feature 2: Recency Score (Điểm độ mới)** - Trọng số: 25%
```
daysSinceLastReview = today - lastReviewed
recencyScore = 100 - min(daysSinceLastReview * 5, 100)
- Giá trị: 0-100
- Ý nghĩa: Từ càng lâu không ôn tập, điểm càng thấp
```

#### **Feature 3: Difficulty Score (Điểm độ khó)** - Trọng số: 20%
```
CEFR Level Mapping:
- A1: 20
- A2: 35
- B1: 50
- B2: 65
- C1: 80
- C2: 95
```

#### **Feature 4: Repetition Score (Điểm lặp lại)** - Trọng số: 15%
```
repetitionScore = min(repetition * 10, 100)
- Giá trị: 0-100
- Ý nghĩa: Số lần đã ôn tập thành công
```

#### **Feature 5: Status Priority (Ưu tiên trạng thái)** - Trọng số: 5%
```
Status Mapping:
- UNKNOWN: 100 (ưu tiên cao nhất)
- NEW: 70
- KNOWN: 40
```

### 3.2. Vector Chuẩn hóa

```java
// Normalized Feature Vector (0-1 scale)
double[] features = {
    masteryScore / 100.0,      // 0.0 - 1.0
    recencyScore / 100.0,      // 0.0 - 1.0
    difficultyScore / 100.0,   // 0.0 - 1.0
    repetitionScore / 100.0,   // 0.0 - 1.0
    statusPriority / 100.0     // 0.0 - 1.0
};
```

### 3.3. Số lượng Clusters (K)

Đề xuất **K = 4 clusters**:

1. **Cluster 0: "Cần Ôn Gấp" (Urgent Review)**
   - Từ có mastery thấp, lâu không ôn tập
   - Status: UNKNOWN hoặc NEW
   - Ưu tiên: Cao nhất

2. **Cluster 1: "Cần Củng Cố" (Need Reinforcement)**
   - Từ có mastery trung bình, cần luyện tập thêm
   - Status: KNOWN nhưng timesWrong > timesCorrect
   - Ưu tiên: Cao

3. **Cluster 2: "Ôn Tập Định Kỳ" (Regular Review)**
   - Từ có mastery tốt nhưng cần duy trì
   - Status: KNOWN, timesCorrect > timesWrong
   - Ưu tiên: Trung bình

4. **Cluster 3: "Gần Thành Thạo" (Near Mastery)**
   - Từ có mastery cao, sắp đạt MASTERED
   - Status: KNOWN, timesCorrect >= 8, timesWrong <= 2
   - Ưu tiên: Thấp

## 4. Kiến trúc Hệ thống

### 4.1. Thư viện Java cho K-means

**Đề xuất: Apache Commons Math**

```xml
<!-- pom.xml -->
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-math3</artifactId>
    <version>3.6.1</version>
</dependency>
```

**Lý do chọn:**
- Lightweight, không cần thêm ML framework nặng
- Tích hợp tốt với Spring Boot
- API đơn giản, dễ sử dụng
- Hỗ trợ K-means++ initialization

### 4.2. Cấu trúc Code

```
src/main/java/com/thuanthichlaptrinh/card_words/
├── core/
│   ├── domain/
│   │   └── VocabCluster.java (Entity mới - lưu kết quả clustering)
│   ├── service/
│   │   └── ml/
│   │       ├── KMeansClusteringService.java
│   │       ├── FeatureExtractor.java
│   │       └── ClusterAnalyzer.java
│   └── usecase/
│       └── user/
│           └── SmartReviewService.java (API chính)
├── dataprovider/
│   └── repository/
│       └── VocabClusterRepository.java
└── entrypoint/
    ├── dto/
    │   ├── request/
    │   │   └── SmartReviewRequest.java
    │   └── response/
    │       ├── SmartReviewResponse.java
    │       └── ClusterStatsResponse.java
    └── rest/
        └── SmartReviewController.java
```

## 5. Thiết kế Database

### 5.1. Bảng mới: vocab_clusters

```sql
CREATE TABLE vocab_clusters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    vocab_id UUID NOT NULL REFERENCES vocab(id) ON DELETE CASCADE,
    cluster_id INTEGER NOT NULL,
    cluster_name VARCHAR(50) NOT NULL,
    priority_score DOUBLE PRECISION NOT NULL,
    mastery_score DOUBLE PRECISION,
    recency_score DOUBLE PRECISION,
    difficulty_score DOUBLE PRECISION,
    repetition_score DOUBLE PRECISION,
    status_priority DOUBLE PRECISION,
    last_clustered_at TIMESTAMP NOT NULL DEFAULT NOW(),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    
    CONSTRAINT uk_user_vocab_cluster UNIQUE(user_id, vocab_id)
);

CREATE INDEX idx_vocab_clusters_user_id ON vocab_clusters(user_id);
CREATE INDEX idx_vocab_clusters_cluster_id ON vocab_clusters(cluster_id);
CREATE INDEX idx_vocab_clusters_priority ON vocab_clusters(priority_score DESC);
```

### 5.2. Migration Script

```sql
-- V10__create_vocab_clusters_table.sql
-- (Đặt trong src/main/resources/db/migration/)
```

## 6. Luồng Hoạt động

### 6.1. Clustering Process (Chạy định kỳ hoặc on-demand)

```
1. Lấy tất cả UserVocabProgress của user có status IN (NEW, UNKNOWN, KNOWN)
2. Trích xuất features cho mỗi từ vựng
3. Chuẩn hóa features về scale 0-1
4. Áp dụng K-means clustering (K=4)
5. Gán cluster_id và tính priority_score cho mỗi từ
6. Lưu kết quả vào bảng vocab_clusters
7. Trả về thống kê clusters
```

### 6.2. Review API Flow

```
1. User gọi API: GET /api/v1/review/smart?limit=20
2. Lấy từ vựng từ vocab_clusters, sắp xếp theo:
   - cluster_id ASC (ưu tiên cluster 0 trước)
   - priority_score DESC
3. Trộn ngẫu nhiên trong cùng cluster để tránh nhàm chán
4. Trả về danh sách từ vựng cần ôn tập
5. User ôn tập và submit kết quả
6. Cập nhật UserVocabProgress
7. Trigger re-clustering nếu cần (sau mỗi 10 từ ôn tập)
```

## 7. API Endpoints

### 7.1. Trigger Clustering

```http
POST /api/v1/review/smart/cluster
Authorization: Bearer {token}

Response:
{
  "success": true,
  "message": "Clustering completed successfully",
  "stats": {
    "totalVocabs": 150,
    "clusters": [
      {
        "clusterId": 0,
        "name": "Cần Ôn Gấp",
        "count": 45,
        "avgMastery": 35.5
      },
      {
        "clusterId": 1,
        "name": "Cần Củng Cố",
        "count": 50,
        "avgMastery": 55.2
      },
      {
        "clusterId": 2,
        "name": "Ôn Tập Định Kỳ",
        "count": 35,
        "avgMastery": 72.8
      },
      {
        "clusterId": 3,
        "name": "Gần Thành Thạo",
        "count": 20,
        "avgMastery": 88.5
      }
    ]
  }
}
```

### 7.2. Get Smart Review Vocabs

```http
GET /api/v1/review/smart?limit=20&clusterId=0
Authorization: Bearer {token}

Response:
{
  "vocabs": [
    {
      "vocabId": "uuid",
      "word": "abandon",
      "meaningVi": "từ bỏ",
      "transcription": "/əˈbændən/",
      "cefr": "B2",
      "img": "url",
      "audio": "url",
      "cluster": {
        "id": 0,
        "name": "Cần Ôn Gấp",
        "priorityScore": 92.5
      },
      "progress": {
        "status": "UNKNOWN",
        "timesCorrect": 2,
        "timesWrong": 5,
        "lastReviewed": "2024-11-10",
        "daysSinceReview": 5
      }
    }
  ],
  "meta": {
    "total": 20,
    "clusterId": 0,
    "clusterName": "Cần Ôn Gấp"
  }
}
```

### 7.3. Get Cluster Statistics

```http
GET /api/v1/review/smart/stats
Authorization: Bearer {token}

Response:
{
  "lastClusteredAt": "2024-11-15T10:30:00",
  "totalVocabs": 150,
  "clusters": [...],
  "recommendations": {
    "nextCluster": 0,
    "suggestedReviewCount": 20,
    "estimatedTime": "15 minutes"
  }
}
```

## 8. Tối ưu hóa

### 8.1. Caching Strategy

```java
@Cacheable(value = "vocabClusters", key = "#userId")
public List<VocabCluster> getCachedClusters(UUID userId) {
    // Cache kết quả clustering trong 1 giờ
}

@CacheEvict(value = "vocabClusters", key = "#userId")
public void invalidateClusterCache(UUID userId) {
    // Xóa cache khi có cập nhật
}
```

### 8.2. Background Job

```java
@Scheduled(cron = "0 0 2 * * ?") // Chạy lúc 2h sáng mỗi ngày
public void scheduledClustering() {
    // Tự động clustering cho tất cả users có hoạt động
}
```

### 8.3. Incremental Update

Thay vì clustering lại toàn bộ, chỉ cập nhật:
- Khi user hoàn thành >= 10 từ ôn tập
- Khi có từ mới được thêm vào
- Khi status thay đổi (UNKNOWN → KNOWN)

## 9. Ưu điểm của Giải pháp

### 9.1. Cá nhân hóa
- Mỗi user có cluster riêng dựa trên tiến độ học tập
- Ưu tiên từ vựng phù hợp với năng lực hiện tại

### 9.2. Hiệu quả
- Tập trung vào từ cần ôn tập nhất
- Tránh lãng phí thời gian với từ đã thành thạo

### 9.3. Khoa học
- Dựa trên thuật toán ML đã được chứng minh
- Kết hợp với SM-2 algorithm hiện có

### 9.4. Linh hoạt
- Dễ dàng điều chỉnh số lượng clusters
- Có thể thêm/bớt features

## 10. Nhược điểm và Giải pháp

### 10.1. Cold Start Problem
**Vấn đề:** User mới chưa có đủ dữ liệu để clustering

**Giải pháp:**
- Sử dụng rule-based system cho user mới
- Chuyển sang K-means sau khi có >= 20 từ vựng

### 10.2. Computational Cost
**Vấn đề:** Clustering tốn tài nguyên với nhiều user

**Giải pháp:**
- Chạy background job vào giờ thấp điểm
- Cache kết quả clustering
- Chỉ re-cluster khi cần thiết

### 10.3. Cluster Imbalance
**Vấn đề:** Một cluster có quá nhiều từ, cluster khác quá ít

**Giải pháp:**
- Sử dụng weighted sampling
- Điều chỉnh K (số clusters) động

## 11. Roadmap Triển khai

### Phase 1: MVP (2-3 tuần)
- [ ] Thêm dependency Apache Commons Math
- [ ] Tạo entity VocabCluster và migration
- [ ] Implement FeatureExtractor
- [ ] Implement KMeansClusteringService (basic)
- [ ] Tạo API trigger clustering
- [ ] Tạo API get smart review vocabs
- [ ] Unit tests

### Phase 2: Enhancement (1-2 tuần)
- [ ] Thêm caching với Redis
- [ ] Implement background job
- [ ] Tối ưu hóa query performance
- [ ] Thêm API statistics
- [ ] Integration tests

### Phase 3: Advanced (2-3 tuần)
- [ ] Incremental clustering
- [ ] A/B testing với review thông thường
- [ ] Analytics và metrics
- [ ] Fine-tuning parameters
- [ ] Documentation

## 12. Metrics để Đánh giá

### 12.1. User Engagement
- Số từ ôn tập mỗi ngày
- Thời gian ôn tập trung bình
- Retention rate

### 12.2. Learning Effectiveness
- Tỷ lệ từ chuyển từ UNKNOWN → KNOWN
- Tỷ lệ từ chuyển từ KNOWN → MASTERED
- Thời gian trung bình để thành thạo 1 từ

### 12.3. System Performance
- Thời gian clustering
- Cache hit rate
- API response time

## 13. Tài liệu Tham khảo

1. **K-means Clustering:**
   - https://en.wikipedia.org/wiki/K-means_clustering
   - Apache Commons Math: https://commons.apache.org/proper/commons-math/

2. **Spaced Repetition:**
   - SM-2 Algorithm: https://www.supermemo.com/en/archives1990-2015/english/ol/sm2
   - Anki Algorithm: https://faqs.ankiweb.net/what-spaced-repetition-algorithm.html

3. **Feature Engineering:**
   - https://www.kaggle.com/learn/feature-engineering

## 14. Kết luận

Việc áp dụng K-means clustering vào hệ thống ôn tập từ vựng sẽ:
- Nâng cao trải nghiệm người dùng
- Tăng hiệu quả học tập
- Cá nhân hóa lộ trình học
- Tận dụng dữ liệu đã có trong hệ thống

Giải pháp này phù hợp với kiến trúc hiện tại của dự án và có thể triển khai từng bước mà không ảnh hưởng đến các tính năng đang hoạt động.

---

**Tác giả:** AI Assistant  
**Ngày tạo:** 2024-11-15  
**Phiên bản:** 1.0
