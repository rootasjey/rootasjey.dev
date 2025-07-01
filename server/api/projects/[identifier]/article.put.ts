// PUT /api/projects/[identifier]/article
import { getProjectByIdentifier } from '~/server/utils/project'
import { z } from 'zod'

const updateArticleSchema = z.object({
  article: z.any(),
})

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const identifier = decodeURIComponent(getRouterParam(event, 'identifier') ?? '')
  const body = await readValidatedBody(event, updateArticleSchema.parse)

  if (!identifier) {
    throw createError({
      statusCode: 400,
      message: "Project identifier is required",
    })
  }

  const userId = session.user.id
  const project = await getProjectByIdentifier(db, identifier)

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
