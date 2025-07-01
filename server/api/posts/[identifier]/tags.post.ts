// POST /api/posts/:id/tags
// Body: { tagIds: number[] }

export default defineEventHandler(async (event) => {
  const identifier = getRouterParam(event, 'identifier') || ''
  const isNumericId = typeof identifier === "number" || /^\d+$/.test(String(identifier))

  if (!identifier) {
    throw createError({ statusCode: 400, statusMessage: 'Post identifier (id) is required' })
  }
  
  if (!isNumericId && typeof identifier !== 'string') {
    throw createError({ statusCode: 400, statusMessage: `Invalid post identifier format: ${identifier}` })
  }

  const body = await readBody(event)
  
  if (!identifier || !Array.isArray(body?.tagIds)) {
    throw createError({ statusCode: 400, statusMessage: 'Post id and tagIds are required' })
  }
  
  // Remove all existing tags for this post
  await hubDatabase().prepare('DELETE FROM post_tags WHERE post_id = ?1').bind(identifier).run()
  
  // Insert new tags
  for (const tagId of body.tagIds) {
    await hubDatabase().prepare('INSERT INTO post_tags (post_id, tag_id) VALUES (?1, ?2)').bind(identifier, tagId).run()
  }
  
  // Return updated tags
  const sql = `SELECT t.* FROM tags t
    INNER JOIN post_tags pt ON pt.tag_id = t.id
    WHERE pt.post_id = ?1
    ORDER BY t.name ASC`
  
    const stmt = hubDatabase().prepare(sql).bind(identifier)
  
    const tags = await stmt.all()
  return tags.results
})
