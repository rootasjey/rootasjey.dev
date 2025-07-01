// GET /api/projects/:id/tags

export default defineEventHandler(async (event) => {
  const identifier = getRouterParam(event, 'identifier') || ''
  const isNumericId = typeof identifier === "number" || /^\d+$/.test(String(identifier))

  if (!identifier) {
    throw createError({ statusCode: 400, statusMessage: 'Post identifier (id) is required' })
  }
  
  if (!isNumericId && typeof identifier !== 'string') {
    throw createError({ statusCode: 400, statusMessage: `Invalid post identifier format: ${identifier}` })
  }

  const sql = `SELECT t.* FROM tags t
    INNER JOIN project_tags pt ON pt.tag_id = t.id
    WHERE pt.project_id = ?1
    ORDER BY t.name ASC`
    
  const stmt = hubDatabase().prepare(sql).bind(identifier)
  const tags = await stmt.all()
  return tags.results
})
