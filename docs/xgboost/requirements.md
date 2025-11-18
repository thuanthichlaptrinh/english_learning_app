# Requirements Document

## Introduction

Hệ thống gợi ý ôn tập từ vựng thông minh sử dụng mô hình XGBoost (Gradient Boosting Machine Learning) để dự đoán và ưu tiên các từ vựng mà người dùng nên ôn tập. Hệ thống phân tích dữ liệu học tập từ bảng `user_vocab_progress` và đưa ra danh sách từ vựng được sắp xếp theo mức độ ưu tiên, giúp người dùng tối ưu hóa quá trình học tập.

## Glossary

- **XGBoost**: Extreme Gradient Boosting - thuật toán machine learning mạnh mẽ cho bài toán phân loại và hồi quy
- **AI Service**: Microservice Python FastAPI chạy độc lập, cung cấp các API liên quan đến AI/ML
- **Spring Boot Backend**: Backend chính của ứng dụng Card Words, viết bằng Java Spring Boot
- **UserVocabProgress**: Entity lưu trữ tiến trình học từ vựng của người dùng
- **VocabStatus**: Trạng thái của từ vựng (NEW, KNOWN, UNKNOWN, MASTERED)
- **Priority Score**: Điểm ưu tiên được tính toán bởi model XGBoost để xếp hạng từ vựng cần ôn tập
- **Feature Vector**: Vector đặc trưng được trích xuất từ dữ liệu UserVocabProgress để đưa vào model
- **Training Dataset**: Tập dữ liệu được sử dụng để huấn luyện model XGBoost
- **Inference**: Quá trình sử dụng model đã huấn luyện để dự đoán priority score cho từ vựng mới

## Requirements

### Requirement 1: Trích xuất đặc trưng từ dữ liệu học tập

**User Story:** Là một AI Engineer, tôi muốn trích xuất các đặc trưng từ bảng UserVocabProgress, để có thể đưa vào model XGBoost cho việc dự đoán

#### Acceptance Criteria

1. WHEN THE AI Service nhận được yêu cầu trích xuất đặc trưng, THE AI Service SHALL đọc dữ liệu từ bảng user_vocab_progress của user được chỉ định
2. THE AI Service SHALL trích xuất các đặc trưng sau từ mỗi bản ghi UserVocabProgress: times_correct, times_wrong, interval_days, repetition, ef_factor, days_since_last_review, days_until_next_review, status_encoded, accuracy_rate
3. THE AI Service SHALL tính toán accuracy_rate bằng công thức times_correct / (times_correct + times_wrong) WHEN tổng số lần thử lớn hơn 0
4. THE AI Service SHALL tính toán days_since_last_review bằng số ngày từ last_reviewed đến ngày hiện tại
5. THE AI Service SHALL tính toán days_until_next_review bằng số ngày từ ngày hiện tại đến next_review_date
6. THE AI Service SHALL mã hóa status thành giá trị số (NEW=0, UNKNOWN=1, KNOWN=2, MASTERED=3)
7. THE AI Service SHALL chuẩn hóa các đặc trưng số về khoảng [0, 1] sử dụng StandardScaler hoặc MinMaxScaler
8. THE AI Service SHALL trả về feature vector dưới dạng numpy array với shape (n_samples, n_features)

### Requirement 2: Huấn luyện model XGBoost

**User Story:** Là một AI Engineer, tôi muốn huấn luyện model XGBoost từ dữ liệu lịch sử, để model có thể học được pattern và dự đoán từ vựng cần ôn tập

#### Acceptance Criteria

1. THE AI Service SHALL tạo training dataset từ dữ liệu UserVocabProgress của tất cả người dùng
2. THE AI Service SHALL tạo target label dựa trên logic: từ vựng có status là UNKNOWN hoặc NEW hoặc KNOWN AND (days_until_next_review <= 0 OR accuracy_rate < 0.7) SHALL được gán label = 1 (cần ôn tập), còn lại label = 0
3. THE AI Service SHALL chia dataset thành training set (80%) và validation set (20%)
4. THE AI Service SHALL khởi tạo XGBoost classifier với các hyperparameters: max_depth=6, learning_rate=0.1, n_estimators=100, objective='binary:logistic'
5. THE AI Service SHALL huấn luyện model trên training set
6. THE AI Service SHALL đánh giá model trên validation set và tính toán các metrics: accuracy, precision, recall, F1-score, AUC-ROC
7. THE AI Service SHALL lưu model đã huấn luyện vào thư mục models/ dưới định dạng pickle hoặc joblib
8. THE AI Service SHALL lưu scaler đã fit vào thư mục models/ để sử dụng cho inference
9. WHEN validation accuracy nhỏ hơn 0.7, THE AI Service SHALL ghi log cảnh báo về chất lượng model

