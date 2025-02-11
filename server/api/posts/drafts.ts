// GET /api/posts/drafts
import { useSurrealDB } from '~/composables/useSurrealDB'

export default defineEventHandler(async (event) => {
  const { db, connect } = useSurrealDB()
  const rawToken = getHeader(event, "Authorization")
  if (!rawToken) {
    throw createError({
      statusCode: 401,
      message: "Unauthorized",
    })
  }

  const token = rawToken.replace('Bearer ', '').replace('token=', '')
  await connect()
  await db.authenticate(token)

  const [posts]: any[] = await db.query(`
    SELECT * FROM posts WHERE visibility = 'private' OR visibility = 'project:private'
    ORDER BY created_at DESC
    LIMIT 25
  `)

  return posts
})
