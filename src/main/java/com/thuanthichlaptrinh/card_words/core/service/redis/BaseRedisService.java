package com.thuanthichlaptrinh.card_words.core.service.redis;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.*;
import java.util.concurrent.TimeUnit;

/**
 * Base Redis Service
 * Provides common Redis operations with error handling and logging
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class BaseRedisService {

    private final RedisTemplate<String, Object> redisTemplate;
    private final StringRedisTemplate stringRedisTemplate; // Auto-configured by Spring Boot
    private final RedisTemplate<String, Long> longRedisTemplate;

    // ==================== STRING OPERATIONS ====================

    public void set(String key, Object value) {
        try {
            redisTemplate.opsForValue().set(key, value);
            log.debug("✅ Redis SET: key={}", key);
        } catch (Exception e) {
            log.error("❌ Redis SET failed: key={}, error={}", key, e.getMessage());
        }
    }

    public void set(String key, Object value, Duration ttl) {
        try {
            redisTemplate.opsForValue().set(key, value, ttl);
            log.debug("✅ Redis SET with TTL: key={}, ttl={}s", key, ttl.getSeconds());
        } catch (Exception e) {
            log.error("❌ Redis SET with TTL failed: key={}, error={}", key, e.getMessage());
        }
    }

    public <T> T get(String key, Class<T> clazz) {
        try {
            Object value = redisTemplate.opsForValue().get(key);
            if (value == null) {
                log.debug("⚠️ Redis GET: key={}, result=null", key);
                return null;
            }
            log.debug("✅ Redis GET: key={}, found=true", key);
            return clazz.cast(value);
        } catch (Exception e) {
            log.error("❌ Redis GET failed: key={}, error={}", key, e.getMessage());
            return null;
        }
    }

    public Object get(String key) {
        try {
            Object value = redisTemplate.opsForValue().get(key);
            log.debug("✅ Redis GET: key={}, found={}", key, value != null);
            return value;
        } catch (Exception e) {
            log.error("❌ Redis GET failed: key={}, error={}", key, e.getMessage());
            return null;
        }
    }

    public String getString(String key) {
        try {
            String value = stringRedisTemplate.opsForValue().get(key);
            log.debug("✅ Redis GET String: key={}, found={}", key, value != null);
            return value;
        } catch (Exception e) {
            log.error("❌ Redis GET String failed: key={}, error={}", key, e.getMessage());
            return null;
        }
    }

    public boolean delete(String key) {
        try {
            Boolean result = redisTemplate.delete(key);
            log.debug("✅ Redis DELETE: key={}, deleted={}", key, result);
            return Boolean.TRUE.equals(result);
        } catch (Exception e) {
            log.error("❌ Redis DELETE failed: key={}, error={}", key, e.getMessage());
            return false;
        }
    }

    public long delete(Collection<String> keys) {
        try {
            Long count = redisTemplate.delete(keys);
            log.debug("✅ Redis DELETE multiple: count={}", count);
            return count != null ? count : 0;
        } catch (Exception e) {
            log.error("❌ Redis DELETE multiple failed: error={}", e.getMessage());
            return 0;
        }
    }

    public boolean exists(String key) {
        try {
            Boolean result = redisTemplate.hasKey(key);
            return Boolean.TRUE.equals(result);
        } catch (Exception e) {
            log.error("❌ Redis EXISTS failed: key={}, error={}", key, e.getMessage());
            return false;
        }
    }

    public boolean expire(String key, Duration ttl) {
        try {
            Boolean result = redisTemplate.expire(key, ttl);
            log.debug("✅ Redis EXPIRE: key={}, ttl={}s, success={}", key, ttl.getSeconds(), result);
            return Boolean.TRUE.equals(result);
        } catch (Exception e) {
            log.error("❌ Redis EXPIRE failed: key={}, error={}", key, e.getMessage());
            return false;
        }
    }

    public Long getExpire(String key) {
        try {
            return redisTemplate.getExpire(key, TimeUnit.SECONDS);
        } catch (Exception e) {
            log.error("❌ Redis GET EXPIRE failed: key={}, error={}", key, e.getMessage());
            return null;
        }
    }

    /**
     * Get TTL (Time To Live) of a key in seconds
     * Alias for getExpire()
     */
    public Long getTTL(String key) {
        return getExpire(key);
    }

    // ==================== COUNTER OPERATIONS ====================

    public Long increment(String key) {
        try {
            Long result = stringRedisTemplate.opsForValue().increment(key);
            log.debug("✅ Redis INCR: key={}, newValue={}", key, result);
            return result;
        } catch (Exception e) {
            log.error("❌ Redis INCR failed: key={}, error={}", key, e.getMessage());
            return null;
        }
    }

    public Long increment(String key, long delta) {
        try {
            Long result = stringRedisTemplate.opsForValue().increment(key, delta);
            log.debug("✅ Redis INCRBY: key={}, delta={}, newValue={}", key, delta, result);
            return result;
        } catch (Exception e) {
            log.error("❌ Redis INCRBY failed: key={}, error={}", key, e.getMessage());
            return null;
        }
    }

    public Long decrement(String key) {
        try {
            Long result = stringRedisTemplate.opsForValue().decrement(key);
            log.debug("✅ Redis DECR: key={}, newValue={}", key, result);
            return result;
        } catch (Exception e) {
            log.error("❌ Redis DECR failed: key={}, error={}", key, e.getMessage());
            return null;
        }
    }

    // ==================== HASH OPERATIONS ====================

    public void hSet(String key, String field, Object value) {
        try {
            redisTemplate.opsForHash().put(key, field, value);
            log.debug("✅ Redis HSET: key={}, field={}", key, field);
        } catch (Exception e) {
            log.error("❌ Redis HSET failed: key={}, field={}, error={}", key, field, e.getMessage());
        }
    }

    public Object hGet(String key, String field) {
        try {
            Object value = redisTemplate.opsForHash().get(key, field);
            log.debug("✅ Redis HGET: key={}, field={}, found={}", key, field, value != null);
            return value;
        } catch (Exception e) {
            log.error("❌ Redis HGET failed: key={}, field={}, error={}", key, field, e.getMessage());
            return null;
        }
    }

    public Map<Object, Object> hGetAll(String key) {
        try {
            Map<Object, Object> map = redisTemplate.opsForHash().entries(key);
            log.debug("✅ Redis HGETALL: key={}, size={}", key, map.size());
            return map;
        } catch (Exception e) {
            log.error("❌ Redis HGETALL failed: key={}, error={}", key, e.getMessage());
            return Collections.emptyMap();
        }
    }

    public boolean hExists(String key, String field) {
        try {
            return Boolean.TRUE.equals(redisTemplate.opsForHash().hasKey(key, field));
        } catch (Exception e) {
            log.error("❌ Redis HEXISTS failed: key={}, field={}, error={}", key, field, e.getMessage());
            return false;
        }
    }

    public Long hDelete(String key, Object... fields) {
        try {
            Long count = redisTemplate.opsForHash().delete(key, fields);
            log.debug("✅ Redis HDEL: key={}, fieldsDeleted={}", key, count);
            return count;
        } catch (Exception e) {
            log.error("❌ Redis HDEL failed: key={}, error={}", key, e.getMessage());
            return 0L;
        }
    }

    // ==================== LIST OPERATIONS ====================

    public Long lPush(String key, Object value) {
        try {
            Long size = redisTemplate.opsForList().leftPush(key, value);
            log.debug("✅ Redis LPUSH: key={}, newSize={}", key, size);
            return size;
        } catch (Exception e) {
            log.error("❌ Redis LPUSH failed: key={}, error={}", key, e.getMessage());
            return null;
        }
    }

    public Long rPush(String key, Object value) {
        try {
            Long size = redisTemplate.opsForList().rightPush(key, value);
            log.debug("✅ Redis RPUSH: key={}, newSize={}", key, size);
            return size;
        } catch (Exception e) {
            log.error("❌ Redis RPUSH failed: key={}, error={}", key, e.getMessage());
            return null;
        }
    }

    public Object lPop(String key) {
        try {
            Object value = redisTemplate.opsForList().leftPop(key);
            log.debug("✅ Redis LPOP: key={}, found={}", key, value != null);
            return value;
        } catch (Exception e) {
            log.error("❌ Redis LPOP failed: key={}, error={}", key, e.getMessage());
            return null;
        }
    }

    public List<Object> lRange(String key, long start, long end) {
        try {
            List<Object> list = redisTemplate.opsForList().range(key, start, end);
            log.debug("✅ Redis LRANGE: key={}, start={}, end={}, size={}",
                    key, start, end, list != null ? list.size() : 0);
            return list != null ? list : Collections.emptyList();
        } catch (Exception e) {
            log.error("❌ Redis LRANGE failed: key={}, error={}", key, e.getMessage());
            return Collections.emptyList();
        }
    }

    public Long lLen(String key) {
        try {
            return redisTemplate.opsForList().size(key);
        } catch (Exception e) {
            log.error("❌ Redis LLEN failed: key={}, error={}", key, e.getMessage());
            return 0L;
        }
    }

    // ==================== SET OPERATIONS ====================

    public Long sAdd(String key, Object... values) {
        try {
            Long count = redisTemplate.opsForSet().add(key, values);
            log.debug("✅ Redis SADD: key={}, added={}", key, count);
            return count;
        } catch (Exception e) {
            log.error("❌ Redis SADD failed: key={}, error={}", key, e.getMessage());
            return 0L;
        }
    }

    public Set<Object> sMembers(String key) {
        try {
            Set<Object> set = redisTemplate.opsForSet().members(key);
            log.debug("✅ Redis SMEMBERS: key={}, size={}", key, set != null ? set.size() : 0);
            return set != null ? set : Collections.emptySet();
        } catch (Exception e) {
            log.error("❌ Redis SMEMBERS failed: key={}, error={}", key, e.getMessage());
            return Collections.emptySet();
        }
    }

    public boolean sIsMember(String key, Object value) {
        try {
            return Boolean.TRUE.equals(redisTemplate.opsForSet().isMember(key, value));
        } catch (Exception e) {
            log.error("❌ Redis SISMEMBER failed: key={}, error={}", key, e.getMessage());
            return false;
        }
    }

    public Long sRem(String key, Object... values) {
        try {
            Long count = redisTemplate.opsForSet().remove(key, values);
            log.debug("✅ Redis SREM: key={}, removed={}", key, count);
            return count;
        } catch (Exception e) {
            log.error("❌ Redis SREM failed: key={}, error={}", key, e.getMessage());
            return 0L;
        }
    }

    public Long sCard(String key) {
        try {
            return redisTemplate.opsForSet().size(key);
        } catch (Exception e) {
            log.error("❌ Redis SCARD failed: key={}, error={}", key, e.getMessage());
            return 0L;
        }
    }

    // ==================== SORTED SET OPERATIONS ====================

    public Boolean zAdd(String key, Object value, double score) {
        try {
            Boolean result = redisTemplate.opsForZSet().add(key, value, score);
            log.debug("✅ Redis ZADD: key={}, score={}, added={}", key, score, result);
            return result;
        } catch (Exception e) {
            log.error("❌ Redis ZADD failed: key={}, error={}", key, e.getMessage());
            return false;
        }
    }

    public Set<Object> zRange(String key, long start, long end) {
        try {
            Set<Object> set = redisTemplate.opsForZSet().range(key, start, end);
            log.debug("✅ Redis ZRANGE: key={}, start={}, end={}, size={}",
                    key, start, end, set != null ? set.size() : 0);
            return set != null ? set : Collections.emptySet();
        } catch (Exception e) {
            log.error("❌ Redis ZRANGE failed: key={}, error={}", key, e.getMessage());
            return Collections.emptySet();
        }
    }

    public Set<Object> zRevRange(String key, long start, long end) {
        try {
            Set<Object> set = redisTemplate.opsForZSet().reverseRange(key, start, end);
            log.debug("✅ Redis ZREVRANGE: key={}, start={}, end={}, size={}",
                    key, start, end, set != null ? set.size() : 0);
            return set != null ? set : Collections.emptySet();
        } catch (Exception e) {
            log.error("❌ Redis ZREVRANGE failed: key={}, error={}", key, e.getMessage());
            return Collections.emptySet();
        }
    }

    public Long zRank(String key, Object value) {
        try {
            return redisTemplate.opsForZSet().rank(key, value);
        } catch (Exception e) {
            log.error("❌ Redis ZRANK failed: key={}, error={}", key, e.getMessage());
            return null;
        }
    }

    public Long zRevRank(String key, Object value) {
        try {
            return redisTemplate.opsForZSet().reverseRank(key, value);
        } catch (Exception e) {
            log.error("❌ Redis ZREVRANK failed: key={}, error={}", key, e.getMessage());
            return null;
        }
    }

    public Double zScore(String key, Object value) {
        try {
            return redisTemplate.opsForZSet().score(key, value);
        } catch (Exception e) {
            log.error("❌ Redis ZSCORE failed: key={}, error={}", key, e.getMessage());
            return null;
        }
    }

    public Long zCard(String key) {
        try {
            return redisTemplate.opsForZSet().size(key);
        } catch (Exception e) {
            log.error("❌ Redis ZCARD failed: key={}, error={}", key, e.getMessage());
            return 0L;
        }
    }

    public Long zRem(String key, Object... values) {
        try {
            Long count = redisTemplate.opsForZSet().remove(key, values);
            log.debug("✅ Redis ZREM: key={}, removed={}", key, count);
            return count;
        } catch (Exception e) {
            log.error("❌ Redis ZREM failed: key={}, error={}", key, e.getMessage());
            return 0L;
        }
    }

    // ==================== UTILITY METHODS ====================

    public Set<String> keys(String pattern) {
        try {
            Set<String> keys = redisTemplate.keys(pattern);
            log.debug("✅ Redis KEYS: pattern={}, found={}", pattern, keys != null ? keys.size() : 0);
            return keys != null ? keys : Collections.emptySet();
        } catch (Exception e) {
            log.error("❌ Redis KEYS failed: pattern={}, error={}", pattern, e.getMessage());
            return Collections.emptySet();
        }
    }

    public boolean ping() {
        try {
            String result = redisTemplate.getConnectionFactory()
                    .getConnection()
                    .ping();
            boolean isAlive = "PONG".equals(result);
            log.debug("✅ Redis PING: connected={}", isAlive);
            return isAlive;
        } catch (Exception e) {
            log.error("❌ Redis PING failed: error={}", e.getMessage());
            return false;
        }
    }
}
