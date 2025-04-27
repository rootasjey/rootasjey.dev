// GET /api/home/how-many-items

export default defineEventHandler(async (event) => {
  const db = hubDatabase()

  // Count the number of public posts
  const posts = await db.prepare(`
    SELECT COUNT(*) AS count 
    FROM posts 
    WHERE visibility = 'public' OR visibility = 'project:public'
  `).first("count")

  // Count the number of public projects
  const projects = await db.prepare(`
    SELECT COUNT(*) AS count 
    FROM projects 
    WHERE visibility = 'public'
  `).first("count")

  return {
    posts,
    projects,
    experiments: 0,
  }
})