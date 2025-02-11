// GET /api/posts
import { useSurrealDB } from '~/composables/useSurrealDB'

export default defineEventHandler(async (event) => {
  const { db, connect } = useSurrealDB()
  await connect()

  const [posts]: any[] = await db.query(`
    SELECT * FROM posts WHERE visibility = 'public' OR visibility = 'project:public'
    ORDER BY created_at DESC
    LIMIT 25
  `)

  return posts
})