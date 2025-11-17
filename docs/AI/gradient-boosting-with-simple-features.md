# Gradient Boosting Cho Gợi Ý Ôn Tập - Dựa Trên Status & Accuracy

## Tổng Quan

**Mục tiêu:** Sử dụng Gradient Boosting (XGBoost/LightGBM) để dự đoán xác suất user sẽ quên một từ vựng, dựa trên:
- `status` (NEW, KNOWN, UNKNOWN, MASTERED)
- `times_correct`, `times_wrong`
- `next_review_date`, `last_reviewed`
- `interval_days`, `repetition`
- User stats (total vocabs, accuracy)
- Vocab features (difficulty, length)

## Chiến Lược Training

### Target Definition

**Cách 1: Accuracy-Based (RECOMMENDED)**

```sql
-- Target: Dự đoán dựa trên accuracy_rate
CASE 
    WHEN times_correct + times_wrong = 0 THEN NULL
    WHEN times_correct::numeric / (times_correct + times_wrong) < 0.5 THEN 1  -- Quên
    ELSE 0  -- Nhớ
END as forgot
```

**Cách 2: Status-Based**

```sql
-- Target: Dự đoán dựa trên status
CASE 
    WHEN status = 'UNKNOWN' THEN 1  -- Quên
    WHEN status IN ('KNOWN', 'MASTERED') THEN 0  -- Nhớ
    ELSE NULL
END as forgot
```

**Cách 3: Hybrid (BEST)**

```sql
-- Kết hợp cả 2
CASE 
    WHEN status = 'UNKNOWN' THEN 1
    WHEN status = 'MASTERED' THEN 0
    WHEN times_correct + times_wrong > 0 THEN
        CASE 
            WHEN times_correct::numeric / (times_correct + times_wrong) < 0.5 THEN 1
            ELSE 0
        END
    ELSE NULL
END as forgot
```

## Features List

### 1. User Features (4 features)
```
- user_total_vocabs: Tổng số từ đã học
- user_accuracy: Độ chính xác trung bình
- user_streak: Chuỗi ngày học liên tục
- user_total_study_days: Tổng số ngày đã học
```

### 2. Vocab Features (2 features)
```
- vocab_difficulty: 1-6 (A1-C2)
- vocab_length: Độ dài từ
```

### 3. Progress Features (13 features)
```
- times_correct: Số lần đúng
- times_wrong: Số lần sai
- accuracy_rate: times_correct / (times_correct + times_wrong)
- repetition: Số lần đã ôn tập
- ef_factor: Easiness Factor từ SM-2
- interval_days: Khoảng cách ôn tập
- days_since_last_review: Số ngày kể từ lần ôn cuối
- days_until_next_review: Số ngày đến lần ôn tiếp theo
- is_overdue: Có quá hạn không (0/1)
- overdue_days: Số ngày quá hạn
- status_new: status == NEW (0/1)
- status_known: status == KNOWN (0/1)
- status_unknown: status == UNKNOWN (0/1)
- status_mastered: status == MASTERED (0/1)
```

### 4. Temporal Features (3 features)
```
- hour_of_day: Giờ trong ngày
- day_of_week: Thứ trong tuần
- is_weekend: Cuối tuần (0/1)
```

**Tổng: 22 features**


## Spring Boot: Export Training Data

### SQL Query

