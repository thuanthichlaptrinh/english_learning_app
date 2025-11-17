# Đề xuất: Microservice Python AI - Smart Vocabulary Review với K-means

## 1. Tổng quan

### 1.1. Mục tiêu
Xây dựng microservice Python độc lập để cung cấp API ôn tập từ vựng thông minh sử dụng K-means clustering, tách biệt khỏi backend Java Spring Boot chính.

### 1.2. Kiến trúc Tổng thể

```
┌─────────────────────────────────────────────────────────────┐
│                    Client (Mobile/Web)                       │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              API Gateway / Load Balancer                     │
└────────┬────────────────────────────────────┬───────────────┘
         │                                    │
         ▼                                    ▼
┌────────────────────┐              ┌────────────────────────┐
│  Spring Boot API   │◄────────────►│  Python AI Service     │
│  (card-words)      │   REST API   │  (card-words-ai)       │
│                    │              │                        │
│  - Authentication  │              │  - K-means Clustering  │
│  - Business Logic  │              │  - Feature Extraction  │
│  - Game Services   │              │  - ML Models           │
└────────┬───────────┘              └───────────┬────────────┘
         │                                      │
         ▼                                      ▼
┌────────────────────┐              ┌────────────────────────┐
│   PostgreSQL       │              │   PostgreSQL           │
│   (Main DB)        │◄────────────►│   (Read Replica)       │
└────────────────────┘              └────────────────────────┘
```

### 1.3. Lý do chọn Python
- **Scikit-learn**: Thư viện ML mạnh mẽ, tối ưu cho K-means
- **NumPy/Pandas**: Xử lý dữ liệu nhanh và hiệu quả
- **FastAPI**: Framework hiện đại, async, performance cao
- **Dễ mở rộng**: Có thể thêm các ML models khác sau này

## 2. Tech Stack

### 2.1. Core Framework

- **FastAPI** 0.104+: Web framework
- **Uvicorn**: ASGI server
- **Python** 3.11+

### 2.2. Machine Learning
- **scikit-learn** 1.3+: K-means clustering
- **NumPy** 1.24+: Numerical computing
- **Pandas** 2.0+: Data manipulation

### 2.3. Database
- **SQLAlchemy** 2.0+: ORM
- **asyncpg**: Async PostgreSQL driver
- **Alembic**: Database migrations

### 2.4. Caching & Performance
- **Redis**: Caching clustering results
- **redis-py**: Redis client

### 2.5. Monitoring & Logging
- **Prometheus**: Metrics
- **Structlog**: Structured logging

### 2.6. Development
- **Poetry**: Dependency management
- **Pytest**: Testing
- **Black**: Code formatting
- **Ruff**: Linting

## 3. Cấu trúc Project

```
card-words-ai/
├── app/
│   ├── __init__.py
│   ├── main.py                      # FastAPI application
│   ├── config.py                    # Configuration
│   ├── dependencies.py              # Dependency injection
│   │
│   ├── api/
│   │   ├── __init__.py
│   │   ├── v1/
│   │   │   ├── __init__.py
│   │   │   ├── router.py
│   │   │   └── endpoints/
│   │   │       ├── __init__.py
│   │   │       ├── clustering.py    # Clustering endpoints
│   │   │       ├── review.py        # Smart review endpoints
│   │   │       └── health.py        # Health check
│   │
│   ├── core/
│   │   ├── __init__.py
│   │   ├── ml/
│   │   │   ├── __init__.py
│   │   │   ├── kmeans_clusterer.py  # K-means implementation
│   │   │   ├── feature_extractor.py # Feature engineering
│   │   │   └── cluster_analyzer.py  # Cluster analysis
│   │   │
│   │   ├── services/
│   │   │   ├── __init__.py
│   │   │   ├── clustering_service.py
│   │   │   ├── review_service.py
│   │   │   └── cache_service.py
│   │   │
│   │   └── utils/
│   │       ├── __init__.py
│   │       ├── logger.py
│   │       └── metrics.py
│   │
│   ├── models/
│   │   ├── __init__.py
│   │   ├── database.py              # SQLAlchemy models
│   │   └── schemas.py               # Pydantic schemas
│   │
│   ├── db/
│   │   ├── __init__.py
│   │   ├── session.py               # Database session
│   │   └── repositories/
│   │       ├── __init__.py
│   │       ├── vocab_progress_repo.py
│   │       └── cluster_repo.py
│   │
│   └── middleware/
│       ├── __init__.py
│       ├── auth.py                  # JWT validation
│       └── error_handler.py
│
├── tests/
│   ├── __init__.py
│   ├── conftest.py
│   ├── unit/
│   │   ├── test_kmeans.py
│   │   └── test_feature_extractor.py
│   └── integration/
│       └── test_api.py
│
├── alembic/
│   ├── versions/
│   └── env.py
│
├── docs/
│   ├── api.md
│   └── kmeans-smart-review-api-proposal.md
│
├── scripts/
│   ├── init_db.py
│   └── seed_data.py
│
├── .env.example
├── .gitignore
├── Dockerfile
├── docker-compose.yml
├── pyproject.toml
├── poetry.lock
└── README.md
```

