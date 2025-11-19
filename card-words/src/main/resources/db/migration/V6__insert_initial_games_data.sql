-- V6: Insert initial games data (IF NOT EXISTS)
-- Insert initial game data for Quick Quiz, Image Word Matching, and Word Definition Matching
-- Logic: Only insert if table exists and record doesn't exist

DO $$
BEGIN
    -- Skip if games table does not exist
    IF NOT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'games'
    ) THEN
        RAISE NOTICE 'V6: Table games does not exist. Skipping migration.';
        RETURN;
    END IF;

    -- Insert Quick Reflex Quiz if not exists
    IF NOT EXISTS (SELECT 1 FROM games WHERE name = 'Quick Reflex Quiz') THEN
        INSERT INTO games (name, description, created_at, updated_at)
        VALUES ('Quick Reflex Quiz', 'Trắc nghiệm phản xạ nhanh với câu hỏi Multiple Choice', NOW(), NOW());
        RAISE NOTICE 'V6: Inserted Quick Reflex Quiz';
    ELSE
        RAISE NOTICE 'V6: Quick Reflex Quiz already exists. Skipped.';
    END IF;

    -- Insert Image-Word Matching if not exists
    IF NOT EXISTS (SELECT 1 FROM games WHERE name = 'Image-Word Matching') THEN
        INSERT INTO games (name, description, created_at, updated_at)
        VALUES ('Image-Word Matching', 'Ghép thẻ hình ảnh với từ vựng tương ứng', NOW(), NOW());
        RAISE NOTICE 'V6: Inserted Image-Word Matching';
    ELSE
        RAISE NOTICE 'V6: Image-Word Matching already exists. Skipped.';
    END IF;

    -- Insert Word-Definition Matching if not exists
    IF NOT EXISTS (SELECT 1 FROM games WHERE name = 'Word-Definition Matching') THEN
        INSERT INTO games (name, description, created_at, updated_at)
        VALUES ('Word-Definition Matching', 'Ghép thẻ từ vựng với nghĩa tương ứng', NOW(), NOW());
        RAISE NOTICE 'V6: Inserted Word-Definition Matching';
    ELSE
        RAISE NOTICE 'V6: Word-Definition Matching already exists. Skipped.';
    END IF;
END $$;
