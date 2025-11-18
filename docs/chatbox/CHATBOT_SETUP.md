# AI Chatbot with Gemini API - Setup Guide

## 🎯 Tính năng

Chatbot AI thông minh sử dụng **Gemini 2.5 Flash** với:

-   ✅ **FAQ System**: Trả lời nhanh câu hỏi thường gặp
-   ✅ **RAG (Retrieval-Augmented Generation)**: Tìm kiếm dữ liệu từ database
-   ✅ **Context-Aware**: Hiểu ngữ cảnh từ lịch sử hội thoại
-   ✅ **Smart Suggestions**: Đề xuất từ vựng và topics liên quan

## 🚀 Cài đặt

### 1. Thêm Gemini API Key

Thêm vào file `.env`:

```env
GEMINI_API_KEY=
```

### 2. Build project

```bash
cd card-words
mvn clean install
```

### 3. Run migration

Migration `V8__create_chat_messages_table.sql` sẽ tự động chạy khi start app.

### 4. Start application

```bash
mvn spring-boot:run
```

## 📡 API Endpoints

### 1. Chat với AI

**POST** `/api/v1/chatbot/chat`

**Headers:**

```
Authorization: Bearer {jwt_token}
Content-Type: application/json
```

**Request Body:**

```json
{
    "message": "Làm sao để học từ vựng hiệu quả?",
    "sessionId": null,
    "includeContext": true,
    "searchFaq": true
}
```

**Response:**

```json
{
    "code": 200,
    "message": "Chat processed successfully",
    "data": {
        "messageId": "uuid",
        "sessionId": "uuid",
        "message": "Làm sao để học từ vựng hiệu quả?",
        "response": "Để học từ vựng hiệu quả, bạn nên...",
        "timestamp": "2025-11-18T10:30:00",
        "tokensUsed": null,
        "relatedTopics": ["Business", "Daily Life"],
        "vocabSuggestions": [
            {
                "vocabId": "uuid",
                "word": "effective",
                "meaningVi": "hiệu quả",
                "cefr": "B1"
            }
        ]
    }
}
```

### 2. Lấy lịch sử chat

**GET** `/api/v1/chatbot/history/{sessionId}?limit=50`

### 3. Xóa lịch sử chat

**DELETE** `/api/v1/chatbot/history/{sessionId}`

### 4. Health check

**GET** `/api/v1/chatbot/health`

## 🧠 Cách hoạt động

### Flow xử lý:

```
User Question
    ↓
1. Search FAQ → Priority answer
    ↓
2. Search Database → Context (vocab, topics, progress)
    ↓
3. Build Prompt → Combine FAQ + DB Context + Question
    ↓
4. Call Gemini API → Generate smart response
    ↓
5. Save to DB → Chat history
    ↓
6. Return Response + Suggestions
```

### Context Building:

1. **FAQ Context** (Cao nhất):

    - Tìm kiếm exact/fuzzy match trong FAQ
    - Sử dụng keyword matching
    - Normalize Vietnamese text

2. **Database Context**:

    - **Vocab**: Tìm từ vựng liên quan
    - **Topics**: Danh sách chủ đề
    - **Progress**: Tiến độ học của user

3. **Conversation History**:
    - Load 10 tin nhắn gần nhất
    - Maintain context cho câu hỏi follow-up

## 🎨 Prompt Engineering

System prompt được thiết kế:

```
Bạn là trợ lý AI thông minh của ứng dụng học từ vựng Card Words.
Nhiệm vụ: Hỗ trợ người dùng học tiếng Anh hiệu quả
Style: Thân thiện, ngắn gọn, chính xác
Format: Sử dụng emoji khi phù hợp
```

## 💡 Ví dụ sử dụng

### 1. Hỏi về cách học

**User:** "Làm sao để học từ vựng hiệu quả?"

**AI:** Tìm trong FAQ → Trả lời từ knowledge base

### 2. Hỏi về từ vựng

**User:** "Nghĩa của từ 'effective' là gì?"

**AI:** Tìm trong DB → Trả về nghĩa + ví dụ + suggestions

### 3. Hỏi về tiến độ

**User:** "Tôi đã học được bao nhiêu từ?"

**AI:** Query progress → Trả về stats cá nhân

### 4. Câu hỏi chung

**User:** "App có miễn phí không?"

**AI:** FAQ → "Card Words hoàn toàn miễn phí..."

## 🔒 Security

-   API Key được store trong environment variable
-   JWT authentication required cho tất cả endpoints
-   Rate limiting through Gemini API (15 req/min free tier)

## ⚡ Performance Tips

### 1. Tối ưu FREE tier:

-   **Model**: `gemini-2.5-flash-exp` (fastest, free)
-   **Max tokens**: 8192 (vừa đủ)
-   **Temperature**: 0.7 (balanced creativity)

### 2. Reduce API calls:

-   Cache FAQ answers
-   Limit conversation history (10 messages)
-   Short, focused context

### 3. Smart context:

-   Chỉ include relevant data
-   Skip context nếu FAQ match 100%

## 📊 Gemini API Limits (FREE)

-   ✅ 15 requests/minute
-   ✅ 1,500 requests/day
-   ✅ 1 million tokens/month
-   ✅ Context window: 128K tokens

## 🐛 Troubleshooting

### Error: "Unexpected response code: 429"

→ Rate limit exceeded. Wait 1 minute.

### Error: "Invalid API key"

→ Check `GEMINI_API_KEY` in `.env`

### Empty response

→ Check Gemini API status: https://status.google.com/

### Context too long

→ Reduce `max-tokens` or conversation history limit

## 📝 Next Steps

1. ✅ Add streaming response (real-time typing effect)
2. ✅ Implement caching layer (Redis)
3. ✅ Add analytics dashboard
4. ✅ Fine-tune prompts based on user feedback
5. ✅ Multi-language support

## 🎯 Test API

```bash
# Login first
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password"}'

# Chat
curl -X POST http://localhost:8080/api/v1/chatbot/chat \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Làm sao để học từ vựng hiệu quả?",
    "includeContext": true,
    "searchFaq": true
  }'
```

---

**Model**: gemini-2.5-flash-exp  
**Status**: ✅ Production Ready  
**Cost**: 💰 FREE
