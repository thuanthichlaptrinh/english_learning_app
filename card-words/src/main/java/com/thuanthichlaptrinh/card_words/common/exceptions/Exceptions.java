package com.thuanthichlaptrinh.card_words.common.exceptions;

import org.springframework.http.HttpStatus;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum Exceptions {
    PASSWORD_INVALID("999", "Mật khẩu không hợp lệ", HttpStatus.BAD_REQUEST),
    USER_EXISTS("1000", "Người dùng đã tồn tại", HttpStatus.CONFLICT),
    NOTFOUND_ERROR("1001", "Không tìm thấy tài nguyên", HttpStatus.NOT_FOUND),
    INVALID_REQUEST("1002", "Yêu cầu không hợp lệ", HttpStatus.BAD_REQUEST),
    INVALID_TOKEN("1003", "Token không hợp lệ hoặc đã hết hạn", HttpStatus.UNAUTHORIZED),
    INVALID_EMAIL("1004", "Định dạng email không hợp lệ", HttpStatus.BAD_REQUEST),
    EMAIL_EXISTS("1009", "Email đã được sử dụng", HttpStatus.CONFLICT);

    private final String code;
    private final String message;
    private final HttpStatus statusCode;

}
