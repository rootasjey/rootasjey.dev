// GET /api/posts

import { PostType } from "~/types/post"

export default defineEventHandler(async (event) => {
  const query = await hubDatabase()
  .prepare(`
    SELECT * FROM posts 
    WHERE status = 'published'
    ORDER BY created_at DESC
    LIMIT 25
  `)
  .all()
  
  for (const post of query.results) {
    if (typeof post.links   === 'string') { post.links  = JSON.parse(post.links) }
    if (typeof post.styles  === 'string') { post.styles = JSON.parse(post.styles) }

    // Fetch tags from join table
    const db = hubDatabase()
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

    post.image = {
      alt: post.image_alt || "",
      ext: post.image_ext || "",
      src: post.image_src || "",
    }

    post.metrics = {
      comments: post.metrics_comments || 0,
      likes: post.metrics_likes || 0,
      views: post.metrics_views || 0,
    }

    // Remove redundant fields
    delete post.image_alt
    delete post.image_ext
    delete post.image_src

    delete post.metrics_comments
    delete post.metrics_likes
    delete post.metrics_views
  }
  
  return query.results as PostType[]
})
