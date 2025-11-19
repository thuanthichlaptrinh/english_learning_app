-- V4: Add img column to topics table (IF NOT EXISTS)
-- Purpose: Store Firebase Storage URL for topic images
-- Logic: Only add column if it doesn't exist

DO $$
BEGIN
    -- Skip if topics table does not exist
    IF NOT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'topics'
    ) THEN
        RAISE NOTICE 'V4: Table topics does not exist. Skipping migration.';
        RETURN;
    END IF;

    -- Add img column only if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public'
        AND table_name = 'topics' 
        AND column_name = 'img'
    ) THEN
        ALTER TABLE topics ADD COLUMN img VARCHAR(500);
        COMMENT ON COLUMN topics.img IS 'Firebase Storage URL for topic image';
        RAISE NOTICE 'V4: Added img column to topics table';
    ELSE
        RAISE NOTICE 'V4: Column img already exists. Skipped.';
    END IF;
END $$;
