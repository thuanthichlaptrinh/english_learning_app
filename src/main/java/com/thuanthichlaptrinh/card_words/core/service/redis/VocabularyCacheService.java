package com.thuanthichlaptrinh.card_words.core.service.redis;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.thuanthichlaptrinh.card_words.configuration.redis.RedisKeyConstants;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.*;

/**
 * Vocabulary Cache Service
 * Manages caching for vocabularies, topics, and types
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class VocabularyCacheService {

    private final BaseRedisService redisService;
    private final ObjectMapper objectMapper;

    private static final Duration VOCAB_DETAIL_TTL = Duration.ofHours(24);
    private static final Duration VOCAB_LIST_TTL = Duration.ofHours(12);
    private static final Duration TOPIC_TTL = Duration.ofHours(12);
    private static final Duration TYPE_TTL = Duration.ofHours(12);
    private static final Duration STATS_TTL = Duration.ofMinutes(30);

    // ==================== VOCABULARY DETAIL ====================

    /**
     * Cache vocabulary detail by ID
     */
    public <T> void cacheVocabDetail(Long vocabId, T vocab) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.VOCAB_DETAIL, vocabId);
            String json = objectMapper.writeValueAsString(vocab);
            redisService.set(key, json, VOCAB_DETAIL_TTL);
            log.debug("✅ Cached vocab detail: id={}", vocabId);
        } catch (JsonProcessingException e) {
            log.error("❌ Failed to cache vocab detail: id={}, error={}", vocabId, e.getMessage());
        }
    }

    /**
     * Get cached vocabulary detail
     */
    public <T> T getVocabDetail(Long vocabId, Class<T> clazz) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.VOCAB_DETAIL, vocabId);
            String json = (String) redisService.get(key);
            
            if (json == null) {
                log.debug("⚠️ Cache miss: vocab detail id={}", vocabId);
                return null;
            }
            
            return objectMapper.readValue(json, clazz);
        } catch (Exception e) {
            log.error("❌ Failed to get vocab detail: id={}, error={}", vocabId, e.getMessage());
            return null;
        }
    }

    /**
     * Invalidate vocabulary detail cache
     */
    public void invalidateVocabDetail(Long vocabId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.VOCAB_DETAIL, vocabId);
        redisService.delete(key);
        log.info("✅ Invalidated vocab detail cache: id={}", vocabId);
    }

    // ==================== VOCABULARY LISTS ====================

    /**
     * Cache vocabularies by topic
     */
    public <T> void cacheVocabsByTopic(Long topicId, List<T> vocabs) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.VOCAB_BY_TOPIC, topicId);
            String json = objectMapper.writeValueAsString(vocabs);
            redisService.set(key, json, VOCAB_LIST_TTL);
            log.debug("✅ Cached {} vocabs for topic {}", vocabs.size(), topicId);
        } catch (JsonProcessingException e) {
            log.error("❌ Failed to cache vocabs by topic: topicId={}", topicId);
        }
    }

    /**
     * Get cached vocabularies by topic
     */
    public <T> List<T> getVocabsByTopic(Long topicId, TypeReference<List<T>> typeRef) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.VOCAB_BY_TOPIC, topicId);
            String json = (String) redisService.get(key);
            
            if (json == null) {
                log.debug("⚠️ Cache miss: vocabs by topic={}", topicId);
                return null;
            }
            
            return objectMapper.readValue(json, typeRef);
        } catch (Exception e) {
            log.error("❌ Failed to get vocabs by topic: topicId={}", topicId);
            return null;
        }
    }

    /**
     * Cache vocabularies by CEFR level
     */
    public <T> void cacheVocabsByCEFR(String cefrLevel, List<T> vocabs) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.VOCAB_BY_CEFR, cefrLevel);
            String json = objectMapper.writeValueAsString(vocabs);
            redisService.set(key, json, VOCAB_LIST_TTL);
            log.debug("✅ Cached {} vocabs for CEFR {}", vocabs.size(), cefrLevel);
        } catch (JsonProcessingException e) {
            log.error("❌ Failed to cache vocabs by CEFR: level={}", cefrLevel);
        }
    }

    /**
     * Get cached vocabularies by CEFR level
     */
    public <T> List<T> getVocabsByCEFR(String cefrLevel, TypeReference<List<T>> typeRef) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.VOCAB_BY_CEFR, cefrLevel);
            String json = (String) redisService.get(key);
            
            if (json == null) {
                log.debug("⚠️ Cache miss: vocabs by CEFR={}", cefrLevel);
                return null;
            }
            
            return objectMapper.readValue(json, typeRef);
        } catch (Exception e) {
            log.error("❌ Failed to get vocabs by CEFR: level={}", cefrLevel);
            return null;
        }
    }

    /**
     * Cache random vocabularies for games
     */
    public <T> void cacheRandomVocabs(String gameType, List<T> vocabs) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.VOCAB_RANDOM, gameType);
            String json = objectMapper.writeValueAsString(vocabs);
            redisService.set(key, json, Duration.ofMinutes(10)); // Shorter TTL for random lists
            log.debug("✅ Cached {} random vocabs for game {}", vocabs.size(), gameType);
        } catch (JsonProcessingException e) {
            log.error("❌ Failed to cache random vocabs: gameType={}", gameType);
        }
    }

    // ==================== TOPICS ====================

    /**
     * Cache topic detail
     */
    public <T> void cacheTopicDetail(Long topicId, T topic) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.TOPIC_DETAIL, topicId);
            String json = objectMapper.writeValueAsString(topic);
            redisService.set(key, json, TOPIC_TTL);
            log.debug("✅ Cached topic detail: id={}", topicId);
        } catch (JsonProcessingException e) {
            log.error("❌ Failed to cache topic detail: id={}", topicId);
        }
    }

    /**
     * Get cached topic detail
     */
    public <T> T getTopicDetail(Long topicId, Class<T> clazz) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.TOPIC_DETAIL, topicId);
            String json = (String) redisService.get(key);
            
            if (json == null) {
                return null;
            }
            
            return objectMapper.readValue(json, clazz);
        } catch (Exception e) {
            log.error("❌ Failed to get topic detail: id={}", topicId);
            return null;
        }
    }

    /**
     * Cache all topics list
     */
    public <T> void cacheAllTopics(List<T> topics) {
        try {
            String key = RedisKeyConstants.TOPIC_LIST;
            String json = objectMapper.writeValueAsString(topics);
            redisService.set(key, json, TOPIC_TTL);
            log.debug("✅ Cached {} topics", topics.size());
        } catch (JsonProcessingException e) {
            log.error("❌ Failed to cache all topics");
        }
    }

    /**
     * Get cached topics list
     */
    public <T> List<T> getAllTopics(TypeReference<List<T>> typeRef) {
        try {
            String key = RedisKeyConstants.TOPIC_LIST;
            String json = (String) redisService.get(key);
            
            if (json == null) {
                log.debug("⚠️ Cache miss: all topics");
                return null;
            }
            
            return objectMapper.readValue(json, typeRef);
        } catch (Exception e) {
            log.error("❌ Failed to get all topics");
            return null;
        }
    }

    /**
     * Invalidate all topic caches
     */
    public void invalidateTopicCaches() {
        redisService.delete(RedisKeyConstants.TOPIC_LIST);
        log.info("✅ Invalidated topic list cache");
    }

    // ==================== TYPES ====================

    /**
     * Cache type detail
     */
    public <T> void cacheTypeDetail(Long typeId, T type) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.TYPE_DETAIL, typeId);
            String json = objectMapper.writeValueAsString(type);
            redisService.set(key, json, TYPE_TTL);
            log.debug("✅ Cached type detail: id={}", typeId);
        } catch (JsonProcessingException e) {
            log.error("❌ Failed to cache type detail: id={}", typeId);
        }
    }

    /**
     * Get cached type detail
     */
    public <T> T getTypeDetail(Long typeId, Class<T> clazz) {
        try {
            String key = RedisKeyConstants.buildKey(RedisKeyConstants.TYPE_DETAIL, typeId);
            String json = (String) redisService.get(key);
            
            if (json == null) {
                return null;
            }
            
            return objectMapper.readValue(json, clazz);
        } catch (Exception e) {
            log.error("❌ Failed to get type detail: id={}", typeId);
            return null;
        }
    }

    /**
     * Cache all types list
     */
    public <T> void cacheAllTypes(List<T> types) {
        try {
            String key = RedisKeyConstants.TYPE_LIST;
            String json = objectMapper.writeValueAsString(types);
            redisService.set(key, json, TYPE_TTL);
            log.debug("✅ Cached {} types", types.size());
        } catch (JsonProcessingException e) {
            log.error("❌ Failed to cache all types");
        }
    }

    /**
     * Get cached types list
     */
    public <T> List<T> getAllTypes(TypeReference<List<T>> typeRef) {
        try {
            String key = RedisKeyConstants.TYPE_LIST;
            String json = (String) redisService.get(key);
            
            if (json == null) {
                log.debug("⚠️ Cache miss: all types");
                return null;
            }
            
            return objectMapper.readValue(json, typeRef);
        } catch (Exception e) {
            log.error("❌ Failed to get all types");
            return null;
        }
    }

    /**
     * Invalidate all type caches
     */
    public void invalidateTypeCaches() {
        redisService.delete(RedisKeyConstants.TYPE_LIST);
        log.info("✅ Invalidated type list cache");
    }

    // ==================== VOCABULARY STATISTICS ====================

    /**
     * Cache total vocabulary count
     */
    public void cacheTotalVocabCount(long count) {
        String key = RedisKeyConstants.VOCAB_STATS_TOTAL;
        redisService.set(key, count, STATS_TTL);
    }

    /**
     * Get cached total vocabulary count
     */
    public Long getTotalVocabCount() {
        String key = RedisKeyConstants.VOCAB_STATS_TOTAL;
        return redisService.get(key, Long.class);
    }

    /**
     * Cache vocabulary count by topic
     */
    public void cacheVocabCountByTopic(Long topicId, long count) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.VOCAB_STATS_BY_TOPIC, topicId);
        redisService.set(key, count, STATS_TTL);
    }

    /**
     * Get cached vocabulary count by topic
     */
    public Long getVocabCountByTopic(Long topicId) {
        String key = RedisKeyConstants.buildKey(RedisKeyConstants.VOCAB_STATS_BY_TOPIC, topicId);
        return redisService.get(key, Long.class);
    }

    // ==================== BULK OPERATIONS ====================

    /**
     * Invalidate all vocabulary caches for a specific topic
     */
    public void invalidateTopicVocabCaches(Long topicId) {
        List<String> keys = Arrays.asList(
            RedisKeyConstants.buildKey(RedisKeyConstants.VOCAB_BY_TOPIC, topicId),
            RedisKeyConstants.buildKey(RedisKeyConstants.VOCAB_STATS_BY_TOPIC, topicId)
        );
        
        redisService.delete(keys);
        log.info("✅ Invalidated vocab caches for topic {}", topicId);
    }

    /**
     * Invalidate all vocabulary caches (use with caution!)
     */
    public void invalidateAllVocabCaches() {
        List<String> patterns = Arrays.asList(
            RedisKeyConstants.VOCAB_DETAIL + "*",
            RedisKeyConstants.VOCAB_BY_TOPIC + "*",
            RedisKeyConstants.VOCAB_BY_CEFR + "*",
            RedisKeyConstants.VOCAB_STATS_TOTAL,
            RedisKeyConstants.VOCAB_STATS_BY_TOPIC + "*"
        );
        
        patterns.forEach(pattern -> {
            Set<String> keys = redisService.keys(pattern);
            if (!keys.isEmpty()) {
                redisService.delete(new ArrayList<>(keys));
            }
        });
        
        log.warn("⚠️ Invalidated all vocabulary caches");
    }

    /**
     * Warm up vocabulary cache (preload frequently accessed data)
     */
    public void warmUpCache(List<?> vocabs, List<?> topics, List<?> types) {
        log.info("🔥 Starting cache warm-up...");
        
        cacheAllTopics(topics);
        cacheAllTypes(types);
        cacheTotalVocabCount(vocabs.size());
        
        log.info("✅ Cache warm-up completed: {} vocabs, {} topics, {} types", 
                vocabs.size(), topics.size(), types.size());
    }
}
