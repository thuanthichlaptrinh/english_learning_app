-- V8: Create chat_messages table for AI chatbot
CREATE TABLE IF NOT EXISTS chat_messages (
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

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_chat_user_id ON chat_messages(user_id);
CREATE INDEX IF NOT EXISTS idx_chat_session_id ON chat_messages(session_id);
CREATE INDEX IF NOT EXISTS idx_chat_created_at ON chat_messages(created_at);

-- Add comment for table
COMMENT ON TABLE chat_messages IS 'Store chat history between users and AI chatbot';
COMMENT ON COLUMN chat_messages.session_id IS 'Session ID to group related conversations';
COMMENT ON COLUMN chat_messages.role IS 'Message sender role: USER, ASSISTANT, or SYSTEM';
COMMENT ON COLUMN chat_messages.context_used IS 'Context data used to generate AI response (FAQ + DB data)';
COMMENT ON COLUMN chat_messages.tokens_used IS 'Number of tokens consumed by Gemini API';
