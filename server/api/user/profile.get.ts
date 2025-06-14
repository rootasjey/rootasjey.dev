import { User } from "#auth-utils"

export default eventHandler(async (event) => {
  try {
    // Check authentication
    const session = await requireUserSession(event)
    if (!session.user?.id) {
      throw createError({
        statusCode: 401,
        statusMessage: 'Authentication required'
      })
    }

    const userId = session.user.id

    // Fetch user profile data
    const db = hubDatabase()
    const userRecord = await db.prepare(`
      SELECT id, name, email, biography, job, location, language, socials, created_at, updated_at
      FROM users 
      WHERE id = ?
    `).bind(userId).run()

    if (!userRecord.success) {
      throw createError({
        statusCode: 404,
        statusMessage: 'User not found'
      })
    }

    const user = userRecord.results[0] as unknown as User

    return {
      success: true,
      data: user
    }

  } catch (error: any) {
    if (error.statusCode) {
      throw error
    }

    console.error('Error fetching user profile:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Internal server error'
    })
  }
})