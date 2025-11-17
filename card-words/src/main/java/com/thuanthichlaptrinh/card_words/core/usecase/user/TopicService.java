package com.thuanthichlaptrinh.card_words.core.usecase.user;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.common.helper.TopicProgressCalculator;
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
    private final TopicProgressCalculator topicProgressCalculator;

    @Transactional
    public TopicResponse createTopic(CreateTopicRequest request) {
        log.info("Tạo chủ đề mới: {}", request.getName());

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

    /**
     * Lấy danh sách tất cả chủ đề với tiến độ học của user
     * 
     * @param userId ID của user đang đăng nhập, có thể null nếu chưa đăng nhập
     */
    public List<TopicResponse> getAllTopics(UUID userId) {
        log.info("Lấy danh sách tất cả chủ đề cho user: {}", userId);

        return topicRepository.findAll().stream()
                .map(topic -> buildTopicResponse(topic, userId))
                .collect(Collectors.toList());
    }

    /**
     * Lấy thông tin chi tiết một chủ đề với tiến độ học của user
     * 
     * @param id     ID của topic
     * @param userId ID của user đang đăng nhập, có thể null nếu chưa đăng nhập
     */
    public TopicResponse getTopicById(Long id, UUID userId) {
        log.info("Lấy thông tin chủ đề: {} cho user: {}", id, userId);

        Topic topic = topicRepository.findById(id)
                .orElseThrow(() -> new ErrorException("Không tìm thấy chủ đề với ID: " + id));

        return buildTopicResponse(topic, userId);
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

    // ========== Helper Methods ==========

    /**
     * Build TopicResponse với tính toán progress
     * Method này có thể tái sử dụng cho nhiều API
     * 
     * @param topic  Topic entity
     * @param userId ID của user, có thể null nếu chưa đăng nhập
     * @return TopicResponse với thông tin progress
     */
    private TopicResponse buildTopicResponse(Topic topic, UUID userId) {
        Double progress = 0.0;

        // Chỉ tính progress nếu user đã đăng nhập
        if (userId != null) {
            progress = topicProgressCalculator.calculateTopicProgress(userId, topic.getId());
        }

        return TopicResponse.builder()
                .id(topic.getId())
                .name(topic.getName())
                .description(topic.getDescription())
                .img(topic.getImg())
                .progress(progress)
                .build();
    }

}