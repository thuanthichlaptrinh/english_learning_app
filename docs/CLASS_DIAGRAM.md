# SƠ ĐỒ LỚP - HỆ THỐNG CARD WORDS

## 1. Sơ Đồ Lớp Mức Phân Tích (Analysis Class Diagram)

Sơ đồ mức phân tích tập trung vào các khái niệm nghiệp vụ chính, không chi tiết thuộc tính và phương thức.

```mermaid
classDiagram
    direction TB

    %% ========== CORE ENTITIES ==========
    class User {
        <<entity>>
        Người dùng hệ thống
    }

    class Role {
        <<entity>>
        Vai trò người dùng
    }

    class Topic {
        <<entity>>
        Chủ đề từ vựng
    }

    class Vocab {
        <<entity>>
        Từ vựng tiếng Anh
    }

    class Type {
        <<entity>>
        Loại từ (noun, verb...)
    }

    class Game {
        <<entity>>
        Trò chơi học từ
    }

    class GameSession {
        <<entity>>
        Phiên chơi game
    }

    class GameSessionDetail {
        <<entity>>
        Chi tiết câu trả lời
    }

    class UserVocabProgress {
        <<entity>>
        Tiến độ học từ
    }

    class Token {
        <<entity>>
        Token xác thực
    }

    class Notification {
        <<entity>>
        Thông báo
    }

    class ChatMessage {
        <<entity>>
        Tin nhắn chatbot
    }

    class ActionLog {
        <<entity>>
        Nhật ký hoạt động
    }

    class UserGameSetting {
        <<entity>>
        Cài đặt game của user
    }

    %% ========== RELATIONSHIPS ==========
    User "*" -- "*" Role : có vai trò
    User "1" -- "*" Token : sở hữu
    User "1" -- "*" GameSession : tham gia
    User "1" -- "*" UserVocabProgress : theo dõi
    User "1" -- "*" Notification : nhận
    User "1" -- "*" ChatMessage : gửi
    User "1" -- "1" UserGameSetting : cấu hình

    Topic "1" -- "*" Vocab : chứa
    Topic "1" -- "*" GameSession : thuộc về

    Vocab "*" -- "*" Type : thuộc loại
    Vocab "1" -- "*" UserVocabProgress : được theo dõi bởi
    Vocab "1" -- "*" GameSessionDetail : xuất hiện trong

    Game "1" -- "*" GameSession : có các phiên

    GameSession "1" -- "*" GameSessionDetail : bao gồm
```

---

## 2. Sơ Đồ Lớp Mức Thiết Kế (Design Class Diagram)

Sơ đồ mức thiết kế chi tiết với đầy đủ thuộc tính, kiểu dữ liệu và quan hệ.

### 2.1. Quản Lý Người Dùng & Phân Quyền

```mermaid
classDiagram
    direction TB

    class User {
        -id: UUID
        -name: String
        -email: String
        -password: String
        -avatar: String
        -gender: String
        -dateOfBirth: LocalDate
        -currentLevel: CEFRLevel
        -levelTestCompleted: Boolean
        -activated: Boolean
        -activationKey: String
        -activationExpiredDate: LocalDateTime
        -nextActivationTime: LocalDateTime
        -banned: Boolean
        -status: String
        -currentStreak: Integer
        -longestStreak: Integer
        -lastActivityDate: LocalDate
        -totalStudyDays: Integer
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
        +getAuthorities() Collection~GrantedAuthority~
        +getUsername() String
        +isAccountNonExpired() boolean
        +isAccountNonLocked() boolean
        +isCredentialsNonExpired() boolean
        +isEnabled() boolean
    }

    class Role {
        -id: Long
        -name: String
        -description: String
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class Token {
        -id: UUID
        -token: String
        -refreshToken: String
        -expired: Boolean
        -revoked: Boolean
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class CEFRLevel {
        <<enumeration>>
        A1
        A2
        B1
        B2
        C1
        C2
    }

    User "*" -- "*" Role : user_roles
    User "1" -- "*" Token : tokens
    Token "*" -- "1" User : user
    User --> CEFRLevel : currentLevel
```

### 2.2. Quản Lý Từ Vựng & Chủ Đề

