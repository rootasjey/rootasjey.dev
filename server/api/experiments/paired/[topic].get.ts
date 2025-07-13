// GET /api/experiments/paired/[topic]
// Get card pairs for a specific topic

import { TopicData } from "~/types/paired"

export default defineEventHandler(async (event) => {
  const topic = getRouterParam(event, 'topic')
  
  if (!topic) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Topic parameter is required'
    })
  }
  
  try {
    // Get topic data from KV storage
    const topicData = await hubKV().get(`paired:topic:${topic}`) as TopicData | null
    
    if (!topicData) {
      throw createError({
        statusCode: 404,
        statusMessage: 'Topic not found'
      })
    }
    
    return {
      success: true,
      topic: {
        id: topic,
        name: topicData.name,
        description: topicData.description,
        difficulty: topicData.difficulty,
        icon: topicData.icon,
        cardPairs: topicData.cardPairs
      }
    }
  } catch (error: any) {
    if (error.statusCode) {
      throw error
    }
    
    console.error('Error fetching topic data:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to fetch topic data'
    })
  }
})
