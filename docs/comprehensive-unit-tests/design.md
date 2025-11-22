# Design Document - Comprehensive Unit Tests

## Overview

Thiết kế này mô tả cách implement unit tests toàn diện cho cả hai hệ thống: Card-Words (Java Spring Boot) và Card-Words-AI (Python FastAPI). Mục tiêu là đạt coverage >= 80% cho business logic, đảm bảo code quality và tạo foundation vững chắc cho continuous integration.

### Testing Philosophy

- **Isolation**: Mỗi test phải độc lập, không phụ thuộc vào external services
- **Fast**: Tests phải chạy nhanh (< 5 giây cho toàn bộ suite)
- **Reliable**: Tests không được flaky, kết quả phải consistent
- **Maintainable**: Test code phải clean, dễ đọc và maintain
- **Meaningful**: Chỉ test business logic quan trọng, không test getters/setters đơn giản

## Architecture

### Card-Words (Java) Testing Architecture

```
src/test/java/com/thuanthichlaptrinh/card_words/
├── config/                          # Test configuration
│   ├── TestConfig.java             # Base test configuration
│   ├── TestSecurityConfig.java     # Security config for tests
│   └── TestRedisConfig.java        # Redis mock config
├── fixtures/                        # Test data fixtures
│   ├── UserFixtures.java           # User test data
│   ├── VocabFixtures.java          # Vocab test data
│   ├── GameFixtures.java           # Game test data
│   └── TopicFixtures.java          # Topic test data
├── core/
│   ├── usecase/
│   │   ├── user/                   # User use case tests
│   │   │   ├── AuthenticationServiceTest.java
│   │   │   ├── VocabServiceTest.java
│   │   │   ├── GameHistoryServiceTest.java
│   │   │   ├── LeaderboardServiceTest.java
│   │   │   ├── StreakServiceTest.java
│   │   │   └── ...
│   │   └── admin/                  # Admin use case tests
│   │       ├── TopicServiceTest.java
│   │       ├── UserAdminServiceTest.java
│   │       └── ...
│   ├── service/                    # Service tests
│   │   ├── ChatbotServiceTest.java
│   │   ├── GeminiServiceTest.java
│   │   └── redis/
│   │       └── RedisCacheServiceTest.java
│   ├── mapper/                     # Mapper tests
│   │   ├── VocabMapperTest.java
│   │   ├── UserAdminMapperTest.java
│   │   └── GameHistoryMapperTest.java
│   └── util/                       # Utility tests
│       ├── VocabStatusCalculatorTest.java (exists)
│       ├── PasswordGeneratorTest.java
│       └── StreakCalculationTest.java
├── common/
│   └── helper/                     # Helper tests
│       ├── TopicProgressCalculatorTest.java
│       └── AuthenticationHelperTest.java
└── integration/                    # Integration tests (optional)
    └── ...
```

### Card-Words-AI (Python) Testing Architecture

```
tests/
├── __init__.py
├── conftest.py                     # Pytest fixtures and configuration
├── fixtures/                       # Test data fixtures
│   ├── __init__.py
│   ├── vocab_fixtures.py          # Vocab test data
│   └── feature_fixtures.py        # ML feature test data
├── unit/
│   ├── __init__.py
│   ├── core/
│   │   ├── ml/
│   │   │   ├── test_feature_extractor.py
│   │   │   └── test_xgboost_model.py
│   │   └── services/
│   │       ├── test_smart_review_service.py
│   │       └── test_cache_service.py
│   ├── api/
│   │   └── v1/
│   │       ├── test_prediction_endpoints.py
│   │       └── test_training_endpoints.py
│   └── middleware/
│       └── test_auth.py
└── integration/                    # Integration tests (optional)
    └── ...
```

## Components and Interfaces

### 1. Test Configuration (Java)

#### TestConfig.java
```java
@TestConfiguration
public class TestConfig {
    @Bean
    @Primary
    public DataSource dataSource() {
        // H2 in-memory database for tests
        return new EmbeddedDatabaseBuilder()
            .setType(EmbeddedDatabaseType.H2)
            .build();
    }
}
```

