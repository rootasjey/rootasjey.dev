// GET /api/posts/:slug

import { ApiPost } from "~/types/post"
import { convertApiToPost, getPostByIdentifier } from '~/server/utils/post'

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

  const apiPost: ApiPost | null = await getPostByIdentifier(db, identifier)

  if (!apiPost) {
    throw createError({
      statusCode: 404,
      message: `Post "${identifier}" not found`
    })
  }

  if (apiPost.status !== "published" && apiPost.user_id !== userId) {
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
  `).bind(apiPost.id).all()

  const articleBlob = await blobStorage.get(apiPost.blob_path as string)
  const article = await articleBlob?.text() ?? ''
  const post = convertApiToPost(apiPost, {
    tags: tagsResult.results,
    article,
  })

  try {
    await db
      .prepare(`UPDATE posts SET metrics_views = metrics_views + 1 WHERE id = ?1`)
      .bind(apiPost.id)
      .run()
  } catch (error) {
    console.error(`Failed to update view count for post ${apiPost.id}:`, error)
  }

  return post
})
