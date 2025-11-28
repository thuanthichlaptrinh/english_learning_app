# TÀI LIỆU KIỂM THỬ PHẦN MỀM (TEST CASES)

Tài liệu này mô tả chi tiết các trường hợp kiểm thử (Test Cases) cho các chức năng chính của hệ thống Card Words, bao gồm: Đăng ký, Đăng nhập, Đổi mật khẩu, Admin, Profile, Tìm kiếm, Game và Học từ vựng.

---

## 1. Chức năng Đăng ký (Registration)

**Mô tả:** Người dùng mới đăng ký tài khoản vào hệ thống. Hệ thống sẽ tự động sinh mật khẩu ngẫu nhiên và gửi về email của người dùng.

### 1.1. Phân hoạch tương đương (Equivalence Partitioning)

| Đầu vào                | Lớp hợp lệ (Valid)                                          | Lớp không hợp lệ (Invalid)                       |
| :--------------------- | :---------------------------------------------------------- | :----------------------------------------------- |
| **Họ và tên**          | Có nhập (Chuỗi ký tự khác rỗng)                             | Để trống                                         |
| **Email - Local part** | Chứa ít nhất 1 ký tự hợp lệ (a-z, A-Z, 0-9, ., \_, %, +, -) | Trống, Chứa ký tự đặc biệt không cho phép        |
| **Email - @**          | Có đúng 1 ký tự @                                           | Không có @, Có nhiều hơn 1 @                     |
| **Email - Domain**     | Có ít nhất 1 ký tự hợp lệ ([a-zA-Z0-9.-]+)                  | Trống, Chứa ký tự không hợp lệ                   |
| **Email - Dấu chấm**   | Có dấu chấm ngăn cách Domain và TLD                         | Không có dấu chấm phân tách                      |
| **Email - TLD**        | Ít nhất 2 ký tự chữ cái ([a-zA-Z]{2,})                      | Dưới 2 ký tự, Chứa số hoặc ký tự đặc biệt, Trống |
| **Tên tài khoản**      | Tên tài khoản chưa tồn tại                                  | Tên tài khoản đã tồn tại, Để trống               |
| **Giới tính**          | Nam, Nữ, Khác                                               | Null (nếu bắt buộc)                              |
| **Ngày sinh**          | Định dạng Date hợp lệ                                       | Null, Định dạng sai                              |
| **Trình độ**           | A1, A2, B1, B2, C1, C2                                      | Null, Giá trị không nằm trong danh sách          |

### 1.2. Bảng Test Case

| ID       | Tiêu đề/Kịch bản                            | Tóm tắt                               | Các bước kiểm tra                                                                             | Dữ liệu kiểm tra                                                                                    | Kết quả mong đợi                                                                                                                                                           | Điều kiện tiên quyết              | Kết quả thực tế | Trạng thái | Ghi chú |
| :------- | :------------------------------------------ | :------------------------------------ | :-------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-------------------------------- | :-------------- | :--------- | :------ |
| **TC01** | Đăng ký thành công                          | Kiểm tra đăng ký với thông tin hợp lệ | 1. Vào trang đăng ký<br>2. Nhập Email, Tên, Giới tính, Ngày sinh, Trình độ<br>3. Nhấn Đăng ký | Email: `newuser@test.com`<br>Name: `User Test`<br>Gender: `Nam`<br>DOB: `2000-01-01`<br>Level: `A1` | - Thông báo "Đăng ký thành công! Mật khẩu đã được gửi về email của bạn."<br>- User được tạo trong DB với trạng thái ACTIVE.<br>- Email chứa mật khẩu được gửi đến hộp thư. | Chưa đăng nhập                    |                 |            |         |
| **TC02** | Đăng ký thất bại - Email thiếu @            | Kiểm tra validate email               | 1. Nhập Email thiếu @<br>2. Nhấn Đăng ký                                                      | Email: `user.test.com`                                                                              | Hiển thị lỗi "Email không hợp lệ"                                                                                                                                          |                                   |                 |            |         |
| **TC03** | Đăng ký thất bại - Email thiếu TLD          | Kiểm tra validate email               | 1. Nhập Email thiếu đuôi miền<br>2. Nhấn Đăng ký                                              | Email: `user@test.`                                                                                 | Hiển thị lỗi "Email không hợp lệ"                                                                                                                                          |                                   |                 |            |         |
| **TC04** | Đăng ký thất bại - Email đã tồn tại         | Kiểm tra trùng lặp email              | 1. Nhập Email đã có trong DB<br>2. Nhấn Đăng ký                                               | Email: `exist@test.com`                                                                             | Hiển thị lỗi "Email đã được sử dụng"                                                                                                                                       | Email `exist@test.com` đã tồn tại |                 |            |         |
| **TC05** | Đăng ký thất bại - Họ tên rỗng              | Kiểm tra validate họ tên              | 1. Để trống Họ tên<br>2. Nhập các trường khác hợp lệ<br>3. Nhấn Đăng ký                       | Name: ``                                                                                            | Hiển thị lỗi "Họ tên không được để trống"                                                                                                                                  |                                   |                 |            |         |
| **TC06** | Đăng ký thất bại - Ngày sinh không hợp lệ   | Kiểm tra validate ngày sinh           | 1. Nhập ngày sinh tương lai<br>2. Nhấn Đăng ký                                                | DOB: `2099-01-01`                                                                                   | Hiển thị lỗi "Ngày sinh không hợp lệ"                                                                                                                                      |                                   |                 |            |         |
| **TC07** | Đăng ký thất bại - Trình độ không hợp lệ    | Kiểm tra validate enum                | 1. Gửi request với Level sai<br>2. Nhấn Đăng ký                                               | Level: `Z1`                                                                                         | Hiển thị lỗi "Trình độ không hợp lệ"                                                                                                                                       |                                   |                 |            |         |
| **TC08** | Đăng ký thất bại - Để trống trường bắt buộc | Kiểm tra trường bắt buộc              | 1. Để trống Tên hoặc Email<br>2. Nhấn Đăng ký                                                 | Tên: [Trống]                                                                                        | Hiển thị lỗi "Vui lòng nhập đầy đủ thông tin"                                                                                                                              |                                   |                 |            |         |