#### TestSecurityConfig.java
```java
@TestConfiguration
public class TestSecurityConfig {
    @Bean
    @Primary
    public SecurityFilterChain testSecurityFilterChain(HttpSecurity http) {
        // Disable security for tests
        http.csrf().disable()
            .authorizeHttpRequests().anyRequest().permitAll();
        return http.build();
    }
}
```

### 2. Test Fixtures (Java)

#### UserFixtures.java
```java
public class UserFixtures {
    public static User createTestUser() {
        return User.builder()
            .id(UUID.randomUUID())
            .email("test@example.com")
            .username("testuser")
            .password("hashedPassword")
            .build();
    }
    
    public static User createTestAdmin() {
        // Admin user fixture
    }
}
```

#### VocabFixtures.java
```java
public class VocabFixtures {
    public static Vocab createTestVocab() {
        return Vocab.builder()
            .id(UUID.randomUUID())
            .word("test")
            .meaning("nghĩa test")
            .pronunciation("/test/")
            .build();
    }
    
    public static List<Vocab> createTestVocabList(int count) {
        // Create multiple vocabs
    }
}
```

### 3. Use Case Tests (Java)

#### Pattern cho Use Case Tests
```java
@ExtendWith(MockitoExtension.class)
class AuthenticationServiceTest {
    
    @Mock
    private UserRepository userRepository;
    
    @Mock
    private PasswordEncoder passwordEncoder;
    
    @Mock
    private JwtService jwtService;
    
    @InjectMocks
    private AuthenticationService authenticationService;
    
    @Test
    void login_WithValidCredentials_ShouldReturnToken() {
        // Given
        User user = UserFixtures.createTestUser();
        when(userRepository.findByEmail(anyString()))
            .thenReturn(Optional.of(user));
        when(passwordEncoder.matches(anyString(), anyString()))
            .thenReturn(true);
        when(jwtService.generateToken(any()))
            .thenReturn("test-token");
        
        // When
        LoginResponse response = authenticationService.login(
            new LoginRequest("test@example.com", "password")
        );
        
        // Then
        assertNotNull(response);
        assertEquals("test-token", response.getToken());
        verify(userRepository).findByEmail("test@example.com");
    }
    
    @Test
    void login_WithInvalidCredentials_ShouldThrowException() {
        // Given
        when(userRepository.findByEmail(anyString()))
            .thenReturn(Optional.empty());
        
        // When & Then
        assertThrows(ErrorException.class, () -> {
            authenticationService.login(
                new LoginRequest("invalid@example.com", "password")
            );
        });
    }
}
```

### 4. Mapper Tests (Java)

#### Pattern cho Mapper Tests
```java
@ExtendWith(MockitoExtension.class)
class VocabMapperTest {
    
    @InjectMocks
    private VocabMapperImpl vocabMapper;
    
    @Test
    void toDTO_WithValidEntity_ShouldMapAllFields() {
        // Given
        Vocab vocab = VocabFixtures.createTestVocab();
        
        // When
        VocabDTO dto = vocabMapper.toDTO(vocab);
        
        // Then
        assertNotNull(dto);
        assertEquals(vocab.getId(), dto.getId());
        assertEquals(vocab.getWord(), dto.getWord());
        assertEquals(vocab.getMeaning(), dto.getMeaning());
        assertEquals(vocab.getPronunciation(), dto.getPronunciation());
    }
    
    @Test
    void toDTO_WithNullEntity_ShouldReturnNull() {
        // When
        VocabDTO dto = vocabMapper.toDTO(null);
        
        // Then
        assertNull(dto);
    }
    
    @Test
    void toEntity_WithValidDTO_ShouldMapAllFields() {
        // Given
        VocabDTO dto = new VocabDTO();
        dto.setWord("test");
        dto.setMeaning("nghĩa test");
        
        // When
        Vocab entity = vocabMapper.toEntity(dto);
        
        // Then
        assertNotNull(entity);
        assertEquals(dto.getWord(), entity.getWord());
        assertEquals(dto.getMeaning(), entity.getMeaning());
    }
}
```

