-- V5: Remove game_name from user_game_settings (IF EXISTS)
-- Migration to remove game_name column and make one record per user
-- Logic: Only drop if exists, only add constraint if not exists

DO $$
BEGIN
    -- Skip if user_game_settings table does not exist
    IF NOT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'user_game_settings'
    ) THEN
        RAISE NOTICE 'V5: Table user_game_settings does not exist. Skipping migration.';
        RETURN;
    END IF;

    -- Drop unique constraint if exists
    IF EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'uq_user_game' 
        AND conrelid = 'user_game_settings'::regclass
    ) THEN
        ALTER TABLE user_game_settings DROP CONSTRAINT uq_user_game;
        RAISE NOTICE 'V5: Dropped constraint uq_user_game';
    END IF;

    -- Drop index on game_name if exists
    IF EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE tablename = 'user_game_settings' 
        AND indexname = 'idx_ugs_game_name'
    ) THEN
        DROP INDEX idx_ugs_game_name;
        RAISE NOTICE 'V5: Dropped index idx_ugs_game_name';
    END IF;

    -- Remove game_name column if exists
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public'
        AND table_name = 'user_game_settings' 
        AND column_name = 'game_name'
    ) THEN
        ALTER TABLE user_game_settings DROP COLUMN game_name;
        RAISE NOTICE 'V5: Dropped column game_name';
    END IF;

    -- Add unique constraint on user_id only if not exists
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'uq_user_game_settings_user_id' 
        AND conrelid = 'user_game_settings'::regclass
    ) THEN
        ALTER TABLE user_game_settings ADD CONSTRAINT uq_user_game_settings_user_id UNIQUE (user_id);
        RAISE NOTICE 'V5: Added constraint uq_user_game_settings_user_id';
    ELSE
        RAISE NOTICE 'V5: Constraint uq_user_game_settings_user_id already exists. Skipped.';
    END IF;
END $$;
