// GET /api/posts/drafts
import { PostType } from "~/types/post"

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
  
  const drafts = rows.results.map(post => {
    if (typeof post.links   === 'string') { post.links  = JSON.parse(post.links || '[]') }
    if (typeof post.tags    === 'string') { post.tags   = JSON.parse(post.tags || '[]') }
    if (typeof post.styles  === 'string') { post.styles = JSON.parse(post.styles || '{}') }
    
    // Reconstruct image object
    post.image = {
      alt: post.image_alt || "",
      src: post.image_src || ""
    }
    
    // Remove redundant fields
    delete post.image_alt
    delete post.image_src
    return post
  })
  
  return drafts as PostType[]
})