---

## 2. Chức năng Đăng nhập (Login)

### 2.1. Phân hoạch tương đương

| Đầu vào      | Lớp hợp lệ (Valid)                     | Lớp không hợp lệ (Invalid)              |
| :----------- | :------------------------------------- | :-------------------------------------- |
| **Email**    | Đúng định dạng email, tồn tại trong DB | Sai định dạng, Không tồn tại, Rỗng      |
| **Mật khẩu** | Độ dài 6-20 ký tự, đúng với DB         | < 6 hoặc > 20 ký tự, Sai mật khẩu, Rỗng |

### 2.2. Bảng Test Case

| ID       | Tiêu đề/Kịch bản                                | Tóm tắt                           | Các bước kiểm tra                                                   | Dữ liệu kiểm tra                         | Kết quả mong đợi                                            | Điều kiện tiên quyết   | Kết quả thực tế | Trạng thái | Ghi chú |
| :------- | :---------------------------------------------- | :-------------------------------- | :------------------------------------------------------------------ | :--------------------------------------- | :---------------------------------------------------------- | :--------------------- | :-------------- | :--------- | :------ |
| **TC09** | Đăng nhập thành công                            | Kiểm tra đăng nhập đúng thông tin | 1. Vào trang Login<br>2. Nhập Email, Pass đúng<br>3. Nhấn Đăng nhập | Email: `user@test.com`<br>Pass: `123456` | Đăng nhập thành công, nhận Token, vào trang chủ             | Tài khoản đã kích hoạt |                 |            |         |
| **TC10** | Đăng nhập thất bại - Sai mật khẩu               | Kiểm tra bảo mật mật khẩu         | 1. Nhập Email đúng<br>2. Nhập Pass sai<br>3. Nhấn Đăng nhập         | Pass: `wrongpass`                        | Báo lỗi "Thông tin đăng nhập không chính xác"               |                        |                 |            |         |
| **TC11** | Đăng nhập thất bại - Email không tồn tại        | Kiểm tra tài khoản chưa đăng ký   | 1. Nhập Email chưa có<br>2. Nhấn Đăng nhập                          | Email: `no@test.com`                     | Báo lỗi "Người dùng không tồn tại" hoặc thông báo chung     |                        |                 |            |         |
| **TC12** | Đăng nhập thất bại - Mật khẩu không đúng độ dài | Kiểm tra validate mật khẩu        | 1. Nhập Pass < 6 hoặc > 20 ký tự<br>2. Nhấn Đăng nhập               | Pass: `123` hoặc `a`.repeat(21)          | Báo lỗi validation (nếu có check client) hoặc lỗi đăng nhập |                        |                 |            |         |
| **TC13** | Đăng nhập thất bại - Email rỗng                 | Kiểm tra validate email           | 1. Để trống Email<br>2. Nhấn Đăng nhập                              | Email: ``                                | Báo lỗi "Email không được để trống"                         |                        |                 |            |         |
| **TC14** | Đăng nhập thất bại - Mật khẩu rỗng              | Kiểm tra validate mật khẩu        | 1. Để trống Mật khẩu<br>2. Nhấn Đăng nhập                           | Pass: ``                                 | Báo lỗi "Mật khẩu không được để trống"                      |                        |                 |            |         |

---

## 3. Chức năng Đổi mật khẩu (Change Password)

### 3.1. Phân hoạch tương đương

| Đầu vào               | Lớp hợp lệ (Valid)                           | Lớp không hợp lệ (Invalid)                   |
| :-------------------- | :------------------------------------------- | :------------------------------------------- |
| **Mật khẩu hiện tại** | Không rỗng, Trùng khớp với mật khẩu hiện tại | Rỗng, Sai mật khẩu cũ                        |
| **Mật khẩu mới**      | Độ dài 6-20 ký tự, Khác mật khẩu cũ          | Rỗng, < 6 hoặc > 20 ký tự, Trùng mật khẩu cũ |
| **Xác nhận mật khẩu** | Không rỗng, Trùng khớp với mật khẩu mới      | Rỗng, Không trùng khớp                       |

### 3.2. Bảng Test Case

