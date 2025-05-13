// POST /api/posts/create
import { createPostData } from '~/server/utils/server.post'

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

  // Post content blob
  const postContentBlob = createPostFileContent()
  const blob_path = `posts/${postData.slug}/content.json`
  
  // Store the content in blob storage
  await blobStorage.put(blob_path, JSON.stringify(postContentBlob))
  postData.blob_path = blob_path
  
  // Ensure all object fields are stringified
  if (typeof postData.links === 'object') {
    postData.links = JSON.stringify(postData.links)
  }
  if (typeof postData.styles === 'object') {
    postData.styles = JSON.stringify(postData.styles)
  }
  if (typeof postData.tags === 'object') {
    postData.tags = JSON.stringify(postData.tags)
  }

  const insertStmt = db.prepare(`
    INSERT INTO posts (
      author_id, blob_path, category, description, image_src, image_alt,
      language, links, metrics_comments, metrics_likes, metrics_views,
      name, slug, styles, tags, visibility
    ) VALUES (
      ?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, ?12, ?13, ?14, ?15, ?16
    )
  `)

  const result = await insertStmt.bind(
    postData.author_id,
    postData.blob_path,
    postData.category,
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
    postData.visibility
  ).run()

  return {
    id: result.meta.last_row_id,
    ...postData,
    // Parse JSON strings back to objects for the response
    links: typeof postData.links === 'string' ? JSON.parse(postData.links) : postData.links,
    styles: typeof postData.styles === 'string' ? JSON.parse(postData.styles) : postData.styles,
    tags: typeof postData.tags === 'string' ? JSON.parse(postData.tags) : postData.tags
  }
})
