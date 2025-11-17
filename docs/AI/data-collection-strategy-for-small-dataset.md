# Chiến Lược Thu Thập Dữ Liệu Cho Bài Toán Với Dataset Nhỏ

## Vấn Đề Hiện Tại

**Tình huống:**
- Dữ liệu chỉ có từ bảng `user_vocab_progress`
- Số lượng records ít (< 10K samples)
- Chưa đủ để train model ML hiệu quả

**Yêu cầu tối thiểu:**
- **Baseline model**: 1,000 - 5,000 samples
- **Good model**: 10,000 - 50,000 samples
- **Excellent model**: > 50,000 samples

---

## Giải Pháp 1: Thu Thập Dữ Liệu Từ Nhiều Nguồn

### 1.1 Khai Thác Dữ Liệu Từ Game Sessions

```sql
-- Lấy dữ liệu từ game sessions (QuickQuiz, ImageWordMatching, etc.)
SELECT 
    gsd.user_id,
    gsd.vocab_id,
    gsd.is_correct,
    gsd.time_taken,
    gsd.created_at,
    v.cefr,
    v.word,
    LENGTH(v.word) as vocab_length,
    gs.game_id
FROM game_session_details gsd
JOIN game_sessions gs ON gsd.session_id = gs.id
JOIN vocabs v ON gsd.vocab_id = v.id
WHERE gsd.created_at >= NOW() - INTERVAL '6 months'
ORDER BY gsd.created_at DESC;
```

**Lợi ích:**
- Có nhiều data hơn từ game sessions
- Mỗi lần chơi game = 1 data point
- Có thể có hàng chục nghìn records

### 1.2 Tạo Synthetic Training Data

```python
import pandas as pd
import numpy as np
from datetime import datetime, timedelta

def create_synthetic_data(existing_data, n_samples=10000):
    """
    Tạo synthetic data dựa trên distribution của data thật
    """
    synthetic_data = []
    
    for _ in range(n_samples):
        # Sample từ distribution thật
        base_sample = existing_data.sample(1).iloc[0]
        
        # Add noise
        synthetic_sample = {
            'user_total_vocabs': int(base_sample['user_total_vocabs'] * np.random.uniform(0.8, 1.2)),
            'user_accuracy': np.clip(base_sample['user_accuracy'] + np.random.normal(0, 0.1), 0, 1),
            'vocab_difficulty': base_sample['vocab_difficulty'],
            'vocab_length': base_sample['vocab_length'],
            'times_correct': int(base_sample['times_correct'] * np.random.uniform(0.5, 1.5)),
            'times_wrong': int(base_sample['times_wrong'] * np.random.uniform(0.5, 1.5)),
            'repetition': base_sample['repetition'] + np.random.randint(-1, 2),
            'ef_factor': np.clip(base_sample['ef_factor'] + np.random.normal(0, 0.2), 1.3, 3.0),
            'interval_days': max(1, int(base_sample['interval_days'] * np.random.uniform(0.7, 1.3))),
            'days_since_last_review': max(0, int(base_sample['days_since_last_review'] + np.random.randint(-3, 3))),
            'days_until_next_review': int(base_sample['days_until_next_review'] + np.random.randint(-2, 2)),
            'forgot': base_sample['forgot']  # Keep target
        }
        
        synthetic_data.append(synthetic_sample)
    
    return pd.DataFrame(synthetic_data)

# Usage
synthetic_df = create_synthetic_data(real_data, n_samples=10000)
combined_df = pd.concat([real_data, synthetic_df])
```


### 1.3 Kết Hợp Nhiều Bảng

