# CHƯƠNG 1: THIẾT KẾ HỆ THỐNG

## 1.1. Giới thiệu

Hệ thống sử dụng kiến trúc đa cơ sở dữ liệu (Polyglot Persistence) kết hợp sức mạnh của PostgreSQL, Redis và Firebase để tối ưu hóa hiệu năng, tính toàn vẹn dữ liệu và khả năng mở rộng.

## 1.2. Thiết kế cơ sở dữ liệu

Cơ sở dữ liệu của hệ thống được thiết kế dựa trên mô hình quan hệ (Relational Database), sử dụng hệ quản trị cơ sở dữ liệu PostgreSQL. Việc thiết kế được thực hiện theo các nguyên tắc:

-   Đảm bảo tính toàn vẹn dữ liệu thông qua khóa chính (PRIMARY KEY), khóa ngoại (FOREIGN KEY) và các ràng buộc (CONSTRAINT).
-   Hạn chế tối đa trùng lặp thông tin bằng cách chuẩn hóa dữ liệu (tối thiểu ở mức 3NF).
-   Dễ dàng mở rộng để phục vụ các nghiệp vụ nâng cao như: Chơi game ở chế độ hai người, phân tích dữ liệu học tập chuyên sâu.

Các thực thể trong hệ thống bao gồm: Users, Roles, Tokens, Vocab, Topics, Types, UserVocabProgress, Games, GameSessions, GameSessionDetails, UserGameSettings, ActionLogs, Notifications, ChatMessages.

### 1.2.1. Các bảng dữ liệu chính

Hệ thống bao gồm các bảng dữ liệu sau:

-   **Bảng users:** Lưu trữ thông tin tài khoản người dùng, chi tiết hồ sơ và thống kê học tập. Các trường quan trọng như: `id` (UUID), `email` (đăng nhập), `password` (mã hóa), `name` (hiển thị), `avatar` (URL), `current_streak` (chuỗi ngày học), `current_level` (trình độ CEFR), `activated` (trạng thái kích hoạt).
-   **Bảng roles:** Định nghĩa các vai trò người dùng để phân quyền. Các trường quan trọng như: `id` (Long), `name` (tên vai trò: ADMIN, USER), `description` (mô tả).
-   **Bảng user_roles:** Bảng trung gian liên kết giữa Users và Roles. Các trường quan trọng như: `user_id` (FK), `role_id` (FK).
-   **Bảng tokens:** Lưu trữ Refresh Token để hỗ trợ cơ chế xác thực JWT và quản lý phiên đăng nhập. Các trường quan trọng như: `id` (UUID), `user_id` (FK), `token` (Access Token), `refresh_token` (Refresh Token), `expired` (hết hạn), `revoked` (thu hồi).
-   **Bảng vocab:** Lưu trữ từ vựng tiếng Anh cùng các thông tin chi tiết. Các trường quan trọng như: `id` (UUID), `word` (từ vựng), `meaning_vi` (nghĩa tiếng Việt), `transcription` (phiên âm), `example_sentence` (ví dụ), `img` (URL ảnh), `audio` (URL âm thanh), `cefr` (cấp độ), `topic_id` (FK).
-   **Bảng topics:** Quản lý các chủ đề từ vựng. Các trường quan trọng như: `id` (Long), `name` (tên chủ đề), `description` (mô tả), `img` (URL ảnh đại diện).
-   **Bảng types:** Định nghĩa các loại từ. Các trường quan trọng như: `id` (Long), `name` (Danh từ, Động từ...).
-   **Bảng vocab_types:** Bảng trung gian liên kết giữa Vocab và Types. Các trường quan trọng như: `vocab_id` (FK), `type_id` (FK).
-   **Bảng user_vocab_progress:** Lưu trữ tiến độ học tập của từng người dùng đối với từng từ vựng (theo thuật toán Spaced Repetition). Các trường quan trọng như: `id` (UUID), `user_id` (FK), `vocab_id` (FK), `status` (trạng thái: NEW, LEARNING...), `next_review_date` (ngày ôn tiếp theo), `interval_days` (khoảng cách ôn), `ef_factor` (hệ số dễ nhớ).
-   **Bảng games:** Định nghĩa các loại trò chơi có sẵn. Các trường quan trọng như: `id` (Long), `name` (tên game), `rules_json` (luật chơi).
-   **Bảng game_sessions:** Lưu trữ lịch sử các phiên chơi game của người dùng. Các trường quan trọng như: `id` (UUID), `user_id` (FK), `game_id` (FK), `started_at` (bắt đầu), `finished_at` (kết thúc), `score` (điểm số), `accuracy` (độ chính xác).
-   **Bảng game_session_details:** Lưu trữ chi tiết từng câu hỏi được trả lời trong một phiên chơi. Các trường quan trọng như: `id` (UUID), `session_id` (FK), `vocab_id` (FK), `is_correct` (đúng/sai), `time_taken` (thời gian trả lời).
-   **Bảng user_game_settings:** Lưu trữ cấu hình trò chơi riêng của từng người dùng. Các trường quan trọng như: `id` (UUID), `user_id` (FK), `quick_quiz_total_questions` (số câu hỏi), `quick_quiz_time_per_question` (thời gian mỗi câu).
-   **Bảng action_logs:** Nhật ký kiểm toán (Audit Log) cho các hoạt động quan trọng. Các trường quan trọng như: `id` (Long), `user_id` (FK), `action_type` (loại hành động), `resource_type` (loại tài nguyên), `status` (trạng thái).
-   **Bảng notifications:** Lưu trữ các thông báo hệ thống. Các trường quan trọng như: `id` (Long), `user_id` (FK), `title` (tiêu đề), `content` (nội dung), `is_read` (đã đọc).
-   **Bảng chat_messages:** Lưu trữ lịch sử tương tác giữa người dùng và AI Chatbot. Các trường quan trọng như: `id` (UUID), `session_id` (phiên chat), `user_id` (FK), `role` (người gửi), `content` (nội dung).

