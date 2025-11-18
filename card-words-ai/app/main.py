"""
Card Words AI Service - Main Application
FastAPI application for ML-powered vocabulary review recommendations using XGBoost
"""

from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from datetime import datetime
from contextlib import asynccontextmanager
import structlog
import os

from app.config import settings
from app.db.database_service import DatabaseService
from app.core.services.cache_service import CacheService
from app.core.services.smart_review_service import SmartReviewService
from app.core.ml.xgboost_model import XGBoostVocabModel
from app.middleware.auth import verify_jwt_token, verify_admin_api_key, verify_internal_api_key
from app.schemas.requests import PredictRequest, RetrainRequest, InvalidateCacheRequest
from app.schemas.responses import (
    PredictResponse, RetrainResponse, HealthResponse, MetricsResponse, ErrorResponse
)

# Configure structured logging
structlog.configure(
    processors=[
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.add_log_level,
        structlog.processors.JSONRenderer()
    ]
)

logger = structlog.get_logger()

# Global services
db_service: DatabaseService = None
cache_service: CacheService = None
model: XGBoostVocabModel = None
smart_review_service: SmartReviewService = None


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Lifespan context manager for startup and shutdown"""
    global db_service, cache_service, model, smart_review_service
    
    # Startup
    logger.info("service_starting", version=settings.MODEL_VERSION)
    
    # Initialize services
    db_service = DatabaseService()
    cache_service = CacheService()
    
    # Initialize and load model
    model = XGBoostVocabModel(
        model_path=settings.MODEL_PATH,
        scaler_path=settings.SCALER_PATH,
        version=settings.MODEL_VERSION
    )
    
    # Try to load model if exists
    if os.path.exists(settings.MODEL_PATH):
        try:
            model.load_model()
            logger.info("model_loaded_successfully", version=settings.MODEL_VERSION)
        except Exception as e:
            logger.warning("model_load_failed", error=str(e))
    else:
        logger.warning("model_file_not_found", path=settings.MODEL_PATH)
    
    # Initialize smart review service
    smart_review_service = SmartReviewService(
        model=model,
        db_service=db_service,
        cache_service=cache_service
    )
    
    logger.info("service_started")
    
    yield
    
    # Shutdown
    logger.info("service_shutting_down")
    await db_service.close()
    await cache_service.close()
    logger.info("service_stopped")


# Create FastAPI app
app = FastAPI(
    title="Card Words AI Service",
    description="AI-powered vocabulary review recommendations using XGBoost",
    version="0.1.0",
    lifespan=lifespan
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Error handlers
@app.exception_handler(Exception)
async def global_exception_handler(request, exc: Exception):
    """Global exception handler"""
    logger.error(
        "unhandled_exception",
        path=request.url.path,
        method=request.method,
        error=str(exc),
        exc_info=True
    )
    
    return JSONResponse(
        status_code=500,
        content={
            "error": "InternalServerError",
            "message": "An unexpected error occurred",
            "timestamp": datetime.now().isoformat()
        }
    )


# Root endpoint
@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "service": "Card Words AI",
        "version": "0.1.0",
        "status": "running",
        "model_version": settings.MODEL_VERSION,
        "timestamp": datetime.now().isoformat()
    }


# Health check endpoint
@app.get("/health", response_model=HealthResponse)
async def health_check():
    """Health check endpoint"""
    db_healthy = await db_service.health_check()
    redis_healthy = await cache_service.health_check()
    model_loaded = model.is_loaded if model else False
    
    status = "healthy" if all([db_healthy, redis_healthy, model_loaded]) else "unhealthy"
    
    return {
        "status": status,
        "service": "card-words-ai",
        "model_loaded": model_loaded,
        "database_connected": db_healthy,
        "redis_connected": redis_healthy,
        "timestamp": datetime.now().isoformat()
    }


# Metrics endpoint
@app.get("/metrics", response_model=MetricsResponse)
async def get_metrics():
    """Get service metrics"""
    # TODO: Implement actual metrics tracking
    return {
        "total_requests": 0,
        "cache_hit_rate": 0.0,
        "average_inference_time_ms": 0.0,
        "model_version": settings.MODEL_VERSION,
        "last_training_time": None
    }


# Smart review prediction endpoint
@app.post("/api/v1/smart-review/predict", response_model=PredictResponse)
async def predict_smart_review(
    request: PredictRequest,
    token_payload: dict = Depends(verify_jwt_token)
):
    """
    Get smart vocabulary review recommendations
    
    Requires JWT authentication
    """
    # Verify user_id matches token
    token_user_id = token_payload.get('sub')
    if token_user_id != request.user_id:
        logger.warning(
            "user_id_mismatch",
            token_user_id=token_user_id,
            request_user_id=request.user_id
        )
        raise HTTPException(status_code=403, detail="User ID mismatch")
    
    if not model.is_loaded:
        logger.error("model_not_loaded")
        raise HTTPException(status_code=503, detail="Model not loaded")
    
    try:
        result = await smart_review_service.get_recommendations(
            user_id=request.user_id,
            limit=request.limit
        )
        return result
    
    except Exception as e:
        logger.error(
            "prediction_failed",
            user_id=request.user_id,
            error=str(e),
            exc_info=True
        )
        raise HTTPException(status_code=500, detail="Prediction failed")


# Retrain model endpoint (admin only)
@app.post("/api/v1/smart-review/retrain", response_model=RetrainResponse)
async def retrain_model(
    request: RetrainRequest,
    _: bool = Depends(verify_admin_api_key)
):
    """
    Retrain XGBoost model with latest data
    
    Requires admin API key
    """
    import time
    
    logger.info("retrain_started", force=request.force)
    start_time = time.time()
    
    try:
        # Fetch all vocab progress data
        progress_list = await db_service.get_all_vocab_progress()
        
        if len(progress_list) < 10:
            raise HTTPException(
                status_code=400,
                detail=f"Insufficient data for training: {len(progress_list)} samples"
            )
        
        # Backup old model if exists
        if os.path.exists(settings.MODEL_PATH):
            backup_path = settings.MODEL_PATH + ".backup"
            os.rename(settings.MODEL_PATH, backup_path)
            logger.info("model_backed_up", backup_path=backup_path)
        
        # Train model
        metrics = model.train(progress_list)
        
        # Save model
        model.save_model()
        
        training_time = time.time() - start_time
        
        logger.info(
            "retrain_completed",
            metrics=metrics,
            training_time_seconds=training_time,
            samples=len(progress_list)
        )
        
        return {
            "success": True,
            "model_version": settings.MODEL_VERSION,
            "metrics": metrics,
            "training_time_seconds": training_time,
            "samples_trained": len(progress_list)
        }
    
    except Exception as e:
        logger.error("retrain_failed", error=str(e), exc_info=True)
        raise HTTPException(status_code=500, detail=f"Training failed: {str(e)}")


# Invalidate cache endpoint (internal)
@app.post("/api/v1/smart-review/invalidate-cache")
async def invalidate_cache(
    request: InvalidateCacheRequest,
    _: bool = Depends(verify_internal_api_key)
):
    """
    Invalidate cache for a user
    
    Requires internal API key
    """
    try:
        await smart_review_service.invalidate_user_cache(request.user_id)
        
        return {
            "success": True,
            "user_id": request.user_id,
            "message": "Cache invalidated"
        }
    
    except Exception as e:
        logger.error(
            "cache_invalidation_failed",
            user_id=request.user_id,
            error=str(e)
        )
        raise HTTPException(status_code=500, detail="Cache invalidation failed")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        app,
        host=settings.API_HOST,
        port=settings.API_PORT,
        log_level=settings.LOG_LEVEL.lower()
    )
