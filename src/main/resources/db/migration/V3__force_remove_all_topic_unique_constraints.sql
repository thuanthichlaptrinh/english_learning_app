-- V3: Force remove ALL unique constraints on topic_id
-- This migration runs after Hibernate potentially recreates constraints
-- Ensures Many-to-One relationship works correctly

DO $$
DECLARE
    r RECORD;
BEGIN
    -- Drop ALL unique constraints related to topic_id on vocab table
    FOR r IN (
        SELECT conname 
        FROM pg_constraint 
        WHERE conrelid = 'vocab'::regclass
        AND contype = 'u'
        AND (
            conname LIKE '%topic%' 
            OR conname IN (
                SELECT c.conname 
                FROM pg_constraint c
                JOIN pg_attribute a ON a.attnum = ANY(c.conkey) AND a.attrelid = c.conrelid
                WHERE a.attname = 'topic_id' 
                AND c.conrelid = 'vocab'::regclass
            )
        )
    ) LOOP
        RAISE NOTICE 'Dropping unique constraint: %', r.conname;
        EXECUTE 'ALTER TABLE vocab DROP CONSTRAINT IF EXISTS ' || quote_ident(r.conname);
    END LOOP;

    -- Drop ALL unique indexes on topic_id
    FOR r IN (
        SELECT indexname 
        FROM pg_indexes 
        WHERE tablename = 'vocab'
        AND (
            (indexname LIKE '%topic%' AND indexdef LIKE '%UNIQUE%')
            OR (indexdef LIKE '%topic_id%' AND indexdef LIKE '%UNIQUE%')
        )
    ) LOOP
        RAISE NOTICE 'Dropping unique index: %', r.indexname;
        EXECUTE 'DROP INDEX IF EXISTS ' || quote_ident(r.indexname);
    END LOOP;

    -- Ensure non-unique index exists for performance
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE tablename = 'vocab' 
        AND indexname = 'idx_vocab_topic_id'
    ) THEN
        CREATE INDEX idx_vocab_topic_id ON vocab(topic_id);
        RAISE NOTICE 'Created non-unique index: idx_vocab_topic_id';
    END IF;

END $$;

-- Verify: Check remaining constraints
DO $$
DECLARE
    constraint_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO constraint_count
    FROM pg_constraint 
    WHERE conrelid = 'vocab'::regclass
    AND contype = 'u'
    AND conname LIKE '%topic%';
    
    IF constraint_count = 0 THEN
        RAISE NOTICE '✓ SUCCESS: No unique constraints on topic_id in vocab table';
    ELSE
        RAISE WARNING '✗ WARNING: Still found % unique constraint(s) on topic_id', constraint_count;
    END IF;
END $$;