### Requirement 3: API dự đoán từ vựng cần ôn tập

**User Story:** Là một người dùng, tôi muốn nhận được danh sách từ vựng được gợi ý ôn tập, để tôi có thể tập trung vào những từ quan trọng nhất

#### Acceptance Criteria

1. THE AI Service SHALL cung cấp endpoint POST /api/v1/smart-review/predict với request body chứa user_id và limit (số lượng từ vựng)
2. WHEN THE AI Service nhận được request, THE AI Service SHALL xác thực JWT token từ header Authorization
3. THE AI Service SHALL truy vấn tất cả UserVocabProgress của user có status là NEW, UNKNOWN, hoặc KNOWN
4. THE AI Service SHALL trích xuất feature vector cho mỗi từ vựng
5. THE AI Service SHALL load model XGBoost đã huấn luyện từ thư mục models/
6. THE AI Service SHALL sử dụng model để dự đoán probability score cho mỗi từ vựng
7. THE AI Service SHALL sắp xếp danh sách từ vựng theo probability score giảm dần
8. THE AI Service SHALL trả về top N từ vựng (theo limit) kèm theo thông tin: vocab_id, word, meaning_vi, transcription, priority_score, status, times_correct, times_wrong, last_reviewed, next_review_date
9. THE AI Service SHALL cache kết quả dự đoán trong Redis với TTL là 300 giây (5 phút)
10. WHEN cache tồn tại cho user_id, THE AI Service SHALL trả về kết quả từ cache thay vì tính toán lại

### Requirement 4: API huấn luyện lại model

**User Story:** Là một Admin, tôi muốn có thể huấn luyện lại model XGBoost, để model luôn được cập nhật với dữ liệu mới nhất

#### Acceptance Criteria

1. THE AI Service SHALL cung cấp endpoint POST /api/v1/smart-review/retrain chỉ cho phép admin truy cập
2. WHEN THE AI Service nhận được request retrain, THE AI Service SHALL xác thực API key hoặc admin token
3. THE AI Service SHALL thu thập toàn bộ dữ liệu UserVocabProgress từ database
4. THE AI Service SHALL thực hiện quá trình huấn luyện model như mô tả trong Requirement 2
5. THE AI Service SHALL backup model cũ trước khi ghi đè model mới
6. THE AI Service SHALL trả về response chứa training metrics: accuracy, precision, recall, F1-score, training_time
7. THE AI Service SHALL ghi log chi tiết về quá trình huấn luyện
8. WHEN quá trình huấn luyện thất bại, THE AI Service SHALL giữ nguyên model cũ và trả về error message

### Requirement 5: Tích hợp với Spring Boot Backend

**User Story:** Là một Backend Developer, tôi muốn Spring Boot Backend có thể gọi AI Service, để người dùng có thể sử dụng tính năng gợi ý thông minh từ ứng dụng chính

#### Acceptance Criteria

1. THE Spring Boot Backend SHALL tạo REST client để gọi AI Service endpoints
2. THE Spring Boot Backend SHALL cung cấp endpoint GET /api/v1/smart-review/recommendations với query params: limit (default=20)
3. WHEN THE Spring Boot Backend nhận được request, THE Spring Boot Backend SHALL forward request đến AI Service kèm theo user_id từ JWT token
4. THE Spring Boot Backend SHALL enrich response từ AI Service bằng cách thêm thông tin: imageUrl, audioUrl, topicName từ database
5. THE Spring Boot Backend SHALL xử lý timeout và error từ AI Service với timeout là 10 giây
6. WHEN AI Service không khả dụng, THE Spring Boot Backend SHALL fallback về thuật toán rule-based đơn giản
7. THE Spring Boot Backend SHALL trả về response với format: recommendations (array), total, meta (last_updated, model_version)

### Requirement 6: Monitoring và Logging

**User Story:** Là một DevOps Engineer, tôi muốn theo dõi hiệu suất của AI Service, để đảm bảo hệ thống hoạt động ổn định

#### Acceptance Criteria

