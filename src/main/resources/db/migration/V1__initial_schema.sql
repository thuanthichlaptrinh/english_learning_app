-- V1: Initial database schema
-- Date: 2025-11-03
-- Description: Create initial tables for card-words application

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255),
    full_name VARCHAR(255),
    avatar_url VARCHAR(500),
    is_email_verified BOOLEAN DEFAULT FALSE,
    oauth_provider VARCHAR(50),
    oauth_provider_id VARCHAR(255),
    current_streak INTEGER DEFAULT 0,
    longest_streak INTEGER DEFAULT 0,
    last_activity_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_oauth ON users(oauth_provider, oauth_provider_id);

-- Create roles table
CREATE TABLE IF NOT EXISTS roles (
    id UUID PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create user_roles table (many-to-many)
CREATE TABLE IF NOT EXISTS user_roles (
    user_id UUID NOT NULL,
    role_id UUID NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);

-- Create topic table
CREATE TABLE IF NOT EXISTS topic (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create type table
CREATE TABLE IF NOT EXISTS type (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create vocabulary table
CREATE TABLE IF NOT EXISTS vocabulary (
    id UUID PRIMARY KEY,
    word VARCHAR(255) NOT NULL,
    meaning_vi TEXT NOT NULL,
    transcription VARCHAR(255),
    interpret TEXT,
    example_sentence TEXT,
    cefr VARCHAR(10),
    difficulty INTEGER,
    img VARCHAR(500),
    audio VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_vocabulary_word ON vocabulary(word);
CREATE INDEX idx_vocabulary_cefr ON vocabulary(cefr);

-- Create vocab_topic table (many-to-many)
CREATE TABLE IF NOT EXISTS vocab_topic (
    vocab_id UUID NOT NULL,
    topic_id UUID NOT NULL,
    PRIMARY KEY (vocab_id, topic_id),
    FOREIGN KEY (vocab_id) REFERENCES vocabulary(id) ON DELETE CASCADE,
    FOREIGN KEY (topic_id) REFERENCES topic(id) ON DELETE CASCADE
);

-- Create vocab_type table (many-to-many)
CREATE TABLE IF NOT EXISTS vocab_type (
    vocab_id UUID NOT NULL,
    type_id UUID NOT NULL,
    PRIMARY KEY (vocab_id, type_id),
    FOREIGN KEY (vocab_id) REFERENCES vocabulary(id) ON DELETE CASCADE,
    FOREIGN KEY (type_id) REFERENCES type(id) ON DELETE CASCADE
);

-- Create user_vocab_progress table
CREATE TABLE IF NOT EXISTS user_vocab_progress (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    vocab_id UUID NOT NULL,
    status VARCHAR(50),
    last_reviewed DATE,
    times_correct INTEGER DEFAULT 0,
    times_wrong INTEGER DEFAULT 0,
    ef_factor DOUBLE PRECISION DEFAULT 2.5,
    interval_days INTEGER DEFAULT 1,
    repetition INTEGER DEFAULT 0,
    next_review_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (vocab_id) REFERENCES vocabulary(id) ON DELETE CASCADE,
    UNIQUE (user_id, vocab_id)
);

CREATE INDEX idx_uvp_user_id ON user_vocab_progress(user_id);
CREATE INDEX idx_uvp_vocab_id ON user_vocab_progress(vocab_id);
CREATE INDEX idx_uvp_status ON user_vocab_progress(status);
CREATE INDEX idx_uvp_next_review_date ON user_vocab_progress(next_review_date);
CREATE INDEX idx_uvp_user_vocab ON user_vocab_progress(user_id, vocab_id);

-- Create game table
CREATE TABLE IF NOT EXISTS game (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    min_pairs INTEGER,
    max_pairs INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create game_session table
CREATE TABLE IF NOT EXISTS game_session (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL,
    game_id BIGINT NOT NULL,
    total_questions INTEGER DEFAULT 0,
    correct_count INTEGER DEFAULT 0,
    score INTEGER DEFAULT 0,
    accuracy DOUBLE PRECISION DEFAULT 0,
    duration INTEGER DEFAULT 0,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    finished_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (game_id) REFERENCES game(id) ON DELETE CASCADE
);

CREATE INDEX idx_game_session_user_id ON game_session(user_id);
CREATE INDEX idx_game_session_game_id ON game_session(game_id);

-- Create game_session_detail table
CREATE TABLE IF NOT EXISTS game_session_detail (
    id BIGSERIAL PRIMARY KEY,
    session_id BIGINT NOT NULL,
    vocab_id UUID NOT NULL,
    is_correct BOOLEAN NOT NULL,
    time_taken INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES game_session(id) ON DELETE CASCADE,
    FOREIGN KEY (vocab_id) REFERENCES vocabulary(id) ON DELETE CASCADE
);

CREATE INDEX idx_game_session_detail_session_id ON game_session_detail(session_id);

-- Create email_verification_token table
CREATE TABLE IF NOT EXISTS email_verification_token (
    id UUID PRIMARY KEY,
    token VARCHAR(255) NOT NULL UNIQUE,
    user_id UUID NOT NULL,
    expired_at TIMESTAMP NOT NULL,
    verified_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_email_verification_token ON email_verification_token(token);
CREATE INDEX idx_email_verification_user_id ON email_verification_token(user_id);

-- Create refresh_token table
CREATE TABLE IF NOT EXISTS refresh_token (
    id UUID PRIMARY KEY,
    token VARCHAR(500) NOT NULL UNIQUE,
    user_id UUID NOT NULL,
    expired_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_refresh_token ON refresh_token(token);
CREATE INDEX idx_refresh_token_user_id ON refresh_token(user_id);

-- Insert default roles
INSERT INTO roles (id, name) VALUES
    (gen_random_uuid(), 'ROLE_USER'),
    (gen_random_uuid(), 'ROLE_ADMIN')
ON CONFLICT (name) DO NOTHING;

-- Insert default games
INSERT INTO game (name, description, min_pairs, max_pairs) VALUES
    ('Quick Quiz', 'Quick vocabulary quiz game', 5, 20),
    ('Image Word Matching', 'Match words with images', 4, 10),
    ('Word Definition Matching', 'Match words with definitions', 4, 10)
ON CONFLICT (name) DO NOTHING;

