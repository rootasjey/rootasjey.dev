// GET /api/posts/:slug

import { PostType } from "~/types/post"
import { getPostByIdentifier } from '~/server/utils/post'

export default defineEventHandler(async (event) => {
  const identifier = decodeURIComponent(getRouterParam(event, 'identifier') ?? '')
  const db = hubDatabase()
  const blobStorage = hubBlob()

  if (!identifier) {
    throw createError({
      statusCode: 400,
      message: 'Post identifier is required',
    })
  }

  let userId = null
  try {
    const session = await getUserSession(event) // (optional - for private projects)
    if (session && session.user) { userId = session.user.id }
  } catch (error) { /* No session, continue as anonymous user */ }

  const post: PostType | null = await getPostByIdentifier(db, identifier)

  if (!post) {
    throw createError({
      statusCode: 404,
      message: `Post "${identifier}" not found`
    })
  }

  if (post.status !== "published" && post.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to view this post',
    })
  }

  // Fetch tags from join table
  const tagsResult = await db.prepare(`
    SELECT t.* FROM tags t
    JOIN post_tags pt ON pt.tag_id = t.id
    WHERE pt.post_id = ?
    ORDER BY pt.rowid ASC
  `).bind(post.id).all()

  post.tags = (tagsResult.results || []).map(t => ({
    id: Number(t.id),
    name: String(t.name),
    category: typeof t.category === 'string' ? t.category : '',
    created_at: t.created_at ? String(t.created_at) : '',
    updated_at: t.updated_at ? String(t.updated_at) : ''
  }))

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
    console.error(`Failed to update view count for post ${post.id}:`, error)
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
