-- V10: Add missing columns to action_logs table
-- Migration to add user_email, user_name, action_category, metadata columns
-- These columns were defined in the entity but missing from the database schema

DO $$
BEGIN
    -- Add user_email column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public'
        AND table_name = 'action_logs' 
        AND column_name = 'user_email'
    ) THEN
        ALTER TABLE action_logs ADD COLUMN user_email VARCHAR(100);
        RAISE NOTICE 'V10: Added user_email column';
    ELSE
        RAISE NOTICE 'V10: Column user_email already exists. Skipped.';
    END IF;

    -- Add user_name column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public'
        AND table_name = 'action_logs' 
        AND column_name = 'user_name'
    ) THEN
        ALTER TABLE action_logs ADD COLUMN user_name VARCHAR(100);
        RAISE NOTICE 'V10: Added user_name column';
    ELSE
        RAISE NOTICE 'V10: Column user_name already exists. Skipped.';
    END IF;

    -- Add action_category column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public'
        AND table_name = 'action_logs' 
        AND column_name = 'action_category'
    ) THEN
        ALTER TABLE action_logs ADD COLUMN action_category VARCHAR(50);
        RAISE NOTICE 'V10: Added action_category column';
    ELSE
        RAISE NOTICE 'V10: Column action_category already exists. Skipped.';
    END IF;

    -- Add metadata column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public'
        AND table_name = 'action_logs' 
        AND column_name = 'metadata'
    ) THEN
        ALTER TABLE action_logs ADD COLUMN metadata TEXT;
        RAISE NOTICE 'V10: Added metadata column';
    ELSE
        RAISE NOTICE 'V10: Column metadata already exists. Skipped.';
    END IF;

    RAISE NOTICE 'V10: Migration completed successfully';
END $$;
