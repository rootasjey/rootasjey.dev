// GET /api/posts/drafts
import { convertApiToPost } from "~/server/utils/post"
import { ApiPost, Post } from "~/types/post"

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const userId = session.user.id
  
  const rows = await db.prepare(`
    SELECT * FROM posts 
    WHERE user_id = ? AND (status = 'draft')
    ORDER BY created_at DESC
    LIMIT 25
  `)
  .bind(userId)
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
