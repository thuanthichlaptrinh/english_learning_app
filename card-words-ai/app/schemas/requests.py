"""Request schemas"""
from pydantic import BaseModel, Field


class PredictRequest(BaseModel):
    """Request schema for prediction endpoint"""
    user_id: str = Field(..., description="User UUID")
    limit: int = Field(20, ge=1, le=100, description="Number of vocabs to return")


class RetrainRequest(BaseModel):
    """Request schema for retrain endpoint"""
    force: bool = Field(False, description="Force retrain even if recent")
    model_type: str = Field("xgboost", description="Model type to train: 'xgboost' or 'random_forest'")


class InvalidateCacheRequest(BaseModel):
    """Request schema for cache invalidation"""
    user_id: str = Field(..., description="User UUID")