```mermaid
classDiagram
    direction TB

    class Topic {
        -id: Long
        -name: String
        -description: String
        -img: String
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class Vocab {
        -id: UUID
        -word: String
        -transcription: String
        -meaningVi: String
        -interpret: String
        -exampleSentence: String
        -cefr: String
        -img: String
        -audio: String
        -credit: String
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class Type {
        -id: Long
        -name: String
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class UserVocabProgress {
        -id: UUID
        -status: VocabStatus
        -lastReviewed: LocalDate
        -timesCorrect: Integer
        -timesWrong: Integer
        -efFactor: Double
        -intervalDays: Integer
        -repetition: Integer
        -nextReviewDate: LocalDate
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class VocabStatus {
        <<enumeration>>
        NEW
        LEARNING
        REVIEW
        MASTERED
    }

    Topic "1" -- "*" Vocab : vocabs
    Vocab "*" -- "1" Topic : topic
    Vocab "*" -- "*" Type : vocab_types
    Vocab "1" -- "*" UserVocabProgress : userProgress
    UserVocabProgress "*" -- "1" Vocab : vocab
    UserVocabProgress "*" -- "1" User : user
    UserVocabProgress --> VocabStatus : status
```

### 2.3. Hệ Thống Game & Phiên Chơi

```mermaid
classDiagram
    direction TB

    class Game {
        -id: Long
        -name: String
        -description: String
        -rulesJson: String
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class GameSession {
        -id: UUID
        -startedAt: LocalDateTime
        -finishedAt: LocalDateTime
        -totalQuestions: Integer
        -correctCount: Integer
        -accuracy: Double
        -duration: Integer
        -score: Integer
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class GameSessionDetail {
        -id: UUID
        -isCorrect: Boolean
        -timeTaken: Integer
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class UserGameSetting {
        -id: UUID
        -quickQuizTotalQuestions: Integer
        -quickQuizTimePerQuestion: Integer
        -imageWordTotalPairs: Integer
        -wordDefinitionTotalPairs: Integer
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    Game "1" -- "*" GameSession : gameSessions
    GameSession "*" -- "1" Game : game
    GameSession "*" -- "1" User : user
    GameSession "*" -- "1" Topic : topic
    GameSession "1" -- "*" GameSessionDetail : details
    GameSessionDetail "*" -- "1" GameSession : session
    GameSessionDetail "*" -- "1" Vocab : vocab
    UserGameSetting "*" -- "1" User : user
```

### 2.4. Hệ Thống Thông Báo & Chat

```mermaid
classDiagram
    direction TB

    class Notification {
        -id: Long
        -title: String
        -content: String
        -type: String
        -isRead: Boolean
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class ChatMessage {
        -id: UUID
        -sessionId: UUID
        -role: MessageRole
        -content: String
        -contextUsed: String
        -tokensUsed: Integer
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class MessageRole {
        <<enumeration>>
        USER
        ASSISTANT
        SYSTEM
    }

    class ActionLog {
        -id: Long
        -userId: UUID
        -userEmail: String
        -userName: String
        -actionType: String
        -actionCategory: String
        -resourceType: String
        -resourceId: String
        -description: String
        -status: String
        -ipAddress: String
        -userAgent: String
        -metadata: String
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    Notification "*" -- "1" User : user
    ChatMessage "*" -- "1" User : user
    ChatMessage --> MessageRole : role
```

---

## 3. Sơ Đồ Lớp Tổng Hợp (Complete Design Class Diagram)

