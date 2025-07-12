// GET /api/admin/tags/with-usage

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
    // Get all tags with usage counts
    const tagsWithUsage = await db.prepare(`
      SELECT 
        t.*,
        COALESCE(post_usage.count, 0) + COALESCE(project_usage.count, 0) as count,
        CASE 
          WHEN COALESCE(post_usage.count, 0) + COALESCE(project_usage.count, 0) > 0 
          THEN 1 
          ELSE 0 
        END as isUsed
      FROM tags t
      LEFT JOIN (
        SELECT tag_id, COUNT(*) as count
        FROM post_tags
        GROUP BY tag_id
      ) post_usage ON t.id = post_usage.tag_id
      LEFT JOIN (
        SELECT tag_id, COUNT(*) as count
        FROM project_tags
        GROUP BY tag_id
      ) project_usage ON t.id = project_usage.tag_id
      ORDER BY count DESC, t.name ASC
    `).all()

    // Get statistics
    const statsQuery = await db.prepare(`
      SELECT 
        COUNT(DISTINCT t.id) as total,
        COUNT(DISTINCT CASE WHEN pt.tag_id IS NOT NULL OR prt.tag_id IS NOT NULL THEN t.id END) as used,
        COUNT(DISTINCT CASE WHEN pt.tag_id IS NULL AND prt.tag_id IS NULL THEN t.id END) as unused,
        COUNT(DISTINCT t.category) as categories
      FROM tags t
      LEFT JOIN post_tags pt ON t.id = pt.tag_id
      LEFT JOIN project_tags prt ON t.id = prt.tag_id
    `).first()

    if (!statsQuery) {
      throw createError({
        statusCode: 500,
        statusMessage: 'Failed to fetch tag statistics'
      })
    }

    return {
      tags: tagsWithUsage.results || [],
      stats: {
        total: statsQuery.total || 0,
        used: statsQuery.used || 0,
        unused: statsQuery.unused || 0,
        categories: statsQuery.categories || 0
      }
    }
  } catch (error: any) {
    console.error('Error fetching tags with usage:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to fetch tags with usage data'
    })
  }
})
