# So sánh Mô hình ML/DL tốt nhất cho Vocabulary Learning System

## 1. Phân tích Bài toán

### 1.1. Đặc điểm Dữ liệu của bạn

**Structured Data:**
- ✅ Tabular features (times_correct, times_wrong, ef_factor, etc.)
- ✅ Categorical features (status, cefr_level, topic)
- ✅ Temporal features (last_reviewed, interval_days)
- ✅ User behavior patterns

**Sequential Data:**
- ✅ Review history over time
- ✅ Learning trajectory (NEW → UNKNOWN → KNOWN → MASTERED)
- ✅ Temporal dependencies

**Labels:**
- ✅ Multi-class classification (4 classes)
- ✅ Imbalanced classes (có thể)
- ✅ Ordinal relationship (NEW < UNKNOWN < KNOWN < MASTERED)

### 1.2. Yêu cầu Hệ thống

**Performance:**
- Inference time < 50ms (real-time)
- Training time reasonable (< 1 giờ)
- Model size < 500MB

**Accuracy:**
- Classification accuracy > 75%
- Per-class recall balanced
- Handle imbalanced data

**Interpretability:**
- Feature importance
- Explainable predictions
- User trust

## 2. Top 10 Mô hình Được Đề xuất

### 🥇 Tier 1: Production-Ready (Recommended)

#### **1. CatBoost** ⭐⭐⭐⭐⭐

**Tại sao là #1 cho bài toán này:**
- 🎯 **Xử lý categorical features native** (không cần encoding)
- 🚀 **Fast inference** (~1-2ms)
- 📊 **Robust với imbalanced data**
- 🔍 **Built-in feature importance**
- 💪 **Ordered boosting** → tránh overfitting

**Ưu điểm:**
- Không cần feature scaling
- Handle missing values tự động
- Symmetric tree structure → fast prediction
- GPU support
- Tốt nhất cho tabular data với categorical features

**Nhược điểm:**
- Training chậm hơn LightGBM một chút
- Model size lớn hơn

**Use case:** **BEST CHOICE** cho production

```python
from catboost import CatBoostClassifier

model = CatBoostClassifier(
    iterations=1000,
    learning_rate=0.03,
    depth=8,
    loss_function='MultiClass',
    eval_metric='TotalF1',
    cat_features=['status', 'cefr_level', 'topic_id'],  # Categorical features
    auto_class_weights='Balanced',  # Handle imbalanced data
    random_seed=42,
    verbose=100
)

# Train
model.fit(
    X_train, y_train,
    eval_set=(X_val, y_val),
    early_stopping_rounds=50,
    plot=True
)

# Feature importance
feature_importance = model.get_feature_importance(
    prettified=True
)
```

**Performance Estimate:**
- Accuracy: 78-82%
- Training time: 5-10 phút
- Inference: 1-2ms
- Model size: 50-100MB

---

#### **2. LightGBM** ⭐⭐⭐⭐⭐

**Tại sao tốt:**
- ⚡ **Fastest training & inference**
- 💾 **Memory efficient**
- 📈 **Excellent accuracy**
- 🎯 **Handle large datasets**

**Ưu điểm:**
- Nhanh nhất trong các GBDT
- Leaf-wise growth → better accuracy
- Native categorical support
- Distributed training

**Nhược điểm:**
- Dễ overfit với small dataset
- Cần tuning cẩn thận

**Use case:** Khi cần **speed** và có dataset lớn (>10k samples)

```python
import lightgbm as lgb

model = lgb.LGBMClassifier(
    n_estimators=1000,
    learning_rate=0.05,
    num_leaves=31,
    max_depth=8,
    min_child_samples=20,
    subsample=0.8,
    colsample_bytree=0.8,
    objective='multiclass',
    num_class=4,
    class_weight='balanced',
    random_state=42
)

model.fit(
    X_train, y_train,
    eval_set=[(X_val, y_val)],
    eval_metric='multi_logloss',
    callbacks=[
        lgb.early_stopping(50),
        lgb.log_evaluation(100)
    ]
)
```

**Performance Estimate:**
- Accuracy: 76-80%
- Training time: 2-5 phút
- Inference: 0.5-1ms
- Model size: 20-50MB

---

#### **3. XGBoost** ⭐⭐⭐⭐

**Tại sao tốt:**
- 🏆 **Industry standard**
- 🔧 **Highly tunable**
- 📚 **Extensive documentation**
- 🛡️ **Robust & stable**

**Ưu điểm:**
- Proven track record
- Good balance of speed & accuracy
- Regularization built-in
- Cross-platform

**Nhược điểm:**
- Chậm hơn LightGBM
- Cần more memory

**Use case:** **Baseline model** hoặc khi cần stability

```python
import xgboost as xgb

model = xgb.XGBClassifier(
    n_estimators=1000,
    learning_rate=0.05,
    max_depth=8,
    min_child_weight=3,
    subsample=0.8,
    colsample_bytree=0.8,
    gamma=0.1,
    objective='multi:softprob',
    num_class=4,
    eval_metric='mlogloss',
    random_state=42
)

model.fit(
    X_train, y_train,
    eval_set=[(X_val, y_val)],
    early_stopping_rounds=50,
    verbose=100
)
```