| ID       | Tiêu đề/Kịch bản                                 | Tóm tắt                           | Các bước kiểm tra                                                              | Dữ liệu kiểm tra                                    | Kết quả mong đợi                                        | Điều kiện tiên quyết | Kết quả thực tế | Trạng thái | Ghi chú |
| :------- | :----------------------------------------------- | :-------------------------------- | :----------------------------------------------------------------------------- | :-------------------------------------------------- | :------------------------------------------------------ | :------------------- | :-------------- | :--------- | :------ |
| **TC15** | Đổi mật khẩu thành công                          | Kiểm tra quy trình đổi pass chuẩn | 1. Vào Profile -> Đổi MK<br>2. Nhập Old Pass, New Pass, Confirm Pass<br>3. Lưu | Old: `123456`<br>New: `654321`<br>Confirm: `654321` | Thông báo thành công, lần sau đăng nhập bằng pass mới   | Đã đăng nhập         |                 |            |         |
| **TC16** | Đổi MK thất bại - Sai MK cũ                      | Kiểm tra xác thực chủ sở hữu      | 1. Nhập Old Pass sai                                                           | Old: `wrong`                                        | Báo lỗi "Mật khẩu cũ không chính xác"                   |                      |                 |            |         |
| **TC17** | Đổi MK thất bại - Xác nhận không khớp            | Kiểm tra nhập liệu                | 1. Nhập New Pass và Confirm khác nhau                                          | New: `123456`<br>Confirm: `654321`                  | Báo lỗi "Mật khẩu xác nhận không khớp"                  |                      |                 |            |         |
| **TC18** | Đổi MK thất bại - Mật khẩu mới không hợp lệ      | Kiểm tra độ dài mật khẩu mới      | 1. Nhập New Pass < 6 ký tự                                                     | New: `123`                                          | Báo lỗi "Mật khẩu phải từ 6-20 ký tự"                   |                      |                 |            |         |
| **TC19** | Đổi MK thất bại - Mật khẩu mới trùng mật khẩu cũ | Kiểm tra logic đổi mật khẩu       | 1. Nhập New Pass giống Old Pass                                                | New: `123456`                                       | Báo lỗi "Mật khẩu mới không được trùng với mật khẩu cũ" |                      |                 |            |         |
| **TC20** | Đổi MK thất bại - Để trống trường bắt buộc       | Kiểm tra validate                 | 1. Để trống 1 trong 3 trường<br>2. Lưu                                         | Old: ``                                             | Báo lỗi "Vui lòng nhập đầy đủ thông tin"                |                      |                 |            |         |

---

## 4. Chức năng Quản trị (Admin)

### 4.1. Quản lý Chủ đề (Topic Management)

| Đầu vào        | Lớp hợp lệ (Valid)      | Lớp không hợp lệ (Invalid) |
| :------------- | :---------------------- | :------------------------- |
| **Tên chủ đề** | 1-100 ký tự, Không rỗng | Rỗng, > 100 ký tự          |
| **Mô tả**      | <= 500 ký tự            | > 500 ký tự                |

### 4.2. Quản lý Từ vựng (Vocab Management)

| Đầu vào              | Lớp hợp lệ (Valid)       | Lớp không hợp lệ (Invalid) |
| :------------------- | :----------------------- | :------------------------- |
| **Từ vựng (Word)**   | 1-100 ký tự, Không rỗng  | Rỗng, > 100 ký tự          |
| **Nghĩa tiếng Việt** | <= 500 ký tự, Không rỗng | Rỗng, > 500 ký tự          |
| **Phiên âm**         | <= 100 ký tự             | > 100 ký tự                |
| **CEFR Level**       | A1, A2, B1, B2, C1, C2   | Giá trị khác               |

### 4.3. Bảng Test Case

| ID       | Tiêu đề/Kịch bản                    | Tóm tắt                | Các bước kiểm tra                                                          | Dữ liệu kiểm tra                                    | Kết quả mong đợi                                | Điều kiện tiên quyết | Kết quả thực tế | Trạng thái | Ghi chú |
| :------- | :---------------------------------- | :--------------------- | :------------------------------------------------------------------------- | :-------------------------------------------------- | :---------------------------------------------- | :------------------- | :-------------- | :--------- | :------ |
| **TC21** | Tạo chủ đề thành công               | Kiểm tra tạo topic     | 1. Admin vào trang QL Chủ đề<br>2. Nhập Tên, Mô tả<br>3. Lưu               | Name: `Topic 1`<br>Desc: `Mô tả topic`              | Tạo thành công, hiển thị trong danh sách        | Role ADMIN           |                 |            |         |
| **TC22** | Tạo chủ đề thất bại - Tên rỗng      | Kiểm tra validate      | 1. Để trống tên chủ đề<br>2. Lưu                                           | Name: ``                                            | Báo lỗi "Tên chủ đề không được để trống"        |                      |                 |            |         |
| **TC23** | Tạo chủ đề thất bại - Tên quá dài   | Kiểm tra validate      | 1. Nhập tên > 100 ký tự<br>2. Lưu                                          | Name: `a`.repeat(101)                               | Báo lỗi "Tên chủ đề tối đa 100 ký tự"           |                      |                 |            |         |
| **TC24** | Tạo chủ đề thất bại - Mô tả quá dài | Kiểm tra validate      | 1. Nhập mô tả > 500 ký tự<br>2. Lưu                                        | Desc: `a`.repeat(501)                               | Báo lỗi "Mô tả tối đa 500 ký tự"                |                      |                 |            |         |
| **TC25** | Tạo từ vựng thành công              | Kiểm tra tạo vocab     | 1. Admin vào trang QL Từ vựng<br>2. Nhập đầy đủ thông tin hợp lệ<br>3. Lưu | Word: `Hello`<br>Meaning: `Xin chào`<br>Level: `A1` | Tạo thành công, hiển thị trong danh sách        | Role ADMIN           |                 |            |         |
| **TC26** | Tạo từ vựng thất bại - Sai Level    | Kiểm tra validate enum | 1. Nhập Level không hợp lệ<br>2. Lưu                                       | Level: `Z1`                                         | Báo lỗi "CEFR level phải là một trong: A1...C2" |                      |                 |            |         |
| **TC27** | Tạo từ vựng thất bại - Từ vựng rỗng | Kiểm tra validate      | 1. Để trống từ vựng<br>2. Lưu                                              | Word: ``                                            | Báo lỗi "Từ vựng không được để trống"           |                      |                 |            |         |
| **TC28** | Tạo từ vựng thất bại - Nghĩa rỗng   | Kiểm tra validate      | 1. Để trống nghĩa tiếng Việt<br>2. Lưu                                     | Meaning: ``                                         | Báo lỗi "Nghĩa tiếng Việt không được để trống"  |                      |                 |            |         |
| **TC29** | Tạo từ vựng thất bại - Quá độ dài   | Kiểm tra validate      | 1. Nhập Word > 100 hoặc Meaning > 500<br>2. Lưu                            | Word: `a`.repeat(101)                               | Báo lỗi độ dài tương ứng                        |                      |                 |            |         |

