# Gameplay Mechanics & Algorithms

Tài liệu này mô tả chi tiết luồng hoạt động, cách chọn từ vựng, thuật toán và hệ thống tính điểm của ba mini–game: Quick Reflex Quiz, Image-Word Matching, Word-Definition Matching.

---

## 1. Quick Reflex Quiz

**Mục tiêu:** Chọn nghĩa đúng càng nhanh càng tốt để đạt điểm cao và duy trì streak.

### 1.1 Luồng Hoạt Động

1. Client gửi request `POST /games/quick-quiz/start` (tham số: `totalQuestions`, `timePerQuestion`, tùy chọn `cefr`).
2. Server:
    - Validate tham số (2–40 câu, mỗi câu 3–60 giây).
    - Kiểm tra rate limit (tối đa 10 game / 5 phút / user).
    - Tải danh sách vocab theo bộ lọc CEFR (nếu có), random toàn bộ.
    - Chọn `totalQuestions * 4` từ vựng (mỗi câu 1 đúng + 3 sai).
    - Tạo session (UUID) và cache toàn bộ câu hỏi + giới hạn thời gian + timestamp câu hỏi đầu.
    - Trả về câu hỏi đầu tiên + metadata session.
3. Người chơi trả lời từng câu qua `POST /games/quick-quiz/answer`:
    - Server kiểm tra: session tồn tại, quyền truy cập, chưa kết thúc, chưa trả lời trùng.
    - Anti-cheat: thời gian trả lời >= 100ms, không vượt quá limit, đối chiếu timestamp server (tolerance 3000ms).
    - Tính điểm và streak, lưu chi tiết câu hỏi.
    - Cập nhật tiến độ spaced repetition cho từ vựng chính (SM-2 rút gọn).
    - Nếu còn câu → trả câu tiếp theo + start timestamp; nếu hết → kết thúc game.
4. Kết thúc:
    - Tính accuracy, duration, longest streak.
    - Cập nhật leaderboard ("quick-quiz").
    - Tạo notification achievement (score ≥80, accuracy ≥90%, 100%).
    - Xóa cache session khỏi Redis.

### 1.2 Tạo Câu Hỏi

-   Mỗi câu: chọn 4 vocab liên tiếp trong danh sách đã random.
-   Sau đó shuffle lại để random vị trí đáp án đúng.
-   Trả về: word + các nghĩa/thuộc tính của 4 lựa chọn (ẩn chỉ số đáp án đúng).

### 1.3 Thuật Toán Tính Điểm

Các hằng số:

-   BASE_POINTS = 10 (mỗi câu đúng).
-   STREAK_BONUS = 5 (cộng thêm mỗi nhóm 3 streak: `bonus = STREAK_BONUS * (currentStreak / 3)`).
-   SPEED_BONUS_THRESHOLD = 1500ms (trả lời nhanh hơn ngưỡng được +5 điểm).

Công thức điểm cho 1 câu đúng:

```
points = BASE_POINTS
if currentStreak >= 3:
    points += STREAK_BONUS * (currentStreak / 3)
if timeTaken < SPEED_BONUS_THRESHOLD:
    points += 5
```

Sai / Skip: 0 điểm, streak reset.

### 1.4 Accuracy & Streak

-   `accuracy = correctCount * 100.0 / totalAnswered`.
-   Longest streak tính bằng quét toàn bộ `GameSessionDetail`.

### 1.5 Spaced Repetition (SM‑2 Rút Gọn)

Khi trả lời:

-   Đúng: `timesCorrect++`, `repetition++`:
    -   repetition==1 → intervalDays=1
    -   repetition==2 → intervalDays=6
    -   repetition>=3 → `intervalDays *= efFactor`
-   Sai: `timesWrong++`, repetition reset 0, intervalDays=1.
-   Cập nhật status bằng `VocabStatusCalculator` (dựa trên tỉ lệ đúng/sai + trạng thái trước).
-   Set `lastReviewed=today`, `nextReviewDate = today + intervalDays`.

---

## 2. Image-Word Matching

**Mục tiêu:** Chọn từ vựng phù hợp với hình ảnh; tối ưu điểm bằng tốc độ và độ khó (CEFR).

### 2.1 Luồng Hoạt Động

1. Client gọi `POST /games/image-word-matching/start` (tham số: `totalPairs`, tùy chọn `cefr`).
2. Server:
    - Lấy vocab có hình (`img != null`), filter CEFR nếu có, random.
    - Validate đủ số lượng cặp.
    - Tạo session + cache danh sách vocabs của phiên.
