// GET /api/posts/:id

export default defineEventHandler(async (event) => {
  const idOrSlug = event.context.params?.id
  const db = hubDatabase()
  const blobStorage = hubBlob()

  if (!idOrSlug) {
    throw createError({
      statusCode: 400,
      message: 'Post ID or slug is required',
    })
  }

  // Check if we have a session (optional - for private projects)
  let userId = null
  try {
    const session = await getUserSession(event)
    if (session && session.user) {
      userId = session.user.id
    }
  } catch (error) {
    // No session, continue as anonymous user
  }

  // Fetch the post from SQLite
  // const stmt = db.prepare(`
  //   SELECT * FROM posts 
  //   WHERE slug = ?1 AND (visibility = 'public' OR visibility = 'project:public')
  // `)
  const stmt = db.prepare(`
    SELECT * FROM posts 
    WHERE id = ? OR slug = ?
    LIMIT 1
  `)
  
  const post = await stmt.bind(idOrSlug, idOrSlug).first()

  if (!post) {
    throw createError({
      statusCode: 404,
      message: `Post "${idOrSlug}" not found`
    })
  }

  // Check visibility permissions
  if (post.visibility !== "public" && post.author_id !== userId) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to view this post',
    })
  }

  // Parse JSON fields
  if (typeof post.links === 'string') {
    post.links = JSON.parse(post.links)
  }
  if (typeof post.tags === 'string') {
    post.tags = JSON.parse(post.tags)
  }
  if (typeof post.styles === 'string') {
    post.styles = JSON.parse(post.styles)
  }

  // Fetch content from blob storage if available
  const contentBlob = await blobStorage.get(post.blob_path as string)
  if (contentBlob) {
    const contentText = await contentBlob.text()
    post.content = JSON.parse(contentText)
  }

  try { // Update view count
    const updateStmt = db.prepare(`
      UPDATE posts 
      SET metrics_views = metrics_views + 1 
      WHERE id = ?1
    `)
    await updateStmt.bind(post.id).run()
  } catch (error) {
    console.error(`Failed to update view count for post ${idOrSlug}:`, error)
  }

  return post
})
