// PUT /api/tags/:id

export default defineEventHandler(async (event) => {
  const id = event.context.params?.id
  const body = await readBody(event)
  if (!id || !body?.name) {
    throw createError({ statusCode: 400, statusMessage: 'Tag id and name are required' })
  }
  const name = body.name.trim()
  const category = body.category?.trim() || 'general'

  const stmt = hubDatabase().prepare('UPDATE tags SET name = ?1, category = ?2 WHERE id = ?3').bind(name, category, id)
  const result = await stmt.run()
  if (!result.success || (result.meta?.rows_written ?? 0) === 0) {
    throw createError({ statusCode: 404, statusMessage: 'Tag not found' })
  }
  // Fetch the updated tag
  const tag = await hubDatabase().prepare('SELECT * FROM tags WHERE id = ?1').bind(id).first()
  return tag
})
