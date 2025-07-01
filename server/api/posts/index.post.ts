// POST /api/posts/create
import { convertApiToPost, createPostData } from '~/server/utils/post'
import type { ApiTag } from '~/types/tag'
import { ApiPost, Post } from '~/types/post'
import { upsertPostTags } from '~/server/utils/tags'
import { z } from 'zod'

const createPostSchema = z.object({
  name: z.string().min(1).max(255),
  description: z.string().max(1000).optional(),
  tags: z.array(z.object({
    name: z.string().min(1).max(50),
    category: z.string().max(50).optional()
  })).max(20).optional(),
})


export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const blobStorage = hubBlob()
  const body = await readValidatedBody(event, createPostSchema.parse)

  const userId = session.user.id
  const postData = createPostData(body, userId)

  // Insert post without blob_path first
  const result = await db.prepare(`
    INSERT INTO posts (
      description, image_src, image_alt,
      language, links, metrics_comments, metrics_likes, metrics_views,
      name, slug, user_id, status
    ) VALUES (
      ?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, ?12
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
    postData.user_id,
    postData.status
  ).run()

  const createdApiPost: ApiPost | null = await db
    .prepare(`SELECT * FROM posts WHERE id = ?1`)
    .bind(result.meta.last_row_id)
    .first()

  if (!createdApiPost) { 
    throw createError({ statusCode: 500, message: 'Failed to fetch created post.' }) 
  }

  // Now create the article blob using the post's ID
  const article = createArticle()
  const blob_path = `posts/${createdApiPost.id}/article.json`
  await blobStorage.put(blob_path, JSON.stringify(article))

  await db.prepare(`UPDATE posts SET blob_path = ? WHERE id = ?`)
    .bind(blob_path, createdApiPost.id)
    .run()

  createdApiPost.blob_path = blob_path

  // --- TAGS: Process tags after post insert ---
  let createdTags: ApiTag[] = []
  if (Array.isArray(body.tags)) {
    createdTags = await upsertPostTags(db, createdApiPost.id, body.tags)
  }

  const post = convertApiToPost(createdApiPost, {
    tags: createdTags,
    article: JSON.stringify(article),
    userName: session.user.name,
  })

  return post
})