---

## 5. Chức năng Đổi thông tin người dùng (Update Profile)

### 5.1. Phân hoạch tương đương

| Đầu vào       | Lớp hợp lệ (Valid)     | Lớp không hợp lệ (Invalid)   |
| :------------ | :--------------------- | :--------------------------- |
| **Họ và tên** | 2-100 ký tự            | < 2 hoặc > 100 ký tự         |
| **Giới tính** | <= 10 ký tự            | > 10 ký tự                   |
| **Ngày sinh** | Ngày trong quá khứ     | Ngày hiện tại hoặc tương lai |
| **Trình độ**  | A1, A2, B1, B2, C1, C2 | Giá trị khác                 |

### 5.2. Bảng Test Case

| ID       | Tiêu đề/Kịch bản                        | Tóm tắt                     | Các bước kiểm tra                                            | Dữ liệu kiểm tra                                       | Kết quả mong đợi                               | Điều kiện tiên quyết | Kết quả thực tế | Trạng thái | Ghi chú |
| :------- | :-------------------------------------- | :-------------------------- | :----------------------------------------------------------- | :----------------------------------------------------- | :--------------------------------------------- | :------------------- | :-------------- | :--------- | :------ |
| **TC18** | Cập nhật Profile thành công             | Kiểm tra sửa thông tin      | 1. Vào Profile<br>2. Sửa Tên, Giới tính, Ngày sinh<br>3. Lưu | Name: `New Name`<br>Gender: `Nam`<br>DOB: `2000-01-01` | Thông báo cập nhật thành công                  | Đã đăng nhập         |                 |            |         |
| **TC19** | Cập nhật thất bại - Tên quá ngắn        | Kiểm tra validate tên       | 1. Nhập tên 1 ký tự<br>2. Lưu                                | Name: `A`                                              | Báo lỗi "Tên phải từ 2-100 ký tự"              |                      |                 |            |         |
| **TC20** | Cập nhật thất bại - Ngày sinh tương lai | Kiểm tra validate ngày sinh | 1. Nhập ngày sinh là ngày mai<br>2. Lưu                      | DOB: `Tomorrow`                                        | Báo lỗi "Ngày sinh phải là ngày trong quá khứ" |                      |                 |            |         |

---

## 6. Chức năng Tìm kiếm (Search)

### 6.1. Phân hoạch tương đương

| Đầu vào     | Lớp hợp lệ (Valid) | Lớp không hợp lệ (Invalid)                  |
| :---------- | :----------------- | :------------------------------------------ |
| **Từ khóa** | Chuỗi ký tự bất kỳ | (Không có ràng buộc đặc biệt, trừ khi rỗng) |

### 6.2. Bảng Test Case

| ID       | Tiêu đề/Kịch bản   | Tóm tắt                | Các bước kiểm tra                     | Dữ liệu kiểm tra | Kết quả mong đợi              | Điều kiện tiên quyết | Kết quả thực tế | Trạng thái | Ghi chú |
| :------- | :----------------- | :--------------------- | :------------------------------------ | :--------------- | :---------------------------- | :------------------- | :-------------- | :--------- | :------ |
| **TC21** | Tìm kiếm chính xác | Kiểm tra tìm kiếm      | 1. Nhập từ khóa chính xác<br>2. Enter | Keyword: `apple` | Hiển thị kết quả chính xác    |                      |                 |            |         |
| **TC22** | Tìm kiếm gần đúng  | Kiểm tra tìm kiếm like | 1. Nhập một phần từ khóa<br>2. Enter  | Keyword: `app`   | Hiển thị danh sách chứa `app` |                      |                 |            |         |

---

## 7. Chức năng Chơi Game (Quick Quiz)

### 7.1. Cấu hình Game (Start Request)

| Đầu vào           | Lớp hợp lệ (Valid) | Lớp không hợp lệ (Invalid) |
| :---------------- | :----------------- | :------------------------- |
| **Số câu hỏi**    | 2 - 40 câu         | < 2 hoặc > 40              |
| **Thời gian/câu** | 3 - 60 giây        | < 3 hoặc > 60              |

### 7.2. Trả lời câu hỏi (Answer Request)

| Đầu vào             | Lớp hợp lệ (Valid)              | Lớp không hợp lệ (Invalid) |
| :------------------ | :------------------------------ | :------------------------- |
| **Session ID**      | UUID hợp lệ, không rỗng         | Rỗng, Sai định dạng        |
| **Question Number** | Số nguyên dương                 | Rỗng                       |
| **Selected Option** | 0, 1, 2, 3 (hoặc null nếu skip) | < 0 hoặc > 3               |
| **Time Taken**      | Số nguyên dương                 | Rỗng                       |

### 7.3. Bảng Test Case

