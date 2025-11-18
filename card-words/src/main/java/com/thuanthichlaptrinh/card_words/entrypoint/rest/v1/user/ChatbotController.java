package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.user;

import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.domain.ChatMessage;
import com.thuanthichlaptrinh.card_words.core.service.ChatbotService;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.chat.ChatRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.chat.ChatResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;
import java.util.UUID;

@Slf4j
@RestController
@RequestMapping("/api/v1/chatbot")
@RequiredArgsConstructor
@Tag(name = "Chatbot", description = "API trợ lý AI học từ vựng")
public class ChatbotController {

        private final ChatbotService chatbotService;
        private final UserRepository userRepository;

        @PostMapping("/chat")
        @Operation(summary = "Gửi tin nhắn đến chatbot", description = "Gửi câu hỏi hoặc tin nhắn đến AI chatbot để nhận hỗ trợ học từ vựng.\n\n"
                        +
                        "**Features:**\n" +
                        "- Trả lời câu hỏi từ FAQ\n" +
                        "- Tìm kiếm thông tin từ database (từ vựng, topics, tiến độ)\n" +
                        "- Đề xuất từ vựng liên quan\n" +
                        "- Hỗ trợ học tập cá nhân hóa\n\n" +
                        "**Request Body:**\n" +
                        "```json\n" +
                        "{\n" +
                        "  \"message\": \"Làm sao để học từ vựng hiệu quả?\",\n" +
                        "  \"sessionId\": \"uuid-optional\",\n" +
                        "  \"includeContext\": true,\n" +
                        "  \"searchFaq\": true\n" +
                        "}\n" +
                        "```", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<ChatResponse>> chat(
                        Principal principal,
                        @Valid @RequestBody ChatRequest request) {

                User user = userRepository.findByEmail(principal.getName())
                                .orElseThrow(() -> new RuntimeException("User not found"));
                ChatResponse response = chatbotService.chat(
                                user,
                                request.getMessage(),
                                request.getSessionId(),
                                request.getIncludeContext(),
                                request.getSearchFaq());

                return ResponseEntity.ok(ApiResponse.success("Chat processed successfully", response));
        }

        @GetMapping("/history/{sessionId}")
        @Operation(summary = "Lấy lịch sử chat", description = "Lấy lịch sử hội thoại của một session cụ thể.\n\n" +
                        "**URL:** `GET /api/v1/chatbot/history/{sessionId}?limit=50`", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<List<ChatMessage>>> getChatHistory(
                        @Parameter(description = "Session ID") @PathVariable UUID sessionId,
                        @Parameter(description = "Số lượng tin nhắn tối đa") @RequestParam(defaultValue = "50") int limit) {

                List<ChatMessage> history = chatbotService.getChatHistory(sessionId, limit);

                return ResponseEntity.ok(ApiResponse.success("Chat history retrieved", history));
        }

        @DeleteMapping("/history/{sessionId}")
        @Operation(summary = "Xóa lịch sử chat", description = "Xóa toàn bộ lịch sử hội thoại của một session.", security = @SecurityRequirement(name = "Bearer Authentication"))
        public ResponseEntity<ApiResponse<Void>> clearChatHistory(
                        @Parameter(description = "Session ID") @PathVariable UUID sessionId) {

                chatbotService.clearChatHistory(sessionId);

                return ResponseEntity.ok(ApiResponse.success("Chat history cleared", null));
        }

        @GetMapping("/health")
        @Operation(summary = "Kiểm tra trạng thái chatbot", description = "Endpoint để kiểm tra chatbot có hoạt động hay không")
        public ResponseEntity<ApiResponse<String>> health() {
                return ResponseEntity.ok(ApiResponse.success("Chatbot is running", "OK"));
        }
}
