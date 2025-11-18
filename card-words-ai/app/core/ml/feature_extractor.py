"""Feature extraction for vocabulary learning data"""
from typing import List
from datetime import date
import numpy as np
from sklearn.preprocessing import StandardScaler
import structlog

from app.db.models import UserVocabProgress

logger = structlog.get_logger()


class VocabFeatureExtractor:
    """Extract and normalize features from UserVocabProgress"""
    
    # Feature names for reference
    FEATURE_NAMES = [
        'times_correct',
        'times_wrong',
        'accuracy_rate',
        'days_since_last_review',
        'days_until_next_review',
        'interval_days',
        'repetition',
        'ef_factor',
        'status_encoded'
    ]
    
    # Status encoding mapping
    STATUS_ENCODING = {
        'NEW': 0,
        'UNKNOWN': 1,
        'KNOWN': 2,
        'MASTERED': 3
    }
    
    def __init__(self, scaler: StandardScaler = None):
        """
        Initialize feature extractor
        
        Args:
            scaler: Fitted StandardScaler (optional, will create new if not provided)
        """
        self.scaler = scaler if scaler is not None else StandardScaler()
        self.is_fitted = scaler is not None
    
    def extract_features(self, progress: UserVocabProgress) -> np.ndarray:
        """
        Extract raw features from UserVocabProgress
        
        Args:
            progress: UserVocabProgress object
        
        Returns:
            Feature vector as numpy array (9 features)
        """
        # 1. times_correct
        times_correct = progress.times_correct
        
        # 2. times_wrong
        times_wrong = progress.times_wrong
        
        # 3. accuracy_rate
        total_attempts = times_correct + times_wrong
        accuracy_rate = times_correct / total_attempts if total_attempts > 0 else 0.0
        
        # 4. days_since_last_review
        if progress.last_reviewed:
            days_since = (date.today() - progress.last_reviewed).days
        else:
            days_since = 999  # Never reviewed
        
        # 5. days_until_next_review (negative if overdue)
        if progress.next_review_date:
            days_until = (progress.next_review_date - date.today()).days
        else:
            days_until = 0
        
        # 6. interval_days
        interval_days = progress.interval_days
        
        # 7. repetition
        repetition = progress.repetition
        
        # 8. ef_factor
        ef_factor = progress.ef_factor
        
        # 9. status_encoded
        status_encoded = self.STATUS_ENCODING.get(progress.status.value, 0)
        
        return np.array([
            times_correct,
            times_wrong,
            accuracy_rate,
            days_since,
            days_until,
            interval_days,
            repetition,
            ef_factor,
            status_encoded
        ], dtype=np.float64)
    
    def normalize_features(self, features: np.ndarray) -> np.ndarray:
        """
        Normalize features using fitted scaler
        
        Args:
            features: Raw feature matrix (n_samples, n_features)
        
        Returns:
            Normalized feature matrix
        """
        if not self.is_fitted:
            raise ValueError("Scaler is not fitted. Call fit() or extract_and_normalize() first.")
        
        return self.scaler.transform(features)
    
    def extract_and_normalize(self, progress_list: List[UserVocabProgress]) -> np.ndarray:
        """
        Extract and normalize features for a batch
        
        Args:
            progress_list: List of UserVocabProgress objects
        
        Returns:
            Normalized feature matrix (n_samples, n_features)
        """
        if not progress_list:
            return np.array([]).reshape(0, len(self.FEATURE_NAMES))
        
        # Extract features for all progress items
        features = np.array([
            self.extract_features(progress)
            for progress in progress_list
        ])
        
        logger.debug(
            "features_extracted",
            n_samples=len(progress_list),
            n_features=features.shape[1]
        )
        
        # Fit scaler if not fitted yet
        if not self.is_fitted:
            self.scaler.fit(features)
            self.is_fitted = True
            logger.info("scaler_fitted", n_samples=len(progress_list))
        
        # Normalize
        normalized = self.scaler.transform(features)
        
        return normalized
    
    def fit(self, progress_list: List[UserVocabProgress]):
        """
        Fit scaler on training data
        
        Args:
            progress_list: List of UserVocabProgress objects for training
        """
        if not progress_list:
            raise ValueError("Cannot fit scaler on empty data")
        
        features = np.array([
            self.extract_features(progress)
            for progress in progress_list
        ])
        
        self.scaler.fit(features)
        self.is_fitted = True
        
        logger.info("scaler_fitted", n_samples=len(progress_list))