### 1.2.2. Mối liên hệ giữa các bảng

Các bảng trong cơ sở dữ liệu được liên kết chặt chẽ với nhau để hỗ trợ các nghiệp vụ của hệ thống:

-   Quan hệ giữa Người dùng và Vai trò:

    -   `Users` - `Roles`: Một người dùng có thể đảm nhận nhiều vai trò (ví dụ: vừa là User vừa là Admin), và một vai trò có thể được gán cho nhiều người dùng → Quan hệ Nhiều - Nhiều (N-N) thông qua bảng trung gian `user_roles`.

-   Quan hệ giữa Người dùng và Token:

    -   `Users` - `Tokens`: Một người dùng có thể sở hữu nhiều token (đăng nhập trên nhiều thiết bị khác nhau), mỗi token chỉ thuộc về một người dùng duy nhất → Quan hệ Một - Nhiều (1-N) thông qua khóa ngoại `user_id`.

-   Quan hệ giữa Từ vựng và Chủ đề:

    -   `Topics` - `Vocab`: Một chủ đề chứa nhiều từ vựng, mỗi từ vựng thuộc về một chủ đề nhất định → Quan hệ Một - Nhiều (1-N) thông qua khóa ngoại `topic_id`.

-   Quan hệ giữa Từ vựng và Loại từ:

    -   `Vocab` - `Types`: Một từ vựng có thể thuộc nhiều loại từ (ví dụ: "run" vừa là danh từ vừa là động từ), và một loại từ bao gồm nhiều từ vựng → Quan hệ Nhiều - Nhiều (N-N) thông qua bảng trung gian `vocab_types`.

-   Quan hệ giữa Người dùng và Tiến độ học tập (Spaced Repetition):

    -   `Users` - `Vocab`: Một người dùng học nhiều từ vựng, và một từ vựng được học bởi nhiều người dùng. Để lưu trữ trạng thái học tập riêng biệt (như ngày ôn tập, mức độ ghi nhớ) cho từng người dùng với từng từ → Quan hệ Nhiều - Nhiều (N-N) được thực hiện thông qua bảng trung gian `user_vocab_progress`.

-   Quan hệ giữa Người dùng và Phiên chơi game:

    -   `Users` - `GameSessions`: Một người dùng có thể tham gia nhiều phiên chơi game khác nhau, mỗi phiên chơi thuộc về một người dùng → Quan hệ Một - Nhiều (1-N) thông qua khóa ngoại `user_id`.

-   Quan hệ giữa Trò chơi và Phiên chơi game:

    -   `Games` - `GameSessions`: Một loại trò chơi (ví dụ: Quick Quiz) có thể có nhiều phiên chơi được tạo ra, mỗi phiên chơi thuộc về một loại trò chơi cụ thể → Quan hệ Một - Nhiều (1-N) thông qua khóa ngoại `game_id`.

-   Quan hệ giữa Phiên chơi game và Chi tiết phiên chơi:

    -   `GameSessions` - `GameSessionDetails`: Một phiên chơi bao gồm nhiều câu hỏi/lượt trả lời chi tiết, mỗi chi tiết thuộc về một phiên chơi → Quan hệ Một - Nhiều (1-N) thông qua khóa ngoại `session_id`.

-   Quan hệ giữa Chi tiết phiên chơi và Từ vựng:

    -   `Vocab` - `GameSessionDetails`: Một từ vựng có thể xuất hiện trong nhiều lượt chơi khác nhau, mỗi lượt chơi chi tiết liên quan đến một từ vựng cụ thể → Quan hệ Một - Nhiều (1-N) thông qua khóa ngoại `vocab_id`.

-   Quan hệ giữa Người dùng và Cấu hình game:

    -   `Users` - `UserGameSettings`: Mỗi người dùng có một bộ cấu hình game riêng biệt (thời gian, số câu hỏi), mỗi bộ cấu hình thuộc về một người dùng → Quan hệ Một - Một (1-1) thông qua khóa ngoại `user_id`.

-   Quan hệ giữa Người dùng và Thông báo:

    -   `Users` - `Notifications`: Một người dùng nhận được nhiều thông báo, mỗi thông báo thuộc về một người dùng → Quan hệ Một - Nhiều (1-N) thông qua khóa ngoại `user_id`.

-   Quan hệ giữa Người dùng và Tin nhắn Chat AI:
    -   `Users` - `ChatMessages`: Một người dùng có nhiều tin nhắn trao đổi với AI, mỗi tin nhắn thuộc về một người dùng → Quan hệ Một - Nhiều (1-N) thông qua khóa ngoại `user_id`.

### 1.2.3. Mô tả các bảng

#### 1.2.3.1. Bảng Users

Lưu trữ thông tin tài khoản người dùng, chi tiết hồ sơ và thống kê học tập.

| Tên trường           | Loại dữ liệu | Mô tả                                                        |
| -------------------- | ------------ | ------------------------------------------------------------ |
| id                   | UUID         | Khóa chính định danh người dùng.                             |
| email                | VARCHAR(100) | Địa chỉ email dùng để đăng nhập (Duy nhất).                  |
| password             | VARCHAR(255) | Mật khẩu đã được mã hóa.                                     |
| name                 | VARCHAR(100) | Họ và tên hiển thị của người dùng.                           |
| avatar               | VARCHAR(255) | URL ảnh đại diện (lưu trên Firebase).                        |
| gender               | VARCHAR(10)  | Giới tính người dùng.                                        |
| date_of_birth        | DATE         | Ngày sinh người dùng.                                        |
| current_level        | VARCHAR(5)   | Trình độ CEFR hiện tại (A1, A2, B1, B2, C1, C2).             |
| level_test_completed | BOOLEAN      | Đánh dấu người dùng đã hoàn thành bài kiểm tra đầu vào chưa. |
| activated            | BOOLEAN      | Trạng thái kích hoạt tài khoản.                              |
| banned               | BOOLEAN      | Trạng thái cấm tài khoản.                                    |
| current_streak       | INT          | Chuỗi ngày học liên tiếp hiện tại.                           |
| longest_streak       | INT          | Chuỗi ngày học dài nhất được ghi nhận.                       |
| total_study_days     | INT          | Tổng số ngày người dùng đã học.                              |
| last_activity_date   | DATE         | Ngày hoạt động gần nhất.                                     |

