// GET /api/posts/:id/tags

export default defineEventHandler(async (event) => {
  const id = event.context.params?.id
  if (!id) {
    throw createError({ statusCode: 400, statusMessage: 'Post id is required' })
  }
  const sql = `SELECT t.* FROM tags t
    INNER JOIN post_tags pt ON pt.tag_id = t.id
    WHERE pt.post_id = ?1
    ORDER BY t.name ASC`
  const stmt = hubDatabase().prepare(sql).bind(id)
  const tags = await stmt.all()
  return tags.results
})
