// POST /api/posts/[id]/upload-image
export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()

  const postIdOrSlug = event.context.params?.id
  const formData = await readMultipartFormData(event)
  
  const file = formData?.find(item => item.name === 'file')?.data
  const fileName = formData?.find(item => item.name === 'fileName')?.data.toString()
  const type = formData?.find(item => item.name === 'type')?.data.toString()
  // const placement = formData?.find(item => item.name === 'placement')?.data.toString()

  if (!postIdOrSlug || !file || !fileName || !type) {
    throw createError({
      statusCode: 400,
      message: 'Missing required fields',
    })
  }

  const userId = session.user.id

  // Find the post by ID or slug
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

  // Upload the image to blob storage
  const blob = new Blob([file], { type })
  const uploadedBlob = await hubBlob().put(fileName, blob, {
    addRandomSuffix: true,
    prefix: `posts/${post.slug}`
  })

  const imagePathname = `${uploadedBlob.pathname}`

  // Update the post with the new image information
  const updateStmt = db.prepare(`
    UPDATE posts 
    SET image_src = ?, image_alt = ?, updated_at = CURRENT_TIMESTAMP
    WHERE id = ?
  `)

  await updateStmt.bind(imagePathname, fileName, post.id).run()

  return { 
    image: {
      alt: fileName,
      src: imagePathname,
    },
    success: true, 
  }
})
