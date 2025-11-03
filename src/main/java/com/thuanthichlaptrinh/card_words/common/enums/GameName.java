package com.thuanthichlaptrinh.card_words.common.enums;

public enum GameName {
    QUICK_QUIZ("Quick Quiz", "Trắc nghiệm nhanh"),
    IMAGE_WORD_MATCHING("Image Word Matching", "Ghép hình với từ"),
    WORD_DEFINITION_MATCHING("Word Definition Matching", "Ghép từ với nghĩa");

    private final String displayName;
    private final String displayNameVi;

    GameName(String displayName, String displayNameVi) {
        this.displayName = displayName;
        this.displayNameVi = displayNameVi;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getDisplayNameVi() {
        return displayNameVi;
    }
}