#### 1.2.3.2. Bảng Roles

Định nghĩa vai trò người dùng.

| Tên trường  | Loại dữ liệu | Mô tả                                       |
| ----------- | ------------ | ------------------------------------------- |
| id          | BIGINT       | Khóa chính.                                 |
| name        | VARCHAR(50)  | Tên vai trò (ví dụ: ROLE_USER, ROLE_ADMIN). |
| description | VARCHAR(255) | Mô tả chi tiết về vai trò.                  |

#### 1.2.3.3. Bảng User_Roles

Bảng trung gian phân quyền.

| Tên trường | Loại dữ liệu | Mô tả                               |
| ---------- | ------------ | ----------------------------------- |
| user_id    | UUID         | Khóa ngoại liên kết với bảng Users. |
| role_id    | BIGINT       | Khóa ngoại liên kết với bảng Roles. |

#### 1.2.3.4. Bảng Tokens

Quản lý Refresh Token.

| Tên trường    | Loại dữ liệu | Mô tả                               |
| ------------- | ------------ | ----------------------------------- |
| id            | UUID         | Khóa chính.                         |
| user_id       | UUID         | Khóa ngoại liên kết với bảng Users. |
| token         | VARCHAR(500) | Access Token (Duy nhất).            |
| refresh_token | VARCHAR(500) | Refresh Token (Duy nhất).           |
| expired       | BOOLEAN      | Trạng thái hết hạn của token.       |
| revoked       | BOOLEAN      | Trạng thái bị thu hồi của token.    |

#### 1.2.3.5. Bảng Vocab

Lưu trữ từ vựng và nội dung liên quan.

| Tên trường       | Loại dữ liệu  | Mô tả                                 |
| ---------------- | ------------- | ------------------------------------- |
| id               | UUID          | Khóa chính định danh từ vựng.         |
| word             | VARCHAR(100)  | Từ tiếng Anh (Duy nhất).              |
| transcription    | VARCHAR(100)  | Phiên âm IPA.                         |
| meaning_vi       | VARCHAR(500)  | Nghĩa tiếng Việt.                     |
| interpret        | VARCHAR(1000) | Giải thích/Định nghĩa bằng tiếng Anh. |
| example_sentence | VARCHAR(1000) | Câu ví dụ minh họa cách dùng.         |
| cefr             | VARCHAR(10)   | Cấp độ CEFR của từ (A1-C2).           |
| img              | VARCHAR(500)  | URL hình ảnh minh họa (Firebase).     |
| audio            | VARCHAR(500)  | URL file phát âm (Firebase).          |
| topic_id         | BIGINT        | Khóa ngoại liên kết với bảng Topics.  |

#### 1.2.3.6. Bảng Topics

Quản lý chủ đề từ vựng.

| Tên trường  | Loại dữ liệu  | Mô tả                         |
| ----------- | ------------- | ----------------------------- |
| id          | BIGINT        | Khóa chính (Tự tăng).         |
| name        | VARCHAR(100)  | Tên chủ đề (Duy nhất).        |
| description | VARCHAR(500)  | Mô tả ngắn về chủ đề.         |
| img         | VARCHAR(1000) | URL hình ảnh đại diện chủ đề. |

#### 1.2.3.7. Bảng Types

Định nghĩa loại từ.

| Tên trường | Loại dữ liệu | Mô tả                                   |
| ---------- | ------------ | --------------------------------------- |
| id         | BIGINT       | Khóa chính.                             |
| name       | VARCHAR(50)  | Tên loại từ (Noun, Verb, Adjective...). |

#### 1.2.3.8. Bảng Vocab_Types

Phân loại từ vựng.

| Tên trường | Loại dữ liệu | Mô tả                               |
| ---------- | ------------ | ----------------------------------- |
| vocab_id   | UUID         | Khóa ngoại liên kết với bảng Vocab. |
| type_id    | BIGINT       | Khóa ngoại liên kết với bảng Types. |

#### 1.2.3.9. Bảng UserVocabProgress

Theo dõi tiến độ học tập (SRS).

| Tên trường       | Loại dữ liệu | Mô tả                                         |
| ---------------- | ------------ | --------------------------------------------- |
| id               | UUID         | Khóa chính.                                   |
| user_id          | UUID         | Khóa ngoại liên kết với bảng Users.           |
| vocab_id         | UUID         | Khóa ngoại liên kết với bảng Vocab.           |
| status           | VARCHAR(50)  | Trạng thái (NEW, LEARNING, REVIEW, MASTERED). |
| last_reviewed    | DATE         | Ngày từ được ôn tập lần cuối.                 |
| next_review_date | DATE         | Ngày cần ôn tập tiếp theo.                    |
| interval_days    | INT          | Khoảng cách ngày giữa các lần ôn.             |
| ef_factor        | DOUBLE       | Hệ số dễ nhớ (Easiness Factor - SM2).         |
| repetition       | INT          | Số lần ôn tập đúng liên tiếp.                 |
| times_correct    | INT          | Tổng số lần trả lời đúng.                     |
| times_wrong      | INT          | Tổng số lần trả lời sai.                      |

