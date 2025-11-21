-- V11: Change game_sessions and game_session_details ID from BIGINT to UUID
-- This migration changes the primary key type of game_sessions and game_session_details tables from BIGINT to UUID

-- =====================================================
-- STEP 1: Drop ALL constraints and indexes first
-- =====================================================
-- Drop foreign key constraints (JPA generated name)
ALTER TABLE game_session_details DROP CONSTRAINT IF EXISTS fkcgnhrkxuaeiamytg1gtscunu9;
ALTER TABLE game_session_details DROP CONSTRAINT IF EXISTS fk_game_session_details_session;
ALTER TABLE game_session_details DROP CONSTRAINT IF EXISTS game_session_details_session_id_fkey;

-- Drop primary key constraints
ALTER TABLE game_session_details DROP CONSTRAINT IF EXISTS game_session_details_pkey;
ALTER TABLE game_sessions DROP CONSTRAINT IF EXISTS game_sessions_pkey;

-- Drop indexes
DROP INDEX IF EXISTS idx_gsd_session_id;

-- =====================================================
-- STEP 2: Add temporary UUID columns
-- =====================================================
ALTER TABLE game_sessions ADD COLUMN id_new UUID DEFAULT gen_random_uuid();
ALTER TABLE game_session_details ADD COLUMN id_new UUID DEFAULT gen_random_uuid();
ALTER TABLE game_session_details ADD COLUMN session_id_new UUID;

-- =====================================================
-- STEP 3: Backup old IDs for relationship mapping
-- =====================================================
ALTER TABLE game_sessions ADD COLUMN old_id_backup BIGINT;
UPDATE game_sessions SET old_id_backup = id;

-- =====================================================
-- STEP 4: Map relationships using old IDs
-- =====================================================
UPDATE game_session_details gsd
SET session_id_new = gs.id_new
FROM game_sessions gs
WHERE gsd.session_id = gs.old_id_backup;

-- =====================================================
-- STEP 5: Drop old columns (now safe - no constraints)
-- =====================================================
ALTER TABLE game_session_details DROP COLUMN id;
ALTER TABLE game_session_details DROP COLUMN session_id;
ALTER TABLE game_sessions DROP COLUMN id;

-- =====================================================
-- STEP 6: Rename new columns to original names
-- =====================================================
ALTER TABLE game_sessions RENAME COLUMN id_new TO id;
ALTER TABLE game_session_details RENAME COLUMN id_new TO id;
ALTER TABLE game_session_details RENAME COLUMN session_id_new TO session_id;

-- =====================================================
-- STEP 7: Add back constraints
-- =====================================================
-- Add primary keys
ALTER TABLE game_sessions ADD PRIMARY KEY (id);
ALTER TABLE game_session_details ADD PRIMARY KEY (id);

-- Make session_id NOT NULL
ALTER TABLE game_session_details ALTER COLUMN session_id SET NOT NULL;

-- Add foreign key
ALTER TABLE game_session_details 
ADD CONSTRAINT fk_game_session_details_session 
FOREIGN KEY (session_id) REFERENCES game_sessions(id) ON DELETE CASCADE;

-- =====================================================
-- STEP 8: Recreate indexes
-- =====================================================
CREATE INDEX idx_gsd_session_id ON game_session_details(session_id);

-- =====================================================
-- STEP 9: Clean up temporary columns
-- =====================================================
ALTER TABLE game_sessions DROP COLUMN old_id_backup;

-- =====================================================
-- Verification queries (commented out - for manual testing)
-- =====================================================
-- SELECT count(*) FROM game_sessions WHERE id IS NOT NULL;
-- SELECT count(*) FROM game_session_details WHERE id IS NOT NULL AND session_id IS NOT NULL;
-- SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'game_sessions' AND column_name = 'id';
-- SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'game_session_details' AND column_name IN ('id', 'session_id');
