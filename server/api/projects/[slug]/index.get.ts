import { ProjectType } from "~/types/project"

// GET /api/projects/[slug]
export default defineEventHandler(async (event) => {
  const db = hubDatabase()
  const blobStorage = hubBlob()
  const slug = decodeURIComponent(getRouterParam(event, 'slug') ?? '')

  if (!slug) {
    throw createError({
      statusCode: 400,
      message: 'Project slug is required',
    })
  }

  let userId = null
  try {
    const session = await getUserSession(event) // optional - for private projects
    if (session && session.user) {
      userId = session.user.id
    }
  } catch (error) { /* No session, continue as anonymous user */ }

  const project: ProjectType | null = await db
  .prepare(`
    SELECT 
      p.*,
      u.avatar as user_avatar,
      u.name as user_name
    FROM projects p
    JOIN users u ON p.user_id = u.id
    WHERE p.slug = ?
    LIMIT 1
  `)
  .bind(slug)
  .first()

  if (!project) {
    throw createError({
      statusCode: 404,
      message: `Project ${slug} not found`,
    })
  }

  if (project.status === "archived" && project.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to view this project',
    })
  }

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
    console.error(`Failed to update view count for project ${slug}:`, error)
  }

  if (typeof project.links === 'string') { project.links = JSON.parse(project.links) }
  if (typeof project.tags === 'string') { project.tags = JSON.parse(project.tags) }

  project.image = {
    alt: project.image_alt || "",
    ext: project.image_ext || "",
    src: project.image_src || ""
  }

  project.metrics = {
    comments: project.metrics_comments || 0,
    likes: project.metrics_likes || 0,
    views: project.metrics_views || 0,
  }

  project.user = {
    name: project.user_name || "",
    avatar: project.user_avatar || ""
  }

  // Remove redundant fields
  delete project.image_alt
  delete project.image_ext
  delete project.image_src

  delete project.metrics_comments
  delete project.metrics_likes
  delete project.metrics_views

  delete project.user_name
  delete project.user_avatar

  return project
})
