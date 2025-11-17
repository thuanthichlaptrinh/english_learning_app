package com.thuanthichlaptrinh.card_words.core.util;

import com.thuanthichlaptrinh.card_words.common.enums.VocabStatus;
import com.thuanthichlaptrinh.card_words.common.utils.VocabStatusCalculator;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.domain.UserVocabProgress;
import com.thuanthichlaptrinh.card_words.core.domain.Vocab;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("VocabStatusCalculator Tests")
class VocabStatusCalculatorTest {

    @Test
    @DisplayName("Should set status to NEW for first time record")
    void whenFirstPlayGame_shouldSetStatusToNew() {
        // Given: currentStatus = null (first time)
        VocabStatus currentStatus = null;
        int timesCorrect = 1;
        int timesWrong = 0;

        // When
        VocabStatus newStatus = VocabStatusCalculator.calculateStatus(
                currentStatus, timesCorrect, timesWrong);

        // Then
        assertEquals(VocabStatus.NEW, newStatus);
    }

    @Test
    @DisplayName("Should keep status NEW when playing again but not mastered")
    void whenPlayAgain_shouldKeepStatusIfNotMastered() {
        // Given: Record exists with status = NEW
        VocabStatus currentStatus = VocabStatus.NEW;
        int timesCorrect = 5;
        int timesWrong = 2;

        // When
        VocabStatus newStatus = VocabStatusCalculator.calculateStatus(
                currentStatus, timesCorrect, timesWrong);

        // Then
        assertEquals(VocabStatus.NEW, newStatus);
    }

    @Test
    @DisplayName("Should auto upgrade to MASTERED when reaching condition")
    void whenReachMasteredCondition_shouldAutoUpgrade() {
        // Given: timesCorrect = 10, timesWrong = 1, accuracy = 90.9%
        VocabStatus currentStatus = VocabStatus.NEW;
        int timesCorrect = 10;
        int timesWrong = 1;

        // When
        VocabStatus newStatus = VocabStatusCalculator.calculateStatus(
                currentStatus, timesCorrect, timesWrong);

        // Then
        assertEquals(VocabStatus.MASTERED, newStatus);
    }

    @Test
    @DisplayName("Should NOT downgrade from MASTERED")
    void whenMastered_shouldNotDowngrade() {
        // Given: Status = MASTERED
        VocabStatus currentStatus = VocabStatus.MASTERED;
        int timesCorrect = 10;
        int timesWrong = 5; // Wrong increased but still should keep MASTERED

        // When
        VocabStatus newStatus = VocabStatusCalculator.calculateStatus(
                currentStatus, timesCorrect, timesWrong);

        // Then
        assertEquals(VocabStatus.MASTERED, newStatus);
    }

    @Test
    @DisplayName("Should keep KNOWN status when not reaching MASTERED")
    void whenKnown_shouldKeepKnownIfNotMastered() {
        // Given: Status = KNOWN (set by Learn Vocab API)
        VocabStatus currentStatus = VocabStatus.KNOWN;
        int timesCorrect = 5;
        int timesWrong = 1;

        // When
        VocabStatus newStatus = VocabStatusCalculator.calculateStatus(
                currentStatus, timesCorrect, timesWrong);

        // Then
        assertEquals(VocabStatus.KNOWN, newStatus);
    }

    @Test
    @DisplayName("Should keep UNKNOWN status when not reaching MASTERED")
    void whenUnknown_shouldKeepUnknownIfNotMastered() {
        // Given: Status = UNKNOWN (set by Learn Vocab API)
        VocabStatus currentStatus = VocabStatus.UNKNOWN;
        int timesCorrect = 3;
        int timesWrong = 5;

        // When
        VocabStatus newStatus = VocabStatusCalculator.calculateStatus(
                currentStatus, timesCorrect, timesWrong);

        // Then
        assertEquals(VocabStatus.UNKNOWN, newStatus);
    }

