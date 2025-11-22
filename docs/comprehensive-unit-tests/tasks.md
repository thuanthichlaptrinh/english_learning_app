# Implementation Plan

- [ ] 1. Setup test infrastructure cho Card-Words (Java)
  - Tạo test configuration classes (TestConfig, TestSecurityConfig, TestRedisConfig)
  - Setup H2 in-memory database configuration
  - Configure JaCoCo plugin trong pom.xml cho code coverage
  - Tạo base test classes với common setup
  - _Requirements: 1.5, 8.1, 8.2_

- [ ] 2. Tạo test fixtures cho Card-Words
  - Implement UserFixtures với các user types (regular, admin, inactive)
  - Implement VocabFixtures với sample vocabulary data
  - Implement GameFixtures với game sessions và details
  - Implement TopicFixtures với topics và associated vocabs
  - _Requirements: 8.2_

- [ ] 3. Viết unit tests cho utility classes
  - [ ] 3.1 Implement PasswordGeneratorTest
    - Test password generation với various lengths
    - Test password complexity requirements
    - Test random generation uniqueness
    - _Requirements: 4.1, 4.2, 4.3_
  
  - [ ] 3.2 Implement StreakCalculationTest
    - Test streak calculation với consecutive days
    - Test streak reset khi miss days
    - Test edge cases (timezone, midnight)
    - _Requirements: 4.1, 4.2, 4.5_
  
  - [ ] 3.3 Enhance VocabStatusCalculatorTest (already exists)
    - Add more edge case tests
    - Add parameterized tests cho various scenarios
    - Test boundary conditions
    - _Requirements: 4.1, 4.2, 4.5_

- [ ] 4. Viết unit tests cho helper classes
  - [ ] 4.1 Implement TopicProgressCalculatorTest
    - Test progress calculation với various completion rates
    - Test với empty topics
    - Test với partially completed topics
    - _Requirements: 4.1, 4.2, 4.5_
  
  - [ ] 4.2 Implement AuthenticationHelperTest
    - Test getCurrentUser method
    - Test permission checking
    - Test với unauthenticated users
    - _Requirements: 4.1, 4.2_

- [ ] 5. Viết unit tests cho mapper classes
  - [ ] 5.1 Implement VocabMapperTest
    - Test entity to DTO mapping
    - Test DTO to entity mapping
    - Test null handling
    - Test list mapping
    - _Requirements: 3.1, 3.2, 3.3, 3.4_
  
  - [ ] 5.2 Implement UserAdminMapperTest
    - Test user entity to admin DTO mapping
    - Test với various user roles
    - Test null và optional fields
    - _Requirements: 3.1, 3.2, 3.3_
  
  - [ ] 5.3 Implement GameHistoryMapperTest
    - Test game session to DTO mapping
    - Test với game details
    - Test aggregation logic
    - _Requirements: 3.1, 3.2, 3.5_
  
  - [ ] 5.4 Implement UserVocabProgressMapperTest
    - Test progress entity to DTO mapping
    - Test với calculated fields
    - Test status mapping
    - _Requirements: 3.1, 3.2, 3.5_

- [ ] 6. Viết unit tests cho authentication use cases
  - [ ] 6.1 Implement AuthenticationServiceTest
    - Test login với valid credentials
    - Test login với invalid credentials
    - Test registration với valid data
    - Test registration với duplicate email
    - Test password reset flow
    - Test token generation và validation
    - _Requirements: 1.1, 1.2, 1.3, 1.4_
  
  - [ ] 6.2 Implement GoogleOAuth2ServiceTest
    - Test OAuth2 login flow
    - Test user creation từ Google profile
    - Test existing user login
    - Test error handling
    - _Requirements: 1.1, 1.2, 1.3, 1.4_

- [ ] 7. Viết unit tests cho vocab use cases
  - [ ] 7.1 Implement VocabServiceTest
    - Test create vocab với valid data
    - Test update vocab
    - Test delete vocab
    - Test get vocab by ID
    - Test search vocabs với filters
    - Test pagination
    - _Requirements: 1.1, 1.2, 1.3, 1.4_
  
  - [ ] 7.2 Implement UserVocabProgressServiceTest
    - Test update progress
    - Test calculate accuracy
    - Test get user progress
    - Test reset progress
    - _Requirements: 1.1, 1.2, 1.3, 1.4_
  
  - [ ] 7.3 Implement LearnVocabServiceTest
    - Test get vocabs for learning
    - Test mark vocab as learned
    - Test spaced repetition logic
    - _Requirements: 1.1, 1.2, 1.4, 1.5_