## 4. Feature Engineering (Chi tiết)

### 4.1. VocabFeatures Class

```python
from dataclasses import dataclass
from datetime import date
import numpy as np

@dataclass
class VocabFeatures:
    """Feature vector for vocabulary clustering"""
    vocab_id: str
    user_id: str
    
    # Raw features
    times_correct: int
    times_wrong: int
    last_reviewed: date
    repetition: int
    ef_factor: float
    interval_days: int
    status: str  # NEW, UNKNOWN, KNOWN
    cefr_level: str  # A1, A2, B1, B2, C1, C2
    
    def to_vector(self) -> np.ndarray:
        """Convert to normalized feature vector"""
        return np.array([
            self._mastery_score(),
            self._recency_score(),
            self._difficulty_score(),
            self._repetition_score(),
            self._status_priority()
        ])
    
    def _mastery_score(self) -> float:
        """Calculate mastery score (0-1)"""
        total = self.times_correct + self.times_wrong
        if total == 0:
            return 0.0
        return self.times_correct / total
    
    def _recency_score(self) -> float:
        """Calculate recency score (0-1)"""
        if self.last_reviewed is None:
            return 0.0
        days_since = (date.today() - self.last_reviewed).days
        # Decay: 100% at day 0, 0% at day 20+
        return max(0.0, 1.0 - (days_since / 20.0))
    
    def _difficulty_score(self) -> float:
        """Map CEFR level to difficulty (0-1)"""
        mapping = {
            'A1': 0.2, 'A2': 0.35,
            'B1': 0.5, 'B2': 0.65,
            'C1': 0.8, 'C2': 0.95
        }
        return mapping.get(self.cefr_level, 0.5)
    
    def _repetition_score(self) -> float:
        """Calculate repetition score (0-1)"""
        return min(1.0, self.repetition / 10.0)
    
    def _status_priority(self) -> float:
        """Map status to priority (0-1)"""
        mapping = {
            'UNKNOWN': 1.0,
            'NEW': 0.7,
            'KNOWN': 0.4
        }
        return mapping.get(self.status, 0.5)
```


### 4.2. KMeansClusterer Implementation