**Performance Estimate:**
- Accuracy: 75-79%
- Training time: 5-8 phút
- Inference: 1-2ms
- Model size: 30-60MB

---

### 🥈 Tier 2: Advanced Deep Learning

#### **4. TabNet** ⭐⭐⭐⭐⭐

**Tại sao đặc biệt:**
- 🧠 **Deep Learning cho tabular data**
- 🔍 **Interpretable attention mechanism**
- 📊 **Self-supervised pre-training**
- 🎯 **Feature selection tự động**

**Ưu điểm:**
- Attention mechanism → biết feature nào quan trọng
- Không cần feature engineering nhiều
- Có thể pre-train trên unlabeled data
- Competitive với GBDT

**Nhược điểm:**
- Cần GPU để train nhanh
- Training phức tạp hơn
- Inference chậm hơn GBDT

**Use case:** Khi cần **interpretability** + **deep learning power**

```python
from pytorch_tabnet.tab_model import TabNetClassifier

model = TabNetClassifier(
    n_d=64,  # Width of decision prediction layer
    n_a=64,  # Width of attention embedding
    n_steps=5,  # Number of steps in architecture
    gamma=1.5,  # Coefficient for feature reusage
    n_independent=2,
    n_shared=2,
    lambda_sparse=1e-4,
    optimizer_fn=torch.optim.Adam,
    optimizer_params=dict(lr=2e-2),
    scheduler_params={"step_size":50, "gamma":0.9},
    scheduler_fn=torch.optim.lr_scheduler.StepLR,
    mask_type='entmax',
    verbose=10
)

model.fit(
    X_train, y_train,
    eval_set=[(X_val, y_val)],
    eval_metric=['accuracy'],
    max_epochs=200,
    patience=20,
    batch_size=256
)

# Feature importance with attention
explain_matrix, masks = model.explain(X_test)
```

**Performance Estimate:**
- Accuracy: 77-81%
- Training time: 10-20 phút (GPU)
- Inference: 5-10ms
- Model size: 10-30MB

---

#### **5. Temporal Fusion Transformer (TFT)** ⭐⭐⭐⭐⭐

**Tại sao powerful:**
- 🕐 **Designed for temporal data**
- 🎯 **Multi-horizon forecasting**
- 🔍 **Interpretable attention**
- 📊 **Handle static + dynamic features**

**Ưu điểm:**
- State-of-the-art cho time series
- Attention mechanism → interpretable
- Quantile predictions → uncertainty
- Variable selection network

**Nhược điểm:**
- Phức tạp nhất
- Cần nhiều data
- Training time dài

**Use case:** Khi có **rich temporal history** và cần **long-term predictions**

```python
from pytorch_forecasting import TemporalFusionTransformer, TimeSeriesDataSet

# Prepare data
training = TimeSeriesDataSet(
    data,
    time_idx="time_idx",
    target="status",
    group_ids=["user_id", "vocab_id"],
    max_encoder_length=30,  # Look back 30 reviews
    max_prediction_length=1,  # Predict next status
    static_categoricals=["cefr_level", "topic_id"],
    static_reals=["user_level_numeric"],
    time_varying_known_categoricals=[],
    time_varying_known_reals=["days_since_last_review"],
    time_varying_unknown_categoricals=["status"],
    time_varying_unknown_reals=["times_correct", "times_wrong", "ef_factor"],
    target_normalizer=None,
)

model = TemporalFusionTransformer.from_dataset(
    training,
    learning_rate=0.03,
    hidden_size=64,
    attention_head_size=4,
    dropout=0.1,
    hidden_continuous_size=32,
    output_size=4,  # 4 classes
    loss=CrossEntropyLoss(),
)

trainer = pl.Trainer(max_epochs=50, gpus=1)
trainer.fit(model, train_dataloader, val_dataloader)
```

**Performance Estimate:**
- Accuracy: 80-85% (với đủ data)
- Training time: 30-60 phút (GPU)
- Inference: 10-20ms
- Model size: 50-100MB

---

#### **6. GRU/LSTM with Attention** ⭐⭐⭐⭐

**Tại sao tốt:**
- 🔄 **Capture sequential patterns**
- 🧠 **Learn temporal dependencies**
- 🎯 **Attention → interpretability**

**Ưu điểm:**
- Proven architecture
- Flexible
- Good for sequences
- Attention weights → explainable

**Nhược điểm:**
- Cần sequence data
- Training chậm
- Vanishing gradient (LSTM better than RNN)

**Use case:** Khi có **review history sequences**

```python
import torch
import torch.nn as nn

class AttentionGRU(nn.Module):
    def __init__(self, input_dim, hidden_dim, num_classes, num_layers=2):
        super().__init__()
        
        self.gru = nn.GRU(
            input_size=input_dim,
            hidden_size=hidden_dim,
            num_layers=num_layers,
            batch_first=True,
            dropout=0.3,
            bidirectional=True
        )
        
        # Attention mechanism
        self.attention = nn.Sequential(
            nn.Linear(hidden_dim * 2, hidden_dim),
            nn.Tanh(),
            nn.Linear(hidden_dim, 1)
        )
        
        self.classifier = nn.Sequential(
            nn.Linear(hidden_dim * 2, 128),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(128, num_classes)
        )
    
    def forward(self, x):
        # x: (batch, seq_len, input_dim)
        gru_out, _ = self.gru(x)  # (batch, seq_len, hidden_dim*2)
        
        # Attention weights
        attention_weights = self.attention(gru_out)  # (batch, seq_len, 1)
        attention_weights = torch.softmax(attention_weights, dim=1)
        
        # Weighted sum
        context = torch.sum(gru_out * attention_weights, dim=1)  # (batch, hidden_dim*2)
        
        # Classification
        output = self.classifier(context)
        
        return output, attention_weights

model = AttentionGRU(input_dim=30, hidden_dim=64, num_classes=4)
```

