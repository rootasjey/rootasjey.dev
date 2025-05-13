// GET /api/projects

import { ProjectType } from "~/types/project"

export default defineEventHandler(async (event) => {
  const db = hubDatabase()

  const stmt = db.prepare(`
    SELECT * FROM projects WHERE visibility = 'public'
  `)

  const query = await stmt.all()

  for (const project of query.results) {
    // Parse JSON fields if needed
    if (typeof project.links === 'string') {
      project.links = JSON.parse(project.links)
    }
    if (typeof project.technologies === 'string') {
      project.technologies = JSON.parse(project.technologies)
    }
  }

  return query.results as ProjectType[]
})
