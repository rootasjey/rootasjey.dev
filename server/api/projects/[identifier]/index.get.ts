// GET /api/projects/[identifier]

import { ProjectType } from "~/types/project"
import { getProjectByIdentifier } from '~/server/utils/project'
import { createArticle } from '~/server/utils/post'

export default defineEventHandler(async (event) => {
  const db = hubDatabase()
  const blobStorage = hubBlob()
  const identifier = decodeURIComponent(getRouterParam(event, 'identifier') ?? '')

  if (!identifier) {
    throw createError({
      statusCode: 400,
      message: 'Project identifier is required',
    })
  }

  let userId = null
  try {
    const session = await getUserSession(event) // optional - for private projects
    if (session && session.user) {
      userId = session.user.id
    }
  } catch (error) { /* No session, continue as anonymous user */ }

  const project: ProjectType | null = await getProjectByIdentifier(db, identifier)

  if (!project) {
    throw createError({
      statusCode: 404,
      message: `Project ${identifier} not found`,
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
    const blob_path = `projects/${project.id}/article.json`
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
    console.error(`Failed to update view count for project ${identifier}:`, error)
  }

  // Fetch tags from join table
  const tagsResult = await db.prepare(`
    SELECT t.* FROM tags t
    JOIN project_tags pt ON pt.tag_id = t.id
    WHERE pt.project_id = ?
    ORDER BY pt.rowid ASC
  `).bind(project.id).all()
  
  project.tags = (tagsResult.results || []).map(t => ({
    id: Number(t.id),
    name: String(t.name),
    category: typeof t.category === 'string' ? t.category : '',
    created_at: t.created_at ? String(t.created_at) : '',
    updated_at: t.updated_at ? String(t.updated_at) : ''
  }))

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
