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
import numpy as np

from app.config import settings
from app.db.database_service import DatabaseService
from app.core.services.cache_service import CacheService
from app.core.services.smart_review_service import SmartReviewService
from app.core.ml.xgboost_model import XGBoostVocabModel
from app.core.ml.random_forest_model import RandomForestVocabModel
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
xgboost_model: XGBoostVocabModel = None
rf_model: RandomForestVocabModel = None
model = None  # Active model (either xgboost_model or rf_model)
smart_review_service: SmartReviewService = None


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Lifespan context manager for startup and shutdown"""
    global db_service, cache_service, xgboost_model, rf_model, model, smart_review_service
    
    # Startup
    logger.info("service_starting", version=settings.MODEL_VERSION)
    
    # Initialize services
    db_service = DatabaseService()
    cache_service = CacheService()
    
    # Initialize XGBoost model
    xgboost_model = XGBoostVocabModel(
        model_path=settings.MODEL_PATH,
        scaler_path=settings.SCALER_PATH,
        version=settings.MODEL_VERSION
    )
    
    # Initialize Random Forest model
    rf_model = RandomForestVocabModel(
        model_path=settings.RF_MODEL_PATH,
        scaler_path=settings.RF_SCALER_PATH,
        version=settings.RF_MODEL_VERSION
    )
    
    # Try to load XGBoost model if exists
    if os.path.exists(settings.MODEL_PATH):
        try:
            xgboost_model.load_model()
            logger.info("xgboost_model_loaded_successfully", version=settings.MODEL_VERSION)
        except Exception as e:
            logger.warning("xgboost_model_load_failed", error=str(e))
    else:
        logger.warning("xgboost_model_file_not_found", path=settings.MODEL_PATH)
    
    # Try to load Random Forest model if exists
    if os.path.exists(settings.RF_MODEL_PATH):
        try:
            rf_model.load_model()
            logger.info("rf_model_loaded_successfully", version=settings.RF_MODEL_VERSION)
        except Exception as e:
            logger.warning("rf_model_load_failed", error=str(e))
    else:
        logger.warning("rf_model_file_not_found", path=settings.RF_MODEL_PATH)
    
    # Set active model based on configuration
    if settings.ACTIVE_MODEL_TYPE == "random_forest":
        model = rf_model
        logger.info("active_model_set", model_type="random_forest")
    else:
        model = xgboost_model
        logger.info("active_model_set", model_type="xgboost")
    
    # Initialize smart review service with active model
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
    xgboost_loaded = xgboost_model.is_loaded if xgboost_model else False
    rf_loaded = rf_model.is_loaded if rf_model else False
    active_model_loaded = model.is_loaded if model else False
    
    status = "healthy" if all([db_healthy, redis_healthy, active_model_loaded]) else "unhealthy"
    
    return {
        "status": status,
        "service": "card-words-ai",
        "model_loaded": active_model_loaded,
        "active_model_type": settings.ACTIVE_MODEL_TYPE,
        "xgboost_loaded": xgboost_loaded,
        "rf_loaded": rf_loaded,
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
    Retrain XGBoost or Random Forest model with latest data
    
    Requires admin API key
    """
    import time
    
    model_type = request.model_type.lower()
    if model_type not in ["xgboost", "random_forest"]:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid model_type: {model_type}. Must be 'xgboost' or 'random_forest'"
        )
    
    logger.info("retrain_started", force=request.force, model_type=model_type)
    start_time = time.time()
    
    try:
        # Fetch all vocab progress data
        progress_list = await db_service.get_all_vocab_progress()
        
        if len(progress_list) < 10:
            raise HTTPException(
                status_code=400,
                detail=f"Insufficient data for training: {len(progress_list)} samples"
            )
        
        # Select model to train
        if model_type == "random_forest":
            target_model = rf_model
            model_path = settings.RF_MODEL_PATH
        else:
            target_model = xgboost_model
            model_path = settings.MODEL_PATH
        
        # Backup old model if exists
        if os.path.exists(model_path):
            backup_path = model_path + ".backup"
            os.rename(model_path, backup_path)
            logger.info("model_backed_up", backup_path=backup_path, model_type=model_type)
        
        # Train model
        metrics = target_model.train(progress_list)
        
        # Convert any NaN/Inf values to None for JSON serialization
        cleaned_metrics = {}
        for key, value in metrics.items():
            if isinstance(value, dict):
                # Handle nested dict (feature_importances)
                cleaned_metrics[key] = {
                    k: None if (isinstance(v, float) and (np.isnan(v) or np.isinf(v))) else v
                    for k, v in value.items()
                }
            elif isinstance(value, float):
                cleaned_metrics[key] = None if (np.isnan(value) or np.isinf(value)) else value
            else:
                cleaned_metrics[key] = value
        
        # Save model
        target_model.save_model()
        
        training_time = time.time() - start_time
        
        logger.info(
            "retrain_completed",
            model_type=model_type,
            metrics=cleaned_metrics,
            training_time_seconds=training_time,
            samples=len(progress_list)
        )
        
        return {
            "success": True,
            "model_type": model_type,
            "model_version": target_model.version,
            "metrics": cleaned_metrics,
            "training_time_seconds": training_time,
            "samples_trained": len(progress_list)
        }
    
    except Exception as e:
        logger.error("retrain_failed", model_type=model_type, error=str(e), exc_info=True)
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