    @Test
    @DisplayName("Should upgrade KNOWN to MASTERED when reaching condition")
    void whenKnownReachMasteredCondition_shouldUpgrade() {
        // Given: Status = KNOWN, reaching mastered condition
        VocabStatus currentStatus = VocabStatus.KNOWN;
        int timesCorrect = 10;
        int timesWrong = 2;

        // When
        VocabStatus newStatus = VocabStatusCalculator.calculateStatus(
                currentStatus, timesCorrect, timesWrong);

        // Then
        assertEquals(VocabStatus.MASTERED, newStatus);
    }

    @Test
    @DisplayName("Should upgrade UNKNOWN to MASTERED when reaching condition")
    void whenUnknownReachMasteredCondition_shouldUpgrade() {
        // Given: Status = UNKNOWN, but after practice reaching mastered condition
        VocabStatus currentStatus = VocabStatus.UNKNOWN;
        int timesCorrect = 12;
        int timesWrong = 1;

        // When
        VocabStatus newStatus = VocabStatusCalculator.calculateStatus(
                currentStatus, timesCorrect, timesWrong);

        // Then
        assertEquals(VocabStatus.MASTERED, newStatus);
    }

    // ========== Tests for isMastered() ==========

    @Test
    @DisplayName("Should return true when exactly meeting mastered condition")
    void whenExactlyMeetCondition_shouldBeMastered() {
        // Given: Minimum condition: 10 correct, 2 wrong, 83.3% accuracy
        int timesCorrect = 10;
        int timesWrong = 2;

        // When
        boolean isMastered = VocabStatusCalculator.isMastered(timesCorrect, timesWrong);

        // Then
        assertTrue(isMastered);
    }

    @Test
    @DisplayName("Should return false when timesCorrect < 10")
    void whenLessThan10Correct_shouldNotBeMastered() {
        // Given: Only 9 correct (less than required)
        int timesCorrect = 9;
        int timesWrong = 0;

        // When
        boolean isMastered = VocabStatusCalculator.isMastered(timesCorrect, timesWrong);

        // Then
        assertFalse(isMastered);
    }

    @Test
    @DisplayName("Should return false when timesWrong > 2")
    void whenMoreThan2Wrong_shouldNotBeMastered() {
        // Given: Too many wrong answers
        int timesCorrect = 10;
        int timesWrong = 3;

        // When
        boolean isMastered = VocabStatusCalculator.isMastered(timesCorrect, timesWrong);

        // Then
        assertFalse(isMastered);
    }

    @Test
    @DisplayName("Should return false when accuracy < 80%")
    void whenAccuracyLessThan80_shouldNotBeMastered() {
        // Given: 10 correct, 3 wrong = 76.9% accuracy
        int timesCorrect = 10;
        int timesWrong = 3;

        // When
        boolean isMastered = VocabStatusCalculator.isMastered(timesCorrect, timesWrong);

        // Then
        assertFalse(isMastered);
    }

    @Test
    @DisplayName("Should return false when no attempts")
    void whenNoAttempts_shouldNotBeMastered() {
        // Given: No attempts yet
        int timesCorrect = 0;
        int timesWrong = 0;

        // When
        boolean isMastered = VocabStatusCalculator.isMastered(timesCorrect, timesWrong);

        // Then
        assertFalse(isMastered);
    }

    // ========== Tests for calculateAccuracy() ==========

    @Test
    @DisplayName("Should calculate accuracy correctly")
    void shouldCalculateAccuracyCorrectly() {
        // Given
        int timesCorrect = 8;
        int timesWrong = 2;

        // When
        double accuracy = VocabStatusCalculator.calculateAccuracy(timesCorrect, timesWrong);

        // Then
        assertEquals(0.8, accuracy, 0.001); // 8/10 = 0.8
    }

    @Test
    @DisplayName("Should return 0 accuracy when no attempts")
    void whenNoAttempts_shouldReturn0Accuracy() {
        // Given
        int timesCorrect = 0;
        int timesWrong = 0;

        // When
        double accuracy = VocabStatusCalculator.calculateAccuracy(timesCorrect, timesWrong);

        // Then
        assertEquals(0.0, accuracy);
    }