```mermaid
classDiagram
    direction TB

    %% ========== USER MANAGEMENT ==========
    class User {
        -id: UUID
        -name: String
        -email: String
        -password: String
        -avatar: String
        -gender: String
        -dateOfBirth: LocalDate
        -currentLevel: CEFRLevel
        -levelTestCompleted: Boolean
        -activated: Boolean
        -banned: Boolean
        -currentStreak: Integer
        -longestStreak: Integer
        -lastActivityDate: LocalDate
        -totalStudyDays: Integer
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class Role {
        -id: Long
        -name: String
        -description: String
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class Token {
        -id: UUID
        -token: String
        -refreshToken: String
        -expired: Boolean
        -revoked: Boolean
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    %% ========== VOCABULARY MANAGEMENT ==========
    class Topic {
        -id: Long
        -name: String
        -description: String
        -img: String
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class Vocab {
        -id: UUID
        -word: String
        -transcription: String
        -meaningVi: String
        -interpret: String
        -exampleSentence: String
        -cefr: String
        -img: String
        -audio: String
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class Type {
        -id: Long
        -name: String
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class UserVocabProgress {
        -id: UUID
        -status: VocabStatus
        -lastReviewed: LocalDate
        -timesCorrect: Integer
        -timesWrong: Integer
        -efFactor: Double
        -intervalDays: Integer
        -repetition: Integer
        -nextReviewDate: LocalDate
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    %% ========== GAME SYSTEM ==========
    class Game {
        -id: Long
        -name: String
        -description: String
        -rulesJson: String
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class GameSession {
        -id: UUID
        -startedAt: LocalDateTime
        -finishedAt: LocalDateTime
        -totalQuestions: Integer
        -correctCount: Integer
        -accuracy: Double
        -duration: Integer
        -score: Integer
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class GameSessionDetail {
        -id: UUID
        -isCorrect: Boolean
        -timeTaken: Integer
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class UserGameSetting {
        -id: UUID
        -quickQuizTotalQuestions: Integer
        -quickQuizTimePerQuestion: Integer
        -imageWordTotalPairs: Integer
        -wordDefinitionTotalPairs: Integer
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    %% ========== NOTIFICATION & LOGGING ==========
    class Notification {
        -id: Long
        -title: String
        -content: String
        -type: String
        -isRead: Boolean
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class ChatMessage {
        -id: UUID
        -sessionId: UUID
        -role: MessageRole
        -content: String
        -contextUsed: String
        -tokensUsed: Integer
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    class ActionLog {
        -id: Long
        -userId: UUID
        -userEmail: String
        -actionType: String
        -actionCategory: String
        -resourceType: String
        -description: String
        -status: String
        -ipAddress: String
        -createdAt: LocalDateTime
        -updatedAt: LocalDateTime
    }

    %% ========== RELATIONSHIPS ==========
    User "*" -- "*" Role : user_roles
    User "1" -- "*" Token
    User "1" -- "*" GameSession
    User "1" -- "*" UserVocabProgress
    User "1" -- "*" Notification
    User "1" -- "*" ChatMessage
    User "1" -- "*" UserGameSetting

    Topic "1" -- "*" Vocab
    Topic "1" -- "*" GameSession

    Vocab "*" -- "*" Type : vocab_types
    Vocab "1" -- "*" UserVocabProgress
    Vocab "1" -- "*" GameSessionDetail

    Game "1" -- "*" GameSession
    GameSession "1" -- "*" GameSessionDetail
```

---

## 4. Mô Tả Chi Tiết Các Lớp

### 4.1. Quản Lý Người Dùng

| Lớp     | Mô tả                                                | Kiểu ID |
| ------- | ---------------------------------------------------- | ------- |
| `User`  | Người dùng, implements UserDetails (Spring Security) | UUID    |
| `Role`  | Vai trò (ADMIN, USER)                                | Long    |
| `Token` | JWT Token và Refresh Token                           | UUID    |

### 4.2. Quản Lý Từ Vựng

| Lớp                 | Mô tả                                           | Kiểu ID |
| ------------------- | ----------------------------------------------- | ------- |
| `Topic`             | Chủ đề từ vựng (Food, Animals, Technology...)   | Long    |
| `Vocab`             | Từ vựng tiếng Anh với nghĩa, phiên âm, hình ảnh | UUID    |
| `Type`              | Loại từ (noun, verb, adjective...)              | Long    |
| `UserVocabProgress` | Tiến độ học từ của user (SM-2 algorithm)        | UUID    |

### 4.3. Hệ Thống Game

| Lớp                 | Mô tả                                           | Kiểu ID |
| ------------------- | ----------------------------------------------- | ------- |
| `Game`              | Định nghĩa game (Quick Quiz, Image Matching...) | Long    |
| `GameSession`       | Phiên chơi game của user                        | UUID    |
| `GameSessionDetail` | Chi tiết từng câu trả lời trong game            | UUID    |
| `UserGameSetting`   | Cài đặt game cá nhân hóa                        | UUID    |

### 4.4. Thông Báo & Logging

| Lớp            | Mô tả                      | Kiểu ID |
| -------------- | -------------------------- | ------- |
| `Notification` | Thông báo push cho user    | Long    |
| `ChatMessage`  | Tin nhắn chatbot AI        | UUID    |
| `ActionLog`    | Nhật ký hoạt động hệ thống | Long    |