- [ ] 8. Viết unit tests cho game use cases
  - [ ] 8.1 Implement QuickQuizServiceTest
    - Test generate quiz questions
    - Test submit quiz answers
    - Test calculate quiz score
    - Test save quiz results
    - _Requirements: 1.1, 1.2, 1.3, 1.4_
  
  - [ ] 8.2 Implement ImageWordMatchingServiceTest
    - Test generate matching pairs
    - Test validate matches
    - Test calculate score
    - Test save game session
    - _Requirements: 1.1, 1.2, 1.3, 1.4_
  
  - [ ] 8.3 Implement WordDefinitionMatchingServiceTest
    - Test generate definition pairs
    - Test validate matches
    - Test scoring logic
    - _Requirements: 1.1, 1.2, 1.3, 1.4_
  
  - [ ] 8.4 Implement GameHistoryServiceTest
    - Test get user game history
    - Test calculate statistics
    - Test filter by game type
    - Test pagination
    - _Requirements: 1.1, 1.2, 1.4_

- [ ] 9. Viết unit tests cho user management use cases
  - [ ] 9.1 Implement UserServiceTest
    - Test get user profile
    - Test update user profile
    - Test change password
    - Test delete user account
    - _Requirements: 1.1, 1.2, 1.3, 1.4_
  
  - [ ] 9.2 Implement UserStatsServiceTest
    - Test calculate user statistics
    - Test get learning progress
    - Test get achievement data
    - _Requirements: 1.1, 1.2, 1.4_
  
  - [ ] 9.3 Implement StreakServiceTest
    - Test calculate current streak
    - Test update streak on activity
    - Test streak reset logic
    - Test streak history
    - _Requirements: 1.1, 1.2, 1.4, 1.5_
  
  - [ ] 9.4 Implement LeaderboardServiceTest
    - Test get global leaderboard
    - Test get friend leaderboard
    - Test ranking calculation
    - Test pagination và caching
    - _Requirements: 1.1, 1.2, 1.4, 1.5_

- [ ] 10. Viết unit tests cho admin use cases
  - [ ] 10.1 Implement TopicServiceTest (admin)
    - Test create topic
    - Test update topic
    - Test delete topic
    - Test add vocabs to topic
    - _Requirements: 1.1, 1.2, 1.3, 1.4_
  
  - [ ] 10.2 Implement UserAdminServiceTest
    - Test get all users với filters
    - Test update user roles
    - Test ban/unban users
    - Test user statistics
    - _Requirements: 1.1, 1.2, 1.3, 1.4_
  
  - [ ] 10.3 Implement GameAdminServiceTest
    - Test get game statistics
    - Test manage game configurations
    - _Requirements: 1.1, 1.2, 1.4_

- [ ] 11. Viết unit tests cho service classes
  - [ ] 11.1 Implement ChatbotServiceTest
    - Test process user message
    - Test FAQ matching
    - Test context management
    - _Requirements: 2.1, 2.2, 2.3, 2.4_
  
  - [ ] 11.2 Implement GeminiServiceTest
    - Test generate AI response
    - Test error handling
    - Test rate limiting
    - _Requirements: 2.1, 2.2, 2.3, 2.4_
  
  - [ ] 11.3 Implement EmailServiceTest
    - Test send activation email
    - Test send password reset email
    - Test email template rendering
    - _Requirements: 2.1, 2.2, 2.3, 2.4_
  
  - [ ] 11.4 Implement NotificationServiceTest
    - Test create notification
    - Test get user notifications
    - Test mark as read
    - Test delete notification
    - _Requirements: 2.1, 2.2, 2.3, 2.4_

- [ ] 12. Setup test infrastructure cho Card-Words-AI (Python)
  - Tạo tests directory structure
  - Implement conftest.py với pytest fixtures
  - Setup pytest.ini configuration
  - Configure pytest-cov cho coverage reporting
  - Tạo requirements-test.txt
  - _Requirements: 5.1, 6.1, 7.1, 8.3_

