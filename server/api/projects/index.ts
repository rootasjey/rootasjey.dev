// GET /api/projects

export default defineEventHandler(async (event) => {
  const db = hubDatabase()

  const stmt = db.prepare(`
    SELECT * FROM projects WHERE visibility = 'public'
  `)
  
  const query = await stmt.all()
  
  const projectByCategory: { [key: string]: any[] } = {}
  for (const project of query.results) {
    // Parse JSON fields if needed
    if (typeof project.links === 'string') {
      project.links = JSON.parse(project.links)
    }
    if (typeof project.technologies === 'string') {
      project.technologies = JSON.parse(project.technologies)
    }

    const category = project.category as string || 'Uncategorized'
    if (!projectByCategory[category]) {
      projectByCategory[category] = []
    }
    projectByCategory[category].push(project)
  }
  
  return projectByCategory
})
