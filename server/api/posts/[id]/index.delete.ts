// DELETE /api/posts/:id

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const blobStorage = hubBlob()

  const idOrSlug = getRouterParam(event, 'id')
  if (!idOrSlug) {
    throw createError({
      statusCode: 400,
      message: 'Post ID or slug is required.',
    })
  }

  const userId = session.user.id

  const post = await db
  .prepare(`SELECT * FROM posts WHERE id = ? OR slug = ? LIMIT 1`)
  .bind(idOrSlug, idOrSlug)
  .first()

  if (!post) {
    throw createError({
      statusCode: 404,
      message: 'Post not found.',
    })
  }

  if (post.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: "You are not authorized to delete this post",
    })
  }

  if (post.blob_path) {
    try {
      await blobStorage.delete(post.blob_path as string)
    } catch (error) {
      console.error(`Failed to delete blob file at ${post.blob_path}:`, error)
      // Continue with post deletion even if blob deletion fails
    }
  }

  await db
  .prepare(`DELETE FROM posts WHERE id = ?`)
  .bind(post.id)
  .run()

  return {
    message: "Post deleted successfully",
    id: post.id,
    slug: post.slug
  }
})
