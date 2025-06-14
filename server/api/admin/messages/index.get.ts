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

  const query = getQuery(event)
  const page = parseInt(query.page as string) || 1
  const limit = parseInt(query.limit as string) || 20
  const readFilter = query.read as string // 'true', 'false', or undefined for all
  const search = query.search as string || ''
  const offset = (page - 1) * limit

  try {
    let whereClause = ''
    const params: any[] = []

    // Build WHERE clause for filtering
    const conditions: string[] = []
    
    if (readFilter !== undefined) {
      conditions.push('read = ?')
      params.push(readFilter === 'true' ? 1 : 0)
    }

    if (search) {
      conditions.push('(sender_email LIKE ? OR subject LIKE ? OR message LIKE ?)')
      params.push(`%${search}%`, `%${search}%`, `%${search}%`)
    }

    if (conditions.length > 0) {
      whereClause = 'WHERE ' + conditions.join(' AND ')
    }

    // Get total count for pagination
    const countQuery = `SELECT COUNT(*) as total FROM messages ${whereClause}`
    const countResult = await hubDatabase().prepare(countQuery).bind(...params).first()
    const total = countResult?.total as number || 0

    // Get messages with pagination
    const messagesQuery = `
      SELECT 
        id,
        sender_email,
        subject,
        message,
        read,
        created_at,
        updated_at
      FROM messages 
      ${whereClause}
      ORDER BY created_at DESC
      LIMIT ? OFFSET ?
    `
    
    const messages = await hubDatabase()
      .prepare(messagesQuery)
      .bind(...params, limit, offset)
      .all()

    return {
      success: true,
      data: {
        messages: messages.results as unknown as Message[],
        pagination: {
          page,
          limit,
          total,
          totalPages: Math.ceil(total / limit),
          hasNext: page * limit < total,
          hasPrev: page > 1
        }
      }
    }
  } catch (error) {
    console.error('Error fetching messages:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to fetch messages'
    })
  }
})