```sql
-- Query tổng hợp từ nhiều nguồn
WITH user_stats AS (
    SELECT 
        user_id,
        COUNT(DISTINCT vocab_id) as total_vocabs,
        AVG(CASE WHEN times_correct + times_wrong > 0 
            THEN times_correct::float / (times_correct + times_wrong) 
            ELSE 0 END) as user_accuracy
    FROM user_vocab_progress
    GROUP BY user_id
),
game_results AS (
    SELECT 
        gsd.user_id,
        gsd.vocab_id,
        gsd.is_correct,
        gsd.time_taken,
        gsd.created_at,
        v.cefr,
        LENGTH(v.word) as vocab_length
    FROM game_session_details gsd
    JOIN vocabs v ON gsd.vocab_id = v.id
),
vocab_progress AS (
    SELECT 
        uvp.user_id,
        uvp.vocab_id,
        uvp.times_correct,
        uvp.times_wrong,
        uvp.repetition,
        uvp.ef_factor,
        uvp.interval_days,
        uvp.last_reviewed,
        uvp.next_review_date,
        uvp.status
    FROM user_vocab_progress uvp
)
SELECT 
    us.user_id,
    gr.vocab_id,
    us.total_vocabs as user_total_vocabs,
    us.user_accuracy,
    CASE gr.cefr 
        WHEN 'A1' THEN 1 WHEN 'A2' THEN 2 
        WHEN 'B1' THEN 3 WHEN 'B2' THEN 4 
        WHEN 'C1' THEN 5 WHEN 'C2' THEN 6 
        ELSE 3 END as vocab_difficulty,
    gr.vocab_length,
    COALESCE(vp.times_correct, 0) as times_correct,
    COALESCE(vp.times_wrong, 0) as times_wrong,
    COALESCE(vp.repetition, 0) as repetition,
    COALESCE(vp.ef_factor, 2.5) as ef_factor,
    COALESCE(vp.interval_days, 1) as interval_days,
    COALESCE(EXTRACT(DAY FROM (CURRENT_DATE - vp.last_reviewed)), 999) as days_since_last_review,
    COALESCE(EXTRACT(DAY FROM (vp.next_review_date - CURRENT_DATE)), 0) as days_until_next_review,
    -- Target: Dự đoán từ game result tiếp theo
    CASE WHEN gr.is_correct = false THEN 1 ELSE 0 END as forgot
FROM user_stats us
JOIN game_results gr ON us.user_id = gr.user_id
LEFT JOIN vocab_progress vp ON gr.user_id = vp.user_id AND gr.vocab_id = vp.vocab_id
WHERE gr.created_at >= NOW() - INTERVAL '6 months'
ORDER BY gr.created_at DESC;
```

**Ước tính số lượng data:**
- Nếu có 100 users
- Mỗi user chơi 50 games
- Mỗi game có 10 questions
- → **50,000 data points** 🎉


## Giải Pháp 2: Rule-Based Model Trước, ML Model Sau

### Phase 1: Rule-Based Recommendation (Ngay lập tức)

Không cần training data, chỉ cần logic:

```python
def rule_based_recommendation(user_progress_list):
    """
    Gợi ý dựa trên rules đơn giản
    Không cần ML model
    """
    recommendations = []
    
    for progress in user_progress_list:
        priority_score = 0
        reasons = []
        
        # Rule 1: Overdue (40 points)
        if progress.days_until_next_review < 0:
            overdue_days = abs(progress.days_until_next_review)
            priority_score += min(overdue_days * 4, 40)
            reasons.append(f"Quá hạn {overdue_days} ngày")
        
        # Rule 2: Low accuracy (30 points)
        total_attempts = progress.times_correct + progress.times_wrong
        if total_attempts > 0:
            accuracy = progress.times_correct / total_attempts
            if accuracy < 0.5:
                priority_score += 30
                reasons.append("Tỷ lệ đúng thấp")
            elif accuracy < 0.7:
                priority_score += 15
        
        # Rule 3: Difficult vocab (20 points)
        if progress.vocab.cefr in ['C1', 'C2']:
            priority_score += 20
            reasons.append("Từ khó")
        elif progress.vocab.cefr in ['B2']:
            priority_score += 10
        
        # Rule 4: Due today (10 points)
        if progress.days_until_next_review == 0:
            priority_score += 10
            reasons.append("Đến hạn hôm nay")
        
        recommendations.append({
            'vocab_id': progress.vocab.id,
            'priority_score': priority_score,
            'reasons': ' • '.join(reasons)
        })
    
    # Sort by priority
    recommendations.sort(key=lambda x: x['priority_score'], reverse=True)
    
    return recommendations
```

**Ưu điểm:**
- ✅ Không cần training data
- ✅ Deploy ngay lập tức
- ✅ Dễ hiểu, dễ explain
- ✅ Có thể tune rules dựa trên feedback

**Nhược điểm:**
- ❌ Không personalized
- ❌ Không học từ data
- ❌ Accuracy thấp hơn ML


### Phase 2: Hybrid Model (Sau 1-2 tháng)

Kết hợp rule-based và ML:

