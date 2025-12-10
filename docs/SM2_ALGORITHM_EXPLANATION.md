# Giải thích Thuật toán Lặp lại ngắt quãng (Spaced Repetition) - SM-2

Tài liệu này mô tả chi tiết về thuật toán **SuperMemo-2 (SM-2)** được sử dụng trong tính năng ôn tập Flashcard của dự án. Thuật toán này giúp tối ưu hóa việc ghi nhớ từ vựng bằng cách tính toán thời điểm "vàng" để ôn tập lại - ngay trước khi người dùng sắp quên.

## 1. Tổng quan về SM-2

SM-2 là một trong những thuật toán phổ biến nhất thế giới về lặp lại ngắt quãng (Spaced Repetition), được phát triển bởi Piotr Woźniak.

-   **Mục tiêu:** Giúp người học ghi nhớ lâu dài với số lần ôn tập ít nhất có thể.
-   **Nguyên lý:** Nếu bạn nhớ một từ càng tốt (trả lời đúng và nhanh), khoảng cách đến lần ôn tiếp theo sẽ càng xa. Ngược lại, nếu bạn quên, hệ thống sẽ bắt bạn ôn lại ngay lập tức.

## 2. Các tham số chính

Trong mã nguồn dự án (`FlashcardReviewService.java`), mỗi từ vựng của người dùng (`UserVocabProgress`) được theo dõi bởi các chỉ số sau:

-   **Quality (q):** Chất lượng câu trả lời của người dùng, thang điểm từ 0 đến 5.
-   **EF (Easiness Factor):** Hệ số dễ nhớ của từ.
    -   Giá trị khởi tạo mặc định: **2.5**.
    -   Giá trị tối thiểu: **1.3** (Từ khó nhất cũng sẽ không bị lặp lại quá dày đặc).
-   **Repetition (n):** Số lần trả lời đúng liên tiếp.
-   **Interval (I):** Khoảng cách (số ngày) đến lần ôn tập tiếp theo.

## 3. Quy trình tính toán (Logic Code)

Khi người dùng hoàn thành ôn tập một thẻ Flashcard, họ sẽ tự đánh giá mức độ ghi nhớ của mình (Quality):

### A. Thang điểm đánh giá (Quality)

-   **5 - Perfect:** Trả lời hoàn hảo, không do dự.
-   **4 - Good:** Trả lời đúng nhưng có chút ngập ngừng.
-   **3 - Pass:** Trả lời đúng nhưng rất khó khăn.
-   **2 - Fail (Easy):** Trả lời sai, nhưng khi xem đáp án thấy rất dễ nhớ lại.
-   **1 - Fail (Familiar):** Trả lời sai, xem đáp án thấy quen quen.
-   **0 - Blackout:** Quên hoàn toàn.

### B. Xử lý kết quả

#### Trường hợp 1: Trả lời SAI (Quality < 3)

Nếu người dùng đánh giá 0, 1 hoặc 2, hệ thống coi như người dùng đã quên từ này.

-   **Repetition (n):** Reset về **0**.
-   **Interval (I):** Reset về **1 ngày** (Phải ôn lại vào ngày mai).
-   **EF:** Giữ nguyên (Không thay đổi độ khó của từ).
-   **Trạng thái:** Chuyển về `UNKNOWN` (Chưa thuộc).

#### Trường hợp 2: Trả lời ĐÚNG (Quality >= 3)

Nếu người dùng đánh giá 3, 4 hoặc 5:

**Bước 1: Cập nhật hệ số EF (Easiness Factor)**
Công thức toán học:
$$EF' = EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))$$

-   Nếu trả lời càng dễ (q cao), EF càng tăng -> Khoảng cách ôn tập lần sau càng giãn ra nhanh.
-   Nếu trả lời khó khăn (q thấp), EF sẽ giảm -> Khoảng cách ôn tập sẽ ngắn lại.
-   _Lưu ý:_ EF không bao giờ nhỏ hơn **1.3**.

**Bước 2: Cập nhật số lần lặp lại (Repetition)**

-   Tăng lên 1 đơn vị: `n = n + 1`

**Bước 3: Tính khoảng cách ngày ôn tập tiếp theo (Interval)**

-   Nếu **n = 1** (Lần đầu đúng): Interval = **1 ngày**.
-   Nếu **n = 2** (Lần thứ 2 đúng): Interval = **6 ngày**.
-   Nếu **n >= 3**:
    $$Interval = Interval\_cũ * EF$$
    _(Làm tròn kết quả)_

**Bước 4: Cập nhật trạng thái từ vựng**

-   Nếu Interval > 21 ngày: Chuyển trạng thái thành `MASTERED` (Đã thành thạo).
-   Ngược lại: Trạng thái là `KNOWN` (Đã biết).

## 4. Ví dụ minh họa

Giả sử một từ vựng có EF = 2.5.

1.  **Lần 1 (Hôm nay):** Bạn học từ mới và trả lời đúng (Quality 4).
    -   Interval = 1 ngày. (Ôn lại vào ngày mai).
2.  **Lần 2 (Ngày mai):** Bạn trả lời đúng (Quality 4).
    -   Interval = 6 ngày. (Ôn lại sau 1 tuần).
3.  **Lần 3 (Tuần sau):** Bạn trả lời rất tốt (Quality 5).
    -   EF tăng lên (ví dụ: 2.6).
    -   Interval = 6 \* 2.6 = 15.6 -> Làm tròn **16 ngày**.
4.  **Lần 4 (16 ngày sau):** Bạn quên từ này (Quality 1).
    -   Repetition về 0.
    -   Interval về 1 ngày. (Phải học lại từ đầu vào ngày mai).
    -   EF giữ nguyên 2.6 (Từ này vẫn được coi là dễ với bạn, chỉ là lỡ quên thôi).

## 5. Ý nghĩa trong dự án

Việc áp dụng SM-2 giúp ứng dụng **Card Words** giải quyết bài toán:

-   Không bắt người dùng học lại những từ họ đã thuộc làu (tránh nhàm chán).
-   Tập trung thời gian vào những từ khó, hay quên.
-   Đảm bảo kiến thức được nạp vào bộ nhớ dài hạn (Long-term memory).
