-- V2: Add additional indexes and constraints
-- Date: 2025-11-03
-- Description: Add performance indexes and additional constraints

-- Add indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);
CREATE INDEX IF NOT EXISTS idx_vocabulary_created_at ON vocabulary(created_at);
CREATE INDEX IF NOT EXISTS idx_game_session_started_at ON game_session(started_at);
CREATE INDEX IF NOT EXISTS idx_game_session_finished_at ON game_session(finished_at);

-- Add composite indexes for common queries
CREATE INDEX IF NOT EXISTS idx_game_session_user_game ON game_session(user_id, game_id);
CREATE INDEX IF NOT EXISTS idx_uvp_user_status ON user_vocab_progress(user_id, status);
CREATE INDEX IF NOT EXISTS idx_uvp_user_next_review ON user_vocab_progress(user_id, next_review_date);

-- Add check constraints
ALTER TABLE user_vocab_progress
ADD CONSTRAINT check_times_correct_positive CHECK (times_correct >= 0);

ALTER TABLE user_vocab_progress
ADD CONSTRAINT check_times_wrong_positive CHECK (times_wrong >= 0);

ALTER TABLE game_session
ADD CONSTRAINT check_correct_count_positive CHECK (correct_count >= 0);

ALTER TABLE game_session
ADD CONSTRAINT check_score_positive CHECK (score >= 0);

-- Add comments for documentation
COMMENT ON TABLE users IS 'User accounts and profile information';
COMMENT ON TABLE vocabulary IS 'Vocabulary words with translations and metadata';
COMMENT ON TABLE user_vocab_progress IS 'Tracks user learning progress for each vocabulary';
COMMENT ON TABLE game_session IS 'Records of game sessions played by users';
COMMENT ON TABLE game_session_detail IS 'Detailed results for each vocabulary in a game session';

