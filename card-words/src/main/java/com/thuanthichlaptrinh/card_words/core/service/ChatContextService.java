package com.thuanthichlaptrinh.card_words.core.service;

import com.thuanthichlaptrinh.card_words.core.domain.Topic;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.domain.Vocab;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.TopicRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserVocabProgressRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.VocabRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChatContextService {

    private final VocabRepository vocabRepository;
    private final TopicRepository topicRepository;
    private final UserVocabProgressRepository userVocabProgressRepository;

    /**
     * Build context from database based on user's question
     */
    public String buildContext(User user, String question) {
        StringBuilder context = new StringBuilder();

        try {
            // Analyze question to determine what context to retrieve
            boolean askingAboutVocab = containsKeywords(question, "từ", "word", "vocabulary", "nghĩa", "meaning");
            boolean askingAboutTopic = containsKeywords(question, "topic", "chủ đề", "theme");
            boolean askingAboutProgress = containsKeywords(question, "tiến độ", "progress", "đã học", "learned");

            if (askingAboutVocab) {
                String vocabContext = getVocabContext(question);
                if (!vocabContext.isEmpty()) {
                    context.append(vocabContext);
                }
            }

            if (askingAboutTopic) {
                String topicContext = getTopicContext(question);
                if (!topicContext.isEmpty()) {
                    context.append(topicContext);
                }
            }

            if (askingAboutProgress && user != null) {
                context.append(getUserProgressContext(user));
            }

            // If no specific context, provide general overview
            if (context.length() == 0) {
                context.append(getGeneralContext());
            }
        } catch (Exception e) {
            log.error("Error building chat context", e);
            // Return basic context in case of error
            return getGeneralContext();
        }

        return context.toString();
    }

    private String getVocabContext(String question) {
        List<Vocab> relatedVocabs = findRelatedVocabs(question);

        if (relatedVocabs.isEmpty()) {
            return "";
        }

        StringBuilder context = new StringBuilder("\n### Thông tin từ vựng:\n");
        for (Vocab vocab : relatedVocabs) {
            context.append(String.format("- %s (%s): %s\n",
                    vocab.getWord(),
                    vocab.getCefr(),
                    vocab.getMeaningVi()));

            if (vocab.getExampleSentence() != null) {
                context.append(String.format("  Ví dụ: %s\n", vocab.getExampleSentence()));
            }
        }

        return context.toString();
    }

    private String getTopicContext(String question) {
        StringBuilder context = new StringBuilder("\n### Thông tin chủ đề:\n");

        List<Topic> topics = topicRepository.findAll();
        String normalizedQuestion = question.toLowerCase();

        if (!topics.isEmpty()) {
            // Đếm tổng số topic
            context.append(String.format("**Tổng số chủ đề:** %d\n\n", topics.size()));

            context.append("**Các chủ đề có sẵn:**\n");
            for (Topic topic : topics) {
                // Đếm số từ thực tế trong topic từ database
                long vocabCount = vocabRepository.countByTopicId(topic.getId());

                context.append(String.format("- **%s**: %s (%d từ vựng)\n",
                        topic.getName(),
                        topic.getDescription() != null ? topic.getDescription() : "Không có mô tả",
                        vocabCount));

                // Nếu câu hỏi chứa tên topic, lấy thêm danh sách từ vựng của topic đó
                if (normalizedQuestion.contains(topic.getName().toLowerCase())) {
                    List<Vocab> topicVocabs = vocabRepository.findByTopicNameIgnoreCase(topic.getName());
                    if (!topicVocabs.isEmpty()) {
                        context.append("  > **Danh sách từ vựng trong chủ đề này:**\n");
                        // Limit to 20 words to avoid token limit
                        for (Vocab v : topicVocabs.stream().limit(20).collect(Collectors.toList())) {
                            context.append(
                                    String.format("    + %s (%s): %s\n", v.getWord(), v.getCefr(), v.getMeaningVi()));
                        }
                        if (topicVocabs.size() > 20) {
                            context.append(String.format("    + ... và %d từ khác.\n", topicVocabs.size() - 20));
                        }
                    }
                }
            }
        } else {
            context.append("Chưa có chủ đề nào.\n");
        }

        return context.toString();
    }

    private String getUserProgressContext(User user) {
        StringBuilder context = new StringBuilder("\n### Tiến độ học tập của bạn:\n");

        // Count learned vocabs (timesCorrect > 0)
        Long learnedCount = userVocabProgressRepository.countLearnedVocabs(user.getId());
        if (learnedCount == null)
            learnedCount = 0L;

        // Count mastered vocabs
        Long masteredCount = userVocabProgressRepository.countByUserIdAndStatus(user.getId(),
                com.thuanthichlaptrinh.card_words.common.enums.VocabStatus.MASTERED);
        if (masteredCount == null)
            masteredCount = 0L;

        // Count total correct and wrong attempts
        Long totalCorrect = userVocabProgressRepository.countTotalCorrectAttempts(user.getId());
        Long totalWrong = userVocabProgressRepository.countTotalWrongAttempts(user.getId());
        if (totalCorrect == null)
            totalCorrect = 0L;
        if (totalWrong == null)
            totalWrong = 0L;

        context.append(String.format("- **Tổng từ đã học:** %d từ\n", learnedCount));
        context.append(String.format("- **Từ đã thành thạo (Mastered):** %d từ\n", masteredCount));
        context.append(String.format("- **Từ đang học:** %d từ\n", learnedCount - masteredCount));
        context.append(String.format("- **Tổng số lần trả lời đúng:** %d\n", totalCorrect));
        context.append(String.format("- **Tổng số lần trả lời sai:** %d\n", totalWrong));

        if (totalCorrect + totalWrong > 0) {
            double accuracy = (totalCorrect * 100.0) / (totalCorrect + totalWrong);
            context.append(String.format("- **Độ chính xác:** %.1f%%\n", accuracy));
        }

        return context.toString();
    }

    private String getGeneralContext() {
        StringBuilder context = new StringBuilder("\n### Tổng quan hệ thống:\n");

        long totalVocabs = vocabRepository.count();
        long totalTopics = topicRepository.count();

        context.append(String.format("- Tổng số từ vựng: %d\n", totalVocabs));
        context.append(String.format("- Tổng số chủ đề: %d\n", totalTopics));

        return context.toString();
    }

    private List<Vocab> findRelatedVocabs(String question) {
        List<Vocab> relatedVocabs = new ArrayList<>();

        if (question == null || question.trim().isEmpty()) {
            return relatedVocabs;
        }

        // Simple keyword extraction and search
        String[] words = question.toLowerCase()
                .replaceAll("[^a-zA-Z0-9\\s]", "")
                .split("\\s+");

        for (String word : words) {
            if (word.length() >= 3) {
                // Use PageRequest to limit results at database level (Top 3 matches)
                List<Vocab> found = vocabRepository
                        .searchByKeyword(word, org.springframework.data.domain.PageRequest.of(0, 3)).getContent();
                if (!found.isEmpty()) {
                    relatedVocabs.addAll(found);
                }
            }
        }

        return relatedVocabs.stream()
                .distinct()
                .limit(5)
                .collect(Collectors.toList());
    }

    public List<Vocab> suggestVocabs(String question, int limit) {
        return findRelatedVocabs(question).stream()
                .limit(limit)
                .collect(Collectors.toList());
    }

    public List<Topic> suggestTopics(String question, int limit) {
        // Simple keyword matching for topics
        List<Topic> allTopics = topicRepository.findAll();

        String normalizedQuestion = question.toLowerCase();

        return allTopics.stream()
                .filter(topic -> normalizedQuestion.contains(topic.getName().toLowerCase()))
                .limit(limit)
                .collect(Collectors.toList());
    }

    private boolean containsKeywords(String text, String... keywords) {
        String normalizedText = text.toLowerCase();
        for (String keyword : keywords) {
            if (normalizedText.contains(keyword.toLowerCase())) {
                return true;
            }
        }
        return false;
    }
}
