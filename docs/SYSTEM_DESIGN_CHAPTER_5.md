# CHƯƠNG 5: THỬ NGHIỆM VÀ TRIỂN KHAI

## 5.1. Thử nghiệm (Testing)

Hệ thống áp dụng chiến lược kiểm thử toàn diện (Comprehensive Testing Strategy) bao gồm cả Unit Test và Integration Test cho hai phân hệ chính: Backend (Java) và AI Service (Python). Mục tiêu là đạt độ bao phủ (coverage) >= 80% cho các logic nghiệp vụ quan trọng.

### 5.1.1. Chiến lược kiểm thử

-   **Isolation (Cô lập):** Mỗi test case phải độc lập, sử dụng Mock Object để giả lập các phụ thuộc bên ngoài (Database, Redis, External APIs).
-   **Fast (Nhanh):** Tối ưu hóa thời gian chạy test để hỗ trợ quy trình CI/CD.
-   **Reliable (Tin cậy):** Kết quả test phải nhất quán, không phụ thuộc vào thứ tự chạy hay trạng thái môi trường.
-   **Meaningful (Có ý nghĩa):** Tập trung test các logic nghiệp vụ phức tạp (thuật toán, tính toán điểm, luồng dữ liệu) thay vì các hàm getter/setter đơn giản.

### 5.1.2. Kiến trúc kiểm thử

#### a. Backend Service (Java Spring Boot)

Sử dụng **JUnit 5** và **Mockito** làm framework chính.

-   **Cấu trúc thư mục test:**

    -   `config/`: Cấu hình môi trường test (TestConfig, TestSecurityConfig).
    -   `fixtures/`: Dữ liệu mẫu (UserFixtures, VocabFixtures) để tái sử dụng.
    -   `core/usecase/`: Unit test cho các Use Case (User, Admin).
    -   `core/service/`: Unit test cho các Service (Chatbot, Redis).
    -   `core/util/`: Test các hàm tiện ích và thuật toán (SM-2, Streak).

-   **Các thành phần được kiểm thử:**
    -   **Service Layer:** Kiểm tra logic nghiệp vụ, xử lý ngoại lệ.
    -   **Mapper Layer:** Kiểm tra việc chuyển đổi dữ liệu giữa Entity và DTO.
    -   **Utility Classes:** Kiểm tra tính đúng đắn của các thuật toán (ví dụ: `VocabStatusCalculatorTest`, `StreakCalculationTest`).

#### b. AI Service (Python FastAPI)

Sử dụng **Pytest** làm framework chính.

-   **Cấu trúc thư mục test:**
    -   `fixtures/`: Dữ liệu mẫu cho ML features và Vocab.
    -   `unit/core/ml/`: Test các thành phần Machine Learning (Feature Extractor, XGBoost Model).
    -   `unit/api/`: Test các API endpoint (Prediction, Training).

### 5.1.3. Kịch bản kiểm thử chính

1.  **Authentication:**
    -   Đăng ký/Đăng nhập thành công và thất bại.
    -   Xác thực JWT Token và phân quyền (Role-based).
2.  **Học từ vựng (Learn Vocab):**
    -   Tính toán đúng ngày ôn tập tiếp theo dựa trên thuật toán SM-2.
    -   Cập nhật trạng thái từ vựng (NEW -> LEARNING -> MASTERED).
3.  **Game Logic:**
    -   Tính điểm chính xác cho Quick Quiz (bao gồm Streak Bonus, Speed Bonus).
    -   Xử lý ghép cặp đúng/sai trong Image-Word Matching.
4.  **AI Prediction:**
    -   Trích xuất đúng 9 đặc trưng (features) từ dữ liệu người dùng.
    -   Mô hình trả về kết quả dự đoán (xác suất) hợp lệ.

## 5.2. Đánh giá Mô hình & Thuật toán

### 5.2.1. Mô hình AI (XGBoost & Random Forest)

Hệ thống sử dụng song song hai mô hình **XGBoost** và **Random Forest** để dự đoán xác suất người dùng quên từ vựng, từ đó đưa ra gợi ý ôn tập thông minh.