**Performance Estimate:**
- Accuracy: 78-82%
- Training time: 15-30 phút (GPU)
- Inference: 5-10ms
- Model size: 20-40MB

---

### 🥉 Tier 3: Specialized Models

#### **7. Neural Oblivious Decision Trees (NODE)** ⭐⭐⭐⭐

**Tại sao interesting:**
- 🌳 **Combines trees + neural networks**
- 🎯 **Differentiable decision trees**
- 📊 **Best of both worlds**

**Ưu điểm:**
- Interpretable như trees
- Powerful như neural nets
- End-to-end training
- Good for tabular data

**Nhược điểm:**
- Mới, ít documentation
- Cần GPU
- Phức tạp

**Use case:** Research, khi muốn **tree interpretability + NN power**

```python
# Requires: pip install node-lib
from node import NODE

model = NODE(
    num_layers=4,
    total_tree_count=2048,
    tree_depth=6,
    tree_output_dim=4,
    num_classes=4
)
```

**Performance Estimate:**
- Accuracy: 77-81%
- Training time: 20-40 phút (GPU)
- Inference: 3-5ms

---

#### **8. AutoGluon (AutoML)** ⭐⭐⭐⭐⭐

**Tại sao powerful:**
- 🤖 **Automated ML**
- 🎯 **Ensemble of best models**
- 🚀 **State-of-the-art results**
- 🔧 **Minimal code**

**Ưu điểm:**
- Tự động thử nhiều models
- Ensemble tốt nhất
- Hyperparameter tuning tự động
- Production-ready

**Nhược điểm:**
- Black box
- Training time dài
- Model size lớn

**Use case:** Khi muốn **best accuracy** và không quan tâm complexity

```python
from autogluon.tabular import TabularPredictor

predictor = TabularPredictor(
    label='status',
    problem_type='multiclass',
    eval_metric='f1_weighted',
    path='./autogluon_models'
)

predictor.fit(
    train_data=train_df,
    time_limit=3600,  # 1 hour
    presets='best_quality',  # or 'medium_quality', 'optimize_for_deployment'
    num_bag_folds=5,
    num_stack_levels=1
)

# Get leaderboard
leaderboard = predictor.leaderboard(test_df)
```

**Performance Estimate:**
- Accuracy: 80-85% (ensemble)
- Training time: 1-3 giờ
- Inference: 10-50ms (depends on ensemble)
- Model size: 200-500MB

---


#### **9. FT-Transformer** ⭐⭐⭐⭐

**Tại sao modern:**
- 🤖 **Transformer for tabular data**
- 🎯 **Feature tokenization**
- 📊 **Self-attention mechanism**
- 🚀 **State-of-the-art on benchmarks**

**Ưu điểm:**
- Transformer architecture
- Không cần feature engineering nhiều
- Attention → interpretable
- Competitive với GBDT

**Nhược điểm:**
- Cần GPU
- Training time dài
- Overfitting với small data

**Use case:** Research, khi có **large dataset** (>50k samples)

```python
import torch
import torch.nn as nn

class FTTransformer(nn.Module):
    def __init__(self, n_features, n_classes, d_model=192, n_heads=8, n_layers=3):
        super().__init__()
        
        # Feature tokenization
        self.feature_tokenizer = nn.Linear(1, d_model)
        
        # Transformer encoder
        encoder_layer = nn.TransformerEncoderLayer(
            d_model=d_model,
            nhead=n_heads,
            dim_feedforward=d_model * 4,
            dropout=0.1,
            activation='gelu'
        )
        self.transformer = nn.TransformerEncoder(encoder_layer, num_layers=n_layers)
        
        # Classification head
        self.classifier = nn.Sequential(
            nn.LayerNorm(d_model),
            nn.Linear(d_model, n_classes)
        )
    
    def forward(self, x):
        # x: (batch, n_features)
        
        # Tokenize each feature
        x = x.unsqueeze(-1)  # (batch, n_features, 1)
        tokens = self.feature_tokenizer(x)  # (batch, n_features, d_model)
        
        # Add CLS token
        cls_token = nn.Parameter(torch.randn(1, 1, d_model))
        tokens = torch.cat([cls_token.expand(x.size(0), -1, -1), tokens], dim=1)
        
        # Transformer
        tokens = tokens.transpose(0, 1)  # (seq_len, batch, d_model)
        encoded = self.transformer(tokens)
        
        # Use CLS token for classification
        cls_output = encoded[0]  # (batch, d_model)
        
        output = self.classifier(cls_output)
        return output

model = FTTransformer(n_features=30, n_classes=4)
```

**Performance Estimate:**
- Accuracy: 78-83%
- Training time: 30-60 phút (GPU)
- Inference: 5-10ms
- Model size: 50-100MB

