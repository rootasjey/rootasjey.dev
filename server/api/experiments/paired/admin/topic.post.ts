// POST /api/experiments/paired/admin/topic
// Add or update a topic with card pairs

export default defineEventHandler(async (event) => {
  const user = await requireUserSession(event)
  if (user.user?.role !== 'admin') {
    throw createError({
      statusCode: 403,
      statusMessage: 'Admin access required'
    })
  }

  const body = await readBody(event)
  
  // Validate required fields
  if (!body.id || !body.name || !body.cardPairs) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Missing required fields: id, name, cardPairs'
    })
  }

  // Validate card pairs structure
  if (!Array.isArray(body.cardPairs) || body.cardPairs.length === 0) {
    throw createError({
      statusCode: 400,
      statusMessage: 'cardPairs must be a non-empty array'
    })
  }

  // Validate each card pair
  for (const pair of body.cardPairs) {
    if (!pair.pair1 || !pair.pair2 || !pair.fact) {
      throw createError({
        statusCode: 400,
        statusMessage: 'Each card pair must have pair1, pair2, and fact properties'
      })
    }
    
    if (!pair.pair1.text || !pair.pair1.icon || !pair.pair2.text || !pair.pair2.icon) {
      throw createError({
        statusCode: 400,
        statusMessage: 'Each pair must have text and icon properties'
      })
    }
  }

  try {
    const topicData = {
      name: body.name,
      description: body.description || '',
      difficulty: body.difficulty || 'medium',
      icon: body.icon || 'i-ph-cards',
      cardPairs: body.cardPairs,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    }

    // Store in KV
    await hubKV().set(`paired:topic:${body.id}`, topicData)

    return {
      success: true,
      message: `Topic '${body.name}' saved successfully`,
      topic: {
        id: body.id,
        ...topicData
      }
    }
  } catch (error) {
    console.error('Error saving topic:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to save topic'
    })
  }
})
