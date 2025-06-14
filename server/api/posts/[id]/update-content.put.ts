// PUT /api/posts/[id]/update-content
export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const postIdOrSlug = event.context.params?.id
  const body = await readBody(event)

  if (!postIdOrSlug) {
    throw createError({
      statusCode: 400,
      message: 'Post ID or slug is required',
    })
  }

  if (!body.content) {
    throw createError({
      statusCode: 400,
      message: 'Post content is required',
    })
  }

  const userId = session.user.id

  // Find the post by ID or slug
  const postStmt = db.prepare(`
    SELECT * FROM posts WHERE id = ? OR slug = ? LIMIT 1
  `)
  
  const post = await postStmt.bind(postIdOrSlug, postIdOrSlug).first()

  if (!post) {
    throw createError({
      statusCode: 404,
      message: 'Post not found',
    })
  }

  // Check if the user is the author of the post
  if (post.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to update this post',
    })
  }

  try {
    // If there's an existing blob_path, update the existing blob
    const contentBlob = new Blob([JSON.stringify(body.content)], { 
      type: 'application/json' 
    })
    
    // Update the existing blob
    await hubBlob().put(post.blob_path as string, contentBlob)
    
    // Update the post's updated_at timestamp
    const updateTimestampStmt = db.prepare(`
      UPDATE posts 
      SET updated_at = CURRENT_TIMESTAMP
      WHERE id = ?
    `)
    
    await updateTimestampStmt.bind(post.id).run()

    // Get the updated post
    const updatedPostStmt = db.prepare(`
      SELECT * FROM posts WHERE id = ? LIMIT 1
    `)
    
    const updatedPost = await updatedPostStmt.bind(post.id).first()

    return {
      message: 'Post content updated successfully',
      post: updatedPost,
      success: true,
    }
  } catch (error) {
    console.error('Error updating post content:', error)
    throw createError({
      statusCode: 500,
      message: 'Failed to update post content',
    })
  }
})
