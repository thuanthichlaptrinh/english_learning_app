package com.thuanthichlaptrinh.card_words.entrypoint.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DailyVocabStatsResponse {
    private String dayName; // Thứ trong tuần (Monday, Tuesday, Wednesday, ...)
    private Long count; // Số từ học được trong ngày
    private LocalDate date; // Ngày (YYYY-MM-DD)
}
