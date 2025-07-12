// GET /api/projects

import { Project } from "~/types/project"

export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const limit = parseInt((query.limit as string) ?? '50', 10)
  const offset = parseInt((query.offset as string) ?? '0', 10)

  const session = await getUserSession(event)

  // Build SQL query to exclude archived projects unless user owns them
  let sql = `SELECT * FROM projects WHERE (status != 'archived'${session?.user?.id ? ' OR user_id = ?' : ''})`
  const params = []
  
  if (session?.user?.id) {
    params.push(session.user.id)
  }

  // Add pagination
  const safeLimit = Math.max(1, Math.min(limit, 100))
  const safeOffset = Math.max(0, offset)
  sql += ` LIMIT ? OFFSET ?`
  params.push(safeLimit, safeOffset)

  const dbResponse = await hubDatabase()
  .prepare(sql)
  .bind(...params)
  .all()

  for (const project of dbResponse.results) {
    if (typeof project.links === 'string') {
      try { project.links = JSON.parse(project.links) } catch { project.links = [] }
    }

    // Fetch tags from join table
    const db = hubDatabase()
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

    project.createdAt = project.created_at ? String(project.created_at) : ''
    project.updatedAt = project.updated_at ? String(project.updated_at) : ''

    delete project.created_at
    delete project.updated_at

    project.image = {
      alt: project.image_alt || "",
      ext: project.image_ext || "",
      src: project.image_src || "",
    }

    // Remove redundant fields
    delete project.image_alt
    delete project.image_ext
    delete project.image_src
  }

  // Get total count for pagination with same filtering logic
  const countSql = `SELECT COUNT(*) as count FROM projects WHERE (status != 'archived'${session?.user?.id ? ' OR user_id = ?' : ''})`
  const countParams = []
  if (session?.user?.id) countParams.push(session.user.id)
  
  const countResponse = await hubDatabase()
    .prepare(countSql)
    .bind(...countParams)
    .first()

  return {
    projects: dbResponse.results as Project[],
    pagination: {
      total: countResponse?.count ?? 0,
      limit,
      offset
    },
  }
})
