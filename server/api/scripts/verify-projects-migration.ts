// /server/api/scripts/verify-projects-migration.ts
import { useSurrealDB } from '~/composables/useSurrealDB'

export default defineEventHandler(async (event) => {
  // Connect to SurrealDB
  const { db: surrealDb, connect } = useSurrealDB()
  await connect()

  // Get NuxtHub SQLite database
  const sqliteDb = hubDatabase()

  // Fetch all projects from SurrealDB
  const [surrealProjects]: any[] = await surrealDb.query(`
    SELECT * FROM projects WHERE visibility = 'public'
  `)

  // Fetch all projects from SQLite
  const sqliteStmt = sqliteDb.prepare(`
    SELECT * FROM projects WHERE visibility = 'public'
  `)
  const sqliteProjects = await sqliteStmt.all()

  return {
    surrealCount: surrealProjects.length,
    sqliteCount: sqliteProjects.results.length,
    isComplete: surrealProjects.length === sqliteProjects.results.length,
    surrealCategories: [...new Set(surrealProjects.map((p: any) => p.category))],
    sqliteCategories: [...new Set(sqliteProjects.results.map(p => p.category))]
  }
})
