// GET /api/posts/:id

export default defineEventHandler(async (event) => {
  const idOrSlug = getRouterParam(event, 'id')
  const db = hubDatabase()
  const blobStorage = hubBlob()

  if (!idOrSlug) {
    throw createError({
      statusCode: 400,
      message: 'Post ID or slug is required',
    })
  }

  let userId = null
  try {
    const session = await getUserSession(event) // (optional - for private projects)
    if (session && session.user) { userId = session.user.id }
  } catch (error) { /* No session, continue as anonymous user */}

  const post = await db
  .prepare(`SELECT * FROM posts WHERE id = ? OR slug = ? LIMIT 1`)
  .bind(idOrSlug, idOrSlug)
  .first()

  if (!post) {
    throw createError({
      statusCode: 404,
      message: `Post "${idOrSlug}" not found`
    })
  }

  if (post.visibility !== "public" && post.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to view this post',
    })
  }

  if (typeof post.links   === 'string') { post.links = JSON.parse(post.links) }
  if (typeof post.styles  === 'string') { post.styles = JSON.parse(post.styles) }
  if (typeof post.tags    === 'string') { post.tags = JSON.parse(post.tags) }

  const articleBlob = await blobStorage.get(post.blob_path as string)
  if (articleBlob) {
    const textArticle = await articleBlob.text()
    post.article = JSON.parse(textArticle)
  }

  try {
    await db
    .prepare(`UPDATE posts SET metrics_views = metrics_views + 1 WHERE id = ?1`)
    .bind(post.id)
    .run()
  } catch (error) {
    console.error(`Failed to update view count for post ${idOrSlug}:`, error)
  }

  post.image = {
    alt: post.image_alt || "",
    ext: post.image_ext || "",
    src: post.image_src || ""
  }

  // Remove redundant fields
  delete post.image_alt
  delete post.image_ext
  delete post.image_src

  return post
})
