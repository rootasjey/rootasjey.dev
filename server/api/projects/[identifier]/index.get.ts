// GET /api/projects/[identifier]

import { convertApiProjectToProject, getProjectByIdentifier } from '~/server/utils/project'
import { createArticle } from '~/server/utils/post'

export default defineEventHandler(async (event) => {
  const db = hubDatabase()
  const blobStorage = hubBlob()
  const identifier = decodeURIComponent(getRouterParam(event, 'identifier') ?? '')

  if (!identifier) {
    throw createError({ statusCode: 400, message: 'Project identifier is required' })
  }

  let userId = null
  try {
    const session = await getUserSession(event) // optional - for private projects
    if (session && session.user) { userId = session.user.id }
  } catch (error) { /* No session, continue as anonymous user */ }

  const apiProject = await getProjectByIdentifier(db, identifier)

  if (!apiProject) {
    throw createError({ statusCode: 404, message: `Project ${identifier} not found` })
  }

  if (apiProject.status === "archived" && apiProject.user_id !== userId) {
    throw createError({ statusCode: 403, message: 'You are not authorized to view this project' })
  }

  if (!apiProject.blob_path) {
    const newArticleBlob = createArticle()
    const blob_path = `projects/${apiProject.id}/article.json`
    await blobStorage.put(blob_path, JSON.stringify(newArticleBlob))
    await db.prepare(`UPDATE projects SET blob_path = ? WHERE id = ?`)
      .bind(blob_path, apiProject.id)
      .run()
    apiProject.blob_path = blob_path
  }

  try {
    await db
      .prepare(`UPDATE projects SET metrics_views = metrics_views + 1 WHERE id = ?1`)
      .bind(apiProject.id)
      .run()
  } catch (error) { console.error(`Failed to update view count for project ${identifier}:`, error) }


  const articleBlob = await blobStorage.get(apiProject.blob_path as string)
  const article = await articleBlob?.text() ?? ''

  const tagQuery = await db.prepare(`
    SELECT t.* FROM tags t
    JOIN project_tags pt ON pt.tag_id = t.id
    WHERE pt.project_id = ?
    ORDER BY pt.rowid ASC
  `).bind(apiProject.id).all()

  const project = convertApiProjectToProject(apiProject, {
    tags: tagQuery.results,
    article,
  })

  return project
})
