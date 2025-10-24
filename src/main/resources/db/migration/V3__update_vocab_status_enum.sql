-- Migration: Update VocabStatus enum values
-- Date: 2025-10-24
-- Description: Migrate existing status values to new 4-status system (NEW, KNOWN, UNKNOWN, MASTERED)

-- Step 1: Update existing values
-- "NEW" stays as "NEW"
-- "LEARNING" -> "KNOWN" (đang học nghĩa là đã biết)
-- "MASTERED" stays as "MASTERED"
-- NULL -> không update (để frontend hiển thị là NEW)

UPDATE user_vocab_progress 
SET status = 'KNOWN' 
WHERE status = 'LEARNING';

-- Step 2: Set default KNOWN for records with timesCorrect > 0 but status is NULL
UPDATE user_vocab_progress 
SET status = 'KNOWN' 
WHERE status IS NULL AND times_correct > 0;

-- Step 3: Validate - Check distribution
-- (Uncomment để kiểm tra sau khi migrate)
-- SELECT status, COUNT(*) as count 
-- FROM user_vocab_progress 
-- GROUP BY status;

-- Expected results:
-- NEW: Số từ mới chưa học
-- KNOWN: Số từ đã thuộc 
-- UNKNOWN: 0 (chưa có ai click "Chưa thuộc")
-- MASTERED: Số từ đã thành thạo
-- NULL: Các từ chưa có progress (sẽ hiển thị là NEW ở frontend)
