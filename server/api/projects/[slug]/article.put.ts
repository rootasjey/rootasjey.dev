// PUT /api/projects/[slug]/article

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const slug = decodeURIComponent(getRouterParam(event, 'slug') ?? '')
  const body = await readBody(event)

  if (!slug) {
    throw createError({
      statusCode: 400,
      message: "Project's slug is required",
    })
  }

  if (!body.article) {
    throw createError({
      statusCode: 400,
      message: "Project's article is required",
    })
  }

  const userId = session.user.id

  const project = await db
  .prepare(`SELECT * FROM projects WHERE slug = ? LIMIT 1`)
  .bind(slug)
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

  try {
    const articleBlob = new Blob([JSON.stringify(body.article)], { 
      type: 'application/json' 
    })
    
    await hubBlob().put(project.blob_path as string, articleBlob)
    
    await db
    .prepare(`UPDATE projects SET updated_at = CURRENT_TIMESTAMP WHERE id = ?`)
    .bind(project.id)
    .run()

    const updatedProject = await db
    .prepare(`SELECT * FROM projects WHERE id = ? LIMIT 1`)
    .bind(project.id)
    .first()

    return {
      message: 'Project article updated successfully',
      project: updatedProject,
      success: true,
    }
  } catch (error) {
    console.error('Error updating project article:', error)
    throw createError({
      statusCode: 500,
      message: 'Failed to update project article',
    })
  }
})
