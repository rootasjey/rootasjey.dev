// POST /api/project/[id]/cover

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const projectIdOrSlug = getRouterParam(event, 'id')
  const formData = await readMultipartFormData(event)
  const db = hubDatabase()
  
  const file = formData?.find(item => item.name === 'file')?.data
  const fileName = formData?.find(item => item.name === 'fileName')?.data.toString()
  const type = formData?.find(item => item.name === 'type')?.data.toString()

  if (!projectIdOrSlug || !file || !fileName || !type) {
    throw createError({
      statusCode: 400,
      message: 'Missing required fields',
    })
  }

  const userId = session.user.id

  const project = await db
  .prepare(`SELECT * FROM projects WHERE id = ? OR slug = ? LIMIT 1`)
  .bind(projectIdOrSlug, projectIdOrSlug)
  .first()

  if (!project) {
    throw createError({
      statusCode: 404,
      message: 'Project not found',
    })
  }

  if (project.user_id !== userId) {
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

  await db.prepare(`
    UPDATE projects 
    SET image_src = ?, image_alt = ?, updated_at = CURRENT_TIMESTAMP
    WHERE id = ?
  `)
  .bind(imagePathname, fileName, project.id)
  .run()

  return { 
    image: {
      alt: fileName,
      src: imagePathname,
    },
    success: true, 
  }
})
