// POST /api/tags

export default defineEventHandler(async (event) => {
  const body = await readBody(event)
  if (!body?.name) {
    throw createError({ statusCode: 400, statusMessage: 'Tag name is required' })
  }
  
  const name = body.name.trim()
  const category = body.category?.trim() || 'general'

  try {
    const stmt = hubDatabase().prepare('INSERT INTO tags (name, category) VALUES (?1, ?2)').bind(name, category)
    const result = await stmt.run()
    if (!result.success) {
      throw createError({ statusCode: 500, statusMessage: 'Failed to create tag' })
    }
    // Fetch the created tag (by name and category, since id is not returned)
    const tag = await hubDatabase().prepare('SELECT * FROM tags WHERE name = ?1 AND category = ?2').bind(name, category).first()
    return tag
  } catch (e: any) {
    if (e.message && e.message.includes('UNIQUE')) {
      throw createError({ statusCode: 409, statusMessage: 'Tag already exists' })
    }
    throw createError({ statusCode: 500, statusMessage: 'Failed to create tag' })
  }
})
