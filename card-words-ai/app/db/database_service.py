"""Database service for async operations"""
from typing import List, Optional
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from sqlalchemy.orm import joinedload
from sqlalchemy import select, text
import structlog

from app.config import settings
from app.db.models import UserVocabProgress, VocabStatus

logger = structlog.get_logger()


class DatabaseService:
    """Async database service for querying UserVocabProgress"""
    
    def __init__(self, database_url: Optional[str] = None):
        """
        Initialize database service
        
        Args:
            database_url: PostgreSQL connection URL (optional, uses settings if not provided)
        """
        self.database_url = database_url or settings.get_database_url
        
        # Create async engine with connection pooling
        self.engine = create_async_engine(
            self.database_url,
            pool_size=20,
            max_overflow=10,
            pool_pre_ping=True,
            echo=False
        )
        
        # Create async session factory
        self.async_session = async_sessionmaker(
            self.engine,
            class_=AsyncSession,
            expire_on_commit=False
        )
        
        logger.info("database_service_initialized", database_url=self.database_url.split('@')[-1])
    
    async def get_user_vocab_progress(
        self,
        user_id: str,
        statuses: Optional[List[str]] = None
    ) -> List[UserVocabProgress]:
        """
        Get user's vocab progress filtered by statuses
        
        Args:
            user_id: User UUID
            statuses: List of status strings to filter (e.g., ['NEW', 'UNKNOWN', 'KNOWN'])
        
        Returns:
            List of UserVocabProgress objects with vocab relationship loaded
        """
        if statuses is None:
            statuses = ['NEW', 'UNKNOWN', 'KNOWN']
        
        try:
            async with self.async_session() as session:
                # Convert string statuses to enum values
                status_enums = [VocabStatus[s] for s in statuses]
                
                # Build query with eager loading of vocab relationship
                query = (
                    select(UserVocabProgress)
                    .options(joinedload(UserVocabProgress.vocab))
                    .filter(UserVocabProgress.user_id == user_id)
                    .filter(UserVocabProgress.status.in_(status_enums))
                )
                
                result = await session.execute(query)
                progress_list = result.scalars().all()
                
                logger.info(
                    "user_vocab_progress_fetched",
                    user_id=user_id,
                    count=len(progress_list),
                    statuses=statuses
                )
                
                return list(progress_list)
        
        except Exception as e:
            logger.error(
                "failed_to_fetch_user_vocab_progress",
                user_id=user_id,
                error=str(e),
                exc_info=True
            )
            raise
    
    async def get_all_vocab_progress(self) -> List[UserVocabProgress]:
        """
        Get all vocab progress for training
        
        Returns:
            List of all UserVocabProgress objects
        """
        try:
            async with self.async_session() as session:
                query = (
                    select(UserVocabProgress)
                    .options(joinedload(UserVocabProgress.vocab))
                )
                
                result = await session.execute(query)
                progress_list = result.scalars().all()
                
                logger.info(
                    "all_vocab_progress_fetched",
                    count=len(progress_list)
                )
                
                return list(progress_list)
        
        except Exception as e:
            logger.error(
                "failed_to_fetch_all_vocab_progress",
                error=str(e),
                exc_info=True
            )
            raise
    
    async def health_check(self) -> bool:
        """
        Check database connection
        
        Returns:
            True if database is accessible, False otherwise
        """
        try:
            async with self.async_session() as session:
                await session.execute(text("SELECT 1"))
            
            logger.debug("database_health_check_passed")
            return True
        
        except Exception as e:
            logger.error(
                "database_health_check_failed",
                error=str(e)
            )
            return False
    
    async def close(self):
        """Close database connections"""
        await self.engine.dispose()
        logger.info("database_connections_closed")
