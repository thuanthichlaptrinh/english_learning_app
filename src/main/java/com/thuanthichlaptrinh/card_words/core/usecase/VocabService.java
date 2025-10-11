package com.thuanthichlaptrinh.card_words.core.usecase;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.Type;
import com.thuanthichlaptrinh.card_words.core.domain.Topic;
import com.thuanthichlaptrinh.card_words.core.domain.Vocab;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.TypeRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.TopicRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.VocabRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateVocabRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.VocabResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class VocabService {

    private final VocabRepository vocabRepository;
    private final TypeRepository typeRepository;
    private final TopicRepository topicRepository;

    @Transactional
    public VocabResponse createVocab(CreateVocabRequest request) {
        log.info("Tạo từ vựng mới: {}", request.getWord());

        // Kiểm tra từ vựng đã tồn tại chưa
        if (vocabRepository.existsByWord(request.getWord().trim().toLowerCase())) {
            throw new ErrorException("Từ vựng '" + request.getWord() + "' đã tồn tại");
        }

        // Load hoặc tạo types từ tên
        Set<Type> types = new HashSet<>();
        if (request.getTypes() != null && !request.getTypes().isEmpty()) {
            for (String typeName : request.getTypes()) {
                String normalizedName = typeName.trim().toLowerCase();
                Type type = typeRepository.findByNameIgnoreCase(normalizedName)
                        .orElseGet(() -> {
                            log.info("Tạo Type mới: {}", normalizedName);
                            Type newType = Type.builder()
                                    .name(normalizedName)
                                    .build();
                            return typeRepository.save(newType);
                        });
                types.add(type);
            }
        }

        // Load hoặc tạo topics từ tên
        Set<Topic> topics = new HashSet<>();
        if (request.getTopics() != null && !request.getTopics().isEmpty()) {
            for (String topicName : request.getTopics()) {
                String normalizedName = topicName.trim().toLowerCase();
                Topic topic = topicRepository.findByNameIgnoreCase(normalizedName)
                        .orElseGet(() -> {
                            log.info("Tạo Topic mới: {}", normalizedName);
                            Topic newTopic = Topic.builder()
                                    .name(normalizedName)
                                    .description("Auto-generated from vocab creation")
                                    .build();
                            return topicRepository.save(newTopic);
                        });
                topics.add(topic);
            }
        }

        Vocab vocab = Vocab.builder()
                .word(request.getWord().trim().toLowerCase())
                .transcription(request.getTranscription())
                .meaningVi(request.getMeaningVi())
                .interpret(request.getInterpret())
                .exampleSentence(request.getExampleSentence())
                .cefr(request.getCefr() != null ? request.getCefr().toUpperCase() : "A1")
                .img(request.getImg())
                .audio(request.getAudio())
                .credit(request.getCredit())
                .types(types)
                .topics(topics)
                .build();

        vocab = vocabRepository.save(vocab);

        log.info("Đã tạo từ vựng thành công: {} với ID: {}", vocab.getWord(), vocab.getId());

        return mapToVocabResponse(vocab);
    }

    public VocabResponse getVocabById(UUID id) {
        log.info("Lấy thông tin từ vựng với ID: {}", id);

        Vocab vocab = vocabRepository.findByIdWithTypesAndTopics(id)
                .orElseThrow(() -> new ErrorException("Không tìm thấy từ vựng với ID: " + id));

        return mapToVocabResponse(vocab);
    }

    public VocabResponse getVocabByWord(String word) {
        log.info("Lấy thông tin từ vựng: {}", word);

        Vocab vocab = vocabRepository.findByWordWithTypesAndTopics(word.trim().toLowerCase())
                .orElseThrow(() -> new ErrorException("Không tìm thấy từ vựng: " + word));

        return mapToVocabResponse(vocab);
    }

    public Page<VocabResponse> getAllVocabs(Pageable pageable) {
        log.info("Lấy danh sách từ vựng với phân trang: {}", pageable);

        Page<Vocab> vocabs = vocabRepository.findAllWithTypesAndTopics(pageable);
        return vocabs.map(this::mapToVocabResponse);
    }

    public Page<VocabResponse> searchVocabs(String keyword, Pageable pageable) {
        log.info("Tìm kiếm từ vựng với từ khóa: {}", keyword);

        Page<Vocab> vocabs = vocabRepository.searchByKeyword(keyword, pageable);
        return vocabs.map(this::mapToVocabResponse);
    }

    public Page<VocabResponse> getVocabsByCefr(String cefr, Pageable pageable) {
        log.info("Lấy từ vựng theo CEFR level: {}", cefr);

        Page<Vocab> vocabs = vocabRepository.findByCefrWithPaging(cefr.toUpperCase(), pageable);
        return vocabs.map(this::mapToVocabResponse);
    }

    @Transactional
    public void deleteVocab(UUID id) {
        log.info("Xóa từ vựng với ID: {}", id);

        if (!vocabRepository.existsById(id)) {
            throw new ErrorException("Không tìm thấy từ vựng với ID: " + id);
        }

        vocabRepository.deleteById(id);
        log.info("Đã xóa từ vựng thành công với ID: {}", id);
    }

    private VocabResponse mapToVocabResponse(Vocab vocab) {
        Set<VocabResponse.TypeInfo> typeInfos = vocab.getTypes().stream()
                .map(type -> VocabResponse.TypeInfo.builder()
                        .id(type.getId())
                        .name(type.getName())
                        .build())
                .collect(Collectors.toSet());

        Set<VocabResponse.TopicInfo> topicInfos = vocab.getTopics().stream()
                .map(topic -> VocabResponse.TopicInfo.builder()
                        .id(topic.getId())
                        .name(topic.getName())
                        .build())
                .collect(Collectors.toSet());

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
                .topics(topicInfos)
                .build();
    }

}