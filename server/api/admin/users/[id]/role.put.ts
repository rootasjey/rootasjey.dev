// PUT /api/admin/users/[id]/role

import { z } from 'zod'

const roleSchema = z.object({
  role: z.enum(['user', 'admin', 'moderator'])
})

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

  const userId = getRouterParam(event, 'id')
  if (!userId || isNaN(parseInt(userId))) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Valid user ID required'
    })
  }

  const body = await readValidatedBody(event, roleSchema.parse)
  const { role } = body

  // Prevent admin from changing their own role
  if (parseInt(userId) === session.user.id) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Cannot change your own role'
    })
  }

  const db = hubDatabase()

  try {
    // Check if user exists
    const user = await db.prepare('SELECT * FROM users WHERE id = ?').bind(userId).first()
    if (!user) {
      throw createError({
        statusCode: 404,
        statusMessage: 'User not found'
      })
    }

    // Update user role
    const result = await db.prepare(`
      UPDATE users 
      SET role = ?, updated_at = CURRENT_TIMESTAMP 
      WHERE id = ?
    `).bind(role, userId).run()

    if (!result.success) {
      throw createError({
        statusCode: 500,
        statusMessage: 'Failed to update user role'
      })
    }

    // Fetch updated user
    const updatedUser = await db.prepare(`
      SELECT id, name, email, role, created_at, updated_at
      FROM users 
      WHERE id = ?
    `).bind(userId).first()

    return {
      success: true,
      user: updatedUser,
      message: `User role updated to ${role}`
    }
  } catch (error: any) {
    if (error.statusCode) {
      throw error
    }
    console.error('Error updating user role:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to update user role'
    })
  }
})
