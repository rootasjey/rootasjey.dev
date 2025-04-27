import { useSurrealDB } from '~/composables/useSurrealDB'

export default defineEventHandler(async (event) => {
  // Connect to SurrealDB
  const { db: surrealDb, connect } = useSurrealDB()
  await connect()

  // Get NuxtHub SQLite database
  const sqliteDb = hubDatabase()

  // Fetch all posts from SurrealDB
  const [surrealPosts]: any[] = await surrealDb.query(`
    SELECT * FROM posts WHERE visibility = 'public' OR visibility = 'project:public'
  `)

  // Fetch all posts from SQLite
  const sqliteStmt = sqliteDb.prepare(`
    SELECT * FROM posts WHERE visibility = 'public' OR visibility = 'project:public'
  `)
  const sqlitePosts = await sqliteStmt.all()

  // Compare some key metrics
  const surrealSlugs = surrealPosts.map((p: any) => p.slug).sort();
  const sqliteSlugs = sqlitePosts.results.map(p => p.slug).sort();
  
  // Check if all slugs match (as a basic integrity check)
  const allSlugsMatch = JSON.stringify(surrealSlugs) === JSON.stringify(sqliteSlugs);

  return {
    surrealCount: surrealPosts.length,
    sqliteCount: sqlitePosts.results.length,
    isComplete: surrealPosts.length === sqlitePosts.results.length && allSlugsMatch,
    sampleSurrealSlugs: surrealSlugs.slice(0, 5),
    sampleSqliteSlugs: sqliteSlugs.slice(0, 5)
  }
})
