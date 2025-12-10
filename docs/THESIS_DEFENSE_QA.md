# 🎓 BỘ CÂU HỎI & TRẢ LỜI PHỎNG VẤN BẢO VỆ KHÓA LUẬN (BACKEND)

Tài liệu này tổng hợp các câu hỏi mà Hội đồng bảo vệ khóa luận có thể đặt ra cho vị trí Backend Developer của dự án **Card Words**, kèm theo gợi ý trả lời dựa trên kiến trúc thực tế của hệ thống.

---

## 1. 🏗️ VỀ KIẾN TRÚC HỆ THỐNG (SYSTEM ARCHITECTURE)

### Q1: Tại sao bạn dùng cả Spring Boot và FastAPI? Điểm mạnh của mỗi cái? Dùng song song thì giao tiếp thế nào?

**Trả lời:**

-   **Spring Boot (Java):**
    -   _Điểm mạnh:_ Ổn định, bảo mật cao, quản lý Transaction chặt chẽ (ACID), hệ sinh thái Enterprise mạnh mẽ.
    -   _Vai trò:_ Core Backend, xử lý nghiệp vụ chính (User, Auth, Payment, Sync).
-   **FastAPI (Python):**
    -   _Điểm mạnh:_ Tốc độ phát triển nhanh, hiệu năng cao (Asynchronous), hỗ trợ tuyệt vời cho AI/Data Science (thư viện Pandas, Scikit-learn).
    -   _Vai trò:_ AI Service, chạy các model Random Forest/XGBoost.
-   **Giao tiếp:** Hai service giao tiếp qua **RESTful API (HTTP)**. Spring Boot gọi sang FastAPI khi cần dự đoán.

### Q2: Kiến trúc của hệ thống bạn là Monolithic hay Microservices? Vì sao?

**Trả lời:**

-   Hệ thống đi theo hướng **Modular Monolith** (hoặc Mini-Microservices).
-   Nó không hẳn là Monolith vì đã tách AI ra riêng.
-   Nó chưa hẳn là Microservices thuần túy (vì chưa có Service Discovery, Circuit Breaker phức tạp).
-   **Lý do:** Đây là sự cân bằng giữa việc tận dụng công nghệ (Python cho AI, Java cho App) và chi phí vận hành/bảo trì (không quá phức tạp để deploy).

### Q3: Các service giao tiếp với nhau qua cơ chế nào?

**Trả lời:**

-   Chủ yếu qua **REST API (HTTP/JSON)** vì đơn giản và dễ debug.
-   (Nếu có dùng): Có thể đề cập đến **Redis Pub/Sub** nếu có tính năng realtime notification, nhưng core logic là REST.

### Q4: Bạn triển khai CI/CD chưa? Quy trình deploy của bạn thế nào?

**Trả lời:**

-   Em sử dụng các script tự động hóa (`deploy-vps.sh`, `docker-compose`).
-   **Quy trình:** Code -> Push lên Git -> Pull về VPS -> Build Docker Image -> Run Docker Compose.
-   (Nếu có): Em có cấu hình GitHub Actions để tự động chạy Test khi push code.

---

## 2. ☕ VỀ SPRING BOOT & CORE (DEEP DIVE)

### Q5: Spring Boot hoạt động theo nguyên lý gì?

**Trả lời:**

-   Dựa trên nguyên lý **Inversion of Control (IoC)** và **Dependency Injection (DI)**.
-   **Auto-configuration:** Tự động cấu hình các bean dựa trên các thư viện có trong classpath (ví dụ: thấy driver Postgres thì tự cấu hình DataSource).

### Q6: Sự khác nhau giữa @Component, @Service, @Repository?

**Trả lời:**

-   Về mặt kỹ thuật, `@Service` và `@Repository` đều là `@Component`.
-   **@Component:** Bean chung chung.
-   **@Service:** Đánh dấu lớp xử lý Logic nghiệp vụ (Business Layer).
-   **@Repository:** Đánh dấu lớp truy xuất dữ liệu (Data Access Layer). Đặc biệt, nó có cơ chế tự động chuyển đổi Exception của Database (SQL Exception) sang Exception chuẩn của Spring (DataAccessException).

### Q7: Cơ chế Dependency Injection hoạt động thế nào?

**Trả lời:**

