"""Response schemas"""
from typing import List, Dict, Any, Optional
from pydantic import BaseModel, Field


class VocabRecommendation(BaseModel):
    """Vocabulary recommendation schema"""
    vocab_id: str
    word: str
    meaning_vi: str
    transcription: Optional[str]
    priority_score: float = Field(..., ge=0.0, le=1.0)
    status: str
    times_correct: int
    times_wrong: int
    last_reviewed: Optional[str]
    next_review_date: Optional[str]


class PredictResponse(BaseModel):
    """Response schema for prediction endpoint"""
    user_id: str
    vocabs: List[VocabRecommendation]
    total: int
    meta: Dict[str, Any]


class RetrainResponse(BaseModel):
    """Response schema for retrain endpoint"""
    success: bool
    model_version: str
    metrics: Dict[str, float]
    training_time_seconds: float
    samples_trained: int


class ErrorResponse(BaseModel):
    """Error response schema"""
    error: str
    message: str
    details: Optional[Dict] = None
    timestamp: str


class HealthResponse(BaseModel):
    """Health check response schema"""
    status: str
    service: str
    model_loaded: bool
    database_connected: bool
    redis_connected: bool
    timestamp: str


class MetricsResponse(BaseModel):
    """Metrics response schema"""
    total_requests: int
    cache_hit_rate: float
    average_inference_time_ms: float
    model_version: str
    last_training_time: Optional[str]
