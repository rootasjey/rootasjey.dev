// PUT /api/projects/[id]/index.put.ts

import { ProjectType } from "~/types/project"

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()

  await checkParamOk(event)
  const projectIdOrSlug = getRouterParam(event, 'id')
  const body = await readBody(event)
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

  // Generate slug if not provided
  const slug = body.slug ?? body.name.toLowerCase().replaceAll(" ", "-")
  const oldBlobPath = project.blob_path as string ?? ""
  const newBlobPath = `projects/${slug}/article.json`

  if (oldBlobPath !== newBlobPath) {
    const blobStorage = hubBlob()
    const oldBlobArticle = await blobStorage.get(oldBlobPath)
    if (oldBlobArticle) {
      await blobStorage.put(newBlobPath, oldBlobArticle)
      await blobStorage.delete(oldBlobPath)
      project.blob_path = newBlobPath
      body.blob_path = newBlobPath
    }
  }

  await db.prepare(`
    UPDATE projects 
    SET 
      name = ?,
      blob_path = ?,
      description = ?,
      category = ?,
      company = ?,
      slug = ?,
      visibility = ?,
      updated_at = CURRENT_TIMESTAMP
    WHERE id = ?
  `)
  .bind(
    body.name,
    body.blob_path ?? project.blob_path,
    body.description ?? "",
    body.category ?? "default",
    body.company ?? "",
    slug,
    body.visibility ?? "private",
    project.id
  )
  .run()

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
    technologies: typeof updatedProject.technologies === 'string' ? JSON.parse(updatedProject.technologies || '[]') : updatedProject.technologies,
    image: {
      alt: updatedProject.image_alt as string || "",
      src: updatedProject.image_src as string || ""
    }
  }

  // Remove redundant fields
  delete formattedProject.image_alt
  delete formattedProject.image_src

  return {
    success: true,
    message: 'Project updated successfully',
    project: formattedProject,
  }
})

async function checkParamOk(event: any) {
  const projectIdOrSlug = event.context.params?.id

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
