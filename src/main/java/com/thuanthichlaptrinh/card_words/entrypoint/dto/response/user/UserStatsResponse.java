package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user;

import com.thuanthichlaptrinh.card_words.core.domain.GameSession;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
public class UserStatsResponse {

    private final User user;
    private int totalScore = 0;
    private int gamesPlayed = 0;
    private double totalAccuracy = 0.0;
    private LocalDateTime lastPlayedAt;

    public UserStatsResponse(User user) {
        if (user == null) {
            throw new IllegalArgumentException("User cannot be null");
        }
        this.user = user;
    }

    /**
     * Add a game session to this user's stats
     */
    public void addSession(GameSession session) {
        if (session == null) {
            return;
        }

        this.totalScore += session.getScore() != null ? session.getScore() : 0;
        this.gamesPlayed++;

        if (session.getAccuracy() != null) {
            this.totalAccuracy += session.getAccuracy();
        }

        if (session.getStartedAt() != null) {
            if (this.lastPlayedAt == null || session.getStartedAt().isAfter(this.lastPlayedAt)) {
                this.lastPlayedAt = session.getStartedAt();
            }
        }
    }

    /**
     * Calculate average accuracy across all played games
     */
    public double getAverageAccuracy() {
        if (gamesPlayed == 0) {
            return 0.0;
        }
        return Math.round((totalAccuracy / gamesPlayed) * 100.0) / 100.0;
    }

    /**
     * Get average score per game
     */
    public double getAverageScore() {
        if (gamesPlayed == 0) {
            return 0.0;
        }
        return Math.round(((double) totalScore / gamesPlayed) * 100.0) / 100.0;
    }
}
