// GET /api/tags

export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  let sql = 'SELECT * FROM tags'
  const params: any[] = []

  if (query.category) {
    sql += ' WHERE category = ?1'
    params.push(query.category)
  } else if (query.search) {
    sql += ' WHERE name LIKE ?1'
    params.push(`%${query.search}%`)
  }

  sql += ' ORDER BY name ASC'

  const stmt = hubDatabase().prepare(sql)
  if (params.length) stmt.bind(...params)
  const tags = await stmt.all()
  return tags.results
})
