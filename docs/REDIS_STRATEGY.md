# 🚀 CHIẾN LƯỢC SỬ DỤNG REDIS (REDIS STRATEGY)

Tài liệu này mô tả chi tiết chiến lược sử dụng Redis trong dự án **Card Words**, tập trung vào việc tối ưu hóa hiệu suất, quản lý phiên người dùng và bảo vệ hệ thống.

---

## 1. 🎯 MỤC TIÊU & VAI TRÒ CỦA REDIS

Trong hệ thống Card Words, Redis không chỉ là một bộ nhớ đệm (cache) đơn thuần mà đóng vai trò cốt lõi trong các tác vụ yêu cầu tốc độ phản hồi cao và tính nhất quán tạm thời:

-   **Tăng tốc độ phản hồi (Low Latency):** Giảm thiểu độ trễ khi truy xuất dữ liệu thường xuyên sử dụng (như câu hỏi game, thông tin từ vựng).
-   **Giảm tải cho Database (Database Offloading):** Hạn chế các truy vấn phức tạp xuống PostgreSQL, đặc biệt là trong các phiên chơi game liên tục.
-   **Quản lý trạng thái phiên (Session Management):** Lưu trữ trạng thái tạm thời của các trò chơi (Quick Quiz) mà không cần ghi cứng xuống DB cho đến khi kết thúc.
-   **Bảo vệ hệ thống (Rate Limiting):** Kiểm soát tần suất request để chống spam và lạm dụng API.

---

## 2. 🏗️ KIẾN TRÚC & CẤU TRÚC DỮ LIỆU

### 2.1. Mô hình Service

Hệ thống sử dụng mô hình **Wrapper Service** để đóng gói các thao tác với Redis, giúp code dễ bảo trì và thay đổi implementation nếu cần.

-   **`BaseRedisService`**: Lớp nền tảng cung cấp các phương thức CRUD cơ bản (get, set, delete, expire) với RedisTemplate.
-   **`GameSessionCacheService`**: Service chuyên biệt quản lý dữ liệu cho các phiên game (câu hỏi, thời gian).
-   **`RateLimitingService`**: Service chuyên biệt xử lý logic giới hạn tốc độ truy cập.

### 2.2. Cấu trúc dữ liệu sử dụng

| Loại dữ liệu           | Redis Data Type      | Mục đích sử dụng                                                                 | Ví dụ Key                                 |
| :--------------------- | :------------------- | :------------------------------------------------------------------------------- | :---------------------------------------- |
| **Danh sách câu hỏi**  | `String` (JSON)      | Lưu toàn bộ danh sách câu hỏi của một phiên game dưới dạng chuỗi JSON.           | `quiz:session:questions:{sessionId}`      |
| **Giới hạn thời gian** | `String` (Integer)   | Lưu thời gian cho phép của mỗi câu hỏi (ms).                                     | `quiz:session:timelimit:{sessionId}`      |
| **Thời gian bắt đầu**  | `String` (Time)      | Lưu timestamp bắt đầu của từng câu hỏi để tính toán thời gian trả lời chính xác. | `quiz:session:q_start:{sessionId}:{qNum}` |
| **Rate Limit**         | `String` / `Integer` | Đếm số lượng request trong một khoảng thời gian.                                 | `ratelimit:game:{userId}:quickquiz`       |

---

## 3. 💡 CHIẾN LƯỢC CACHING (CACHING STRATEGIES)

### 3.1. Game Session Caching (Caching Phiên Game)

Đây là chiến lược quan trọng nhất để đảm bảo trải nghiệm mượt mà cho người chơi.

-   **Quy trình:**

    1.  Khi người dùng bắt đầu game (`startGame`), hệ thống lấy từ vựng từ DB, tạo danh sách câu hỏi.
    2.  **Serialize** toàn bộ danh sách câu hỏi thành JSON và lưu vào Redis với key theo `sessionId`.
    3.  Trong suốt quá trình chơi, client gửi `sessionId` lên. Server chỉ cần đọc từ Redis (rất nhanh) thay vì query lại DB.
    4.  Khi game kết thúc hoặc hết hạn, cache sẽ tự động bị xóa hoặc hết hạn (TTL).

-   **Lợi ích:**
    -   **Tốc độ:** Truy xuất câu hỏi tiếp theo gần như tức thì (< 5ms).
    -   **Tính nhất quán:** Đảm bảo bộ câu hỏi không bị thay đổi trong suốt quá trình chơi.

### 3.2. Serialization Strategy

-   Sử dụng **Jackson ObjectMapper** để chuyển đổi đối tượng Java sang JSON string trước khi lưu vào Redis.
-   **Lý do:** Đơn giản, dễ debug (có thể đọc được bằng mắt thường), và tương thích tốt với nhiều ngôn ngữ khác nhau nếu cần mở rộng microservices.

### 3.3. Time-To-Live (TTL) Policy

Việc quản lý vòng đời dữ liệu là cực kỳ quan trọng để tránh tràn bộ nhớ Redis.

| Loại dữ liệu            | TTL (Thời gian tồn tại) | Lý do                                                                                                     |
| :---------------------- | :---------------------- | :-------------------------------------------------------------------------------------------------------- |
| **Game Session Data**   | **30 phút**             | Đủ cho một phiên chơi game thông thường (thường < 5 phút), nhưng đủ dài để user có thể tạm dừng một chút. |
| **Rate Limit Counters** | **5 phút**              | Phù hợp với logic "tối đa X request trong 5 phút".                                                        |
| **JWT Blacklist**       | **Theo thời hạn Token** | Đảm bảo token bị vô hiệu hóa cho đến khi nó tự hết hạn.                                                   |

