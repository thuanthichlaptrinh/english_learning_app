package com.thuanthichlaptrinh.card_words.common.constants;

public final class PasswordConstants {

    private PasswordConstants() {
        // prevent instantiation
    }

    public static final int MIN_LENGTH = 6;
    public static final int MAX_LENGTH = 100;

    public static final String LENGTH_MESSAGE = "Mật khẩu phải từ " + MIN_LENGTH + " đến " + MAX_LENGTH + " ký tự";

    // Nếu bạn muốn message tiếng Anh nữa thì thêm
    public static final String LENGTH_MESSAGE_EN = "Password must be between " + MIN_LENGTH + " and " + MAX_LENGTH
            + " characters";
}