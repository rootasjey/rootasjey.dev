// DELETE /api/projects/:id
// Delete a project from SQLite database
export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const body = await readBody(event)
  const id = body.id

  if (!id) {
    throw createError({
      statusCode: 400,
      message: 'Project ID (`id`) is required.',
    })
  }

  // First, check if the project exists and belongs to the user
  const projectStmt = db.prepare(`
    SELECT * FROM projects WHERE id = ? LIMIT 1
  `)
  
  const project = await projectStmt.bind(id).first()

  if (!project) {
    throw createError({
      statusCode: 404,
      message: 'Project not found.',
    })
  }

  const userId = session.user.id
  if (project.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: "You are not authorized to delete this project",
    })
  }

  // Delete the project from blob storage
  if (project.blob_path && typeof project.blob_path === 'string') {
    const blobStorage = hubBlob()
    await blobStorage.delete(project.blob_path)
  }

  // Delete the project
  const deleteStmt = db.prepare(`
    DELETE FROM projects WHERE id = ?
  `)
  
  await deleteStmt.bind(id).run()

  return {
    message: "Project deleted successfully",
    id,
  }
})