```python
class HybridRecommendationSystem:
    def __init__(self, ml_model=None, min_samples_for_ml=1000):
        self.ml_model = ml_model
        self.min_samples_for_ml = min_samples_for_ml
        self.use_ml = ml_model is not None
    
    def recommend(self, user_progress_list):
        """
        Hybrid approach:
        - Nếu có đủ data → dùng ML
        - Nếu không đủ data → dùng rules
        - Kết hợp cả 2 với weights
        """
        # Rule-based scores
        rule_scores = self._get_rule_based_scores(user_progress_list)
        
        if self.use_ml and len(user_progress_list) >= self.min_samples_for_ml:
            # ML-based scores
            ml_scores = self._get_ml_scores(user_progress_list)
            
            # Combine: 60% ML + 40% Rules
            final_scores = []
            for rule_score, ml_score in zip(rule_scores, ml_scores):
                combined_score = 0.6 * ml_score['score'] + 0.4 * rule_score['score']
                final_scores.append({
                    'vocab_id': rule_score['vocab_id'],
                    'score': combined_score,
                    'ml_score': ml_score['score'],
                    'rule_score': rule_score['score'],
                    'reason': rule_score['reason']
                })
        else:
            # Chỉ dùng rules
            final_scores = rule_scores
        
        # Sort by score
        final_scores.sort(key=lambda x: x['score'], reverse=True)
        
        return final_scores
    
    def _get_rule_based_scores(self, user_progress_list):
        # Implementation từ phase 1
        pass
    
    def _get_ml_scores(self, user_progress_list):
        # Predict using ML model
        features = self._extract_features(user_progress_list)
        predictions = self.ml_model.predict_proba(features)[:, 1]
        
        return [
            {'vocab_id': p.vocab.id, 'score': pred}
            for p, pred in zip(user_progress_list, predictions)
        ]
```

### Phase 3: Pure ML Model (Sau 3-6 tháng)

Khi đã có đủ data (> 10K samples):

```python
# Train XGBoost với data thật
model = xgb.XGBClassifier(
    n_estimators=200,
    max_depth=6,
    learning_rate=0.1,
    # ... other params
)

model.fit(X_train, y_train)

# Deploy và thay thế rule-based hoàn toàn
```


## Giải Pháp 3: Transfer Learning & Pre-trained Models

### 3.1 Sử dụng SM-2 Algorithm Như Features

```python
def calculate_sm2_forgot_probability(progress):
    """
    Sử dụng SM-2 algorithm để tính xác suất quên
    Không cần training data!
    """
    # SM-2 factors
    ef_factor = progress.ef_factor
    interval_days = progress.interval_days
    days_since_last_review = progress.days_since_last_review
    days_until_next_review = progress.days_until_next_review
    
    # Calculate forgetting curve (Ebbinghaus)
    # R = e^(-t/S)
    # R: retention, t: time, S: strength (related to EF factor)
    
    strength = ef_factor * interval_days
    time_elapsed = days_since_last_review
    
    retention = np.exp(-time_elapsed / strength)
    forgot_probability = 1 - retention
    
    return forgot_probability

# Sử dụng như baseline
for progress in user_progress_list:
    progress.forgot_prob_sm2 = calculate_sm2_forgot_probability(progress)
```

### 3.2 Pretrain Trên Public Dataset

```python
# Sử dụng public spaced repetition dataset
# Ví dụ: Anki dataset, Duolingo dataset

# 1. Download public dataset
import requests
public_data = pd.read_csv('https://example.com/spaced_repetition_data.csv')

# 2. Map features to your schema
public_data_mapped = map_features(public_data)

# 3. Pretrain model
pretrained_model = xgb.XGBClassifier()
pretrained_model.fit(public_data_mapped[features], public_data_mapped['forgot'])

# 4. Fine-tune với data của bạn (khi có đủ)
pretrained_model.fit(
    your_data[features], 
    your_data['forgot'],
    xgb_model=pretrained_model.get_booster()  # Continue training
)
```


## Giải Pháp 4: Active Learning - Thu Thập Data Thông Minh

### 4.1 Chiến Lược Thu Thập

```python
class ActiveLearningDataCollector:
    """
    Thu thập data một cách thông minh
    Ưu tiên những cases khó predict
    """
    
    def __init__(self, model, uncertainty_threshold=0.4):
        self.model = model
        self.uncertainty_threshold = uncertainty_threshold
        self.collected_samples = []
    
    def should_collect_feedback(self, features):
        """
        Quyết định có nên hỏi user feedback không
        """
        if self.model is None:
            return True  # Luôn collect nếu chưa có model
        
        # Predict
        proba = self.model.predict_proba([features])[0]
        confidence = max(proba)
        
        # Nếu model không chắc chắn → collect feedback
        if confidence < (0.5 + self.uncertainty_threshold):
            return True
        
        return False
    
    def collect_feedback(self, vocab_id, user_id, features, actual_result):
        """
        Lưu feedback từ user
        """
        sample = {
            'vocab_id': vocab_id,
            'user_id': user_id,
            'features': features,
            'forgot': actual_result,  # 1 if forgot, 0 if remembered
            'collected_at': datetime.now()
        }
        
        self.collected_samples.append(sample)
        
        # Retrain model khi có đủ samples mới
        if len(self.collected_samples) >= 100:
            self.retrain_model()
    
    def retrain_model(self):
        """
        Retrain model với data mới
        """
        new_data = pd.DataFrame(self.collected_samples)
        # Combine với data cũ và retrain
        # ...
        self.collected_samples = []  # Reset
```

