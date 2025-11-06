    # 🎯 QUICK GUIDE: VocabStatus và Streak

## TL;DR

### VocabStatus (Trạng thái từ vựng) 📚
**4 trạng thái cho MỖI TỪ:**

1. **NEW** 🆕 - Chưa có trong `user_vocab_progress`
2. **KNOWN** ✅ - User nhấn "Đã thuộc" (`isCorrect = true`)
3. **UNKNOWN** ❌ - User nhấn "Chưa thuộc" (`isCorrect = false`)
4. **MASTERED** 🏆 - Tự động: `timesCorrect >= 10` && `accuracy >= 80%` && `timesWrong <= 2`

### StreakStatus (Trạng thái học tập) 🔥
**4 trạng thái cho USER:**

1. **NEW** 🆕 - Chưa học lần nào
2. **ACTIVE** 🔥 - Đã học hôm nay
3. **PENDING** ⏰ - Cần học hôm nay (học hôm qua)
4. **BROKEN** 💔 - Đã bỏ lỡ > 1 ngày

---

## ⚡ Điểm quan trọng

### Streak KHÔNG phụ thuộc VocabStatus!

✅ **Streak tăng khi:**
- User học **từ mới** (tạo record mới trong `user_vocab_progress`)
- `created_at` = hôm nay
- Không quan tâm user chọn KNOWN hay UNKNOWN

❌ **Streak KHÔNG tăng khi:**
- User chỉ ôn lại từ cũ (record đã tồn tại)
- `created_at` ≠ hôm nay

### Ví dụ

```
Ngày 1/10:
❌ Học từ A → Chọn "Chưa thuộc" (UNKNOWN)
❌ Học từ B → Chọn "Chưa thuộc" (UNKNOWN)
→ Streak = 1 ✅ (vẫn tăng vì học đều!)

Ngày 2/10:
✅ Học từ C → Chọn "Đã thuộc" (KNOWN)
→ Streak = 2 ✅

Ngày 3/10:
🔄 Ôn lại từ A (đã học 1/10)
🔄 Ôn lại từ B (đã học 1/10)
→ Streak = BROKEN ❌ (không có từ mới ngày 3/10!)
```

---

## 🎓 Best Practice

**Để duy trì streak:** Học ít nhất **1 từ mới** mỗi ngày  
**Không quan trọng:** Từ đó KNOWN hay UNKNOWN  
**Quan trọng:** Học **ĐỀU ĐẶN** mỗi ngày

---

📖 Chi tiết: Xem `VOCAB_STATUS_VS_STREAK_STATUS.md`