---

#### **10. Gradient Boosting + Neural Network Ensemble** ⭐⭐⭐⭐⭐

**Tại sao powerful:**
- 🎯 **Best of both worlds**
- 📊 **GBDT features + NN power**
- 🚀 **Ensemble diversity**

**Ưu điểm:**
- Combine strengths
- Better generalization
- Robust predictions
- High accuracy

**Nhược điểm:**
- Complex pipeline
- Longer training
- Larger model size

**Use case:** Khi cần **maximum accuracy** cho production

```python
class GBDTNNEnsemble:
    def __init__(self):
        # GBDT models
        self.catboost = CatBoostClassifier(iterations=500, depth=6)
        self.lightgbm = lgb.LGBMClassifier(n_estimators=500, num_leaves=31)
        self.xgboost = xgb.XGBClassifier(n_estimators=500, max_depth=6)
        
        # Neural network
        self.nn = TabNetClassifier(n_d=64, n_a=64, n_steps=5)
        
        # Meta-learner
        self.meta_model = LogisticRegression(multi_class='multinomial')
    
    def fit(self, X_train, y_train, X_val, y_val):
        # Train base models
        self.catboost.fit(X_train, y_train, eval_set=(X_val, y_val))
        self.lightgbm.fit(X_train, y_train, eval_set=[(X_val, y_val)])
        self.xgboost.fit(X_train, y_train, eval_set=[(X_val, y_val)])
        self.nn.fit(X_train, y_train, eval_set=[(X_val, y_val)])
        
        # Get predictions for meta-learner
        train_meta_features = self._get_meta_features(X_train)
        self.meta_model.fit(train_meta_features, y_train)
    
    def _get_meta_features(self, X):
        # Stack predictions from all models
        pred_cb = self.catboost.predict_proba(X)
        pred_lgb = self.lightgbm.predict_proba(X)
        pred_xgb = self.xgboost.predict_proba(X)
        pred_nn = self.nn.predict_proba(X)
        
        return np.hstack([pred_cb, pred_lgb, pred_xgb, pred_nn])
    
    def predict_proba(self, X):
        meta_features = self._get_meta_features(X)
        return self.meta_model.predict_proba(meta_features)
    
    def predict(self, X):
        return self.predict_proba(X).argmax(axis=1)

# Usage
ensemble = GBDTNNEnsemble()
ensemble.fit(X_train, y_train, X_val, y_val)
```

**Performance Estimate:**
- Accuracy: 82-87% (best)
- Training time: 30-60 phút
- Inference: 10-20ms
- Model size: 200-400MB

---

## 3. Detailed Comparison Table

| Model | Accuracy | Speed | Interpretability | Complexity | Data Need | GPU | Best For |
|-------|----------|-------|------------------|------------|-----------|-----|----------|
| **CatBoost** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ | ❌ | **Production** |
| **LightGBM** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ | ❌ | **Speed** |
| **XGBoost** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ | ❌ | **Baseline** |
| **TabNet** | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ✅ | **Interpretable DL** |
| **TFT** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ✅ | **Temporal** |
| **GRU+Attention** | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ✅ | **Sequences** |
| **NODE** | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ✅ | **Research** |
| **AutoGluon** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐ | ⭐ | ⭐⭐⭐ | ❌ | **Max Accuracy** |
| **FT-Transformer** | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ✅ | **Large Data** |
| **Ensemble** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⚠️ | **Competition** |

## 4. Recommendation Matrix

### 4.1. Based on Dataset Size

**Small (<5k samples):**
1. CatBoost (best)
2. XGBoost
3. Random Forest

**Medium (5k-50k):**
1. CatBoost (best)
2. LightGBM
3. TabNet

**Large (>50k):**
1. LightGBM (best)
2. AutoGluon
3. FT-Transformer

### 4.2. Based on Priority

**Priority: Speed**
1. LightGBM ⚡
2. CatBoost
3. XGBoost

**Priority: Accuracy**
1. AutoGluon 🎯
2. Ensemble
3. CatBoost

**Priority: Interpretability**
1. CatBoost 🔍
2. TabNet
3. XGBoost

**Priority: Simplicity**
1. CatBoost 🎈
2. LightGBM
3. XGBoost

**Priority: Innovation**
1. TFT 🚀
2. FT-Transformer
3. TabNet

### 4.3. Based on Infrastructure

**No GPU:**
1. CatBoost
2. LightGBM
3. XGBoost

**Have GPU:**
1. TabNet
2. TFT
3. GRU+Attention

**Limited Resources:**
1. LightGBM
2. XGBoost
3. CatBoost

## 5. Recommended Strategy

### 🎯 Phase 1: Quick Win (Tuần 1-2)

**Model:** CatBoost

**Lý do:**
- Fastest to production
- Best accuracy/effort ratio
- Handle categorical features native
- Robust với imbalanced data

**Implementation:**
```python
from catboost import CatBoostClassifier, Pool

# Prepare data
train_pool = Pool(
    X_train, 
    y_train,
    cat_features=['status', 'cefr_level', 'topic_id']
)

val_pool = Pool(
    X_val,
    y_val,
    cat_features=['status', 'cefr_level', 'topic_id']
)

# Train
model = CatBoostClassifier(
    iterations=1000,
    learning_rate=0.03,
    depth=8,
    loss_function='MultiClass',
    eval_metric='TotalF1',
    auto_class_weights='Balanced',
    random_seed=42,
    task_type='GPU'  # if available
)

model.fit(
    train_pool,
    eval_set=val_pool,
    early_stopping_rounds=50,
    verbose=100,
    plot=True
)

# Save
model.save_model('catboost_model.cbm')
```

