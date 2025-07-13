// GET /api/experiments/paired/topics
// Get all available topics for the Paired memory game

import { TopicData } from "~/types/paired"

export default defineEventHandler(async (event) => {
  try {
    // Get all keys that start with 'paired:topic:'
    const keys = await hubKV().keys('paired:topic:')

    // Extract topic information from keys and get metadata
    const topics = await Promise.all(
      keys.map(async (key) => {
        const topicId = key.replace('paired:topic:', '')
        const topicData = await hubKV().get(key) as TopicData | null

        return {
          id: topicId,
          name: topicData?.name || topicId,
          description: topicData?.description || '',
          cardCount: topicData?.cardPairs?.length || 0,
          difficulty: topicData?.difficulty || 'medium',
          icon: topicData?.icon || 'i-ph-cards'
        }
      })
    )

    // Sort topics by name
    topics.sort((a, b) => a.name.localeCompare(b.name))

    return {
      success: true,
      topics
    }
  } catch (error) {
    console.error('Error fetching topics:', error)
    return {
      success: false,
      error: 'Failed to fetch topics',
      topics: []
    }
  }
})