---

## 4. 🛡️ CHIẾN LƯỢC RATE LIMITING (GIỚI HẠN TỐC ĐỘ)

Sử dụng Redis để đếm số lần request của user trong một cửa sổ thời gian trượt (sliding window) hoặc cố định (fixed window).

-   **Cơ chế:**
    -   Mỗi khi user gọi API bắt đầu game, tăng counter trong Redis.
    -   Nếu counter > `MAX_GAMES_PER_5_MIN` (ví dụ: 10), chặn request.
    -   Key sẽ tự động hết hạn sau 5 phút, reset lại bộ đếm.
-   **Ưu điểm:** Xử lý phân tán tốt (nếu chạy nhiều instance server, rate limit vẫn hoạt động chính xác vì dùng chung Redis).

---

## 5. ⚠️ XỬ LÝ LỖI & FALLBACK

-   **Fail-Safe:** Các thao tác với Redis được bọc trong khối `try-catch`.
-   **Logging:** Nếu Redis gặp sự cố (mất kết nối, lỗi timeout), hệ thống sẽ ghi log lỗi (`log.error`) thay vì làm sập ứng dụng ngay lập tức.
-   **Lưu ý:** Hiện tại, nếu Redis chết, tính năng chơi game có thể bị gián đoạn (do phụ thuộc vào session cache). Trong tương lai có thể cân nhắc fallback lưu tạm vào Memory của Server (nếu chạy 1 instance) hoặc DB (chấp nhận chậm hơn).

---

## 6. 📝 KẾT LUẬN

Chiến lược sử dụng Redis của Card Words tập trung vào **hiệu năng** cho tính năng Game và **bảo mật** cho API. Việc tách biệt dữ liệu nóng (hot data - session game) ra khỏi Database chính giúp hệ thống có khả năng mở rộng (scale) tốt hơn khi số lượng người chơi tăng lên.

---

## 7. 🧩 VÍ DỤ THỰC TẾ: CHIẾN LƯỢC CACHING CHO LOGIN

Dưới đây là ví dụ cụ thể về cách áp dụng Redis để tối ưu hóa quy trình đăng nhập (`AuthenticationService.login`), giúp giảm tải DB và tăng tốc độ phản hồi.

### 7.1. Vấn đề

Mỗi khi người dùng đăng nhập, hệ thống thường phải thực hiện các bước:

1.  Tìm user trong DB bằng email (`SELECT * FROM users WHERE email = ?`).
2.  Kiểm tra mật khẩu.
3.  Lấy thông tin chi tiết (Role, Profile) để tạo JWT Token.

Nếu có hàng nghìn người đăng nhập cùng lúc, DB sẽ bị quá tải bởi các câu lệnh `SELECT` lặp đi lặp lại.

### 7.2. Giải pháp: Cache-Aside Pattern

Chúng ta sử dụng chiến lược **Cache-Aside** (Lazy Loading) kết hợp với **Write-Through** (khi đăng ký/cập nhật).

#### Quy trình Login tối ưu:

1.  **Kiểm tra Cache Email Mapping:**

    -   Hệ thống kiểm tra Redis key `user:email:{email}` để lấy `userId`.
    -   **HIT:** Lấy được `userId` ngay lập tức (tốn ~1-2ms).
    -   **MISS:** Query DB để tìm User, sau đó lưu mapping `email -> userId` vào Redis (TTL 12h).

2.  **Kiểm tra Cache User Profile:**

    -   Sau khi có `userId`, kiểm tra Redis Hash `user:profile:{userId}`.
    -   **HIT:** Lấy toàn bộ thông tin user (name, role, avatar...) từ RAM.
    -   **MISS:** Query DB, sau đó lưu toàn bộ object User vào Redis Hash (TTL 24h).

3.  **Tạo Token & Phản hồi:**
    -   Sử dụng thông tin từ Cache để tạo JWT Access Token & Refresh Token.
    -   Không cần query DB thêm lần nào nữa.

### 7.3. Minh họa Code (Pseudo-code)

```java
public AuthenticationResponse login(AuthenticationRequest request) {
    // 1. Authenticate (Spring Security check password)
    authenticationManager.authenticate(...);

    // 2. Tối ưu: Tìm User ID từ Cache trước
    String email = request.getEmail();
    UUID userId = userCacheService.getUserIdByEmail(email); // Redis GET

    User user;
    if (userId != null) {
        // ✅ CACHE HIT: Lấy thông tin chi tiết từ Redis Hash
        user = userCacheService.getUserProfile(userId);
        if (user == null) {
             // Fallback nếu profile hết hạn
             user = userRepository.findById(userId);
             userCacheService.cacheUserProfile(user);
        }
    } else {
        // ⚠️ CACHE MISS: Phải query DB
        user = userRepository.findByEmail(email);

        // Lưu ngay vào Cache cho lần sau
        userCacheService.cacheEmailToUserId(email, user.getId());
        userCacheService.cacheUserProfile(user);
    }

    // 3. Tạo Token từ thông tin (đã có trong cache)
    String accessToken = jwtService.generateToken(user);

    return new AuthenticationResponse(accessToken, ...);
}
```

### 7.4. Hiệu quả

-   **Trước khi Cache:** Mất trung bình **150ms - 300ms** cho mỗi request login (do độ trễ DB connection + query).
-   **Sau khi Cache:** Giảm xuống còn **10ms - 30ms** cho các lần đăng nhập tiếp theo.
-   **Giảm tải DB:** Giảm tới **90%** lượng query `SELECT` vào bảng User trong giờ cao điểm.