### 5. Utility Tests (Java)

#### Pattern cho Utility Tests
```java
class VocabStatusCalculatorTest {
    
    @Test
    void calculateStatus_WithHighAccuracy_ShouldReturnMastered() {
        // Given
        UserVocabProgress progress = new UserVocabProgress();
        progress.setCorrectCount(10);
        progress.setIncorrectCount(1);
        progress.setReviewCount(11);
        
        // When
        VocabStatus status = VocabStatusCalculator.calculateStatus(progress);
        
        // Then
        assertEquals(VocabStatus.MASTERED, status);
    }
    
    @Test
    void calculateStatus_WithLowAccuracy_ShouldReturnLearning() {
        // Given
        UserVocabProgress progress = new UserVocabProgress();
        progress.setCorrectCount(3);
        progress.setIncorrectCount(7);
        progress.setReviewCount(10);
        
        // When
        VocabStatus status = VocabStatusCalculator.calculateStatus(progress);
        
        // Then
        assertEquals(VocabStatus.LEARNING, status);
    }
    
    @ParameterizedTest
    @CsvSource({
        "10, 0, 10, MASTERED",
        "7, 3, 10, FAMILIAR",
        "5, 5, 10, LEARNING",
        "2, 8, 10, DIFFICULT"
    })
    void calculateStatus_WithVariousInputs_ShouldReturnCorrectStatus(
        int correct, int incorrect, int total, VocabStatus expected
    ) {
        // Given
        UserVocabProgress progress = new UserVocabProgress();
        progress.setCorrectCount(correct);
        progress.setIncorrectCount(incorrect);
        progress.setReviewCount(total);
        
        // When
        VocabStatus status = VocabStatusCalculator.calculateStatus(progress);
        
        // Then
        assertEquals(expected, status);
    }
}
```

### 6. Python Test Configuration

#### conftest.py
```python
import pytest
from unittest.mock import Mock, MagicMock
from app.core.ml.xgboost_model import XGBoostModel
from app.core.services.smart_review_service import SmartReviewService

@pytest.fixture
def mock_xgboost_model():
    """Mock XGBoost model for testing"""
    model = Mock(spec=XGBoostModel)
    model.predict.return_value = [0.8, 0.6, 0.9]
    return model

@pytest.fixture
def mock_database_service():
    """Mock database service for testing"""
    db_service = MagicMock()
    return db_service

@pytest.fixture
def sample_vocab_data():
    """Sample vocabulary data for testing"""
    return {
        'vocab_id': 'test-vocab-id',
        'word': 'test',
        'meaning': 'nghĩa test',
        'pronunciation': '/test/'
    }

@pytest.fixture
def sample_features():
    """Sample ML features for testing"""
    return {
        'correct_count': 5,
        'incorrect_count': 2,
        'review_count': 7,
        'days_since_last_review': 3,
        'avg_response_time': 2.5
    }
```

### 7. Python ML Tests

#### test_xgboost_model.py
```python
import pytest
import numpy as np
from app.core.ml.xgboost_model import XGBoostModel

class TestXGBoostModel:
    
    def test_load_model_success(self, tmp_path):
        """Test model loading successfully"""
        # Given
        model_path = tmp_path / "test_model.pkl"
        # Create a dummy model file
        
        # When
        model = XGBoostModel(model_path=str(model_path))
        
        # Then
        assert model is not None
        assert model.model is not None
    
    def test_predict_with_valid_features(self, mock_xgboost_model):
        """Test prediction with valid features"""
        # Given
        features = np.array([[5, 2, 7, 3, 2.5]])
        
        # When
        predictions = mock_xgboost_model.predict(features)
        
        # Then
        assert predictions is not None
        assert len(predictions) == 3
        assert all(0 <= p <= 1 for p in predictions)
    
    def test_predict_with_invalid_features_raises_error(self):
        """Test prediction with invalid features raises error"""
        # Given
        model = XGBoostModel()
        invalid_features = "invalid"
        
        # When & Then
        with pytest.raises(ValueError):
            model.predict(invalid_features)
```

