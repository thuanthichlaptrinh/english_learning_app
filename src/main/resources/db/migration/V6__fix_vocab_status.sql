    -- Migration: Fix vocab status for existing records
-- Date: 2025-11-03
-- Description: Set status = NEW for records with NULL status and auto-upgrade to MASTERED

-- Step 1: Set status = NEW for all records with NULL status
UPDATE user_vocab_progress
SET status = 'NEW'
WHERE status IS NULL;

-- Step 2: Auto-upgrade to MASTERED for records that meet the criteria
-- Criteria: timesCorrect >= 10, timesWrong <= 2, accuracy >= 80%
UPDATE user_vocab_progress
SET status = 'MASTERED'
WHERE status != 'MASTERED'
  AND times_correct >= 10
  AND times_wrong <= 2
  AND (times_correct::float / NULLIF(times_correct + times_wrong, 0)) >= 0.8;

-- Step 3: Add NOT NULL constraint to status column
ALTER TABLE user_vocab_progress
ALTER COLUMN status SET NOT NULL;

-- Step 4: Add default value NEW for status column
ALTER TABLE user_vocab_progress
ALTER COLUMN status SET DEFAULT 'NEW';

-- Step 5: Add check constraint to ensure valid status values
ALTER TABLE user_vocab_progress
ADD CONSTRAINT check_valid_status
CHECK (status IN ('NEW', 'KNOWN', 'UNKNOWN', 'MASTERED'));

-- Verification queries
-- Check status distribution
SELECT
    status,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage
FROM user_vocab_progress
GROUP BY status
ORDER BY count DESC;

-- Check newly mastered vocabs
SELECT
    u.email as user_email,
    v.word,
    uvp.times_correct,
    uvp.times_wrong,
    ROUND(uvp.times_correct::numeric / NULLIF(uvp.times_correct + uvp.times_wrong, 0), 2) as accuracy
FROM user_vocab_progress uvp
JOIN users u ON uvp.user_id = u.id
JOIN vocabulary v ON uvp.vocab_id = v.id
WHERE uvp.status = 'MASTERED'
ORDER BY uvp.times_correct DESC
LIMIT 20;

