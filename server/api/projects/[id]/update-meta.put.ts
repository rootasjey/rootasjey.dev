// PUT /api/projects/[id]/update
export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()

  await checkParamOk(event)
  const projectIdOrSlug = event.context.params?.id
  const body = await readBody(event)
  const userId = session.user.id

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


  // Generate slug if not provided
  const slug = body.slug ?? body.name.toLowerCase().replaceAll(" ", "-")

  const oldBlobPath = project.blob_path as string ?? ""
  const newBlobPath = `projects/${slug}/content.json`

  // Move the content blob to the new path if different
  if (oldBlobPath !== newBlobPath) {
    const blobStorage = hubBlob()
    const oldBlobContent = await blobStorage.get(oldBlobPath)
    if (oldBlobContent) {
      await blobStorage.put(newBlobPath, oldBlobContent)
      await blobStorage.delete(oldBlobPath)
      project.blob_path = newBlobPath
      body.blob_path = newBlobPath
    }
  }

  // Update the project
  const updateStmt = db.prepare(`
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
  
  await updateStmt.bind(
    body.name,
    body.blob_path ?? project.blob_path,
    body.description ?? "",
    body.category ?? "default",
    body.company ?? "",
    slug,
    body.visibility ?? "private",
    project.id
  ).run()

  // Get the updated project
  const updatedProjectStmt = db.prepare(`
    SELECT * FROM projects WHERE id = ? LIMIT 1
  `)
  
  const updatedProject = await updatedProjectStmt.bind(project.id).first()
  if (!updatedProject) {
    throw createError({
      statusCode: 500,
      message: 'Failed to retrieve updated project',
    })
  }

  // Format the response
  const formattedProject = {
    ...updatedProject,
    // Parse JSON fields if they exist
    links: typeof updatedProject.links === 'string' ? JSON.parse(updatedProject.links || '[]') : updatedProject.links,
    technologies: typeof updatedProject.technologies === 'string' ? JSON.parse(updatedProject.technologies || '[]') : updatedProject.technologies,
    // Reconstruct image object
    image: {
      alt: updatedProject.image_alt || "",
      src: updatedProject.image_src || ""
    }
  }

  // Remove redundant fields
  // @ts-ignore
  delete formattedProject.image_alt
  // @ts-ignore
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
