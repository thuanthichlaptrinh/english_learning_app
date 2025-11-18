package com.thuanthichlaptrinh.card_words.core.service;

import com.thuanthichlaptrinh.card_words.core.domain.ChatMessage;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.domain.Vocab;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.ChatMessageRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.chat.ChatResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChatbotService {

    private final GeminiService geminiService;
    private final FaqService faqService;
    private final ChatContextService chatContextService;
    private final ChatMessageRepository chatMessageRepository;

    @Transactional
    public ChatResponse chat(User user, String message, UUID sessionId, boolean includeContext, boolean searchFaq) {
        try {
            // Generate session ID if not provided
            if (sessionId == null) {
                sessionId = UUID.randomUUID();
            }

            // Build conversation context
            String fullPrompt = buildPrompt(user, message, sessionId, includeContext, searchFaq);

            // Get conversation history
            List<GeminiService.Message> messages = buildConversationHistory(sessionId, fullPrompt);

            // Call Gemini API
            String aiResponse = geminiService.generateResponse(messages);

            // Save user message
            saveChatMessage(user, sessionId, ChatMessage.MessageRole.USER,
                    message, null, null);

            // Save AI response
            ChatMessage assistantMessage = saveChatMessage(user, sessionId, ChatMessage.MessageRole.ASSISTANT,
                    aiResponse, fullPrompt, null);

            // Get related suggestions
            List<Vocab> vocabSuggestions = chatContextService.suggestVocabs(message, 5);
            List<String> relatedTopics = chatContextService.suggestTopics(message, 5)
                    .stream()
                    .map(topic -> topic.getName())
                    .collect(Collectors.toList());

            // Build response
            return ChatResponse.builder()
                    .messageId(assistantMessage.getId())
                    .sessionId(sessionId)
                    .message(message)
                    .response(aiResponse)
                    .timestamp(LocalDateTime.now())
                    .tokensUsed(null)
                    .relatedTopics(relatedTopics)
                    .vocabSuggestions(vocabSuggestions.stream()
                            .map(vocab -> ChatResponse.VocabSuggestion.builder()
                                    .vocabId(vocab.getId())
                                    .word(vocab.getWord())
                                    .meaningVi(vocab.getMeaningVi())
                                    .cefr(vocab.getCefr())
                                    .build())
                            .collect(Collectors.toList()))
                    .build();

        } catch (Exception e) {
            log.error("Error processing chat request", e);
            throw new RuntimeException("Failed to process chat request: " + e.getMessage());
        }
    }

    private String buildPrompt(User user, String message, UUID sessionId, boolean includeContext, boolean searchFaq) {
        StringBuilder promptBuilder = new StringBuilder();

        // System prompt - Hướng dẫn AI rõ ràng và nghiêm khắc hơn
        promptBuilder.append("# 🤖 Bạn là AI Assistant của ứng dụng học từ vựng Card Words\n\n");

        promptBuilder.append("## 🎯 Nhiệm vụ:\n");
        promptBuilder.append("- Hỗ trợ người dùng học tiếng Anh hiệu quả\n");
        promptBuilder.append("- Trả lời câu hỏi về từ vựng, chủ đề, tính năng app\n");
        promptBuilder.append("- Đưa ra lời khuyên về phương pháp học tập\n\n");

        promptBuilder.append("## ⚠️ QUY TẮC VÀNG (BẮT BUỘC TUÂN THỦ):\n\n");

        promptBuilder.append("### 1. VỀ DỮ LIỆU:\n");
        promptBuilder.append("- ✅ **NẾU CÓ 'Dữ liệu thực tế từ hệ thống'**: Sử dụng 100% số liệu từ phần đó\n");
        promptBuilder.append("- ✅ **NẾU CÓ 'Câu trả lời từ FAQ'**: Dựa vào FAQ nhưng diễn đạt tự nhiên hơn\n");
        promptBuilder.append("- ❌ **TUYỆT ĐỐI KHÔNG TỰ Ý BỊA SỐ LIỆU** khi chưa có dữ liệu thực tế\n");
        promptBuilder.append("- ❌ **KHÔNG ĐOÁN MÒ** số lượng topic, số từ vựng, hay bất kỳ con số nào\n\n");

        promptBuilder.append("### 2. KHI KHÔNG CÓ DỮ LIỆU:\n");
        promptBuilder.append("- Nói thật: \"Em chưa có dữ liệu cụ thể về...\"\n");
        promptBuilder.append("- Hướng dẫn user cách xem: \"Bạn có thể xem trong menu Topics\"\n");
        promptBuilder.append("- Đưa ra thông tin chung chung (VD: \"Ứng dụng có nhiều chủ đề đa dạng\")\n\n");

        promptBuilder.append("### 3. PHONG CÁCH TRẢ LỜI:\n");
        promptBuilder.append("- 🎯 **NGẮN GỌN**: 2-5 câu cho câu hỏi đơn giản\n");
        promptBuilder.append("- 🎯 **RÕ RÀNG**: Bullet points cho danh sách\n");
        promptBuilder.append("- 🎯 **THÂN THIỆN**: Emoji phù hợp (1-2 emoji/đoạn)\n");
        promptBuilder.append("- 🎯 **TIẾNG VIỆT**: Tự nhiên, dễ hiểu\n");
        promptBuilder.append("- 🎯 **CHỦ ĐỘNG**: Gợi ý hành động tiếp theo\n\n");

        promptBuilder.append("### 4. VÍ DỤ CÂU TRẢ LỜI TốT:\n");
        promptBuilder.append("❓ \"Ứng dụng có bao nhiêu chủ đề?\"\n");
        promptBuilder.append(
                "✅ ĐÚNG (có dữ liệu): \"Ứng dụng hiện có **17 chủ đề** với tổng cộng **1,234 từ vựng**. Các chủ đề phổ biến: Food & Drink (89 từ), Animals (67 từ), Travel (54 từ)...\"\n");
        promptBuilder.append(
                "✅ ĐÚNG (không có dữ liệu): \"Em chưa có dữ liệu cụ thể lúc này. Bạn có thể xem danh sách đầy đủ các chủ đề trong menu Topics nhé! 😊\"\n");
        promptBuilder.append("❌ SAI: \"Ứng dụng có khoảng 12 chủ đề\" (đoán mò)\n\n");

        // FAQ context (priority)
        if (searchFaq) {
            Optional<FaqService.FaqItem> faqMatch = faqService.findBestMatch(message);
            if (faqMatch.isPresent()) {
                promptBuilder.append("═══════════════════════════════════════════\n");
                promptBuilder.append("## 📚 CÂU TRẢ LỜI TỪ FAQ (Ưu tiên sử dụng):\n\n");
                promptBuilder.append(faqMatch.get().getAnswer());
                promptBuilder
                        .append("\n\n**👉 Hướng dẫn:** Dựa vào câu trả lời FAQ trên, diễn đạt lại tự nhiên hơn.\n");
                promptBuilder.append("═══════════════════════════════════════════\n\n");
            }
        }

        // Database context
        if (includeContext) {
            String dbContext = chatContextService.buildContext(user, message);
            if (!dbContext.trim().isEmpty()) {
                promptBuilder.append("═══════════════════════════════════════════\n");
                promptBuilder.append("## 💾 DỮ LIỆU THỰC TẾ TỪ HỆ THỐNG (Sử dụng 100% số liệu này):\n\n");
                promptBuilder.append(dbContext);
                promptBuilder.append("\n\n**⚠️ CHÚ Ý:** Đây là dữ liệu THỰC TẾ từ database.\n");
                promptBuilder.append("- Sử dụng CHÍNH XÁC các con số ở trên\n");
                promptBuilder.append("- KHÔNG thay đổi, làm tròn, hay đoán số liệu\n");
                promptBuilder.append("- Nếu không thấy thông tin → Nói thật là chưa có dữ liệu\n");
                promptBuilder.append("═══════════════════════════════════════════\n\n");
            }
        }

        // User question
        promptBuilder.append("═══════════════════════════════════════════\n");
        promptBuilder.append("## ❓ CÂU HỎI CỦA NGƯỜI DÙNG:\n\n");
        promptBuilder.append(message);
        promptBuilder.append("\n═══════════════════════════════════════════\n\n");

        promptBuilder.append("**Bây giờ hãy trả lời câu hỏi trên, tuân thủ tất cả quy tắc vàng ở trên!** 🚀");

        return promptBuilder.toString();
    }

    private List<GeminiService.Message> buildConversationHistory(UUID sessionId, String currentPrompt) {
        List<GeminiService.Message> messages = new ArrayList<>();

        // Get recent conversation history (last 10 messages)
        List<ChatMessage> history = chatMessageRepository.findBySessionIdOrderByCreatedAtAsc(sessionId)
                .stream()
                .limit(10)
                .collect(Collectors.toList());

        // Add history to messages
        for (ChatMessage msg : history) {
            messages.add(GeminiService.Message.builder()
                    .role(msg.getRole() == ChatMessage.MessageRole.USER ? "user" : "assistant")
                    .content(msg.getContent())
                    .build());
        }

        // Add current prompt
        messages.add(GeminiService.Message.builder()
                .role("user")
                .content(currentPrompt)
                .build());

        return messages;
    }

    private ChatMessage saveChatMessage(User user, UUID sessionId, ChatMessage.MessageRole role,
            String content, String contextUsed, Integer tokensUsed) {
        ChatMessage message = ChatMessage.builder()
                .sessionId(sessionId)
                .user(user)
                .role(role)
                .content(content)
                .contextUsed(contextUsed)
                .tokensUsed(tokensUsed)
                .build();

        return chatMessageRepository.save(message);
    }

    public List<ChatMessage> getChatHistory(UUID sessionId, int limit) {
        return chatMessageRepository.findBySessionIdOrderByCreatedAtDesc(sessionId)
                .stream()
                .limit(limit)
                .collect(Collectors.toList());
    }

    @Transactional
    public void clearChatHistory(UUID sessionId) {
        chatMessageRepository.deleteBySessionId(sessionId);
    }
}
