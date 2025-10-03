package com.thuanthichlaptrinh.card_words.core.usecase;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.Topic;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.TopicRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateTopicRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.TopicResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class TopicService {

    private final TopicRepository topicRepository;

    @Transactional
    public TopicResponse createTopic(CreateTopicRequest request) {
        log.info("Tạo chủ đề mới: {}", request.getName());

        // Kiểm tra trùng tên
        if (topicRepository.existsByName(request.getName())) {
            throw new ErrorException("Chủ đề đã tồn tại: " + request.getName());
        }

        Topic topic = Topic.builder()
                .name(request.getName())
                .description(request.getDescription())
                .build();

        topic = topicRepository.save(topic);

        log.info("Đã tạo chủ đề thành công: {}", topic.getName());

        return TopicResponse.builder()
                .id(topic.getId())
                .name(topic.getName())
                .description(topic.getDescription())
                .build();
    }

    public List<TopicResponse> getAllTopics() {
        log.info("Lấy danh sách tất cả chủ đề");

        return topicRepository.findAll().stream()
                .map(topic -> TopicResponse.builder()
                        .id(topic.getId())
                        .name(topic.getName())
                        .description(topic.getDescription())
                        .build())
                .collect(Collectors.toList());
    }

    public TopicResponse getTopicById(Long id) {
        log.info("Lấy thông tin chủ đề: {}", id);

        Topic topic = topicRepository.findById(id)
                .orElseThrow(() -> new ErrorException("Không tìm thấy chủ đề với ID: " + id));

        return TopicResponse.builder()
                .id(topic.getId())
                .name(topic.getName())
                .description(topic.getDescription())
                .build();
    }

    @Transactional
    public void deleteTopic(Long id) {
        log.info("Xóa chủ đề: {}", id);

        if (!topicRepository.existsById(id)) {
            throw new ErrorException("Không tìm thấy chủ đề với ID: " + id);
        }

        topicRepository.deleteById(id);
        log.info("Đã xóa chủ đề thành công: {}", id);
    }
}