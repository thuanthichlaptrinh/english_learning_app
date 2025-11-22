# Requirements Document

## Introduction

Dự án cần viết unit tests toàn diện cho cả hai hệ thống: card-words (Java Spring Boot backend) và card-words-ai (Python AI service). Mục tiêu là đảm bảo chất lượng code, phát hiện bugs sớm, và tạo nền tảng vững chắc cho việc refactoring và mở rộng tính năng trong tương lai.

## Glossary

- **Card-Words System**: Hệ thống backend Java Spring Boot chính, quản lý vocabulary, games, users, và business logic
- **Card-Words-AI System**: Hệ thống AI service Python sử dụng XGBoost để dự đoán và đề xuất vocabulary
- **Unit Test**: Test kiểm tra một đơn vị code nhỏ nhất (method, function) một cách độc lập
- **Test Coverage**: Phần trăm code được cover bởi tests
- **Mock**: Đối tượng giả lập để thay thế dependencies trong testing
- **JUnit**: Framework testing cho Java
- **Pytest**: Framework testing cho Python
- **Mockito**: Framework mocking cho Java
- **Test Fixture**: Dữ liệu và setup cần thiết để chạy tests

## Requirements

### Requirement 1

**User Story:** Là một developer, tôi muốn có unit tests cho tất cả các use cases trong Card-Words System, để đảm bảo business logic hoạt động đúng

#### Acceptance Criteria

1. WHEN developer chạy test suite, THE Card-Words System SHALL execute tests cho tất cả use case classes với coverage >= 80%
2. WHEN một use case method được gọi với valid input, THE test SHALL verify kết quả trả về đúng expected output
3. WHEN một use case method được gọi với invalid input, THE test SHALL verify exception được throw đúng loại
4. WHERE use case có dependencies (repositories, services), THE test SHALL sử dụng mocks để isolate logic
5. WHILE test chạy, THE Card-Words System SHALL không kết nối đến database hoặc external services thực

### Requirement 2

**User Story:** Là một developer, tôi muốn có unit tests cho các services trong Card-Words System, để đảm bảo service layer hoạt động chính xác

#### Acceptance Criteria

1. WHEN developer chạy test suite, THE Card-Words System SHALL execute tests cho tất cả service classes với coverage >= 80%
2. WHEN một service method xử lý business logic, THE test SHALL verify logic được thực hiện đúng
3. WHEN service tương tác với repositories, THE test SHALL mock repositories và verify interactions
4. IF service throw exception, THEN THE test SHALL verify exception handling đúng
5. WHERE service có caching logic, THE test SHALL verify cache behavior

### Requirement 3

**User Story:** Là một developer, tôi muốn có unit tests cho các mappers trong Card-Words System, để đảm bảo data transformation chính xác

#### Acceptance Criteria

1. WHEN developer chạy test suite, THE Card-Words System SHALL execute tests cho tất cả mapper classes với coverage >= 90%
2. WHEN mapper convert entity to DTO, THE test SHALL verify tất cả fields được map đúng
3. WHEN mapper convert DTO to entity, THE test SHALL verify tất cả fields được map đúng
4. WHEN mapper xử lý null values, THE test SHALL verify null handling đúng
5. WHERE mapper có custom logic, THE test SHALL verify custom logic hoạt động chính xác

### Requirement 4

**User Story:** Là một developer, tôi muốn có unit tests cho các utility classes trong Card-Words System, để đảm bảo helper functions hoạt động đúng

#### Acceptance Criteria

1. WHEN developer chạy test suite, THE Card-Words System SHALL execute tests cho tất cả utility classes với coverage >= 95%
2. WHEN utility method được gọi với various inputs, THE test SHALL verify outputs cho tất cả edge cases
3. WHEN utility method xử lý strings, dates, numbers, THE test SHALL verify calculations và transformations đúng
4. IF utility method có validation logic, THEN THE test SHALL verify validation rules
5. WHERE utility method có complex algorithms, THE test SHALL verify algorithm correctness với multiple test cases

### Requirement 5

**User Story:** Là một developer, tôi muốn có unit tests cho ML prediction service trong Card-Words-AI System, để đảm bảo AI predictions chính xác

#### Acceptance Criteria

1. WHEN developer chạy test suite, THE Card-Words-AI System SHALL execute tests cho prediction service với coverage >= 80%
2. WHEN prediction service nhận valid features, THE test SHALL verify predictions được generate đúng format
3. WHEN prediction service load model, THE test SHALL verify model được load thành công
4. IF model file không tồn tại, THEN THE test SHALL verify error handling đúng
5. WHERE prediction service xử lý features, THE test SHALL verify feature engineering logic đúng

### Requirement 6

**User Story:** Là một developer, tôi muốn có unit tests cho training service trong Card-Words-AI System, để đảm bảo model training process hoạt động đúng

#### Acceptance Criteria

1. WHEN developer chạy test suite, THE Card-Words-AI System SHALL execute tests cho training service với coverage >= 75%
2. WHEN training service prepare data, THE test SHALL verify data preprocessing đúng
3. WHEN training service train model, THE test SHALL verify training process hoàn thành không lỗi
4. WHEN training service save model, THE test SHALL verify model được save đúng location
5. WHERE training service validate data, THE test SHALL verify validation logic đúng

### Requirement 7

**User Story:** Là một developer, tôi muốn có unit tests cho API endpoints trong Card-Words-AI System, để đảm bảo API responses đúng format

#### Acceptance Criteria

1. WHEN developer chạy test suite, THE Card-Words-AI System SHALL execute tests cho tất cả API endpoints với coverage >= 80%
2. WHEN API endpoint nhận valid request, THE test SHALL verify response status code và data format đúng
3. WHEN API endpoint nhận invalid request, THE test SHALL verify error response đúng format
4. IF API endpoint require authentication, THEN THE test SHALL verify auth validation
5. WHERE API endpoint có rate limiting, THE test SHALL verify rate limit behavior

### Requirement 8

**User Story:** Là một developer, tôi muốn có test configuration và fixtures cho cả hai systems, để dễ dàng maintain và reuse test data

#### Acceptance Criteria

1. THE Card-Words System SHALL có test configuration với in-memory database hoặc test containers
2. THE Card-Words System SHALL có test fixtures với sample data cho entities
3. THE Card-Words-AI System SHALL có test fixtures với sample features và predictions
4. THE test suites SHALL có clear naming conventions và organization
5. THE test suites SHALL có documentation về cách chạy và maintain tests

### Requirement 9

**User Story:** Là một developer, tôi muốn có integration với CI/CD để tự động chạy tests, để đảm bảo code quality trước khi merge

#### Acceptance Criteria

1. WHEN developer commit code, THE CI pipeline SHALL tự động chạy unit tests
2. IF any test fails, THEN THE CI pipeline SHALL block merge và notify developer
3. THE CI pipeline SHALL generate test coverage reports
4. THE CI pipeline SHALL fail nếu coverage giảm xuống dưới threshold
5. THE test results SHALL được display rõ ràng trong CI dashboard

### Requirement 10

**User Story:** Là một developer, tôi muốn có performance tests cho critical paths, để đảm bảo system performance không bị degraded

#### Acceptance Criteria

1. WHERE use case hoặc service có performance requirements, THE test SHALL verify execution time
2. WHEN test detect performance regression, THE test SHALL fail với clear message
3. THE performance tests SHALL measure memory usage cho critical operations
4. THE performance tests SHALL verify database query efficiency
5. THE performance test results SHALL được tracked theo thời gian