### 4.2 UI Flow Để Thu Thập Feedback

```typescript
// Frontend: Sau khi user ôn tập
interface ReviewFeedback {
  vocabId: string;
  remembered: boolean;  // User có nhớ không?
  confidence: 'low' | 'medium' | 'high';  // Độ tự tin
  timeSpent: number;  // Thời gian suy nghĩ
}

async function submitReviewFeedback(feedback: ReviewFeedback) {
  // Gửi feedback về backend
  await api.post('/api/v1/smart-review/feedback', feedback);
  
  // Backend sẽ lưu vào training data
}
```

```java
// Backend: Lưu feedback
@PostMapping("/feedback")
public ResponseEntity<ApiResponse<Void>> submitFeedback(
    @AuthenticationPrincipal User user,
    @RequestBody ReviewFeedback feedback) {
    
    // Lưu vào bảng training_data
    TrainingData data = TrainingData.builder()
        .userId(user.getId())
        .vocabId(feedback.getVocabId())
        .remembered(feedback.getRemembered())
        .confidence(feedback.getConfidence())
        .timeSpent(feedback.getTimeSpent())
        .collectedAt(LocalDateTime.now())
        .build();
    
    trainingDataRepository.save(data);
    
    return ResponseEntity.ok(ApiResponse.success("Feedback saved"));
}
```


## Giải Pháp 5: Cold Start Problem - Xử Lý User/Vocab Mới

### 5.1 User Mới (Chưa Có Lịch Sử)

```python
def get_recommendations_for_new_user(user_id, vocab_list):
    """
    Gợi ý cho user mới dựa trên:
    - Độ khó của từ (CEFR)
    - Tần suất xuất hiện
    - Popularity (từ phổ biến)
    """
    recommendations = []
    
    for vocab in vocab_list:
        # Default priority cho user mới
        priority = 50  # Base score
        
        # Ưu tiên từ dễ trước (A1, A2)
        if vocab.cefr == 'A1':
            priority += 20
        elif vocab.cefr == 'A2':
            priority += 15
        elif vocab.cefr == 'B1':
            priority += 10
        
        # Ưu tiên từ phổ biến
        if vocab.frequency_rank < 1000:  # Top 1000 words
            priority += 15
        elif vocab.frequency_rank < 3000:
            priority += 10
        
        recommendations.append({
            'vocab_id': vocab.id,
            'priority': priority,
            'reason': 'Từ cơ bản, phổ biến'
        })
    
    recommendations.sort(key=lambda x: x['priority'], reverse=True)
    return recommendations
```

### 5.2 Vocab Mới (Chưa Có Ai Học)

```python
def estimate_difficulty_for_new_vocab(vocab):
    """
    Ước tính độ khó của từ mới dựa trên:
    - CEFR level
    - Độ dài từ
    - Số âm tiết
    - Có phải từ ghép không
    """
    difficulty_score = 0
    
    # CEFR level
    cefr_scores = {'A1': 1, 'A2': 2, 'B1': 3, 'B2': 4, 'C1': 5, 'C2': 6}
    difficulty_score += cefr_scores.get(vocab.cefr, 3) * 10
    
    # Độ dài từ
    word_length = len(vocab.word)
    if word_length > 10:
        difficulty_score += 20
    elif word_length > 7:
        difficulty_score += 10
    
    # Số âm tiết (estimate)
    syllables = estimate_syllables(vocab.word)
    difficulty_score += syllables * 3
    
    # Từ ghép (có dấu gạch ngang)
    if '-' in vocab.word:
        difficulty_score += 5
    
    return difficulty_score

def estimate_syllables(word):
    """Simple syllable counter"""
    vowels = 'aeiou'
    count = 0
    prev_was_vowel = False
    
    for char in word.lower():
        is_vowel = char in vowels
        if is_vowel and not prev_was_vowel:
            count += 1
        prev_was_vowel = is_vowel
    
    return max(1, count)
```

