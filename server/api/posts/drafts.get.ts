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
  
  const drafts = []
  for (const post of rows.results) {
    if (typeof post.links   === 'string') { post.links  = JSON.parse(post.links || '[]') }
    if (typeof post.styles  === 'string') { post.styles = JSON.parse(post.styles || '{}') }

    // Fetch tags from join table
    const tagsResult = await db.prepare(`
      SELECT t.* FROM tags t
      JOIN post_tags pt ON pt.tag_id = t.id
      WHERE pt.post_id = ?
      ORDER BY pt.rowid ASC
    `).bind(post.id).all()
    post.tags = (tagsResult.results || []).map(t => ({
      id: Number(t.id),
      name: String(t.name),
      category: typeof t.category === 'string' ? t.category : '',
      created_at: t.created_at ? String(t.created_at) : '',
      updated_at: t.updated_at ? String(t.updated_at) : ''
    }))

    // Reconstruct image object
    post.image = {
      alt: post.image_alt || "",
      src: post.image_src || ""
    }

    // Remove redundant fields
    delete post.image_alt
    delete post.image_src
    drafts.push(post)
  }

  return drafts as PostType[]
})