#### test_feature_extractor.py
```python
import pytest
from app.core.ml.feature_extractor import FeatureExtractor

class TestFeatureExtractor:
    
    def test_extract_features_from_progress(self, sample_vocab_data):
        """Test feature extraction from vocab progress"""
        # Given
        progress_data = {
            'correct_count': 5,
            'incorrect_count': 2,
            'review_count': 7,
            'last_review_date': '2024-01-01'
        }
        
        # When
        features = FeatureExtractor.extract_features(progress_data)
        
        # Then
        assert features is not None
        assert 'correct_count' in features
        assert 'incorrect_count' in features
        assert 'accuracy' in features
        assert features['accuracy'] == pytest.approx(5/7, 0.01)
    
    def test_extract_features_with_missing_data(self):
        """Test feature extraction with missing data"""
        # Given
        incomplete_data = {'correct_count': 5}
        
        # When
        features = FeatureExtractor.extract_features(incomplete_data)
        
        # Then
        assert features is not None
        assert 'incorrect_count' in features
        assert features['incorrect_count'] == 0  # Default value
```

### 8. Python Service Tests

#### test_smart_review_service.py
```python
import pytest
from unittest.mock import Mock, patch
from app.core.services.smart_review_service import SmartReviewService

class TestSmartReviewService:
    
    @pytest.fixture
    def service(self, mock_xgboost_model, mock_database_service):
        """Create service instance with mocked dependencies"""
        return SmartReviewService(
            model=mock_xgboost_model,
            db_service=mock_database_service
        )
    
    def test_get_review_recommendations_success(
        self, service, sample_vocab_data
    ):
        """Test getting review recommendations successfully"""
        # Given
        user_id = "test-user-id"
        service.db_service.get_user_progress.return_value = [
            sample_vocab_data
        ]
        
        # When
        recommendations = service.get_review_recommendations(user_id)
        
        # Then
        assert recommendations is not None
        assert len(recommendations) > 0
        assert 'vocab_id' in recommendations[0]
        assert 'priority_score' in recommendations[0]
    
    def test_get_review_recommendations_with_no_progress(self, service):
        """Test getting recommendations when user has no progress"""
        # Given
        user_id = "new-user-id"
        service.db_service.get_user_progress.return_value = []
        
        # When
        recommendations = service.get_review_recommendations(user_id)
        
        # Then
        assert recommendations == []
    
    def test_calculate_priority_score(self, service):
        """Test priority score calculation"""
        # Given
        vocab_data = {
            'correct_count': 5,
            'incorrect_count': 5,
            'days_since_last_review': 7
        }
        
        # When
        score = service.calculate_priority_score(vocab_data)
        
        # Then
        assert score is not None
        assert 0 <= score <= 1
```

### 9. Python API Tests

#### test_prediction_endpoints.py
```python
import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

class TestPredictionEndpoints:
    
    def test_predict_endpoint_success(self, sample_features):
        """Test prediction endpoint with valid data"""
        # Given
        request_data = {
            'user_id': 'test-user',
            'features': sample_features
        }
        
        # When
        response = client.post('/api/v1/predict', json=request_data)
        
        # Then
        assert response.status_code == 200
        data = response.json()
        assert 'predictions' in data
        assert 'vocab_ids' in data
    
    def test_predict_endpoint_with_invalid_data(self):
        """Test prediction endpoint with invalid data"""
        # Given
        invalid_data = {'invalid': 'data'}
        
        # When
        response = client.post('/api/v1/predict', json=invalid_data)
        
        # Then
        assert response.status_code == 422  # Validation error
    
    def test_predict_endpoint_requires_auth(self):
        """Test prediction endpoint requires authentication"""
        # When
        response = client.post('/api/v1/predict', json={})
        
        # Then
        assert response.status_code in [401, 403]
```

## Data Models

### Test Data Models

