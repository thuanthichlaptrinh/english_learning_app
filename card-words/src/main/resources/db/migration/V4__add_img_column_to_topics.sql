-- Migration: Add img column to topics table
-- Purpose: Store Firebase Storage URL for topic images
-- Author: Generated
-- Date: 2025-11-13

ALTER TABLE topics ADD COLUMN img VARCHAR(500);

COMMENT ON COLUMN topics.img IS 'Firebase Storage URL for topic image';
