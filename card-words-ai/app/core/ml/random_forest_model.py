"""Random Forest model for vocabulary review prediction"""
from typing import Dict, List, Tuple
from datetime import date
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, roc_auc_score
import joblib
import os
import structlog

from app.db.models import UserVocabProgress
from app.core.ml.feature_extractor import VocabFeatureExtractor

logger = structlog.get_logger()


class RandomForestVocabModel:
    """Random Forest classifier for vocabulary review prediction"""
    
    # Default hyperparameters
    DEFAULT_PARAMS = {
        'n_estimators': 100,
        'max_depth': 10,
        'min_samples_split': 5,
        'min_samples_leaf': 2,
        'max_features': 'sqrt',
        'random_state': 42,
        'n_jobs': -1,
        'class_weight': 'balanced'
    }
    
    def __init__(self, model_path: str, scaler_path: str, version: str = "v1.0.0"):
        """
        Initialize Random Forest model
        
        Args:
            model_path: Path to save/load model
            scaler_path: Path to save/load scaler
            version: Model version
        """
        self.model_path = model_path
        self.scaler_path = scaler_path
        self.version = version
        self.model = None
        self.feature_extractor = None
        self.is_loaded = False
    
    def generate_labels(self, progress_list: List[UserVocabProgress]) -> np.ndarray:
        """
        Generate binary labels for training
        
        Label = 1 (need review) if:
          - status is UNKNOWN or NEW, OR
          - status is KNOWN AND (overdue OR low accuracy)
        Label = 0 (no need review) otherwise
        
        Args:
            progress_list: List of UserVocabProgress objects
        
        Returns:
            Binary labels array
        """
        labels = []
        
        for progress in progress_list:
            # Calculate days until next review
            days_until = 0
            if progress.next_review_date:
                days_until = (progress.next_review_date - date.today()).days
            
            # Calculate accuracy
            total = progress.times_correct + progress.times_wrong
            accuracy = progress.times_correct / total if total > 0 else 0
            
            # Determine if needs review
            need_review = (
                progress.status.value in ['UNKNOWN', 'NEW'] or
                (progress.status.value == 'KNOWN' and (days_until <= 0 or accuracy < 0.7))
            )
            
            labels.append(1 if need_review else 0)
        
        return np.array(labels)
    
    def train(
        self,
        progress_list: List[UserVocabProgress],
        test_size: float = 0.2,
        random_state: int = 42
    ) -> Dict:
        """
        Train Random Forest model and return metrics
        
        Args:
            progress_list: List of UserVocabProgress for training
            test_size: Proportion of data for validation
            random_state: Random seed
        
        Returns:
            Dictionary with training metrics
        """
        if len(progress_list) < 10:
            raise ValueError(f"Need at least 10 samples for training, got {len(progress_list)}")
        
        logger.info("rf_training_started", n_samples=len(progress_list))
        
        # Initialize feature extractor
        self.feature_extractor = VocabFeatureExtractor()
        
        # Extract features
        X = self.feature_extractor.extract_and_normalize(progress_list)
        
        # Generate labels
        y = self.generate_labels(progress_list)
        
        positive_samples = int(np.sum(y))
        negative_samples = int(len(y) - np.sum(y))
        
        logger.info(
            "rf_labels_generated",
            positive_samples=positive_samples,
            negative_samples=negative_samples
        )
        
        # Check for class imbalance
        if positive_samples == 0 or negative_samples == 0:
            raise ValueError(
                f"Insufficient class diversity: {positive_samples} positive, {negative_samples} negative samples. "
                "Need at least 1 sample of each class for binary classification. "
                "Please add more diverse vocabulary progress data."
            )
        
        # Split train/validation
        X_train, X_val, y_train, y_val = train_test_split(
            X, y,
            test_size=test_size,
            random_state=random_state,
            stratify=y
        )
        
        # Train Random Forest
        self.model = RandomForestClassifier(**self.DEFAULT_PARAMS)
        
        logger.info("rf_fitting_model", n_train_samples=len(X_train))
        
        self.model.fit(X_train, y_train)
        
        self.is_loaded = True
        
        # Evaluate
        metrics = self.evaluate(X_val, y_val)
        
        # Get feature importances
        feature_importances = self._get_feature_importances()
        metrics['feature_importances'] = feature_importances
        
        logger.info("rf_training_completed", metrics=metrics)
        
        # Warning if accuracy is low
        if metrics['accuracy'] < 0.7:
            logger.warning(
                "rf_low_model_accuracy",
                accuracy=metrics['accuracy'],
                message="Model accuracy is below 0.7"
            )
        
        return metrics
    
    def evaluate(self, X: np.ndarray, y: np.ndarray) -> Dict:
        """
        Evaluate model and return metrics
        
        Args:
            X: Feature matrix
            y: True labels
        
        Returns:
            Dictionary with evaluation metrics
        """
        if self.model is None:
            raise ValueError("Model is not trained or loaded")
        
        y_pred = self.model.predict(X)
        y_pred_proba = self.model.predict_proba(X)[:, 1]
        
        metrics = {
            'accuracy': float(accuracy_score(y, y_pred)),
            'precision': float(precision_score(y, y_pred, zero_division=0)),
            'recall': float(recall_score(y, y_pred, zero_division=0)),
            'f1_score': float(f1_score(y, y_pred, zero_division=0)),
            'auc_roc': float(roc_auc_score(y, y_pred_proba))
        }
        
        return metrics
    
    def _get_feature_importances(self) -> Dict[str, float]:
        """
        Get feature importances from trained Random Forest
        
        Returns:
            Dictionary mapping feature names to importance scores
        """
        if self.model is None:
            return {}
        
        importances = self.model.feature_importances_
        feature_names = self.feature_extractor.FEATURE_NAMES
        
        return {
            name: float(importance)
            for name, importance in zip(feature_names, importances)
        }
    
    def predict_proba(self, X: np.ndarray) -> np.ndarray:
        """
        Predict probability scores for vocabs
        
        Args:
            X: Normalized feature matrix
        
        Returns:
            Probability scores (probability of needing review)
        """
        if self.model is None:
            raise ValueError("Model is not trained or loaded")
        
        probabilities = self.model.predict_proba(X)[:, 1]
        
        return probabilities
    
    def save_model(self):
        """Save model and scaler to disk"""
        if self.model is None or self.feature_extractor is None:
            raise ValueError("Model and feature extractor must be trained before saving")
        
        # Create directory if not exists
        os.makedirs(os.path.dirname(self.model_path), exist_ok=True)
        os.makedirs(os.path.dirname(self.scaler_path), exist_ok=True)
        
        # Save model
        joblib.dump(self.model, self.model_path)
        logger.info("rf_model_saved", path=self.model_path)
        
        # Save scaler
        joblib.dump(self.feature_extractor.scaler, self.scaler_path)
        logger.info("rf_scaler_saved", path=self.scaler_path)
    
    def load_model(self):
        """Load model and scaler from disk"""
        if not os.path.exists(self.model_path):
            raise FileNotFoundError(f"Model file not found: {self.model_path}")
        
        if not os.path.exists(self.scaler_path):
            raise FileNotFoundError(f"Scaler file not found: {self.scaler_path}")
        
        # Load model
        self.model = joblib.load(self.model_path)
        logger.info("rf_model_loaded", path=self.model_path)
        
        # Load scaler
        scaler = joblib.load(self.scaler_path)
        self.feature_extractor = VocabFeatureExtractor(scaler=scaler)
        logger.info("rf_scaler_loaded", path=self.scaler_path)
        
        self.is_loaded = True
