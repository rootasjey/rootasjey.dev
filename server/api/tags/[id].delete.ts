// DELETE /api/tags/:id

export default defineEventHandler(async (event) => {
  const id = event.context.params?.id
  if (!id) {
    throw createError({ statusCode: 400, statusMessage: 'Tag id is required' })
  }
  const stmt = hubDatabase().prepare('DELETE FROM tags WHERE id = ?1').bind(id)
  const result = await stmt.run()
  // D1's .run() does not return .changes, so check success/meta
  if (!result.success || (result.meta?.rows_written ?? 0) === 0) {
    throw createError({ statusCode: 404, statusMessage: 'Tag not found' })
  }
  return { id }
})
