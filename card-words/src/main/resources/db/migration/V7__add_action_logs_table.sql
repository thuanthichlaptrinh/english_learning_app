-- V7: Add new columns to existing action_logs table
-- Migration to add user_email, user_name, action_category, metadata columns

-- Add new columns only if they don't exist
DO $$
BEGIN
    -- Add user_email column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'action_logs' AND column_name = 'user_email'
    ) THEN
        ALTER TABLE action_logs ADD COLUMN user_email VARCHAR(100);
    END IF;

    -- Add user_name column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'action_logs' AND column_name = 'user_name'
    ) THEN
        ALTER TABLE action_logs ADD COLUMN user_name VARCHAR(100);
    END IF;

    -- Add action_category column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'action_logs' AND column_name = 'action_category'
    ) THEN
        ALTER TABLE action_logs ADD COLUMN action_category VARCHAR(50);
    END IF;

    -- Add metadata column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'action_logs' AND column_name = 'metadata'
    ) THEN
        ALTER TABLE action_logs ADD COLUMN metadata TEXT;
    END IF;
END $$;
