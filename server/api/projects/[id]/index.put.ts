// PUT /api/projects/[id]/index.put.ts

import { ProjectType } from "~/types/project"

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()

  await handleParamErrors(event)
  const projectIdOrSlug = getRouterParam(event, 'id')
  const body = await readBody(event)
  const userId = session.user.id

  let project: ProjectType | null = await db
  .prepare(`SELECT * FROM projects WHERE id = ? OR slug = ? LIMIT 1`)
  .bind(projectIdOrSlug, projectIdOrSlug)
  .first()

  handleProjectErrors(project, userId)
  project = project as ProjectType

  // Only generate/update slug if explicitly provided in body
  const shouldUpdateSlug = body.slug !== undefined
  const newSlug = shouldUpdateSlug ? body.slug : (body.name ? body.name.toLowerCase().replaceAll(" ", "-") : project.slug)

  // Build dynamic SQL query based on whether slug should be updated
  let updateQuery = `
    UPDATE projects 
    SET 
      name = ?,
      description = ?,
      tags = ?,
      company = ?,
      status = ?`
  
  const updateParams = [
    body.name,
    body.description ?? "",
    typeof body.tags === 'object' ? JSON.stringify(body.tags || []) : '[]',
    body.company ?? "",
    body.status ?? "active"
  ]

  if (shouldUpdateSlug) {
    updateQuery += `, slug = ?`
    updateParams.push(newSlug)
  }

  updateQuery += `, updated_at = CURRENT_TIMESTAMP WHERE id = ?`
  updateParams.push(project.id)

  await db.prepare(updateQuery)
    .bind(...updateParams)
    .run()

  // Handle blob files relocation only if slug is being updated
  if (shouldUpdateSlug && project.slug !== newSlug) {
    const blobStorage = hubBlob()
    const oldPrefix = `projects/${project.slug}`
    const newPrefix = `projects/${newSlug}`

    try {
      // List all blobs with the old slug prefix
      const blobList = await blobStorage.list({ prefix: oldPrefix })
      
      // Relocate each blob to the new path
      for (const blobItem of blobList.blobs) {
        const oldPath = blobItem.pathname
        const relativePath = oldPath.replace(oldPrefix, '')
        const newPath = `${newPrefix}${relativePath}`
        
        // Get the blob content
        const blobContent = await blobStorage.get(oldPath)
        
        if (blobContent) {
          // Upload to new location
          await blobStorage.put(newPath, blobContent)
          // Delete from old location
          await blobStorage.delete(oldPath)
        }
      }

      // Update blob_path in database if it exists
      if (project.blob_path) {
        const newBlobPath = project.blob_path.replace(oldPrefix, newPrefix)
        await db.prepare(`UPDATE projects SET blob_path = ? WHERE id = ?`)
          .bind(newBlobPath, project.id)
          .run()
      }

      // Update image_src in database if it exists (for cover images)
      if (project.image_src) {
        const newImageSrc = project.image_src.replace(oldPrefix, newPrefix)
        await db.prepare(`UPDATE projects SET image_src = ? WHERE id = ?`)
          .bind(newImageSrc, project.id)
          .run()
      }

    } catch (error) {
      console.error(`Failed to relocate blobs from ${oldPrefix} to ${newPrefix}:`, error)
      throw createError({
        statusCode: 500,
        message: 'Failed to relocate project files during slug update',
      })
    }
  }

  const updatedProject = await db
  .prepare(`SELECT * FROM projects WHERE id = ? LIMIT 1`)
  .bind(project.id)
  .first()

  if (!updatedProject) {
    throw createError({
      statusCode: 500,
      message: 'Failed to retrieve updated project',
    })
  }

  const formattedProject: Partial<ProjectType> = {
    ...updatedProject,
    links: typeof updatedProject.links === 'string' ? JSON.parse(updatedProject.links || '[]') : updatedProject.links,
    tags: typeof updatedProject.tags === 'string' ? JSON.parse(updatedProject.tags || '[]') : updatedProject.tags,
    image: {
      alt: updatedProject.image_alt as string || "",
      ext:  updatedProject.image_ext as string || "",
      src: updatedProject.image_src as string || "",
    }
  }

  // Remove redundant fields
  delete formattedProject.image_alt
  delete formattedProject.image_ext
  delete formattedProject.image_src

  return {
    success: true,
    message: 'Project updated successfully',
    project: formattedProject,
  }
})

async function handleParamErrors(event: any) {
  const projectIdOrSlug = getRouterParam(event, 'id')

  if (!projectIdOrSlug) {
    throw createError({
      statusCode: 400,
      message: 'Project ID or slug is required',
    })
  }

  const body = await readBody(event)
  if (!body.name) {
    throw createError({
      statusCode: 400,
      message: 'Project name is required',
    })
  }

  return true
}

async function handleProjectErrors(project: any, userId?: number) {
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
}
