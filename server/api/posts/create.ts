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

  // Insert the post into the SQLite database
  const insertStmt = db.prepare(`
    INSERT INTO posts (
      author_id, blob_path, category, description, image_src, image_alt,
      language, links, metrics_comments, metrics_likes, metrics_views,
      name, slug, styles, tags, visibility
    ) VALUES (
      @author_id, @blob_path, @category, @description, @image_src, @image_alt,
      @language, @links, @metrics_comments, @metrics_likes, @metrics_views,
      @name, @slug, @styles, @tags, @visibility
    )
  `)

  const result = await insertStmt.bind({
    ...postData,
    blob_path,
  }).run()

  // Return the created post with its new ID
  return {
    id: result.meta.last_row_id,
    ...postData,
    // Parse JSON strings back to objects for the response
    links: JSON.parse(postData.links || '[]'),
    styles: JSON.parse(postData.styles || '{}'),
    tags: JSON.parse(postData.tags || '[]')
  }
})
