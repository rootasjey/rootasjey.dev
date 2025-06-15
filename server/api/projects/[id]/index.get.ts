// GET /api/projects/[id]
export default defineEventHandler(async (event) => {
  const db = hubDatabase()
  const blobStorage = hubBlob()
  const idOrSlug = getRouterParam(event, 'id')

  if (!idOrSlug) {
    throw createError({
      statusCode: 400,
      message: 'Project ID or slug is required',
    })
  }

  let userId = null
  try {
    const session = await getUserSession(event) // optional - for private projects
    if (session && session.user) {
      userId = session.user.id
    }
  } catch (error) { /* No session, continue as anonymous user */ }

  const project = await db
  .prepare(`SELECT * FROM projects WHERE id = ? OR slug = ? LIMIT 1`)
  .bind(idOrSlug, idOrSlug)
  .first()

  if (!project) {
    throw createError({
      statusCode: 404,
      message: `Project ${idOrSlug} not found`,
    })
  }

  if (project.visibility !== "public" && project.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to view this project',
    })
  }

  const slug = project.slug

  if (!project.blob_path) {
    const newArticleBlob = createArticle()
    const blob_path = `projects/${slug}/article.json`
    await blobStorage.put(blob_path, JSON.stringify(newArticleBlob))

    await db.prepare(`UPDATE projects SET blob_path = ? WHERE id = ?`)
    .bind(blob_path, project.id)
    .run()

    project.blob_path = blob_path
  }

  const articleBlob = await blobStorage.get(project.blob_path as string)
  
  if (articleBlob) {
    const textArticle = await articleBlob.text()
    project.article = JSON.parse(textArticle)
  }

  try {
    await db
    .prepare(`UPDATE projects SET metrics_views = metrics_views + 1 WHERE id = ?1`)
    .bind(project.id)
    .run()
  } catch (error) {
    console.error(`Failed to update view count for project ${idOrSlug}:`, error)
  }

  if (typeof project.links === 'string') { project.links = JSON.parse(project.links) }
  if (typeof project.technologies === 'string') { project.technologies = JSON.parse(project.technologies) }

  project.image = {
    alt: project.image_alt || "",
    src: project.image_src || ""
  }

  // Remove redundant fields
  delete project.image_alt
  delete project.image_src

  return project
})
