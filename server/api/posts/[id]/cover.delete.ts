// DELETE /api/posts/[id]/cover

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const postIdOrSlug = getRouterParam(event, 'id')

  if (!postIdOrSlug) {
    throw createError({
      statusCode: 400,
      message: 'Post ID or slug is required',
    })
  }

  const userId = session.user.id

  const post = await db
  .prepare(`SELECT * FROM posts WHERE id = ? OR slug = ? LIMIT 1`)
  .bind(postIdOrSlug, postIdOrSlug)
  .first()

  if (!post) {
    throw createError({
      statusCode: 404,
      message: 'Post not found',
    })
  }

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
    await db
    .prepare(`
      UPDATE posts 
      SET image_src = '', image_alt = '', updated_at = CURRENT_TIMESTAMP
      WHERE id = ?
    `)
    .bind(post.id)
    .run()

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
