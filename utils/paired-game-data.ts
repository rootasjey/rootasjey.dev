// Utility functions for managing Paired game data

import type { CardPair, TopicData } from "~/types/paired"

/**
 * Validates a topic data structure
 */
export function validateTopicData(data: any): data is TopicData {
  if (!data || typeof data !== 'object') return false
  
  const required = ['name', 'description', 'difficulty', 'icon', 'cardPairs']
  for (const field of required) {
    if (!(field in data)) return false
  }
  
  if (!Array.isArray(data.cardPairs) || data.cardPairs.length === 0) return false
  
  for (const pair of data.cardPairs) {
    if (!pair.pair1 || !pair.pair2 || !pair.fact) return false
    if (!pair.pair1.text || !pair.pair1.icon || !pair.pair2.text || !pair.pair2.icon) return false
  }
  
  return true
}

/**
 * Creates a new topic data structure
 */
export function createTopicData(
  name: string,
  description: string,
  cardPairs: CardPair[],
  options: {
    difficulty?: 'easy' | 'medium' | 'hard'
    icon?: string
  } = {}
): TopicData {
  return {
    name,
    description,
    difficulty: options.difficulty || 'medium',
    icon: options.icon || 'i-ph-cards',
    cardPairs,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  }
}

/**
 * Generates a topic ID from a topic name
 */
export function generateTopicId(name: string): string {
  return name
    .toLowerCase()
    .replace(/[^a-z0-9\s-]/g, '')
    .replace(/\s+/g, '-')
    .replace(/-+/g, '-')
    .trim()
}

/**
 * Example topic data for reference
 */
export const exampleTopicData: TopicData = {
  name: "Example Topic",
  description: "An example topic for demonstration",
  difficulty: "medium",
  icon: "i-ph-lightbulb",
  cardPairs: [
    {
      pair1: { text: "Example 1", icon: "i-ph-star" },
      pair2: { text: "Match 1", icon: "i-ph-heart" },
      fact: "This is an example fact about the first pair."
    },
    {
      pair1: { text: "Example 2", icon: "i-ph-sun" },
      pair2: { text: "Match 2", icon: "i-ph-moon" },
      fact: "This is an example fact about the second pair."
    }
  ]
}

/**
 * Helper function to add a new topic via API
 */
export async function addTopicToGame(topicId: string, topicData: TopicData) {
  if (!validateTopicData(topicData)) {
    throw new Error('Invalid topic data structure')
  }
  
  const response = await $fetch('/api/experiments/paired/admin/topic', {
    method: 'POST',
    body: {
      id: topicId,
      ...topicData
    }
  })
  
  return response
}
