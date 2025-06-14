// POST /api/admin/messages/bulk

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

  const body = await readBody(event)
  const { action, messageIds } = body

  if (!action || !Array.isArray(messageIds) || messageIds.length === 0) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Action and message IDs are required'
    })
  }

  if (!['mark_read', 'mark_unread', 'delete'].includes(action)) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Invalid action. Must be mark_read, mark_unread, or delete'
    })
  }

  // Validate all IDs are numbers
  const validIds = messageIds.filter(id => !isNaN(parseInt(id))).map(id => parseInt(id))
  if (validIds.length !== messageIds.length) {
    throw createError({
      statusCode: 400,
      statusMessage: 'All message IDs must be valid numbers'
    })
  }

  try {
    const placeholders = validIds.map(() => '?').join(',')
    
    if (action === 'delete') {
      await hubDatabase()
        .prepare(`DELETE FROM messages WHERE id IN (${placeholders})`)
        .bind(...validIds)
        .run()
    } else {
      const readValue = action === 'mark_read' ? 1 : 0
      await hubDatabase()
        .prepare(`UPDATE messages SET read = ?, updated_at = CURRENT_TIMESTAMP WHERE id IN (${placeholders})`)
        .bind(readValue, ...validIds)
        .run()
    }

    return {
      success: true,
      message: `Successfully processed ${validIds.length} messages`,
      processedCount: validIds.length,
      processedIds: validIds,
    }
  } catch (error) {
    console.error('Error processing bulk operation:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to process bulk operation'
    })
  }
})