#### 1.2.3.10. Bảng Games

Danh sách các trò chơi.

| Tên trường  | Loại dữ liệu | Mô tả                                        |
| ----------- | ------------ | -------------------------------------------- |
| id          | BIGINT       | Khóa chính.                                  |
| name        | VARCHAR(100) | Tên trò chơi (Duy nhất).                     |
| description | VARCHAR(500) | Mô tả trò chơi.                              |
| rules_json  | TEXT         | Chuỗi JSON định nghĩa luật chơi và cấu hình. |

#### 1.2.3.11. Bảng GameSessions

Lịch sử phiên chơi game.

| Tên trường      | Loại dữ liệu | Mô tả                                           |
| --------------- | ------------ | ----------------------------------------------- |
| id              | UUID         | Khóa chính phiên chơi.                          |
| user_id         | UUID         | Khóa ngoại liên kết với bảng Users.             |
| game_id         | BIGINT       | Khóa ngoại liên kết với bảng Games.             |
| topic_id        | BIGINT       | Khóa ngoại liên kết với bảng Topics (Tùy chọn). |
| started_at      | DATETIME     | Thời gian bắt đầu.                              |
| finished_at     | DATETIME     | Thời gian kết thúc.                             |
| score           | INT          | Điểm số đạt được.                               |
| correct_count   | INT          | Số câu trả lời đúng.                            |
| total_questions | INT          | Tổng số câu hỏi đã làm.                         |
| accuracy        | DOUBLE       | Độ chính xác (%).                               |
| duration        | INT          | Thời lượng chơi (giây).                         |

#### 1.2.3.12. Bảng GameSessionDetails

Chi tiết từng câu hỏi trong phiên chơi.

| Tên trường | Loại dữ liệu | Mô tả                                      |
| ---------- | ------------ | ------------------------------------------ |
| id         | UUID         | Khóa chính.                                |
| session_id | UUID         | Khóa ngoại liên kết với bảng GameSessions. |
| vocab_id   | UUID         | Khóa ngoại liên kết với bảng Vocab.        |
| is_correct | BOOLEAN      | Kết quả trả lời (Đúng/Sai).                |
| time_taken | INT          | Thời gian trả lời (ms hoặc giây).          |

#### 1.2.3.13. Bảng UserGameSettings

Cấu hình game cá nhân.

| Tên trường                   | Loại dữ liệu | Mô tả                                 |
| ---------------------------- | ------------ | ------------------------------------- |
| id                           | UUID         | Khóa chính.                           |
| user_id                      | UUID         | Khóa ngoại liên kết với bảng Users.   |
| quick_quiz_total_questions   | INT          | Số câu hỏi cho Quick Quiz.            |
| quick_quiz_time_per_question | INT          | Thời gian cho mỗi câu hỏi Quick Quiz. |
| image_word_total_pairs       | INT          | Số cặp hình-từ cho game Ghép hình.    |
| word_definition_total_pairs  | INT          | Số cặp từ-nghĩa cho game Ghép nghĩa.  |

#### 1.2.3.14. Bảng ActionLogs

Nhật ký hoạt động hệ thống.

| Tên trường    | Loại dữ liệu | Mô tả                                    |
| ------------- | ------------ | ---------------------------------------- |
| id            | BIGINT       | Khóa chính.                              |
| user_id       | UUID         | ID người dùng thực hiện hành động.       |
| action_type   | VARCHAR(50)  | Loại hành động (LOGIN, CREATE_VOCAB...). |
| resource_type | VARCHAR(50)  | Loại tài nguyên bị ảnh hưởng.            |
| resource_id   | VARCHAR(100) | ID tài nguyên bị ảnh hưởng.              |
| status        | VARCHAR(20)  | Kết quả (SUCCESS, FAILED).               |
| ip_address    | VARCHAR(50)  | Địa chỉ IP của client.                   |

#### 1.2.3.15. Bảng Notifications

Thông báo người dùng.

| Tên trường | Loại dữ liệu | Mô tả                               |
| ---------- | ------------ | ----------------------------------- |
| id         | BIGINT       | Khóa chính.                         |
| user_id    | UUID         | Khóa ngoại liên kết với bảng Users. |
| title      | VARCHAR(255) | Tiêu đề thông báo.                  |
| content    | TEXT         | Nội dung thông báo.                 |
| type       | VARCHAR(50)  | Loại thông báo.                     |
| is_read    | BOOLEAN      | Trạng thái đã đọc.                  |

#### 1.2.3.16. Bảng ChatMessages

Lịch sử chat với AI.

| Tên trường  | Loại dữ liệu | Mô tả                                |
| ----------- | ------------ | ------------------------------------ |
| id          | UUID         | Khóa chính.                          |
| session_id  | UUID         | Định danh phiên chat.                |
| user_id     | UUID         | Khóa ngoại liên kết với bảng Users.  |
| role        | VARCHAR(10)  | Người gửi (USER, ASSISTANT, SYSTEM). |
| content     | TEXT         | Nội dung tin nhắn.                   |
| tokens_used | INT          | Số token sử dụng.                    |

### 1.2.4. Lựa chọn cơ sở dữ liệu

#### 1.2.4.1. PostgreSQL

PostgreSQL được sử dụng làm kho lưu trữ chính để đảm bảo tính toàn vẹn dữ liệu, quản lý các mối quan hệ phức tạp giữa người dùng, từ vựng và lịch sử học tập.

**Các nhóm bảng chính:**
– **Quản lý Người dùng & Phân quyền:**

-   `users`: Lưu thông tin định danh (UUID, email, password hash, name, avatar, current_streak).
-   `roles`: Định nghĩa vai trò (ADMIN, USER).
-   `user_roles`: Bảng trung gian phân quyền.
-   `tokens`: Quản lý Refresh Token cho cơ chế xác thực JWT.

