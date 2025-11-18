"""Smart review service for vocabulary recommendations"""
from typing import Dict, List, Any
import time
import numpy as np
import structlog

from app.db.database_service import DatabaseService
from app.core.services.cache_service import CacheService
from app.core.ml.xgboost_model import XGBoostVocabModel
from app.config import settings

logger = structlog.get_logger()


class SmartReviewService:
    """Orchestrate the prediction pipeline for smart vocabulary review"""
    
    def __init__(
        self,
        model: XGBoostVocabModel,
        db_service: DatabaseService,
        cache_service: CacheService
    ):
        """
        Initialize smart review service
        
        Args:
            model: Trained XGBoost model
            db_service: Database service
            cache_service: Cache service
        """
        self.model = model
        self.db = db_service
        self.cache = cache_service
    
    async def get_recommendations(
        self,
        user_id: str,
        limit: int = 20
    ) -> Dict[str, Any]:
        """
        Get smart review recommendations for user
        
        Args:
            user_id: User UUID
            limit: Number of vocabs to return
        
        Returns:
            Dictionary with recommendations and metadata
        """
        start_time = time.time()
        
        # 1. Check cache
        cache_key = f"smart_review:{user_id}"
        cached = await self.cache.get(cache_key)
        
        if cached:
            logger.info(
                "cache_hit",
                user_id=user_id,
                cache_key=cache_key
            )
            return cached
        
        # 2. Query database for user's vocab progress
        progress_list = await self.db.get_user_vocab_progress(
            user_id=user_id,
            statuses=['NEW', 'UNKNOWN', 'KNOWN']
        )
        
        if not progress_list:
            logger.info("no_vocab_progress_found", user_id=user_id)
            return {
                "user_id": user_id,
                "vocabs": [],
                "total": 0,
                "meta": {
                    "cached": False,
                    "model_version": self.model.version,
                    "inference_time_ms": 0
                }
            }
        
        # 3. Extract and normalize features
        X = self.model.feature_extractor.extract_and_normalize(progress_list)
        
        # 4. Predict with XGBoost
        probabilities = self.model.predict_proba(X)
        
        # 5. Rank vocabs by probability (descending)
        ranked_indices = np.argsort(probabilities)[::-1]
        
        # 6. Build response
        recommendations = []
        for idx in ranked_indices[:limit]:
            progress = progress_list[idx]
            vocab = progress.vocab
            
            recommendations.append({
                "vocab_id": str(vocab.id),
                "word": vocab.word,
                "meaning_vi": vocab.meaning_vi,
                "transcription": vocab.transcription,
                "priority_score": float(probabilities[idx]),
                "status": progress.status.value,
                "times_correct": progress.times_correct,
                "times_wrong": progress.times_wrong,
                "last_reviewed": progress.last_reviewed.isoformat() if progress.last_reviewed else None,
                "next_review_date": progress.next_review_date.isoformat() if progress.next_review_date else None
            })
        
        # Calculate inference time
        inference_time_ms = int((time.time() - start_time) * 1000)
        
        # Log warning if inference is slow
        if inference_time_ms > settings.INFERENCE_WARNING_THRESHOLD_MS:
            logger.warning(
                "slow_inference",
                user_id=user_id,
                inference_time_ms=inference_time_ms,
                threshold_ms=settings.INFERENCE_WARNING_THRESHOLD_MS
            )
        
        result = {
            "user_id": user_id,
            "vocabs": recommendations,
            "total": len(recommendations),
            "meta": {
                "cached": False,
                "model_version": self.model.version,
                "inference_time_ms": inference_time_ms
            }
        }
        
        # 7. Cache result
        await self.cache.set(cache_key, result, ttl=settings.CACHE_TTL)
        
        logger.info(
            "recommendations_generated",
            user_id=user_id,
            total_vocabs=len(progress_list),
            recommended=len(recommendations),
            inference_time_ms=inference_time_ms
        )
        
        return result
    
    async def invalidate_user_cache(self, user_id: str):
        """
        Invalidate cache when user submits learning result
        
        Args:
            user_id: User UUID
        """
        cache_key = f"smart_review:{user_id}"
        await self.cache.delete(cache_key)
        
        logger.info("cache_invalidated", user_id=user_id, cache_key=cache_key)
