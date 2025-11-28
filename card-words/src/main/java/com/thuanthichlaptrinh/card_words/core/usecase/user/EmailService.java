package com.thuanthichlaptrinh.card_words.core.usecase.user;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmailService {

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    public void sendWelcomeEmailWithPassword(String toEmail, String name, String password) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("🎉 Chào mừng bạn đến với Card Words!");
            helper.setText(buildWelcomeEmailContent(name, toEmail, password), true);
            mailSender.send(message);
            log.info("✅ Welcome email sent to: {}", toEmail);
        } catch (Exception e) {
            log.error("Lỗi khi gửi email đến {}: {}", toEmail, e.getMessage());
            log.error("THÔNG TIN ĐĂNG NHẬP (Do lỗi email):");
            log.error("Email: {}", toEmail);
            log.error("Mật khẩu: {}", password);
        }
    }

    public void sendActivationEmail(String toEmail, String name, String activationKey) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("Kích hoạt tài khoản Card Words");
            helper.setText(buildActivationEmailContent(name, activationKey), true);
            mailSender.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Không thể gửi email kích hoạt", e);
        }
    }

    public void sendActivationSuccessEmail(String toEmail, String name) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("Tài khoản Card Words đã được kích hoạt");
            helper.setText(buildActivationSuccessEmailContent(name), true);
            mailSender.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Không thể gửi email thông báo", e);
        }
    }

    public void sendNewPasswordEmail(String toEmail, String name, String newPassword) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("🔐 Mật khẩu mới cho tài khoản Card Words");
            helper.setText(buildNewPasswordEmailContent(name, toEmail, newPassword), true);
            mailSender.send(message);
            log.info("Đã gửi email mật khẩu mới đến: {}", toEmail);
        } catch (Exception e) {
            log.error("Lỗi khi gửi email mật khẩu mới đến {}: {}", toEmail, e.getMessage());
            throw new RuntimeException("Không thể gửi email mật khẩu mới", e);
        }
    }

    public void sendStreakReminderEmail(String toEmail, String name, int streak) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("🔥 Don't Break Your " + streak + "-Day Streak!");
            helper.setText(buildStreakReminderEmailContent(name, streak), true);
            mailSender.send(message);
            log.info("✅ Streak reminder email sent to: {}", toEmail);
        } catch (Exception e) {
            log.error("❌ Failed to send streak reminder email to {}: {}", toEmail, e.getMessage());
            throw new RuntimeException("Không thể gửi email nhắc nhở streak", e);
        }
    }

    private String buildWelcomeEmailContent(String name, String email, String password) {
        return String.format("""
                <!DOCTYPE html>
                <html><head><meta charset="UTF-8"></head>
                <body style="font-family: Arial, sans-serif;">
                    <h1>🎉 Chào mừng đến với Card Words!</h1>
                    <p>Xin chào %s!</p>
                    <p>Tài khoản của bạn đã được tạo thành công.</p>
                    <p><strong>Email:</strong> %s</p>
                    <p><strong>Mật khẩu:</strong> %s</p>
                    <p>Vui lòng đổi mật khẩu sau khi đăng nhập.</p>
                </body>
                </html>
                """, name, email, password);
    }

    private String buildActivationEmailContent(String name, String activationKey) {
        String activationUrl = "http://localhost:8080/api/v1/auth/verify-email?key=" + activationKey;
        return String.format("""
                <!DOCTYPE html>
                <html><head><meta charset="UTF-8"></head>
                <body>
                    <h2>Xin chào %s!</h2>
                    <p>Vui lòng kích hoạt tài khoản:</p>
                    <a href="%s">Kích hoạt tài khoản</a>
                </body>
                </html>
                """, name, activationUrl);
    }

    private String buildActivationSuccessEmailContent(String name) {
        return String.format("""
                <!DOCTYPE html>
                <html><head><meta charset="UTF-8"></head>
                <body>
                    <h2>Xin chào %s!</h2>
                    <p>🎉 Tài khoản của bạn đã được kích hoạt thành công!</p>
                </body>
                </html>
                """, name);
    }

    private String buildNewPasswordEmailContent(String name, String email, String newPassword) {
        return String.format("""
                <!DOCTYPE html>
                <html><head><meta charset="UTF-8"></head>
                <body>
                    <h2>Xin chào %s!</h2>
                    <p><strong>Email:</strong> %s</p>
                    <p><strong>Mật khẩu mới:</strong> %s</p>
                    <p>Vui lòng đổi mật khẩu sau khi đăng nhập.</p>
                </body>
                </html>
                """, name, email, newPassword);
    }

    private String buildStreakReminderEmailContent(String name, int streak) {
        return String.format("""
                <!DOCTYPE html>
                <html><head><meta charset="UTF-8"></head>
                <body>
                    <h2>Hi %s! 👋</h2>
                    <p>🔥 You have a %d-day streak!</p>
                    <p>Don't break it - practice today!</p>
                </body>
                </html>
                """, name, streak);
    }
}