| ID       | Tiêu đề/Kịch bản                             | Tóm tắt                  | Các bước kiểm tra                                         | Dữ liệu kiểm tra           | Kết quả mong đợi                                    | Điều kiện tiên quyết | Kết quả thực tế | Trạng thái | Ghi chú |
| :------- | :------------------------------------------- | :----------------------- | :-------------------------------------------------------- | :------------------------- | :-------------------------------------------------- | :------------------- | :-------------- | :--------- | :------ |
| **TC41** | Bắt đầu game thành công                      | Kiểm tra start game      | 1. Chọn cấu hình hợp lệ<br>2. Nhấn Start                  | Questions: 10<br>Time: 10s | Game bắt đầu, trả về Session ID và câu hỏi đầu tiên |                      |                 |            |         |
| **TC42** | Bắt đầu game thất bại - Số câu hỏi quá ít    | Kiểm tra validate config | 1. Nhập số câu hỏi < 2<br>2. Start                        | Questions: 1               | Báo lỗi "Số câu hỏi tối thiểu là 2"                 |                      |                 |            |         |
| **TC43** | Bắt đầu game thất bại - Số câu hỏi quá nhiều | Kiểm tra validate config | 1. Nhập số câu hỏi > 40<br>2. Start                       | Questions: 41              | Báo lỗi "Số câu hỏi tối đa là 40"                   |                      |                 |            |         |
| **TC44** | Bắt đầu game thất bại - Thời gian quá ngắn   | Kiểm tra validate config | 1. Nhập thời gian < 3s<br>2. Start                        | Time: 2s                   | Báo lỗi "Thời gian tối thiểu là 3 giây"             |                      |                 |            |         |
| **TC45** | Bắt đầu game thất bại - Thời gian quá dài    | Kiểm tra validate config | 1. Nhập thời gian > 60s<br>2. Start                       | Time: 61s                  | Báo lỗi "Thời gian tối đa là 60 giây"               |                      |                 |            |         |
| **TC46** | Trả lời câu hỏi                              | Kiểm tra submit answer   | 1. Chọn đáp án<br>2. Gửi request                          | Index: 0<br>Time: 2s       | Hệ thống ghi nhận, trả về kết quả đúng/sai          | Game đang chạy       |                 |            |         |
| **TC47** | Trả lời câu hỏi - Timeout                    | Kiểm tra submit answer   | 1. Không chọn đáp án<br>2. Gửi request (hoặc auto submit) | Index: null<br>Time: 11s   | Hệ thống ghi nhận sai do timeout                    | Game đang chạy       |                 |            |         |

---

## 8. Chức năng Học từ vựng (Learn Vocab)

### 8.1. Bảng Test Case

| ID       | Tiêu đề/Kịch bản      | Tóm tắt                     | Các bước kiểm tra                                      | Dữ liệu kiểm tra        | Kết quả mong đợi                                           | Điều kiện tiên quyết | Kết quả thực tế | Trạng thái | Ghi chú |
| :------- | :-------------------- | :-------------------------- | :----------------------------------------------------- | :---------------------- | :--------------------------------------------------------- | :------------------- | :-------------- | :--------- | :------ |
| **TC48** | Học từ mới            | Kiểm tra tiến độ học        | 1. User học 1 từ mới                                   | Word ID: 1              | Trạng thái từ chuyển sang LEARNING                         |                      |                 |            |         |
| **TC49** | Ôn tập từ vựng - Nhớ  | Kiểm tra thuật toán lặp lại | 1. User ôn tập từ đến hạn<br>2. Chọn mức độ nhớ (3-5)  | Word ID: 1<br>Rating: 5 | Cập nhật thời gian ôn tập tiếp theo (Next Review) tăng lên |                      |                 |            |         |
| **TC50** | Ôn tập từ vựng - Quên | Kiểm tra thuật toán lặp lại | 1. User ôn tập từ đến hạn<br>2. Chọn mức độ quên (0-2) | Word ID: 1<br>Rating: 0 | Reset thời gian ôn tập, trạng thái có thể về LEARNING      |                      |                 |            |

---

## 9. Chức năng Game Ghép Hình - Từ (Image Word Matching)

### 9.1. Cấu hình Game (Start Request)

| Đầu vào                  | Lớp hợp lệ (Valid)           | Lớp không hợp lệ (Invalid) |
| :----------------------- | :--------------------------- | :------------------------- |
| **Số cặp (Total Pairs)** | 2 - 5 cặp                    | < 2 hoặc > 5               |
| **CEFR Level**           | A1, A2, B1, B2, C1, C2, Null | Giá trị khác               |

### 9.2. Gửi kết quả (Answer Request)

| Đầu vào               | Lớp hợp lệ (Valid)                | Lớp không hợp lệ (Invalid)         |
| :-------------------- | :-------------------------------- | :--------------------------------- |
| **Session ID**        | UUID hợp lệ, tồn tại              | Rỗng, Sai định dạng, Không tồn tại |
| **Matched Vocab IDs** | Danh sách ID từ vựng đã ghép đúng | Rỗng, Null                         |
| **Time Taken**        | Số nguyên dương (milliseconds)    | <= 0, Null                         |
| **Wrong Attempts**    | Số nguyên >= 0                    | < 0                                |

### 9.3. Bảng Test Case

| ID       | Tiêu đề/Kịch bản                            | Tóm tắt                   | Các bước kiểm tra                        | Dữ liệu kiểm tra          | Kết quả mong đợi                                   | Điều kiện tiên quyết | Kết quả thực tế | Trạng thái | Ghi chú |
| :------- | :------------------------------------------ | :------------------------ | :--------------------------------------- | :------------------------ | :------------------------------------------------- | :------------------- | :-------------- | :--------- | :------ |
| **TC51** | Bắt đầu game thành công                     | Kiểm tra start game       | 1. Chọn số cặp hợp lệ<br>2. Nhấn Start   | Pairs: 5<br>Level: A1     | Game bắt đầu, trả về danh sách hình ảnh và từ vựng |                      |                 |            |         |
| **TC52** | Bắt đầu game thất bại - Số cặp quá ít       | Kiểm tra validate config  | 1. Nhập số cặp < 2<br>2. Start           | Pairs: 1                  | Báo lỗi "Số cặp tối thiểu là 2"                    |                      |                 |            |         |
| **TC53** | Bắt đầu game thất bại - Số cặp quá nhiều    | Kiểm tra validate config  | 1. Nhập số cặp > 5<br>2. Start           | Pairs: 6                  | Báo lỗi "Số cặp tối đa là 5"                       |                      |                 |            |         |
| **TC54** | Gửi kết quả thành công                      | Kiểm tra submit game      | 1. Hoàn thành ghép cặp<br>2. Gửi kết quả | Time: 15000ms<br>Wrong: 0 | Hệ thống ghi nhận điểm, trả về kết quả chi tiết    | Game đang chạy       |                 |            |         |
| **TC55** | Gửi kết quả thất bại - Session không hợp lệ | Kiểm tra validate session | 1. Gửi request với Session ID sai        | Session: `invalid-uuid`   | Báo lỗi "Session không tồn tại" hoặc lỗi định dạng |                      |                 |            |         |

