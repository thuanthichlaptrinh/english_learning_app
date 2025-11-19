-- V7: Add new columns to existing action_logs table (IF NOT EXISTS)
-- Migration to add user_email, user_name, action_category, metadata columns
-- Logic: Only add columns if table exists and column doesn't exist

DO $$
BEGIN
    -- Skip if action_logs table does not exist
    IF NOT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'action_logs'
    ) THEN
        RAISE NOTICE 'V7: Table action_logs does not exist. Skipping migration.';
        RETURN;
    END IF;

    -- Add user_email column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public'
        AND table_name = 'action_logs' 
        AND column_name = 'user_email'
    ) THEN
        ALTER TABLE action_logs ADD COLUMN user_email VARCHAR(100);
        RAISE NOTICE 'V7: Added user_email column';
    ELSE
        RAISE NOTICE 'V7: Column user_email already exists. Skipped.';
    END IF;

    -- Add user_name column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public'
        AND table_name = 'action_logs' 
        AND column_name = 'user_name'
    ) THEN
        ALTER TABLE action_logs ADD COLUMN user_name VARCHAR(100);
        RAISE NOTICE 'V7: Added user_name column';
    ELSE
        RAISE NOTICE 'V7: Column user_name already exists. Skipped.';
    END IF;

    -- Add action_category column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public'
        AND table_name = 'action_logs' 
        AND column_name = 'action_category'
    ) THEN
        ALTER TABLE action_logs ADD COLUMN action_category VARCHAR(50);
        RAISE NOTICE 'V7: Added action_category column';
    ELSE
        RAISE NOTICE 'V7: Column action_category already exists. Skipped.';
    END IF;

    -- Add metadata column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public'
        AND table_name = 'action_logs' 
        AND column_name = 'metadata'
    ) THEN
        ALTER TABLE action_logs ADD COLUMN metadata TEXT;
        RAISE NOTICE 'V7: Added metadata column';
    ELSE
        RAISE NOTICE 'V7: Column metadata already exists. Skipped.';
    END IF;

    RAISE NOTICE 'V7: Migration completed';
END $$;
