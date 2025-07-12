// GET /api/admin/activity

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
  const limit = parseInt(query.limit as string) || 20

  try {
    // Get recent posts activity
    const recentPosts = await db.prepare(`
      SELECT
        'post' as type,
        id,
        name as title,
        status,
        created_at,
        updated_at,
        'created' as action
      FROM posts
      ORDER BY created_at DESC
      LIMIT ?
    `).bind(Math.ceil(limit / 3)).all()

    // Get recent projects activity
    const recentProjects = await db.prepare(`
      SELECT
        'project' as type,
        id,
        name as title,
        status,
        created_at,
        updated_at,
        'created' as action
      FROM projects
      ORDER BY created_at DESC
      LIMIT ?
    `).bind(Math.ceil(limit / 3)).all()

    // Get recent users activity
    const recentUsers = await db.prepare(`
      SELECT
        'user' as type,
        id,
        name as title,
        role as status,
        created_at,
        updated_at,
        'registered' as action
      FROM users
      ORDER BY created_at DESC
      LIMIT ?
    `).bind(Math.ceil(limit / 3)).all()

    // Combine and sort all activities
    const allActivities = [
      ...recentPosts.results.map((item: any) => ({
        ...item,
        icon: 'i-ph-article',
        color: '#093FB4'
      })),
      ...recentProjects.results.map((item: any) => ({
        ...item,
        icon: 'i-ph-folder',
        color: '#ED3500'
      })),
      ...recentUsers.results.map((item: any) => ({
        ...item,
        icon: 'i-ph-user',
        color: '#D9EAFD'
      }))
    ].sort((a: any, b: any) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())
      .slice(0, limit)

    return allActivities
  } catch (error) {
    console.error('Error fetching admin activity:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to fetch recent activity'
    })
  }
})