– **Quản lý Nội dung Học tập (Core Domain):**

-   `vocab`: Bảng trung tâm lưu từ vựng (word, meaning, transcription, image_url, audio_url).
-   `topics`: Chủ đề từ vựng (VD: Animals, Travel).
-   `types`: Loại từ (Noun, Verb, Adjective).
-   `vocab_types`: Quan hệ n-n giữa từ và loại từ.

– **Hệ thống Theo dõi Học tập (SRS & Progress):**

-   `user_vocab_progress`: Bảng quan trọng nhất để theo dõi tiến độ học từng từ của mỗi user.
    -   `status`: Trạng thái (NEW, LEARNING, REVIEW, MASTERED).
    -   `next_review_date`: Ngày cần ôn tập tiếp theo (tính theo thuật toán SRS).
    -   `interval_days`: Khoảng cách giữa các lần ôn.
    -   `ef_factor`: Hệ số dễ nhớ (Easiness Factor) của thuật toán SM-2.
    -   `streak`: Chuỗi đúng liên tiếp cho từ này.

– **Hệ thống Game:**

-   `games`: Định nghĩa loại game (Quick Quiz, Image Word Matching, Word Definition Matching).
-   `game_sessions`: Lưu phiên chơi (start_time, end_time, score, …).
-   `game_session_details`: Chi tiết từng câu trả lời trong phiên (câu đúng/sai, thời gian trả lời, …).

#### 1.2.4.2. Redis

Redis được sử dụng như một lớp bộ nhớ đệm tốc độ cao (In-memory Data Store) để giảm tải cho PostgreSQL và xử lý các tác vụ yêu cầu độ trễ thấp.

**Chiến lược sử dụng Redis:**

1. **Game Session State (Trạng thái phiên chơi):**
    - Lưu trữ tạm thời dữ liệu của phiên game đang diễn ra (câu hỏi hiện tại, danh sách từ vựng trong game, điểm số tạm thời).
    - Lợi ích: Giúp việc validate câu trả lời và tính điểm diễn ra tức thì, ngăn chặn gian lận (anti-cheat) bằng cách đối chiếu timestamp server-side.
    - TTL (Time-to-live): 30 phút.
2. **Data Caching (Bộ nhớ đệm dữ liệu):**
    - Cache thông tin từ vựng (vocab), chủ đề (topics) để giảm query xuống DB khi người dùng duyệt bài học.
    - Cache bảng xếp hạng (Leaderboard) để không phải tính toán lại liên tục.
    - TTL: 24 giờ cho từ vựng, 5 phút cho leaderboard.
3. **Rate Limiting & Security:**
    - Lưu trữ Blacklist Token khi user đăng xuất.
    - Giới hạn tần suất request (Rate Limiting) để chống spam API.

#### 1.2.4.3. Firebase

Firebase Storage được tích hợp để lưu trữ các tệp tin đa phương tiện (Blob storage), giúp giảm tải dung lượng cho server chính và tận dụng mạng lưới phân phối nội dung (CDN) của Google.
– **Hình ảnh (Images):** Lưu ảnh minh họa cho từ vựng và avatar người dùng.
– **Âm thanh (Audio):** Lưu file phát âm chuẩn của từ vựng.
– **Cơ chế:** Backend lưu URL (đường dẫn) trỏ đến file trên Firebase vào bảng vocab, user, topic trong PostgreSQL.

## 1.3. Thuật toán

### 1.3.1. Cơ sở lý thuyết

#### 1.3.1.1. Đường cong quên lãng

Thuật toán học tập mà nhóm lựa chọn giành cho chức năng ôn tập dựa trên nghiên cứu về trí nhớ của nhà tâm lý học người Đức Hermann Ebbinghaus. Từ những thứ nghiệm về trí nhớ của mình, ông rút ra được kết luận về khả năng ghi nhớ của con người và thời gian ôn tập, con người giảm dần khả năng ghi nhớ khi không có sự ôn tập trong một khoảng thời gian dài. Từ đó khái niệm về đường cong quên lãng được ra đời với 5 kết luận đáng chú ý sau:
– **Cảm xúc và sự ghi nhớ:** Cảm xúc tại thời điểm tiếp nhận thông tin ảnh hưởng tỷ lệ thuận đến khả năng lưu trữ ký ức.
– **Tốc độ quên:** Sự quên lãng diễn ra mạnh mẽ nhất ngay sau khi vừa tiếp nhận thông tin.
– **Ý nghĩa của thông tin:** Những thông tin có tính liên kết, logic hoặc ý nghĩa cụ thể sẽ được ghi nhớ lâu hơn các dữ liệu ngẫu nhiên.
– **Cách trình bày:** Phương thức hiển thị kiến thức (trực quan, sinh động) tác động lớn đến hiệu suất ghi nhớ.
– **Tính tất yếu:** Thông tin chắc chắn sẽ bị phai mờ dần theo thời gian nếu không có tác động ôn tập.

#### 1.3.1.2. Thuật toán SM-2 (SuperMemo)

Thuật toán SM-2 được phát triển bởi Piotr Woźniak vào cuối thập niên 80, là phiên bản cải tiến thứ hai của phương pháp SuperMemo. Đây được coi là thuật toán nền tảng cho hầu hết các hệ thống lặp lại ngắt quãng (Spaced Repetition System - SRS) hiện đại trên máy tính và thiết bị di động. Mục tiêu của SM-2 là tính toán khoảng thời gian tối ưu để người dùng ôn tập lại một đơn vị kiến thức (thẻ từ vựng) ngay trước khi họ sắp quên nó.

### 1.3.2. Triển khai thuật toán

