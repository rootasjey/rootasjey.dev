// PUT /api/projects/[id]/update-content
export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const projectIdOrSlug = event.context.params?.id
  const body = await readBody(event)

  if (!projectIdOrSlug) {
    throw createError({
      statusCode: 400,
      message: "Project's ID or slug is required",
    })
  }

  if (!body.content) {
    throw createError({
      statusCode: 400,
      message: "Project's content is required",
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
  if (project.author_id !== userId) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to update this project',
    })
  }

  try {
    // If there's an existing blob_path, update the existing blob
    const contentBlob = new Blob([JSON.stringify(body.content)], { 
      type: 'application/json' 
    })
    
    // Update the existing blob
    await hubBlob().put(project.blob_path as string, contentBlob)
    
    // Update the project's updated_at timestamp
    const updateTimestampStmt = db.prepare(`
      UPDATE projects 
      SET updated_at = CURRENT_TIMESTAMP
      WHERE id = ?
    `)
    
    await updateTimestampStmt.bind(project.id).run()

    // Get the updated project
    const updatedProjectStmt = db.prepare(`
      SELECT * FROM projects WHERE id = ? LIMIT 1
    `)
    
    const updatedProject = await updatedProjectStmt.bind(project.id).first()

    return {
      message: 'Project content updated successfully',
      project: updatedProject,
      success: true,
    }
  } catch (error) {
    console.error('Error updating project content:', error)
    throw createError({
      statusCode: 500,
      message: 'Failed to update project content',
    })
  }
})
