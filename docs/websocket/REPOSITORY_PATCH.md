# Repository Patch - Thêm Method getTrainingDataFromProgress

## Thêm vào UserVocabProgressRepository.java

Thêm method này vào cuối interface `UserVocabProgressRepository` (trước dấu `}` cuối cùng):

```java
    // === TRAINING DATA EXPORT FOR ML MODEL ===
    /**
     * Lấy training data từ user_vocab_progress để train ML model
     * Target: forgot = 1 nếu accuracy_rate < 0.5, ngược lại forgot = 0
     */
    @Query(value = """
        WITH user_stats AS (
            SELECT 
                u.id as user_id,
                COUNT(DISTINCT uvp.vocab_id) as total_vocabs,
                COALESCE(AVG(CASE 
                    WHEN uvp.times_correct + uvp.times_wrong > 0 
                    THEN uvp.times_correct::numeric / (uvp.times_correct + uvp.times_wrong)
                    ELSE 0 
                END), 0) as user_accuracy,
                COALESCE(u.current_streak, 0) as current_streak,
                COALESCE(u.total_study_days, 0) as total_study_days
            FROM users u
            LEFT JOIN user_vocab_progress uvp ON u.id = uvp.user_id
            GROUP BY u.id, u.current_streak, u.total_study_days
        )
        SELECT 
            uvp.user_id::text,
            uvp.vocab_id::text,
            v.word,
            us.total_vocabs::integer as user_total_vocabs,
            us.user_accuracy::double precision,
            us.current_streak::integer as user_streak,
            us.total_study_days::integer,
            CASE v.cefr 
                WHEN 'A1' THEN 1 WHEN 'A2' THEN 2 
                WHEN 'B1' THEN 3 WHEN 'B2' THEN 4 
                WHEN 'C1' THEN 5 WHEN 'C2' THEN 6 
                ELSE 3 
            END::integer as vocab_difficulty,
            LENGTH(v.word)::integer as vocab_length,
            COALESCE(t.name, 'Unknown') as topic_name,
            uvp.times_correct::integer,
            uvp.times_wrong::integer,
            CASE 
                WHEN uvp.times_correct + uvp.times_wrong > 0 
                THEN (uvp.times_correct::numeric / (uvp.times_correct + uvp.times_wrong))::double precision
                ELSE 0::double precision
            END as accuracy_rate,
            uvp.repetition::integer,
            uvp.ef_factor::double precision,
            uvp.interval_days::integer,
            uvp.status::text,
            COALESCE(EXTRACT(DAY FROM (CURRENT_DATE - uvp.last_reviewed))::integer, 999) as days_since_last_review,
            COALESCE(EXTRACT(DAY FROM (uvp.next_review_date - CURRENT_DATE))::integer, 0) as days_until_next_review,
            CASE WHEN uvp.next_review_date < CURRENT_DATE THEN 1 ELSE 0 END::integer as is_overdue,
            CASE 
                WHEN uvp.next_review_date < CURRENT_DATE 
                THEN EXTRACT(DAY FROM (CURRENT_DATE - uvp.next_review_date))::integer
                ELSE 0 
            END::integer as overdue_days,
            EXTRACT(HOUR FROM uvp.updated_at)::integer as hour_of_day,
            EXTRACT(DOW FROM uvp.updated_at)::integer as day_of_week,
            CASE WHEN EXTRACT(DOW FROM uvp.updated_at) IN (0, 6) THEN 1 ELSE 0 END::integer as is_weekend,
            CASE 
                WHEN uvp.times_correct + uvp.times_wrong = 0 THEN NULL
                WHEN (uvp.times_correct::numeric / (uvp.times_correct + uvp.times_wrong)) < 0.5 THEN 1
                ELSE 0
            END::integer as forgot,
            uvp.updated_at
        FROM user_vocab_progress uvp
        JOIN vocabs v ON uvp.vocab_id = v.id
        LEFT JOIN topics t ON v.topic_id = t.id
        JOIN user_stats us ON uvp.user_id = us.user_id
        WHERE (uvp.times_correct + uvp.times_wrong) > 0
            AND uvp.status IN ('KNOWN', 'UNKNOWN', 'MASTERED')
            AND uvp.updated_at >= CURRENT_DATE - INTERVAL '6 months'
        ORDER BY uvp.updated_at DESC
        """, nativeQuery = true)
    List<Object[]> getTrainingDataFromProgress();
```

## Vị trí thêm

Thêm vào cuối file, trước dấu `}` cuối cùng của interface.

Ví dụ:
```java
public interface UserVocabProgressRepository extends JpaRepository<UserVocabProgress, UUID> {
    
    // ... existing methods ...
    
    long countLearnedVocabsByUserAndTopic(@Param("userId") UUID userId, @Param("topicId") Long topicId);
    
    // === THÊM METHOD MỚI Ở ĐÂY ===
    @Query(value = """
        WITH user_stats AS (
        ...
        """, nativeQuery = true)
    List<Object[]> getTrainingDataFromProgress();
    
} // <-- Dấu đóng của interface
```