#### 1.3.2.1. Thuật toán Learn Vocab (Học từ mới)

Hệ thống ưu tiên hiển thị các từ vựng theo thứ tự sau để tối ưu hóa quá trình học:

1.  **Từ đang học dở (In-Progress):** Lấy các từ trong bảng `UserVocabProgress` có trạng thái là `NEW` hoặc `UNKNOWN` (đã học nhưng chưa thuộc).
2.  **Từ mới hoàn toàn (New Words):** Nếu số lượng từ đang học chưa đủ hạn mức phiên học, hệ thống sẽ lấy thêm từ vựng từ bảng `Vocab` mà chưa tồn tại trong `UserVocabProgress` của người dùng.

Khi người dùng bắt đầu học một từ mới:

-   Hệ thống khởi tạo bản ghi `UserVocabProgress` với:
    -   `status`: LEARNING (hoặc UNKNOWN nếu chọn "Chưa thuộc")
    -   `ef_factor`: 2.5
    -   `interval_days`: 1
    -   `repetition`: 0

#### 1.3.2.2. Thuật toán Review (Ôn tập - SM-2)

Hệ thống áp dụng biến thể của thuật toán SM-2 (SuperMemo 2) để tính toán thời điểm ôn tập tối ưu.

**Công thức tính toán:**

1.  **Cập nhật Hệ số dễ nhớ (Easiness Factor - EF):**
    $$EF' = EF + (0.1 - (5 - q) \times (0.08 + (5 - q) \times 0.02))$$

    -   Trong đó $q$ là chất lượng câu trả lời (thang điểm 0-5):
        -   5: Trả lời hoàn hảo, không do dự.
        -   4: Trả lời đúng nhưng có chút do dự.
        -   3: Trả lời đúng nhưng rất khó khăn.
        -   0-2: Trả lời sai hoặc quên.
    -   $EF'$ không được nhỏ hơn 1.3.

2.  **Tính khoảng cách ngày ôn tập (Interval - I):**
    -   Nếu $n = 1$ (lần đúng đầu tiên): $I(1) = 1$ ngày.
    -   Nếu $n = 2$ (lần đúng thứ hai): $I(2) = 6$ ngày.
    -   Nếu $n > 2$: $I(n) = I(n-1) \times EF$.

**Ví dụ minh họa:**

-   **Ngày 1:** Người dùng học từ "Apple". Trả lời đúng (q=5).
    -   $n = 1 \rightarrow I = 1$ ngày.
    -   $EF$ giữ nguyên 2.5.
    -   Lịch ôn tiếp theo: Ngày 2.
-   **Ngày 2:** Ôn lại "Apple". Trả lời đúng nhưng hơi chậm (q=4).
    -   $n = 2 \rightarrow I = 6$ ngày.
    -   $EF$ mới = $2.5 + (0.1 - (5-4) \times (0.08 + (5-4) \times 0.02)) = 2.5$.
    -   Lịch ôn tiếp theo: Ngày 8 (2 + 6).
-   **Ngày 8:** Ôn lại "Apple". Trả lời rất tốt (q=5).
    -   $n = 3 \rightarrow I = 6 \times 2.5 = 15$ ngày.
    -   $EF$ mới = $2.5 + 0.1 = 2.6$.
    -   Lịch ôn tiếp theo: Ngày 23 (8 + 15).

#### 1.3.2.3. Thuật toán Quick Reflex Quiz

-   **Mục tiêu:** Chọn nghĩa đúng càng nhanh càng tốt.
-   **Công thức tính điểm:**
    $$Score = BasePoints + StreakBonus + SpeedBonus$$
    -   $BasePoints = 10$ (Điểm cơ bản cho mỗi câu đúng).
    -   $StreakBonus = 5 \times \lfloor \frac{CurrentStreak}{3} \rfloor$ (Cứ mỗi chuỗi 3 câu đúng liên tiếp được cộng thêm 5 điểm).
    -   $SpeedBonus = 5$ nếu $TimeTaken < 1500ms$ (1.5 giây).

**Ví dụ minh họa:**

-   Người dùng đang có chuỗi đúng (Streak) là 7.
-   Trả lời câu hỏi tiếp theo đúng trong vòng 1.2 giây.
-   **Tính điểm:**
    -   $BasePoints = 10$.
    -   $StreakBonus = 5 \times \lfloor 7/3 \rfloor = 5 \times 2 = 10$.
    -   $SpeedBonus = 5$ (do 1.2s < 1.5s).
    -   **Tổng điểm câu này:** $10 + 10 + 5 = 25$ điểm.

#### 1.3.2.4. Thuật toán Image-Word Matching & Word-Definition Matching

-   **Mục tiêu:** Ghép cặp chính xác trong thời gian ngắn nhất.
-   **Công thức tính điểm:**
    $$TotalScore = \max(0, CEFRScore + TimeBonus - WrongPenalty)$$
    1.  **CEFRScore (Điểm độ khó):** Tổng điểm của các từ ghép đúng dựa trên cấp độ CEFR.
        -   A1 = 1, A2 = 2, B1 = 3, B2 = 4, C1 = 5, C2 = 6.
    2.  **TimeBonus (Thưởng thời gian):** Tính theo phần trăm của $CEFRScore$ dựa trên tổng thời gian hoàn thành ($T$).
        -   $T < 10s$: $+50\%$.
        -   $10s \le T < 20s$: $+30\%$.
        -   $20s \le T < 30s$: $+20\%$.
        -   $30s \le T < 60s$: $+10\%$.
        -   $T \ge 60s$: $0\%$.
    3.  **WrongPenalty (Phạt sai):** $WrongAttempts \times 2$.

**Ví dụ minh họa:**

