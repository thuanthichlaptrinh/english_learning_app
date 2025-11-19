CREATE INDEX IF NOT EXISTS idx_vocab_cefr ON vocab(cefr);
CREATE INDEX IF NOT EXISTS idx_vocab_img_notnull ON vocab(img) WHERE img IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_vocab_word ON vocab(word);

CREATE INDEX IF NOT EXISTS idx_game_sessions_game_score ON game_sessions(game_id, score DESC);
CREATE INDEX IF NOT EXISTS idx_game_sessions_user_started ON game_sessions(user_id, started_at DESC);
CREATE INDEX IF NOT EXISTS idx_game_sessions_user_game ON game_sessions(user_id, game_id);

CREATE INDEX IF NOT EXISTS idx_user_vocab_progress_user_status ON user_vocab_progress(user_id, status);
CREATE INDEX IF NOT EXISTS idx_user_vocab_progress_next_review ON user_vocab_progress(user_id, next_review_date) WHERE next_review_date IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_user_vocab_progress_last_reviewed ON user_vocab_progress(user_id, last_reviewed DESC);

CREATE INDEX IF NOT EXISTS idx_game_session_details_session ON game_session_details(session_id);

CREATE INDEX IF NOT EXISTS idx_users_email_unique ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_name ON users(name);

CREATE INDEX IF NOT EXISTS idx_topics_name_unique ON topics(name);

CREATE INDEX IF NOT EXISTS idx_notifications_user_created ON notifications(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_notifications_user_read ON notifications(user_id, is_read, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_action_logs_user_created ON action_logs(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_action_logs_action_type_time ON action_logs(action_type, created_at DESC);