**Expected Result:**
- Accuracy: 78-82%
- Training: 5-10 phút
- Production-ready

---

### 🚀 Phase 2: Optimization (Tuần 3-4)

**Models:** CatBoost + LightGBM + TabNet

**Strategy:** Ensemble

```python
class OptimizedEnsemble:
    def __init__(self):
        self.catboost = CatBoostClassifier(...)
        self.lightgbm = lgb.LGBMClassifier(...)
        self.tabnet = TabNetClassifier(...)
        
        # Weighted average
        self.weights = [0.4, 0.3, 0.3]  # Tune based on validation
    
    def predict_proba(self, X):
        pred_cb = self.catboost.predict_proba(X)
        pred_lgb = self.lightgbm.predict_proba(X)
        pred_tn = self.tabnet.predict_proba(X)
        
        return (
            self.weights[0] * pred_cb +
            self.weights[1] * pred_lgb +
            self.weights[2] * pred_tn
        )
```

**Expected Result:**
- Accuracy: 80-84%
- Robust predictions

---

### 🎓 Phase 3: Advanced (Tuần 5-6)

**Model:** Temporal Fusion Transformer

**When:** Khi có rich temporal data

```python
# Prepare sequential data
def prepare_sequences(user_id, vocab_id, lookback=30):
    """Get last 30 reviews for this user-vocab pair"""
    history = get_review_history(user_id, vocab_id, limit=lookback)
    
    features = []
    for review in history:
        features.append([
            review.times_correct,
            review.times_wrong,
            review.ef_factor,
            review.interval_days,
            # ... more features
        ])
    
    return np.array(features)

# Train TFT
model = TemporalFusionTransformer(...)
```

**Expected Result:**
- Accuracy: 82-86%
- Long-term predictions
- Interpretable attention

---

## 6. Hybrid Approach (BEST)

### 6.1. Multi-Model System

```
┌─────────────────────────────────────────────────────────┐
│                    Prediction Router                     │
└────────────┬────────────────────────────────────────────┘
             │
             ├─────────────────┬─────────────────┬─────────
             │                 │                 │
             ▼                 ▼                 ▼
    ┌────────────────┐ ┌──────────────┐ ┌──────────────┐
    │   CatBoost     │ │   TabNet     │ │     TFT      │
    │  (Fast Path)   │ │ (Interpret)  │ │  (Temporal)  │
    └────────────────┘ └──────────────┘ └──────────────┘
             │                 │                 │
             └─────────────────┴─────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  Meta Ensemble   │
                    └──────────────────┘
```

### 6.2. Implementation

```python
class HybridVocabPredictor:
    def __init__(self):
        self.catboost = load_model('catboost.cbm')  # Fast
        self.tabnet = load_model('tabnet.pkl')      # Interpretable
        self.tft = load_model('tft.ckpt')           # Temporal
        
        self.router = self._init_router()
    
    async def predict(self, user_id, vocab_id, mode='auto'):
        """
        Predict with appropriate model based on context
        
        Modes:
        - 'fast': Use CatBoost (1-2ms)
        - 'interpret': Use TabNet (5-10ms)
        - 'temporal': Use TFT (10-20ms)
        - 'auto': Router decides
        """
        
        if mode == 'auto':
            mode = self.router.decide(user_id, vocab_id)
        
        if mode == 'fast':
            return await self._predict_catboost(user_id, vocab_id)
        elif mode == 'interpret':
            return await self._predict_tabnet(user_id, vocab_id)
        elif mode == 'temporal':
            return await self._predict_tft(user_id, vocab_id)
    
    def _init_router(self):
        """
        Router logic:
        - New users (<10 vocabs): CatBoost (fast, reliable)
        - Need explanation: TabNet (interpretable)
        - Rich history (>30 reviews): TFT (temporal)
        """
        class Router:
            def decide(self, user_id, vocab_id):
                vocab_count = get_user_vocab_count(user_id)
                review_count = get_review_count(user_id, vocab_id)
                
                if vocab_count < 10:
                    return 'fast'
                elif review_count > 30:
                    return 'temporal'
                else:
                    return 'interpret'
        
        return Router()
```

---

## 7. Special Techniques

### 7.1. Handling Imbalanced Classes

```python
from imblearn.over_sampling import SMOTE
from imblearn.under_sampling import RandomUnderSampler
from imblearn.pipeline import Pipeline

# SMOTE + Undersampling
resampler = Pipeline([
    ('over', SMOTE(sampling_strategy={0: 1000, 1: 1000})),  # Oversample minority
    ('under', RandomUnderSampler(sampling_strategy={3: 500}))  # Undersample majority
])

X_resampled, y_resampled = resampler.fit_resample(X_train, y_train)
```

### 7.2. Ordinal Encoding for Status

