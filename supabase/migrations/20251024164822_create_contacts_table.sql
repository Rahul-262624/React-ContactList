/*
  # Create contacts table

  1. New Tables
    - `contacts`
      - `id` (uuid, primary key) - Unique identifier for each contact
      - `name` (text, required) - Contact's full name
      - `email` (text, optional) - Contact's email address
      - `phone` (text, optional) - Contact's phone number
      - `created_at` (timestamptz) - Timestamp of when contact was created
      - `user_id` (uuid, required) - ID of user who owns this contact

  2. Security
    - Enable RLS on `contacts` table
    - Add policy for authenticated users to view their own contacts
    - Add policy for authenticated users to insert their own contacts
    - Add policy for authenticated users to update their own contacts
    - Add policy for authenticated users to delete their own contacts
*/

CREATE TABLE IF NOT EXISTS contacts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text DEFAULT '',
  phone text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE
);

ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own contacts"
  ON contacts FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own contacts"
  ON contacts FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own contacts"
  ON contacts FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own contacts"
  ON contacts FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS contacts_user_id_idx ON contacts(user_id);
CREATE INDEX IF NOT EXISTS contacts_name_idx ON contacts(name);