// DELETE /api/projects/:id

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const id = getRouterParam(event, 'id')

  if (!id) {
    throw createError({
      statusCode: 400,
      message: 'Project ID (`id`) is required.',
    })
  }

  const project = await db
  .prepare(`SELECT * FROM projects WHERE id = ? LIMIT 1`)
  .bind(id)
  .first()

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

  if (project.blob_path && typeof project.blob_path === 'string') {
    const blobStorage = hubBlob()
    await blobStorage.delete(project.blob_path)
  }

  await db
  .prepare(`DELETE FROM projects WHERE id = ?`)
  .bind(id)
  .run()

  return {
    success: true,
    message: "Project deleted successfully",
    project,
  }
})
