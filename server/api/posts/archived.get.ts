// GET /api/posts/archived

import { convertApiToPost } from "~/server/utils/post"
import { ApiPost, Post } from "~/types/post"

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const userId = session.user.id
  
  const rows = await db.prepare(`
    SELECT * FROM posts 
    WHERE user_id = ? AND status = 'archived'
    ORDER BY created_at DESC
    LIMIT 25
  `)
  .bind(userId)
  .all()
  
  const archivedPosts: Post[] = []
  for (const apiPost of rows.results as ApiPost[]) {
    const tagsResult = await db.prepare(`
      SELECT t.* FROM tags t
      JOIN post_tags pt ON pt.tag_id = t.id
      WHERE pt.post_id = ?
      ORDER BY pt.rowid ASC
    `).bind(apiPost.id).all()

    const archivedPost = convertApiToPost(apiPost, {
      tags: tagsResult.results,
      userName: session.user.name,
    })

    archivedPosts.push(archivedPost)
  }

  return archivedPosts
})
