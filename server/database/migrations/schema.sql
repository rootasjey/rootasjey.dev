-- Create the users table
CREATE TABLE IF NOT EXISTS users (
  avatar TEXT DEFAULT "",
  biography TEXT DEFAULT "",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  email TEXT NOT NULL UNIQUE COLLATE NOCASE,
  email_verified BOOLEAN DEFAULT FALSE,
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  job TEXT DEFAULT "",
  language TEXT DEFAULT "en" CHECK (language IN ('en', 'fr', 'es', 'de', 'it')),
  last_login_at DATETIME,
  location TEXT DEFAULT "",
  name TEXT NOT NULL UNIQUE COLLATE NOCASE,
  password TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'user' CHECK (role IN ('user', 'admin', 'moderator')),
  socials TEXT DEFAULT "[]" CHECK (json_valid(socials)),
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create index for email lookups
CREATE UNIQUE INDEX IF NOT EXISTS idx_users_email ON users (email);
CREATE UNIQUE INDEX IF NOT EXISTS idx_users_name ON users (name);

-- Trigger to update the updated_at timestamp whenever a row is modified
CREATE TRIGGER IF NOT EXISTS update_users_timestamp
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
  UPDATE users SET updated_at = CURRENT_TIMESTAMP WHERE id = OLD.id;
END;

-- Create the posts table
CREATE TABLE IF NOT EXISTS posts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  blob_path TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  description TEXT,
  image_alt TEXT,
  image_ext TEXT,
  image_src TEXT,
  language TEXT DEFAULT "en" CHECK (language IN ('en', 'fr', 'es', 'de', 'it')),
  links TEXT DEFAULT "{}" CHECK (json_valid(links)),
  metrics_comments INTEGER DEFAULT 0 CHECK (metrics_comments >= 0),
  metrics_likes INTEGER DEFAULT 0 CHECK (metrics_likes >= 0),
  metrics_views INTEGER DEFAULT 0 CHECK (metrics_views >= 0),
  name TEXT NOT NULL,
  published_at DATETIME,
  slug TEXT NOT NULL UNIQUE,
  status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
  styles TEXT DEFAULT "{}" CHECK (json_valid(styles)),
  tags TEXT DEFAULT "[]" CHECK (json_valid(tags)),
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  user_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create unique index for posts table
CREATE UNIQUE INDEX IF NOT EXISTS idx_posts_unique_slug ON posts (slug);

-- Trigger to update the updated_at timestamp whenever a post is modified
CREATE TRIGGER IF NOT EXISTS update_posts_timestamp
AFTER UPDATE ON posts
FOR EACH ROW
BEGIN
  UPDATE posts SET updated_at = CURRENT_TIMESTAMP WHERE id = OLD.id;
END;

-- Create the projects table
CREATE TABLE IF NOT EXISTS projects (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  blob_path TEXT,
  company TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  description TEXT,
  end_date DATETIME,
  image_alt TEXT,
  image_ext TEXT,
  image_src TEXT,
  links TEXT DEFAULT "{}" CHECK (json_valid(links)),
  metrics_comments INTEGER DEFAULT 0 CHECK (metrics_comments >= 0),
  metrics_likes INTEGER DEFAULT 0 CHECK (metrics_likes >= 0),
  metrics_views INTEGER DEFAULT 0 CHECK (metrics_views >= 0),
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  tags TEXT DEFAULT "[]" CHECK (json_valid(tags)),
  start_date DATETIME,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'archived', 'on-hold')),
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  user_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CHECK (end_date IS NULL OR start_date IS NULL OR end_date >= start_date)
);

-- Create unique index for projects table
CREATE UNIQUE INDEX IF NOT EXISTS idx_projects_unique_slug ON projects (slug);

-- Trigger to update the updated_at timestamp whenever a project is modified
CREATE TRIGGER IF NOT EXISTS update_projects_timestamp
AFTER UPDATE ON projects
FOR EACH ROW
BEGIN
  UPDATE projects SET updated_at = CURRENT_TIMESTAMP WHERE id = OLD.id;
END;

-- Create the messages table
CREATE TABLE IF NOT EXISTS messages (
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ip_address TEXT,
  message TEXT NOT NULL,
  priority TEXT DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
  read BOOLEAN DEFAULT FALSE,
  sender_email TEXT NOT NULL,
  spam BOOLEAN DEFAULT FALSE,
  subject TEXT NOT NULL,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create index for faster filtering by read status
CREATE INDEX IF NOT EXISTS idx_messages_read ON messages(read);

-- Create composite index for common queries (read status + created_at for sorting)
CREATE INDEX IF NOT EXISTS idx_messages_read_created_at ON messages(read, created_at DESC);

-- Trigger to update the updated_at timestamp whenever a message is modified
CREATE TRIGGER IF NOT EXISTS update_messages_timestamp
AFTER UPDATE ON messages
FOR EACH ROW
BEGIN
  UPDATE messages SET updated_at = CURRENT_TIMESTAMP WHERE id = OLD.id;
END;