-   Người chơi ghép 3 cặp từ: "Cat" (A1), "Beautiful" (A2), "Serendipity" (C2).
-   Tổng thời gian: 15 giây.
-   Số lần ghép sai: 1 lần.
-   **Tính toán:**
    -   $CEFRScore = 1 (A1) + 2 (A2) + 6 (C2) = 9$ điểm.
    -   $TimeBonus$: Vì 15s nằm trong khoảng [10s, 20s) nên thưởng 30%.
        -   $Bonus = 9 \times 30\% = 2.7 \approx 3$ điểm (làm tròn).
    -   $WrongPenalty = 1 \times 2 = 2$ điểm.
    -   **Tổng điểm:** $9 + 3 - 2 = 10$ điểm.

#### 1.3.2.5. Thuật toán Gợi ý Từ vựng (AI Recommendation)

Sử dụng mô hình **XGBoost** để dự đoán xác suất người dùng quên một từ vựng ($P_{forget}$).

-   **Đầu vào (9 Features):**
    1.  `times_correct`: Số lần trả lời đúng.
    2.  `times_wrong`: Số lần trả lời sai.
    3.  `accuracy_rate`: Tỷ lệ chính xác (đúng / tổng số lần).
    4.  `days_since_last_review`: Số ngày kể từ lần ôn tập cuối.
    5.  `days_until_next_review`: Số ngày còn lại đến lần ôn tiếp theo (âm nếu quá hạn).
    6.  `interval_days`: Khoảng cách ôn tập hiện tại (SM-2).
    7.  `repetition`: Số lần lặp lại liên tiếp.
    8.  `ef_factor`: Hệ số dễ nhớ hiện tại.
    9.  `status_encoded`: Trạng thái từ vựng được mã hóa số (NEW=0, UNKNOWN=1, KNOWN=2, MASTERED=3).
-   **Đầu ra:** Xác suất quên ($0 \le P \le 1$).
-   **Quyết định:** Nếu $P_{forget} > Threshold$ (ví dụ 0.7), hệ thống sẽ đề xuất từ này vào danh sách "Cần ôn tập gấp".

#### 1.3.2.6. Thuật toán tính Chuỗi (Streak)

Hệ thống tính toán chuỗi ngày học liên tục dựa trên lịch sử hoạt động trong bảng `UserVocabProgress`.

**Nguyên tắc:**

-   Dựa vào trường `created_at` của `UserVocabProgress` để xác định các ngày có hoạt động học tập.
-   Một ngày được tính là "Active" nếu có ít nhất một từ vựng được tạo mới hoặc ôn tập trong ngày đó.

**Quy trình tính toán:**

1.  **Thu thập dữ liệu:** Lấy danh sách tất cả các ngày duy nhất (`unique_dates`) từ lịch sử học tập của người dùng.
2.  **Sắp xếp:** Sắp xếp `unique_dates` theo thứ tự giảm dần (từ mới nhất đến cũ nhất).
3.  **Tính Current Streak (Chuỗi hiện tại):**
    -   Bắt đầu từ ngày gần nhất (`last_activity_date`).
    -   Kiểm tra liên tục lùi về quá khứ.
    -   Nếu ngày $T$ có hoạt động và ngày $T-1$ cũng có hoạt động $\rightarrow$ Streak + 1.
    -   Dừng lại khi gặp ngày ngắt quãng.
4.  **Tính Longest Streak (Chuỗi dài nhất):**
    -   Duyệt qua toàn bộ danh sách `unique_dates`.
    -   Tìm khoảng thời gian liên tục dài nhất trong lịch sử.

**Trạng thái Streak:**

-   **ACTIVE:** Đã học hôm nay.
-   **PENDING:** Chưa học hôm nay, cần học để duy trì chuỗi.
-   **BROKEN:** Đã bỏ lỡ ngày hôm qua, chuỗi bị reset về 0.

#### 1.3.2.7. Thuật toán Đồng bộ Dữ liệu Offline (Offline Sync)

-   **Mục tiêu:** Đảm bảo tính nhất quán dữ liệu khi người dùng học tập không có kết nối mạng.
-   **Cơ chế:** Batch Processing (Xử lý theo lô) thông qua API `/api/v1/sync/batch`.

**Cấu trúc dữ liệu (DTO):**

-   `BatchSyncRequest`: Gói dữ liệu tổng hợp chứa danh sách `gameSessions`, `gameSessionDetails`, và `vocabProgress`.
-   `OfflineGameSessionRequest`: Thông tin phiên chơi (Game ID, thời gian bắt đầu/kết thúc, `clientSessionId`).
-   `OfflineGameDetailRequest`: Chi tiết từng câu trả lời, chứa `clientSessionId` để tham chiếu ngược lại phiên chơi tương ứng.

**Chi tiết triển khai (Implementation Logic):**

1.  **Bước 1: Lưu Game Sessions (Master Data)**

    -   Server nhận danh sách sessions từ request.
    -   Lưu từng session vào database.
    -   Tạo một `Map<String, GameSession>` để ánh xạ giữa `clientSessionId` (UUID do client sinh ra offline) và `GameSession` entity (đã lưu vào DB).

2.  **Bước 2: Xử lý Game Details & Auto-Update Progress**

    -   Duyệt qua danh sách `gameSessionDetails`.
    -   Sử dụng `clientSessionId` trong mỗi detail để tìm `GameSession` cha tương ứng từ Map ở Bước 1.
    -   Lưu chi tiết lượt chơi (`GameSessionDetail`) vào database.
    -   **Tính toán lại tiến độ (Auto-Update):** Dựa trên kết quả đúng/sai của từng detail, hệ thống gọi service `VocabProgressService` để cập nhật ngay lập tức `UserVocabProgress` (tăng `times_correct`/`times_wrong`, tính lại `status` và `next_review_date` theo thuật toán SM-2).