---

## 10. Chức năng Game Ghép Từ - Nghĩa (Word Definition Matching)

### 10.1. Cấu hình Game (Start Request)

| Đầu vào                  | Lớp hợp lệ (Valid)           | Lớp không hợp lệ (Invalid) |
| :----------------------- | :--------------------------- | :------------------------- |
| **Số cặp (Total Pairs)** | 2 - 5 cặp                    | < 2 hoặc > 5               |
| **CEFR Level**           | A1, A2, B1, B2, C1, C2, Null | Giá trị khác               |

### 10.2. Gửi kết quả (Answer Request)

| Đầu vào               | Lớp hợp lệ (Valid)                            | Lớp không hợp lệ (Invalid)         |
| :-------------------- | :-------------------------------------------- | :--------------------------------- |
| **Session ID**        | UUID hợp lệ, tồn tại                          | Rỗng, Sai định dạng, Không tồn tại |
| **Matched Vocab IDs** | Danh sách ID từ vựng đã ghép đúng, Không rỗng | Rỗng, Null                         |
| **Time Taken**        | Số nguyên dương (milliseconds)                | <= 0, Null                         |
| **Wrong Attempts**    | Số nguyên >= 0                                | < 0                                |

### 10.3. Bảng Test Case

| ID       | Tiêu đề/Kịch bản                      | Tóm tắt                  | Các bước kiểm tra                        | Dữ liệu kiểm tra          | Kết quả mong đợi                                          | Điều kiện tiên quyết | Kết quả thực tế | Trạng thái | Ghi chú |
| :------- | :------------------------------------ | :----------------------- | :--------------------------------------- | :------------------------ | :-------------------------------------------------------- | :------------------- | :-------------- | :--------- | :------ | --- |
| **TC56** | Bắt đầu game thành công               | Kiểm tra start game      | 1. Chọn số cặp hợp lệ<br>2. Nhấn Start   | Pairs: 4<br>Level: B1     | Game bắt đầu, trả về danh sách từ và nghĩa                |                      |                 |            |         |
| **TC57** | Bắt đầu game thất bại - Số cặp sai    | Kiểm tra validate config | 1. Nhập số cặp không hợp lệ<br>2. Start  | Pairs: 10                 | Báo lỗi "Số cặp tối đa là 5"                              |                      |                 |            |         |
| **TC58** | Gửi kết quả thành công                | Kiểm tra submit game     | 1. Hoàn thành ghép cặp<br>2. Gửi kết quả | Time: 20000ms<br>Wrong: 2 | Hệ thống ghi nhận điểm (trừ điểm sai), trả về kết quả     | Game đang chạy       |                 |            |         |
| **TC59** | Gửi kết quả thất bại - Danh sách rỗng | Kiểm tra validate data   | 1. Gửi danh sách matched rỗng            | Matched: []               | Báo lỗi "Danh sách vocab IDs đã ghép không được để trống" |                      |                 |            |         |     |

---

## 3. Chức năng Đổi mật khẩu (Change Password)

### 3.1. Phân hoạch tương đương

| Điều kiện             | Lớp hợp lệ                       | Lớp không hợp lệ             |
| :-------------------- | :------------------------------- | :--------------------------- |
| **Mật khẩu cũ**       | Trùng khớp với mật khẩu hiện tại | Sai mật khẩu cũ              |
| **Mật khẩu mới**      | >= 6 ký tự, Khác mật khẩu cũ     | < 6 ký tự, Trùng mật khẩu cũ |
| **Xác nhận mật khẩu** | Trùng khớp với mật khẩu mới      | Không trùng khớp             |

### 3.2. Bảng Test Case

| ID       | Tiêu đề/Kịch bản                      | Tóm tắt                           | Các bước kiểm tra                                                              | Dữ liệu kiểm tra                                    | Kết quả mong đợi                                      | Điều kiện tiên quyết | Kết quả thực tế | Trạng thái | Ghi chú |
| :------- | :------------------------------------ | :-------------------------------- | :----------------------------------------------------------------------------- | :-------------------------------------------------- | :---------------------------------------------------- | :------------------- | :-------------- | :--------- | :------ |
| **TC08** | Đổi mật khẩu thành công               | Kiểm tra quy trình đổi pass chuẩn | 1. Vào Profile -> Đổi MK<br>2. Nhập Old Pass, New Pass, Confirm Pass<br>3. Lưu | Old: `123456`<br>New: `654321`<br>Confirm: `654321` | Thông báo thành công, lần sau đăng nhập bằng pass mới | Đã đăng nhập         |                 |            |         |
| **TC09** | Đổi MK thất bại - Sai MK cũ           | Kiểm tra xác thực chủ sở hữu      | 1. Nhập Old Pass sai                                                           | Old: `wrong`                                        | Báo lỗi "Mật khẩu cũ không chính xác"                 |                      |                 |            |         |
| **TC10** | Đổi MK thất bại - Xác nhận không khớp | Kiểm tra nhập liệu                | 1. Nhập New Pass và Confirm khác nhau                                          | New: `123`<br>Confirm: `456`                        | Báo lỗi "Mật khẩu xác nhận không khớp"                |                      |                 |            |         |