- [ ] 13. Tạo test fixtures cho Card-Words-AI
  - Implement vocab_fixtures.py với sample vocab data
  - Implement feature_fixtures.py với sample ML features
  - Implement progress_fixtures.py với user progress data
  - Implement model_fixtures.py với mock models
  - _Requirements: 8.3_

- [ ] 14. Viết unit tests cho ML components
  - [ ] 14.1 Implement test_xgboost_model.py
    - Test model loading
    - Test prediction với valid features
    - Test prediction với invalid features
    - Test model save/load cycle
    - _Requirements: 5.1, 5.2, 5.3, 5.4_
  
  - [ ] 14.2 Implement test_feature_extractor.py
    - Test extract features từ vocab progress
    - Test feature normalization
    - Test handle missing data
    - Test feature validation
    - _Requirements: 5.1, 5.5_

- [ ] 15. Viết unit tests cho service classes (Python)
  - [ ] 15.1 Implement test_smart_review_service.py
    - Test get review recommendations
    - Test calculate priority scores
    - Test filter vocabs by criteria
    - Test handle empty progress
    - _Requirements: 5.1, 5.2, 5.5_
  
  - [ ] 15.2 Implement test_cache_service.py
    - Test cache get/set operations
    - Test cache expiration
    - Test cache invalidation
    - _Requirements: 2.5_
  
  - [ ] 15.3 Implement test_database_service.py
    - Test get user progress
    - Test get vocab data
    - Test connection handling
    - Test error handling
    - _Requirements: 6.1, 6.2, 6.5_

- [ ] 16. Viết unit tests cho training components
  - [ ] 16.1 Implement test_model_trainer.py
    - Test data preparation
    - Test model training
    - Test model evaluation
    - Test model saving
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5_
  
  - [ ] 16.2 Implement test_data_preprocessor.py
    - Test data cleaning
    - Test feature engineering
    - Test data validation
    - Test handle outliers
    - _Requirements: 6.2, 6.5_

- [ ] 17. Viết unit tests cho API endpoints (Python)
  - [ ] 17.1 Implement test_prediction_endpoints.py
    - Test POST /api/v1/predict với valid data
    - Test POST /api/v1/predict với invalid data
    - Test authentication requirement
    - Test response format
    - _Requirements: 7.1, 7.2, 7.3, 7.4_
  
  - [ ] 17.2 Implement test_training_endpoints.py
    - Test POST /api/v1/train endpoint
    - Test GET /api/v1/model/status endpoint
    - Test authentication và authorization
    - _Requirements: 7.1, 7.2, 7.3, 7.4_
  
  - [ ] 17.3 Implement test_health_endpoints.py
    - Test GET /health endpoint
    - Test GET /ready endpoint
    - Test model health check
    - _Requirements: 7.1, 7.2_

- [ ] 18. Viết unit tests cho middleware (Python)
  - [ ] 18.1 Implement test_auth.py
    - Test JWT token validation
    - Test authentication middleware
    - Test authorization checks
    - Test error responses
    - _Requirements: 7.4_

- [ ] 19. Setup CI/CD integration
  - [ ] 19.1 Tạo GitHub Actions workflow cho Java tests
    - Configure Maven test execution
    - Setup JaCoCo coverage reporting
    - Configure test result publishing
    - _Requirements: 9.1, 9.2, 9.3, 9.4_
  
  - [ ] 19.2 Tạo GitHub Actions workflow cho Python tests
    - Configure pytest execution
    - Setup pytest-cov coverage reporting
    - Configure test result publishing
    - _Requirements: 9.1, 9.2, 9.3, 9.4_
  
  - [ ] 19.3 Configure coverage thresholds
    - Set minimum coverage requirements
    - Configure coverage fail conditions
    - Setup coverage badges
    - _Requirements: 9.3, 9.4_

- [ ] 20. Tạo documentation và scripts
  - Viết README.md cho testing trong card-words
  - Viết README.md cho testing trong card-words-ai
  - Tạo script chạy tests locally (run-tests.sh/bat)
  - Tạo script generate coverage reports
  - Document test naming conventions
  - _Requirements: 8.4, 8.5_
