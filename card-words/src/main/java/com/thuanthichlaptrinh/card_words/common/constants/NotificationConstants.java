package com.thuanthichlaptrinh.card_words.common.constants;

import java.util.List;

public class NotificationConstants {

    // Notification Types - match with database and API
    public static final String VOCAB_REMINDER = "vocab_reminder"; // 📚 Nhắc nhở học từ vựng
    public static final String NEW_FEATURE = "new_feature"; // 🚀 Tính năng mới
    public static final String ACHIEVEMENT = "achievement"; // 🏆 Thành tựu đạt được
    public static final String SYSTEM_ALERT = "system_alert"; // ⚠️ Cảnh báo hệ thống
    public static final String STUDY_PROGRESS = "study_progress"; // 📈 Tiến trình học tập
    public static final String STREAK_REMINDER = "streak_reminder"; // 🔥 Nhắc nhở streak
    public static final String STREAK_MILESTONE = "streak_milestone"; // ⭐ Cột mốc streak (3, 7, 30 ngày)
    public static final String GAME_ACHIEVEMENT = "game_achievement"; // 🎮 Thành tích trong game

    // All valid notification types
    public static final List<String> VALID_TYPES = List.of(
            VOCAB_REMINDER,
            NEW_FEATURE,
            ACHIEVEMENT,
            SYSTEM_ALERT,
            STUDY_PROGRESS,
            STREAK_REMINDER,
            STREAK_MILESTONE,
            GAME_ACHIEVEMENT);

    // Filter categories for UI (if needed)
    public static final List<String> FILTER_CATEGORIES = List.of(
            "Unread",
            "Study Progress",
            "Vocabulary Reminders",
            "Streak Reminders",
            "Streak Milestones",
            "Game Achievements",
            "Achievements",
            "New Features",
            "System Alerts");

    private NotificationConstants() {
        // Prevent instantiation
    }
}
