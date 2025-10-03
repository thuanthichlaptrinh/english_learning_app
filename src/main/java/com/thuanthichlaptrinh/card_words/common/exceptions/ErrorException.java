package com.thuanthichlaptrinh.card_words.common.exceptions;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ErrorException extends RuntimeException {
    private Exceptions errorCode;

    public ErrorException(Exceptions errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
    }

    public ErrorException(String message) {
        super(message);
    }

    public ErrorException(Exceptions errorCode, String customMessage) {
        super(customMessage);
        this.errorCode = errorCode;
    }
}
