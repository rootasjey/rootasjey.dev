// DELETE /api/projects/[id]/remove-image
export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const projectIdOrSlug = event.context.params?.id

  if (!projectIdOrSlug) {
    throw createError({
      statusCode: 400,
      message: 'Project ID or slug is required',
    })
  }

  const userId = session.user.id

  // Find the project by ID or slug
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
  if (project.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to update this project',
    })
  }

  if (!project.image_src) {
    throw createError({
      statusCode: 400,
      message: 'Project does not have an image',
    })
  }

  try {
    await hubBlob().delete(project.image_src as string)
    const updateStmt = db.prepare(`
      UPDATE projects 
      SET image_src = '', image_alt = '', updated_at = CURRENT_TIMESTAMP
      WHERE id = ?
    `)

    await updateStmt.bind(project.id).run()

    return { 
      error: null,
      success: true,
      message: 'Image removed successfully',
      project,
    }
  } catch (error) {
    console.log(error)
    return {
      error,
      success: false,
      message: 'Failed to remove image',
      project,
    }
  }
})
