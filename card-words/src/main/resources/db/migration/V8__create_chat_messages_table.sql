-- V8: Create chat_messages table for AI chatbot (IF NOT EXISTS)
-- Logic: Only create table and indexes if they don't exist

DO $$
BEGIN
    -- Skip if users table does not exist (required for foreign key)
    IF NOT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'users'
    ) THEN
        RAISE NOTICE 'V8: Table users does not exist. Skipping migration.';
        RETURN;
    END IF;

    -- Create table only if it doesn't exist
    IF NOT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'chat_messages'
    ) THEN
        CREATE TABLE chat_messages (
            id UUID PRIMARY KEY,
            session_id UUID NOT NULL,
            user_id UUID NOT NULL,
            role VARCHAR(10) NOT NULL CHECK (role IN ('USER', 'ASSISTANT', 'SYSTEM')),
            content TEXT NOT NULL,
            context_used TEXT,
            tokens_used INTEGER,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            CONSTRAINT fk_chat_messages_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
        );
        
        COMMENT ON TABLE chat_messages IS 'Store chat history between users and AI chatbot';
        COMMENT ON COLUMN chat_messages.session_id IS 'Session ID to group related conversations';
        COMMENT ON COLUMN chat_messages.role IS 'Message sender role: USER, ASSISTANT, or SYSTEM';
        COMMENT ON COLUMN chat_messages.context_used IS 'Context data used to generate AI response (FAQ + DB data)';
        COMMENT ON COLUMN chat_messages.tokens_used IS 'Number of tokens consumed by Gemini API';
        
        RAISE NOTICE 'V8: Created chat_messages table';
    ELSE
        RAISE NOTICE 'V8: Table chat_messages already exists. Skipped.';
    END IF;

    -- Create indexes only if they don't exist
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE tablename = 'chat_messages' 
        AND indexname = 'idx_chat_user_id'
    ) THEN
        CREATE INDEX idx_chat_user_id ON chat_messages(user_id);
        RAISE NOTICE 'V8: Created index idx_chat_user_id';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE tablename = 'chat_messages' 
        AND indexname = 'idx_chat_session_id'
    ) THEN
        CREATE INDEX idx_chat_session_id ON chat_messages(session_id);
        RAISE NOTICE 'V8: Created index idx_chat_session_id';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE tablename = 'chat_messages' 
        AND indexname = 'idx_chat_created_at'
    ) THEN
        CREATE INDEX idx_chat_created_at ON chat_messages(created_at);
        RAISE NOTICE 'V8: Created index idx_chat_created_at';
    END IF;

    RAISE NOTICE 'V8: Migration completed';
END $$;