#### Java Test Fixtures
- **UserFixtures**: Tạo test users với các roles khác nhau
- **VocabFixtures**: Tạo test vocabulary với đầy đủ fields
- **GameFixtures**: Tạo test game sessions và details
- **TopicFixtures**: Tạo test topics với vocabs

#### Python Test Fixtures
- **vocab_fixtures**: Sample vocabulary data
- **feature_fixtures**: Sample ML features
- **progress_fixtures**: Sample user progress data

## Error Handling

### Java Test Error Scenarios
1. **Repository Exceptions**: Test khi database throw exception
2. **Validation Errors**: Test khi input không hợp lệ
3. **Business Logic Errors**: Test khi business rules bị vi phạm
4. **External Service Failures**: Test khi external services fail

### Python Test Error Scenarios
1. **Model Loading Errors**: Test khi model file không tồn tại
2. **Prediction Errors**: Test khi features không hợp lệ
3. **Database Errors**: Test khi database connection fail
4. **API Validation Errors**: Test khi request data không đúng format

## Testing Strategy

### Unit Test Coverage Goals
- **Use Cases/Services**: >= 80% coverage
- **Mappers**: >= 90% coverage
- **Utilities/Helpers**: >= 95% coverage
- **ML Models**: >= 75% coverage
- **API Endpoints**: >= 80% coverage

### Test Execution Strategy
1. **Local Development**: Chạy tests trước khi commit
2. **Pre-commit Hook**: Tự động chạy tests khi commit
3. **CI Pipeline**: Chạy full test suite khi push
4. **Nightly Builds**: Chạy extended tests và performance tests

### Mocking Strategy
- **Repositories**: Always mock để tránh database access
- **External Services**: Always mock (Email, Firebase, Redis)
- **Security**: Disable hoặc mock cho tests
- **Time**: Mock Clock/LocalDateTime cho time-dependent tests

### Test Data Management
- **In-memory Database**: Sử dụng H2 cho Java integration tests
- **Fixtures**: Tạo reusable test data fixtures
- **Cleanup**: Mỗi test phải cleanup data sau khi chạy
- **Isolation**: Tests không được share state

## Performance Considerations

### Test Execution Performance
- **Parallel Execution**: Chạy tests parallel khi có thể
- **Fast Mocks**: Sử dụng mocks thay vì real objects
- **Minimal Setup**: Chỉ setup những gì cần thiết cho mỗi test
- **Lazy Loading**: Load test data on-demand

### CI/CD Performance
- **Caching**: Cache dependencies (Maven, pip)
- **Incremental Testing**: Chỉ chạy tests cho code thay đổi
- **Test Sharding**: Chia tests thành nhiều jobs parallel

## Tools and Frameworks

### Java Testing Stack
- **JUnit 5**: Test framework
- **Mockito**: Mocking framework
- **AssertJ**: Fluent assertions
- **H2 Database**: In-memory database
- **Spring Boot Test**: Test utilities
- **JaCoCo**: Code coverage

### Python Testing Stack
- **Pytest**: Test framework
- **pytest-mock**: Mocking utilities
- **pytest-cov**: Code coverage
- **FastAPI TestClient**: API testing
- **Faker**: Test data generation

### CI/CD Tools
- **GitHub Actions** hoặc **GitLab CI**: CI/CD pipeline
- **SonarQube**: Code quality và coverage tracking
- **Codecov**: Coverage reporting

## Documentation

### Test Documentation Requirements
1. **README.md**: Hướng dẫn chạy tests
2. **Test Naming**: Clear, descriptive test names
3. **Comments**: Giải thích complex test logic
4. **Coverage Reports**: Generate và publish coverage reports
5. **Test Reports**: Generate HTML test reports

### Test Naming Conventions

#### Java
```
methodName_StateUnderTest_ExpectedBehavior
Example: login_WithValidCredentials_ShouldReturnToken
```

#### Python
```
test_method_name_state_under_test_expected_behavior
Example: test_predict_with_valid_features_returns_predictions
```