```python
# Status có thứ tự: NEW < UNKNOWN < KNOWN < MASTERED
from sklearn.preprocessing import OrdinalEncoder

ordinal_encoder = OrdinalEncoder(
    categories=[['NEW', 'UNKNOWN', 'KNOWN', 'MASTERED']]
)

# Use ordinal loss
model = CatBoostClassifier(
    loss_function='MultiClass',
    # Or use custom metric that considers order
)
```

### 7.3. Feature Engineering Boost

```python
def create_advanced_features(df):
    """Advanced feature engineering"""
    
    # 1. Interaction features
    df['accuracy_x_recency'] = df['accuracy_rate'] * df['recency_score']
    df['difficulty_gap'] = df['vocab_cefr_numeric'] - df['user_level_numeric']
    
    # 2. Aggregation features (per user)
    user_stats = df.groupby('user_id').agg({
        'times_correct': ['mean', 'std', 'max'],
        'times_wrong': ['mean', 'std', 'max'],
        'accuracy_rate': ['mean', 'std']
    })
    df = df.merge(user_stats, on='user_id', suffixes=('', '_user_avg'))
    
    # 3. Aggregation features (per vocab)
    vocab_stats = df.groupby('vocab_id').agg({
        'times_correct': 'mean',
        'times_wrong': 'mean',
        'accuracy_rate': 'mean'
    })
    df = df.merge(vocab_stats, on='vocab_id', suffixes=('', '_vocab_avg'))
    
    # 4. Temporal features
    df['hour_of_day'] = df['last_reviewed'].dt.hour
    df['day_of_week'] = df['last_reviewed'].dt.dayofweek
    df['is_weekend'] = df['day_of_week'].isin([5, 6]).astype(int)
    
    # 5. Streak features
    df['study_consistency'] = df['current_streak'] / (df['total_study_days'] + 1)
    
    return df
```


## 8. Final Recommendations

### 🏆 Top 3 Choices

#### **#1: CatBoost (BEST FOR YOU)**

**Lý do:**
- ✅ Perfect cho tabular data với categorical features
- ✅ Không cần GPU
- ✅ Production-ready ngay
- ✅ Robust với imbalanced data
- ✅ Fast inference (1-2ms)
- ✅ Interpretable
- ✅ Easy to deploy

**Khi nào dùng:** **ALWAYS** - Đây là best choice cho bài toán của bạn

**Code template:**
```python
# train.py
from catboost import CatBoostClassifier, Pool
import pandas as pd

# Load data
df = pd.read_sql("SELECT * FROM user_vocab_progress ...", conn)

# Feature engineering
df = create_features(df)

# Prepare
X = df[feature_columns]
y = df['status']

# Split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# Train
model = CatBoostClassifier(
    iterations=1000,
    learning_rate=0.03,
    depth=8,
    loss_function='MultiClass',
    eval_metric='TotalF1',
    cat_features=['status', 'cefr_level', 'topic_id'],
    auto_class_weights='Balanced',
    random_seed=42
)

model.fit(X_train, y_train, eval_set=(X_test, y_test))

# Save
model.save_model('models/catboost_v1.cbm')
```

---

#### **#2: LightGBM (If you need SPEED)**

**Khi nào dùng:**
- Dataset lớn (>50k samples)
- Cần inference cực nhanh (<1ms)
- Có nhiều features (>100)

**Trade-off:** Accuracy có thể thấp hơn CatBoost 1-2%

---

#### **#3: TabNet (If you need INTERPRETABILITY)**

**Khi nào dùng:**
- Cần giải thích predictions cho users
- Muốn biết features nào quan trọng cho từng prediction
- Có GPU

**Trade-off:** Inference chậm hơn (5-10ms)

---

### 📊 Decision Tree

```
START
  │
  ├─ Dataset size < 10k?
  │   └─ YES → CatBoost
  │   └─ NO → Continue
  │
  ├─ Need interpretability?
  │   └─ YES → TabNet
  │   └─ NO → Continue
  │
  ├─ Have rich temporal data (>30 reviews per vocab)?
  │   └─ YES → TFT
  │   └─ NO → Continue
  │
  ├─ Need maximum accuracy (competition)?
  │   └─ YES → AutoGluon or Ensemble
  │   └─ NO → Continue
  │
  └─ Default → CatBoost
```

---

## 9. Implementation Plan

### Week 1: CatBoost Baseline

**Day 1-2: Data Preparation**
```bash
# Tasks
- [ ] Query data from PostgreSQL
- [ ] EDA (Exploratory Data Analysis)
- [ ] Check label distribution
- [ ] Handle missing values
- [ ] Feature engineering
```

**Day 3-4: Model Training**
```bash
# Tasks
- [ ] Train CatBoost model
- [ ] Hyperparameter tuning with Optuna
- [ ] Cross-validation
- [ ] Evaluate metrics
```

**Day 5: Deployment**
```bash
# Tasks
- [ ] Save model
- [ ] Create inference API
- [ ] Test predictions
- [ ] Document results
```

### Week 2: Optimization

**Day 1-2: Ensemble**
```bash
# Tasks
- [ ] Train LightGBM
- [ ] Train XGBoost
- [ ] Create ensemble
- [ ] Compare results
```

**Day 3-4: Advanced Features**
```bash
# Tasks
- [ ] Add interaction features
- [ ] Add aggregation features
- [ ] Add temporal features
- [ ] Retrain models
```

