package com.thuanthichlaptrinh.card_words.common.exceptions;

import java.util.NoSuchElementException;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.NoHandlerFoundException;

import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;

import jakarta.persistence.EntityNotFoundException;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {

    @Value("${spring.profiles.active:dev}")
    private String activeProfile;

    @ExceptionHandler(NoSuchElementException.class)
    public ResponseEntity<ApiResponse<Object>> handleNotFound(NoSuchElementException ex) {
        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(ApiResponse.error("404", ex.getMessage()));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Object>> handleValidation(MethodArgumentNotValidException ex) {
        String message = ex.getBindingResult().getAllErrors().get(0).getDefaultMessage();

        log.warn("Validation error: {}", message);
        log.debug("Validation details - Target: {}, Field errors: {}",
                ex.getBindingResult().getTarget() != null ? ex.getBindingResult().getTarget().getClass().getSimpleName()
                        : "NULL",
                ex.getBindingResult().getFieldErrors());

        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error("400", message));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ApiResponse<Object>> handleBadRequest(IllegalArgumentException ex) {
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error("400", ex.getMessage()));
    }

    @ExceptionHandler(IllegalStateException.class)
    public ResponseEntity<ApiResponse<Object>> handleIllegalState(IllegalStateException ex) {
        log.warn("IllegalStateException: {}", ex.getMessage());
        return ResponseEntity
                .status(HttpStatus.CONFLICT)
                .body(ApiResponse.error("409", ex.getMessage()));
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ApiResponse<Object>> handleAccessDenied(AccessDeniedException ex) {
        return ResponseEntity
                .status(HttpStatus.FORBIDDEN)
                .body(ApiResponse.error("403", "Bạn không có quyền truy cập vào tài nguyên này"));
    }

    @ExceptionHandler(ErrorException.class)
    public ResponseEntity<ApiResponse<Object>> handleErrorException(ErrorException ex) {
        log.warn("ErrorException: {}", ex.getMessage());
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error("400", ex.getMessage()));
    }

    // ==================== Authentication & Authorization Exceptions
    // ===================

    // 401 - Chưa đăng nhập / Token sai / Token hết hạn (từ JwtAuthenticationFilter)
    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<ApiResponse<Object>> handleAuthenticationException(AuthenticationException ex) {
        return ResponseEntity
                .status(HttpStatus.UNAUTHORIZED)
                .body(ApiResponse.error("401",
                        "Phiên đăng nhập không hợp lệ hoặc đã hết hạn."));
    }

    @ExceptionHandler(BadCredentialsException.class)
    public ResponseEntity<ApiResponse<Object>> handleBadCredentials(BadCredentialsException ex) {
        log.warn("BadCredentialsException: {}", ex.getMessage());
        return ResponseEntity
                .status(HttpStatus.UNAUTHORIZED)
                .body(ApiResponse.error("401", "Email hoặc mật khẩu không đúng"));
    }

    @ExceptionHandler(DisabledException.class)
    public ResponseEntity<ApiResponse<Object>> handleDisabled(DisabledException ex) {
        log.warn("DisabledException: {}", ex.getMessage());
        return ResponseEntity
                .status(HttpStatus.UNAUTHORIZED)
                .body(ApiResponse.error("401", "Tài khoản của bạn đã bị vô hiệu hóa"));
    }

    @ExceptionHandler(LockedException.class)
    public ResponseEntity<ApiResponse<Object>> handleLocked(LockedException ex) {
        log.warn("LockedException: {}", ex.getMessage());
        return ResponseEntity
                .status(HttpStatus.UNAUTHORIZED)
                .body(ApiResponse.error("401", "Tài khoản của bạn đã bị khóa"));
    }

    // ==================== Database & Data Exceptions ====================

    @ExceptionHandler(EntityNotFoundException.class)
    public ResponseEntity<ApiResponse<Object>> handleEntityNotFound(EntityNotFoundException ex) {
        log.warn("EntityNotFoundException: {}", ex.getMessage());
        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(ApiResponse.error("404", ex.getMessage()));
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ApiResponse<Object>> handleDataIntegrityViolation(DataIntegrityViolationException ex) {
        log.error("DataIntegrityViolationException: {}", ex.getMessage());

        String message = "Dữ liệu không hợp lệ hoặc vi phạm ràng buộc";

        // Check for common constraint violations
        if (ex.getMessage() != null) {
            if (ex.getMessage().contains("Duplicate entry")) {
                message = "Dữ liệu đã tồn tại trong hệ thống";
            } else if (ex.getMessage().contains("foreign key constraint")) {
                message = "Không thể xóa do có dữ liệu liên quan";
            } else if (ex.getMessage().contains("unique constraint")) {
                message = "Giá trị đã tồn tại, vui lòng sử dụng giá trị khác";
            }
        }

        return ResponseEntity
                .status(HttpStatus.CONFLICT)
                .body(ApiResponse.error("409", message));
    }

    // ==================== Request Validation Exceptions ====================

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ApiResponse<Object>> handleHttpMessageNotReadable(HttpMessageNotReadableException ex) {
        log.warn("HttpMessageNotReadableException: {}", ex.getMessage());

        String message = "Dữ liệu request không đúng định dạng";

        if (ex.getMessage() != null) {
            if (ex.getMessage().contains("JSON parse error")) {
                message = "Dữ liệu JSON không hợp lệ";
            } else if (ex.getMessage().contains("Required request body is missing")) {
                message = "Thiếu dữ liệu request body";
            }
        }

        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error("400", message));
    }

    @ExceptionHandler(MissingServletRequestParameterException.class)
    public ResponseEntity<ApiResponse<Object>> handleMissingParams(MissingServletRequestParameterException ex) {
        log.warn("MissingServletRequestParameterException: {}", ex.getMessage());
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error("400", "Thiếu tham số bắt buộc: " + ex.getParameterName()));
    }

    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<ApiResponse<Object>> handleTypeMismatch(MethodArgumentTypeMismatchException ex) {
        log.warn("MethodArgumentTypeMismatchException: {}", ex.getMessage());

        String message = String.format("Tham số '%s' không đúng định dạng", ex.getName());

        if (ex.getRequiredType() != null) {
            message += String.format(". Yêu cầu kiểu: %s", ex.getRequiredType().getSimpleName());
        }

        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error("400", message));
    }

    // ==================== HTTP Method & Route Exceptions ====================

    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public ResponseEntity<ApiResponse<Object>> handleMethodNotSupported(HttpRequestMethodNotSupportedException ex) {
        log.warn("HttpRequestMethodNotSupportedException: {}", ex.getMessage());
        return ResponseEntity
                .status(HttpStatus.METHOD_NOT_ALLOWED)
                .body(ApiResponse.error("405", "Phương thức HTTP không được hỗ trợ: " + ex.getMethod()));
    }

    @ExceptionHandler(NoHandlerFoundException.class)
    public ResponseEntity<ApiResponse<Object>> handleNoHandlerFound(NoHandlerFoundException ex) {
        log.warn("NoHandlerFoundException: {}", ex.getMessage());
        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(ApiResponse.error("404", "Không tìm thấy endpoint: " + ex.getRequestURL()));
    }

    // ==================== File Upload Exceptions ====================

    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public ResponseEntity<ApiResponse<Object>> handleMaxUploadSizeExceeded(MaxUploadSizeExceededException ex) {
        log.warn("MaxUploadSizeExceededException: {}", ex.getMessage());
        return ResponseEntity
                .status(HttpStatus.PAYLOAD_TOO_LARGE)
                .body(ApiResponse.error("413", "Kích thước file vượt quá giới hạn cho phép"));
    }

    // ==================== Runtime Exceptions ====================

    @ExceptionHandler(NullPointerException.class)
    public ResponseEntity<ApiResponse<Object>> handleNullPointer(NullPointerException ex) {
        String errorId = UUID.randomUUID().toString();
        log.error("NullPointerException [errorId={}]", errorId, ex);

        String message = "Đã xảy ra lỗi xử lý dữ liệu";
        if ("dev".equals(activeProfile) || "staging".equals(activeProfile)) {
            message += " (Mã lỗi: " + errorId + ")";
        }

        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ApiResponse.error("500", message));
    }

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<ApiResponse<Object>> handleRuntimeException(RuntimeException ex) {
        String errorId = UUID.randomUUID().toString();
        log.error("RuntimeException [errorId={}]", errorId, ex);

        String message = ex.getMessage();
        if (message == null || message.isEmpty()) {
            message = "Đã xảy ra lỗi trong quá trình xử lý";
        }

        if ("dev".equals(activeProfile) || "staging".equals(activeProfile)) {
            message += " (Mã lỗi: " + errorId + ")";
        }

        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ApiResponse.error("500", message));
    }

    // ==================== General Exception Handler ====================

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Object>> handleGeneral(Exception ex) {
        // Generate unique error ID for tracking
        String errorId = UUID.randomUUID().toString();
        log.error("Unhandled exception [errorId={}]", errorId, ex);

        // Don't expose internal error details in production
        String userMessage = "Đã xảy ra lỗi không mong muốn. Vui lòng thử lại sau.";

        // Include error ID in development/staging for debugging
        if ("dev".equals(activeProfile) || "staging".equals(activeProfile)) {
            userMessage += " (Mã lỗi: " + errorId + ")";
        }

        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ApiResponse.error("500", userMessage));
    }
}
