// DELETE /api/projects/:slug

import { ProjectType } from "~/types/project"

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const slug = decodeURIComponent(getRouterParam(event, 'slug') ?? '')

  if (!slug) {
    throw createError({
      statusCode: 400,
      message: 'Project slug is required.',
    })
  }

  const project: ProjectType | null = await db
  .prepare(`SELECT * FROM projects WHERE slug = ? LIMIT 1`)
  .bind(slug)
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

  // Delete images cover if it exists
  if (project.image_src) {
    try {
      const prefix = project.image_src as string
      const blobList = await hubBlob().list({ prefix })
      
      for (const blobItem of blobList.blobs) {
        await hubBlob().delete(blobItem.pathname)
      }
    } catch (error) {
      console.error(`Failed to delete image cover at ${project.image_src}:`, error)
      // Continue with project deletion even if image cover deletion fails
    }
  }

  await db
  .prepare(`DELETE FROM projects WHERE id = ?`)
  .bind(project.id)
  .run()

  return {
    success: true,
    message: "Project deleted successfully",
    project,
  }
})
