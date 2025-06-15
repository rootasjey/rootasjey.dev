-- Create the users table
CREATE TABLE IF NOT EXISTS users (
  biography TEXT DEFAULT "",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  email TEXT NOT NULL UNIQUE,
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  job TEXT DEFAULT "",
  language TEXT DEFAULT "en",
  location TEXT DEFAULT "",
  name TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'user',
  socials TEXT DEFAULT "[]",
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
  category TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  description TEXT,
  image_alt TEXT,
  image_ext TEXT,
  image_src TEXT,
  language TEXT,
  links TEXT,
  metrics_comments INTEGER DEFAULT 0,
  metrics_likes INTEGER DEFAULT 0,
  metrics_views INTEGER DEFAULT 0,
  name TEXT NOT NULL,
  published_at DATETIME,
  slug TEXT NOT NULL UNIQUE,
  styles TEXT,
  tags TEXT,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  user_id INTEGER NOT NULL,
  visibility TEXT DEFAULT 'private',
  
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Create unique index for slug
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
  category TEXT,
  company TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  description TEXT,
  image_alt TEXT,
  image_ext TEXT,
  image_src TEXT,
  links TEXT,
  metrics_comments INTEGER DEFAULT 0,
  metrics_likes INTEGER DEFAULT 0,
  metrics_views INTEGER DEFAULT 0,
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  technologies TEXT,
  visibility TEXT DEFAULT 'private',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  user_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Create unique index for slug
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
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  message TEXT NOT NULL,
  subject TEXT NOT NULL,
  sender_email TEXT NOT NULL,
  read BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
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