-   Spring Container (ApplicationContext) sẽ quản lý vòng đời của các Bean.
-   Khi một Bean A cần Bean B, Spring sẽ tự động "tiêm" (inject) instance của B vào A.
-   Em ưu tiên dùng **Constructor Injection** (khuyên dùng) thay vì Field Injection (`@Autowired`) để đảm bảo tính bất biến và dễ viết Unit Test.

### Q8: JPA/Hibernate làm việc ra sao? Lazy/Eager là gì?

**Trả lời:**

-   Hibernate là một ORM (Object Relational Mapping) ánh xạ Table thành Class.
-   **Lazy Loading:** Chỉ tải dữ liệu khi thực sự cần dùng (ví dụ: `getDetails()`). Giúp tiết kiệm bộ nhớ và tăng tốc độ query ban đầu.
-   **Eager Loading:** Tải dữ liệu liên quan ngay lập tức (dùng JOIN). Tốt khi biết chắc chắn sẽ dùng đến dữ liệu đó.

### Q9: Bạn xử lý Validation và Exception Handling như thế nào?

**Trả lời:**

-   **Validation:** Dùng Bean Validation (`@NotNull`, `@Size`, `@Email`) trong DTO.
-   **Exception Handling:** Dùng `@ControllerAdvice` và `@ExceptionHandler` để bắt lỗi toàn cục, trả về format JSON chuẩn (`ApiResponse`) cho Client.

---

## 3. 🗄️ VỀ DATABASE (POSTGRESQL)

### Q10: Tại sao dùng PostgreSQL thay vì MySQL?

**Trả lời:**

-   Hỗ trợ **JSONB** mạnh mẽ (lưu trữ dữ liệu bán cấu trúc).
-   Tuân thủ **ACID** tốt hơn cho các giao dịch phức tạp.
-   Hiệu năng tốt hơn cho các truy vấn phức tạp (Complex Queries).

### Q11: Bạn tối ưu query thế nào?

**Trả lời:**

-   **Index:** Đánh index cho các cột hay tìm kiếm (`email`, `status`).
-   **Select:** Chỉ select các cột cần thiết, tránh `SELECT *`.
-   **N+1:** Dùng `JOIN FETCH` để load dữ liệu quan hệ.
-   **Explain Analyze:** Dùng lệnh này để xem Query Plan và tìm điểm nghẽn (Full Table Scan).

### Q12: Transaction isolation levels là gì? Bạn dùng mức nào?

**Trả lời:**

-   Là mức độ cô lập giữa các transaction đồng thời.
-   PostgreSQL mặc định là **Read Committed** (tránh Dirty Read). Em sử dụng mức mặc định này vì nó cân bằng tốt giữa hiệu năng và tính toàn vẹn dữ liệu.

---

## 4. ⚡ VỀ REDIS (CACHING)

### Q13: Bạn dùng Redis cho mục đích gì?

**Trả lời:**

-   **Cache:** Lưu User Profile, Từ vựng (giảm tải DB).
-   **Session Store:** Lưu trạng thái Game Session đang chơi (tốc độ cao).
-   **Rate Limiting:** Đếm số request để chống Spam.

### Q14: Redis lưu dữ liệu kiểu gì? RAM hay Disk?

**Trả lời:**

-   Redis lưu dữ liệu chủ yếu trên **RAM** (In-memory) nên tốc độ cực nhanh.
-   Tuy nhiên, nó có cơ chế **Persistence** (RDB hoặc AOF) để ghi xuống Disk định kỳ, giúp khôi phục dữ liệu nếu Server bị restart.

### Q15: Eviction policy bạn dùng là gì?

**Trả lời:**

-   Thường dùng **volatile-lru** (xóa các key có đặt TTL ít được sử dụng nhất) hoặc **allkeys-lru** (xóa key ít dùng nhất bất kể có TTL hay không) khi bộ nhớ đầy.

### Q16: Phân biệt Redis Cache và Database?

**Trả lời:**

-   **Redis:** Nhanh (RAM), Key-Value đơn giản, dung lượng giới hạn, dữ liệu có thể mất (chấp nhận được).
-   **Database (Postgres):** Chậm hơn (Disk), Quan hệ phức tạp (SQL), dung lượng lớn, đảm bảo an toàn dữ liệu tuyệt đối (ACID).

---

## 5. 🐳 VỀ DEVOPS (DOCKER & NGINX)

### Q17: Khác nhau giữa Docker Image và Container?

**Trả lời:**

