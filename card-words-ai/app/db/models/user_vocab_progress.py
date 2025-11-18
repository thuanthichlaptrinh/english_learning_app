"""UserVocabProgress SQLAlchemy model"""
from sqlalchemy import Column, String, Integer, Float, Date, ForeignKey, Enum as SQLEnum
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import UUID
import uuid
import enum

from .base import Base


class VocabStatus(str, enum.Enum):
    """Vocabulary status enum"""
    NEW = "NEW"
    UNKNOWN = "UNKNOWN"
    KNOWN = "KNOWN"
    MASTERED = "MASTERED"


class UserVocabProgress(Base):
    """User vocabulary progress model"""
    __tablename__ = 'user_vocab_progress'
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), nullable=False, index=True)
    vocab_id = Column(UUID(as_uuid=True), ForeignKey('vocab.id'), nullable=False, index=True)
    
    status = Column(SQLEnum(VocabStatus), nullable=False, index=True)
    last_reviewed = Column(Date)
    times_correct = Column(Integer, default=0, nullable=False)
    times_wrong = Column(Integer, default=0, nullable=False)
    ef_factor = Column(Float, default=2.5, nullable=False)
    interval_days = Column(Integer, default=1, nullable=False)
    repetition = Column(Integer, default=0, nullable=False)
    next_review_date = Column(Date, index=True)
    
    # Relationship
    vocab = relationship("Vocab", lazy="joined")
    
    def __repr__(self):
        return f"<UserVocabProgress(user_id={self.user_id}, vocab_id={self.vocab_id}, status={self.status})>"
