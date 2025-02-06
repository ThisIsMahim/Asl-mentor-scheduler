/*
  # Initial Schema for Mentoring System

  1. New Tables
    - profiles
      - Stores user profile information
      - Links to Supabase auth.users
    - courses
      - Stores course/discipline information
    - course_enrollments
      - Tracks student enrollments in courses
    - mentor_assignments
      - Tracks mentor assignments to courses
    - availability
      - Stores user availability slots
    - sessions
      - Stores scheduled mentoring sessions

  2. Security
    - Enable RLS on all tables
    - Add policies for appropriate access control
    - Ensure data isolation between users
*/

-- Create profiles table
CREATE TABLE profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id),
  email text NOT NULL,
  full_name text,
  role text NOT NULL CHECK (role IN ('member', 'mentor', 'admin')),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create courses table
CREATE TABLE courses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  created_by uuid REFERENCES profiles(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create course_enrollments table
CREATE TABLE course_enrollments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id uuid REFERENCES courses(id) ON DELETE CASCADE,
  user_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  UNIQUE(course_id, user_id)
);

-- Create mentor_assignments table
CREATE TABLE mentor_assignments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id uuid REFERENCES courses(id) ON DELETE CASCADE,
  mentor_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  UNIQUE(course_id, mentor_id)
);

-- Create availability table
CREATE TABLE availability (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  start_time timestamptz NOT NULL,
  end_time timestamptz NOT NULL,
  created_at timestamptz DEFAULT now(),
  CONSTRAINT valid_time_range CHECK (end_time > start_time)
);

-- Create sessions table
CREATE TABLE sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id uuid REFERENCES courses(id) ON DELETE CASCADE,
  mentor_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  member_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  start_time timestamptz NOT NULL,
  end_time timestamptz NOT NULL,
  status text NOT NULL CHECK (status IN ('scheduled', 'completed', 'cancelled')),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  CONSTRAINT valid_session_time CHECK (end_time > start_time)
);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE course_enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE mentor_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE availability ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;

-- Profiles Policies
CREATE POLICY "Public profiles are viewable by everyone"
  ON profiles FOR SELECT
  USING (true);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- Courses Policies
CREATE POLICY "Courses are viewable by everyone"
  ON courses FOR SELECT
  USING (true);

CREATE POLICY "Only admins can create courses"
  ON courses FOR INSERT
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role = 'admin'
    )
  );

-- Course Enrollments Policies
CREATE POLICY "Users can view their own enrollments"
  ON course_enrollments FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Members can enroll themselves"
  ON course_enrollments FOR INSERT
  USING (
    auth.uid() = user_id AND
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role = 'member'
    )
  );

-- Mentor Assignments Policies
CREATE POLICY "Mentor assignments are viewable by everyone"
  ON mentor_assignments FOR SELECT
  USING (true);

CREATE POLICY "Only admins can manage mentor assignments"
  ON mentor_assignments FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role = 'admin'
    )
  );

-- Availability Policies
CREATE POLICY "Users can manage their own availability"
  ON availability FOR ALL
  USING (auth.uid() = user_id);

CREATE POLICY "Mentors can view member availability"
  ON availability FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role = 'mentor'
    )
  );

-- Sessions Policies
CREATE POLICY "Users can view their own sessions"
  ON sessions FOR SELECT
  USING (
    auth.uid() = mentor_id OR
    auth.uid() = member_id
  );

CREATE POLICY "Mentors can create and update sessions"
  ON sessions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role = 'mentor'
    )
  );