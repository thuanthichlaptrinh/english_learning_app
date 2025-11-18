"""Redis cache service for async operations"""
from typing import Optional, Dict, Any
import redis.asyncio as redis
import json
import structlog

from app.config import settings

logger = structlog.get_logger()


class CacheService:
    """Async Redis cache service"""
    
    def __init__(self, redis_url: Optional[str] = None):
        """
        Initialize cache service
        
        Args:
            redis_url: Redis connection URL (optional, uses settings if not provided)
        """
        self.redis_url = redis_url or settings.get_redis_url
        self.redis = redis.from_url(self.redis_url, decode_responses=True)
        
        logger.info("cache_service_initialized", redis_url=self.redis_url)
    
    async def get(self, key: str) -> Optional[Dict[str, Any]]:
        """
        Get cached value
        
        Args:
            key: Cache key
        
        Returns:
            Cached value as dict, or None if not found
        """
        try:
            data = await self.redis.get(key)
            
            if data:
                logger.debug("cache_hit", key=key)
                return json.loads(data)
            
            logger.debug("cache_miss", key=key)
            return None
        
        except Exception as e:
            logger.error(
                "cache_get_failed",
                key=key,
                error=str(e)
            )
            return None
    
    async def set(self, key: str, value: Dict[str, Any], ttl: int = 300):
        """
        Set cache with TTL
        
        Args:
            key: Cache key
            value: Value to cache (will be JSON serialized)
            ttl: Time to live in seconds (default: 300 = 5 minutes)
        """
        try:
            await self.redis.setex(key, ttl, json.dumps(value, default=str))
            
            logger.debug("cache_set", key=key, ttl=ttl)
        
        except Exception as e:
            logger.error(
                "cache_set_failed",
                key=key,
                error=str(e)
            )
    
    async def delete(self, key: str):
        """
        Delete cache key
        
        Args:
            key: Cache key to delete
        """
        try:
            await self.redis.delete(key)
            
            logger.debug("cache_deleted", key=key)
        
        except Exception as e:
            logger.error(
                "cache_delete_failed",
                key=key,
                error=str(e)
            )
    
    async def health_check(self) -> bool:
        """
        Check Redis connection
        
        Returns:
            True if Redis is accessible, False otherwise
        """
        try:
            await self.redis.ping()
            
            logger.debug("cache_health_check_passed")
            return True
        
        except Exception as e:
            logger.error(
                "cache_health_check_failed",
                error=str(e)
            )
            return False
    
    async def close(self):
        """Close Redis connection"""
        await self.redis.close()
        logger.info("cache_connection_closed")
