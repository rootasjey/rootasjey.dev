// GET /api/posts

import { PostType } from "~/types/post"

export default defineEventHandler(async (event) => {
  const db = hubDatabase()
  
  const stmt = db.prepare(`
    SELECT * FROM posts 
    WHERE visibility = 'public' OR visibility = 'project:public'
    ORDER BY created_at DESC
    LIMIT 25
  `)
  
  const query = await stmt.all()
  
  for (const post of query.results) {
    // Parse JSON fields if needed
    if (typeof post.links === 'string') {
      post.links = JSON.parse(post.links)
    }
    if (typeof post.tags === 'string') {
      post.tags = JSON.parse(post.tags)
    }
    if (typeof post.styles === 'string') {
      post.styles = JSON.parse(post.styles)
    }

    // For list endpoints, we typically don't need to load the full content
    // This keeps the response size smaller and faster
    // post.hasContent = !!post.content
    // delete post.content
  }
  
  return query.results as PostType[]
})
