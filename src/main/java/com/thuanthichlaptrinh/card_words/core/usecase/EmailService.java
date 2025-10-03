package com.thuanthichlaptrinh.card_words.core.usecase;

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

    /**
     * Gửi email kích hoạt tài khoản
     */
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

    /**
     * Gửi email thông báo kích hoạt thành công
     */
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

    /**
     * Tạo nội dung HTML cho email chào mừng
     */
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

    /**
     * Tạo nội dung HTML cho email kích hoạt
     */
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

    /**
     * Tạo nội dung HTML cho email thông báo kích hoạt thành công
     */
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
}
