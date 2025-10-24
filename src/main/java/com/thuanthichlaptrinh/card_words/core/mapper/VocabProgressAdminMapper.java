package com.thuanthichlaptrinh.card_words.core.mapper;

import org.springframework.stereotype.Component;

import com.thuanthichlaptrinh.card_words.core.domain.UserVocabProgress;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.UserVocabProgressAdminResponse;

@Component
public class VocabProgressAdminMapper {

    public UserVocabProgressAdminResponse toUserVocabProgressAdminResponse(UserVocabProgress progress) {
        int total = progress.getTimesCorrect() + progress.getTimesWrong();
        double accuracy = total > 0 ? (progress.getTimesCorrect() * 100.0 / total) : 0;

        return UserVocabProgressAdminResponse.builder()
                .id(progress.getId())
                .userId(progress.getUser().getId())
                .userName(progress.getUser().getName())
                .vocabId(progress.getVocab().getId())
                .word(progress.getVocab().getWord())
                .meaningVi(progress.getVocab().getMeaningVi())
                .cefr(progress.getVocab().getCefr())
                .timesCorrect(progress.getTimesCorrect())
                .timesWrong(progress.getTimesWrong())
                .accuracy(accuracy)
                .createdAt(progress.getCreatedAt())
                .updatedAt(progress.getUpdatedAt())
                .build();
    }
}