```python
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
import numpy as np
from typing import List, Dict

class KMeansClusterer:
    """K-means clustering for vocabulary review"""
    
    def __init__(self, n_clusters: int = 4, random_state: int = 42):
        self.n_clusters = n_clusters
        self.kmeans = KMeans(
            n_clusters=n_clusters,
            init='k-means++',
            n_init=10,
            max_iter=300,
            random_state=random_state
        )
        self.scaler = StandardScaler()
        self.cluster_names = {
            0: "Cần Ôn Gấp",
            1: "Cần Củng Cố", 
            2: "Ôn Tập Định Kỳ",
            3: "Gần Thành Thạo"
        }
    
    def fit_predict(self, features: List[VocabFeatures]) -> Dict:
        """
        Cluster vocabularies and return results
        
        Returns:
            {
                'vocab_id': cluster_id,
                'cluster_centers': array,
                'labels': array,
                'stats': {...}
            }
        """
        if len(features) < self.n_clusters:
            raise ValueError(f"Need at least {self.n_clusters} vocabs")
        
        # Extract feature vectors
        X = np.array([f.to_vector() for f in features])
        
        # Normalize features
        X_scaled = self.scaler.fit_transform(X)
        
        # Fit K-means
        labels = self.kmeans.fit_predict(X_scaled)
        
        # Map vocab_id to cluster
        vocab_clusters = {
            features[i].vocab_id: int(labels[i])
            for i in range(len(features))
        }
        
        # Calculate statistics
        stats = self._calculate_stats(features, labels)
        
        return {
            'vocab_clusters': vocab_clusters,
            'cluster_centers': self.kmeans.cluster_centers_,
            'labels': labels,
            'stats': stats
        }
    
    def _calculate_stats(self, features: List[VocabFeatures], 
                        labels: np.ndarray) -> Dict:
        """Calculate cluster statistics"""
        stats = {}
        
        for cluster_id in range(self.n_clusters):
            mask = labels == cluster_id
            cluster_features = [f for i, f in enumerate(features) if mask[i]]
            
            if not cluster_features:
                continue
            
            avg_mastery = np.mean([
                f._mastery_score() for f in cluster_features
            ])
            
            stats[cluster_id] = {
                'name': self.cluster_names[cluster_id],
                'count': len(cluster_features),
                'avg_mastery': round(avg_mastery * 100, 2),
                'status_distribution': self._status_distribution(cluster_features)
            }
        
        return stats
    
    def _status_distribution(self, features: List[VocabFeatures]) -> Dict:
        """Calculate status distribution in cluster"""
        from collections import Counter
        statuses = [f.status for f in features]
        return dict(Counter(statuses))
```

## 5. API Endpoints

### 5.1. POST /api/v1/clustering/trigger

**Mô tả:** Trigger clustering cho một user

**Request:**
```json
{
  "user_id": "uuid",
  "force_refresh": false
}
```

**Response:**
```json
{
  "success": true,
  "user_id": "uuid",
  "total_vocabs": 150,
  "clusters": [
    {
      "cluster_id": 0,
      "name": "Cần Ôn Gấp",
      "count": 45,
      "avg_mastery": 35.5,
      "status_distribution": {
        "UNKNOWN": 30,
        "NEW": 10,
        "KNOWN": 5
      }
    },
    {
      "cluster_id": 1,
      "name": "Cần Củng Cố",
      "count": 50,
      "avg_mastery": 55.2,
      "status_distribution": {
        "KNOWN": 35,
        "UNKNOWN": 15
      }
    }
  ],
  "clustered_at": "2024-11-15T10:30:00Z",
  "processing_time_ms": 245
}
```

### 5.2. GET /api/v1/review/smart

**Mô tả:** Lấy danh sách từ vựng để ôn tập thông minh

**Query Parameters:**
- `user_id` (required): UUID của user
- `limit` (optional, default=20): Số lượng từ vựng
- `cluster_id` (optional): Lọc theo cluster cụ thể
- `shuffle` (optional, default=true): Trộn ngẫu nhiên trong cluster

**Response:**
```json
{
  "vocabs": [
    {
      "vocab_id": "uuid",
      "word": "abandon",
      "meaning_vi": "từ bỏ",
      "transcription": "/əˈbændən/",
      "cefr": "B2",
      "cluster": {
        "id": 0,
        "name": "Cần Ôn Gấp",
        "priority_score": 92.5
      },
      "progress": {
        "status": "UNKNOWN",
        "times_correct": 2,
        "times_wrong": 5,
        "last_reviewed": "2024-11-10",
        "days_since_review": 5
      },
      "features": {
        "mastery_score": 28.6,
        "recency_score": 75.0,
        "difficulty_score": 65.0
      }
    }
  ],
  "meta": {
    "total": 20,
    "cluster_distribution": {
      "0": 12,
      "1": 6,
      "2": 2
    },
    "last_clustered_at": "2024-11-15T10:30:00Z"
  }
}
```

