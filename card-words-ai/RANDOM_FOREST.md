# Card Words AI - Random Forest Model

## Tổng quan

Mô hình **Random Forest** đã được thêm vào `card-words-ai` service, hoạt động song song với mô hình XGBoost hiện có.

## Đặc điểm Random Forest

### Hyperparameters

```python
{
    'n_estimators': 100,        # 100 cây quyết định
    'max_depth': 10,            # Độ sâu tối đa mỗi cây
    'min_samples_split': 5,     # Tối thiểu 5 samples để split node
    'min_samples_leaf': 2,      # Tối thiểu 2 samples ở leaf
    'max_features': 'sqrt',     # Số features tối đa = sqrt(n_features)
    'random_state': 42,
    'n_jobs': -1,               # Dùng tất cả CPU cores
    'class_weight': 'balanced'  # Tự động cân bằng class
}
```

### Features (9 chiều - giống XGBoost)

1. times_correct
2. times_wrong
3. accuracy_rate
4. days_since_last_review
5. days_until_next_review
6. interval_days
7. repetition
8. ef_factor
9. status_encoded

### Labeling (giống XGBoost)

-   **Label = 1** (cần ôn): UNKNOWN, NEW, hoặc KNOWN + (quá hạn hoặc accuracy < 70%)
-   **Label = 0**: còn lại

## Cấu hình

### Environment Variables (.env)

```env
# Active model: "xgboost" hoặc "random_forest"
ACTIVE_MODEL_TYPE=xgboost

# Random Forest paths
RF_MODEL_PATH=/app/models/random_forest_model_v1.pkl
RF_SCALER_PATH=/app/models/rf_scaler_v1.pkl
RF_MODEL_VERSION=v1.0.0
```

## Sử dụng

### 1. Train Random Forest model

**Linux/Mac:**

```bash
cd card-words-ai
./train-rf-model.sh
```

**Windows PowerShell:**

```powershell
cd card-words-ai
.\train-rf-model.ps1
```

**Hoặc dùng curl:**

```bash
curl -X POST http://localhost:8001/api/v1/smart-review/retrain \
  -H "X-API-Key: card-words-admin-key-2024" \
  -H "Content-Type: application/json" \
  -d '{
    "force": true,
    "model_type": "random_forest"
  }'
```

### 2. Train XGBoost model

```bash
curl -X POST http://localhost:8001/api/v1/smart-review/retrain \
  -H "X-API-Key: card-words-admin-key-2024" \
  -H "Content-Type: application/json" \
  -d '{
    "force": true,
    "model_type": "xgboost"
  }'
```

### 3. Chuyển đổi active model

Sửa file `.env`:

```env
ACTIVE_MODEL_TYPE=random_forest  # hoặc "xgboost"
```

Restart service:

```bash
docker-compose restart card-words-ai
```

### 4. Kiểm tra health

```bash
curl http://localhost:8001/health
```

Response:

```json
{
    "status": "healthy",
    "service": "card-words-ai",
    "model_loaded": true,
    "active_model_type": "xgboost",
    "xgboost_loaded": true,
    "rf_loaded": true,
    "database_connected": true,
    "redis_connected": true,
    "timestamp": "2025-11-24T10:00:00"
}
```

## So sánh XGBoost vs Random Forest

| Tiêu chí               | XGBoost              | Random Forest           |
| ---------------------- | -------------------- | ----------------------- |
| **Tốc độ training**    | Nhanh hơn            | Chậm hơn                |
| **Tốc độ inference**   | Nhanh                | Trung bình              |
| **Độ chính xác**       | Cao (thường tốt hơn) | Tốt                     |
| **Overfitting**        | Cần tuning cẩn thận  | Ít overfitting hơn      |
| **Feature importance** | Có (gain-based)      | Có (built-in)           |
| **Cân bằng class**     | Cần scale_pos_weight | class_weight='balanced' |
| **Parallel training**  | Hạn chế              | Tốt (n_jobs=-1)         |

## Metrics

Sau khi training, cả 2 model đều trả về:

-   **accuracy**: Độ chính xác tổng thể
-   **precision**: Độ chính xác positive class
-   **recall**: Độ phủ positive class
-   **f1_score**: Điểm F1
-   **auc_roc**: Area Under ROC Curve

**Random Forest thêm:**

-   **feature_importances**: Độ quan trọng từng feature

## Khi nào dùng Random Forest?

✅ **Nên dùng khi:**

-   Dataset nhỏ (< 10,000 samples)
-   Cần tránh overfitting
-   Cần feature importances rõ ràng
-   Có nhiều CPU cores để parallel training

❌ **Không nên dùng khi:**

-   Dataset rất lớn (> 100,000 samples)
-   Cần inference cực nhanh
-   Đã có XGBoost tuning tốt

## Troubleshooting

### Model không load được

```bash
# Kiểm tra file tồn tại
ls -la card-words-ai/models/

# Train lại
./train-rf-model.sh
```

### Lỗi "Insufficient class diversity"

-   Cần ít nhất 10 samples và có cả 2 class (need review / no need)
-   Thêm dữ liệu vocab progress đa dạng hơn

### Memory issues khi training

-   Giảm `n_estimators` (100 → 50)
-   Giảm `max_depth` (10 → 8)
-   Hoặc dùng XGBoost thay thế

## Files cấu trúc

```
card-words-ai/
├── app/
│   └── core/
│       └── ml/
│           ├── xgboost_model.py
│           └── random_forest_model.py  ← MỚI
├── models/
│   ├── xgboost_model_v1.pkl
│   ├── scaler_v1.pkl
│   ├── random_forest_model_v1.pkl     ← MỚI
│   └── rf_scaler_v1.pkl               ← MỚI
├── train-rf-model.sh                   ← MỚI
├── train-rf-model.ps1                  ← MỚI
└── RANDOM_FOREST.md                    ← MỚI
```

## Performance Tips

1. **Tăng tốc training:**

    - `n_jobs=-1` (dùng tất cả cores)
    - Giảm `n_estimators` nếu dataset lớn

2. **Tăng accuracy:**

    - Tăng `n_estimators` (100 → 200)
    - Tăng `max_depth` (10 → 15)
    - Tune `min_samples_split` và `min_samples_leaf`

3. **Giảm overfitting:**
    - Giảm `max_depth`
    - Tăng `min_samples_split`
    - Tăng `min_samples_leaf`

## API Documentation

Chi tiết API xem [README.md](README.md) - tất cả endpoints giống nhau, chỉ khác `model_type` parameter khi retrain.