1. THE AI Service SHALL ghi log mỗi khi nhận được request với thông tin: timestamp, user_id, endpoint, processing_time
2. THE AI Service SHALL ghi log chi tiết khi xảy ra lỗi với thông tin: error_type, error_message, stack_trace
3. THE AI Service SHALL expose endpoint GET /health để kiểm tra trạng thái service
4. THE AI Service SHALL expose endpoint GET /metrics để lấy các metrics: total_requests, average_response_time, model_version, last_training_time
5. THE AI Service SHALL tính toán và log average inference time cho mỗi batch prediction
6. WHEN inference time vượt quá 2 giây, THE AI Service SHALL ghi log cảnh báo
7. THE AI Service SHALL lưu trữ logs vào file với rotation hàng ngày

### Requirement 7: Caching và Performance

**User Story:** Là một người dùng, tôi muốn nhận được kết quả gợi ý nhanh chóng, để trải nghiệm sử dụng được mượt mà

#### Acceptance Criteria

1. THE AI Service SHALL sử dụng Redis để cache kết quả prediction với key format: "smart_review:{user_id}"
2. THE AI Service SHALL set TTL cho cache là 300 giây (5 phút)
3. WHEN cache hit, THE AI Service SHALL trả về kết quả trong vòng dưới 50 milliseconds
4. WHEN cache miss, THE AI Service SHALL thực hiện prediction và cache kết quả trước khi trả về
5. THE AI Service SHALL invalidate cache của user WHEN user submit kết quả học tập mới
6. THE AI Service SHALL load model XGBoost vào memory khi khởi động service
7. THE AI Service SHALL sử dụng batch prediction WHEN số lượng từ vựng lớn hơn 100
8. THE AI Service SHALL giới hạn số lượng concurrent requests là 50 để tránh quá tải

### Requirement 8: Database Connection

**User Story:** Là một AI Service, tôi cần kết nối đến PostgreSQL database, để đọc dữ liệu UserVocabProgress

#### Acceptance Criteria

1. THE AI Service SHALL kết nối đến PostgreSQL database sử dụng SQLAlchemy ORM
2. THE AI Service SHALL sử dụng connection pool với min_size=5, max_size=20
3. THE AI Service SHALL chỉ thực hiện read-only queries trên database
4. THE AI Service SHALL sử dụng async queries với asyncpg driver
5. THE AI Service SHALL xử lý database connection errors và retry tối đa 3 lần với exponential backoff
6. THE AI Service SHALL đóng database connections khi shutdown service
7. WHEN database không khả dụng, THE AI Service SHALL trả về HTTP 503 Service Unavailable

### Requirement 9: Security

**User Story:** Là một Security Engineer, tôi muốn đảm bảo AI Service được bảo mật, để tránh truy cập trái phép

#### Acceptance Criteria

1. THE AI Service SHALL xác thực JWT token cho tất cả endpoints trừ /health và /metrics
2. THE AI Service SHALL sử dụng shared JWT secret với Spring Boot Backend
3. THE AI Service SHALL kiểm tra token expiration và trả về HTTP 401 Unauthorized WHEN token hết hạn
4. THE AI Service SHALL kiểm tra user_id trong token khớp với user_id trong request body
5. THE AI Service SHALL yêu cầu API key hoặc admin role cho endpoint /retrain
6. THE AI Service SHALL rate limit requests theo user_id: tối đa 60 requests/phút
7. WHEN rate limit vượt quá, THE AI Service SHALL trả về HTTP 429 Too Many Requests
8. THE AI Service SHALL không log sensitive information như JWT token hoặc passwords

### Requirement 10: Deployment và Configuration

**User Story:** Là một DevOps Engineer, tôi muốn deploy AI Service dễ dàng, để có thể triển khai lên production nhanh chóng

#### Acceptance Criteria

1. THE AI Service SHALL được containerized sử dụng Docker
2. THE AI Service SHALL đọc configuration từ environment variables: DATABASE_URL, REDIS_URL, JWT_SECRET, MODEL_PATH
3. THE AI Service SHALL expose port 8001 cho HTTP traffic
4. THE AI Service SHALL có health check endpoint để Docker kiểm tra
5. THE AI Service SHALL gracefully shutdown khi nhận SIGTERM signal
6. THE AI Service SHALL có Dockerfile tối ưu với multi-stage build
7. THE AI Service SHALL được thêm vào docker-compose.yml chung ở root của monorepo cùng với Spring Boot, PostgreSQL và Redis
8. THE AI Service SHALL sử dụng shared network "card-words-network" trong docker-compose để kết nối với các services khác
9. THE AI Service SHALL có pyproject.toml để quản lý dependencies với Poetry