3. Người chơi gửi đáp án `submitAnswer`:
    - Request: `sessionId`, `matchedVocabIds[]`, `timeTaken(ms)`, `wrongAttempts` (số lần ghép sai).
    - Server kiểm tra session, quyền, chưa hoàn thành.
    - Duyệt từng vocab: xác định đúng/sai trong danh sách matched.
    - Tính điểm CEFR + time bonus - wrong penalty.
    - Lưu `GameSessionDetail` cho từng vocab.
    - Cập nhật `UserVocabProgress` (giống QuickQuiz logic rút gọn, nhưng ở code hiện tại chỉ cộng timesCorrect/timesWrong và tính lại status; intervalDays cố định 1 nếu chưa mở rộng).
4. Hoàn thành: set `finishedAt`, lưu score, accuracy, xóa cache, ghi streak.

### 2.2 Chọn Từ Vựng

```
if cefr specified:
    vocabs = findByCefr(cefr)
else:
    vocabs = findAllWithImage()
shuffle(vocabs)
limit(count)
```

Yêu cầu: phải đủ `totalPairs` vocab.

### 2.3 Tính Điểm

Điểm cơ bản theo CEFR:

```
A1=1, A2=2, B1=3, B2=4, C1=5, C2=6 (default 1 nếu null)
```

Time Bonus (phần trăm trên tổng CEFR score):

```
<10s  => +50%
<20s  => +30%
<30s  => +20%
<60s  => +10%
>=60s => +0%
```

Wrong Penalty (phạt số lần ghép sai):

```
wrongPenalty = wrongAttempts × 2
```

Công thức tổng điểm:

```
totalScore = max(0, cefrScore + timeBonus - wrongPenalty)

Trong đó:
- cefrScore: Tổng điểm CEFR của các cặp ghép đúng
- timeBonus: round(cefrScore × bonusPercentage)
- wrongPenalty: wrongAttempts × 2
- Điểm tối thiểu: 0 (không âm)
```

### 2.4 Accuracy

`accuracy = correctMatches / totalPairs * 100`.

### 2.5 Cập Nhật Tiến Độ Học Từ

-   Tăng `timesCorrect` nếu đúng, ngược lại `timesWrong`.
-   Tính lại status bằng `VocabStatusCalculator`.
-   `lastReviewed = today`, `nextReviewDate = today + intervalDays` (nếu intervalDays > 0; mặc định 1).
-   Không áp dụng logic SM-2 nâng cao trong phiên bản hiện tại (có thể mở rộng sau).

---

## 3. Word-Definition Matching

**Mục tiêu:** Ghép từ với nghĩa tiếng Việt. Tối ưu điểm bằng độ khó (CEFR) và tốc độ hoàn thành toàn bộ.

### 3.1 Luồng Hoạt Động

1. Client gọi `POST /games/word-definition-matching/start` với `totalPairs` (2–5) và tùy chọn `cefr`.
2. Server:
    - Validate số cặp (2 ≤ totalPairs ≤ 5).
    - Lấy vocab (filter CEFR nếu có, không yêu cầu hình ảnh) → shuffle → limit.
    - Tạo session + cache `SessionData` (danh sách vocabs).
    - Trả về list vocab (word, meaningVi, ...). FE tự render thẻ để ghép.
3. Khi người chơi hoàn thành, gửi `POST /games/word-definition-matching/submit`:
    - Request: `sessionId`, `matchedVocabIds[]`, `timeTaken(ms)`, `wrongAttempts` (số lần ghép sai).
    - Server kiểm tra session, quyền truy cập, chưa kết thúc.
    - Xác nhận số lượng ID khớp với số từ trong session.
    - Với mỗi vocab: nếu nằm trong submitted set → đúng.
    - Tính điểm CEFR + time bonus - wrong penalty.
    - Lưu từng `GameSessionDetail`, cập nhật `UserVocabProgress`.
    - Xóa cache phiên, ghi streak.
4. Trả về kết quả: tổng điểm, số đúng, độ chính xác, chi tiết từng từ, breakdown (cefrScore, timeBonus, wrongPenalty).

### 3.2 Chọn Từ Vựng

```
if cefr != null:
    vocabs = findByCefr(cefr)
else:
    vocabs = findAll()
shuffle(vocabs)
limit(totalPairs)
```

Yêu cầu: đủ số lượng, nếu thiếu → báo lỗi.

### 3.3 Tính Điểm

Giống Image-Word Matching:

```
CEFR: A1=1, A2=2, B1=3, B2=4, C1=5, C2=6

Time Bonus (phần trăm trên tổng CEFR score):
  <10s => 0.50 (+50%)
  <20s => 0.30 (+30%)
  <30s => 0.20 (+20%)
  <60s => 0.10 (+10%)
  else => 0

Wrong Penalty:
  wrongPenalty = wrongAttempts × 2

Công thức:
  totalScore = max(0, cefrScore + round(cefrScore × bonusPercentage) - wrongPenalty)
```

