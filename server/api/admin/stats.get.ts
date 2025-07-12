// GET /api/admin/stats

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

  try {
    // Get posts stats
    const postsStats = await db.prepare(`
      SELECT 
        COUNT(*) as total,
        SUM(CASE WHEN status = 'published' THEN 1 ELSE 0 END) as published,
        SUM(CASE WHEN status = 'draft' THEN 1 ELSE 0 END) as drafts,
        SUM(CASE WHEN status = 'archived' THEN 1 ELSE 0 END) as archived
      FROM posts
    `).first()

    // Get projects stats
    const projectsStats = await db.prepare(`
      SELECT
        COUNT(*) as total,
        SUM(CASE WHEN status != 'archived' THEN 1 ELSE 0 END) as active,
        SUM(CASE WHEN status = 'archived' THEN 1 ELSE 0 END) as archived
      FROM projects
    `).first()

    // Get tags stats
    const tagsStats = await db.prepare(`
      SELECT 
        COUNT(DISTINCT t.id) as total,
        COUNT(DISTINCT CASE WHEN pt.tag_id IS NOT NULL OR prt.tag_id IS NOT NULL THEN t.id END) as used,
        COUNT(DISTINCT CASE WHEN pt.tag_id IS NULL AND prt.tag_id IS NULL THEN t.id END) as unused
      FROM tags t
      LEFT JOIN post_tags pt ON t.id = pt.tag_id
      LEFT JOIN project_tags prt ON t.id = prt.tag_id
    `).first()

    // Get users stats
    const usersStats = await db.prepare(`
      SELECT 
        COUNT(*) as total,
        SUM(CASE WHEN role = 'admin' THEN 1 ELSE 0 END) as admins,
        SUM(CASE WHEN role = 'user' THEN 1 ELSE 0 END) as regular,
        SUM(CASE WHEN role = 'moderator' THEN 1 ELSE 0 END) as moderators
      FROM users
    `).first()

    return {
      posts: {
        total: Number(postsStats?.total) || 0,
        published: Number(postsStats?.published) || 0,
        drafts: Number(postsStats?.drafts) || 0,
        archived: Number(postsStats?.archived) || 0
      },
      projects: {
        total: Number(projectsStats?.total) || 0,
        active: Number(projectsStats?.active) || 0,
        archived: Number(projectsStats?.archived) || 0
      },
      tags: {
        total: Number(tagsStats?.total) || 0,
        used: Number(tagsStats?.used) || 0,
        unused: Number(tagsStats?.unused) || 0
      },
      users: {
        total: Number(usersStats?.total) || 0,
        admins: Number(usersStats?.admins) || 0,
        regular: Number(usersStats?.regular) || 0,
        moderators: Number(usersStats?.moderators) || 0
      }
    }
  } catch (error) {
    console.error('Error fetching admin stats:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to fetch admin statistics'
    })
  }
})