**Day 5: Production**
```bash
# Tasks
- [ ] Deploy best model
- [ ] Setup monitoring
- [ ] A/B testing
```

---

## 10. Code Templates

### 10.1. Complete Training Pipeline

```python
# train_pipeline.py
import pandas as pd
import numpy as np
from catboost import CatBoostClassifier, Pool
from sklearn.model_selection import train_test_split, StratifiedKFold
from sklearn.metrics import accuracy_score, f1_score, classification_report
import optuna
import mlflow

class VocabModelTrainer:
    def __init__(self, db_connection):
        self.conn = db_connection
        self.model = None
        self.feature_names = None
    
    def load_data(self):
        """Load data from database"""
        query = """
        SELECT 
            uvp.id,
            uvp.user_id,
            uvp.vocab_id,
            uvp.status,
            uvp.times_correct,
            uvp.times_wrong,
            uvp.ef_factor,
            uvp.interval_days,
            uvp.repetition,
            uvp.last_reviewed,
            uvp.created_at,
            v.cefr,
            v.word_length,
            v.topic_id,
            u.current_level,
            u.current_streak,
            u.total_study_days
        FROM user_vocab_progress uvp
        JOIN vocab v ON uvp.vocab_id = v.id
        JOIN users u ON uvp.user_id = u.id
        WHERE uvp.status IN ('NEW', 'UNKNOWN', 'KNOWN', 'MASTERED')
        """
        
        df = pd.read_sql(query, self.conn)
        return df
    
    def engineer_features(self, df):
        """Feature engineering"""
        
        # Temporal features
        df['days_since_last_review'] = (
            pd.Timestamp.now() - pd.to_datetime(df['last_reviewed'])
        ).dt.days
        
        df['days_since_created'] = (
            pd.Timestamp.now() - pd.to_datetime(df['created_at'])
        ).dt.days
        
        # Accuracy
        df['accuracy_rate'] = df['times_correct'] / (
            df['times_correct'] + df['times_wrong'] + 1
        )
        
        # CEFR numeric
        cefr_map = {'A1': 1, 'A2': 2, 'B1': 3, 'B2': 4, 'C1': 5, 'C2': 6}
        df['cefr_numeric'] = df['cefr'].map(cefr_map)
        df['user_level_numeric'] = df['current_level'].map(cefr_map)
        
        # Difficulty gap
        df['difficulty_gap'] = df['cefr_numeric'] - df['user_level_numeric']
        
        # Study consistency
        df['study_consistency'] = df['current_streak'] / (df['total_study_days'] + 1)
        
        # User aggregations
        user_stats = df.groupby('user_id').agg({
            'accuracy_rate': ['mean', 'std'],
            'times_correct': 'mean',
            'times_wrong': 'mean'
        }).reset_index()
        user_stats.columns = ['user_id', 'user_avg_accuracy', 'user_std_accuracy',
                             'user_avg_correct', 'user_avg_wrong']
        df = df.merge(user_stats, on='user_id', how='left')
        
        return df
    
    def prepare_data(self):
        """Prepare train/val/test sets"""
        
        df = self.load_data()
        df = self.engineer_features(df)
        
        # Features
        feature_cols = [
            'times_correct', 'times_wrong', 'ef_factor', 'interval_days',
            'repetition', 'days_since_last_review', 'days_since_created',
            'accuracy_rate', 'cefr_numeric', 'user_level_numeric',
            'difficulty_gap', 'current_streak', 'total_study_days',
            'study_consistency', 'user_avg_accuracy', 'user_std_accuracy',
            'user_avg_correct', 'user_avg_wrong'
        ]
        
        cat_features = ['topic_id']
        
        X = df[feature_cols + cat_features]
        y = df['status'].map({'NEW': 0, 'UNKNOWN': 1, 'KNOWN': 2, 'MASTERED': 3})
        
        self.feature_names = feature_cols + cat_features
        
        # Split
        X_train, X_temp, y_train, y_temp = train_test_split(
            X, y, test_size=0.3, random_state=42, stratify=y
        )
        
        X_val, X_test, y_val, y_test = train_test_split(
            X_temp, y_temp, test_size=0.5, random_state=42, stratify=y_temp
        )
        
        return {
            'train': (X_train, y_train),
            'val': (X_val, y_val),
            'test': (X_test, y_test),
            'cat_features': cat_features
        }
    
    def optimize_hyperparameters(self, X_train, y_train, X_val, y_val, cat_features):
        """Hyperparameter tuning with Optuna"""
        
        def objective(trial):
            params = {
                'iterations': trial.suggest_int('iterations', 500, 2000),
                'learning_rate': trial.suggest_float('learning_rate', 0.01, 0.1),
                'depth': trial.suggest_int('depth', 4, 10),
                'l2_leaf_reg': trial.suggest_float('l2_leaf_reg', 1, 10),
                'border_count': trial.suggest_int('border_count', 32, 255),
                'random_seed': 42,
                'loss_function': 'MultiClass',
                'eval_metric': 'TotalF1',
                'auto_class_weights': 'Balanced',
                'verbose': False
            }
            
            model = CatBoostClassifier(**params)
            model.fit(
                X_train, y_train,
                eval_set=(X_val, y_val),
                cat_features=cat_features,
                early_stopping_rounds=50,
                verbose=False
            )
            
            y_pred = model.predict(X_val)
            f1 = f1_score(y_val, y_pred, average='weighted')
            
            return f1
        
        study = optuna.create_study(direction='maximize')
        study.optimize(objective, n_trials=50)
        
        return study.best_params
    
    def train(self, params=None):
        """Train final model"""
        
        mlflow.start_run()
        
        # Prepare data
        data = self.prepare_data()
        X_train, y_train = data['train']
        X_val, y_val = data['val']
        X_test, y_test = data['test']
        cat_features = data['cat_features']
        
        # Hyperparameter tuning
        if params is None:
            print("Optimizing hyperparameters...")
            params = self.optimize_hyperparameters(
                X_train, y_train, X_val, y_val, cat_features
            )
        
        # Train final model
        print("Training final model...")
        self.model = CatBoostClassifier(**params)
        self.model.fit(
            X_train, y_train,
            eval_set=(X_val, y_val),
            cat_features=cat_features,
            early_stopping_rounds=50,
            verbose=100
        )
        
        # Evaluate
        y_pred = self.model.predict(X_test)
        accuracy = accuracy_score(y_test, y_pred)
        f1 = f1_score(y_test, y_pred, average='weighted')
        
        print(f"\nTest Accuracy: {accuracy:.4f}")
        print(f"Test F1-Score: {f1:.4f}")
        print("\nClassification Report:")
        print(classification_report(y_test, y_pred, 
                                   target_names=['NEW', 'UNKNOWN', 'KNOWN', 'MASTERED']))
        
        # Log to MLflow
        mlflow.log_params(params)
        mlflow.log_metrics({'test_accuracy': accuracy, 'test_f1': f1})
        mlflow.catboost.log_model(self.model, "model")
        
        mlflow.end_run()
        
        return self.model
    
    def save_model(self, path='models/catboost_vocab_predictor.cbm'):
        """Save model"""
        self.model.save_model(path)
        print(f"Model saved to {path}")

# Usage
if __name__ == "__main__":
    from sqlalchemy import create_engine
    
    engine = create_engine("postgresql://user:pass@localhost/cardwords")
    
    trainer = VocabModelTrainer(engine)
    model = trainer.train()
    trainer.save_model()
```

