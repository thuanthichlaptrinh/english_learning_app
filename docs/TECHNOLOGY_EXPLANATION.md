# Giải thích chi tiết công nghệ sử dụng trong dự án Card Words

Tài liệu này giải thích chi tiết về các công nghệ được sử dụng trong dự án, vai trò của chúng và lý do lựa chọn, phục vụ cho việc báo cáo và bảo vệ đồ án.

## 1. Spring Boot

-   **Là gì:** Framework phát triển ứng dụng Java mạnh mẽ, giúp xây dựng các ứng dụng cấp doanh nghiệp (Enterprise) nhanh chóng với cấu hình tối thiểu.
-   **Vai trò trong dự án:** Đóng vai trò là **Backend Core (Lõi trung tâm)**.
    -   Xử lý toàn bộ nghiệp vụ logic chính: Quản lý người dùng, từ vựng, chủ đề, bài kiểm tra, logic game.
    -   Cung cấp RESTful API cho Client (Mobile/Web).
    -   Tương tác trực tiếp với Database chính.

## 2. FastAPI

-   **Là gì:** Framework hiện đại của Python để xây dựng API với hiệu năng cực cao (ngang ngửa NodeJS/Go), hỗ trợ xử lý bất đồng bộ (Asynchronous).
-   **Vai trò trong dự án:** Đóng vai trò là **AI Service (Service Trí tuệ nhân tạo)**.
    -   Là cầu nối để tích hợp các thư viện Machine Learning của Python (Scikit-learn, XGBoost) vào hệ thống.
    -   Chạy mô hình **Random Forest** để phân tích lịch sử học tập và đưa ra gợi ý ôn tập cá nhân hóa.
    -   Giao tiếp với Spring Boot qua API nội bộ.

## 3. WebSocket

-   **Là gì:** Giao thức truyền tải dữ liệu hai chiều thời gian thực (Real-time) giữa Client và Server qua một kết nối TCP duy nhất.
-   **Vai trò trong dự án:** Xử lý **Thông báo thời gian thực**.
    -   Gửi thông báo ngay lập tức khi người dùng đạt thành tích (Level up, Top server) mà không cần người dùng tải lại trang.
    -   Hỗ trợ các tính năng tương tác trực tiếp trong tương lai (như Chat, thi đấu đối kháng).

## 4. Spring Security

-   **Là gì:** Framework bảo mật mạnh mẽ và tùy biến cao, là tiêu chuẩn bảo mật cho các ứng dụng Java.
-   **Vai trò trong dự án:** **Bảo vệ ứng dụng**.
    -   **Authentication (Xác thực):** Kiểm tra danh tính người dùng khi đăng nhập.
    -   **Authorization (Phân quyền):** Kiểm soát quyền truy cập tài nguyên (Ví dụ: Chỉ Admin mới được thêm/sửa/xóa từ vựng, User thường chỉ được xem và học).

## 5. JWT (JSON Web Token)

-   **Là gì:** Chuẩn mở (RFC 7519) định nghĩa cách truyền tin an toàn giữa các bên dưới dạng đối tượng JSON.
-   **Vai trò trong dự án:** Cơ chế **Xác thực phi trạng thái (Stateless)**.
    -   Giúp Server không cần lưu Session của người dùng, giảm tải cho bộ nhớ Server.
    -   Token chứa thông tin định danh và quyền hạn, được mã hóa và ký số. Client gửi Token này trong mỗi request để chứng minh danh tính.

## 6. Database (Hệ quản trị cơ sở dữ liệu)

Hệ thống sử dụng kiến trúc đa cơ sở dữ liệu (Polyglot Persistence) để tối ưu hóa cho từng loại dữ liệu:

### a. PostgreSQL (CSDL Quan hệ - RDBMS)

-   **Vai trò:** Kho chứa dữ liệu chính (Primary Database).
-   **Lưu trữ:** Thông tin người dùng, cấu trúc bài học, từ vựng, lịch sử giao dịch, kết quả học tập.
-   **Kỹ thuật:** Sử dụng **Indexing (Đánh chỉ mục)** để tối ưu tốc độ truy vấn trên các bảng lớn. Đảm bảo tính toàn vẹn dữ liệu (ACID).

### b. Redis (CSDL In-Memory - NoSQL)

-   **Vai trò:** Bộ nhớ đệm (Caching) và lưu trữ tạm thời.
-   **Lưu trữ:** Dữ liệu truy cập thường xuyên (Top xếp hạng, Session, OTP), dữ liệu cần tốc độ phản hồi cực nhanh.
-   **Lợi ích:** Giảm tải cho PostgreSQL, tăng tốc độ phản hồi API lên nhiều lần do dữ liệu được đọc trực tiếp từ RAM.

### c. Firebase Storage (Cloud Storage)

-   **Vai trò:** Lưu trữ tệp tin đa phương tiện (Blob Storage).
-   **Lưu trữ:** Ảnh đại diện (Avatar), hình ảnh minh họa từ vựng, file âm thanh phát âm.
-   **Lợi ích:** Giảm tải dung lượng lưu trữ cho VPS, tận dụng hạ tầng CDN của Google để tăng tốc độ tải media cho người dùng cuối.

## 7. Infrastructure (Hạ tầng triển khai)

### a. Docker

-   **Là gì:** Nền tảng container hóa ứng dụng.
-   **Vai trò:** Đóng gói ứng dụng (Spring Boot, FastAPI, Database) và môi trường chạy vào các **Container** độc lập.
-   **Lợi ích:** Đảm bảo tính nhất quán của môi trường (Dev/Prod giống hệt nhau), dễ dàng triển khai và mở rộng.

### b. VPS (Virtual Private Server)

-   **Vai trò:** Máy chủ ảo chạy hệ điều hành Linux (Ubuntu), nơi vận hành toàn bộ hệ thống 24/7 để phục vụ người dùng.

### c. Nginx

-   **Là gì:** Web Server hiệu năng cao và Reverse Proxy.
-   **Vai trò:**
    -   **Reverse Proxy (Proxy ngược):** Đứng trước các ứng dụng Backend, tiếp nhận request từ Internet và điều hướng đến đúng service (Spring Boot hoặc FastAPI).
    -   **Load Balancing (Cân bằng tải):** Phân phối lưu lượng truy cập nếu chạy nhiều bản sao của ứng dụng (Scale out).
    -   **Security & SSL:** Ẩn thông tin hạ tầng bên trong, cấu hình HTTPS để mã hóa dữ liệu truyền tải.
