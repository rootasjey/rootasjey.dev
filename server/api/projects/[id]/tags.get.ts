// GET /api/projects/:id/tags

export default defineEventHandler(async (event) => {
  const id = event.context.params?.id
  if (!id) {
    throw createError({ statusCode: 400, statusMessage: 'Project id is required' })
  }
  const sql = `SELECT t.* FROM tags t
    INNER JOIN project_tags pt ON pt.tag_id = t.id
    WHERE pt.project_id = ?1
    ORDER BY t.name ASC`
  const stmt = hubDatabase().prepare(sql).bind(id)
  const tags = await stmt.all()
  return tags.results
})
