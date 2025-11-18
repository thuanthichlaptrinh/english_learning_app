# Implementation Plan

- [ ] 1. Setup project structure and dependencies
  - Cập nhật pyproject.toml với XGBoost và các dependencies cần thiết
  - Tạo cấu trúc thư mục cho ML components, services, repositories
  - Cấu hình environment variables và settings
  - _Requirements: 10.1, 10.2, 10.8, 10.9_

- [ ] 2. Implement database layer
  - [ ] 2.1 Create SQLAlchemy models for UserVocabProgress and Vocab
    - Định nghĩa UserVocabProgress model với tất cả fields
    - Định nghĩa Vocab model với relationships
    - _Requirements: 8.1, 8.2_
  
  - [ ] 2.2 Implement DatabaseService with async queries
    - Tạo async engine và session factory
    - Implement get_user_vocab_progress() với filter by statuses
    - Implement get_all_vocab_progress() cho training
    - Implement health_check() method
    - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5, 8.6_

- [ ] 3. Implement cache layer
  - [ ] 3.1 Create CacheService for Redis operations
    - Implement async get() method
    - Implement async set() với TTL support
    - Implement async delete() method
    - Implement health_check() method
    - _Requirements: 7.1, 7.2, 7.3, 7.4_

- [ ] 4. Implement feature extraction
  - [ ] 4.1 Create VocabFeatureExtractor class
    - Implement extract_features() để trích xuất 9 features
    - Implement tính toán accuracy_rate
    - Implement tính toán days_since_last_review
    - Implement tính toán days_until_next_review
    - Implement status encoding (NEW=0, UNKNOWN=1, KNOWN=2, MASTERED=3)
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 1.6_
  
  - [ ] 4.2 Implement feature normalization
    - Implement normalize_features() với StandardScaler
    - Implement extract_and_normalize() cho batch processing
    - _Requirements: 1.7, 1.8_

- [ ] 5. Implement XGBoost model
  - [ ] 5.1 Create XGBoostVocabModel class
    - Implement __init__() với model_path parameter
    - Implement load_model() để load từ disk
    - Implement save_model() để lưu model và scaler
    - _Requirements: 2.7, 2.8_
  
  - [ ] 5.2 Implement training logic
    - Implement generate_labels() logic (UNKNOWN/NEW/KNOWN với điều kiện)
    - Implement train() method với train/validation split
    - Configure XGBoost hyperparameters (max_depth=6, learning_rate=0.1, n_estimators=100)
    - Implement evaluate() để tính accuracy, precision, recall, F1, AUC-ROC
    - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.9_
  
  - [ ] 5.3 Implement prediction logic
    - Implement predict_proba() method
    - Load model vào memory khi khởi động service
    - _Requirements: 3.5, 3.6, 7.6_

- [ ] 6. Implement prediction service
  - [ ] 6.1 Create SmartReviewService class
    - Implement get_recommendations() method
    - Implement cache check logic
    - Implement database query cho user vocab progress
    - Implement feature extraction và normalization
    - Implement XGBoost prediction
    - Implement ranking vocabs by probability score
    - Implement cache result với TTL 300s
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9, 3.10, 7.1, 7.2, 7.3, 7.4_
  
  - [ ] 6.2 Implement cache invalidation
    - Implement invalidate_user_cache() method
    - _Requirements: 7.5_

- [ ] 7. Implement API endpoints
  - [ ] 7.1 Create Pydantic schemas
    - Create PredictRequest schema
    - Create VocabRecommendation schema
    - Create PredictResponse schema
    - Create RetrainRequest schema
    - Create RetrainResponse schema
    - Create ErrorResponse schema
    - _Requirements: 3.1, 4.1_
  
  - [ ] 7.2 Implement POST /api/v1/smart-review/predict endpoint
    - Validate request body
    - Call SmartReviewService.get_recommendations()
    - Return response với vocab list và metadata
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8_
  
  - [ ] 7.3 Implement POST /api/v1/smart-review/retrain endpoint
    - Validate admin API key
    - Collect all UserVocabProgress data
    - Train XGBoost model
    - Backup old model
    - Save new model
    - Return training metrics
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7, 4.8_
  
  - [ ] 7.4 Implement POST /api/v1/smart-review/invalidate-cache endpoint
    - Validate internal API key
    - Call cache invalidation service
    - _Requirements: 7.5_
  
  - [ ] 7.5 Update GET /health endpoint
    - Check database connection
    - Check Redis connection
    - Check model loaded status
    - _Requirements: 6.3, 8.6_
  
  - [ ] 7.6 Implement GET /metrics endpoint
    - Return total requests, cache hit rate, average inference time
    - Return model version và last training time
    - _Requirements: 6.4_

