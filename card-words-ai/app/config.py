"""
Configuration settings for Card Words AI Service
"""
from pydantic_settings import BaseSettings
from typing import Optional
import os
from pathlib import Path


class Settings(BaseSettings):
    """Application settings loaded from environment variables"""
    
    # Database - Build từ components hoặc dùng DATABASE_URL trực tiếp
    POSTGRES_USER: str = "postgres"
    POSTGRES_PASSWORD: str = "123456"
    POSTGRES_HOST: str = "postgres"
    POSTGRES_PORT: str = "5432"
    POSTGRES_DB: str = "card_words"
    DATABASE_URL: Optional[str] = None
    
    # Redis - Build từ components hoặc dùng REDIS_URL trực tiếp
    REDIS_HOST: str = "redis"
    REDIS_PORT: str = "6379"
    REDIS_AI_DB: str = "1"
    REDIS_URL: Optional[str] = None
    
    # JWT (shared với Spring Boot)
    JWT_SECRET: str = "your-secret-key"
    JWT_ALGORITHM: str = "HS256"
    
    # Model - XGBoost
    MODEL_PATH: str = "/app/models/xgboost_model_v1.pkl"
    SCALER_PATH: str = "/app/models/scaler_v1.pkl"
    MODEL_VERSION: str = "v1.0.0"
    
    # Model - Random Forest
    RF_MODEL_PATH: str = "/app/models/random_forest_model_v1.pkl"
    RF_SCALER_PATH: str = "/app/models/rf_scaler_v1.pkl"
    RF_MODEL_VERSION: str = "v1.0.0"
    
    # Active model type: "xgboost" or "random_forest"
    ACTIVE_MODEL_TYPE: str = "xgboost"
    
    # API
    API_HOST: str = "0.0.0.0"
    API_PORT: int = 8001
    
    # Admin
    ADMIN_API_KEY: str = "your-admin-api-key"
    INTERNAL_API_KEY: str = "your-internal-api-key"
    
    # Logging
    LOG_LEVEL: str = "INFO"
    
    # Cache
    CACHE_TTL: int = 300  # 5 minutes
    
    # Rate Limiting
    RATE_LIMIT_PER_MINUTE: int = 60
    
    # Performance
    MAX_CONCURRENT_REQUESTS: int = 50
    INFERENCE_WARNING_THRESHOLD_MS: int = 2000
    
    class Config:
        # Tìm file .env ở thư mục parent (root của monorepo)
        env_file = str(Path(__file__).parent.parent.parent.parent / ".env")
        case_sensitive = True
        extra = "allow"  # Allow extra fields từ .env
    
    @property
    def get_database_url(self) -> str:
        """Build database URL từ components nếu DATABASE_URL không được set"""
        if self.DATABASE_URL:
            return self.DATABASE_URL
        return f"postgresql+asyncpg://{self.POSTGRES_USER}:{self.POSTGRES_PASSWORD}@{self.POSTGRES_HOST}:{self.POSTGRES_PORT}/{self.POSTGRES_DB}"
    
    @property
    def get_redis_url(self) -> str:
        """Build Redis URL từ components nếu REDIS_URL không được set"""
        if self.REDIS_URL:
            return self.REDIS_URL
        return f"redis://{self.REDIS_HOST}:{self.REDIS_PORT}/{self.REDIS_AI_DB}"


# Global settings instance
settings = Settings()