### 3.4 Accuracy

`accuracy = correctMatches / totalPairs * 100`.

### 3.5 Cập Nhật Tiến Độ Học Từ

-   Nếu đúng: `timesCorrect++`, sai: `timesWrong++`.
-   Khởi tạo record mới nếu chưa có (status=NEW, efFactor=2.5, interval=1, repetition=0).
-   Gọi `VocabStatusCalculator.calculateStatus(oldStatus, timesCorrect, timesWrong)`.
-   Cập nhật ngày ôn (`lastReviewed = today`) và `nextReviewDate = today + intervalDays`.

---

## 4. So Sánh Nhanh Ba Game

| Thuộc tính        | Quick Reflex Quiz                                       | Image-Word Matching               | Word-Definition Matching        |
| ----------------- | ------------------------------------------------------- | --------------------------------- | ------------------------------- |
| Kiểu tương tác    | Trả lời từng câu (MCQ)                                  | Ghép / chọn theo hình ảnh (batch) | Ghép word-meaning (batch)       |
| Chọn vocab        | `totalQuestions * 4` (1 đúng + 3 sai mỗi câu)           | `totalPairs` có hình              | `totalPairs` tự do              |
| Điểm cơ bản       | BASE_POINTS (10) mỗi câu đúng                           | Summed CEFR points                | Summed CEFR points              |
| Bonus             | Streak + Speed (<1500ms)                                | Time bonus - Wrong penalty        | Time bonus - Wrong penalty      |
| Accuracy          | correct / answered                                      | correct / totalPairs              | correct / totalPairs            |
| Spaced repetition | SM-2 rút gọn (interval tăng dần)                        | Đơn giản (intervalDays cố định)   | Đơn giản (intervalDays cố định) |
| Cache             | Questions + time per question + per-question start time | Session vocabs                    | Session vocabs                  |
| Anti-cheat        | Min time + server timestamp tolerance                   | Wrong attempts tracking           | Wrong attempts tracking         |

---

## 5. Mở Rộng / Gợi Ý Nâng Cấp

-   Thống nhất cơ chế SM-2 chi tiết (easeFactor điều chỉnh khi trả lời sai, quality score).
-   Bổ sung adaptive difficulty: chọn vocab đúng nhiều lần → tăng CEFR hoặc thêm distractors khó hơn.
-   Thêm per‑question time decay scoring cho Image/WordDefinition (hiện tại chỉ bonus theo tổng thời gian).
-   Thêm logging chi tiết latency client vs server để phát hiện nghi ngờ gian lận.
-   Gamification nâng cao: badges theo streak (10, 25, 50), cấp độ chuyên sâu từng CEFR.

---

## 6. Tóm Tắt Công Thức Chính

```
QuickQuiz:
 points = 10
 if streak >= 3: points += 5 * (streak / 3)
 if timeTaken < 1500ms: points += 5
 totalScore = Σ(points per correct answer)
 accuracy = correctCount * 100 / answered

Image/WordDefinition:
 cefrScore = Σ(cefrPoint(vocab))
 timeBonus = round(cefrScore * bonusPercentByTotalTime)
 wrongPenalty = wrongAttempts × 2
 totalScore = max(0, cefrScore + timeBonus - wrongPenalty)
 accuracy = correctMatches * 100 / totalPairs

Spaced Repetition (simplified):
 if correct:
   timesCorrect++ ; repetition++
   intervalDays progression: 1 → 6 → interval * efFactor
 else:
   timesWrong++ ; repetition=0 ; intervalDays=1
 status = VocabStatusCalculator(oldStatus, timesCorrect, timesWrong)
 lastReviewed=today ; nextReviewDate=today + intervalDays
```

---

## 7. Phụ Lục: Các Hằng Số

-   QUICK QUIZ: `BASE_POINTS=10`, `STREAK_BONUS=5`, `SPEED_BONUS_THRESHOLD=1500ms`, `MIN_ANSWER_TIME=100ms`, `TIME_TOLERANCE_MS=3000ms`.
-   IMAGE / WORD-DEFINITION:
    -   Time bonus tiers: `<10s 50%`, `<20s 30%`, `<30s 20%`, `<60s 10%`.
    -   Wrong penalty: `2 điểm/lần sai`.
-   Spaced repetition default: `efFactor=2.5`, `intervalDays=1` khi mới.

---

**Kết luận:** Ba game chia sẻ chung cơ chế lưu session, cập nhật tiến độ học và sử dụng Redis để cache phiên. Khác biệt chính nằm ở cấu trúc câu hỏi, cách chọn distrators, và công thức bonus thời gian / streak. Image-Word Matching và Word-Definition Matching thêm hệ thống phạt số lần sai để khuyến khích người chơi cẩn thận hơn khi ghép cặp.