-   **Image:** Là bản thiết kế (Blueprint), tĩnh, read-only (giống file .exe).
-   **Container:** Là một instance đang chạy của Image (giống process đang chạy), có thể ghi dữ liệu (read-write layer).

### Q18: Volume và Network trong Docker để làm gì?

**Trả lời:**

-   **Volume:** Để lưu trữ dữ liệu bền vững (Persist Data). Nếu xóa Container mà không có Volume, dữ liệu DB sẽ mất.
-   **Network:** Để các Container (App, DB, Redis) nhìn thấy và giao tiếp được với nhau qua tên Service.

### Q19: Bạn dùng Nginx để làm gì? Cơ chế Reverse Proxy?

**Trả lời:**

-   **Reverse Proxy:** Nginx đứng trước, nhận request từ Client và chuyển tiếp (forward) vào Spring Boot hoặc FastAPI. Client không biết Server thật sự nằm đâu.
-   **Load Balancing:** Phân tải nếu chạy nhiều instance.
-   **Serve Static File:** Phục vụ ảnh, file HTML tĩnh nhanh hơn Backend.
-   **Routing:** `/api/v1/ai` -> FastAPI, `/api` -> Spring Boot.

---

## 6. 🛡️ VỀ BẢO MẬT (SECURITY)

### Q20: Bạn bảo vệ API như thế nào?

**Trả lời:**

-   **JWT:** Xác thực người dùng.
-   **Rate Limit:** Chống Spam bằng Redis.
-   **CORS:** Cấu hình chỉ cho phép các domain tin cậy (Frontend) gọi API.

### Q21: Bạn có chống SQL Injection chưa?

**Trả lời:**

-   Có. Em sử dụng **JPA/Hibernate**, nó mặc định sử dụng **Prepared Statements** (tham số hóa câu truy vấn) nên ngăn chặn được SQL Injection cơ bản.

---

## 7. 🐛 VỀ TROUBLESHOOTING & SCALING

### Q22: Nếu một service bị down thì hệ thống có hoạt động không?

**Trả lời:**

-   Nếu **AI Service down:** App vẫn chạy, nhưng tính năng gợi ý/dự đoán sẽ lỗi.
-   Nếu **Redis down:** App vẫn chạy (nếu code xử lý try-catch tốt), nhưng sẽ chậm (do query DB trực tiếp) và không chơi được Game (do mất Session).
-   Nếu **DB down:** Hệ thống ngưng hoạt động hoàn toàn.

### Q23: Tại sao cần Redis khi scale nhiều instance (Horizontal Scaling)?

**Trả lời:**

-   Khi chạy nhiều instance Spring Boot, Session của user nếu lưu trên RAM của server A thì server B sẽ không biết.
-   Redis đóng vai trò là **Distributed Session Store** (kho session tập trung). Bất kỳ instance nào cũng có thể truy cập Redis để lấy thông tin user, đảm bảo trải nghiệm đồng nhất.

### Q24: Nếu lượng user tăng lên 100.000, bạn sẽ tối ưu gì trước?

**Trả lời:**

-   1. **Caching:** Tận dụng Redis triệt để hơn.
-   2. **Database:** Đánh Index kỹ hơn, tách Read/Write Replica.
-   3. **CDN:** Đẩy static file (ảnh, video) ra CDN.
-   4. **Scale:** Tăng số lượng Container (Horizontal Scaling).

---

## 8. 🧠 CÂU HỎI TƯ DUY (TRICKY QUESTIONS)

### Q25: Hệ thống của bạn có điểm nghẽn (bottleneck) ở đâu?

**Trả lời:**

-   Điểm nghẽn lớn nhất thường là **Database (I/O)**.
-   Hoặc giao tiếp đồng bộ (Synchronous) giữa Spring Boot và FastAPI (nếu AI xử lý lâu, User phải chờ). Giải pháp là chuyển sang cơ chế bất đồng bộ (Message Queue).

### Q26: Tại sao không dùng một framework mà dùng cả hai?

**Trả lời:**

-   "Em muốn chọn công cụ tốt nhất cho từng công việc (Right tool for the job). Java tốt cho hệ thống lớn, Python tốt cho AI. Sự kết hợp này mang lại hiệu quả cao hơn là cố ép Java làm AI hoặc Python làm Enterprise Backend."

---