---

## 4. Chức năng Đăng nhập Admin

### 4.1. Phân hoạch tương đương

| Điều kiện            | Lớp hợp lệ   | Lớp không hợp lệ |
| :------------------- | :----------- | :--------------- |
| **Quyền hạn (Role)** | Role = ADMIN | Role = USER      |

### 4.2. Bảng Test Case

| ID       | Tiêu đề/Kịch bản                    | Tóm tắt                      | Các bước kiểm tra                                            | Dữ liệu kiểm tra                        | Kết quả mong đợi                                | Điều kiện tiên quyết    | Kết quả thực tế | Trạng thái | Ghi chú |
| :------- | :---------------------------------- | :--------------------------- | :----------------------------------------------------------- | :-------------------------------------- | :---------------------------------------------- | :---------------------- | :-------------- | :--------- | :------ |
| **TC11** | Admin truy cập trang quản trị       | Kiểm tra quyền Admin         | 1. Đăng nhập bằng tk Admin<br>2. Truy cập `/admin/dashboard` | User: `admin@test.com`<br>Role: `ADMIN` | Truy cập thành công, hiển thị dashboard         | Tài khoản có role ADMIN |                 |            |         |
| **TC12** | User thường truy cập trang quản trị | Kiểm tra chặn quyền truy cập | 1. Đăng nhập bằng tk User<br>2. Truy cập `/admin/dashboard`  | User: `user@test.com`<br>Role: `USER`   | Báo lỗi 403 Forbidden hoặc chuyển hướng về Home | Tài khoản có role USER  |                 |            |         |

---

## 5. Chức năng Đổi thông tin người dùng (Update Profile)

### 5.1. Phân hoạch tương đương

| Điều kiện        | Lớp hợp lệ                            | Lớp không hợp lệ                                 |
| :--------------- | :------------------------------------ | :----------------------------------------------- |
| **Tên hiển thị** | Chuỗi ký tự hợp lệ                    | Rỗng                                             |
| **Avatar**       | File ảnh (jpg, png), kích thước < 5MB | File không phải ảnh (txt, exe), kích thước > 5MB |

### 5.2. Bảng Test Case

| ID       | Tiêu đề/Kịch bản                        | Tóm tắt                       | Các bước kiểm tra                                            | Dữ liệu kiểm tra                                       | Kết quả mong đợi                                       | Điều kiện tiên quyết | Kết quả thực tế | Trạng thái | Ghi chú |
| :------- | :-------------------------------------- | :---------------------------- | :----------------------------------------------------------- | :----------------------------------------------------- | :----------------------------------------------------- | :------------------- | :-------------- | :--------- | :------ |
| **TC30** | Cập nhật Profile thành công             | Kiểm tra sửa thông tin        | 1. Vào Profile<br>2. Sửa Tên, Giới tính, Ngày sinh<br>3. Lưu | Name: `New Name`<br>Gender: `Nam`<br>DOB: `2000-01-01` | Thông báo cập nhật thành công                          | Đã đăng nhập         |                 |            |         |
| **TC31** | Cập nhật thất bại - Tên quá ngắn        | Kiểm tra validate tên         | 1. Nhập tên 1 ký tự<br>2. Lưu                                | Name: `A`                                              | Báo lỗi "Tên phải từ 2-100 ký tự"                      |                      |                 |            |         |
| **TC32** | Cập nhật thất bại - Tên quá dài         | Kiểm tra validate tên         | 1. Nhập tên > 100 ký tự<br>2. Lưu                            | Name: `a`.repeat(101)                                  | Báo lỗi "Tên phải từ 2-100 ký tự"                      |                      |                 |            |         |
| **TC33** | Cập nhật thất bại - Ngày sinh tương lai | Kiểm tra validate ngày sinh   | 1. Nhập ngày sinh là ngày mai<br>2. Lưu                      | DOB: `Tomorrow`                                        | Báo lỗi "Ngày sinh phải là ngày trong quá khứ"         |                      |                 |            |         |
| **TC34** | Cập nhật thất bại - Giới tính quá dài   | Kiểm tra validate giới tính   | 1. Nhập giới tính > 10 ký tự<br>2. Lưu                       | Gender: `a`.repeat(11)                                 | Báo lỗi "Giới tính tối đa 10 ký tự"                    |                      |                 |            |         |
| **TC35** | Upload Avatar thành công                | Kiểm tra tính năng upload ảnh | 1. Chọn file ảnh hợp lệ<br>2. Nhấn Upload/Lưu                | File: `avatar.jpg` (2MB)                               | Ảnh đại diện thay đổi, file được lưu trên server/cloud |                      |                 |            |         |
| **TC36** | Upload Avatar thất bại - File quá lớn   | Kiểm tra giới hạn file        | 1. Chọn file ảnh > 5MB                                       | File: `large.jpg` (10MB)                               | Báo lỗi "Kích thước file quá lớn"                      |                      |                 |            |         |
| **TC37** | Upload Avatar thất bại - Sai định dạng  | Kiểm tra định dạng file       | 1. Chọn file không phải ảnh<br>2. Lưu                        | File: `test.txt`                                       | Báo lỗi "Định dạng file không hợp lệ"                  |                      |                 |            |         |

---

## 6. Chức năng Tìm kiếm (Search)

### 6.1. Phân hoạch tương đương

