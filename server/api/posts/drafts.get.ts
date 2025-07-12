// GET /api/posts/drafts
import { convertApiToPost } from "~/server/utils/post"
import { ApiPost, Post } from "~/types/post"

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const query = getQuery(event)
  const search = query.search as string
  const db = hubDatabase()
  const userId = session.user.id

  let sql = `
    SELECT * FROM posts
    WHERE user_id = ? AND status = 'draft'
  `
  const params: any[] = [userId]

  if (search && search.trim()) {
    sql += ` AND (name LIKE ? OR description LIKE ?)`
    const searchPattern = `%${search.trim()}%`
    params.push(searchPattern, searchPattern)
  }

  sql += ` ORDER BY created_at DESC LIMIT 25`

  const rows = await db
    .prepare(sql)
    .bind(...params)
    .all()
  
  const drafts: Post[] = []
  for (const apiPost of rows.results as ApiPost[]) {
    const tagsResult = await db.prepare(`
      SELECT t.* FROM tags t
      JOIN post_tags pt ON pt.tag_id = t.id
      WHERE pt.post_id = ?
      ORDER BY pt.rowid ASC
    `).bind(apiPost.id).all()

    const draft = convertApiToPost(apiPost, {
      tags: tagsResult.results,
      userName: session.user.name,
    })

    drafts.push(draft)
  }

  return drafts
})
