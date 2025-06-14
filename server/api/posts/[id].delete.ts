// DELETE /api/posts/:id
// Delete a post from SQLite database and its associated blob file
export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const blobStorage = hubBlob()

  const idOrSlug = event.context.params?.id
  
  if (!idOrSlug) {
    throw createError({
      statusCode: 400,
      message: 'Post ID or slug is required.',
    })
  }

  const userId = session.user.id

  // First, check if the post exists and belongs to the user
  const postStmt = db.prepare(`
    SELECT * FROM posts WHERE id = ? OR slug = ? LIMIT 1
  `)
  
  const query = await postStmt.bind(idOrSlug, idOrSlug).all()

  if (!query.success) {
    throw createError({
      statusCode: 404,
      message: 'Post not found.',
    })
  }

  const post = query.results[0]

  if (post.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: "You are not authorized to delete this post",
    })
  }

  // Delete the blob file if it exists
  if (post.blob_path) {
    try {
      await blobStorage.delete(post.blob_path as string)
    } catch (error) {
      console.error(`Failed to delete blob file at ${post.blob_path}:`, error)
      // Continue with post deletion even if blob deletion fails
    }
  }

  // Delete the post from the database
  const deleteStmt = db.prepare(`
    DELETE FROM posts WHERE id = ?
  `)
  
  await deleteStmt.bind(post.id).run()

  return {
    message: "Post deleted successfully",
    id: post.id,
    slug: post.slug
  }
})
