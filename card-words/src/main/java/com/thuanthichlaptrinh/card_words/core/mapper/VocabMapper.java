package com.thuanthichlaptrinh.card_words.core.mapper;

import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

import com.thuanthichlaptrinh.card_words.core.domain.Vocab;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.vocab.VocabMediaUrlResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.vocab.VocabResponse;

@Component
public class VocabMapper {

        public VocabResponse toVocabResponse(Vocab vocab) {
                Set<VocabResponse.TypeInfo> typeInfos = vocab.getTypes().stream()
                                .map(type -> VocabResponse.TypeInfo.builder()
                                                .id(type.getId())
                                                .name(type.getName())
                                                .build())
                                .collect(Collectors.toSet());

                // Convert topic to TopicInfo (1-1 relationship)
                VocabResponse.TopicInfo topicInfo = vocab.getTopic() != null
                                ? VocabResponse.TopicInfo.builder()
                                                .id(vocab.getTopic().getId())
                                                .name(vocab.getTopic().getName())
                                                .build()
                                : null;

                return VocabResponse.builder()
                                .id(vocab.getId())
                                .word(vocab.getWord())
                                .transcription(vocab.getTranscription())
                                .meaningVi(vocab.getMeaningVi())
                                .interpret(vocab.getInterpret())
                                .exampleSentence(vocab.getExampleSentence())
                                .cefr(vocab.getCefr())
                                .img(vocab.getImg())
                                .audio(vocab.getAudio())
                                .credit(vocab.getCredit())
                                .createdAt(vocab.getCreatedAt())
                                .updatedAt(vocab.getUpdatedAt())
                                .types(typeInfos)
                                .topic(topicInfo)
                                .build();
        }

        public VocabMediaUrlResponse toVocabMediaUrlResponse(Vocab vocab) {
                return VocabMediaUrlResponse.builder()
                                .vocabId(vocab.getId())
                                .word(vocab.getWord())
                                .imageUrl(vocab.getImg())
                                .audioUrl(vocab.getAudio())
                                .hasImage(vocab.getImg() != null && !vocab.getImg().isEmpty())
                                .hasAudio(vocab.getAudio() != null && !vocab.getAudio().isEmpty())
                                .build();
        }
}
