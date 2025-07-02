// DELETE /api/projects/[identifier]/cover
import { getProjectByIdentifier } from '~/server/utils/project'
import { ApiProject } from "~/types/project"

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const userId = session.user.id
  const identifier = decodeURIComponent(getRouterParam(event, 'identifier') ?? '')
  const db = hubDatabase()

  let project: ApiProject | null = await getProjectByIdentifier(db, identifier)

  handleErrors({ project, userId })
  project = project as ApiProject

  try {
    const prefix = project.image_src as string
    const blobList = await hubBlob().list({ prefix })
    
    for (const blobItem of blobList.blobs) {
      await hubBlob().delete(blobItem.pathname)
    }

    await db
    .prepare(`
      UPDATE projects 
      SET image_src = '', image_alt = '', image_ext = '', updated_at = CURRENT_TIMESTAMP
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

type HandleErrorsProps = {
  project: ApiProject | null
  userId: number
}

const handleErrors = ({ project, userId } : HandleErrorsProps) => {
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
}
