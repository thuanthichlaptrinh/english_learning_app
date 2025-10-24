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

    // Gửi email kích hoạt tài khoản
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

    // Gửi email thông báo kích hoạt thành công
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

    // Tạo nội dung HTML cho email chào mừng
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
                                    <p>Tài khoản của bạn đã được tạo thành công trên hệ thống Card Words. Chúng tôi rất vui mừng chào đón bạn!</p>

                                    <div class="credentials">
                                        <h3>📧 Thông tin đăng nhập:</h3>
                                        <p><strong>Email:</strong> %s</p>
                                        <p><strong>Mật khẩu:</strong> <code style="background: #e9ecef; padding: 4px 8px; border-radius: 4px; font-family: monospace;">%s</code></p>
                                    </div>

                                    <div class="warning">
                                        <h4>🔒 Lưu ý về mật khẩu:</h4>
                                        <ul>
                                            <li><strong>Mật khẩu đã được tạo dễ nhớ</strong> với format: Chữ hoa + Số + Chữ thường + Số + Chữ hoa + Số</li>
                                            <li>Bạn có thể <strong>thay đổi mật khẩu</strong> sau khi đăng nhập thành công</li>
                                            <li>Không chia sẻ thông tin đăng nhập với bất kỳ ai</li>
                                            <li>Giữ mật khẩu ở nơi an toàn</li>
                                        </ul>
                                    </div>

                                    <div style="text-align: center;">
                                        <a href="http://localhost:8080/swagger-ui/index.html" class="btn">🚀 Bắt đầu sử dụng</a>
                                    </div>

                                    <p>Nếu bạn có bất kỳ câu hỏi nào, đừng ngần ngại liên hệ với chúng tôi.</p>
                                    <p>Chúc bạn có những trải nghiệm tuyệt vời với Card Words!</p>
                                </div>
                                <div class="footer">
                                    <p>© 2025 Card Words - Hệ thống học từ vựng tiếng Anh bằng trò chơi ghép thẻ</p>
                                    <p>Email này được gửi tự động, vui lòng không reply.</p>
                                </div>
                            </div>
                        </body>
                        </html>
                        """,
                name, email, password);
    }

    // Tạo nội dung HTML cho email kích hoạt
    private String buildActivationEmailContent(String name, String activationKey) {
        String activationUrl = "http://localhost:8080/api/v1/auth/verify-email?key=" + activationKey;

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
                                .btn { display: inline-block; background: #28a745; color: white; padding: 15px 30px; text-decoration: none; border-radius: 6px; margin: 20px 0; font-weight: bold; }
                                .code { background: white; padding: 15px; border-radius: 8px; border-left: 4px solid #667eea; margin: 20px 0; font-family: monospace; }
                                .footer { text-align: center; margin-top: 30px; color: #666; font-size: 14px; }
                            </style>
                        </head>
                        <body>
                            <div class="container">
                                <div class="header">
                                    <h1>🔐 Kích hoạt tài khoản</h1>
                                    <p>Card Words</p>
                                </div>
                                <div class="content">
                                    <h2>Xin chào %s!</h2>
                                    <p>Cảm ơn bạn đã đăng ký tài khoản Card Words. Để hoàn tất quá trình đăng ký, vui lòng kích hoạt tài khoản của bạn.</p>

                                    <div style="text-align: center;">
                                        <a href="%s" class="btn">✅ Kích hoạt tài khoản</a>
                                    </div>

                                    <p>Hoặc copy đường link sau vào trình duyệt:</p>
                                    <div class="code">%s</div>

                                    <p><strong>Lưu ý:</strong> Link kích hoạt có hiệu lực trong 24 giờ.</p>

                                    <p>Nếu bạn không đăng ký tài khoản này, vui lòng bỏ qua email này.</p>
                                </div>
                                <div class="footer">
                                    <p>© 2025 Card Words</p>
                                    <p>Email này được gửi tự động, vui lòng không reply.</p>
                                </div>
                            </div>
                        </body>
                        </html>
                        """,
                name, activationUrl, activationUrl);
    }

    // Tạo nội dung HTML cho email thông báo kích hoạt thành công
    private String buildActivationSuccessEmailContent(String name) {
        return String.format(
                """
                        <!DOCTYPE html>
                        <html>
                        <head>
                            <meta charset="UTF-8">
                            <style>
                                body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
                                .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                                .header { background: linear-gradient(135deg, #28a745, #20c997); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
                                .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }
                                .btn { display: inline-block; background: #667eea; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; margin: 10px 0; }
                                .footer { text-align: center; margin-top: 30px; color: #666; font-size: 14px; }
                            </style>
                        </head>
                        <body>
                            <div class="container">
                                <div class="header">
                                    <h1>✅ Kích hoạt thành công!</h1>
                                    <p>Chào mừng đến với Card Words</p>
                                </div>
                                <div class="content">
                                    <h2>Xin chào %s!</h2>
                                    <p>🎉 Tài khoản của bạn đã được kích hoạt thành công!</p>
                                    <p>Bây giờ bạn có thể đăng nhập và bắt đầu học từ vựng tiếng Anh với Card Words.</p>

                                    <div style="text-align: center;">
                                        <a href="http://localhost:8080/swagger-ui/index.html" class="btn">🚀 Bắt đầu học ngay</a>
                                    </div>

                                    <p>Chúc bạn có những trải nghiệm tuyệt vời!</p>
                                </div>
                                <div class="footer">
                                    <p>© 2025 Card Words</p>
                                </div>
                            </div>
                        </body>
                        </html>
                        """,
                name);
    }

    // Gửi email với mật khẩu mới khi quên mật khẩu
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

    // Tạo nội dung HTML cho email mật khẩu mới
    private String buildNewPasswordEmailContent(String name, String email, String newPassword) {
        return String.format(
                """
                        <!DOCTYPE html>
                        <html>
                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Mật khẩu mới - Card Words</title>
                            <style>
                                body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f5f5f5; }
                                .container { max-width: 600px; margin: 0 auto; background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
                                .header { background: linear-gradient(135deg, #667eea 0%%, #764ba2 100%%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
                                .header h1 { margin: 0; font-size: 28px; }
                                .content { padding: 30px; }
                                .password-box { background: #f8f9fa; border: 2px solid #e9ecef; border-radius: 8px; padding: 20px; margin: 20px 0; text-align: center; }
                                .password { font-size: 24px; font-weight: bold; color: #495057; font-family: 'Courier New', monospace; letter-spacing: 2px; }
                                .warning { background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 6px; padding: 15px; margin: 20px 0; color: #856404; }
                                .footer { background: #f8f9fa; padding: 20px; text-align: center; color: #6c757d; border-radius: 0 0 10px 10px; }
                                .button { display: inline-block; padding: 12px 24px; background: #007bff; color: white; text-decoration: none; border-radius: 6px; margin: 10px 5px; }
                            </style>
                        </head>
                        <body>
                            <div class="container">
                                <div class="header">
                                    <h1>🔐 Mật khẩu mới</h1>
                                    <p>Card Words - Ứng dụng học từ vựng Tiếng Anh bằng trò chơi ghép thẻ</p>
                                </div>
                                <div class="content">
                                    <h2>Xin chào %s!</h2>

                                    <p>Bạn đã yêu cầu đặt lại mật khẩu cho tài khoản <strong>%s</strong>.</p>

                                    <div class="password-box">
                                        <p><strong>Mật khẩu mới của bạn là:</strong></p>
                                        <div class="password">%s</div>
                                    </div>

                                    <div class="warning">
                                        <strong>⚠️ Lưu ý quan trọng:</strong>
                                        <ul style="margin: 10px 0; padding-left: 20px;">
                                            <li>Vui lòng đăng nhập và đổi mật khẩu ngay lập tức</li>
                                            <li>Không chia sẻ mật khẩu này với bất kỳ ai</li>
                                            <li>Mật khẩu này được tạo tự động và dễ nhớ</li>
                                        </ul>
                                    </div>

                                    <div style="text-align: center; margin: 30px 0;">
                                        <a href="http://localhost:3000/login" class="button">Đăng nhập ngay</a>
                                    </div>

                                    <p><strong>Thông tin đăng nhập:</strong></p>
                                    <ul>
                                        <li><strong>Email:</strong> %s</li>
                                        <li><strong>Mật khẩu:</strong> %s</li>
                                    </ul>

                                    <p>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng liên hệ với chúng tôi ngay lập tức.</p>

                                    <p>Chúc bạn có những trải nghiệm học tập tuyệt vời!</p>
                                </div>
                                <div class="footer">
                                    <p>© 2025 Card Words</p>
                                    <p>Email này được gửi tự động, vui lòng không trả lời</p>
                                </div>
                            </div>
                        </body>
                        </html>
                        """,
                name, email, newPassword, email, newPassword);
    }
}
