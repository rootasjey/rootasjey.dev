/**
 * Tag structure used in the API.
 * This is used in the API response and in the Post type.
 * It includes the tag's ID, name, category, and timestamps.
 */
export type ApiTag = {
  id: number
  name: string
  category: string
  created_at: string
  updated_at: string
}

/**
 * Tag structure used in the UI.
 * This is used in the Post type and in the UI components.
 * It includes the tag's name and an optional category.
 */
export type Tag = {
  name: string
  category?: string
}

export interface TagWithUsage extends ApiTag {
  count: number
  isUsed: boolean
}

export interface TagStats {
  total: number
  custom: number
}
