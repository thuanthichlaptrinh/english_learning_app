-- V9: Add performance indexes (IF NOT EXISTS)
-- Logic: Only create indexes if they don't exist

DO $$
DECLARE
    index_created INTEGER := 0;
BEGIN
    RAISE NOTICE 'V9: Starting performance indexes creation...';

    -- Vocab indexes
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'vocab') THEN
        IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_vocab_cefr') THEN
            CREATE INDEX idx_vocab_cefr ON vocab(cefr);
            index_created := index_created + 1;
        END IF;
        
        IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_vocab_img_notnull') THEN
            CREATE INDEX idx_vocab_img_notnull ON vocab(img) WHERE img IS NOT NULL;
            index_created := index_created + 1;
        END IF;
        
        IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_vocab_word') THEN
            CREATE INDEX idx_vocab_word ON vocab(word);
            index_created := index_created + 1;
        END IF;
    END IF;

    -- Game sessions indexes
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'game_sessions') THEN
        IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_game_sessions_game_score') THEN
            CREATE INDEX idx_game_sessions_game_score ON game_sessions(game_id, score DESC);
            index_created := index_created + 1;
        END IF;
        
        IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_game_sessions_user_started') THEN
            CREATE INDEX idx_game_sessions_user_started ON game_sessions(user_id, started_at DESC);
            index_created := index_created + 1;
        END IF;
        
        IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_game_sessions_user_game') THEN
            CREATE INDEX idx_game_sessions_user_game ON game_sessions(user_id, game_id);
            index_created := index_created + 1;
        END IF;
    END IF;

    -- User vocab progress indexes
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'user_vocab_progress') THEN
        IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_user_vocab_progress_user_status') THEN
            CREATE INDEX idx_user_vocab_progress_user_status ON user_vocab_progress(user_id, status);
            index_created := index_created + 1;
        END IF;
        
        IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_user_vocab_progress_next_review') THEN
            CREATE INDEX idx_user_vocab_progress_next_review ON user_vocab_progress(user_id, next_review_date) WHERE next_review_date IS NOT NULL;
            index_created := index_created + 1;
        END IF;
        
        IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_user_vocab_progress_last_reviewed') THEN
            CREATE INDEX idx_user_vocab_progress_last_reviewed ON user_vocab_progress(user_id, last_reviewed DESC);
            index_created := index_created + 1;
        END IF;
    END IF;

    -- Game session details indexes
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'game_session_details') THEN
        IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_game_session_details_session') THEN
            CREATE INDEX idx_game_session_details_session ON game_session_details(session_id);
            index_created := index_created + 1;
        END IF;
    END IF;

    -- Users indexes
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'users') THEN
        IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_users_email_unique') THEN
            CREATE INDEX idx_users_email_unique ON users(email);
            index_created := index_created + 1;
        END IF;
        
        IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_users_name') THEN
            CREATE INDEX idx_users_name ON users(name);
            index_created := index_created + 1;
        END IF;
    END IF;

    -- Topics indexes
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'topics') THEN
        IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_topics_name_unique') THEN
            CREATE INDEX idx_topics_name_unique ON topics(name);
            index_created := index_created + 1;
        END IF;
    END IF;

    -- Notifications indexes
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'notifications') THEN
        IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_notifications_user_created') THEN
            CREATE INDEX idx_notifications_user_created ON notifications(user_id, created_at DESC);
            index_created := index_created + 1;
        END IF;
        
        IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_notifications_user_read') THEN
            CREATE INDEX idx_notifications_user_read ON notifications(user_id, is_read, created_at DESC);
            index_created := index_created + 1;
        END IF;
    END IF;

    -- Action logs indexes
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'action_logs') THEN
        IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_action_logs_user_created') THEN
            CREATE INDEX idx_action_logs_user_created ON action_logs(user_id, created_at DESC);
            index_created := index_created + 1;
        END IF;
        
        IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_action_logs_action_type_time') THEN
            CREATE INDEX idx_action_logs_action_type_time ON action_logs(action_type, created_at DESC);
            index_created := index_created + 1;
        END IF;
    END IF;

    RAISE NOTICE 'V9: Created % new performance indexes', index_created;
END $$;

