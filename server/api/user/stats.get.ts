// GET /api/user/stats
import data from "~/server/api/experiments/data.json"

export default eventHandler(async (event) => {
  const session = await requireUserSession(event)

  try {
    const db = await hubDatabase()
    
    // Get total post count
    const totalPostResult: { count: number } | null = await db
      .prepare('SELECT COUNT(*) as count FROM posts WHERE user_id = ?')
      .bind(session.user.id)
      .first()
    
    // Get total projects count
    const totalProjectResult: { count: number } | null = await db
      .prepare('SELECT COUNT(*) as count FROM projects WHERE user_id = ?')
      .bind(session.user.id)
      .first()

    return {
      data: {
        totalPosts: totalPostResult?.count || 0,
        totalProjects: totalProjectResult?.count || 0,
        totalExperiments: data.length || 0,
      },
    }
  } catch (error) {
    console.error('Error fetching user stats:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to fetch user statistics'
    })
  }
})