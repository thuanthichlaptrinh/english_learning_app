package com.thuanthichlaptrinh.card_words.common.utils;

import java.security.SecureRandom;

public class PasswordGenerator {

    private static final String LOWERCASE = "abcdefghijklmnopqrstuvwxyz";
    private static final String UPPERCASE = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private static final String DIGITS = "0123456789";
    private static final String SPECIAL_CHARS = "@$!%*?&";

    private static final String ALL_CHARS = LOWERCASE + UPPERCASE + DIGITS + SPECIAL_CHARS;
    private static final SecureRandom random = new SecureRandom();

    /**
     * Tạo mật khẩu ngẫu nhiên dễ nhớ với độ dài mặc định 6 ký tự
     * 
     * @return mật khẩu ngẫu nhiên dễ nhớ
     */
    public static String generatePassword() {
        return generateEasyPassword();
    }

    /**
     * Tạo mật khẩu dễ nhớ với format: [Chữ cái][Số][Chữ cái][Số][Chữ cái][Số]
     * Ví dụ: A1b2C3, M5n8K4
     * 
     * @return mật khẩu dễ nhớ 6 ký tự
     */
    public static String generateEasyPassword() {
        StringBuilder password = new StringBuilder(6);

        // Pattern: Chữ hoa + Số + Chữ thường + Số + Chữ hoa + Số
        password.append(UPPERCASE.charAt(random.nextInt(UPPERCASE.length())));
        password.append(DIGITS.charAt(random.nextInt(DIGITS.length())));
        password.append(LOWERCASE.charAt(random.nextInt(LOWERCASE.length())));
        password.append(DIGITS.charAt(random.nextInt(DIGITS.length())));
        password.append(UPPERCASE.charAt(random.nextInt(UPPERCASE.length())));
        password.append(DIGITS.charAt(random.nextInt(DIGITS.length())));

        return password.toString();
    }

    /**
     * Tạo mật khẩu ngẫu nhiên với độ dài tùy chỉnh (cho trường hợp cần bảo mật cao)
     * 
     * @param length
     * @return
     */
    public static String generateComplexPassword(int length) {
        if (length < 8) {
            throw new IllegalArgumentException("Độ dài mật khẩu phải tối thiểu 8 ký tự");
        }

        StringBuilder password = new StringBuilder(length);

        password.append(LOWERCASE.charAt(random.nextInt(LOWERCASE.length())));
        password.append(UPPERCASE.charAt(random.nextInt(UPPERCASE.length())));
        password.append(DIGITS.charAt(random.nextInt(DIGITS.length())));
        password.append(SPECIAL_CHARS.charAt(random.nextInt(SPECIAL_CHARS.length())));

        for (int i = 4; i < length; i++) {
            password.append(ALL_CHARS.charAt(random.nextInt(ALL_CHARS.length())));
        }

        return shuffleString(password.toString());
    }

    private static String shuffleString(String input) {
        char[] chars = input.toCharArray();

        for (int i = chars.length - 1; i > 0; i--) {
            int j = random.nextInt(i + 1);
            char temp = chars[i];
            chars[i] = chars[j];
            chars[j] = temp;
        }

        return new String(chars);
    }
}