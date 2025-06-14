// PUT /api/posts/[id]/update-styles
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

  if (!body.styles) {
    throw createError({
      statusCode: 400,
      message: 'Post styles is required',
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

  // Convert styles object to JSON string for storage
  const stylesJson = JSON.stringify(body.styles)

  // Update the post styles
  const updateStmt = db.prepare(`
    UPDATE posts 
    SET styles = ?, updated_at = CURRENT_TIMESTAMP
    WHERE id = ?
  `)
  
  await updateStmt.bind(stylesJson, post.id).run()

  // Get the updated post
  const updatedPostStmt = db.prepare(`
    SELECT * FROM posts WHERE id = ? LIMIT 1
  `)
  
  const updatedPost = await updatedPostStmt.bind(post.id).first()
  if (!updatedPost) {
    throw createError({
      statusCode: 500,
      message: 'Failed to update post',
    })
  }

  // Format the response
  const formattedPost = {
    ...updatedPost,
    // Parse JSON fields if they exist
    links: typeof updatedPost.links === 'string' ? JSON.parse(updatedPost.links || '[]') : updatedPost.links,
    tags: typeof updatedPost.tags === 'string' ? JSON.parse(updatedPost.tags || '[]') : updatedPost.tags,
    styles: typeof updatedPost.styles === 'string' ? JSON.parse(updatedPost.styles || '{}') : updatedPost.styles,
    // Reconstruct image object
    image: {
      alt: updatedPost.image_alt || "",
      src: updatedPost.image_src || ""
    }
  }

  // Remove redundant fields
  // delete formattedPost.image_alt
  // delete formattedPost.image_src

  return {
    message: 'Post updated successfully',
    post: formattedPost,
    success: true,
  }
})
