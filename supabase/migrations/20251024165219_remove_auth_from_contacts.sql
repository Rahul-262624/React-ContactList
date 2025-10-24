/*
  # Remove authentication requirement from contacts table

  1. Changes
    - Drop all existing RLS policies that require authentication
    - Make user_id column nullable and optional
    - Create new permissive policies that allow anyone to read, insert, update, and delete contacts
    - This makes the contacts table public and accessible without authentication

  2. Security
    - This migration removes all security restrictions
    - All contacts will be accessible to everyone
    - Use only for development or demo purposes
*/

DROP POLICY IF EXISTS "Users can view own contacts" ON contacts;
DROP POLICY IF EXISTS "Users can insert own contacts" ON contacts;
DROP POLICY IF EXISTS "Users can update own contacts" ON contacts;
DROP POLICY IF EXISTS "Users can delete own contacts" ON contacts;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'contacts' AND column_name = 'user_id' AND is_nullable = 'NO'
  ) THEN
    ALTER TABLE contacts ALTER COLUMN user_id DROP NOT NULL;
  END IF;
END $$;

CREATE POLICY "Anyone can view contacts"
  ON contacts FOR SELECT
  USING (true);

CREATE POLICY "Anyone can insert contacts"
  ON contacts FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Anyone can update contacts"
  ON contacts FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Anyone can delete contacts"
  ON contacts FOR DELETE
  USING (true);