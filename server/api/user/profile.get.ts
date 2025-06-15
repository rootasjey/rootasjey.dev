import { User } from "#auth-utils"

export default eventHandler(async (event) => {
  try {
    const session = await requireUserSession(event)
    const userId = session.user.id

    const db = hubDatabase()
    const userRecord = await db
    .prepare(`
      SELECT id, name, email, biography, job, location, language, socials, created_at, updated_at
      FROM users 
      WHERE id = ?
    `)
    .bind(userId)
    .run()

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
    if (error.statusCode) { throw error }
    console.error('Error fetching user profile:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Internal server error'
    })
  }
})