## 9. 🛡️ BIỆN LUẬN CÔNG NGHỆ & HIỂU SÂU (TECHNOLOGY DEFENSE)

### Q27: Tại sao bạn dùng JWT thay vì Session truyền thống? (Lợi ích - Hạn chế)

**Trả lời:**

-   **Lợi ích:**
    -   **Stateless:** Server không cần lưu trạng thái, giúp dễ dàng mở rộng (Scale) nhiều server mà không lo đồng bộ session.
    -   **Mobile Friendly:** Dễ dàng tích hợp với Mobile App (Android/iOS) hơn là Cookie/Session.
-   **Hạn chế:**
    -   Khó thu hồi (revoke) token ngay lập tức khi user báo mất tài khoản (phải đợi hết hạn hoặc dùng Blacklist trên Redis).
    -   Payload lớn hơn Session ID, tốn băng thông hơn một chút.

### Q28: Docker khác gì với Máy ảo (Virtual Machine)? (Hiểu bản chất)

**Trả lời:**

-   **Docker (Container):** Ảo hóa ở cấp hệ điều hành (OS Level). Các container chia sẻ chung Kernel của máy chủ (Host), chỉ đóng gói thư viện và ứng dụng. -> Nhẹ, khởi động nhanh (giây).
-   **Virtual Machine:** Ảo hóa phần cứng. Mỗi VM chạy một hệ điều hành riêng biệt (Guest OS) trên nền Hypervisor. -> Nặng, khởi động lâu (phút).

### Q29: Python có cơ chế GIL (Global Interpreter Lock), tại sao FastAPI lại nhanh? (Hiểu bản chất)

**Trả lời:**

-   **GIL:** Là cơ chế của Python chỉ cho phép 1 thread chạy tại 1 thời điểm (hạn chế CPU-bound).
-   **FastAPI:** Nhanh nhờ sử dụng **Asynchronous I/O (async/await)**. Khi gặp tác vụ chờ (I/O bound) như gọi DB hay gọi API khác, nó sẽ nhường CPU cho request khác thay vì ngồi chờ. Do đó nó xử lý được hàng ngàn request đồng thời.

### Q30: Nhược điểm lớn nhất của kiến trúc hiện tại là gì? (Tư duy phản biện)

**Trả lời:**

-   **Độ trễ (Latency):** Việc giao tiếp giữa Spring Boot và FastAPI qua HTTP sẽ chậm hơn so với việc gọi hàm nội bộ trong cùng một ngôn ngữ.
-   **Phức tạp vận hành:** Phải quản lý 2 môi trường (Java & Python), 2 quy trình build/deploy khác nhau.

### Q31: Sự khác nhau giữa Interface và Abstract Class trong Java? Tại sao Service dùng Interface? (Java Core)

**Trả lời:**

-   **Interface:** Chỉ chứa các method trừu tượng (trước Java 8), dùng để định nghĩa "Hành vi" (Contract). Một class có thể implement nhiều Interface.
-   **Abstract Class:** Có thể chứa logic chung (method thường) và method trừu tượng. Dùng để định nghĩa "Bản chất" (Is-a).
-   **Tại sao Service dùng Interface:** Để tuân thủ nguyên lý **Loose Coupling** (Lỏng lẻo). Controller chỉ cần biết Interface, không cần biết Class cụ thể. Giúp dễ dàng thay thế implementation hoặc Mock khi test.

### Q32: Nếu Docker Container bị xóa, dữ liệu log có mất không? (Nếu hỏng thì sao)

**Trả lời:**

-   Mặc định là **CÓ**. Log của container nằm trong container.
-   **Giải pháp:** Em cấu hình **Docker Volume** hoặc **Bind Mount** để map thư mục log ra ngoài máy chủ (Host), hoặc dùng các driver logging để đẩy log về hệ thống tập trung (ELK Stack/Loki) nếu cần.

---

## 💡 MẸO TRẢ LỜI PHỎNG VẤN

1.  **Tự tin:** Khẳng định "Em đã thiết kế...", "Em quyết định chọn..." để thể hiện sự làm chủ công nghệ.
2.  **Trung thực:** Nếu chưa làm được tính năng nào (ví dụ: Sharding DB), hãy nói "Em chưa triển khai nhưng em biết hướng giải quyết là...".
3.  **Nhấn mạnh điểm mạnh:** Hãy lái câu chuyện về các phần em làm tốt nhất (Redis, Offline Sync, SM-2).
