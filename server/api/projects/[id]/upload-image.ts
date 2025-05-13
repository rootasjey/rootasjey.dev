// POST /api/project/[id]/upload-image
export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()

  const projectIdOrSlug = event.context.params?.id
  const formData = await readMultipartFormData(event)
  
  const file = formData?.find(item => item.name === 'file')?.data
  const fileName = formData?.find(item => item.name === 'fileName')?.data.toString()
  const type = formData?.find(item => item.name === 'type')?.data.toString()
  // const placement = formData?.find(item => item.name === 'placement')?.data.toString()

  if (!projectIdOrSlug || !file || !fileName || !type) {
    throw createError({
      statusCode: 400,
      message: 'Missing required fields',
    })
  }

  const userId = session.user.id

  // Find the post by ID or slug
  const projectStmt = db.prepare(`
    SELECT * FROM projects WHERE id = ? OR slug = ? LIMIT 1
  `)

  const project = await projectStmt.bind(projectIdOrSlug, projectIdOrSlug).first()

  if (!project) {
    throw createError({
      statusCode: 404,
      message: 'Project not found',
    })
  }

  // Check if the user is the author of the project
  if (project.author_id !== userId) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to update this project',
    })
  }

  // Upload the image to blob storage
  const blob = new Blob([file], { type })
  const uploadedBlob = await hubBlob().put(fileName, blob, {
    addRandomSuffix: true,
    prefix: `projects/${project.slug}`
  })

  const imagePathname = `${uploadedBlob.pathname}`

  // Update the project with the new image information
  const updateStmt = db.prepare(`
    UPDATE projects 
    SET image_src = ?, image_alt = ?, updated_at = CURRENT_TIMESTAMP
    WHERE id = ?
  `)

  await updateStmt.bind(imagePathname, fileName, project.id).run()

  return { 
    image: {
      alt: fileName,
      src: imagePathname,
    },
    success: true, 
  }
})
