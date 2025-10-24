-- Create the resumes table
CREATE TABLE IF NOT EXISTS resumes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  slug TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  subtitle TEXT,
  type TEXT DEFAULT 'general' CHECK (type IN ('general', 'technical', 'communication', 'creative')),
  language TEXT DEFAULT 'fr' CHECK (language IN ('en', 'fr')),
  template_name TEXT DEFAULT 'default',
  name TEXT NOT NULL,
  tagline TEXT,
  location TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  published BOOLEAN DEFAULT TRUE,
  profile TEXT CHECK (json_valid(profile)),
  skills TEXT CHECK (json_valid(skills)),
  experiences TEXT CHECK (json_valid(experiences)),
  education TEXT CHECK (json_valid(education)),
  projects TEXT CHECK (json_valid(projects)),
  interests TEXT CHECK (json_valid(interests)),
  contact TEXT CHECK (json_valid(contact)),
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create the cover_letters table
CREATE TABLE IF NOT EXISTS cover_letters (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  slug TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  company_name TEXT,
  position TEXT,
  language TEXT DEFAULT 'fr' CHECK (language IN ('en', 'fr')),
  template_name TEXT DEFAULT 'default',
  greeting TEXT,
  body TEXT NOT NULL,
  closing TEXT,
  signature TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  published BOOLEAN DEFAULT TRUE,
  resume_id INTEGER,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (resume_id) REFERENCES resumes(id) ON DELETE SET NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create indexes
CREATE UNIQUE INDEX IF NOT EXISTS idx_resumes_slug ON resumes(slug);
CREATE UNIQUE INDEX IF NOT EXISTS idx_cover_letters_slug ON cover_letters(slug);
CREATE INDEX IF NOT EXISTS idx_resumes_type ON resumes(type);
CREATE INDEX IF NOT EXISTS idx_resumes_published ON resumes(published);
CREATE INDEX IF NOT EXISTS idx_cover_letters_published ON cover_letters(published);
CREATE INDEX IF NOT EXISTS idx_cover_letters_resume_id ON cover_letters(resume_id);

-- Triggers to update the updated_at timestamp
CREATE TRIGGER IF NOT EXISTS update_resumes_timestamp
AFTER UPDATE ON resumes
FOR EACH ROW
BEGIN
  UPDATE resumes SET updated_at = CURRENT_TIMESTAMP WHERE id = OLD.id;
END;

CREATE TRIGGER IF NOT EXISTS update_cover_letters_timestamp
AFTER UPDATE ON cover_letters
FOR EACH ROW
BEGIN
  UPDATE cover_letters SET updated_at = CURRENT_TIMESTAMP WHERE id = OLD.id;
END;
