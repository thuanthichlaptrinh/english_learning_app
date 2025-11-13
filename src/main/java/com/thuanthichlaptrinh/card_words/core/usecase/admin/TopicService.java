package com.thuanthichlaptrinh.card_words.core.usecase.admin;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.core.domain.Topic;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.TopicRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.BulkCreateTopicsRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.BulkUpdateTopicsRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.CreateTopicRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.UpdateTopicRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.BulkTopicOperationResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.TopicResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service("topicAdminService")
@RequiredArgsConstructor
public class TopicService {

    private final TopicRepository topicRepository;
    private final FirebaseStorageService firebaseStorageService;

    /**
     * Create new topic with optional image
     */
    @Transactional
    public TopicResponse createTopic(CreateTopicRequest request, MultipartFile image) {
        log.info("Creating new topic: {}", request.getName());

        // Check if topic name already exists
        if (topicRepository.existsByName(request.getName())) {
            throw new ErrorException("Chủ đề '" + request.getName() + "' đã tồn tại");
        }

        // Upload image to Firebase if provided
        String imageUrl = null;
        if (image != null && !image.isEmpty()) {
            try {
                imageUrl = firebaseStorageService.uploadFile(image, "topics/images");
                log.info("Uploaded topic image: {}", imageUrl);
            } catch (IOException e) {
                log.error("Failed to upload topic image: {}", e.getMessage());
                throw new ErrorException("Không thể tải lên hình ảnh chủ đề: " + e.getMessage());
            }
        }

        // Create and save topic
        Topic topic = Topic.builder()
                .name(request.getName())
                .description(request.getDescription())
                .img(imageUrl)
                .build();

        Topic savedTopic = topicRepository.save(topic);
        log.info("Topic created successfully with ID: {}", savedTopic.getId());

        return mapToResponse(savedTopic);
    }

    /**
     * Update existing topic with optional image
     */
    @Transactional
    public TopicResponse updateTopic(Long topicId, UpdateTopicRequest request, MultipartFile image) {
        log.info("Updating topic ID: {}", topicId);

        // Find existing topic
        Topic topic = topicRepository.findById(topicId)
                .orElseThrow(() -> new ErrorException("Không tìm thấy chủ đề với ID: " + topicId));

        // Check if new name conflicts with other topics
        if (request.getName() != null && !request.getName().equals(topic.getName())) {
            if (topicRepository.existsByName(request.getName())) {
                throw new ErrorException("Tên chủ đề '" + request.getName() + "' đã được sử dụng");
            }
            topic.setName(request.getName());
        }

        // Update description if provided
        if (request.getDescription() != null) {
            topic.setDescription(request.getDescription());
        }

        // Upload new image if provided
        if (image != null && !image.isEmpty()) {
            try {
                // Delete old image from Firebase if exists
                if (topic.getImg() != null && !topic.getImg().isEmpty()) {
                    try {
                        firebaseStorageService.deleteFile(topic.getImg());
                        log.info("Deleted old topic image: {}", topic.getImg());
                    } catch (Exception e) {
                        log.warn("Failed to delete old topic image: {}", e.getMessage());
                    }
                }

                // Upload new image
                String newImageUrl = firebaseStorageService.uploadFile(image, "topics/images");
                topic.setImg(newImageUrl);
                log.info("Uploaded new topic image: {}", newImageUrl);
            } catch (IOException e) {
                log.error("Failed to upload new topic image: {}", e.getMessage());
                throw new ErrorException("Không thể tải lên hình ảnh mới: " + e.getMessage());
            }
        }

        Topic updatedTopic = topicRepository.save(topic);
        log.info("Topic updated successfully: {}", updatedTopic.getId());

        return mapToResponse(updatedTopic);
    }

    /**
     * Get topic by ID
     */
    public TopicResponse getTopicById(Long topicId) {
        Topic topic = topicRepository.findById(topicId)
                .orElseThrow(() -> new ErrorException("Không tìm thấy chủ đề với ID: " + topicId));
        return mapToResponse(topic);
    }

