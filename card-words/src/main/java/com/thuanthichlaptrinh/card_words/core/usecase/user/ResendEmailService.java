package com.thuanthichlaptrinh.card_words.core.usecase.user;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

/**
 * Email service using Resend HTTP API
 * Works on Railway where SMTP ports are blocked
 */
@Slf4j
@Service
public class ResendEmailService {

    @Value("${resend.api.key:}")
    private String resendApiKey;

    @Value("${resend.from.email:onboarding@resend.dev}")
    private String fromEmail;

    private final RestTemplate restTemplate = new RestTemplate();
    private static final String RESEND_API_URL = "https://api.resend.com/emails";

    public boolean isEnabled() {
        return resendApiKey != null && !resendApiKey.isEmpty() && !resendApiKey.equals("your-resend-api-key");
    }

    public boolean sendEmail(String to, String subject, String htmlContent) {
        if (!isEnabled()) {
            log.warn("Resend API key not configured, skipping email");
            return false;
        }

        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(resendApiKey);

            Map<String, Object> body = new HashMap<>();
            body.put("from", fromEmail);
            body.put("to", new String[]{to});
            body.put("subject", subject);
            body.put("html", htmlContent);

            HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);
            ResponseEntity<String> response = restTemplate.postForEntity(RESEND_API_URL, request, String.class);

            if (response.getStatusCode().is2xxSuccessful()) {
                log.info("✅ Email sent successfully via Resend to: {}", to);
                return true;
            } else {
                log.error("❌ Resend API error: {}", response.getBody());
                return false;
            }
        } catch (Exception e) {
            log.error("❌ Failed to send email via Resend: {}", e.getMessage());
            return false;
        }
    }
}