### 5.3. GET /api/v1/clustering/stats

**Mô tả:** Lấy thống kê clustering của user

**Query Parameters:**
- `user_id` (required): UUID của user

**Response:**
```json
{
  "user_id": "uuid",
  "last_clustered_at": "2024-11-15T10:30:00Z",
  "total_vocabs": 150,
  "clusters": [...],
  "recommendations": {
    "next_cluster_to_review": 0,
    "suggested_vocab_count": 20,
    "estimated_time_minutes": 15,
    "priority_vocabs": ["uuid1", "uuid2", "uuid3"]
  }
}
```

### 5.4. POST /api/v1/clustering/batch

**Mô tả:** Batch clustering cho nhiều users (admin only)

**Request:**
```json
{
  "user_ids": ["uuid1", "uuid2", "uuid3"],
  "async": true
}
```

## 6. Database Schema

### 6.1. Bảng vocab_clusters (Tạo mới)

```sql
CREATE TABLE vocab_clusters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    vocab_id UUID NOT NULL,
    cluster_id INTEGER NOT NULL,
    cluster_name VARCHAR(50) NOT NULL,
    
    -- Feature scores (for debugging/analysis)
    mastery_score FLOAT NOT NULL,
    recency_score FLOAT NOT NULL,
    difficulty_score FLOAT NOT NULL,
    repetition_score FLOAT NOT NULL,
    status_priority FLOAT NOT NULL,
    
    -- Priority for sorting
    priority_score FLOAT NOT NULL,
    
    -- Metadata
    clustered_at TIMESTAMP NOT NULL DEFAULT NOW(),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    
    CONSTRAINT uk_user_vocab_cluster UNIQUE(user_id, vocab_id)
);

CREATE INDEX idx_vocab_clusters_user_id ON vocab_clusters(user_id);
CREATE INDEX idx_vocab_clusters_cluster_id ON vocab_clusters(cluster_id);
CREATE INDEX idx_vocab_clusters_priority ON vocab_clusters(user_id, priority_score DESC);
CREATE INDEX idx_vocab_clusters_user_cluster ON vocab_clusters(user_id, cluster_id);
```

### 6.2. Bảng clustering_metadata (Tạo mới)

```sql
CREATE TABLE clustering_metadata (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE,
    total_vocabs INTEGER NOT NULL,
    cluster_stats JSONB NOT NULL,
    last_clustered_at TIMESTAMP NOT NULL,
    processing_time_ms INTEGER,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_clustering_metadata_user_id ON clustering_metadata(user_id);
CREATE INDEX idx_clustering_metadata_last_clustered ON clustering_metadata(last_clustered_at DESC);
```


## 7. Tích hợp với Spring Boot Backend

### 7.1. Communication Flow

```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│   Client     │────1───►│ Spring Boot  │────2───►│  Python AI   │
│              │         │   Backend    │         │   Service    │
└──────────────┘         └──────────────┘         └──────────────┘
                                │                         │
                                │                         │
                                ▼                         ▼
                         ┌──────────────┐         ┌──────────────┐
                         │ PostgreSQL   │◄────────│ PostgreSQL   │
                         │   (Main)     │  Sync   │  (Replica)   │
                         └──────────────┘         └──────────────┘

Flow:
1. Client gọi Spring Boot API: GET /api/v1/review/smart
2. Spring Boot forward request đến Python AI Service
3. Python AI Service query data, thực hiện clustering
4. Trả kết quả về Spring Boot
5. Spring Boot enrich data (thêm images, audio URLs) và trả về Client
```

### 7.2. Spring Boot RestTemplate Configuration

```java
@Configuration
public class AIServiceConfig {
    
    @Value("${ai.service.base-url}")
    private String aiServiceBaseUrl;
    
    @Bean
    public RestTemplate aiServiceRestTemplate() {
        RestTemplate restTemplate = new RestTemplate();
        
        // Set timeouts
        HttpComponentsClientHttpRequestFactory factory = 
            new HttpComponentsClientHttpRequestFactory();
        factory.setConnectTimeout(5000);
        factory.setReadTimeout(10000);
        
        restTemplate.setRequestFactory(factory);
        return restTemplate;
    }
}
```

