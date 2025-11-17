# Đề xuất: Supervised ML & Deep Learning cho Smart Vocabulary Review

## 1. Tổng quan

### 1.1. Bài toán
Vì bảng `UserVocabProgress` đã có nhãn `status` (NEW, UNKNOWN, KNOWN, MASTERED), ta có thể:
1. **Dự đoán status tiếp theo** của từ vựng sau khi user ôn tập
2. **Dự đoán xác suất user trả lời đúng** từ vựng
3. **Tối ưu hóa thứ tự ôn tập** dựa trên model predictions
4. **Cá nhân hóa learning path** cho từng user

### 1.2. Ưu điểm so với K-means (Unsupervised)
✅ **Có nhãn sẵn** → Supervised Learning chính xác hơn  
✅ **Dự đoán được kết quả** → Proactive recommendations  
✅ **Personalized** → Model học pattern riêng của từng user  
✅ **Measurable** → Có metrics rõ ràng (accuracy, F1-score)  

## 2. Các Bài toán ML có thể giải quyết

### 2.1. Bài toán 1: Status Prediction (Classification)
**Mục tiêu:** Dự đoán status tiếp theo của từ vựng

**Input Features:**
- `times_correct`, `times_wrong`
- `ef_factor`, `interval_days`, `repetition`
- `days_since_last_review`
- `cefr_level` (A1-C2)
- `user_current_level`
- `topic_id`
- `time_of_day`, `day_of_week` (temporal features)

**Output:** 
- Xác suất cho mỗi status: [P(NEW), P(UNKNOWN), P(KNOWN), P(MASTERED)]

**Use case:**
- Dự đoán từ nào sắp chuyển từ KNOWN → MASTERED
- Dự đoán từ nào có nguy cơ quên (KNOWN → UNKNOWN)

### 2.2. Bài toán 2: Success Probability Prediction (Regression)
**Mục tiêu:** Dự đoán xác suất user trả lời đúng từ vựng

**Input Features:** (giống trên)

**Output:**
- Xác suất trả lời đúng: 0.0 - 1.0

**Use case:**
- Ưu tiên từ có xác suất 40-60% (optimal difficulty)
- Tránh từ quá dễ (>90%) hoặc quá khó (<20%)

### 2.3. Bài toán 3: Optimal Review Time Prediction (Regression)
**Mục tiêu:** Dự đoán thời điểm tối ưu để ôn tập lại từ vựng

**Input Features:** (giống trên)

**Output:**
- Số ngày tối ưu để review lại: 1-30 days

**Use case:**
- Thay thế SM-2 algorithm bằng ML model
- Personalized spacing intervals

## 3. Kiến trúc ML System

### 3.1. Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Data Collection Layer                     │
│  - UserVocabProgress (labeled data)                         │
│  - GameSessionDetail (interaction data)                     │
│  - User behavior logs                                       │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                  Feature Engineering Layer                   │
│  - Temporal features (time since last review)               │
│  - Aggregation features (avg accuracy per topic)            │
│  - User features (learning speed, consistency)              │
│  - Vocab features (difficulty, frequency)                   │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                      ML Models Layer                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   XGBoost    │  │  LightGBM    │  │  Neural Net  │     │
│  │ (Baseline)   │  │ (Production) │  │  (Advanced)  │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                   Prediction Service Layer                   │
│  - Real-time inference API                                  │
│  - Batch prediction jobs                                    │
│  - Model versioning & A/B testing                           │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                  Application Layer (FastAPI)                 │
│  - Smart review recommendations                             │
│  - Personalized learning paths                              │
│  - Adaptive difficulty                                      │
└─────────────────────────────────────────────────────────────┘
```

## 4. Feature Engineering (Chi tiết)

### 4.1. User-level Features

```python
class UserFeatures:
    """Features describing user's learning behavior"""
    
    # Learning speed
    avg_time_to_master: float  # Avg days from NEW to MASTERED
    learning_velocity: float    # Vocabs mastered per week
    
    # Consistency
    study_streak: int
    avg_daily_reviews: float
    study_time_variance: float  # Consistency of study time
    
    # Performance
    overall_accuracy: float
    accuracy_by_cefr: Dict[str, float]  # A1: 0.9, B1: 0.7, etc.
    
    # Preferences
    preferred_study_time: int  # Hour of day (0-23)
    preferred_topics: List[str]
    
    # Experience
    total_vocabs_learned: int
    days_since_registration: int
    current_level: str  # A1-C2
```

### 4.2. Vocab-level Features

```python
class VocabFeatures:
    """Features describing vocabulary characteristics"""
    
    # Difficulty
    cefr_level: str
    cefr_numeric: float  # A1=1, A2=2, ..., C2=6
    word_length: int
    syllable_count: int
    
    # Frequency
    word_frequency_rank: int  # From corpus
    
    # Semantic
    topic_id: int
    pos_tag: str  # noun, verb, adjective, etc.
    
    # Historical performance (across all users)
    global_avg_accuracy: float
    global_avg_time_to_master: float
```

### 4.3. Interaction Features

```python
class InteractionFeatures:
    """Features from user-vocab interactions"""
    
    # Current state
    status: str  # NEW, UNKNOWN, KNOWN, MASTERED
    times_correct: int
    times_wrong: int
    accuracy_rate: float
    
    # Temporal
    days_since_last_review: int
    days_since_first_seen: int
    review_count: int
    
    # SM-2 algorithm features
    ef_factor: float
    interval_days: int
    repetition: int
    
    # Trend
    accuracy_trend: float  # Improving or declining
    review_frequency: float  # Reviews per week
    
    # Context
    last_review_time_of_day: int
    last_review_day_of_week: int
```

### 4.4. Combined Feature Vector

```python
def create_feature_vector(
    user: User,
    vocab: Vocab,
    progress: UserVocabProgress
) -> np.ndarray:
    """
    Create complete feature vector for ML model
    
    Returns: 
        Array of shape (n_features,) - typically 30-50 features
    """
    
    features = []
    
    # User features (10)
    features.extend([
        user.avg_time_to_master,
        user.learning_velocity,
        user.study_streak,
        user.overall_accuracy,
        user.total_vocabs_learned,
        user.days_since_registration,
        encode_cefr(user.current_level),
        user.preferred_study_time,
        user.avg_daily_reviews,
        user.study_time_variance
    ])
    
    # Vocab features (8)
    features.extend([
        encode_cefr(vocab.cefr_level),
        vocab.word_length,
        vocab.word_frequency_rank,
        vocab.global_avg_accuracy,
        vocab.global_avg_time_to_master,
        encode_topic(vocab.topic_id),
        encode_pos(vocab.pos_tag),
        vocab.syllable_count
    ])
    
    # Interaction features (12)
    features.extend([
        progress.times_correct,
        progress.times_wrong,
        progress.times_correct / (progress.times_correct + progress.times_wrong + 1),
        (datetime.now().date() - progress.last_reviewed).days if progress.last_reviewed else 999,
        (datetime.now().date() - progress.created_at.date()).days,
        progress.ef_factor,
        progress.interval_days,
        progress.repetition,
        progress.review_count,
        progress.accuracy_trend,
        progress.review_frequency,
        encode_status(progress.status)
    ])
    
    return np.array(features)
