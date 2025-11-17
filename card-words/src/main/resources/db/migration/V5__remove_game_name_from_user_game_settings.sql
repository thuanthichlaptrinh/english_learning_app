-- V5__remove_game_name_from_user_game_settings.sql
-- Migration to remove game_name column and make one record per user

-- Drop unique constraint
ALTER TABLE user_game_settings DROP CONSTRAINT IF EXISTS uq_user_game;

-- Drop index on game_name
DROP INDEX IF EXISTS idx_ugs_game_name;

-- Remove game_name column
ALTER TABLE user_game_settings DROP COLUMN IF EXISTS game_name;

-- Add unique constraint on user_id only (one record per user)
ALTER TABLE user_game_settings ADD CONSTRAINT uq_user_game_settings_user_id UNIQUE (user_id);
