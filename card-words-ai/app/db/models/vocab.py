"""Vocab SQLAlchemy model"""
from sqlalchemy import Column, String
from sqlalchemy.dialects.postgresql import UUID
import uuid

from .base import Base


class Vocab(Base):
    """Vocabulary model"""
    __tablename__ = 'vocab'
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    word = Column(String(255), nullable=False)
    meaning_vi = Column(String(500))
    transcription = Column(String(255))
    cefr = Column(String(10))
    img = Column(String(500))
    audio = Column(String(500))
    
    def __repr__(self):
        return f"<Vocab(word={self.word}, cefr={self.cefr})>"
