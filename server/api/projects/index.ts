// GET /api/projects
import { useSurrealDB } from '~/composables/useSurrealDB'

export default defineEventHandler(async (event) => {
  const { db, connect } = useSurrealDB()
  await connect()

  const [projects]: any[] = await db.query(`
    SELECT * FROM projects WHERE visibility = 'public'
  `)

  const projectByCategory: { [key: string]: any[] } = {}
  for await (const project of projects) {
    if (!projectByCategory[project.category]) {
      projectByCategory[project.category] = []
    }
    projectByCategory[project.category].push(project)
  }

  return projectByCategory
})