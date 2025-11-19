-- V3: Force remove ALL unique constraints and indexes on topic_id column (IF EXISTS)
-- This migration runs AFTER V2 to ensure absolutely no unique constraints remain
-- Logic: Only DROP if exists, Only CREATE if not exists

DO $$
DECLARE
    r RECORD;
    constraint_count INTEGER := 0;
    index_count INTEGER := 0;
    total_operations INTEGER := 0;
BEGIN
    -- Skip if vocab table does not exist (new database)
    IF NOT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'vocab'
    ) THEN
        RAISE NOTICE 'V3: Table vocab does not exist. Skipping migration.';
        RETURN;
    END IF;

    RAISE NOTICE 'V3: Starting comprehensive cleanup of topic_id constraints and indexes...';

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
        RAISE NOTICE 'V3: Dropping unique constraint: %', r.conname;
        EXECUTE 'ALTER TABLE vocab DROP CONSTRAINT IF EXISTS ' || quote_ident(r.conname);
        constraint_count := constraint_count + 1;
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
        RAISE NOTICE 'V3: Dropping unique index: %', r.indexname;
        EXECUTE 'DROP INDEX IF EXISTS ' || quote_ident(r.indexname);
        index_count := index_count + 1;
    END LOOP;

    total_operations := constraint_count + index_count;

    -- Ensure non-unique index exists for performance
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE tablename = 'vocab' 
        AND indexname = 'idx_vocab_topic_id'
    ) THEN
        CREATE INDEX idx_vocab_topic_id ON vocab(topic_id);
        RAISE NOTICE 'V3: Created regular index idx_vocab_topic_id';
    ELSE
        RAISE NOTICE 'V3: Index idx_vocab_topic_id already exists. Skipped creation.';
    END IF;

    IF total_operations > 0 THEN
        RAISE NOTICE 'V3: Cleanup completed. Removed % constraints, % unique indexes', constraint_count, index_count;
    ELSE
        RAISE NOTICE 'V3: No cleanup needed. Table already clean.';
    END IF;
END $$;
