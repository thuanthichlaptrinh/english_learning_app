package com.thuanthichlaptrinh.card_words.core.mapper;

import org.springframework.stereotype.Component;

import com.thuanthichlaptrinh.card_words.core.domain.UserVocabProgress;
import com.thuanthichlaptrinh.card_words.core.domain.Vocab;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.UserVocabProgressResponse;

@Component
public class UserVocabProgressMapper {

        public UserVocabProgressResponse toUserVocabProgressResponse(UserVocabProgress progress) {
                Vocab vocab = progress.getVocab();

                int totalAttempts = progress.getTimesCorrect() + progress.getTimesWrong();
                double accuracyRate = totalAttempts > 0
                                ? (progress.getTimesCorrect() * 100.0 / totalAttempts)
                                : 0.0;

                return UserVocabProgressResponse.builder()
                                .id(progress.getId())
                                .vocab(UserVocabProgressResponse.VocabInfo.builder()
                                                .id(vocab.getId())
                                                .word(vocab.getWord())
                                                .meaningVi(vocab.getMeaningVi())
                                                .transcription(vocab.getTranscription())
                                                .cefr(vocab.getCefr())
                                                .build())
                                .status(progress.getStatus())
                                .lastReviewed(progress.getLastReviewed())
                                .timesCorrect(progress.getTimesCorrect())
                                .timesWrong(progress.getTimesWrong())
                                .totalAttempts(totalAttempts)
                                .accuracyRate(Math.round(accuracyRate * 100.0) / 100.0)
                                .efFactor(progress.getEfFactor())
                                .intervalDays(progress.getIntervalDays())
                                .repetition(progress.getRepetition())
                                .nextReviewDate(progress.getNextReviewDate())
                                .build();
        }
}
