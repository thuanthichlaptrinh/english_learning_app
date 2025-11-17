-- V6__insert_initial_games_data.sql
-- Insert initial game data for Quick Quiz, Image Word Matching, and Word Definition Matching

INSERT INTO games (name, description, created_at, updated_at)
SELECT 'Quick Reflex Quiz', 'Trắc nghiệm phản xạ nhanh với câu hỏi Multiple Choice', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM games WHERE name = 'Quick Reflex Quiz');

INSERT INTO games (name, description, created_at, updated_at)
SELECT 'Image-Word Matching', 'Ghép thẻ hình ảnh với từ vựng tương ứng', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM games WHERE name = 'Image-Word Matching');

INSERT INTO games (name, description, created_at, updated_at)
SELECT 'Word-Definition Matching', 'Ghép thẻ từ vựng với nghĩa tương ứng', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM games WHERE name = 'Word-Definition Matching');
