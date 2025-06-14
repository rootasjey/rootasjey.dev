// GET /api/projects/[id]
export default defineEventHandler(async (event) => {
  const db = hubDatabase()
  const blobStorage = hubBlob()
  const idOrSlug = event.context.params?.id

  if (!idOrSlug) {
    throw createError({
      statusCode: 400,
      message: 'Project ID or slug is required',
    })
  }

  // Check if we have a session (optional - for private projects)
  let userId = null
  try {
    const session = await getUserSession(event)
    if (session && session.user) {
      userId = session.user.id
    }
  } catch (error) {
    // No session, continue as anonymous user
  }

  // Query that can find a project by either ID or slug
  const stmt = db.prepare(`
    SELECT * FROM projects 
    WHERE id = ? OR slug = ? 
    LIMIT 1
  `)
  
  const project = await stmt.bind(idOrSlug, idOrSlug).first()

  if (!project) {
    throw createError({
      statusCode: 404,
      message: `Project ${idOrSlug} not found`,
    })
  }

  // Check visibility permissions
  if (project.visibility !== "public" && project.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to view this project',
    })
  }

  const slug = project.slug

  if (!project.blob_path) {
    const postContentBlob = createPostFileContent()
    const blob_path = `projects/${slug}/content.json`
    await blobStorage.put(blob_path, JSON.stringify(postContentBlob))

    // Update the project with the blob path
    await db.prepare(`
      UPDATE projects 
      SET blob_path = ? 
      WHERE id = ?
      `).bind(blob_path, project.id)
      .run()

    project.blob_path = blob_path
  }

  // Fetch content from blob storage if available
  const contentBlob = await blobStorage.get(project.blob_path as string)
  if (contentBlob) {
    const contentText = await contentBlob.text()
    project.content = JSON.parse(contentText)
  }

  try { // Update view count
    const updateStmt = db.prepare(`
      UPDATE projects 
      SET metrics_views = metrics_views + 1 
      WHERE id = ?1
    `)
    await updateStmt.bind(project.id).run()
  } catch (error) {
    console.error(`Failed to update view count for project ${idOrSlug}:`, error)
  }

  // Parse JSON fields
  if (typeof project.links === 'string') {
    project.links = JSON.parse(project.links)
  }
  if (typeof project.technologies === 'string') {
    project.technologies = JSON.parse(project.technologies)
  }

  project.image = {
    alt: project.image_alt || "",
    src: project.image_src || ""
  }

  // Remove redundant fields
  delete project.image_alt
  delete project.image_src

  return project
})
