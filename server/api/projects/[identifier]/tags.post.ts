// POST /api/projects/:id/tags
// Body: { tagIds: number[] }

export default defineEventHandler(async (event) => {
  const identifier = getRouterParam(event, 'identifier') || ''
  const isNumericId = typeof identifier === "number" || /^\d+$/.test(String(identifier))
  const body = await readBody(event)
  const db = hubDatabase()

  if (!identifier) {
    throw createError({ statusCode: 400, statusMessage: 'Post identifier (id) is required' })
  }
  
  if (!isNumericId && typeof identifier !== 'string') {
    throw createError({ statusCode: 400, statusMessage: `Invalid post identifier format: ${identifier}` })
  }

  if (!Array.isArray(body?.tagIds)) {
    throw createError({ statusCode: 400, statusMessage: 'Project id and tagIds are required' })
  }
  
  // Remove all existing tags for this project
  await db.prepare('DELETE FROM project_tags WHERE project_id = ?1').bind(identifier).run()
  
  // Insert new tags
  for (const tagId of body.tagIds) {
    await db.prepare('INSERT INTO project_tags (project_id, tag_id) VALUES (?1, ?2)').bind(identifier, tagId).run()
  }
  
  // Return updated tags
  const sql = `SELECT t.* FROM tags t
    INNER JOIN project_tags pt ON pt.tag_id = t.id
    WHERE pt.project_id = ?1
    ORDER BY t.name ASC`
  
    const stmt = db.prepare(sql).bind(identifier)
  const tags = await stmt.all()
  return tags.results
})
