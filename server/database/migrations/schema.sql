-- Create the users table
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  biography TEXT,
  job TEXT,
  language TEXT,
  location TEXT,
  socials TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create index for email lookups
CREATE UNIQUE INDEX IF NOT EXISTS idx_users_email ON users (email);

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
  author_id INTEGER NOT NULL,
  blob_path TEXT,
  category TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  description TEXT,
  image_src TEXT,
  image_alt TEXT,
  language TEXT,
  links TEXT,
  metrics_comments INTEGER DEFAULT 0,
  metrics_likes INTEGER DEFAULT 0,
  metrics_views INTEGER DEFAULT 0,
  name TEXT NOT NULL,
  published_at DATETIME,
  slug TEXT NOT NULL,
  styles TEXT,
  tags TEXT,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  visibility TEXT DEFAULT 'private',
  
  FOREIGN KEY (author_id) REFERENCES users(id)
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
  author_id INTEGER NOT NULL,
  blob_path TEXT,
  category TEXT,
  company TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  description TEXT,
  image_src TEXT,
  image_alt TEXT,
  links TEXT,
  name TEXT NOT NULL,
  slug TEXT NOT NULL,
  technologies TEXT,
  visibility TEXT DEFAULT 'private',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (author_id) REFERENCES users(id)
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