| Điều kiện   | Lớp hợp lệ                       | Lớp không hợp lệ                                       |
| :---------- | :------------------------------- | :----------------------------------------------------- |
| **Từ khóa** | Từ có trong từ điển, Từ một phần | Từ không có trong từ điển, Ký tự đặc biệt không hợp lệ |

### 6.2. Bảng Test Case

| ID       | Tiêu đề/Kịch bản          | Tóm tắt                | Các bước kiểm tra                         | Dữ liệu kiểm tra  | Kết quả mong đợi                            | Điều kiện tiên quyết | Kết quả thực tế | Trạng thái | Ghi chú |
| :------- | :------------------------ | :--------------------- | :---------------------------------------- | :---------------- | :------------------------------------------ | :------------------- | :-------------- | :--------- | :------ |
| **TC38** | Tìm kiếm chính xác        | Kiểm tra tìm kiếm      | 1. Nhập từ khóa chính xác<br>2. Enter     | Keyword: `apple`  | Hiển thị kết quả chính xác                  |                      |                 |            |         |
| **TC39** | Tìm kiếm gần đúng         | Kiểm tra tìm kiếm like | 1. Nhập một phần từ khóa<br>2. Enter      | Keyword: `app`    | Hiển thị danh sách chứa `app`               |                      |                 |            |         |
| **TC40** | Tìm kiếm không có kết quả | Kiểm tra tìm kiếm      | 1. Nhập từ khóa không tồn tại<br>2. Enter | Keyword: `xyzabc` | Hiển thị thông báo "Không tìm thấy kết quả" |                      |                 |            |         |

---

## 7. Chức năng Chơi Game (Quick Quiz)

### 7.1. Phân hoạch tương đương

| Điều kiện       | Lớp hợp lệ              | Lớp không hợp lệ            |
| :-------------- | :---------------------- | :-------------------------- |
| **Câu trả lời** | Đáp án đúng, Đáp án sai | Không chọn đáp án (Timeout) |
| **Thời gian**   | < Thời gian quy định    | > Thời gian quy định        |

### 7.2. Bảng Test Case

| ID       | Tiêu đề/Kịch bản        | Tóm tắt                              | Các bước kiểm tra                             | Dữ liệu kiểm tra | Kết quả mong đợi                                         | Điều kiện tiên quyết | Kết quả thực tế | Trạng thái | Ghi chú |
| :------- | :---------------------- | :----------------------------------- | :-------------------------------------------- | :--------------- | :------------------------------------------------------- | :------------------- | :-------------- | :--------- | :------ |
| **TC19** | Trả lời đúng            | Kiểm tra logic tính điểm khi đúng    | 1. Vào game Quick Quiz<br>2. Chọn đáp án đúng | Đáp án: Đúng     | Hiển thị hiệu ứng đúng, cộng điểm, tăng Streak           | Đang trong game      |                 |            |         |
| **TC20** | Trả lời sai             | Kiểm tra logic khi sai               | 1. Chọn đáp án sai                            | Đáp án: Sai      | Hiển thị đáp án đúng, không cộng điểm, Reset Streak về 0 |                      |                 |            |         |
| **TC21** | Hết thời gian (Timeout) | Kiểm tra xử lý timeout               | 1. Không chọn đáp án cho đến khi hết giờ      | Time: > 15s      | Tự động chuyển câu, tính là sai, Reset Streak            |                      |                 |            |         |
| **TC22** | Tính điểm Streak        | Kiểm tra thuật toán cộng điểm Streak | 1. Trả lời đúng 3 câu liên tiếp               | Streak: 3        | Điểm câu thứ 3 được cộng thêm Bonus Streak               |                      |                 |            |         |

---

## 8. Chức năng Học từ vựng (Learn Vocab)

### 8.1. Phân hoạch tương đương

| Điều kiện           | Lớp hợp lệ               | Lớp không hợp lệ |
| :------------------ | :----------------------- | :--------------- |
| **Hành động**       | Học từ mới, Ôn tập từ cũ |                  |
| **Đánh giá (SM-2)** | Quên (0-2), Nhớ (3-5)    |                  |

### 8.2. Bảng Test Case

| ID       | Tiêu đề/Kịch bản | Tóm tắt                                   | Các bước kiểm tra                                          | Dữ liệu kiểm tra          | Kết quả mong đợi                                                          | Điều kiện tiên quyết | Kết quả thực tế | Trạng thái | Ghi chú |
| :------- | :--------------- | :---------------------------------------- | :--------------------------------------------------------- | :------------------------ | :------------------------------------------------------------------------ | :------------------- | :-------------- | :--------- | :------ |
| **TC23** | Học từ mới       | Kiểm tra khởi tạo tiến độ                 | 1. Vào bài học<br>2. Học 1 từ mới<br>3. Hoàn thành bài học | Từ: `Hello` (New)         | Từ `Hello` chuyển trạng thái sang `LEARNING`, lưu vào `UserVocabProgress` | Từ chưa học          |                 |            |         |
| **TC24** | Ôn tập - Nhớ tốt | Kiểm tra thuật toán SM-2 (Tăng interval)  | 1. Ôn tập từ đến hạn<br>2. Chọn mức "Dễ" (5)               | Từ: `Apple`<br>Rating: 5  | Interval tăng lên (ví dụ 1 ngày -> 6 ngày), EF tăng                       | Từ đến hạn ôn        |                 |            |         |
| **TC25** | Ôn tập - Quên    | Kiểm tra thuật toán SM-2 (Reset interval) | 1. Ôn tập từ<br>2. Chọn mức "Quên" (0)                     | Từ: `Banana`<br>Rating: 0 | Interval reset về 1 ngày, EF giảm, trạng thái có thể về LEARNING          |                      |                 |            |         |