---

## 5. Enumerations (Kiểu Liệt Kê)

```mermaid
classDiagram
    class CEFRLevel {
        <<enumeration>>
        A1 : Beginner
        A2 : Elementary
        B1 : Intermediate
        B2 : Upper Intermediate
        C1 : Advanced
        C2 : Proficient
    }

    class VocabStatus {
        <<enumeration>>
        NEW : Chưa học
        LEARNING : Đang học
        REVIEW : Cần ôn tập
        MASTERED : Đã thuộc
    }

    class MessageRole {
        <<enumeration>>
        USER : Tin nhắn từ người dùng
        ASSISTANT : Tin nhắn từ AI
        SYSTEM : Tin nhắn hệ thống
    }
```

---

## 6. Quan Hệ Giữa Các Lớp

### 6.1. Quan Hệ 1-N (One-to-Many)

| Lớp Cha     | Lớp Con           | Mô tả                               |
| ----------- | ----------------- | ----------------------------------- |
| User        | Token             | 1 user có nhiều token               |
| User        | GameSession       | 1 user có nhiều phiên game          |
| User        | UserVocabProgress | 1 user theo dõi nhiều từ            |
| User        | Notification      | 1 user nhận nhiều thông báo         |
| User        | ChatMessage       | 1 user gửi nhiều tin nhắn           |
| User        | UserGameSetting   | 1 user có nhiều cài đặt game        |
| Topic       | Vocab             | 1 topic chứa nhiều từ               |
| Topic       | GameSession       | 1 topic có nhiều phiên game         |
| Game        | GameSession       | 1 game có nhiều phiên               |
| GameSession | GameSessionDetail | 1 phiên có nhiều chi tiết           |
| Vocab       | UserVocabProgress | 1 từ được nhiều user theo dõi       |
| Vocab       | GameSessionDetail | 1 từ xuất hiện trong nhiều chi tiết |

### 6.2. Quan Hệ N-N (Many-to-Many)

| Lớp A | Lớp B | Bảng Trung Gian | Mô tả                                         |
| ----- | ----- | --------------- | --------------------------------------------- |
| User  | Role  | user_roles      | 1 user có nhiều role, 1 role thuộc nhiều user |
| Vocab | Type  | vocab_types     | 1 từ có nhiều loại, 1 loại có nhiều từ        |

---

## 7. Stereotypes Sử Dụng

| Stereotype        | Ý nghĩa                      |
| ----------------- | ---------------------------- |
| `<<entity>>`      | Lớp thực thể (domain object) |
| `<<abstract>>`    | Lớp trừu tượng               |
| `<<interface>>`   | Interface                    |
| `<<enumeration>>` | Kiểu liệt kê                 |

---

## 8. Tổng Kết

### Thống Kê Lớp

| Nhóm                   | Số lượng | Lớp                                                   |
| ---------------------- | -------- | ----------------------------------------------------- |
| User Management        | 3        | User, Role, Token                                     |
| Vocabulary             | 4        | Topic, Vocab, Type, UserVocabProgress                 |
| Game System            | 4        | Game, GameSession, GameSessionDetail, UserGameSetting |
| Notification & Logging | 3        | Notification, ChatMessage, ActionLog                  |
| Enumerations           | 3        | CEFRLevel, VocabStatus, MessageRole                   |
| **Tổng cộng**          | **17**   |                                                       |

### Đặc Điểm Thiết Kế

1. **Standalone Entities**: Mỗi entity là một lớp độc lập với đầy đủ thuộc tính (id, createdAt, updatedAt)
2. **Encapsulation**: Các thuộc tính private, getter/setter qua Lombok
3. **Quan hệ**: Sử dụng JPA annotations để định nghĩa quan hệ
4. **Indexing**: Đánh index cho các trường thường xuyên query
5. **Audit**: Tự động tracking createdAt, updatedAt với @CreationTimestamp và @UpdateTimestamp
6. **ID Generation**: UUID sử dụng GenerationType.UUID, Long sử dụng GenerationType.IDENTITY

---

_Tài liệu được tạo tự động từ source code domain layer_  
_Ngày tạo: 27/11/2025_