```


## 5. ML Models Comparison

### 5.1. Traditional ML Models

#### **Model 1: XGBoost (Baseline)**

**Ưu điểm:**
- Fast training & inference
- Handle missing values tốt
- Feature importance rõ ràng
- Không cần feature scaling

**Nhược điểm:**
- Không capture temporal patterns tốt
- Cần feature engineering thủ công

**Use case:** Baseline model, production-ready

```python
import xgboost as xgb

# Status classification
model = xgb.XGBClassifier(
    n_estimators=100,
    max_depth=6,
    learning_rate=0.1,
    objective='multi:softprob',
    num_class=4  # NEW, UNKNOWN, KNOWN, MASTERED
)

# Success probability regression
model = xgb.XGBRegressor(
    n_estimators=100,
    max_depth=6,
    learning_rate=0.1,
    objective='reg:squarederror'
)
```

#### **Model 2: LightGBM (Recommended)**

**Ưu điểm:**
- Nhanh hơn XGBoost
- Memory efficient
- Handle categorical features native
- Tốt với large dataset

**Nhược điểm:**
- Dễ overfit với small dataset
- Cần tuning cẩn thận

**Use case:** Production model, best performance

```python
import lightgbm as lgb

# Status classification
model = lgb.LGBMClassifier(
    n_estimators=100,
    max_depth=6,
    learning_rate=0.1,
    num_leaves=31,
    objective='multiclass',
    num_class=4
)

# Success probability
model = lgb.LGBMRegressor(
    n_estimators=100,
    max_depth=6,
    learning_rate=0.1,
    num_leaves=31,
    objective='regression'
)
```

#### **Model 3: Random Forest**

**Ưu điểm:**
- Robust, ít overfit
- Không cần tuning nhiều
- Feature importance

**Nhược điểm:**
- Chậm hơn XGBoost/LightGBM
- Model size lớn

**Use case:** Ensemble với các models khác

### 5.2. Deep Learning Models

#### **Model 4: Feedforward Neural Network (Simple)**

**Architecture:**
```python
import torch
import torch.nn as nn

class VocabStatusPredictor(nn.Module):
    def __init__(self, input_dim=30, hidden_dims=[128, 64, 32], num_classes=4):
        super().__init__()
        
        layers = []
        prev_dim = input_dim
        
        for hidden_dim in hidden_dims:
            layers.extend([
                nn.Linear(prev_dim, hidden_dim),
                nn.BatchNorm1d(hidden_dim),
                nn.ReLU(),
                nn.Dropout(0.3)
            ])
            prev_dim = hidden_dim
        
        layers.append(nn.Linear(prev_dim, num_classes))
        self.network = nn.Sequential(*layers)
    
    def forward(self, x):
        return self.network(x)

# Usage
model = VocabStatusPredictor(input_dim=30, num_classes=4)
criterion = nn.CrossEntropyLoss()
optimizer = torch.optim.Adam(model.parameters(), lr=0.001)
```

**Ưu điểm:**
- Flexible architecture
- Có thể học non-linear patterns phức tạp
- Dễ thêm regularization

**Nhược điểm:**
- Cần nhiều data hơn
- Training chậm hơn
- Khó interpret

#### **Model 5: LSTM (Temporal Patterns)**

**Architecture:**
```python
class TemporalVocabPredictor(nn.Module):
    """
    LSTM model to capture temporal learning patterns
    Input: Sequence of review history
    Output: Next status or success probability
    """
    
    def __init__(self, input_dim=30, hidden_dim=64, num_layers=2, num_classes=4):
        super().__init__()
        
        self.lstm = nn.LSTM(
            input_size=input_dim,
            hidden_size=hidden_dim,
            num_layers=num_layers,
            batch_first=True,
            dropout=0.3
        )
        
        self.fc = nn.Sequential(
            nn.Linear(hidden_dim, 32),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(32, num_classes)
        )
    
    def forward(self, x):
        # x shape: (batch, sequence_length, input_dim)
        lstm_out, (h_n, c_n) = self.lstm(x)
        
        # Use last hidden state
        last_hidden = h_n[-1]
        
        output = self.fc(last_hidden)
        return output

# Usage
model = TemporalVocabPredictor(input_dim=30, hidden_dim=64, num_classes=4)
```

**Ưu điểm:**
- Capture temporal dependencies
- Học được learning trajectory của user
- Dự đoán chính xác hơn cho long-term

**Nhược điểm:**
- Cần sequence data (history of reviews)
- Training phức tạp hơn
- Inference chậm hơn

**Use case:** Advanced model khi có đủ historical data

#### **Model 6: Transformer (State-of-the-art)**

**Architecture:**
```python
class TransformerVocabPredictor(nn.Module):
    """
    Transformer model for vocabulary learning prediction
    Can handle variable-length sequences and attention mechanism
    """
    
    def __init__(self, input_dim=30, d_model=128, nhead=4, 
                 num_layers=2, num_classes=4):
        super().__init__()
        
        self.embedding = nn.Linear(input_dim, d_model)
        
        encoder_layer = nn.TransformerEncoderLayer(
            d_model=d_model,
            nhead=nhead,
            dim_feedforward=256,
            dropout=0.1
        )
        
        self.transformer = nn.TransformerEncoder(
            encoder_layer,
            num_layers=num_layers
        )
        
        self.classifier = nn.Sequential(
            nn.Linear(d_model, 64),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(64, num_classes)
        )
    
    def forward(self, x):
        # x shape: (batch, seq_len, input_dim)
        x = self.embedding(x)
        
        # Transformer expects (seq_len, batch, d_model)
        x = x.transpose(0, 1)
        
        transformer_out = self.transformer(x)
        
        # Use mean pooling
        pooled = transformer_out.mean(dim=0)
        
        output = self.classifier(pooled)
        return output
```

**Ưu điểm:**
- State-of-the-art performance
- Attention mechanism → interpretable
- Parallel processing → fast training

**Nhược điểm:**
- Cần nhiều data
- Phức tạp, khó tune
- Overkill cho bài toán này

**Use case:** Research, khi có >100k samples

### 5.3. Model Comparison Table

| Model | Training Speed | Inference Speed | Accuracy | Interpretability | Data Required |
|-------|---------------|-----------------|----------|------------------|---------------|
| XGBoost | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| LightGBM | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| Random Forest | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| Neural Net | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ |
| LSTM | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| Transformer | ⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

**Recommendation:**
- **MVP/Production:** LightGBM (best balance)
- **Research/Advanced:** LSTM hoặc Transformer
- **Baseline:** XGBoost

## 6. Training Pipeline

### 6.1. Data Preparation

```python
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
import pandas as pd