- [ ] 8. Implement middleware
  - [ ] 8.1 Create JWT authentication middleware
    - Extract token từ Authorization header
    - Decode JWT với shared secret
    - Validate token expiration
    - Extract user_id từ payload
    - _Requirements: 9.1, 9.2, 9.3_
  
  - [ ] 8.2 Create rate limiting middleware
    - Track requests per user_id trong Redis
    - Limit 60 requests/minute
    - Return 429 khi vượt quá
    - _Requirements: 9.6, 9.7_
  
  - [ ] 8.3 Create error handler middleware
    - Handle authentication errors (401)
    - Handle authorization errors (403)
    - Handle validation errors (422)
    - Handle rate limit errors (429)
    - Handle service errors (503)
    - Handle internal errors (500)
    - Log errors với structured logging
    - _Requirements: 9.8_

- [ ] 9. Implement monitoring and logging
  - [ ] 9.1 Setup structured logging với structlog
    - Configure logger với JSON format
    - Log mỗi request với timestamp, user_id, endpoint, processing_time
    - Log errors với error_type, message, stack_trace
    - _Requirements: 6.1, 6.2_
  
  - [ ] 9.2 Implement metrics tracking
    - Track total requests
    - Track cache hit rate
    - Track average inference time
    - Track model version
    - _Requirements: 6.4, 6.5_
  
  - [ ] 9.3 Implement performance monitoring
    - Log warning khi inference time > 2 seconds
    - Implement log rotation hàng ngày
    - _Requirements: 6.6, 6.7_

- [ ] 10. Implement Spring Boot integration
  - [ ] 10.1 Create REST client trong Spring Boot
    - Tạo AIServiceClient class
    - Configure RestTemplate với timeouts (connect=5s, read=10s)
    - _Requirements: 5.1, 5.5_
  
  - [ ] 10.2 Create Spring Boot endpoint GET /api/v1/smart-review/recommendations
    - Extract user_id từ JWT token
    - Forward request đến AI Service
    - Enrich response với imageUrl, audioUrl, topicName
    - Handle timeout và errors
    - Implement fallback về rule-based algorithm
    - _Requirements: 5.2, 5.3, 5.4, 5.5, 5.6, 5.7_

- [ ] 11. Docker deployment
  - [ ] 11.1 Create optimized Dockerfile
    - Use Python 3.11-slim base image
    - Install system dependencies (gcc, postgresql-client, curl)
    - Install Poetry và dependencies
    - Copy application code và models
    - Configure health check
    - _Requirements: 10.1, 10.3, 10.4, 10.5, 10.6_
  
  - [ ] 11.2 Update docker-compose.yml
    - Service đã được thêm vào docker-compose.yml ở root
    - Verify environment variables
    - Verify volumes cho models directory
    - Verify network configuration (card-words-network)
    - _Requirements: 10.7, 10.8_

- [ ] 12. Security implementation
  - [ ] 12.1 Implement JWT validation
    - Validate JWT token cho tất cả endpoints trừ /health và /metrics
    - Check user_id trong token khớp với request
    - _Requirements: 9.1, 9.2, 9.3, 9.4_
  
  - [ ] 12.2 Implement API key authentication
    - Validate admin API key cho /retrain endpoint
    - Validate internal API key cho /invalidate-cache endpoint
    - _Requirements: 9.5_
  
  - [ ] 12.3 Implement input validation và sanitization
    - Validate tất cả request parameters
    - Ensure không log sensitive information
    - _Requirements: 9.8_

- [ ]* 13. Testing
  - [ ]* 13.1 Write unit tests cho Feature Extractor
    - Test extract_features() với các trường hợp khác nhau
    - Test normalization logic
    - Test edge cases (no reviews, zero attempts)
    - _Requirements: 1.1-1.8_
  
  - [ ]* 13.2 Write unit tests cho XGBoost Model
    - Test model training
    - Test prediction
    - Test model save/load
    - Test label generation logic
    - _Requirements: 2.1-2.9_
  
  - [ ]* 13.3 Write unit tests cho SmartReviewService
    - Test recommendation logic
    - Test cache hit/miss scenarios
    - Test error handling
    - _Requirements: 3.1-3.10_
  
  - [ ]* 13.4 Write integration tests cho API endpoints
    - Test POST /api/v1/smart-review/predict
    - Test POST /api/v1/smart-review/retrain
    - Test authentication và authorization
    - Test rate limiting
    - _Requirements: 3.1-3.10, 4.1-4.8, 9.1-9.8_
  
  - [ ]* 13.5 Write integration tests cho database và cache
    - Test database queries
    - Test Redis operations
    - Test connection pooling
    - _Requirements: 7.1-7.8, 8.1-8.6_

- [ ] 14. Documentation và deployment guide
  - [ ]* 14.1 Write API documentation
    - Document tất cả endpoints với examples
    - Document request/response schemas
    - Document error codes
    - _Requirements: All_
  
  - [ ] 14.2 Create deployment guide
    - Document environment variables
    - Document Docker deployment steps
    - Document model training process
    - _Requirements: 10.1-10.9_
  
  - [ ]* 14.3 Create README cho card-words-ai
    - Overview của service
    - Setup instructions
    - API usage examples
    - _Requirements: All_
