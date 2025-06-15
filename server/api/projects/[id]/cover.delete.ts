// DELETE /api/projects/[id]/cover

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const projectIdOrSlug = getRouterParam(event, 'id')

  if (!projectIdOrSlug) {
    throw createError({
      statusCode: 400,
      message: 'Project ID or slug is required',
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

  if (!project.image_src) {
    throw createError({
      statusCode: 400,
      message: 'Project does not have an image',
    })
  }

  try {
    await hubBlob().delete(project.image_src as string)
    await db.prepare(`
      UPDATE projects 
      SET image_src = '', image_alt = '', updated_at = CURRENT_TIMESTAMP
      WHERE id = ?
    `)
    .bind(project.id)
    .run()

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
