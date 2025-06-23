// GET /api/projects

import { ProjectType } from "~/types/project"

export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const limit = parseInt((query.limit as string) ?? '50', 10)
  const offset = parseInt((query.offset as string) ?? '0', 10)
  const visibility = query.visibility ?? 'public'

  const session = await getUserSession(event)

  let sql = `SELECT * FROM projects WHERE (visibility = ?${session?.user?.id ? ' OR user_id = ?' : ''})`
  const params = [visibility]
  
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
    if (typeof project.technologies === 'string') {
      try { project.technologies = JSON.parse(project.technologies) } catch { project.technologies = [] }
    }

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

  // Get total count for pagination
  const countSql = `SELECT COUNT(*) as count FROM projects WHERE (visibility = ?${session?.user?.id ? ' OR user_id = ?' : ''})`
  const countParams = [visibility]
  if (session?.user?.id) countParams.push(session.user.id)
  const countResponse = await hubDatabase()
    .prepare(countSql)
    .bind(...countParams)
    .first()

  return {
    projects: dbResponse.results as ProjectType[],
    pagination: {
      total: countResponse?.count ?? 0,
      limit,
      offset
    },
  }
})