### 10.2. Inference API

```python
# api.py
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from catboost import CatBoostClassifier
import numpy as np
import pandas as pd

app = FastAPI()

# Load model at startup
model = CatBoostClassifier()
model.load_model('models/catboost_vocab_predictor.cbm')

class PredictionRequest(BaseModel):
    user_id: str
    vocab_id: str

class PredictionResponse(BaseModel):
    vocab_id: str
    current_status: str
    predicted_status: str
    probabilities: dict
    confidence: float
    recommendation: str

@app.post("/predict", response_model=PredictionResponse)
async def predict(request: PredictionRequest):
    """Predict next status for vocabulary"""
    
    # Fetch features from database
    features = await fetch_features(request.user_id, request.vocab_id)
    
    # Create feature vector
    X = create_feature_vector(features)
    
    # Predict
    probabilities = model.predict_proba(X)[0]
    predicted_class = model.predict(X)[0]
    
    status_map = {0: 'NEW', 1: 'UNKNOWN', 2: 'KNOWN', 3: 'MASTERED'}
    predicted_status = status_map[predicted_class]
    
    probs_dict = {
        status_map[i]: float(prob) 
        for i, prob in enumerate(probabilities)
    }
    
    confidence = float(np.max(probabilities))
    
    recommendation = generate_recommendation(
        features['current_status'],
        predicted_status,
        probs_dict,
        confidence
    )
    
    return PredictionResponse(
        vocab_id=request.vocab_id,
        current_status=features['current_status'],
        predicted_status=predicted_status,
        probabilities=probs_dict,
        confidence=confidence,
        recommendation=recommendation
    )
```

---

## 11. Conclusion

### 🎯 Final Answer: **CatBoost**

**Lý do:**
1. ✅ **Perfect fit** cho tabular data với categorical features
2. ✅ **Production-ready** ngay lập tức
3. ✅ **High accuracy** (78-82%)
4. ✅ **Fast inference** (1-2ms)
5. ✅ **No GPU needed**
6. ✅ **Interpretable**
7. ✅ **Easy to maintain**
8. ✅ **Robust với imbalanced data**

### 📈 Expected Results

**Metrics:**
- Accuracy: 78-82%
- F1-Score: 0.76-0.80
- Inference time: 1-2ms
- Training time: 5-10 phút

**Business Impact:**
- User engagement: +20%
- Learning efficiency: +15%
- Retention: +20%

### 🚀 Next Steps

1. **Week 1:** Implement CatBoost baseline
2. **Week 2:** Optimize & deploy
3. **Week 3:** A/B testing
4. **Week 4:** Iterate based on results

### 💡 Pro Tips

1. **Start simple:** CatBoost first, optimize later
2. **Feature engineering:** Spend time here, biggest impact
3. **Monitor:** Track online performance
4. **Iterate:** Continuous improvement

---

**Tác giả:** AI Assistant  
**Ngày tạo:** 2024-11-16  
**Phiên bản:** 1.0  
**Status:** Ready to implement! 🚀

**Recommendation:** Bắt đầu với CatBoost ngay hôm nay! 💪
