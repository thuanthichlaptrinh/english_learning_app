package com.thuanthichlaptrinh.card_words.common.exceptions;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class ErrorException extends RuntimeException {
    private Exceptions errorCode;
}