3.  **Bước 3: Đồng bộ Vocab Progress thủ công (Merge Strategy)**
    -   Xử lý danh sách `vocabProgress` (các cập nhật tiến độ không qua game).
    -   **Chiến lược hợp nhất:**
        -   Nếu server chưa có record: Tạo mới.
        -   Nếu server đã có: Thực hiện cộng dồn các chỉ số tích lũy (như `times_correct`, `times_wrong`) và cập nhật trạng thái nếu dữ liệu từ client mới hơn (`last_updated` timestamp).

#### 1.3.2.8. Thuật toán AI Chatbot (RAG - Retrieval Augmented Generation)

-   **Mục tiêu:** Cung cấp hỗ trợ học tập thông minh, hiểu ngữ cảnh người dùng.
-   **Mô hình:** Gemini 2.5 Flash kết hợp kỹ thuật RAG.
-   **Quy trình xử lý:**
    1.  **Context Retrieval (Truy vấn ngữ cảnh):**
        -   Khi nhận câu hỏi, hệ thống truy vấn database để lấy thông tin liên quan: Từ vựng đang học, Topic đang quan tâm, Lịch sử học tập.
    2.  **Prompt Engineering:**
        -   Xây dựng prompt: `System Instruction` + `User Context` + `Chat History` + `User Question`.
    3.  **Generation (Sinh câu trả lời):**
        -   Gửi prompt đến Gemini API.
        -   Nhận phản hồi văn bản.
    4.  **Smart Suggestion (Gợi ý thông minh):**
        -   Phân tích câu trả lời để trích xuất các từ khóa.
        -   Tìm kiếm trong database các từ vựng (`Vocab`) hoặc chủ đề (`Topic`) khớp với từ khóa.
        -   Trả về danh sách gợi ý kèm theo câu trả lời để người dùng có thể học ngay.

## 1.4. Công nghệ sử dụng

### 1.4.1. Backend (Chi tiết)

Backend của hệ thống được xây dựng dựa trên nền tảng Java Spring Boot, tuân thủ kiến trúc Clean Architecture để đảm bảo tính tách biệt, dễ bảo trì và mở rộng.

#### 1.4.1.1. Core Framework & Language

-   **Java 17:** Ngôn ngữ lập trình chính, tận dụng các tính năng mới về hiệu năng và cú pháp (Records, Pattern Matching).
-   **Spring Boot 3.2.5:** Framework chủ đạo giúp khởi tạo, cấu hình và vận hành ứng dụng nhanh chóng. Sử dụng các module:
    -   `spring-boot-starter-web`: Xây dựng RESTful APIs.
    -   `spring-boot-starter-data-jpa`: Tương tác với cơ sở dữ liệu.
    -   `spring-boot-starter-security`: Bảo mật ứng dụng.
    -   `spring-boot-starter-websocket`: Hỗ trợ giao tiếp thời gian thực.
    -   `spring-boot-starter-data-redis`: Tương tác với Redis Cache.

#### 1.4.1.2. Database & Persistence

-   **PostgreSQL:** Hệ quản trị cơ sở dữ liệu quan hệ chính.
-   **Spring Data JPA (Hibernate):** ORM (Object-Relational Mapping) framework giúp ánh xạ các bảng database thành các Java Entity. Sử dụng `JpaRepository` để thực hiện các thao tác CRUD và truy vấn dữ liệu mà không cần viết SQL thủ công.
-   **Flyway (hoặc Hibernate DDL Auto):** Quản lý version và migration cho cơ sở dữ liệu.

#### 1.4.1.3. Caching & Session Management

-   **Redis:** In-memory data store hiệu năng cao.
    -   **Cache Manager:** Cấu hình Spring Cache để tự động cache các kết quả truy vấn nặng (như danh sách từ vựng, bảng xếp hạng).
    -   **Session Storage:** Lưu trữ thông tin phiên chơi game (Game Session) tạm thời để truy xuất nhanh và tự động hết hạn (TTL).

#### 1.4.1.4. Security & Authentication

-   **Spring Security:** Framework bảo mật mạnh mẽ.
    -   **JWT (JSON Web Token):** Cơ chế xác thực Stateless. Server cấp Access Token (ngắn hạn) và Refresh Token (dài hạn).
    -   **BCrypt:** Thuật toán băm mật khẩu an toàn.
    -   **CORS Configuration:** Cấu hình chia sẻ tài nguyên chéo nguồn để cho phép Client (Flutter/React) gọi API.

#### 1.4.1.5. Real-time Communication

-   **WebSocket (STOMP over SockJS):**
    -   Cung cấp kênh giao tiếp hai chiều liên tục giữa Client và Server.
    -   Sử dụng cho tính năng: Thông báo (Notification) đẩy từ server xuống client, cập nhật trạng thái game realtime (nếu có chế độ đối kháng).

#### 1.4.1.6. AI Service Integration

-   **FastAPI (Python Microservice):** Một service riêng biệt viết bằng Python để chạy các mô hình AI nặng.
    -   **XGBoost:** Thư viện Machine Learning dùng để huấn luyện và chạy mô hình gợi ý từ vựng (Recommendation System).
    -   **Giao tiếp:** Backend Java gọi sang Python Service thông qua REST API nội bộ.
-   **Google Gemini API:** Tích hợp trực tiếp vào Java Backend (hoặc qua Python Service) để cung cấp tính năng Chatbot thông minh, giải thích từ vựng theo ngữ cảnh.

#### 1.4.1.7. Deployment & DevOps

-   **Docker:** Đóng gói toàn bộ ứng dụng (Java Backend, Python Service, Database) vào các container.
-   **Docker Compose:** Orchestration tool để định nghĩa và chạy đa container (Backend, DB, Redis) cùng lúc với một lệnh duy nhất.