```sql
WITH user_stats AS (
    SELECT 
        u.id as user_id,
        COUNT(DISTINCT uvp.vocab_id) as total_vocabs,
        AVG(CASE 
            WHEN uvp.times_correct + uvp.times_wrong > 0 
            THEN uvp.times_correct::numeric / (uvp.times_correct + uvp.times_wrong)
            ELSE 0 
        END) as user_accuracy,
        u.current_streak,
        u.total_study_days
    FROM users u
    LEFT JOIN user_vocab_progress uvp ON u.id = uvp.user_id
    GROUP BY u.id
)
SELECT 
    uvp.user_id,
    uvp.vocab_id,
    v.word,
    
    -- User features
    us.total_vocabs as user_total_vocabs,
    us.user_accuracy,
    us.current_streak as user_streak,
    us.total_study_days,
    
    -- Vocab features
    CASE v.cefr 
        WHEN 'A1' THEN 1 WHEN 'A2' THEN 2 
        WHEN 'B1' THEN 3 WHEN 'B2' THEN 4 
        WHEN 'C1' THEN 5 WHEN 'C2' THEN 6 
        ELSE 3 
    END as vocab_difficulty,
    LENGTH(v.word) as vocab_length,
    
    -- Progress features
    uvp.times_correct,
    uvp.times_wrong,
    CASE 
        WHEN uvp.times_correct + uvp.times_wrong > 0 
        THEN uvp.times_correct::numeric / (uvp.times_correct + uvp.times_wrong)
        ELSE 0 
    END as accuracy_rate,
    uvp.repetition,
    uvp.ef_factor,
    uvp.interval_days,
    COALESCE(EXTRACT(DAY FROM (CURRENT_DATE - uvp.last_reviewed)), 999) as days_since_last_review,
    COALESCE(EXTRACT(DAY FROM (uvp.next_review_date - CURRENT_DATE)), 0) as days_until_next_review,
    CASE WHEN uvp.next_review_date < CURRENT_DATE THEN 1 ELSE 0 END as is_overdue,
    CASE 
        WHEN uvp.next_review_date < CURRENT_DATE 
        THEN EXTRACT(DAY FROM (CURRENT_DATE - uvp.next_review_date))
        ELSE 0 
    END as overdue_days,
    
    -- Status as one-hot encoding
    CASE WHEN uvp.status = 'NEW' THEN 1 ELSE 0 END as status_new,
    CASE WHEN uvp.status = 'KNOWN' THEN 1 ELSE 0 END as status_known,
    CASE WHEN uvp.status = 'UNKNOWN' THEN 1 ELSE 0 END as status_unknown,
    CASE WHEN uvp.status = 'MASTERED' THEN 1 ELSE 0 END as status_mastered,
    
    -- Temporal features
    EXTRACT(HOUR FROM uvp.updated_at) as hour_of_day,
    EXTRACT(DOW FROM uvp.updated_at) as day_of_week,
    CASE WHEN EXTRACT(DOW FROM uvp.updated_at) IN (0, 6) THEN 1 ELSE 0 END as is_weekend,
    
    -- Target: Hybrid approach
    CASE 
        WHEN uvp.status = 'UNKNOWN' THEN 1
        WHEN uvp.status = 'MASTERED' THEN 0
        WHEN uvp.times_correct + uvp.times_wrong > 0 THEN
            CASE 
                WHEN uvp.times_correct::numeric / (uvp.times_correct + uvp.times_wrong) < 0.5 THEN 1
                ELSE 0
            END
        ELSE NULL
    END as forgot,
    
    uvp.status as status_label,
    uvp.updated_at as recorded_at
    
FROM user_vocab_progress uvp
JOIN vocabs v ON uvp.vocab_id = v.id
JOIN user_stats us ON uvp.user_id = us.user_id
WHERE uvp.times_correct + uvp.times_wrong > 0  -- Chỉ lấy vocab đã có attempts
    AND uvp.updated_at >= CURRENT_DATE - INTERVAL '6 months'
ORDER BY uvp.updated_at DESC;
```

### Repository Method

```java
@Query(value = """
    [SQL query ở trên]
    """, nativeQuery = true)
List<Object[]> getTrainingDataForGradientBoosting();
```


## Python: Training Script

### Complete Training Pipeline

