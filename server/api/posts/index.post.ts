// POST /api/posts/create
import { createPostData } from '~/server/utils/post'
import type { ApiTag } from '~/types/tag'
import { PostType } from '~/types/post'
import { upsertPostTags } from '~/server/utils/tags'

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const blobStorage = hubBlob()
  const body = await readBody(event)

  if (!body.name) {
    throw createError({
      statusCode: 400,
      message: "Post name is required",
    })
  }

  const userId = session.user.id
  const postData = createPostData(body, userId)

  // Remove blob_path from postData for initial insert
  postData.blob_path = ''

  if (typeof postData.links   === 'object') { postData.links = JSON.stringify(postData.links) }
  if (typeof postData.styles  === 'object') { postData.styles = JSON.stringify(postData.styles) }

  // Insert post without blob_path first
  const result = await db.prepare(`
    INSERT INTO posts (
      description, image_src, image_alt,
      language, links, metrics_comments, metrics_likes, metrics_views,
      name, slug, styles, user_id, status
    ) VALUES (
      ?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, ?12, ?13
    )
  `)
  .bind(
    postData.description,
    postData.image_src,
    postData.image_alt,
    postData.language,
    postData.links,
    postData.metrics_comments,
    postData.metrics_likes,
    postData.metrics_views,
    postData.name,
    postData.slug,
    postData.styles,
    postData.user_id,
    postData.status
  ).run()

  const createdPost: PostType | null = await db
    .prepare(`SELECT * FROM posts WHERE id = ?1`)
    .bind(result.meta.last_row_id)
    .first()

  if (!createdPost) {
    throw createError({
      statusCode: 500,
      message: 'Failed to fetch created post.',
    })
  }

  // Now create the article blob using the post's ID
  const articleBlob = createArticle()
  const blob_path = `posts/${createdPost.id}/article.json`
  await blobStorage.put(blob_path, JSON.stringify(articleBlob))

  // Update the post with the blob_path
  await db.prepare(`UPDATE posts SET blob_path = ? WHERE id = ?`)
    .bind(blob_path, createdPost.id)
    .run()

  // --- TAGS: Process tags after post insert ---
  let createdTags: ApiTag[] = []
  if (Array.isArray(body.tags)) {
    createdTags = await upsertPostTags(db, createdPost.id, body.tags)
  }

  const newPost: PostType = {
    ...createdPost,
    blob_path,
    links:  typeof createdPost.links   === 'string' ? JSON.parse(createdPost.links)   : createdPost.links,
    styles: typeof createdPost.styles  === 'string' ? JSON.parse(createdPost.styles)  : createdPost.styles,
    tags:   createdTags,
  }

  return newPost
})
