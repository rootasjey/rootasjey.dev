// DELETE /api/posts/[id]/remove-image
export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const postIdOrSlug = event.context.params?.id

  if (!postIdOrSlug) {
    throw createError({
      statusCode: 400,
      message: 'Post ID or slug is required',
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

  if (!post.image_src) {
    throw createError({
      statusCode: 400,
      message: 'Post does not have an image',
    })
  }

  try {
    await hubBlob().delete(post.image_src as string)
    const updateStmt = db.prepare(`
      UPDATE posts 
      SET image_src = '', image_alt = '', updated_at = CURRENT_TIMESTAMP
      WHERE id = ?
    `)

    await updateStmt.bind(post.id).run()

    return { 
      success: true,
      message: 'Image removed successfully',
      post,
    }
  } catch (error) {
    console.log(error)
    return {
      error,
      success: false,
      message: 'Failed to remove image',
      post,
    }
  }
})
