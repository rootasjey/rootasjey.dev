// GET /api/admin/users

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  
  if (!session?.user) {
    throw createError({
      statusCode: 401,
      statusMessage: 'Authentication required'
    })
  }

  if (session.user.role !== 'admin') {
    throw createError({
      statusCode: 403,
      statusMessage: 'Admin access required'
    })
  }

  const db = hubDatabase()
  const query = getQuery(event)
  const search = query.search as string || ''
  const role = query.role as string || ''

  try {
    // Build the SQL query
    let sql = `
      SELECT 
        id, name, email, role, created_at, updated_at, last_login_at,
        biography, job, location, language
      FROM users
    `
    const params: any[] = []
    const conditions: string[] = []

    // Add search condition
    if (search) {
      conditions.push('(name LIKE ? OR email LIKE ?)')
      params.push(`%${search}%`, `%${search}%`)
    }

    // Add role filter
    if (role && role !== 'all') {
      conditions.push('role = ?')
      params.push(role)
    }

    // Add WHERE clause if there are conditions
    if (conditions.length > 0) {
      sql += ' WHERE ' + conditions.join(' AND ')
    }

    sql += ' ORDER BY created_at DESC'

    // Execute query
    const stmt = db.prepare(sql)
    if (params.length > 0) {
      stmt.bind(...params)
    }
    const users = await stmt.all()

    // Get user statistics
    const statsQuery = await db.prepare(`
      SELECT 
        COUNT(*) as total,
        SUM(CASE WHEN role = 'admin' THEN 1 ELSE 0 END) as admins,
        SUM(CASE WHEN role = 'moderator' THEN 1 ELSE 0 END) as moderators,
        SUM(CASE WHEN role = 'user' THEN 1 ELSE 0 END) as regular
      FROM users
    `).first()

    if (!statsQuery) {
      throw createError({
        statusCode: 500,
        statusMessage: 'Failed to fetch user statistics'
      })
    }

    return {
      users: users.results || [],
      stats: {
        total: statsQuery.total || 0,
        admins: statsQuery.admins || 0,
        moderators: statsQuery.moderators || 0,
        regular: statsQuery.regular || 0
      }
    }
  } catch (error: any) {
    console.error('Error fetching users:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to fetch users'
    })
  }
})
