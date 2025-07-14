// DELETE /api/experiments/paired/admin/topic/[id]
// Delete a topic from the Paired memory game

export default defineEventHandler(async (event) => {
  const user = await requireUserSession(event)
  if (user.user?.role !== 'admin') {
    throw createError({
      statusCode: 403,
      statusMessage: 'Admin access required'
    })
  }

  const topicId = getRouterParam(event, 'id')
  
  if (!topicId) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Topic ID is required'
    })
  }

  try {
    const existingTopic = await hubKV().get(`paired:topic:${topicId}`)
    
    if (!existingTopic) {
      throw createError({
        statusCode: 404,
        statusMessage: 'Topic not found'
      })
    }

    await hubKV().del(`paired:topic:${topicId}`)

    return {
      success: true,
      message: `Topic '${topicId}' deleted successfully`,
      topicId
    }
  } catch (error: any) {
    if (error.statusCode) {
      throw error
    }
    
    console.error('Error deleting topic:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to delete topic'
    })
  }
})