### 7.3. AI Service Client

```java
@Service
@Slf4j
public class AIServiceClient {
    
    private final RestTemplate restTemplate;
    private final String aiServiceBaseUrl;
    
    public AIServiceClient(
        @Qualifier("aiServiceRestTemplate") RestTemplate restTemplate,
        @Value("${ai.service.base-url}") String aiServiceBaseUrl
    ) {
        this.restTemplate = restTemplate;
        this.aiServiceBaseUrl = aiServiceBaseUrl;
    }
    
    public SmartReviewResponse getSmartReview(UUID userId, Integer limit) {
        String url = aiServiceBaseUrl + "/api/v1/review/smart" +
                    "?user_id=" + userId + "&limit=" + limit;
        
        try {
            return restTemplate.getForObject(url, SmartReviewResponse.class);
        } catch (Exception e) {
            log.error("Failed to call AI service: {}", e.getMessage());
            throw new AIServiceException("AI service unavailable", e);
        }
    }
    
    public ClusteringResponse triggerClustering(UUID userId) {
        String url = aiServiceBaseUrl + "/api/v1/clustering/trigger";
        
        ClusteringRequest request = new ClusteringRequest(userId, false);
        
        try {
            return restTemplate.postForObject(
                url, request, ClusteringResponse.class
            );
        } catch (Exception e) {
            log.error("Failed to trigger clustering: {}", e.getMessage());
            throw new AIServiceException("Clustering failed", e);
        }
    }
}
```

### 7.4. Application Properties

```yaml
# application.yml
ai:
  service:
    base-url: http://localhost:8001
    enabled: true
    timeout:
      connect: 5000
      read: 10000
```

## 8. Caching Strategy

### 8.1. Redis Cache Structure

```python
# Cache keys
CLUSTER_CACHE_KEY = "cluster:{user_id}"
REVIEW_CACHE_KEY = "review:{user_id}:{cluster_id}"
STATS_CACHE_KEY = "stats:{user_id}"

# TTL
CLUSTER_TTL = 3600  # 1 hour
REVIEW_TTL = 300    # 5 minutes
STATS_TTL = 600     # 10 minutes
```

### 8.2. Cache Service Implementation

```python
import redis.asyncio as redis
import json
from typing import Optional, Dict, Any

class CacheService:
    def __init__(self, redis_url: str):
        self.redis = redis.from_url(redis_url)
    
    async def get_clusters(self, user_id: str) -> Optional[Dict]:
        """Get cached clustering results"""
        key = f"cluster:{user_id}"
        data = await self.redis.get(key)
        return json.loads(data) if data else None
    
    async def set_clusters(self, user_id: str, data: Dict, ttl: int = 3600):
        """Cache clustering results"""
        key = f"cluster:{user_id}"
        await self.redis.setex(key, ttl, json.dumps(data))
    
    async def invalidate_user_cache(self, user_id: str):
        """Invalidate all cache for a user"""
        pattern = f"*:{user_id}*"
        keys = await self.redis.keys(pattern)
        if keys:
            await self.redis.delete(*keys)
```

## 9. Authentication & Security

### 9.1. JWT Validation Middleware

```python
from fastapi import HTTPException, Security
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import jwt
from datetime import datetime

security = HTTPBearer()

async def verify_token(
    credentials: HTTPAuthorizationCredentials = Security(security)
) -> dict:
    """Verify JWT token from Spring Boot"""
    token = credentials.credentials
    
    try:
        # Decode JWT (shared secret with Spring Boot)
        payload = jwt.decode(
            token,
            settings.JWT_SECRET,
            algorithms=["HS256"]
        )
        
        # Check expiration
        if datetime.fromtimestamp(payload['exp']) < datetime.now():
            raise HTTPException(status_code=401, detail="Token expired")
        
        return payload
    
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Invalid token")
```

### 9.2. API Key for Internal Services

