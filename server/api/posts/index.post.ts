// POST /api/posts/create
import { createPostData } from '~/server/utils/post'
import { PostType } from '~/types/post'

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

  const articleBlob = createArticle()
  const blob_path = `posts/${postData.slug}/article.json`
  
  await blobStorage.put(blob_path, JSON.stringify(articleBlob))
  postData.blob_path = blob_path
  
  if (typeof postData.links   === 'object') { postData.links = JSON.stringify(postData.links) }
  if (typeof postData.styles  === 'object') { postData.styles = JSON.stringify(postData.styles) }
  if (typeof postData.tags    === 'object') { postData.tags = JSON.stringify(postData.tags) }

  const result = await db.prepare(`
    INSERT INTO posts (
      blob_path, description, image_src, image_alt,
      language, links, metrics_comments, metrics_likes, metrics_views,
      name, slug, styles, tags, user_id, visibility
    ) VALUES (
      ?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, ?12, ?13, ?14, ?15
    )
  `)
  .bind(
    postData.blob_path,
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
    postData.tags,
    postData.user_id,
    postData.visibility
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

  const newPost: PostType = {
    ...createdPost,
    links:  typeof createdPost.links   === 'string' ? JSON.parse(createdPost.links)   : createdPost.links,
    styles: typeof createdPost.styles  === 'string' ? JSON.parse(createdPost.styles)  : createdPost.styles,
    tags:   typeof createdPost.tags    === 'string' ? JSON.parse(createdPost.tags)    : createdPost.tags,
  }

  return newPost
})
