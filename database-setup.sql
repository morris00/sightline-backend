-- SightLine Database Setup
-- Run this in Supabase SQL Editor

-- 1. Create schools table
CREATE TABLE IF NOT EXISTS schools (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Create users table
CREATE TABLE IF NOT EXISTS users (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  school_id UUID REFERENCES schools(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('observer', 'admin', 'super_admin')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Create criteria table
CREATE TABLE IF NOT EXISTS criteria (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  school_id UUID REFERENCES schools(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  "order" INTEGER NOT NULL DEFAULT 0,
  rating_scale TEXT DEFAULT '4-point',
  weight INTEGER DEFAULT 1,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Create observations table
CREATE TABLE IF NOT EXISTS observations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  school_id UUID REFERENCES schools(id) ON DELETE CASCADE,
  observer_id UUID REFERENCES users(id) ON DELETE SET NULL,
  observer_name TEXT NOT NULL,
  teacher_name TEXT NOT NULL,
  department TEXT,
  grade_level TEXT,
  subject TEXT,
  observation_type TEXT NOT NULL,
  observation_date DATE NOT NULL,
  notes TEXT NOT NULL,
  analysis JSONB NOT NULL,
  tags TEXT[] DEFAULT ARRAY[]::TEXT[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. Create comments table
CREATE TABLE IF NOT EXISTS comments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  observation_id UUID REFERENCES observations(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  user_name TEXT NOT NULL,
  comment_text TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_observations_school ON observations(school_id);
CREATE INDEX IF NOT EXISTS idx_observations_observer ON observations(observer_id);
CREATE INDEX IF NOT EXISTS idx_observations_teacher ON observations(teacher_name);
CREATE INDEX IF NOT EXISTS idx_observations_department ON observations(department);
CREATE INDEX IF NOT EXISTS idx_observations_date ON observations(observation_date);
CREATE INDEX IF NOT EXISTS idx_comments_observation ON comments(observation_id);
CREATE INDEX IF NOT EXISTS idx_criteria_school ON criteria(school_id);

-- 7. Insert default school (YOUR SCHOOL)
INSERT INTO schools (name) 
VALUES ('Your School Name Here')
ON CONFLICT DO NOTHING
RETURNING id;

-- IMPORTANT: Save the school ID that's returned

-- 8. Insert default user (YOU)
-- Replace 'YOUR_SCHOOL_ID' with the ID from step 7
-- Replace email and name with your actual info
INSERT INTO users (email, name, school_id, role)
VALUES (
  'your.email@school.com',
  'Your Name',
  'YOUR_SCHOOL_ID',  -- Replace this
  'admin'
)
ON CONFLICT DO NOTHING
RETURNING id;

-- IMPORTANT: Save your user ID

-- 9. Insert default Danielson criteria
-- Replace 'YOUR_SCHOOL_ID' with your school ID from step 7
INSERT INTO criteria (school_id, name, description, "order") VALUES
  ('YOUR_SCHOOL_ID', 'Classroom Environment', 'Creating an environment of respect and rapport, establishing a culture for learning, managing classroom procedures and student behavior', 1),
  ('YOUR_SCHOOL_ID', 'Instruction', 'Communicating with students, using questioning and discussion techniques, engaging students in learning, using assessment in instruction', 2),
  ('YOUR_SCHOOL_ID', 'Planning and Preparation', 'Demonstrating knowledge of content and pedagogy, demonstrating knowledge of students, setting instructional outcomes, designing coherent instruction', 3),
  ('YOUR_SCHOOL_ID', 'Professional Responsibilities', 'Reflecting on teaching, maintaining accurate records, communicating with families, growing and developing professionally', 4)
ON CONFLICT DO NOTHING;

-- 10. Enable Row Level Security (RLS)
ALTER TABLE schools ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE observations ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE criteria ENABLE ROW LEVEL SECURITY;

-- 11. Create RLS Policies (allow all for now - will add auth later)
CREATE POLICY "Allow all operations on schools" ON schools FOR ALL USING (true);
CREATE POLICY "Allow all operations on users" ON users FOR ALL USING (true);
CREATE POLICY "Allow all operations on observations" ON observations FOR ALL USING (true);
CREATE POLICY "Allow all operations on comments" ON comments FOR ALL USING (true);
CREATE POLICY "Allow all operations on criteria" ON criteria FOR ALL USING (true);

-- Setup complete
-- Next steps:
-- 1. Save your school_id and user_id
-- 2. Test creating an observation through the API