```python
from fastapi import Header, HTTPException

async def verify_api_key(x_api_key: str = Header(...)):
    """Verify API key for internal service calls"""
    if x_api_key != settings.INTERNAL_API_KEY:
        raise HTTPException(status_code=403, detail="Invalid API key")
    return True
```

## 10. Deployment

### 10.1. Dockerfile

```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install poetry==1.7.0

# Copy dependency files
COPY pyproject.toml poetry.lock ./

# Install dependencies
RUN poetry config virtualenvs.create false \
    && poetry install --no-dev --no-interaction --no-ansi

# Copy application
COPY . .

# Expose port
EXPOSE 8001

# Run application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8001"]
```

### 10.2. docker-compose.yml

```yaml
version: '3.8'

services:
  ai-service:
    build: .
    container_name: card-words-ai
    ports:
      - "8001:8001"
    environment:
      - DATABASE_URL=postgresql://user:pass@postgres:5432/cardwords
      - REDIS_URL=redis://redis:6379/0
      - JWT_SECRET=${JWT_SECRET}
      - LOG_LEVEL=INFO
    depends_on:
      - postgres
      - redis
    networks:
      - card-words-network
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    container_name: card-words-redis
    ports:
      - "6379:6379"
    networks:
      - card-words-network
    restart: unless-stopped

networks:
  card-words-network:
    external: true
```

### 10.3. Environment Variables

```bash
# .env
DATABASE_URL=postgresql://user:pass@localhost:5432/cardwords
REDIS_URL=redis://localhost:6379/0
JWT_SECRET=your-secret-key-shared-with-spring-boot
INTERNAL_API_KEY=your-internal-api-key
LOG_LEVEL=INFO
ENVIRONMENT=production

# K-means settings
KMEANS_N_CLUSTERS=4
KMEANS_RANDOM_STATE=42

# Cache settings
CACHE_CLUSTER_TTL=3600
CACHE_REVIEW_TTL=300
```

## 11. Monitoring & Logging

### 11.1. Prometheus Metrics

```python
from prometheus_client import Counter, Histogram, Gauge

# Metrics
clustering_requests = Counter(
    'clustering_requests_total',
    'Total clustering requests',
    ['user_id', 'status']
)

clustering_duration = Histogram(
    'clustering_duration_seconds',
    'Time spent clustering',
    buckets=[0.1, 0.5, 1.0, 2.0, 5.0]
)

active_users = Gauge(
    'active_users_total',
    'Number of users with recent clustering'
)

review_requests = Counter(
    'review_requests_total',
    'Total smart review requests',
    ['cluster_id']
)
```

### 11.2. Structured Logging

```python
import structlog

logger = structlog.get_logger()

# Usage
logger.info(
    "clustering_completed",
    user_id=user_id,
    total_vocabs=150,
    processing_time_ms=245,
    clusters=4
)
```


## 12. Testing Strategy

### 12.1. Unit Tests

```python
# tests/unit/test_feature_extractor.py
import pytest
from datetime import date, timedelta
from app.core.ml.feature_extractor import VocabFeatures

def test_mastery_score_calculation():
    features = VocabFeatures(
        vocab_id="test-id",
        user_id="user-id",
        times_correct=8,
        times_wrong=2,
        last_reviewed=date.today(),
        repetition=3,
        ef_factor=2.5,
        interval_days=6,
        status="KNOWN",
        cefr_level="B1"
    )
    
    assert features._mastery_score() == 0.8

def test_recency_score_today():
    features = VocabFeatures(
        vocab_id="test-id",
        user_id="user-id",
        times_correct=5,
        times_wrong=1,
        last_reviewed=date.today(),
        repetition=2,
        ef_factor=2.5,
        interval_days=3,
        status="KNOWN",
        cefr_level="A2"
    )
    
    assert features._recency_score() == 1.0

def test_recency_score_old():
    features = VocabFeatures(
        vocab_id="test-id",
        user_id="user-id",
        times_correct=5,
        times_wrong=1,
        last_reviewed=date.today() - timedelta(days=20),
        repetition=2,
        ef_factor=2.5,
        interval_days=3,
        status="KNOWN",
        cefr_level="A2"
    )
    
    assert features._recency_score() == 0.0
```

