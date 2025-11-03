package com.thuanthichlaptrinh.card_words.common.helper;

import com.thuanthichlaptrinh.card_words.core.domain.GameSession;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class UserLeaderboardData {
    private final User user;
    private int totalScore = 0;
    private int gamesPlayed = 0;
    private int totalCorrect = 0;
    private int totalWrong = 0;
    private LocalDateTime lastPlayedAt;

    public UserLeaderboardData(User user) {
        this.user = user;
    }

    public void addSession(GameSession session) {
        totalScore += session.getScore();
        gamesPlayed++;
        totalCorrect += session.getCorrectCount() != null ? session.getCorrectCount() : 0;

        // Tính số câu sai trong tổng số câu hỏi và số câu đúng
        int totalQuestions = session.getTotalQuestions() != null ? session.getTotalQuestions() : 0;
        int correctCount = session.getCorrectCount() != null ? session.getCorrectCount() : 0;
        totalWrong += (totalQuestions - correctCount);

        if (lastPlayedAt == null || session.getStartedAt().isAfter(lastPlayedAt)) {
            lastPlayedAt = session.getStartedAt();
        }
    }

    /**
     * Tính độ chính xác trung bình trên tất cả các phiên
     */
    public double getAverageAccuracy() {
        if (totalCorrect + totalWrong == 0)
            return 0.0;
        return Math.round((totalCorrect * 100.0 / (totalCorrect + totalWrong)) * 100.0) / 100.0;
    }
}
