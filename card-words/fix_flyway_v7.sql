-- Script to fix Flyway migration V7 issue
-- Run this script directly on your PostgreSQL database

-- Step 1: Check current status of V7 migration
SELECT version, description, type, script, checksum, installed_on, execution_time, success
FROM flyway_schema_history
WHERE version = '7';

-- Step 2: Delete the failed V7 migration record (if it failed)
-- Uncomment the line below if the migration failed
-- DELETE FROM flyway_schema_history WHERE version = '7' AND success = false;

-- Step 3: If migration succeeded but checksum changed, delete it to re-run
-- Uncomment the line below to force re-run of V7 migration
-- DELETE FROM flyway_schema_history WHERE version = '7';

-- Step 4: Verify the action_logs table structure
SELECT column_name, data_type, character_maximum_length, is_nullable
FROM information_schema.columns
WHERE table_name = 'action_logs'
ORDER BY ordinal_position;

-- Step 5: Manual fix - Add missing columns if they don't exist
-- This is the same logic as V7 migration, run this if you want to fix manually
DO $$
BEGIN
    -- Add user_email column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'action_logs' AND column_name = 'user_email'
    ) THEN
        ALTER TABLE action_logs ADD COLUMN user_email VARCHAR(100);
        RAISE NOTICE 'Added user_email column';
    ELSE
        RAISE NOTICE 'user_email column already exists';
    END IF;

    -- Add user_name column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'action_logs' AND column_name = 'user_name'
    ) THEN
        ALTER TABLE action_logs ADD COLUMN user_name VARCHAR(100);
        RAISE NOTICE 'Added user_name column';
    ELSE
        RAISE NOTICE 'user_name column already exists';
    END IF;

    -- Add action_category column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'action_logs' AND column_name = 'action_category'
    ) THEN
        ALTER TABLE action_logs ADD COLUMN action_category VARCHAR(50);
        RAISE NOTICE 'Added action_category column';
    ELSE
        RAISE NOTICE 'action_category column already exists';
    END IF;

    -- Add metadata column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'action_logs' AND column_name = 'metadata'
    ) THEN
        ALTER TABLE action_logs ADD COLUMN metadata TEXT;
        RAISE NOTICE 'Added metadata column';
    ELSE
        RAISE NOTICE 'metadata column already exists';
    END IF;
END $$;

-- Step 6: Verify the fix
SELECT column_name, data_type, character_maximum_length, is_nullable
FROM information_schema.columns
WHERE table_name = 'action_logs'
AND column_name IN ('user_email', 'user_name', 'action_category', 'metadata')
ORDER BY column_name;
