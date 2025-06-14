// PUT /api/posts/[id]/update-meta
export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const postIdOrSlug = event.context.params?.id
  const body = await readBody(event)

  if (!postIdOrSlug) {
    throw createError({
      statusCode: 400,
      message: 'Post ID or slug is required',
    })
  }

  if (!body.name) {
    throw createError({
      statusCode: 400,
      message: 'Post name is required',
    })
  }

  const userId = session.user.id

  const postStmt = db.prepare(`
    SELECT * FROM posts WHERE id = ? OR slug = ? LIMIT 1
  `)

  const post = await postStmt.bind(postIdOrSlug, postIdOrSlug).first()

  if (!post) {
    throw createError({
      statusCode: 404,
      message: 'Post not found',
    })
  }

  // Check if the user is the author of the post
  if (post.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to update this post',
    })
  }

  // Generate slug if not provided
  const slug = body.slug ?? body.name.toLowerCase().replaceAll(" ", "-")

  const oldBlobPath = post.blob_path as string ?? ""
  const newBlobPath = `posts/${slug}/content.json`

  // Move the content blob to the new path if different
  if (oldBlobPath !== newBlobPath) {
    const blobStorage = hubBlob()
    const oldBlobContent = await blobStorage.get(oldBlobPath)
    if (oldBlobContent) {
      await blobStorage.put(newBlobPath, oldBlobContent)
      await blobStorage.delete(oldBlobPath)
      post.blob_path = newBlobPath
      body.blob_path = newBlobPath
    }
  }

  // Process category
  let category = body.category ?? ""
  category = category === "no category" ? "" : category.toLowerCase()

  // Update the post metadata
  const updateStmt = db.prepare(`
    UPDATE posts 
    SET 
      category = ?,
      description = ?,
      language = ?,
      name = ?,
      visibility = ?,
      slug = ?,
      updated_at = CURRENT_TIMESTAMP
    WHERE id = ?
  `)
  
  await updateStmt.bind(
    category,
    body.description ?? "",
    body.language ?? "en",
    body.name,
    body.visibility ?? "public",
    body.slug ?? "",
    post.id
  ).run()

  // Get the updated post
  const updatedPostStmt = db.prepare(`
    SELECT * FROM posts WHERE id = ? LIMIT 1
  `)
  
  const updatedPost = await updatedPostStmt.bind(post.id).first()
  if (!updatedPost) {
    throw createError({
      statusCode: 500,
      message: 'Failed to update post',
    })
  }

  // Format the response
  const formattedPost = {
    ...updatedPost,
    // Parse JSON fields if they exist
    links: typeof updatedPost.links === 'string' ? JSON.parse(updatedPost.links || '[]') : updatedPost.links,
    tags: typeof updatedPost.tags === 'string' ? JSON.parse(updatedPost.tags || '[]') : updatedPost.tags,
    styles: typeof updatedPost.styles === 'string' ? JSON.parse(updatedPost.styles || '{}') : updatedPost.styles,
    image: {
      alt: updatedPost.image_alt || "",
      src: updatedPost.image_src || ""
    }
  }

  // Remove redundant fields
  // delete formattedPost.image_alt
  // delete formattedPost.image_src

  return {
    message: 'Post updated successfully',
    post: formattedPost,
    success: true,
  }
})