-   **Mục tiêu:** Phân loại từ vựng vào nhóm "Cần ôn tập" (Label 1) hoặc "Chưa cần ôn" (Label 0).
-   **Dữ liệu đầu vào (9 Features):**

    1.  `times_correct`: Số lần đúng.
    2.  `times_wrong`: Số lần sai.
    3.  `accuracy_rate`: Tỷ lệ chính xác.
    4.  `days_since_last_review`: Số ngày chưa ôn.
    5.  `days_until_next_review`: Số ngày đến hạn ôn (SM-2).
    6.  `interval_days`: Khoảng cách ôn tập.
    7.  `repetition`: Số lần lặp lại.
    8.  `ef_factor`: Hệ số dễ nhớ.
    9.  `status_encoded`: Trạng thái từ vựng.

-   **Tiêu chí gán nhãn (Labeling):**

    -   **Label 1 (Cần ôn):** Trạng thái UNKNOWN, NEW, hoặc KNOWN nhưng đã quá hạn/độ chính xác thấp (< 70%).
    -   **Label 0 (Không cần ôn):** Các trường hợp còn lại.

-   **Cấu hình Hyperparameters (Random Forest):**
    -   `n_estimators`: 100 (Số cây quyết định).
    -   `max_depth`: 10 (Độ sâu tối đa).
    -   `class_weight`: 'balanced' (Cân bằng dữ liệu mẫu).

### 5.2.2. Thuật toán SM-2 (Spaced Repetition)

Thuật toán SM-2 được đánh giá thông qua việc theo dõi sự thay đổi của `ef_factor` (Hệ số dễ nhớ) và `interval_days` (Khoảng cách ôn tập) của người dùng theo thời gian.

-   **Kiểm chứng:** Unit Test `VocabStatusCalculatorTest` đảm bảo rằng với cùng một chuỗi input (chất lượng trả lời), thuật toán luôn đưa ra output (ngày ôn tiếp theo) chính xác theo công thức lý thuyết.

## 5.3. Triển khai (Deployment)

Hệ thống được đóng gói và triển khai sử dụng công nghệ Containerization (Docker) để đảm bảo tính nhất quán giữa các môi trường (Dev, Staging, Prod).

### 5.3.1. Môi trường triển khai

Hệ thống bao gồm các container services sau chạy trong cùng một mạng Docker (`docker network`):

1.  **Backend Service (`card-words`):**
    -   Image: OpenJDK 17 Slim.
    -   Port: 8080.
    -   Chức năng: Xử lý API chính, WebSocket, kết nối Database.
2.  **AI Service (`card-words-ai`):**
    -   Image: Python 3.11 Slim.
    -   Port: 8001.
    -   Chức năng: Chạy mô hình XGBoost/Random Forest, cung cấp API dự đoán.
3.  **Database (`postgres`):**
    -   Image: PostgreSQL 16.
    -   Port: 5432.
    -   Chức năng: Lưu trữ dữ liệu bền vững.
4.  **Cache (`redis`):**
    -   Image: Redis 7.x.
    -   Port: 6379.
    -   Chức năng: Caching, Session Storage, Message Broker.

### 5.3.2. Quy trình triển khai

Quy trình triển khai được tự động hóa thông qua `docker-compose`:

1.  **Chuẩn bị mã nguồn:**
    -   Backend: Build file JAR (`mvn clean install`).
    -   AI Service: Cập nhật dependencies (`poetry export` hoặc `requirements.txt`).
2.  **Cấu hình môi trường:**
    -   Tạo file `.env` chứa các biến môi trường nhạy cảm (DB credentials, API Keys, JWT Secret).
3.  **Khởi động hệ thống:**
    -   Chạy lệnh: `docker-compose up -d --build`.
    -   Docker Compose sẽ tự động build images, tạo network, và khởi động các containers theo đúng thứ tự phụ thuộc (DB/Redis -> Backend/AI).
4.  **Database Migration:**
    -   Flyway (tích hợp trong Backend) sẽ tự động chạy các script SQL migration khi ứng dụng khởi động để cập nhật cấu trúc database mới nhất.

### 5.3.3. Giám sát và Vận hành

-   **Logs:** Sử dụng `docker logs` hoặc tích hợp ELK Stack để theo dõi log tập trung.
-   **Health Check:** Các service đều cung cấp endpoint `/health` để kiểm tra trạng thái hoạt động.
-   **Backup:** Script tự động backup database định kỳ (như đã thấy trong thư mục `server/card-words/`).
