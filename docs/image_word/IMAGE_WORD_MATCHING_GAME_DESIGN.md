# Ý Tưởng và Thiết Kế Game Image-Word Matching

## 📋 Mục Lục

1. [Giới Thiệu](#giới-thiệu)
2. [Ý Tưởng Chính](#ý-tưởng-chính)
3. [Mục Tiêu Học Tập](#mục-tiêu-học-tập)
4. [Thiết Kế Game](#thiết-kế-game)
5. [Cơ Chế Chơi](#cơ-chế-chơi)
6. [Hệ Thống Chấm Điểm](#hệ-thống-chấm-điểm)
7. [Ưu Điểm Nổi Bật](#ưu-điểm-nổi-bật)
8. [Công Nghệ Sử Dụng](#công-nghệ-sử-dụng)

---

## 1. Giới Thiệu

### 1.1. Tổng Quan

**Image-Word Matching** là một trò chơi học từ vựng tiếng Anh tương tác, kết hợp giữa hình ảnh và từ vựng để tạo ra trải nghiệm học tập hiệu quả và thú vị. Game sử dụng phương pháp **học qua hình ảnh** (Visual Learning) và **học chủ động** (Active Learning) để giúp người học ghi nhớ từ vựng tốt hơn.

**Đặc điểm chính:**

-   ✅ **Single Mode**: Chế độ chơi duy nhất, đơn giản và tập trung
-   ✅ **Random Vocabulary**: Từ vựng ngẫu nhiên, không giới hạn chủ đề
-   ✅ **CEFR-Based Scoring**: Điểm tính theo cấp độ CEFR (A1=1pt → C2=6pt)
-   ✅ **Time Bonus**: Hoàn thành nhanh được cộng điểm (lên đến +50%)
-   ✅ **Frontend Card Generation**: Backend trả về vocab, frontend tạo cards
-   ✅ **30-Minute Session**: Session được cache 30 phút

### 1.2. Bối Cảnh

Trong bối cảnh giáo dục hiện đại, việc học ngoại ngữ đang chuyển dịch từ phương pháp truyền thống sang các hình thức **gamification** (trò chơi hóa). Nghiên cứu cho thấy:

-   **Visual Learning**: Con người ghi nhớ 80% những gì nhìn thấy so với 20% những gì đọc
-   **Active Recall**: Trò chơi tương tác giúp cải thiện khả năng ghi nhớ lâu dài
-   **Motivation**: Gamification tăng động lực học tập lên 40-50%

### 1.3. Đối Tượng Người Chơi

-   **Học sinh/Sinh viên**: Học từ vựng theo chương trình (CEFR A1-C2)
-   **Người tự học**: Muốn cải thiện vốn từ vựng tiếng Anh
-   **Trẻ em**: Học từ vựng cơ bản qua hình ảnh sinh động
-   **Người lớn**: Ôn tập và củng cố kiến thức

---

## 2. Ý Tưởng Chính

### 2.1. Concept Core

Game dựa trên ý tưởng **"Memory Matching"** (ghép thẻ trí nhớ) kết hợp với **"Visual Association"** (liên kết hình ảnh):

```
Hình Ảnh (Visual) + Từ Vựng (Textual) = Ghi Nhớ Mạnh Mẽ
```

**Nguyên lý hoạt động:**

1. Người chơi được hiển thị một tập hợp hình ảnh và từ vựng
2. Nhiệm vụ: Ghép đúng hình ảnh với từ tương ứng
3. Phản hồi ngay lập tức: Đúng/Sai + Giải thích
4. Tích điểm và theo dõi tiến độ

### 2.2. Tầm Nhìn (Vision)

Tạo ra một nền tảng học từ vựng:

-   ✅ **Hiệu quả**: Sử dụng khoa học nhận thức (Cognitive Science)
-   ✅ **Thú vị**: Gamification khuyến khích người học
-   ✅ **Linh hoạt**: Nhiều chế độ chơi phù hợp mọi trình độ
-   ✅ **Có đo lường**: Theo dõi tiến độ và phân tích kết quả

### 2.3. Sứ Mệnh (Mission)

> **"Biến việc học từ vựng từ nhàm chán thành thú vị, từ thụ động thành chủ động, từ cô đơn thành cạnh tranh lành mạnh"**

### 2.4. Cảm Hứng Thiết Kế

Game lấy cảm hứng từ:

-   **Duolingo**: Gamification và daily streak
-   **Memrise**: Visual learning với memes
-   **Quizlet**: Flashcards và học tập tương tác
-   **Memory Game**: Classic matching game

Nhưng được **cải tiến** với:

-   ✨ Nhiều chế độ chơi đa dạng
-   ✨ Hệ thống chấm điểm thông minh
-   ✨ Độ khó tăng dần tự động
-   ✨ Leaderboard cạnh tranh

---

## 3. Mục Tiêu Học Tập

### 3.1. Mục Tiêu Chính

#### 📚 **Nhận Biết Từ Vựng (Recognition)**

-   Nhận diện từ vựng qua hình ảnh
-   Liên kết hình ảnh với từ đúng
-   Phát triển vocabulary bank

#### 🧠 **Ghi Nhớ Lâu Dài (Long-term Retention)**

-   Sử dụng **Visual Memory**: Não bộ ghi nhớ hình ảnh tốt hơn chữ
-   Áp dụng **Active Recall**: Trò chơi yêu cầu nhớ lại chủ động
-   **Spaced Repetition**: Từ sai được lặp lại nhiều hơn

#### ⚡ **Phản Xạ Ngôn Ngữ (Language Reflex)**

-   Rút ngắn thời gian suy nghĩ
-   Tăng tốc độ nhận diện từ
-   Tự động hóa quá trình recall

### 3.2. Kỹ Năng Phát Triển

```
┌─────────────────────────────────────┐
│   COGNITIVE SKILLS (Kỹ năng tư duy) │
├─────────────────────────────────────┤
│ • Visual Processing (Xử lý hình ảnh)│
│ • Pattern Recognition (Nhận dạng)    │
│ • Memory Recall (Nhớ lại)            │
│ • Attention & Focus (Tập trung)      │
│ • Decision Making (Ra quyết định)    │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  LANGUAGE SKILLS (Kỹ năng ngôn ngữ) │
├─────────────────────────────────────┤
│ • Vocabulary Building (Xây dựng vốn)│
│ • Word-Image Association (Liên kết) │
│ • Spelling Recognition (Chính tả)   │
│ • Contextual Understanding (Ngữ cảnh)│
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│   SOFT SKILLS (Kỹ năng mềm)         │
├─────────────────────────────────────┤
│ • Time Management (Quản lý thời gian)│
│ • Competition Spirit (Tinh thần thi đua)│
│ • Persistence (Kiên trì)             │
│ • Self-improvement (Tự cải thiện)    │
└─────────────────────────────────────┘
```

### 3.3. Phương Pháp Học

#### **Constructivism (Học tập xây dựng)**

-   Người học tự khám phá và tạo liên kết
-   Không áp đặt, chỉ hướng dẫn
-   Học qua trải nghiệm

#### **Immediate Feedback (Phản hồi ngay lập tức)**

-   Biết ngay đúng/sai
-   Giải thích lý do
-   Củng cố kiến thức đúng

#### **Progressive Difficulty (Độ khó tăng dần)**

-   Bắt đầu dễ để xây dựng tự tin
-   Tăng dần để thách thức
-   Tránh quá dễ (nhàm chán) hoặc quá khó (nản lòng)

---

## 4. Thiết Kế Game

### 4.1. Kiến Trúc Tổng Thể

```
┌─────────────────────────────────────────────────┐
│              IMAGE-WORD MATCHING                │
├─────────────────────────────────────────────────┤
│                                                 │
│              ┌──────────────────┐               │
│              │   SINGLE MODE    │               │
│              │  (Only 1 Mode)   │               │
│              └────────┬─────────┘               │
│                       │                         │
│              ┌────────▼────────┐                │
│              │  CORE ENGINE    │                │
│              ├─────────────────┤                │
│              │ • Vocab Pool    │                │
│              │ • CEFR Filter   │                │
│              │ • Validation    │                │
│              │ • Scoring       │                │
│              │ • Time Bonus    │                │
│              │ • Session Cache │                │
│              └────────┬────────┘                │
│                       │                         │
│       ┌───────────────┼───────────────┐         │
│       ▼               ▼               ▼         │
│  ┌─────────┐  ┌──────────┐  ┌──────────┐       │
│  │Database │  │  Cache   │  │Analytics │      │
│  └─────────┘  └──────────┘  └──────────┘      │
└─────────────────────────────────────────────────┘
```

### 4.2. Ba Chế Độ Chơi

#### 🎮 **Mode 1: Classic Mode (Chế độ Cổ điển)**

**Mô tả:**

-   Giống Memory Game truyền thống
-   Tất cả thẻ úp ngửa, người chơi lật từng cặp
-   Nhấn mạnh vào **trí nhớ** và **tập trung**

**Cơ chế:**

```
1. Hiển thị 2N thẻ úp (N hình ảnh + N từ)
2. Click để lật 2 thẻ
3. Nếu khớp → Giữ mở, +điểm
4. Nếu không → Úp lại, cần nhớ vị trí
5. Tiếp tục cho đến hết
```

**Đặc điểm:**

-   ⏱️ **Không giới hạn thời gian** (stress-free)
-   🧠 **Rèn luyện trí nhớ ngắn hạn**
-   🎯 **Phù hợp người mới bắt đầu**
-   📊 **Số cặp**: 6-10 pairs (12-20 thẻ)

**Kỹ năng phát triển:**

-   Visual memory (Trí nhớ hình ảnh)
-   Spatial awareness (Nhận thức không gian)
-   Concentration (Tập trung)

---

#### ⚡ **Mode 2: Speed Match (Ghép Nhanh)**

**Mô tả:**

-   Đua với thời gian
-   Tất cả thẻ mở, người chơi ghép nhanh
-   Nhấn mạnh vào **tốc độ** và **phản xạ**

**Cơ chế:**

```
1. Hiển thị N hình ảnh (cột trái) + N từ (cột phải)
2. Đếm ngược: 30-60 giây
3. Kéo từ và thả vào hình ảnh tương ứng
4. Submit khi hoàn thành hoặc hết giờ
5. Bonus nếu làm nhanh
```

**Đặc điểm:**

-   ⏰ **Có giới hạn thời gian** (30-60s)
-   ⚡ **Rèn luyện phản xạ ngôn ngữ**
-   🏃 **Phù hợp người có kinh nghiệm**
-   📊 **Số cặp**: 5 pairs (thời gian ngắn)

**Kỹ năng phát triển:**

-   Quick thinking (Tư duy nhanh)
-   Time management (Quản lý thời gian)
-   Decision making under pressure (Quyết định dưới áp lực)
-   Word-image reflex (Phản xạ từ-hình)

**Chiến lược điểm:**

```
Base Score: 10đ/cặp đúng
Time Bonus:
  • < 30s: +20đ (Very Fast!)
  • 30-45s: +10đ (Fast)
  • > 45s: 0đ (Normal)
Perfect Bonus:
  • 100% đúng: +15đ
```

---

#### 📈 **Mode 3: Progressive Challenge (Thử Thách Tăng Dần)**

**Mô tả:**

-   Độ khó tăng dần theo level
-   Mỗi level thêm 1 cặp mới
-   Nhấn mạnh vào **tiến bộ** và **thách thức**

**Cơ chế:**

```
Level 1: 3 cặp → Hoàn thành với ≥80% accuracy
         ↓
Level 2: 4 cặp → Hoàn thành với ≥80% accuracy
         ↓
Level 3: 5 cặp → Hoàn thành với ≥80% accuracy
         ↓
Level N: (3 + N - 1) cặp
```

**Đặc điểm:**

-   📈 **Độ khó tăng tự động**
-   🎓 **Phù hợp mọi trình độ**
-   🏆 **Tạo cảm giác thành tựu**
-   🔄 **Học lại từ sai nhiều lần**

**Điều kiện lên level:**

```
IF accuracy >= 80%:
    → Level up: +1 pair
    → Giữ lại điểm
    → Từ vựng mới
ELSE:
    → Game over
    → Hiển thị level đạt được
```

**Kỹ năng phát triển:**

-   Adaptive learning (Học thích nghi)
-   Mastery learning (Học thành thạo)
-   Self-challenge (Tự thách thức)
-   Progressive difficulty (Tăng dần độ khó)

**Tâm lý học:**

-   **Flow State**: Độ khó tăng vừa phải giữ người chơi trong "vùng thách thức"
-   **Achievement Unlocking**: Mỗi level là một thành tựu nhỏ
-   **Incremental Progress**: Tiến bộ từng bước nhỏ dễ dàng hơn mục tiêu lớn

---

### 4.3. So Sánh Ba Chế Độ

| Tiêu Chí         | Classic        | Speed Match    | Progressive    |
| ---------------- | -------------- | -------------- | -------------- |
| **Thời gian**    | Không giới hạn | 30-60s         | Không giới hạn |
| **Số cặp**       | 6-10 (cố định) | 5 (cố định)    | 3→∞ (tăng dần) |
| **Độ khó**       | Trung bình     | Khó            | Dễ → Khó       |
| **Kỹ năng**      | Trí nhớ        | Phản xạ        | Thích nghi     |
| **Mục tiêu**     | Ghi nhớ        | Tốc độ         | Tiến bộ        |
| **Áp lực**       | Thấp           | Cao            | Trung bình     |
| **Người chơi**   | Mới bắt đầu    | Có kinh nghiệm | Mọi trình độ   |
| **Điểm bonus**   | Perfect        | Time + Perfect | Perfect        |
| **Replay value** | Trung bình     | Cao            | Rất cao        |

---

## 5. Cơ Chế Chơi

### 5.1. Luồng Chơi Tổng Quát

```
START
  ↓
1. Chọn Mode (Classic/Speed/Progressive)
  ↓
2. Chọn Difficulty (Topic, CEFR level, Số cặp)
  ↓
3. Server tạo session:
   • Random chọn N vocabs có hình ảnh
   • Tạo 2N cards (N images + N words)
   • Shuffle ngẫu nhiên
  ↓
4. Hiển thị Game Board
  ↓
5. Người chơi tương tác:
   • Classic: Click lật thẻ
   • Speed: Kéo thả ghép
   • Progressive: Tương tự Classic
  ↓
6. Submit câu trả lời (tất cả cặp cùng lúc)
  ↓
7. Server validate:
   • So sánh vocab.word với matchedWord
   • Đếm số đúng/sai
   • Tính accuracy
  ↓
8. Tính điểm:
   • Base score (10đ/cặp đúng)
   • Time bonus (nếu Speed Match)
   • Perfect bonus (100% đúng)
  ↓
9. Lưu kết quả:
   • GameSession (session info)
   • GameSessionDetail (từng vocab)
   • UserVocabProgress (tracking)
  ↓
10. Hiển thị kết quả:
    • Score, Accuracy, Time
    • Danh sách đúng/sai
    • Từ cần ôn lại
  ↓
11. Progressive: Check nếu accuracy ≥ 80%
    YES → Lên level tiếp
    NO → Game over
  ↓
END
```

### 5.2. Card System (Hệ Thống Thẻ)

#### **Cấu trúc Card:**

```json
{
    "id": "UUID", // Unique card ID
    "type": "IMAGE|WORD", // Loại thẻ
    "content": "...", // URL hình hoặc text từ
    "vocabId": "UUID", // Reference đến vocab
    "isFlipped": false, // Đã lật chưa (Classic)
    "isMatched": false // Đã ghép đúng chưa
}
```

#### **Quy tắc tạo cards:**

```javascript
// Input: N vocabs
vocabs = ["apple", "banana", "cat", ...]

// Output: 2N cards
cards = [
  // Image cards
  {id: 1, type: "IMAGE", content: "apple.jpg", vocabId: "apple-uuid"},
  {id: 2, type: "IMAGE", content: "banana.jpg", vocabId: "banana-uuid"},

  // Word cards
  {id: 3, type: "WORD", content: "apple", vocabId: "apple-uuid"},
  {id: 4, type: "WORD", content: "banana", vocabId: "banana-uuid"},
  ...
]

// Shuffle (Fisher-Yates)
shuffle(cards)
```

### 5.3. Validation Logic (Logic Chấm Điểm)

```java
// Pseudo-code
for each matchPair in userAnswer:
    vocab = findVocabById(matchPair.vocabId)

    // Case-insensitive comparison
    isCorrect = vocab.word.equalsIgnoreCase(matchPair.matchedWord.trim())

    if (isCorrect):
        correctCount++
        // Update progress: timesCorrect++
    else:
        incorrectCount++
        // Update progress: timesWrong++

    results.add({
        vocabId: vocab.id,
        word: vocab.word,
        image: vocab.img,
        userAnswer: matchPair.matchedWord,
        correct: isCorrect
    })

accuracy = (correctCount / totalPairs) * 100
```

### 5.4. Shuffle Algorithm

**Tại sao cần shuffle?**

-   ✅ Tạo tính ngẫu nhiên
-   ✅ Tránh pattern nhận dạng
-   ✅ Mỗi lượt chơi khác nhau
-   ✅ Tăng replay value

**Fisher-Yates Shuffle:**

```javascript
function shuffle(array) {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
    return array;
}

// Đảm bảo:
// - Mọi hoán vị có xác suất bằng nhau
// - Time: O(n)
// - Space: O(1) (in-place)
```

---

## 6. Hệ Thống Chấm Điểm

### 6.1. Công Thức Tổng Quát

```
Total Score = CEFR Score + Time Bonus

CEFR Score = Σ(points for each matched vocab)
  • A1 = 1 point
  • A2 = 2 points
  • B1 = 3 points
  • B2 = 4 points
  • C1 = 5 points
  • C2 = 6 points

Time Bonus = CEFR Score × Bonus Percentage
  • < 10s: +50%
  • < 20s: +30%
  • < 30s: +20%
  • < 60s: +10%
  • ≥ 60s: 0%
```

### 6.2. Chi Tiết Hệ Thống Điểm

#### **CEFR-Based Scoring (Điểm Theo Cấp Độ)**

Mỗi từ vựng được ghép đúng sẽ cho điểm dựa trên cấp độ CEFR:

```
A1 (Beginner) → 1 điểm
A2 (Elementary) → 2 điểm
B1 (Intermediate) → 3 điểm
B2 (Upper-Intermediate) → 4 điểm
C1 (Advanced) → 5 điểm
C2 (Proficiency) → 6 điểm
```

**Ý nghĩa:**

-   ✅ **Fair Scoring**: Từ khó → điểm cao hơn
-   ✅ **Skill-Based**: Thưởng cho việc học từ khó
-   ✅ **Motivational**: Khuyến khích người chơi thử thách bản thân

**Ví dụ:**

```
5 từ A1 ghép đúng → 5 × 1 = 5 điểm
3 từ C2 ghép đúng → 3 × 6 = 18 điểm
```

---

#### **Time Bonus (Điểm Thưởng Thời Gian)**

Người chơi hoàn thành nhanh sẽ được cộng thêm phần trăm điểm CEFR:

```java
long seconds = timeTaken / 1000;
double bonusPercentage = 0;

if (seconds < 10) {
    bonusPercentage = 0.50;  // +50%
} else if (seconds < 20) {
    bonusPercentage = 0.30;  // +30%
} else if (seconds < 30) {
    bonusPercentage = 0.20;  // +20%
} else if (seconds < 60) {
    bonusPercentage = 0.10;  // +10%
}

int timeBonus = (int) Math.round(cefrScore * bonusPercentage);
```

**Bảng Time Bonus:**
| Thời gian | Mức độ | Bonus % | Ví dụ (10 điểm CEFR) |
|-----------|--------|---------|----------------------|
| < 10s | ⚡ Lightning | +50% | +5 điểm → 15 total |
| 10-19s | 🏃 Very Fast | +30% | +3 điểm → 13 total |
| 20-29s | � Fast | +20% | +2 điểm → 12 total |
| 30-59s | 🚶 Normal | +10% | +1 điểm → 11 total |
| ≥ 60s | 🐌 Slow | 0% | 0 điểm → 10 total |

**Tâm lý:**

-   Tạo động lực hoàn thành nhanh
-   Không quá khắt khe (vẫn có điểm cơ bản)
-   Reward cho skill và tốc độ

---

### 6.3. Accuracy Calculation

```
Accuracy = (Correct Matches / Total Pairs) × 100%
```

**Ứng dụng:**

1. **Hiển thị cho người chơi**

    - "You got 100% accuracy!" → Perfect score

2. **Phân loại hiệu suất**

    ```
    100%: Perfect ⭐⭐⭐
    80-99%: Great ⭐⭐
    60-79%: Good ⭐
    < 60%: Need practice
    ```

3. **Personalized feedback**
    - Accuracy cao → Khuyến khích chơi CEFR level cao hơn
    - Accuracy thấp → Gợi ý ôn lại

---

### 6.4. Ví Dụ Tính Điểm

#### **Scenario 1: Classic Mode**

```
Input:
  • Mode: CLASSIC
  • Total pairs: 8
  • Correct: 7
  • Wrong: 1
  • Time: 120s (không tính)

Calculation:
  Base Score = 7 × 10 = 70
  Time Bonus = 0 (không có trong Classic)
  Perfect Bonus = 0 (không 100%)

Output:
  Total Score = 70
  Accuracy = 7/8 = 87.5%
  Message: "Great job! 7/8 correct"
```

---

#### **Scenario 2: Speed Match (Fast)**

```
Input:
  • Mode: SPEED_MATCH
  • Total pairs: 5
  • Correct: 5
  • Wrong: 0
  • Time: 28s

Calculation:
  Base Score = 5 × 10 = 50
#### **Scenario 1: Perfect Score với High CEFR**

```

Input:
• Total pairs: 3
• CEFR: C2
• Correct: 3/3
• Time: 15 giây

Calculation:
CEFR Score = 3 × 6 = 18 điểm (C2 = 6đ/từ)
Time Bonus = 18 × 30% = 5.4 điểm (< 20s)

Output:
Total Score = 18 + 5.4 = 23.4 điểm
Accuracy = 100%
Message: "Perfect! Very fast!"

```

---

#### **Scenario 2: Medium Speed với Mixed CEFR**

```

Input:
• Total pairs: 5
• CEFR: Mixed (2×A1, 2×B1, 1×C1)
• Correct: 5/5
• Time: 35 giây

Calculation:
CEFR Score:
• 2 × A1 = 2 × 1 = 2 điểm
• 2 × B1 = 2 × 3 = 6 điểm
• 1 × C1 = 1 × 5 = 5 điểm
• Total CEFR = 13 điểm

Time Bonus = 13 × 20% = 2.6 điểm (< 40s)

Output:
Total Score = 13 + 2.6 = 15.6 điểm
Accuracy = 100%

```

---

#### **Scenario 3: Slow Completion**

```

Input:
• Total pairs: 5
• CEFR: A1
• Correct: 5/5
• Time: 70 giây

Calculation:
CEFR Score = 5 × 1 = 5 điểm
Time Bonus = 0 điểm (≥ 60s)

Output:
Total Score = 5 điểm
Accuracy = 100%
Message: "Great job! Try to be faster next time."

```

---

## 7. Ưu Điểm Nổi Bật

### 7.1. Về Mặt Sư Phạm (Pedagogy)

#### ✅ **Active Learning (Học Chủ Động)**

```

Passive Learning (Truyền thống):
Đọc danh sách từ → Ghi nhớ → Quên

Active Learning (Game):
Tương tác → Suy nghĩ → Quyết định → Phản hồi → Ghi nhớ

```

**Hiệu quả:**

-   Ghi nhớ cao hơn **3-4 lần** so với học thụ động
-   Retention rate: 70-90% (vs 10-20% đọc sách)

---

#### ✅ **Visual Association (Liên Kết Hình Ảnh)**

**Dual Coding Theory** (Allan Paivio):

```

Từ vựng + Hình ảnh = Mã hóa kép (Verbal + Visual)
→ Tăng khả năng ghi nhớ

```

**Ví dụ:**

```

Học từ "apple":
❌ Chỉ đọc: "apple = táo"
✅ Với hình: Nhìn 🍎 → "apple" → Liên kết mạnh

```

**Nghiên cứu:**

-   Pictures are remembered **6x better** than words
-   Visual + Verbal = **89% recall** (vs 10% text only)

---

#### ✅ **Immediate Feedback (Phản Hồi Ngay)**

```

Traditional:
Làm bài → Nộp → Đợi 1 tuần → Nhận điểm → Đã quên câu hỏi

Game:
Ghép thẻ → Submit → Ngay lập tức → Đúng/Sai + Giải thích

````

**Lợi ích:**

-   Củng cố kiến thức đúng ngay lập tức
-   Sửa sai kịp thời, tránh ghi nhớ sai
-   Tạo vòng lặp học tập (Learning Loop):
    ```
    Try → Fail → Learn → Retry → Success
    ```

---

#### ✅ **Spaced Repetition (Lặp Lại Giãn Cách)**

Tích hợp trong **UserVocabProgress**:

```java
if (isCorrect) {
    progress.timesCorrect++;
    // Từ đúng nhiều → Xuất hiện ít hơn
} else {
    progress.timesWrong++;
    // Từ sai nhiều → Xuất hiện nhiều hơn
}
````

**Ebbinghaus Forgetting Curve:**

```
Không ôn lại: ↘ Quên 50% sau 1 ngày
                ↘ Quên 90% sau 1 tuần

Có ôn lại:    → Giữ 80-90% sau nhiều tuần
```

---

### 7.2. Về Mặt Tâm Lý (Psychology)

#### 🎯 **Gamification Effects**

**1. Achievement (Thành tựu):**

```
• Level progression (Progressive mode)
• High scores (Speed Match)
• Perfect matches (All modes)
• Leaderboard ranking
```

→ Kích thích **dopamine**, tạo động lực

**2. Competition (Cạnh tranh):**

```
• Leaderboard: Top players
• Personal best: Beat your own record
• Social sharing: Share achievements
```

→ **Social motivation**, học nhóm hiệu quả hơn

**3. Mastery (Làm chủ):**

```
Level 1 (Easy) → ... → Level 10 (Expert)
```

→ Cảm giác **progress**, tăng tự tin

---

#### 🧠 **Flow State (Trạng Thái Dòng Chảy)**

Mihaly Csikszentmihalyi's Flow Theory:

```
           ↑ Challenge
           │
    Anxiety│     ╱╲ FLOW ZONE
           │    ╱  ╲
           │   ╱    ╲
           │  ╱      ╲
    ───────┼─╱────────╲─────→ Skill
           │╱  Boredom ╲
           ╱
```

**Game thiết kế:**

-   **Easy start** (3 pairs) → Xây dựng confidence
-   **Progressive difficulty** → Giữ trong Flow Zone
-   **Adaptive** → Không quá dễ, không quá khó

**Kết quả:**

-   ⏰ Time flies (Mất cảm giác thời gian)
-   🎯 Deep focus (Tập trung cao độ)
-   😊 Enjoyment (Thích thú)
-   🚀 Peak performance (Hiệu suất cao)

---

#### 💪 **Self-Efficacy (Tự tin)**

**Bandura's Theory:**

```
Success Experience → Tăng Self-Efficacy → Effort Increase → More Success
```

**Game thiết kế:**

-   ✅ Small wins (3 pairs đầu dễ)
-   ✅ Clear progress (Level 1 → 2 → 3)
-   ✅ Positive feedback ("Great job!")
-   ✅ Second chances (Replay)

---

### 7.3. Về Mặt Kỹ Thuật (Technical)

#### ⚡ **Performance**

**1. In-Memory Caching:**

```java
ConcurrentHashMap<SessionId, SessionData>
```

-   O(1) lookup time
-   Reduced database load
-   Fast validation

**2. Efficient Algorithms:**

```
• Fisher-Yates Shuffle: O(n)
• Validation: O(n × m) → có thể optimize O(m)
• Scoring: O(1)
```

**3. Parallel Processing:**

```
Future feature:
  • Async validation
  • Batch updates
  • Real-time leaderboard
```

---

#### 🔒 **Security & Data Integrity**

**1. Session Management:**

```
• JWT Authentication
• Session timeout
• Anti-cheat measures
```

**2. Validation:**

```
• Server-side validation (không tin client)
• Case-insensitive comparison
• Trim whitespace
```

**3. Data Tracking:**

```
• GameSession (session info)
• GameSessionDetail (từng vocab)
• UserVocabProgress (long-term tracking)
```

---

#### 📊 **Analytics & Insights**

**Collected Data:**

```
1. Performance Metrics:
   • Accuracy per vocab
   • Time per pair
   • Success rate by topic/CEFR

2. User Behavior:
   • Favorite game mode
   • Play time distribution
   • Learning patterns

3. Content Quality:
   • Which images work best
   • Confusing pairs
   • Difficulty balance
```

**Applications:**

-   🎯 Personalized recommendations
-   📈 Adaptive difficulty
-   🔍 Content improvement
-   📊 Learning analytics

---

## 8. Công Nghệ Sử Dụng

### 8.1. Backend Architecture

```
┌─────────────────────────────────────┐
│         Spring Boot 3.2.5           │
├─────────────────────────────────────┤
│                                     │
│  ┌──────────────────────────────┐  │
│  │      REST Controllers        │  │
│  │  • ImageWordMatchingController│  │
│  └──────────────────────────────┘  │
│              ↓                      │
│  ┌──────────────────────────────┐  │
│  │      Service Layer           │  │
│  │  • ImageWordMatchingService  │  │
│  │  • VocabService              │  │
│  │  • UserService               │  │
│  └──────────────────────────────┘  │
│              ↓                      │
│  ┌──────────────────────────────┐  │
│  │    Repository Layer          │  │
│  │  • Spring Data JPA           │  │
│  └──────────────────────────────┘  │
│              ↓                      │
│  ┌──────────────────────────────┐  │
│  │       PostgreSQL             │  │
│  │  • Vocabs, Sessions, Users   │  │
│  └──────────────────────────────┘  │
└─────────────────────────────────────┘
```

### 8.2. Technology Stack

#### **Backend:**

-   ☕ **Java 17**: Modern Java features
-   🍃 **Spring Boot 3.2.5**: Framework
-   🗄️ **PostgreSQL**: Relational database
-   🔐 **Spring Security + JWT**: Authentication
-   📝 **Swagger/OpenAPI**: API documentation
-   ⚡ **Caffeine Cache**: In-memory session caching (30-minute TTL)

#### **Key Libraries:**

```xml
<dependencies>
    <!-- Core -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>

    <!-- Security -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-security</artifactId>
    </dependency>

    <!-- Validation -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-validation</artifactId>
    </dependency>

    <!-- Cache -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-cache</artifactId>
    </dependency>
    <dependency>
        <groupId>com.github.ben-manes.caffeine</groupId>
        <artifactId>caffeine</artifactId>
    </dependency>

    <!-- Utilities -->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
    </dependency>
</dependencies>
```

#### **Firebase Integration:**

-   🔥 **Firebase Storage**: Lưu hình ảnh và audio
-   🔥 **Firebase Admin SDK**: Server-side operations

#### **Caching Strategy:**

-   🚀 **Caffeine Cache**: High-performance in-memory cache
-   ⏱️ **30-minute TTL**: Sessions expire after 30 minutes
-   📦 **Max 10,000 sessions**: Prevents memory overflow

### 8.3. Database Schema

```sql
-- Vocabs Table
CREATE TABLE vocabs (
    id UUID PRIMARY KEY,
    word VARCHAR(255) UNIQUE NOT NULL,
    meaning_vi TEXT,
    transcription VARCHAR(255),
    img VARCHAR(500),  -- Firebase Storage URL
    audio VARCHAR(500), -- Firebase Storage URL
    cefr VARCHAR(10),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Game Sessions
CREATE TABLE game_sessions (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    game_id BIGINT REFERENCES games(id),
    total_questions INTEGER,
    correct_count INTEGER,
    accuracy DECIMAL(5,2),
    score INTEGER,
    duration INTEGER, -- seconds
    started_at TIMESTAMP,
    finished_at TIMESTAMP,
    created_at TIMESTAMP
);

-- Session Details (Từng vocab trong session)
CREATE TABLE game_session_details (
    id BIGSERIAL PRIMARY KEY,
    session_id BIGINT REFERENCES game_sessions(id),
    vocab_id UUID REFERENCES vocabs(id),
    is_correct BOOLEAN,
    created_at TIMESTAMP
);

-- User Vocab Progress (Long-term tracking)
CREATE TABLE user_vocab_progress (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    vocab_id UUID REFERENCES vocabs(id),
    times_correct INTEGER DEFAULT 0,
    times_wrong INTEGER DEFAULT 0,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    UNIQUE(user_id, vocab_id)
);
```

### 8.4. API Design

**RESTful Endpoints:**

```
POST   /api/v1/games/image-word-matching/start
       → Start new game session

POST   /api/v1/games/image-word-matching/submit
       → Submit answers and get results

POST   /api/v1/games/image-word-matching/progress/{sessionId}
       → Progress to next level (Progressive mode)

GET    /api/v1/games/image-word-matching/session/{sessionId}
       → Get session details

GET    /api/v1/games/image-word-matching/history
       → Get user's game history

GET    /api/v1/games/image-word-matching/leaderboard
       → Get top players

GET    /api/v1/games/image-word-matching/stats
       → Get user statistics
```

**Request/Response Format:**

```json
// Start Game Request
{
  "gameMode": "CLASSIC|SPEED_MATCH|PROGRESSIVE",
  "totalPairs": 8,
  "topicName": "animals",
  "cefr": "A1",
  "timeLimit": 60
}

// Start Game Response
{
  "sessionId": 123,
  "gameMode": "CLASSIC",
  "currentLevel": 1,
  "totalPairs": 8,
  "timeLimit": null,
  "cards": [
    {
      "id": "uuid-1",
      "type": "IMAGE",
      "content": "https://...",
      "vocabId": "vocab-uuid-1"
    },
    {
      "id": "uuid-2",
      "type": "WORD",
      "content": "dog",
      "vocabId": "vocab-uuid-1"
    }
  ],
  "status": "IN_PROGRESS"
}
```

### 8.5. Algorithms Implemented

**10 Core Algorithms:**

1. **Fisher-Yates Shuffle** - Random card placement
2. **Random Sampling** - Select vocabs from pool
3. **Weighted Scoring** - Fair point calculation
4. **Accuracy Calculation** - Performance measurement
5. **Leaderboard Ranking** - Group-by + Sort
6. **Progressive Difficulty** - Auto-increase challenge
7. **Card Generation** - Create 2N cards from N vocabs
8. **Match Validation** - Case-insensitive comparison
9. **Session Caching** - In-memory state management
10. **Progress Tracking** - Long-term learning analytics

**Time Complexity:**

```
Start Game:     O(n log n)  // Shuffle
Submit Answer:  O(n × m)    // Validation (can optimize to O(m))
Leaderboard:    O(n log n)  // Sort
Progress Level: O(n log n)  // New vocabs + shuffle
```

---

## 9. Roadmap và Tương Lai

### 9.1. Current Features (v1.0)

✅ 3 game modes (Classic, Speed Match, Progressive)  
✅ Multi-topic support (animals, food, colors, etc.)  
✅ CEFR level filtering (A1-C2)  
✅ Real-time scoring  
✅ Leaderboard  
✅ User progress tracking  
✅ Session management  
✅ RESTful API

### 9.2. Planned Features (v2.0)

#### 🎮 **Game Enhancements:**

-   [ ] Multiplayer mode (1v1 battles)
-   [ ] Daily challenges
-   [ ] Achievement system
-   [ ] Power-ups and boosters
-   [ ] Custom game creation

#### 📊 **Analytics:**

-   [ ] Learning curve visualization
-   [ ] Weak vocab identification
-   [ ] Personalized recommendations
-   [ ] Study plan generator

#### 🎨 **UX Improvements:**

-   [ ] Animations and sound effects
-   [ ] Themes and skins
-   [ ] Accessibility features
-   [ ] Mobile app (React Native)

#### 🔧 **Technical:**

-   [ ] Redis caching for leaderboard
-   [ ] WebSocket for real-time multiplayer
-   [ ] GraphQL API
-   [ ] Microservices architecture
-   [ ] AI-powered difficulty adjustment

### 9.3. Research Opportunities

-   📚 **Adaptive Learning**: Machine learning cho personalized difficulty
-   🧠 **Cognitive Science**: Tối ưu retention rate
-   📊 **Data Science**: Predict learning outcomes
-   🎮 **Game Design**: A/B testing cho engagement

---

## 10. Kết Luận

### 10.1. Tóm Tắt Ý Tưởng

**Image-Word Matching** là một game học từ vựng:

✅ **Dựa trên khoa học**: Visual learning + Active recall  
✅ **Đa dạng**: 3 modes phù hợp mọi trình độ  
✅ **Thông minh**: Scoring + difficulty tự động  
✅ **Có đo lường**: Tracking progress dài hạn  
✅ **Công nghệ hiện đại**: Spring Boot + PostgreSQL + Firebase

### 10.2. Giá Trị Mang Lại

#### **Cho Học Sinh:**

-   🎯 Học từ vựng hiệu quả hơn 3-4 lần
-   🧠 Ghi nhớ lâu dài (80-90% retention)
-   😊 Thích thú, không nhàm chán
-   📈 Theo dõi tiến độ rõ ràng

#### **Cho Giáo Viên:**

-   📊 Analytics chi tiết về học sinh
-   🎯 Identify weak areas
-   📝 Assign targeted practice
-   ⏱️ Save time on grading

#### **Cho Nghiên Cứu:**

-   📚 Data for learning science
-   🧪 Platform for experiments
-   📊 Evidence-based education

### 10.3. Contribution to Education

Game này đóng góp vào xu hướng:

1. **EdTech Revolution**: Technology-enhanced learning
2. **Gamification**: Making learning fun
3. **Personalized Learning**: Adapt to individual needs
4. **Data-Driven Education**: Evidence-based decisions

---

## 📚 Tài Liệu Tham Khảo

### Academic Papers:

1. **Paivio, A. (1971).** "Dual Coding Theory"
2. **Csikszentmihalyi, M. (1990).** "Flow: The Psychology of Optimal Experience"
3. **Ebbinghaus, H.** "Forgetting Curve and Spaced Repetition"
4. **Bandura, A. (1977).** "Self-Efficacy Theory"

### Books:

1. **"Make It Stick: The Science of Successful Learning"** - Peter C. Brown
2. **"How We Learn"** - Benedict Carey
3. **"Gamification by Design"** - Gabe Zichermann

### Research:

1. **Visual Learning**: Picture Superiority Effect
2. **Active Learning**: Freeman et al. (2014) PNAS study
3. **Gamification**: Deterding et al. (2011)

---

**Version:** 1.0  
**Last Updated:** October 17, 2025  
**Author:** Card Words Development Team
