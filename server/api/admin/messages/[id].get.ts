// GET /api/admin/messages

import { Message } from "~/types/message"

export default eventHandler(async (event) => {
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

  const messageId = getRouterParam(event, 'id')
  
  if (!messageId || isNaN(parseInt(messageId))) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Valid message ID required'
    })
  }

  try {
    const message = await hubDatabase()
      .prepare(`
        SELECT 
          id,
          sender_email,
          subject,
          message,
          read,
          created_at,
          updated_at
        FROM messages 
        WHERE id = ?
      `)
      .bind(parseInt(messageId))
      .first()

    if (!message) {
      throw createError({
        statusCode: 404,
        statusMessage: 'Message not found'
      })
    }

    return {
      success: true,
      data: message as unknown as Message,
    }
  } catch (error: any) {
    if (error.statusCode) {
      throw error
    }
    
    console.error('Error fetching message:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to fetch message'
    })
  }
})