```python
# train_gradient_boosting.py
import requests
import pandas as pd
import numpy as np
import xgboost as xgb
import lightgbm as lgb
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.metrics import roc_auc_score, classification_report, confusion_matrix
import joblib
import matplotlib.pyplot as plt

class GradientBoostingTrainer:
    def __init__(self, api_url, admin_token, model_type='xgboost'):
        """
        model_type: 'xgboost' hoặc 'lightgbm'
        """
        self.api_url = api_url
        self.admin_token = admin_token
        self.model_type = model_type
        self.model = None
        
        self.feature_columns = [
            # User features (4)
            'user_total_vocabs', 'user_accuracy', 'user_streak', 'user_total_study_days',
            
            # Vocab features (2)
            'vocab_difficulty', 'vocab_length',
            
            # Progress features (13)
            'times_correct', 'times_wrong', 'accuracy_rate',
            'repetition', 'ef_factor', 'interval_days',
            'days_since_last_review', 'days_until_next_review',
            'is_overdue', 'overdue_days',
            'status_new', 'status_known', 'status_unknown', 'status_mastered',
            
            # Temporal features (3)
            'hour_of_day', 'day_of_week', 'is_weekend'
        ]
    
    def fetch_data(self):
        """
        Fetch training data từ Spring Boot API
        """
        print("🔄 Fetching training data from API...")
        
        url = f"{self.api_url}/api/v1/training-data/export"
        headers = {'Authorization': f'Bearer {self.admin_token}'}
        
        response = requests.get(url, headers=headers, timeout=120)
        response.raise_for_status()
        
        data = response.json()
        
        if not data['success']:
            raise Exception(f"API error: {data.get('message')}")
        
        records = data['data']['records']
        stats = data['data']['statistics']
        
        print(f"✅ Fetched {len(records)} records")
        print(f"📊 Statistics:")
        print(f"   - Total users: {stats['totalUsers']}")
        print(f"   - Total vocabs: {stats['totalVocabs']}")
        print(f"   - Forgot count: {stats['forgotCount']}")
        print(f"   - Remembered count: {stats['rememberedCount']}")
        print(f"   - Forgot rate: {stats['forgotRate']:.2%}")
        
        df = pd.DataFrame(records)
        
        return df, stats
    
    def prepare_data(self, df):
        """
        Prepare features and target
        """
        print("\n📊 Preparing data...")
        
        # Check missing values
        missing = df[self.feature_columns + ['forgot']].isnull().sum()
        if missing.sum() > 0:
            print(f"⚠️  Missing values found:")
            print(missing[missing > 0])
            
            # Fill missing
            df = df.fillna({
                'user_streak': 0,
                'user_total_study_days': 0,
                'hour_of_day': 12,
                'day_of_week': 3,
                'is_weekend': 0
            })
        
        # Features and target
        X = df[self.feature_columns]
        y = df['forgot']
        
        # Remove null targets
        mask = y.notna()
        X = X[mask]
        y = y[mask]
        
        print(f"✅ Features shape: {X.shape}")
        print(f"✅ Target distribution:")
        print(y.value_counts())
        print(f"   Forgot rate: {y.mean():.2%}")
        
        return X, y
    
    def train_xgboost(self, X, y):
        """
        Train XGBoost model
        """
        print("\n🤖 Training XGBoost model...")
        
        # Split
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42, stratify=y
        )
        
        print(f"Train: {len(X_train)}, Test: {len(X_test)}")
        
        # Calculate scale_pos_weight
        scale_pos_weight = (y_train == 0).sum() / (y_train == 1).sum()
        print(f"Scale pos weight: {scale_pos_weight:.2f}")
        
        # Train
        model = xgb.XGBClassifier(
            n_estimators=200,
            max_depth=6,
            learning_rate=0.1,
            subsample=0.8,
            colsample_bytree=0.8,
            min_child_weight=3,
            gamma=0.1,
            reg_alpha=0.1,
            reg_lambda=1.0,
            scale_pos_weight=scale_pos_weight,
            objective='binary:logistic',
            eval_metric='auc',
            random_state=42,
            n_jobs=-1
        )
        
        model.fit(
            X_train, y_train,
            eval_set=[(X_test, y_test)],
            early_stopping_rounds=20,
            verbose=10
        )
        
        return model, X_test, y_test
    
    def train_lightgbm(self, X, y):
        """
        Train LightGBM model
        """
        print("\n🤖 Training LightGBM model...")
        
        # Split
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42, stratify=y
        )
        
        print(f"Train: {len(X_train)}, Test: {len(X_test)}")
        
        # Train
        model = lgb.LGBMClassifier(
            n_estimators=200,
            max_depth=6,
            learning_rate=0.1,
            num_leaves=31,
            subsample=0.8,
            colsample_bytree=0.8,
            min_child_samples=20,
            min_split_gain=0.1,
            reg_alpha=0.1,
            reg_lambda=1.0,
            class_weight='balanced',
            objective='binary',
            metric='auc',
            random_state=42,
            n_jobs=-1,
            verbose=-1
        )
        
        model.fit(
            X_train, y_train,
            eval_set=[(X_test, y_test)],
            callbacks=[lgb.early_stopping(20), lgb.log_evaluation(10)]
        )
        
        return model, X_test, y_test
    
    def evaluate(self, model, X_test, y_test):
        """
        Evaluate model
        """
        print("\n📊 Evaluating model...")
        
        # Predictions
        y_pred_proba = model.predict_proba(X_test)[:, 1]
        y_pred = (y_pred_proba > 0.5).astype(int)
        
        # Metrics
        auc = roc_auc_score(y_test, y_pred_proba)
        
        print(f"\n🎯 Performance Metrics:")
        print(f"   AUC-ROC: {auc:.4f}")
        
        print(f"\n📊 Classification Report:")
        print(classification_report(y_test, y_pred, 
                                   target_names=['Remembered', 'Forgot']))
        
        print(f"\n📊 Confusion Matrix:")
        cm = confusion_matrix(y_test, y_pred)
        print(cm)
        print(f"   True Negatives: {cm[0,0]}")
        print(f"   False Positives: {cm[0,1]}")
        print(f"   False Negatives: {cm[1,0]}")
        print(f"   True Positives: {cm[1,1]}")
        
        return auc
    
    def plot_feature_importance(self, model, top_n=15):
        """
        Plot feature importance
        """
        print(f"\n📊 Feature Importance Analysis...")
        
        importance = model.feature_importances_
        feature_df = pd.DataFrame({
            'feature': self.feature_columns,
            'importance': importance
        }).sort_values('importance', ascending=False)
        
        print(f"\nTop {top_n} Features:")
        print(feature_df.head(top_n).to_string(index=False))
        
        # Plot
        plt.figure(figsize=(12, 8))
        plt.barh(feature_df['feature'][:top_n], 
                 feature_df['importance'][:top_n])
        plt.xlabel('Importance')
        plt.ylabel('Feature')
        plt.title(f'Top {top_n} Most Important Features - {self.model_type.upper()}')
        plt.tight_layout()
        
        filename = f'feature_importance_{self.model_type}.png'
        plt.savefig(filename)
        print(f"💾 Saved plot to {filename}")
        
        return feature_df
    
    def save_model(self, model, auc):
        """
        Save trained model
        """
        import os
        os.makedirs('models', exist_ok=True)
        
        model_filename = f'models/smart_review_{self.model_type}.pkl'
        features_filename = 'models/feature_columns.pkl'
        
        joblib.dump(model, model_filename)
        joblib.dump(self.feature_columns, features_filename)
        
        # Save metadata
        metadata = {
            'model_type': self.model_type,
            'auc_score': auc,
            'n_features': len(self.feature_columns),
            'trained_at': pd.Timestamp.now().isoformat(),
            'version': '1.0.0'
        }
        
        import json
        with open('models/model_metadata.json', 'w') as f:
            json.dump(metadata, f, indent=2)
        
        print(f"\n💾 Model saved:")
        print(f"   - Model: {model_filename}")
        print(f"   - Features: {features_filename}")
        print(f"   - Metadata: models/model_metadata.json")
    
    def train(self):
        """
        Complete training pipeline
        """
        # 1. Fetch data
        df, stats = self.fetch_data()
        
        # Check minimum samples
        if len(df) < 100:
            print(f"\n⚠️  Warning: Only {len(df)} samples!")
            print("   Recommended minimum: 1000 samples")
            print("   Model may not perform well.")
            
            response = input("\nContinue anyway? (y/n): ")
            if response.lower() != 'y':
                print("❌ Training cancelled")
                return None, 0
        
        # 2. Prepare data
        X, y = self.prepare_data(df)
        
        # 3. Train model
        if self.model_type == 'xgboost':
            model, X_test, y_test = self.train_xgboost(X, y)
        elif self.model_type == 'lightgbm':
            model, X_test, y_test = self.train_lightgbm(X, y)
        else:
            raise ValueError(f"Unknown model type: {self.model_type}")
        
        # 4. Evaluate
        auc = self.evaluate(model, X_test, y_test)
        
        # 5. Feature importance
        feature_df = self.plot_feature_importance(model)
        
        # 6. Save model
        self.save_model(model, auc)
        
        return model, auc

# Main
if __name__ == "__main__":
    print("=" * 70)
    print("🚀 Gradient Boosting Training Pipeline")
    print("=" * 70)
    
    # Configuration
    API_URL = "http://localhost:8080"
    ADMIN_TOKEN = "your_admin_jwt_token_here"
    MODEL_TYPE = "xgboost"  # hoặc "lightgbm"
    
    # Train
    trainer = GradientBoostingTrainer(API_URL, ADMIN_TOKEN, MODEL_TYPE)
    model, auc = trainer.train()
    
    if model is not None:
        print("\n" + "=" * 70)
        print(f"✅ Training completed successfully!")
        print(f"🎯 Final AUC-ROC: {auc:.4f}")
        print(f"📦 Model type: {MODEL_TYPE.upper()}")
        print("=" * 70)
```

### Requirements

```txt
# requirements.txt
pandas==2.1.3
numpy==1.26.2
xgboost==2.0.3
lightgbm==4.1.0
scikit-learn==1.3.2
requests==2.31.0
joblib==1.3.2
matplotlib==3.8.2
```

