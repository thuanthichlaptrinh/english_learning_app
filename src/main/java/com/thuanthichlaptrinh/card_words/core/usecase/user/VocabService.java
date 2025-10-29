package com.thuanthichlaptrinh.card_words.core.usecase.user;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.Type;
import com.thuanthichlaptrinh.card_words.core.domain.Topic;
import com.thuanthichlaptrinh.card_words.core.domain.Vocab;
import com.thuanthichlaptrinh.card_words.core.mapper.VocabMapper;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.TypeRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.TopicRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.VocabRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.vocab.BulkCreateVocabRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.vocab.CreateVocabRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.vocab.UpdateVocabRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.BulkImportResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.vocab.VocabMediaUrlResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.vocab.VocabResponse;

import java.util.ArrayList;
import java.util.List;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class VocabService {

    private final VocabRepository vocabRepository;
    private final TypeRepository typeRepository;
    private final TopicRepository topicRepository;
    private final VocabMapper vocabMapper;

    @Transactional
    public BulkImportResponse bulkCreateVocabs(BulkCreateVocabRequest request) {
        log.info("Bắt đầu import hàng loạt {} từ vựng", request.getVocabs().size());

        int successCount = 0;
        int failedCount = 0;
        int skippedCount = 0;
        List<BulkImportResponse.ImportError> errors = new ArrayList<>();

        for (int i = 0; i < request.getVocabs().size(); i++) {
            BulkCreateVocabRequest.VocabImportItem item = request.getVocabs().get(i);
            int lineNumber = i + 1;

            try {
                // Kiểm tra từ vựng đã tồn tại chưa
                if (vocabRepository.existsByWord(item.getWord().trim().toLowerCase())) {
                    skippedCount++;
                    errors.add(BulkImportResponse.ImportError.builder()
                            .word(item.getWord())
                            .reason("Từ vựng đã tồn tại")
                            .lineNumber(lineNumber)
                            .build());
                    continue;
                }

                // Tạo từ vựng mới
                CreateVocabRequest createRequest = CreateVocabRequest.builder()
                        .word(item.getWord())
                        .transcription(item.getTranscription())
                        .meaningVi(item.getMeaningVi())
                        .interpret(item.getInterpret())
                        .exampleSentence(item.getExampleSentence())
                        .cefr(item.getCefr())
                        .img(item.getImg())
                        .audio(item.getAudio())
                        .credit(item.getCredit())
                        .types(item.getTypes() != null ? new HashSet<>(item.getTypes()) : null)
                        .topics(item.getTopics() != null ? new HashSet<>(item.getTopics()) : null)
                        .build();

                createVocab(createRequest);
                successCount++;

            } catch (Exception e) {
                failedCount++;
                errors.add(BulkImportResponse.ImportError.builder()
                        .word(item.getWord())
                        .reason(e.getMessage())
                        .lineNumber(lineNumber)
                        .build());
                log.error("Lỗi khi import từ vựng '{}': {}", item.getWord(), e.getMessage());
            }
        }

        log.info("Import hoàn tất. Thành công: {}, Thất bại: {}, Bỏ qua: {}",
                successCount, failedCount, skippedCount);

        return BulkImportResponse.builder()
                .totalRequested(request.getVocabs().size())
                .successCount(successCount)
                .failedCount(failedCount)
                .skippedCount(skippedCount)
                .errors(errors)
                .build();
    }

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

        return vocabMapper.toVocabResponse(vocab);
    }

    public VocabResponse getVocabById(UUID id) {
        log.info("Lấy thông tin từ vựng với ID: {}", id);

        Vocab vocab = vocabRepository.findByIdWithTypesAndTopics(id)
                .orElseThrow(() -> new ErrorException("Không tìm thấy từ vựng với ID: " + id));

        return vocabMapper.toVocabResponse(vocab);
    }

    public VocabResponse getVocabByWord(String word) {
        log.info("Lấy thông tin từ vựng: {}", word);

        Vocab vocab = vocabRepository.findByWordWithTypesAndTopics(word.trim().toLowerCase())
                .orElseThrow(() -> new ErrorException("Không tìm thấy từ vựng: " + word));

        return vocabMapper.toVocabResponse(vocab);
    }

    public Page<VocabResponse> getAllVocabs(Pageable pageable) {
        log.info("Lấy danh sách từ vựng với phân trang: {}", pageable);

        Page<Vocab> vocabs = vocabRepository.findAllWithTypesAndTopics(pageable);
        return vocabs.map(vocabMapper::toVocabResponse);
    }

    public Page<VocabResponse> searchVocabs(String keyword, Pageable pageable) {
        log.info("Tìm kiếm từ vựng với từ khóa: {}", keyword);

        Page<Vocab> vocabs = vocabRepository.searchByKeyword(keyword, pageable);
        return vocabs.map(vocabMapper::toVocabResponse);
    }

    public Page<VocabResponse> getVocabsByCefr(String cefr, Pageable pageable) {
        log.info("Lấy từ vựng theo CEFR level: {}", cefr);

        Page<Vocab> vocabs = vocabRepository.findByCefrWithPaging(cefr.toUpperCase(), pageable);
        return vocabs.map(vocabMapper::toVocabResponse);
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

    @Transactional
    public VocabResponse updateVocab(UUID id, UpdateVocabRequest request) {
        log.info("Cập nhật từ vựng với ID: {}", id);

        // Tìm vocab cần update
        Vocab vocab = vocabRepository.findById(id)
                .orElseThrow(() -> new ErrorException("Không tìm thấy từ vựng với ID: " + id));

        // Kiểm tra nếu đổi từ thì từ mới không được trùng với từ khác
        if (request.getWord() != null && !request.getWord().trim().isEmpty()) {
            if (!vocab.getWord().equalsIgnoreCase(request.getWord().trim())) {
                if (vocabRepository.existsByWord(request.getWord().trim().toLowerCase())) {
                    throw new ErrorException("Từ vựng '" + request.getWord() + "' đã tồn tại");
                }
                vocab.setWord(request.getWord().trim().toLowerCase());
            }
        }

        // Cập nhật các field nếu có giá trị (không null và không empty)
        if (request.getTranscription() != null && !request.getTranscription().trim().isEmpty()) {
            vocab.setTranscription(request.getTranscription());
        }

        if (request.getMeaningVi() != null && !request.getMeaningVi().trim().isEmpty()) {
            vocab.setMeaningVi(request.getMeaningVi());
        }

        if (request.getInterpret() != null && !request.getInterpret().trim().isEmpty()) {
            vocab.setInterpret(request.getInterpret());
        }

        if (request.getExampleSentence() != null && !request.getExampleSentence().trim().isEmpty()) {
            vocab.setExampleSentence(request.getExampleSentence());
        }

        if (request.getCefr() != null && !request.getCefr().trim().isEmpty()) {
            vocab.setCefr(request.getCefr());
        }

        if (request.getImg() != null && !request.getImg().trim().isEmpty()) {
            vocab.setImg(request.getImg());
        }

        if (request.getAudio() != null && !request.getAudio().trim().isEmpty()) {
            vocab.setAudio(request.getAudio());
        }

        if (request.getCredit() != null && !request.getCredit().trim().isEmpty()) {
            vocab.setCredit(request.getCredit());
        }

        // Update types nếu có
        if (request.getTypes() != null) {
            Set<Type> types = new HashSet<>();
            for (String typeName : request.getTypes()) {
                String normalizedName = typeName.trim().toLowerCase();
                Type type = typeRepository.findByNameIgnoreCase(normalizedName)
                        .orElseGet(() -> {
                            log.info("Tạo type mới: {}", normalizedName);
                            Type newType = Type.builder()
                                    .name(normalizedName)
                                    .build();
                            return typeRepository.save(newType);
                        });
                types.add(type);
            }
            vocab.setTypes(types);
        }

        // Update topics nếu có
        if (request.getTopics() != null) {
            Set<Topic> topics = new HashSet<>();
            for (String topicName : request.getTopics()) {
                String normalizedName = topicName.trim().toLowerCase();
                Topic topic = topicRepository.findByNameIgnoreCase(normalizedName)
                        .orElseGet(() -> {
                            log.info("Tạo topic mới: {}", normalizedName);
                            Topic newTopic = Topic.builder()
                                    .name(normalizedName)
                                    .build();
                            return topicRepository.save(newTopic);
                        });
                topics.add(topic);
            }
            vocab.setTopics(topics);
        }

        Vocab updatedVocab = vocabRepository.save(vocab);
        log.info("Đã cập nhật từ vựng thành công: {}", updatedVocab.getWord());

        return vocabMapper.toVocabResponse(updatedVocab);
    }

    @Transactional
    public VocabResponse updateVocabByWord(String word, UpdateVocabRequest request) {
        log.info("Cập nhật từ vựng theo từ: {}", word);

        // Tìm vocab theo word
        Vocab vocab = vocabRepository.findByWord(word.trim().toLowerCase())
                .orElseThrow(() -> new ErrorException("Không tìm thấy từ vựng: " + word));

        // Kiểm tra nếu đổi từ thì từ mới không được trùng với từ khác
        if (request.getWord() != null && !request.getWord().trim().isEmpty()) {
            if (!vocab.getWord().equalsIgnoreCase(request.getWord().trim())) {
                if (vocabRepository.existsByWord(request.getWord().trim().toLowerCase())) {
                    throw new ErrorException("Từ vựng '" + request.getWord() + "' đã tồn tại");
                }
                vocab.setWord(request.getWord().trim().toLowerCase());
            }
        }

        // Cập nhật các field nếu có giá trị (không null và không empty)
        if (request.getTranscription() != null && !request.getTranscription().trim().isEmpty()) {
            vocab.setTranscription(request.getTranscription());
        }

        if (request.getMeaningVi() != null && !request.getMeaningVi().trim().isEmpty()) {
            vocab.setMeaningVi(request.getMeaningVi());
        }

        if (request.getInterpret() != null && !request.getInterpret().trim().isEmpty()) {
            vocab.setInterpret(request.getInterpret());
        }

        if (request.getExampleSentence() != null && !request.getExampleSentence().trim().isEmpty()) {
            vocab.setExampleSentence(request.getExampleSentence());
        }

        if (request.getCefr() != null && !request.getCefr().trim().isEmpty()) {
            vocab.setCefr(request.getCefr());
        }

        if (request.getImg() != null && !request.getImg().trim().isEmpty()) {
            vocab.setImg(request.getImg());
        }

        if (request.getAudio() != null && !request.getAudio().trim().isEmpty()) {
            vocab.setAudio(request.getAudio());
        }

        if (request.getCredit() != null && !request.getCredit().trim().isEmpty()) {
            vocab.setCredit(request.getCredit());
        }

        // Update types nếu có
        if (request.getTypes() != null && !request.getTypes().isEmpty()) {
            Set<Type> types = new HashSet<>();
            for (String typeName : request.getTypes()) {
                String normalizedName = typeName.trim().toLowerCase();
                Type type = typeRepository.findByNameIgnoreCase(normalizedName)
                        .orElseGet(() -> {
                            log.info("Tạo type mới: {}", normalizedName);
                            Type newType = Type.builder()
                                    .name(normalizedName)
                                    .build();
                            return typeRepository.save(newType);
                        });
                types.add(type);
            }
            vocab.setTypes(types);
        }

        // Update topics nếu có
        if (request.getTopics() != null && !request.getTopics().isEmpty()) {
            Set<Topic> topics = new HashSet<>();
            for (String topicName : request.getTopics()) {
                String normalizedName = topicName.trim().toLowerCase();
                Topic topic = topicRepository.findByNameIgnoreCase(normalizedName)
                        .orElseGet(() -> {
                            log.info("Tạo topic mới: {}", normalizedName);
                            Topic newTopic = Topic.builder()
                                    .name(normalizedName)
                                    .build();
                            return topicRepository.save(newTopic);
                        });
                topics.add(topic);
            }
            vocab.setTopics(topics);
        }

        Vocab updatedVocab = vocabRepository.save(vocab);
        log.info("Đã cập nhật từ vựng thành công: {}", updatedVocab.getWord());

        return vocabMapper.toVocabResponse(updatedVocab);
    }

    @Transactional
    public void bulkUpdateMediaUrls(String word, String imageUrl, String audioUrl) {
        log.info("Bulk update media cho từ: {}", word);

        Vocab vocab = vocabRepository.findByWord(word.trim().toLowerCase())
                .orElse(null);

        if (vocab == null) {
            log.warn("Không tìm thấy từ vựng: {}", word);
            return;
        }

        boolean updated = false;

        if (imageUrl != null && !imageUrl.trim().isEmpty()) {
            vocab.setImg(imageUrl);
            updated = true;
            log.info("Cập nhật image cho từ '{}': {}", word, imageUrl);
        }

        if (audioUrl != null && !audioUrl.trim().isEmpty()) {
            vocab.setAudio(audioUrl);
            updated = true;
            log.info("Cập nhật audio cho từ '{}': {}", word, audioUrl);
        }

        if (updated) {
            vocabRepository.save(vocab);
            log.info("Đã lưu cập nhật media cho từ: {}", word);
        }
    }

    // Get media URLs (image and audio) for a vocab by ID
    @Transactional(readOnly = true)
    public VocabMediaUrlResponse getVocabMediaUrls(UUID id) {
        log.info("Lấy media URLs cho vocab với ID: {}", id);

        Vocab vocab = vocabRepository.findById(id)
                .orElseThrow(() -> new ErrorException("Không tìm thấy từ vựng với ID: " + id));

        return vocabMapper.toVocabMediaUrlResponse(vocab);
    }

    // Get media URLs (image and audio) for a vocab by word
    @Transactional(readOnly = true)
    public VocabMediaUrlResponse getVocabMediaUrlsByWord(String word) {
        log.info("Lấy media URLs cho vocab với từ: {}", word);

        Vocab vocab = vocabRepository.findByWord(word.trim().toLowerCase())
                .orElseThrow(() -> new ErrorException("Không tìm thấy từ vựng: " + word));

        return vocabMapper.toVocabMediaUrlResponse(vocab);
    }

}