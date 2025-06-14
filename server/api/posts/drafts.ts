import { PostType } from "~/types/post"

// GET /api/posts/drafts
export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  
  // Get the user ID from the session
  const userId = session.user.id
  
  // Query to get drafts (private posts) for the authenticated user
  const stmt = db.prepare(`
    SELECT * FROM posts 
    WHERE user_id = ? AND (visibility = 'private' OR visibility = 'project:private')
    ORDER BY created_at DESC
    LIMIT 25
  `)
  
  const posts = await stmt.bind(userId).all()
  
  // Process the posts to parse JSON fields and format the response
  const formattedPosts = posts.results.map(post => {
    // Parse JSON fields
    if (typeof post.links === 'string') {
      post.links = JSON.parse(post.links || '[]')
    }
    
    if (typeof post.tags === 'string') {
      post.tags = JSON.parse(post.tags || '[]')
    }
    
    if (typeof post.styles === 'string') {
      post.styles = JSON.parse(post.styles || '{}')
    }
    
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
  
  return formattedPosts as PostType[]
})
