package com.thuanthichlaptrinh.card_words.core.service;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import jakarta.annotation.PostConstruct;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
public class FaqService {

    private List<FaqItem> faqs = new ArrayList<>();
    private final Gson gson = new Gson();

    @PostConstruct
    public void loadFaqs() {
        try {
            ClassPathResource resource = new ClassPathResource("faq-data.json");
            InputStreamReader reader = new InputStreamReader(resource.getInputStream(), StandardCharsets.UTF_8);

            Map<String, List<FaqItem>> faqData = gson.fromJson(reader,
                    new TypeToken<Map<String, List<FaqItem>>>() {
                    }.getType());

            this.faqs = faqData.get("faqs");
            log.info("Loaded {} FAQ items", faqs.size());
        } catch (Exception e) {
            log.error("Failed to load FAQ data", e);
            this.faqs = new ArrayList<>();
        }
    }

    public Optional<FaqItem> findBestMatch(String question) {
        String normalizedQuestion = normalizeText(question);

        return faqs.stream()
                .map(faq -> {
                    double score = calculateMatchScore(normalizedQuestion, faq);
                    return new ScoredFaq(faq, score);
                })
                .filter(scored -> scored.score > 0.3)
                .max(Comparator.comparingDouble(scored -> scored.score))
                .map(scored -> scored.faq);
    }

    public List<FaqItem> searchFaqs(String query, int limit) {
        String normalizedQuery = normalizeText(query);

        return faqs.stream()
                .map(faq -> {
                    double score = calculateMatchScore(normalizedQuery, faq);
                    return new ScoredFaq(faq, score);
                })
                .filter(scored -> scored.score > 0.2)
                .sorted(Comparator.comparingDouble((ScoredFaq scored) -> scored.score).reversed())
                .limit(limit)
                .map(scored -> scored.faq)
                .collect(Collectors.toList());
    }

    public List<FaqItem> getFaqsByCategory(String category) {
        return faqs.stream()
                .filter(faq -> faq.getCategory().equalsIgnoreCase(category))
                .collect(Collectors.toList());
    }

    public List<FaqItem> getAllFaqs() {
        return new ArrayList<>(faqs);
    }

    private double calculateMatchScore(String query, FaqItem faq) {
        double score = 0.0;

        String normalizedFaqQuestion = normalizeText(faq.getQuestion());

        // Exact match
        if (normalizedFaqQuestion.contains(query) || query.contains(normalizedFaqQuestion)) {
            score += 1.0;
        }

        // Keyword match
        String[] queryWords = query.split("\\s+");
        for (String keyword : faq.getKeywords()) {
            String normalizedKeyword = normalizeText(keyword);
            for (String queryWord : queryWords) {
                if (normalizedKeyword.contains(queryWord) || queryWord.contains(normalizedKeyword)) {
                    score += 0.3;
                }
            }
        }

        // Question similarity
        String[] faqWords = normalizedFaqQuestion.split("\\s+");
        long matchingWords = Arrays.stream(queryWords)
                .filter(qWord -> Arrays.asList(faqWords).contains(qWord))
                .count();

        if (queryWords.length > 0) {
            score += (matchingWords * 0.5) / queryWords.length;
        }

        return score;
    }

    private String normalizeText(String text) {
        return text.toLowerCase()
                .replaceAll("[àáạảãâầấậẩẫăằắặẳẵ]", "a")
                .replaceAll("[èéẹẻẽêềếệểễ]", "e")
                .replaceAll("[ìíịỉĩ]", "i")
                .replaceAll("[òóọỏõôồốộổỗơờớợởỡ]", "o")
                .replaceAll("[ùúụủũưừứựửữ]", "u")
                .replaceAll("[ỳýỵỷỹ]", "y")
                .replaceAll("[đ]", "d")
                .replaceAll("[^a-z0-9\\s]", "")
                .trim();
    }

    @Data
    public static class FaqItem {
        private Integer id;
        private String category;
        private String question;
        private String answer;
        private List<String> keywords;
    }

    @Data
    private static class ScoredFaq {
        private final FaqItem faq;
        private final double score;
    }
}
