-- Create user_game_settings table
CREATE TABLE IF NOT EXISTS user_game_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    game_name VARCHAR(50) NOT NULL,

    -- Quick Quiz settings
    quick_quiz_total_questions INT,
    quick_quiz_time_per_question INT,

    -- Image Word Matching settings
    image_word_total_pairs INT,

    -- Word Definition Matching settings
    word_definition_total_pairs INT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_user_game_settings_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT uq_user_game UNIQUE(user_id, game_name)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_ugs_user_id ON user_game_settings(user_id);
CREATE INDEX IF NOT EXISTS idx_ugs_game_name ON user_game_settings(game_name);

-- Add comment
COMMENT ON TABLE user_game_settings IS 'Stores user preferences for game settings (questions count, time limits, pairs count)';