### 12.2. Integration Tests

```python
# tests/integration/test_api.py
import pytest
from httpx import AsyncClient
from app.main import app

@pytest.mark.asyncio
async def test_trigger_clustering():
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.post(
            "/api/v1/clustering/trigger",
            json={"user_id": "test-user-id", "force_refresh": False},
            headers={"X-API-Key": "test-key"}
        )
        
        assert response.status_code == 200
        data = response.json()
        assert "clusters" in data
        assert len(data["clusters"]) == 4

@pytest.mark.asyncio
async def test_get_smart_review():
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get(
            "/api/v1/review/smart",
            params={"user_id": "test-user-id", "limit": 10},
            headers={"Authorization": "Bearer test-token"}
        )
        
        assert response.status_code == 200
        data = response.json()
        assert "vocabs" in data
        assert len(data["vocabs"]) <= 10
```

## 13. Performance Optimization

### 13.1. Database Query Optimization

```python
# Use async queries with connection pooling
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker

engine = create_async_engine(
    DATABASE_URL,
    pool_size=20,
    max_overflow=10,
    pool_pre_ping=True
)

async_session = sessionmaker(
    engine, class_=AsyncSession, expire_on_commit=False
)

# Batch loading with eager loading
async def get_user_vocab_progress(user_id: str):
    async with async_session() as session:
        result = await session.execute(
            select(UserVocabProgress)
            .options(joinedload(UserVocabProgress.vocab))
            .filter(UserVocabProgress.user_id == user_id)
            .filter(UserVocabProgress.status.in_(['NEW', 'UNKNOWN', 'KNOWN']))
        )
        return result.scalars().all()
```

### 13.2. Parallel Processing

```python
import asyncio
from concurrent.futures import ProcessPoolExecutor

async def batch_clustering(user_ids: List[str]):
    """Process multiple users in parallel"""
    with ProcessPoolExecutor(max_workers=4) as executor:
        loop = asyncio.get_event_loop()
        tasks = [
            loop.run_in_executor(executor, cluster_user, user_id)
            for user_id in user_ids
        ]
        results = await asyncio.gather(*tasks)
    return results
```

### 13.3. Response Compression

```python
from fastapi.middleware.gzip import GZipMiddleware

app.add_middleware(GZipMiddleware, minimum_size=1000)
```

## 14. Roadmap Triển khai

### Phase 1: Setup & Core (Tuần 1-2)
- [ ] Setup project structure với Poetry
- [ ] Cấu hình FastAPI, SQLAlchemy, Redis
- [ ] Implement VocabFeatures và FeatureExtractor
- [ ] Implement KMeansClusterer
- [ ] Unit tests cho ML components
- [ ] Database migrations

### Phase 2: API Development (Tuần 3)
- [ ] Implement clustering endpoints
- [ ] Implement smart review endpoints
- [ ] JWT authentication middleware
- [ ] API documentation với OpenAPI
- [ ] Integration tests

### Phase 3: Integration (Tuần 4)
- [ ] Tích hợp với Spring Boot backend
- [ ] Setup Redis caching
- [ ] Implement monitoring với Prometheus
- [ ] Load testing
- [ ] Bug fixes

### Phase 4: Deployment (Tuần 5)
- [ ] Docker containerization
- [ ] CI/CD pipeline
- [ ] Production deployment
- [ ] Monitoring dashboard
- [ ] Documentation

### Phase 5: Optimization (Tuần 6+)
- [ ] Performance tuning
- [ ] A/B testing
- [ ] Advanced features (adaptive K, personalized weights)
- [ ] Analytics dashboard

## 15. Ưu điểm của Kiến trúc Microservice

### 15.1. Separation of Concerns
- Backend Java tập trung vào business logic
- Python service chuyên về ML/AI
- Dễ maintain và scale độc lập

### 15.2. Technology Flexibility
- Sử dụng công cụ tốt nhất cho từng task
- Python ecosystem mạnh về ML
- Java ecosystem mạnh về enterprise

