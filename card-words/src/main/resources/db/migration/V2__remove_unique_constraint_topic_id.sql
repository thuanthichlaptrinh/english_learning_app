-- V2: Remove unique constraint from topic_id in vocab table (IF EXISTS)
-- This allows multiple vocabs to share the same topic (Many-to-One relationship)
-- Logic: Only DROP if exists, Only CREATE if not exists

DO $$
DECLARE
    r RECORD;
    constraint_count INTEGER := 0;
    index_count INTEGER := 0;
BEGIN
    -- Skip if vocab table does not exist (new database)
    IF NOT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'vocab'
    ) THEN
        RAISE NOTICE 'V2: Table vocab does not exist. Skipping migration.';
        RETURN;
    END IF;

    RAISE NOTICE 'V2: Starting migration on existing vocab table...';

    -- Drop unique constraints ONLY if they exist
    FOR r IN (
        SELECT conname 
        FROM pg_constraint 
        WHERE conrelid = 'vocab'::regclass
        AND contype = 'u'
        AND (conname LIKE '%topic_id%' OR conname = 'uk_vocab_topic_id')
    ) LOOP
        EXECUTE 'ALTER TABLE vocab DROP CONSTRAINT IF EXISTS ' || quote_ident(r.conname);
        RAISE NOTICE 'V2: Dropped constraint %', r.conname;
        constraint_count := constraint_count + 1;
    END LOOP;

    -- Drop unique indexes ONLY if they exist
    FOR r IN (
        SELECT indexname 
        FROM pg_indexes 
        WHERE tablename = 'vocab'
        AND indexname LIKE '%topic_id%'
        AND indexdef LIKE '%UNIQUE%'
    ) LOOP
        EXECUTE 'DROP INDEX IF EXISTS ' || quote_ident(r.indexname);
        RAISE NOTICE 'V2: Dropped unique index %', r.indexname;
        index_count := index_count + 1;
    END LOOP;

    -- Create regular index ONLY if it does not exist
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE tablename = 'vocab' 
        AND indexname = 'idx_vocab_topic_id'
    ) THEN
        CREATE INDEX idx_vocab_topic_id ON vocab(topic_id);
        RAISE NOTICE 'V2: Created non-unique index idx_vocab_topic_id';
    ELSE
        RAISE NOTICE 'V2: Index idx_vocab_topic_id already exists. Skipped creation.';
    END IF;

    RAISE NOTICE 'V2: Migration completed. Dropped % constraints, % indexes', constraint_count, index_count;
END $$;