    /**
     * Get all topics
     */
    public List<TopicResponse> getAllTopics() {
        return topicRepository.findAll().stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    /**
     * Delete topic
     */
    @Transactional
    public void deleteTopic(Long topicId) {
        log.info("Deleting topic ID: {}", topicId);

        Topic topic = topicRepository.findById(topicId)
                .orElseThrow(() -> new ErrorException("Không tìm thấy chủ đề với ID: " + topicId));

        // Delete image from Firebase if exists
        if (topic.getImg() != null && !topic.getImg().isEmpty()) {
            try {
                firebaseStorageService.deleteFile(topic.getImg());
                log.info("Deleted topic image: {}", topic.getImg());
            } catch (Exception e) {
                log.warn("Failed to delete topic image: {}", e.getMessage());
            }
        }

        topicRepository.delete(topic);
        log.info("Topic deleted successfully: {}", topicId);
    }

    /**
     * Map Topic entity to TopicResponse DTO
     */
    private TopicResponse mapToResponse(Topic topic) {
        return TopicResponse.builder()
                .id(topic.getId())
                .name(topic.getName())
                .description(topic.getDescription())
                .img(topic.getImg())
                .build();
    }

    /**
     * Bulk create topics
     */
    @Transactional
    public BulkTopicOperationResponse bulkCreateTopics(BulkCreateTopicsRequest request) {
        log.info("Bulk creating {} topics", request.getTopics().size());

        List<BulkTopicOperationResponse.TopicResult> results = new ArrayList<>();
        int successCount = 0;
        int failureCount = 0;

        for (BulkCreateTopicsRequest.TopicItem item : request.getTopics()) {
            try {
                // Check if topic name already exists
                if (topicRepository.existsByName(item.getName())) {
                    results.add(BulkTopicOperationResponse.TopicResult.builder()
                            .success(false)
                            .message("Chủ đề '" + item.getName() + "' đã tồn tại")
                            .inputName(item.getName())
                            .build());
                    failureCount++;
                    continue;
                }

                // Create topic
                Topic topic = Topic.builder()
                        .name(item.getName())
                        .description(item.getDescription())
                        .img(item.getImageUrl())
                        .build();

                Topic savedTopic = topicRepository.save(topic);
                log.info("Created topic: {} (ID: {})", savedTopic.getName(), savedTopic.getId());

                results.add(BulkTopicOperationResponse.TopicResult.builder()
                        .success(true)
                        .message("Tạo thành công")
                        .data(mapToResponse(savedTopic))
                        .inputName(item.getName())
                        .build());
                successCount++;

            } catch (Exception e) {
                log.error("Failed to create topic '{}': {}", item.getName(), e.getMessage());
                results.add(BulkTopicOperationResponse.TopicResult.builder()
                        .success(false)
                        .message("Lỗi: " + e.getMessage())
                        .inputName(item.getName())
                        .build());
                failureCount++;
            }
        }

        log.info("Bulk create completed: {} success, {} failures", successCount, failureCount);

        return BulkTopicOperationResponse.builder()
                .totalRequested(request.getTopics().size())
                .successCount(successCount)
                .failureCount(failureCount)
                .results(results)
                .build();
    }

    /**
     * Bulk update topics
     */
    @Transactional
    public BulkTopicOperationResponse bulkUpdateTopics(BulkUpdateTopicsRequest request) {
        log.info("Bulk updating {} topics", request.getTopics().size());

        List<BulkTopicOperationResponse.TopicResult> results = new ArrayList<>();
        int successCount = 0;
        int failureCount = 0;

        for (BulkUpdateTopicsRequest.TopicItem item : request.getTopics()) {
            try {
                // Find existing topic
                Topic topic = topicRepository.findById(item.getId())
                        .orElseThrow(() -> new ErrorException("Không tìm thấy chủ đề với ID: " + item.getId()));

                // Update name if provided and different
                if (item.getName() != null && !item.getName().trim().isEmpty()
                        && !item.getName().equals(topic.getName())) {
                    // Check if new name conflicts with other topics
                    if (topicRepository.existsByName(item.getName())) {
                        results.add(BulkTopicOperationResponse.TopicResult.builder()
                                .success(false)
                                .message("Tên chủ đề '" + item.getName() + "' đã được sử dụng")
                                .inputId(item.getId())
                                .inputName(item.getName())
                                .build());
                        failureCount++;
                        continue;
                    }
                    topic.setName(item.getName());
                }

                // Update description if provided
                if (item.getDescription() != null) {
                    topic.setDescription(item.getDescription());
                }

                // Update image URL if provided
                if (item.getImageUrl() != null && !item.getImageUrl().trim().isEmpty()) {
                    // Delete old image if exists and different from new one
                    if (topic.getImg() != null && !topic.getImg().equals(item.getImageUrl())) {
                        try {
                            firebaseStorageService.deleteFile(topic.getImg());
                            log.info("Deleted old topic image: {}", topic.getImg());
                        } catch (Exception e) {
                            log.warn("Failed to delete old topic image: {}", e.getMessage());
                        }
                    }
                    topic.setImg(item.getImageUrl());
                }

                Topic updatedTopic = topicRepository.save(topic);
                log.info("Updated topic ID: {}", updatedTopic.getId());

                results.add(BulkTopicOperationResponse.TopicResult.builder()
                        .success(true)
                        .message("Cập nhật thành công")
                        .data(mapToResponse(updatedTopic))
                        .inputId(item.getId())
                        .inputName(item.getName())
                        .build());
                successCount++;

            } catch (Exception e) {
                log.error("Failed to update topic ID {}: {}", item.getId(), e.getMessage());
                results.add(BulkTopicOperationResponse.TopicResult.builder()
                        .success(false)
                        .message("Lỗi: " + e.getMessage())
                        .inputId(item.getId())
                        .inputName(item.getName())
                        .build());
                failureCount++;
            }
        }

        log.info("Bulk update completed: {} success, {} failures", successCount, failureCount);

        return BulkTopicOperationResponse.builder()
                .totalRequested(request.getTopics().size())
                .successCount(successCount)
                .failureCount(failureCount)
                .results(results)
                .build();
    }
}
