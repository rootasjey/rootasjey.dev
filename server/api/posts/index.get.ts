// GET /api/posts

import { PostType } from "~/types/post"

export default defineEventHandler(async (event) => {
  const query = await hubDatabase()
  .prepare(`
    SELECT * FROM posts 
    WHERE visibility = 'public' OR visibility = 'project:public'
    ORDER BY created_at DESC
    LIMIT 25
  `)
  .all()
  
  for (const post of query.results) {
    if (typeof post.links   === 'string') { post.links  = JSON.parse(post.links) }
    if (typeof post.tags    === 'string') { post.tags   = JSON.parse(post.tags) }
    if (typeof post.styles  === 'string') { post.styles = JSON.parse(post.styles) }

    post.image = {
      alt: post.image_alt || "",
      ext: post.image_ext || "",
      src: post.image_src || "",
    }

    // Remove redundant fields
    delete post.image_alt
    delete post.image_ext
    delete post.image_src
  }
  
  return query.results as PostType[]
})
