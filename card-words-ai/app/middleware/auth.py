"""Authentication middleware"""
from fastapi import HTTPException, Security, Header
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import jwt
from datetime import datetime
import structlog

from app.config import settings

logger = structlog.get_logger()
security = HTTPBearer()


async def verify_jwt_token(
    credentials: HTTPAuthorizationCredentials = Security(security)
) -> dict:
    """
    Verify JWT token from Authorization header
    
    Args:
        credentials: HTTP Bearer credentials
    
    Returns:
        Decoded JWT payload
    
    Raises:
        HTTPException: If token is invalid or expired
    """
    token = credentials.credentials
    
    try:
        # Decode JWT (shared secret with Spring Boot)
        payload = jwt.decode(
            token,
            settings.JWT_SECRET,
            algorithms=[settings.JWT_ALGORITHM]
        )
        
        # Check expiration
        if 'exp' in payload:
            exp_timestamp = payload['exp']
            if datetime.fromtimestamp(exp_timestamp) < datetime.now():
                logger.warning("token_expired", exp=exp_timestamp)
                raise HTTPException(status_code=401, detail="Token expired")
        
        logger.debug("token_verified", user_id=payload.get('sub'))
        return payload
    
    except jwt.ExpiredSignatureError:
        logger.warning("token_expired_signature")
        raise HTTPException(status_code=401, detail="Token expired")
    
    except jwt.InvalidTokenError as e:
        logger.warning("invalid_token", error=str(e))
        raise HTTPException(status_code=401, detail="Invalid token")


async def verify_admin_api_key(x_api_key: str = Header(..., alias="X-API-Key")):
    """
    Verify admin API key
    
    Args:
        x_api_key: API key from header
    
    Raises:
        HTTPException: If API key is invalid
    """
    if x_api_key != settings.ADMIN_API_KEY:
        logger.warning("invalid_admin_api_key")
        raise HTTPException(status_code=403, detail="Invalid API key")
    
    logger.debug("admin_api_key_verified")
    return True


async def verify_internal_api_key(x_api_key: str = Header(..., alias="X-API-Key")):
    """
    Verify internal API key for service-to-service calls
    
    Args:
        x_api_key: API key from header
    
    Raises:
        HTTPException: If API key is invalid
    """
    if x_api_key != settings.INTERNAL_API_KEY:
        logger.warning("invalid_internal_api_key")
        raise HTTPException(status_code=403, detail="Invalid API key")
    
    logger.debug("internal_api_key_verified")
    return True
