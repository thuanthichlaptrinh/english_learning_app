-- Add streak columns to users table
ALTER TABLE users
ADD COLUMN IF NOT EXISTS current_streak INT DEFAULT 0,
ADD COLUMN IF NOT EXISTS longest_streak INT DEFAULT 0,
ADD COLUMN IF NOT EXISTS last_activity_date DATE,
ADD COLUMN IF NOT EXISTS total_study_days INT DEFAULT 0;

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_user_current_streak ON users(current_streak);
CREATE INDEX IF NOT EXISTS idx_user_last_activity ON users(last_activity_date);

-- Update existing users to have default values
UPDATE users
SET current_streak = 0,
    longest_streak = 0,
    total_study_days = 0
WHERE current_streak IS NULL;