### 15.3. Scalability
- Scale Python service độc lập khi cần
- Không ảnh hưởng đến main backend
- Có thể deploy trên GPU instances nếu cần

### 15.4. Development Speed
- Team có thể làm việc song song
- Deploy độc lập, không cần restart main app
- Dễ dàng rollback nếu có vấn đề

## 16. Nhược điểm và Giải pháp

### 16.1. Network Latency
**Vấn đề:** Thêm network hop giữa services

**Giải pháp:**
- Aggressive caching với Redis
- Deploy cùng VPC/network
- HTTP/2 connection pooling

### 16.2. Complexity
**Vấn đề:** Thêm một service cần maintain

**Giải pháp:**
- Comprehensive monitoring
- Good documentation
- Automated deployment

### 16.3. Data Consistency
**Vấn đề:** Sync data giữa services

**Giải pháp:**
- Read from PostgreSQL replica
- Event-driven updates (optional)
- Periodic sync jobs

## 17. Alternative: Embedded Python

Nếu không muốn microservice, có thể embed Python trong Java:

### 17.1. Jython (Không khuyến nghị)
- Chỉ support Python 2.7
- Không có NumPy, scikit-learn

### 17.2. GraalVM Python (Khả thi)
- Support Python 3.8+
- Có thể chạy scikit-learn
- Performance tốt

### 17.3. Py4J / JPype
- Call Python từ Java
- Phức tạp hơn microservice
- Khó debug

**Kết luận:** Microservice approach vẫn tốt nhất cho dự án này.

## 18. Cost Estimation

### 18.1. Development Time
- Phase 1-2: 2 tuần (Core + API)
- Phase 3-4: 2 tuần (Integration + Deployment)
- Phase 5: Ongoing (Optimization)
- **Total MVP: 4 tuần**

### 18.2. Infrastructure Cost (Monthly)
- Python service: $20-50 (1-2 vCPU, 2-4GB RAM)
- Redis: $10-20 (256MB-1GB)
- Database replica: $0 (sử dụng chung)
- **Total: $30-70/month**

### 18.3. Maintenance
- Monitoring: 2-4 giờ/tuần
- Updates: 4-8 giờ/tháng
- Bug fixes: As needed

## 19. Success Metrics

### 19.1. Technical Metrics
- API response time < 200ms (p95)
- Clustering time < 1s for 500 vocabs
- Cache hit rate > 80%
- Uptime > 99.5%

### 19.2. Business Metrics
- User engagement tăng 20%
- Review completion rate tăng 15%
- Time to mastery giảm 10%
- User satisfaction score > 4.5/5

## 20. Tài liệu Tham khảo

### 20.1. Machine Learning
- Scikit-learn K-means: https://scikit-learn.org/stable/modules/clustering.html#k-means
- Feature Engineering: https://www.kaggle.com/learn/feature-engineering

### 20.2. FastAPI
- Documentation: https://fastapi.tiangolo.com/
- Best Practices: https://github.com/zhanymkanov/fastapi-best-practices

### 20.3. Microservices
- Microservice Patterns: https://microservices.io/patterns/
- API Gateway Pattern: https://microservices.io/patterns/apigateway.html

### 20.4. Python Async
- AsyncIO: https://docs.python.org/3/library/asyncio.html
- SQLAlchemy Async: https://docs.sqlalchemy.org/en/20/orm/extensions/asyncio.html

## 21. Next Steps

1. **Review & Approval**
   - Review tài liệu này với team
   - Quyết định có triển khai hay không
   - Xác định timeline

2. **Setup Development Environment**
   - Clone repository
   - Setup Python 3.11+
   - Install Poetry
   - Setup PostgreSQL & Redis locally

3. **Start Phase 1**
   - Tạo project structure
   - Implement core ML components
   - Write unit tests

4. **Iterate & Improve**
   - Gather feedback
   - Optimize performance
   - Add features

---

**Tác giả:** AI Assistant  
**Ngày tạo:** 2024-11-15  
**Phiên bản:** 1.0  
**Status:** Proposal - Chờ review
