package com.thuanthichlaptrinh.card_words.configuration.redis;

import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.jsontype.BasicPolymorphicTypeValidator;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.RedisSerializationContext;
import org.springframework.data.redis.serializer.StringRedisSerializer;

import java.time.Duration;
import java.util.HashMap;
import java.util.Map;

/**
 * Redis Configuration
 * - Multiple RedisTemplates for different use cases
 * - Cache manager with custom TTL per cache name
 * - JSON serialization with Jackson
 */
@Slf4j
@Configuration
@EnableCaching
@RequiredArgsConstructor
public class RedisConfig {

    private final RedisConnectionFactory redisConnectionFactory;

    /**
     * Custom ObjectMapper for Redis serialization ONLY
     * Handles Java 8 date/time types and polymorphic types
     * NOTE: This ObjectMapper is ONLY used for Redis, not for HTTP requests
     */
    private ObjectMapper createRedisObjectMapper() {
        ObjectMapper objectMapper = new ObjectMapper();

        // Register JavaTimeModule for LocalDateTime, LocalDate, etc.
        objectMapper.registerModule(new JavaTimeModule());

        // Enable polymorphic type handling for Redis cache objects
        // This allows storing different object types in Redis with type information
        objectMapper.activateDefaultTyping(
                BasicPolymorphicTypeValidator.builder()
                        .allowIfBaseType(Object.class)
                        .build(),
                ObjectMapper.DefaultTyping.NON_FINAL,
                JsonTypeInfo.As.PROPERTY);

        return objectMapper;
    }

    /**
     * Primary RedisTemplate for general purpose
     * Key: String, Value: Object (JSON)
     */
    @Bean
    @Primary
    public RedisTemplate<String, Object> redisTemplate() {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(redisConnectionFactory);

        // Use String serializer for keys
        StringRedisSerializer stringSerializer = new StringRedisSerializer();
        template.setKeySerializer(stringSerializer);
        template.setHashKeySerializer(stringSerializer);

        // Use JSON serializer for values
        GenericJackson2JsonRedisSerializer jsonSerializer = new GenericJackson2JsonRedisSerializer(
                createRedisObjectMapper());
        template.setValueSerializer(jsonSerializer);
        template.setHashValueSerializer(jsonSerializer);

        template.afterPropertiesSet();

        log.info("✅ Primary RedisTemplate initialized");
        return template;
    }

    /**
     * Note: stringRedisTemplate is already provided by Spring Boot
     * Auto-configuration
     * We don't need to create it here - just @Autowire StringRedisTemplate where
     * needed
     */

    /**
     * RedisTemplate for Long values
     * Useful for timestamps, counters
     */
    @Bean
    public RedisTemplate<String, Long> longRedisTemplate() {
        RedisTemplate<String, Long> template = new RedisTemplate<>();
        template.setConnectionFactory(redisConnectionFactory);

        StringRedisSerializer stringSerializer = new StringRedisSerializer();
        template.setKeySerializer(stringSerializer);

        GenericJackson2JsonRedisSerializer jsonSerializer = new GenericJackson2JsonRedisSerializer(
                createRedisObjectMapper());
        template.setValueSerializer(jsonSerializer);

        template.afterPropertiesSet();

        log.info("✅ Long RedisTemplate initialized");
        return template;
    }

    /**
     * Cache Manager with custom TTL per cache name
     */
    @Bean
    public CacheManager cacheManager() {
        // Default cache configuration (1 hour)
        RedisCacheConfiguration defaultConfig = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofHours(1))
                .serializeKeysWith(
                        RedisSerializationContext.SerializationPair.fromSerializer(
                                new StringRedisSerializer()))
                .serializeValuesWith(
                        RedisSerializationContext.SerializationPair.fromSerializer(
                                new GenericJackson2JsonRedisSerializer(createRedisObjectMapper())))
                .disableCachingNullValues();

        // Custom TTL for specific caches
        Map<String, RedisCacheConfiguration> cacheConfigurations = new HashMap<>();

        // Game Sessions - 30 minutes
        cacheConfigurations.put("gameSessions",
                defaultConfig.entryTtl(Duration.ofMinutes(30)));

        // Vocabularies - 24 hours
        cacheConfigurations.put("vocabularies",
                defaultConfig.entryTtl(Duration.ofHours(24)));

        // User Stats - 10 minutes
        cacheConfigurations.put("userStats",
                defaultConfig.entryTtl(Duration.ofMinutes(10)));

        // Leaderboards - 5 minutes
        cacheConfigurations.put("leaderboards",
                defaultConfig.entryTtl(Duration.ofMinutes(5)));

        // Topics & Types - 12 hours
        cacheConfigurations.put("topics",
                defaultConfig.entryTtl(Duration.ofHours(12)));
        cacheConfigurations.put("types",
                defaultConfig.entryTtl(Duration.ofHours(12)));

        // Auth tokens - 7 days
        cacheConfigurations.put("authTokens",
                defaultConfig.entryTtl(Duration.ofDays(7)));

        // Rate limiting - 5 minutes
        cacheConfigurations.put("rateLimits",
                defaultConfig.entryTtl(Duration.ofMinutes(5)));

        RedisCacheManager cacheManager = RedisCacheManager.builder(redisConnectionFactory)
                .cacheDefaults(defaultConfig)
                .withInitialCacheConfigurations(cacheConfigurations)
                .transactionAware()
                .build();

        log.info("✅ Redis CacheManager initialized with {} custom cache configurations",
                cacheConfigurations.size());

        return cacheManager;
    }
}