    @Test
    @DisplayName("Should return 1.0 accuracy when all correct")
    void whenAllCorrect_shouldReturn100Accuracy() {
        // Given
        int timesCorrect = 10;
        int timesWrong = 0;

        // When
        double accuracy = VocabStatusCalculator.calculateAccuracy(timesCorrect, timesWrong);

        // Then
        assertEquals(1.0, accuracy);
    }

    @Test
    @DisplayName("Should calculate accuracy from UserVocabProgress")
    void shouldCalculateAccuracyFromProgress() {
        // Given
        UserVocabProgress progress = UserVocabProgress.builder()
                .user(new User())
                .vocab(new Vocab())
                .timesCorrect(7)
                .timesWrong(3)
                .build();

        // When
        double accuracy = VocabStatusCalculator.calculateAccuracy(progress);

        // Then
        assertEquals(0.7, accuracy, 0.001); // 7/10 = 0.7
    }

    // ========== Tests for formatAccuracy() ==========

    @Test
    @DisplayName("Should format accuracy as percentage string")
    void shouldFormatAccuracyAsPercentage() {
        // Given
        int timesCorrect = 8;
        int timesWrong = 2;

        // When
        String formatted = VocabStatusCalculator.formatAccuracy(timesCorrect, timesWrong);

        // Then
        assertEquals("80.0%", formatted);
    }

    @Test
    @DisplayName("Should format 0% correctly")
    void shouldFormat0Percent() {
        // Given
        int timesCorrect = 0;
        int timesWrong = 5;

        // When
        String formatted = VocabStatusCalculator.formatAccuracy(timesCorrect, timesWrong);

        // Then
        assertEquals("0.0%", formatted);
    }

    @Test
    @DisplayName("Should format 100% correctly")
    void shouldFormat100Percent() {
        // Given
        int timesCorrect = 10;
        int timesWrong = 0;

        // When
        String formatted = VocabStatusCalculator.formatAccuracy(timesCorrect, timesWrong);

        // Then
        assertEquals("100.0%", formatted);
    }

    // ========== Tests for getStatusDescription() ==========

    @Test
    @DisplayName("Should return correct description for each status")
    void shouldReturnCorrectDescriptionForEachStatus() {
        assertEquals("Từ mới", VocabStatusCalculator.getStatusDescription(VocabStatus.NEW));
        assertEquals("Đã biết", VocabStatusCalculator.getStatusDescription(VocabStatus.KNOWN));
        assertEquals("Chưa biết", VocabStatusCalculator.getStatusDescription(VocabStatus.UNKNOWN));
        assertEquals("Đã thành thạo", VocabStatusCalculator.getStatusDescription(VocabStatus.MASTERED));
        assertEquals("Chưa học", VocabStatusCalculator.getStatusDescription(null));
    }

    // ========== Tests for isLearned() ==========

    @Test
    @DisplayName("Should return true when progress has at least 1 attempt")
    void whenHasAttempt_shouldBeLearned() {
        // Given
        UserVocabProgress progress = UserVocabProgress.builder()
                .user(new User())
                .vocab(new Vocab())
                .timesCorrect(1)
                .timesWrong(0)
                .build();

        // When
        boolean isLearned = VocabStatusCalculator.isLearned(progress);

        // Then
        assertTrue(isLearned);
    }

    @Test
    @DisplayName("Should return false when progress has no attempts")
    void whenNoAttempt_shouldNotBeLearned() {
        // Given
        UserVocabProgress progress = UserVocabProgress.builder()
                .user(new User())
                .vocab(new Vocab())
                .timesCorrect(0)
                .timesWrong(0)
                .build();

        // When
        boolean isLearned = VocabStatusCalculator.isLearned(progress);

        // Then
        assertFalse(isLearned);
    }

    @Test
    @DisplayName("Should return false when progress is null")
    void whenProgressNull_shouldNotBeLearned() {
        // Given
        UserVocabProgress progress = null;

        // When
        boolean isLearned = VocabStatusCalculator.isLearned(progress);

        // Then
        assertFalse(isLearned);
    }
}
