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

            String htmlContent = buildWelcomeEmailContent(name, toEmail, password);
            helper.setText(htmlContent, true);

            mailSender.send(message);

        } catch (Exception e) {
            log.error("Lỗi khi gửi email đến {}: {}", toEmail, e.getMessage());
            log.error("THÔNG TIN ĐĂNG NHẬP (Do lỗi email):");
            log.error("Email: {}", toEmail);
            log.error("Mật khẩu: {}", password);
            log.error("Vui lòng cấu hình SMTP hoặc tạo App Password cho Gmail!");
        }
    }

    public void sendActivationEmail(String toEmail, String name, String activationKey) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("Kích hoạt tài khoản Card Words");

            String htmlContent = buildActivationEmailContent(name, activationKey);
            helper.setText(htmlContent, true);

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

            String htmlContent = buildActivationSuccessEmailContent(name);
            helper.setText(htmlContent, true);

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

            String htmlContent = buildNewPasswordEmailContent(name, toEmail, newPassword);
            helper.setText(htmlContent, true);

            mailSender.send(message);
            log.info("Đã gửi email mật khẩu mới đến: {}", toEmail);

        } catch (Exception e) {
            log.error("Lỗi khi gửi email mật khẩu mới đến {}: {}", toEmail, e.getMessage());
            log.error("THÔNG TIN MẬT KHẨU MỚI (Do lỗi email):");
            log.error("Email: {}", toEmail);
            log.error("Mật khẩu mới: {}", newPassword);
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

            String htmlContent = buildStreakReminderEmailContent(name, streak);
            helper.setText(htmlContent, true);

            mailSender.send(message);
            log.info("✅ Streak reminder email sent to: {}", toEmail);

        } catch (Exception e) {
            log.error("❌ Failed to send streak reminder email to {}: {}", toEmail, e.getMessage());
            throw new RuntimeException("Không thể gửi email nhắc nhở streak", e);
        }
    }

    private String buildWelcomeEmailContent(String name, String email, String password) {
        return String.format(
                """
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <style>
                        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
                        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                        .header { background: linear-gradient(135deg, #667eea, #764ba2); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
                        .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }
                        .credentials { background: white; padding: 20px; border-radius: 8px; border-left: 4px solid #667eea; margin: 20px 0; }
                        .warning { background: #fff3cd; padding: 15px; border-radius: 8px; border-left: 4px solid #ffc107; margin: 20px 0; }
                        .footer { text-align: center; margin-top: 30px; color: #666; font-size: 14px; }
                        .btn { display: inline-block; background: #667eea; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; margin: 10px 0; }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="header">
                            <h1>🎉 Chào mừng đến với Card Words!</h1>
                            <p>Hệ thống học từ vựng tiếng Anh bằng trò chơi ghép thẻ</p>
                        </div>
                        <div class="content">
                            <h2>Xin chào %s!</h2>
                            <p>Tài khoản của bạn đã được tạo thành công.</p>
                            <div class="credentials">
                                <h3>📧 Thông tin đăng nhập:</h3>
                                <p><strong>Email:</strong> %s</p>
                                <p><strong>Mật khẩu:</strong> <code>%s</code></p>
                            </div>
                            <div class="warning">
                                <h4>🔒 Lưu ý:</h4>
                                <p>Vui lòng đổi mật khẩu sau khi đăng nhập.</p>
                            </div>
                        </div>
                        <div class="footer">
                            <p>© 2025 Card Words</p>
                        </div>
                    </div>
                </body>
                </html>
                """, name, email, password);
    }


    private String buildActivationEmailContent(String name, String activationKey) {
        String activationUrl = "http://localhost:8080/api/v1/auth/verify-email?key=" + activationKey;
        return String.format(
                """
                <!DOCTYPE html>
                <html>
                <head><meta charset="UTF-8"></head>
                <body>
                    <h2>Xin chào %s!</h2>
                    <p>Vui lòng kích hoạt tài khoản:</p>
                    <a href="%s">Kích hoạt tài khoản</a>
                    <p>Link: %s</p>
                </body>
                </html>
                """, name, activationUrl, activationUrl);
    }

    private String buildActivationSuccessEmailContent(String name) {
        return String.format(
                """
                <!DOCTYPE html>
                <html>
                <head><meta charset="UTF-8"></head>
                <body>
                    <h2>Xin chào %s!</h2>
                    <p>🎉 Tài khoản của bạn đã được kích hoạt thành công!</p>
                </body>
                </html>
                """, name);
    }

    private String buildNewPasswordEmailContent(String name, String email, String newPassword) {
        return String.format(
                """
                <!DOCTYPE html>
                <html>
                <head><meta charset="UTF-8"></head>
                <body>
                    <h2>Xin chào %s!</h2>
                    <p>Mật khẩu mới của bạn:</p>
                    <p><strong>Email:</strong> %s</p>
                    <p><strong>Mật khẩu:</strong> %s</p>
                    <p>Vui lòng đổi mật khẩu sau khi đăng nhập.</p>
                </body>
                </html>
                """, name, email, newPassword);
    }

    private String buildStreakReminderEmailContent(String name, int streak) {
        return String.format(
                """
                <!DOCTYPE html>
                <html>
                <head><meta charset="UTF-8"></head>
                <body>
                    <h2>Hi %s! 👋</h2>
                    <p>🔥 You have a %d-day streak!</p>
                    <p>Don't break it - practice today!</p>
                </body>
                </html>
                """, name, streak);
    }
}
