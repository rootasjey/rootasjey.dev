// GET /api/posts/:id

import { PostType } from "~/types/post"

export default defineEventHandler(async (event) => {
  const idOrSlug = decodeURIComponent(getRouterParam(event, 'id') ?? '')
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

   const post: PostType | null = await db
  .prepare(`
    SELECT 
      p.*,
      u.avatar as user_avatar,
      u.name as user_name
    FROM posts p
    JOIN users u ON p.user_id = u.id
    WHERE p.id = ? OR p.slug = ? 
    LIMIT 1
  `)
  .bind(idOrSlug, idOrSlug)
  .first()

  console.log(`[0 • API] Fetching post with ID or slug: ${idOrSlug}`, post)
  console.log(`[1 • API] decoded slug: ${decodeURIComponent(idOrSlug)}`)

  if (!post) {
    throw createError({
      statusCode: 404,
      message: `Post "${idOrSlug}" not found`
    })
  }

  if (post.status !== "published" && post.user_id !== userId) {
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

  post.metrics = {
    comments: post.metrics_comments || 0,
    likes: post.metrics_likes || 0,
    views: post.metrics_views || 0,
  }

  post.user = {
    name: post.user_name || "",
    avatar: post.user_avatar || ""
  }

  // Remove redundant fields
  delete post.image_alt
  delete post.image_ext
  delete post.image_src

  delete post.metrics_comments
  delete post.metrics_likes
  delete post.metrics_views

  delete post.user_name
  delete post.user_avatar

  return post
})