class DataPipeline:
    def __init__(self):
        self.scaler = StandardScaler()
        self.label_encoder = LabelEncoder()
    
    async def prepare_training_data(self):
        """Prepare data from database"""
        
        # Query data
        query = """
        SELECT 
            uvp.*,
            v.cefr, v.word, v.topic_id,
            u.current_level, u.current_streak, u.total_study_days
        FROM user_vocab_progress uvp
        JOIN vocab v ON uvp.vocab_id = v.id
        JOIN users u ON uvp.user_id = u.id
        WHERE uvp.status IN ('NEW', 'UNKNOWN', 'KNOWN', 'MASTERED')
        """
        
        df = await self.fetch_dataframe(query)
        
        # Feature engineering
        df = self.engineer_features(df)
        
        # Split features and labels
        X = df[self.feature_columns]
        y = df['status']
        
        # Encode labels
        y_encoded = self.label_encoder.fit_transform(y)
        
        # Train/val/test split
        X_train, X_temp, y_train, y_temp = train_test_split(
            X, y_encoded, test_size=0.3, random_state=42, stratify=y_encoded
        )
        
        X_val, X_test, y_val, y_test = train_test_split(
            X_temp, y_temp, test_size=0.5, random_state=42, stratify=y_temp
        )
        
        # Scale features
        X_train_scaled = self.scaler.fit_transform(X_train)
        X_val_scaled = self.scaler.transform(X_val)
        X_test_scaled = self.scaler.transform(X_test)
        
        return {
            'train': (X_train_scaled, y_train),
            'val': (X_val_scaled, y_val),
            'test': (X_test_scaled, y_test)
        }
    
    def engineer_features(self, df: pd.DataFrame) -> pd.DataFrame:
        """Create additional features"""
        
        # Temporal features
        df['days_since_last_review'] = (
            pd.Timestamp.now() - df['last_reviewed']
        ).dt.days
        
        df['days_since_created'] = (
            pd.Timestamp.now() - df['created_at']
        ).dt.days
        
        # Accuracy rate
        df['accuracy_rate'] = df['times_correct'] / (
            df['times_correct'] + df['times_wrong'] + 1
        )
        
        # CEFR numeric
        cefr_map = {'A1': 1, 'A2': 2, 'B1': 3, 'B2': 4, 'C1': 5, 'C2': 6}
        df['cefr_numeric'] = df['cefr'].map(cefr_map)
        df['user_level_numeric'] = df['current_level'].map(cefr_map)
        
        # Difficulty gap
        df['difficulty_gap'] = df['cefr_numeric'] - df['user_level_numeric']
        
        return df
```

### 6.2. Training Script

```python
import lightgbm as lgb
from sklearn.metrics import accuracy_score, f1_score, classification_report
import mlflow

class ModelTrainer:
    def __init__(self, model_type='lightgbm'):
        self.model_type = model_type
        self.model = None
    
    def train(self, X_train, y_train, X_val, y_val):
        """Train model with validation"""
        
        mlflow.start_run()
        
        if self.model_type == 'lightgbm':
            self.model = lgb.LGBMClassifier(
                n_estimators=200,
                max_depth=8,
                learning_rate=0.05,
                num_leaves=31,
                objective='multiclass',
                num_class=4,
                class_weight='balanced',
                random_state=42
            )
            
            self.model.fit(
                X_train, y_train,
                eval_set=[(X_val, y_val)],
                eval_metric='multi_logloss',
                callbacks=[
                    lgb.early_stopping(stopping_rounds=20),
                    lgb.log_evaluation(period=10)
                ]
            )
        
        # Log parameters
        mlflow.log_params(self.model.get_params())
        
        # Evaluate
        y_pred = self.model.predict(X_val)
        accuracy = accuracy_score(y_val, y_pred)
        f1 = f1_score(y_val, y_pred, average='weighted')
        
        mlflow.log_metrics({
            'accuracy': accuracy,
            'f1_score': f1
        })
        
        print(f"Validation Accuracy: {accuracy:.4f}")
        print(f"Validation F1-Score: {f1:.4f}")
        print("\nClassification Report:")
        print(classification_report(y_val, y_pred))
        
        # Save model
        mlflow.sklearn.log_model(self.model, "model")
        
        mlflow.end_run()
        
        return self.model
    
    def get_feature_importance(self, feature_names):
        """Get feature importance"""
        importance = pd.DataFrame({
            'feature': feature_names,
            'importance': self.model.feature_importances_
        }).sort_values('importance', ascending=False)
        
        return importance
```


## 7. Inference & Prediction Service

### 7.1. Real-time Prediction API

```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib
import numpy as np

app = FastAPI()

# Load model at startup
model = joblib.load('models/lightgbm_status_predictor.pkl')
scaler = joblib.load('models/scaler.pkl')

class PredictionRequest(BaseModel):
    user_id: str
    vocab_id: str
    # Features will be fetched from DB

class PredictionResponse(BaseModel):
    vocab_id: str
    current_status: str
    predicted_status: str
    status_probabilities: dict
    success_probability: float
    confidence: float
    recommendation: str

@app.post("/api/v1/predict/status", response_model=PredictionResponse)
async def predict_status(request: PredictionRequest):
    """
    Predict next status for a vocabulary
    """
    
    # Fetch features from database
    features = await fetch_features(request.user_id, request.vocab_id)
    
    # Prepare feature vector
    X = create_feature_vector(features)
    X_scaled = scaler.transform(X.reshape(1, -1))
    
    # Predict
    probabilities = model.predict_proba(X_scaled)[0]
    predicted_class = model.predict(X_scaled)[0]
    
    # Map to status names
    status_map = {0: 'NEW', 1: 'UNKNOWN', 2: 'KNOWN', 3: 'MASTERED'}
    predicted_status = status_map[predicted_class]
    
    status_probs = {
        status_map[i]: float(prob) 
        for i, prob in enumerate(probabilities)
    }
    
    # Calculate confidence
    confidence = float(np.max(probabilities))
    
    # Generate recommendation
    recommendation = generate_recommendation(
        features['current_status'],
        predicted_status,
        status_probs,
        confidence
    )
    
    return PredictionResponse(
        vocab_id=request.vocab_id,
        current_status=features['current_status'],
        predicted_status=predicted_status,
        status_probabilities=status_probs,
        success_probability=status_probs.get('KNOWN', 0) + status_probs.get('MASTERED', 0),
        confidence=confidence,
        recommendation=recommendation
    )

def generate_recommendation(current, predicted, probs, confidence):
    """Generate human-readable recommendation"""
    
    if predicted == 'MASTERED' and confidence > 0.7:
        return "Từ này bạn sắp thành thạo! Ôn tập thêm 2-3 lần nữa."
    
    elif predicted == 'UNKNOWN' and current == 'KNOWN':
        return "Cảnh báo: Từ này có nguy cơ quên. Nên ôn tập ngay!"
    
    elif predicted == 'KNOWN' and current == 'UNKNOWN':
        return "Tốt! Bạn đang tiến bộ với từ này. Tiếp tục luyện tập."
    
    elif probs['MASTERED'] > 0.3:
        return "Bạn đang làm rất tốt! Còn một chút nữa là thành thạo."
    
    else:
        return "Tiếp tục ôn tập đều đặn để cải thiện."
