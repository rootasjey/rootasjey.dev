// GET /api/posts

import { convertApiToPost } from "~/server/utils/post"
import { ApiPost, Post } from "~/types/post"

export default defineEventHandler(async (event) => {
  const db = hubDatabase()
  const postQuery = await db
  .prepare(`
    SELECT * FROM posts 
    WHERE status = 'published'
    ORDER BY created_at DESC
    LIMIT 25
  `)
  .all()
  
  const posts: Post[] = []
  for (const apiPost of postQuery.results as ApiPost[]) {
    const tagQuery = await db.prepare(`
      SELECT t.* FROM tags t
      JOIN post_tags pt ON pt.tag_id = t.id
      WHERE pt.post_id = ?
      ORDER BY pt.rowid ASC
    `).bind(apiPost.id).all()
    
    const post = convertApiToPost(apiPost, {
      tags: tagQuery.results,
    })

    posts.push(post)
  }
  
  return posts
})