```

### 7.2. Batch Prediction for Smart Review

```python
@app.post("/api/v1/review/smart-ml")
async def get_smart_review_ml(
    user_id: str,
    limit: int = 20,
    strategy: str = "optimal_difficulty"
):
    """
    Get smart review recommendations using ML predictions
    
    Strategies:
    - optimal_difficulty: Focus on vocabs with 40-60% success probability
    - at_risk: Focus on vocabs likely to be forgotten
    - ready_to_master: Focus on vocabs close to mastery
    - balanced: Mix of all above
    """
    
    # Get all vocabs for user with status NEW, UNKNOWN, KNOWN
    vocabs = await get_user_vocabs(user_id, exclude_mastered=True)
    
    # Batch prediction
    predictions = []
    for vocab in vocabs:
        features = await fetch_features(user_id, vocab.id)
        X = create_feature_vector(features)
        X_scaled = scaler.transform(X.reshape(1, -1))
        
        probs = model.predict_proba(X_scaled)[0]
        success_prob = probs[2] + probs[3]  # KNOWN + MASTERED
        
        predictions.append({
            'vocab_id': vocab.id,
            'vocab': vocab,
            'success_probability': success_prob,
            'status_probs': probs,
            'features': features
        })
    
    # Apply strategy
    if strategy == "optimal_difficulty":
        # Sort by how close to 50% (optimal challenge)
        predictions.sort(key=lambda x: abs(x['success_probability'] - 0.5))
    
    elif strategy == "at_risk":
        # Vocabs with declining performance
        predictions = [p for p in predictions if p['status_probs'][1] > 0.3]  # High UNKNOWN prob
        predictions.sort(key=lambda x: x['status_probs'][1], reverse=True)
    
    elif strategy == "ready_to_master":
        # Vocabs close to mastery
        predictions = [p for p in predictions if p['status_probs'][3] > 0.2]  # Some MASTERED prob
        predictions.sort(key=lambda x: x['status_probs'][3], reverse=True)
    
    elif strategy == "balanced":
        # Mix of all strategies
        optimal = sorted(predictions, key=lambda x: abs(x['success_probability'] - 0.5))[:limit//3]
        at_risk = sorted([p for p in predictions if p['status_probs'][1] > 0.3], 
                        key=lambda x: x['status_probs'][1], reverse=True)[:limit//3]
        ready = sorted([p for p in predictions if p['status_probs'][3] > 0.2],
                      key=lambda x: x['status_probs'][3], reverse=True)[:limit//3]
        
        predictions = optimal + at_risk + ready
        random.shuffle(predictions)
    
    # Return top N
    return {
        'vocabs': [p['vocab'] for p in predictions[:limit]],
        'meta': {
            'strategy': strategy,
            'total_candidates': len(vocabs),
            'avg_success_probability': np.mean([p['success_probability'] for p in predictions[:limit]])
        }
    }
```

## 8. Advanced Features

### 8.1. Personalized Learning Path

```python
class LearningPathGenerator:
    """Generate personalized learning path using ML predictions"""
    
    def __init__(self, model, scaler):
        self.model = model
        self.scaler = scaler
    
    async def generate_path(self, user_id: str, days: int = 30):
        """
        Generate optimal learning path for next N days
        
        Returns:
            {
                'day_1': [vocab_ids],
                'day_2': [vocab_ids],
                ...
            }
        """
        
        # Get all vocabs
        vocabs = await get_user_vocabs(user_id, exclude_mastered=True)
        
        # Predict optimal review time for each vocab
        vocab_schedule = []
        for vocab in vocabs:
            features = await fetch_features(user_id, vocab.id)
            
            # Predict when to review next
            optimal_days = self.predict_optimal_review_time(features)
            
            vocab_schedule.append({
                'vocab_id': vocab.id,
                'optimal_review_day': optimal_days,
                'priority': self.calculate_priority(features)
            })
        
        # Distribute vocabs across days
        learning_path = {}
        for day in range(1, days + 1):
            # Get vocabs scheduled for this day
            day_vocabs = [
                v for v in vocab_schedule 
                if abs(v['optimal_review_day'] - day) < 2
            ]
            
            # Sort by priority
            day_vocabs.sort(key=lambda x: x['priority'], reverse=True)
            
            # Limit to 20 vocabs per day
            learning_path[f'day_{day}'] = [v['vocab_id'] for v in day_vocabs[:20]]
        
        return learning_path
    
    def predict_optimal_review_time(self, features: dict) -> int:
        """Predict optimal number of days until next review"""
        
        # Use regression model or heuristic based on status probabilities
        X = create_feature_vector(features)
        X_scaled = self.scaler.transform(X.reshape(1, -1))
        
        probs = self.model.predict_proba(X_scaled)[0]
        
        # Heuristic: Higher mastery → longer interval
        mastery_score = probs[2] * 0.5 + probs[3] * 1.0  # KNOWN + MASTERED
        
        if mastery_score > 0.8:
            return 7  # Review in 1 week
        elif mastery_score > 0.6:
            return 3  # Review in 3 days
        elif mastery_score > 0.4:
            return 1  # Review tomorrow
        else:
            return 0  # Review today
```

### 8.2. Adaptive Difficulty

```python
class AdaptiveDifficultyEngine:
    """Adjust difficulty based on user performance predictions"""
    
    def __init__(self, model):
        self.model = model
    
    async def get_adaptive_vocabs(self, user_id: str, target_accuracy: float = 0.7):
        """
        Get vocabs that match target accuracy level
        
        Args:
            target_accuracy: Desired success rate (0.5-0.9)
                - 0.5-0.6: Challenging
                - 0.6-0.8: Optimal (flow state)
                - 0.8-0.9: Confidence building
        """
        
        vocabs = await get_user_vocabs(user_id, exclude_mastered=True)
        
        # Predict success probability for each vocab
        candidates = []
        for vocab in vocabs:
            features = await fetch_features(user_id, vocab.id)
            X = create_feature_vector(features)
            X_scaled = scaler.transform(X.reshape(1, -1))
            
            probs = self.model.predict_proba(X_scaled)[0]
            success_prob = probs[2] + probs[3]  # KNOWN + MASTERED
            
            # Calculate distance from target
            distance = abs(success_prob - target_accuracy)
            
            candidates.append({
                'vocab': vocab,
                'success_prob': success_prob,
                'distance': distance
            })
        
        # Sort by closest to target
        candidates.sort(key=lambda x: x['distance'])
        
        return [c['vocab'] for c in candidates[:20]]
```

### 8.3. Forgetting Curve Prediction

```python
class ForgettingCurvePredictor:
    """Predict when user will forget a vocabulary"""
    
    def __init__(self, model):
        self.model = model
    
    async def predict_forgetting_time(self, user_id: str, vocab_id: str) -> dict:
        """
        Predict when user will likely forget this vocab
        
        Returns:
            {
                'days_until_forgotten': int,
                'confidence': float,
                'recommended_review_date': date
            }
        """
        
        features = await fetch_features(user_id, vocab_id)
        
        # Simulate future states
        forgetting_probs = []
        for days_ahead in range(1, 31):
            # Modify features to simulate future
            future_features = features.copy()
            future_features['days_since_last_review'] += days_ahead
            
            X = create_feature_vector(future_features)
            X_scaled = scaler.transform(X.reshape(1, -1))
            
            probs = self.model.predict_proba(X_scaled)[0]
            unknown_prob = probs[1]  # Probability of UNKNOWN status
            
            forgetting_probs.append({
                'days': days_ahead,
                'forget_prob': unknown_prob
            })
        
        # Find when forget_prob exceeds threshold (e.g., 0.5)
        threshold = 0.5
        days_until_forgotten = next(
            (fp['days'] for fp in forgetting_probs if fp['forget_prob'] > threshold),
            30  # Default to 30 days
        )
        
        # Recommend review before forgetting
        recommended_days = max(1, days_until_forgotten - 2)
        
        return {
            'days_until_forgotten': days_until_forgotten,
            'confidence': 1.0 - forgetting_probs[days_until_forgotten - 1]['forget_prob'],
            'recommended_review_date': date.today() + timedelta(days=recommended_days),
            'forgetting_curve': forgetting_probs
        }
```


## 9. Model Evaluation & Monitoring

### 9.1. Evaluation Metrics

```python
from sklearn.metrics import (
    accuracy_score, precision_recall_fscore_support,
    confusion_matrix, classification_report, roc_auc_score
)
import matplotlib.pyplot as plt
import seaborn as sns

class ModelEvaluator:
    def __init__(self, model, X_test, y_test, label_names):
        self.model = model
        self.X_test = X_test
        self.y_test = y_test
        self.label_names = label_names
        self.y_pred = model.predict(X_test)
        self.y_pred_proba = model.predict_proba(X_test)
    
    def evaluate_all(self):
        """Run all evaluation metrics"""
        
        print("=" * 60)
        print("MODEL EVALUATION REPORT")
        print("=" * 60)
        
        # Overall metrics
        accuracy = accuracy_score(self.y_test, self.y_pred)
        print(f"\nOverall Accuracy: {accuracy:.4f}")
        
        # Per-class metrics
        precision, recall, f1, support = precision_recall_fscore_support(
            self.y_test, self.y_pred, average=None
        )
        
        print("\nPer-Class Metrics:")
        print("-" * 60)
        for i, label in enumerate(self.label_names):
            print(f"{label:12} | Precision: {precision[i]:.4f} | "
                  f"Recall: {recall[i]:.4f} | F1: {f1[i]:.4f} | "
                  f"Support: {support[i]}")
        
        # Weighted average
        precision_w, recall_w, f1_w, _ = precision_recall_fscore_support(
            self.y_test, self.y_pred, average='weighted'
        )
        print("-" * 60)
        print(f"{'Weighted Avg':12} | Precision: {precision_w:.4f} | "
              f"Recall: {recall_w:.4f} | F1: {f1_w:.4f}")
        
        # Confusion matrix
        self.plot_confusion_matrix()
        
        # ROC-AUC (for multi-class)
        try:
            auc = roc_auc_score(self.y_test, self.y_pred_proba, 
                               multi_class='ovr', average='weighted')
            print(f"\nWeighted ROC-AUC: {auc:.4f}")
        except:
            print("\nROC-AUC: Not available for this dataset")
        
        # Classification report
        print("\nDetailed Classification Report:")
        print(classification_report(self.y_test, self.y_pred, 
                                   target_names=self.label_names))
    
    def plot_confusion_matrix(self):
        """Plot confusion matrix"""
        cm = confusion_matrix(self.y_test, self.y_pred)
        
        plt.figure(figsize=(10, 8))
        sns.heatmap(cm, annot=True, fmt='d', cmap='Blues',
                   xticklabels=self.label_names,
                   yticklabels=self.label_names)
        plt.title('Confusion Matrix')
        plt.ylabel('True Label')
        plt.xlabel('Predicted Label')
        plt.tight_layout()
        plt.savefig('confusion_matrix.png')
        print("\nConfusion matrix saved to: confusion_matrix.png")
    
    def analyze_errors(self):
        """Analyze misclassified samples"""
        errors = self.X_test[self.y_test != self.y_pred]
        error_true = self.y_test[self.y_test != self.y_pred]
        error_pred = self.y_pred[self.y_test != self.y_pred]
        
        print(f"\nTotal Errors: {len(errors)} / {len(self.y_test)} "
              f"({len(errors)/len(self.y_test)*100:.2f}%)")
        
        # Most common error patterns
        error_patterns = {}
        for true, pred in zip(error_true, error_pred):
            pattern = f"{self.label_names[true]} → {self.label_names[pred]}"
            error_patterns[pattern] = error_patterns.get(pattern, 0) + 1
        
        print("\nMost Common Error Patterns:")
        for pattern, count in sorted(error_patterns.items(), 
                                     key=lambda x: x[1], reverse=True)[:5]:
            print(f"  {pattern}: {count} times")
```

### 9.2. Online Monitoring

```python
from prometheus_client import Counter, Histogram, Gauge
import structlog

logger = structlog.get_logger()

# Metrics
prediction_counter = Counter(
    'ml_predictions_total',
    'Total ML predictions',
    ['model_version', 'predicted_status']
)

prediction_latency = Histogram(
    'ml_prediction_latency_seconds',
    'ML prediction latency',
    buckets=[0.01, 0.05, 0.1, 0.5, 1.0]
)

model_accuracy = Gauge(
    'ml_model_accuracy',
    'Current model accuracy',
    ['model_version']
)

class PredictionMonitor:
    """Monitor predictions in production"""
    
    def __init__(self):
        self.predictions_buffer = []
        self.ground_truth_buffer = []
    
    async def log_prediction(self, user_id: str, vocab_id: str, 
                           prediction: dict, features: dict):
        """Log prediction for monitoring"""
        
        logger.info(
            "ml_prediction",
            user_id=user_id,
            vocab_id=vocab_id,
            predicted_status=prediction['predicted_status'],
            confidence=prediction['confidence'],
            current_status=features['current_status']
        )
        
        # Update metrics
        prediction_counter.labels(
            model_version='v1.0',
            predicted_status=prediction['predicted_status']
        ).inc()
        
        # Store for later evaluation
        self.predictions_buffer.append({
            'user_id': user_id,
            'vocab_id': vocab_id,
            'prediction': prediction,
            'timestamp': datetime.now()
        })
    
    async def collect_ground_truth(self):
        """
        Collect actual outcomes after users review vocabs
        Compare with predictions to calculate online accuracy
        """
        
        # Query actual status changes
        for pred in self.predictions_buffer:
            actual_status = await get_current_status(
                pred['user_id'], 
                pred['vocab_id']
            )
            
            if actual_status != pred['prediction']['current_status']:
                # Status changed, compare with prediction
                predicted = pred['prediction']['predicted_status']
                correct = (actual_status == predicted)
                
                self.ground_truth_buffer.append({
                    'predicted': predicted,
                    'actual': actual_status,
                    'correct': correct
                })
        
        # Calculate online accuracy
        if len(self.ground_truth_buffer) > 100:
            accuracy = sum(g['correct'] for g in self.ground_truth_buffer) / len(self.ground_truth_buffer)
            model_accuracy.labels(model_version='v1.0').set(accuracy)
            
            logger.info(
                "online_accuracy_update",
                accuracy=accuracy,
                sample_size=len(self.ground_truth_buffer)
            )
```

### 9.3. A/B Testing Framework

```python
import random
from enum import Enum

class ReviewStrategy(Enum):
    BASELINE = "baseline"  # SM-2 algorithm
    ML_OPTIMAL = "ml_optimal"  # ML with optimal difficulty
    ML_BALANCED = "ml_balanced"  # ML with balanced strategy
    ML_ADAPTIVE = "ml_adaptive"  # ML with adaptive difficulty

class ABTestManager:
    """Manage A/B testing for different review strategies"""
    
    def __init__(self):
        self.strategy_weights = {
            ReviewStrategy.BASELINE: 0.25,
            ReviewStrategy.ML_OPTIMAL: 0.25,
            ReviewStrategy.ML_BALANCED: 0.25,
            ReviewStrategy.ML_ADAPTIVE: 0.25
        }
    
    def assign_strategy(self, user_id: str) -> ReviewStrategy:
        """Assign user to a strategy group"""
        
        # Consistent assignment based on user_id hash
        hash_value = hash(user_id) % 100
        
        cumulative = 0
        for strategy, weight in self.strategy_weights.items():
            cumulative += weight * 100
            if hash_value < cumulative:
                return strategy
        
        return ReviewStrategy.BASELINE
    
    async def get_review_vocabs(self, user_id: str, limit: int = 20):
        """Get review vocabs based on assigned strategy"""
        
        strategy = self.assign_strategy(user_id)
        
        logger.info(
            "ab_test_assignment",
            user_id=user_id,
            strategy=strategy.value
        )
        
        if strategy == ReviewStrategy.BASELINE:
            # Use traditional SM-2 algorithm
            return await get_sm2_review_vocabs(user_id, limit)
        
        elif strategy == ReviewStrategy.ML_OPTIMAL:
            return await get_smart_review_ml(user_id, limit, "optimal_difficulty")
        
        elif strategy == ReviewStrategy.ML_BALANCED:
            return await get_smart_review_ml(user_id, limit, "balanced")
        
        elif strategy == ReviewStrategy.ML_ADAPTIVE:
            engine = AdaptiveDifficultyEngine(model)
            return await engine.get_adaptive_vocabs(user_id, target_accuracy=0.7)
    
    async def analyze_results(self):
        """Analyze A/B test results"""
        
        query = """
        SELECT 
            ab_test_group,
            COUNT(DISTINCT user_id) as users,
            AVG(review_completion_rate) as avg_completion,
            AVG(accuracy_rate) as avg_accuracy,
            AVG(time_to_master) as avg_time_to_master,
            AVG(retention_7d) as retention_7d
        FROM ab_test_metrics
        GROUP BY ab_test_group
        """
        
        results = await execute_query(query)
        
        print("\nA/B Test Results:")
        print("=" * 80)
        for row in results:
            print(f"\nStrategy: {row['ab_test_group']}")
            print(f"  Users: {row['users']}")
            print(f"  Completion Rate: {row['avg_completion']:.2%}")
            print(f"  Accuracy: {row['avg_accuracy']:.2%}")
            print(f"  Time to Master: {row['avg_time_to_master']:.1f} days")
            print(f"  7-day Retention: {row['retention_7d']:.2%}")
```

## 10. Deployment Strategy

### 10.1. Model Versioning

```python
import mlflow
from datetime import datetime

class ModelRegistry:
    """Manage model versions and deployment"""
    
    def __init__(self):
        mlflow.set_tracking_uri("http://mlflow-server:5000")
    
    def register_model(self, model, model_name: str, metrics: dict):
        """Register new model version"""
        
        with mlflow.start_run():
            # Log model
            mlflow.sklearn.log_model(model, "model")
            
            # Log metrics
            mlflow.log_metrics(metrics)
            
            # Log parameters
            mlflow.log_params(model.get_params())
            
            # Register model
            model_uri = f"runs:/{mlflow.active_run().info.run_id}/model"
            mlflow.register_model(model_uri, model_name)
            
            version = self.get_latest_version(model_name)
            
            logger.info(
                "model_registered",
                model_name=model_name,
                version=version,
                metrics=metrics
            )
            
            return version
    
    def promote_to_production(self, model_name: str, version: int):
        """Promote model version to production"""
        
        client = mlflow.tracking.MlflowClient()
        
        # Archive current production model
        current_prod = client.get_latest_versions(model_name, stages=["Production"])
        for model in current_prod:
            client.transition_model_version_stage(
                name=model_name,
                version=model.version,
                stage="Archived"
            )
        
        # Promote new version
        client.transition_model_version_stage(
            name=model_name,
            version=version,
            stage="Production"
        )
        
        logger.info(
            "model_promoted",
            model_name=model_name,
            version=version
        )
    
    def load_production_model(self, model_name: str):
        """Load current production model"""
        
        model_uri = f"models:/{model_name}/Production"
        model = mlflow.sklearn.load_model(model_uri)
        
        return model
```

### 10.2. Continuous Training Pipeline

```python
from apscheduler.schedulers.asyncio import AsyncIOScheduler

class ContinuousTrainingPipeline:
    """Automated model retraining pipeline"""
    
    def __init__(self):
        self.scheduler = AsyncIOScheduler()
        self.model_registry = ModelRegistry()
    
    def start(self):
        """Start continuous training schedule"""
        
        # Retrain weekly
        self.scheduler.add_job(
            self.retrain_model,
            'cron',
            day_of_week='sun',
            hour=2,
            minute=0
        )
        
        # Evaluate daily
        self.scheduler.add_job(
            self.evaluate_production_model,
            'cron',
            hour=3,
            minute=0
        )
        
        self.scheduler.start()
        logger.info("continuous_training_started")
    
    async def retrain_model(self):
        """Retrain model with latest data"""
        
        logger.info("retraining_started")
        
        try:
            # Prepare data
            pipeline = DataPipeline()
            data = await pipeline.prepare_training_data()
            
            # Train model
            trainer = ModelTrainer(model_type='lightgbm')
            model = trainer.train(
                data['train'][0], data['train'][1],
                data['val'][0], data['val'][1]
            )
            
            # Evaluate on test set
            y_pred = model.predict(data['test'][0])
            accuracy = accuracy_score(data['test'][1], y_pred)
            f1 = f1_score(data['test'][1], y_pred, average='weighted')
            
            metrics = {
                'test_accuracy': accuracy,
                'test_f1_score': f1
            }
            
            # Register new version
            version = self.model_registry.register_model(
                model,
                "vocab_status_predictor",
                metrics
            )
            
            # Auto-promote if better than current production
            current_model = self.model_registry.load_production_model(
                "vocab_status_predictor"
            )
            current_accuracy = self.evaluate_model(current_model, data['test'])
            
            if accuracy > current_accuracy + 0.01:  # 1% improvement threshold
                self.model_registry.promote_to_production(
                    "vocab_status_predictor",
                    version
                )
                logger.info(
                    "model_auto_promoted",
                    new_accuracy=accuracy,
                    old_accuracy=current_accuracy
                )
            
            logger.info("retraining_completed", metrics=metrics)
            
        except Exception as e:
            logger.error("retraining_failed", error=str(e))
    
    async def evaluate_production_model(self):
        """Evaluate production model performance"""
        
        # Collect recent predictions and ground truth
        monitor = PredictionMonitor()
        await monitor.collect_ground_truth()
        
        # Calculate metrics
        if len(monitor.ground_truth_buffer) > 100:
            accuracy = sum(
                g['correct'] for g in monitor.ground_truth_buffer
            ) / len(monitor.ground_truth_buffer)
            
            logger.info(
                "production_model_evaluation",
                accuracy=accuracy,
                sample_size=len(monitor.ground_truth_buffer)
            )
            
            # Alert if accuracy drops below threshold
            if accuracy < 0.7:
                logger.warning(
                    "model_performance_degradation",
                    accuracy=accuracy,
                    threshold=0.7
                )
                # Trigger retraining
                await self.retrain_model()
```


## 11. Tech Stack Summary

### 11.1. Core ML Libraries

```toml
# pyproject.toml
[tool.poetry.dependencies]
python = "^3.11"

# Web Framework
fastapi = "^0.104.0"
uvicorn = {extras = ["standard"], version = "^0.24.0"}
pydantic = "^2.4.0"

# Machine Learning
scikit-learn = "^1.3.0"
lightgbm = "^4.1.0"
xgboost = "^2.0.0"
numpy = "^1.24.0"
pandas = "^2.0.0"

# Deep Learning (Optional)
torch = "^2.1.0"
pytorch-lightning = "^2.1.0"

# Database
sqlalchemy = "^2.0.0"
asyncpg = "^0.29.0"
alembic = "^1.12.0"

# Caching
redis = "^5.0.0"

# ML Ops
mlflow = "^2.8.0"
optuna = "^3.4.0"  # Hyperparameter tuning

# Monitoring
prometheus-client = "^0.18.0"
structlog = "^23.2.0"

# Utilities
python-dotenv = "^1.0.0"
joblib = "^1.3.0"

[tool.poetry.group.dev.dependencies]
pytest = "^7.4.0"
pytest-asyncio = "^0.21.0"
black = "^23.10.0"
ruff = "^0.1.0"
mypy = "^1.6.0"
```

### 11.2. Infrastructure

```yaml
# docker-compose.yml
version: '3.8'

services:
  # ML API Service
  ml-api:
    build: .
    container_name: card-words-ml-api
    ports:
      - "8001:8001"
    environment:
      - DATABASE_URL=${DATABASE_URL}
      - REDIS_URL=redis://redis:6379/0
      - MLFLOW_TRACKING_URI=http://mlflow:5000
    depends_on:
      - postgres
      - redis
      - mlflow
    volumes:
      - ./models:/app/models
    restart: unless-stopped

  # MLflow Tracking Server
  mlflow:
    image: ghcr.io/mlflow/mlflow:v2.8.0
    container_name: card-words-mlflow
    ports:
      - "5000:5000"
    environment:
      - BACKEND_STORE_URI=postgresql://${DB_USER}:${DB_PASS}@postgres:5432/mlflow
      - DEFAULT_ARTIFACT_ROOT=/mlflow/artifacts
    volumes:
      - mlflow-artifacts:/mlflow/artifacts
    command: >
      mlflow server
      --backend-store-uri postgresql://${DB_USER}:${DB_PASS}@postgres:5432/mlflow
      --default-artifact-root /mlflow/artifacts
      --host 0.0.0.0
      --port 5000
    restart: unless-stopped

  # Redis Cache
  redis:
    image: redis:7-alpine
    container_name: card-words-redis
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    restart: unless-stopped

  # PostgreSQL (shared with main app)
  postgres:
    image: postgres:15-alpine
    container_name: card-words-postgres
    environment:
      - POSTGRES_USER=${DB_USER}
      - POSTGRES_PASSWORD=${DB_PASS}
      - POSTGRES_DB=cardwords
    volumes:
      - postgres-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    restart: unless-stopped

volumes:
  mlflow-artifacts:
  redis-data:
  postgres-data:
```

## 12. Implementation Roadmap

### Phase 1: Data & Features (Tuần 1-2)
**Mục tiêu:** Chuẩn bị dữ liệu và features

- [ ] **Week 1:**
  - [ ] Setup project structure với Poetry
  - [ ] Kết nối database và query data
  - [ ] Exploratory Data Analysis (EDA)
  - [ ] Feature engineering implementation
  - [ ] Data validation và cleaning

- [ ] **Week 2:**
  - [ ] Feature extraction pipeline
  - [ ] Train/val/test split
  - [ ] Feature scaling và encoding
  - [ ] Data versioning với DVC (optional)
  - [ ] Unit tests cho feature engineering

**Deliverables:**
- Clean dataset với features
- Feature engineering pipeline
- Data analysis report

### Phase 2: Model Development (Tuần 3-4)
**Mục tiêu:** Train và evaluate models

- [ ] **Week 3:**
  - [ ] Baseline model (XGBoost)
  - [ ] LightGBM model
  - [ ] Hyperparameter tuning với Optuna
  - [ ] Cross-validation
  - [ ] Model evaluation metrics

- [ ] **Week 4:**
  - [ ] Neural Network model (optional)
  - [ ] LSTM model (optional)
  - [ ] Model comparison
  - [ ] Feature importance analysis
  - [ ] Model selection

**Deliverables:**
- Trained models với metrics
- Model comparison report
- Best model selection

### Phase 3: API Development (Tuần 5)
**Mục tiêu:** Xây dựng prediction API

- [ ] FastAPI endpoints
- [ ] Model loading và caching
- [ ] Request/response schemas
- [ ] Error handling
- [ ] API documentation
- [ ] Integration tests

**Deliverables:**
- Working API với endpoints
- API documentation
- Integration tests

### Phase 4: Advanced Features (Tuần 6)
**Mục tiêu:** Implement advanced ML features

- [ ] Smart review strategies
- [ ] Personalized learning paths
- [ ] Adaptive difficulty
- [ ] Forgetting curve prediction
- [ ] A/B testing framework

**Deliverables:**
- Advanced ML features
- Strategy comparison

### Phase 5: MLOps & Deployment (Tuần 7-8)
**Mục tiêu:** Production-ready deployment

- [ ] **Week 7:**
  - [ ] MLflow integration
  - [ ] Model versioning
  - [ ] Continuous training pipeline
  - [ ] Monitoring và logging
  - [ ] Prometheus metrics

- [ ] **Week 8:**
  - [ ] Docker containerization
  - [ ] CI/CD pipeline
  - [ ] Production deployment
  - [ ] Load testing
  - [ ] Documentation

**Deliverables:**
- Production-ready system
- Monitoring dashboard
- Complete documentation

### Phase 6: Optimization & Iteration (Tuần 9+)
**Mục tiêu:** Optimize và improve

- [ ] Performance optimization
- [ ] A/B test analysis
- [ ] Model fine-tuning
- [ ] Feature engineering improvements
- [ ] User feedback integration

**Deliverables:**
- Optimized system
- A/B test results
- Improvement roadmap

## 13. Success Metrics

### 13.1. ML Model Metrics

**Classification Metrics:**
- Accuracy: > 75%
- F1-Score (weighted): > 0.75
- Per-class recall:
  - NEW → UNKNOWN: > 70%
  - UNKNOWN → KNOWN: > 75%
  - KNOWN → MASTERED: > 80%

**Regression Metrics (Success Probability):**
- MAE (Mean Absolute Error): < 0.15
- RMSE: < 0.20
- R² Score: > 0.70

### 13.2. Business Metrics

**User Engagement:**
- Daily active users: +20%
- Review completion rate: +15%
- Average reviews per session: +25%
- Session duration: +10%

**Learning Effectiveness:**
- Time to master (NEW → MASTERED): -15%
- Retention rate (7-day): +20%
- Accuracy rate: +10%
- Vocabs mastered per month: +30%

**System Performance:**
- API response time (p95): < 200ms
- Model inference time: < 50ms
- Cache hit rate: > 80%
- System uptime: > 99.5%

### 13.3. A/B Test Success Criteria

ML-based review **wins** if:
- Completion rate > baseline + 10%
- Time to master < baseline - 10%
- User satisfaction > baseline + 0.5 points
- 7-day retention > baseline + 15%

## 14. Cost-Benefit Analysis

### 14.1. Development Cost

**Time Investment:**
- Phase 1-2 (Data & Models): 4 tuần × 40h = 160 giờ
- Phase 3-4 (API & Features): 2 tuần × 40h = 80 giờ
- Phase 5-6 (MLOps & Deploy): 2 tuần × 40h = 80 giờ
- **Total:** 320 giờ (~2 tháng full-time)

**Infrastructure Cost (Monthly):**
- ML API server (2 vCPU, 4GB RAM): $40
- MLflow server (1 vCPU, 2GB RAM): $20
- Redis cache (512MB): $15
- Storage (models, artifacts): $10
- **Total:** ~$85/tháng

### 14.2. Expected Benefits

**User Retention:**
- 20% improvement in 7-day retention
- If 1000 users → 200 more retained users
- LTV per user: $10 → $2000 additional revenue/month

**Learning Efficiency:**
- 15% faster time to mastery
- Better user satisfaction → higher word-of-mouth
- Premium conversion rate: +5%

**Competitive Advantage:**
- AI-powered personalization
- Unique selling point
- Market differentiation

**ROI:** 
- Monthly benefit: $2000+
- Monthly cost: $85
- **ROI: ~2300%**

## 15. Risks & Mitigation

### 15.1. Technical Risks

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Model accuracy < 70% | High | Medium | Extensive feature engineering, ensemble methods |
| Insufficient training data | High | Low | Use data augmentation, transfer learning |
| Slow inference time | Medium | Low | Model optimization, caching, async processing |
| Model drift over time | Medium | High | Continuous monitoring, automated retraining |
| Integration issues | Medium | Medium | Thorough testing, gradual rollout |

### 15.2. Business Risks

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Users don't like ML recommendations | High | Medium | A/B testing, user feedback, fallback to baseline |
| Development takes longer | Medium | Medium | Phased approach, MVP first |
| Maintenance overhead | Medium | Low | Automation, good documentation |
| Competitor copies feature | Low | High | Continuous innovation, data moat |

## 16. Comparison: Supervised ML vs K-means

| Aspect | K-means (Unsupervised) | Supervised ML |
|--------|------------------------|---------------|
| **Data Requirement** | No labels needed | Requires labeled data ✅ (We have!) |
| **Accuracy** | Moderate | High ✅ |
| **Personalization** | Limited | Excellent ✅ |
| **Interpretability** | Good | Moderate |
| **Complexity** | Low | High |
| **Maintenance** | Low | Medium |
| **Prediction** | Clustering only | Status, probability, timing ✅ |
| **Adaptability** | Static clusters | Learns from feedback ✅ |

**Recommendation:** Supervised ML vì bạn đã có labels!

## 17. Alternative: Hybrid Approach

Có thể kết hợp cả hai:

### 17.1. Hybrid Architecture

```
1. Use Supervised ML for:
   - Status prediction
   - Success probability
   - Optimal review timing

2. Use K-means for:
   - Initial user segmentation
   - Cold start problem
   - Exploratory analysis

3. Combine:
   - ML predictions → features for K-means
   - K-means clusters → features for ML
```

### 17.2. Implementation

```python
class HybridReviewEngine:
    def __init__(self, ml_model, kmeans_model):
        self.ml_model = ml_model
        self.kmeans_model = kmeans_model
    
    async def get_review_vocabs(self, user_id: str, limit: int = 20):
        # Get ML predictions
        ml_predictions = await self.get_ml_predictions(user_id)
        
        # Get K-means clusters
        clusters = await self.get_kmeans_clusters(user_id)
        
        # Combine: Use ML predictions to rank within clusters
        vocabs = []
        for cluster_id in [0, 1, 2, 3]:  # Priority order
            cluster_vocabs = [
                v for v in ml_predictions 
                if clusters[v['vocab_id']] == cluster_id
            ]
            
            # Sort by ML success probability
            cluster_vocabs.sort(
                key=lambda x: abs(x['success_prob'] - 0.6)
            )
            
            vocabs.extend(cluster_vocabs)
        
        return vocabs[:limit]
```

## 18. Next Steps

### 18.1. Immediate Actions

1. **Data Analysis** (1-2 ngày)
   - Query UserVocabProgress data
   - Analyze label distribution
   - Check data quality
   - Calculate baseline metrics

2. **Proof of Concept** (3-5 ngày)
   - Simple LightGBM model
   - Basic features
   - Train/test split
   - Evaluate accuracy

3. **Decision Point**
   - If PoC accuracy > 70% → Continue
   - If < 70% → Revisit features or use K-means

### 18.2. Questions to Answer

1. **Data:**
   - Bao nhiêu records trong UserVocabProgress?
   - Label distribution? (NEW/UNKNOWN/KNOWN/MASTERED)
   - Có đủ data cho mỗi class không?

2. **Business:**
   - Mục tiêu chính là gì? (Retention? Engagement? Learning speed?)
   - Timeline mong muốn?
   - Resources available?

3. **Technical:**
   - Infrastructure hiện tại?
   - Team có experience với ML không?
   - Preference: Simple (LightGBM) hay Advanced (Deep Learning)?

## 19. Conclusion

### 19.1. Recommendation

**Sử dụng Supervised ML (LightGBM)** vì:

✅ Bạn đã có labels (status)  
✅ Accuracy cao hơn K-means  
✅ Có thể dự đoán được outcomes  
✅ Personalization tốt hơn  
✅ Measurable improvements  
✅ Production-ready với LightGBM  

### 19.2. Suggested Approach

**Phase 1 (MVP - 4 tuần):**
1. LightGBM classification model
2. Basic features (30-40 features)
3. Simple API endpoints
4. A/B testing framework

**Phase 2 (Advanced - 4 tuần):**
1. Advanced features
2. LSTM for temporal patterns
3. Personalized learning paths
4. MLOps pipeline

**Phase 3 (Optimization - Ongoing):**
1. Continuous improvement
2. Feature engineering
3. Model fine-tuning
4. User feedback integration

### 19.3. Expected Outcome

Sau 2-3 tháng:
- ML model với accuracy > 75%
- Smart review API hoạt động tốt
- User engagement tăng 20%+
- Learning efficiency cải thiện 15%+
- Competitive advantage rõ ràng

---

**Tác giả:** AI Assistant  
**Ngày tạo:** 2024-11-16  
**Phiên bản:** 1.0  
**Status:** Proposal - Ready for Implementation

**Contact:** Sẵn sàng hỗ trợ implementation! 🚀
