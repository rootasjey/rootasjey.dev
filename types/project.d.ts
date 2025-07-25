import type { ApiTag, Tag } from './tag'

export type Project = {
  article?: object
  /** Blob path to the article. */
  blobPath: string
  company: string
  createdAt: string
  description: string
  endDate?: string
  id: number
  image: {
    alt: string
    ext: string
    src: string
  }
  links: ProjectLink[] & never[]
  metrics?: {
    comments: number
    likes: number
    views: number
  }
  name: string
  slug: string
  startDate?: string
  status: 'active' | 'completed' | 'archived' | 'on-hold'
  tags: ApiTag[]
  updated_at: string
  user?: {
    id: number
    avatar?: string
    name?: string
  }
}

export type ProjectLink = {
  href: string
  name: string
}

/**
 * Project structure used in the API and database.
 */
export type ApiProject = {
  id: number
  blob_path?: string
  company?: string
  created_at: string
  description?: string
  end_date?: string
  image_alt?: string
  image_ext?: string
  image_src?: string
  links: string // JSON string in DB
  metrics_comments: number
  metrics_likes: number
  metrics_views: number
  name: string
  slug: string
  start_date?: string
  status: 'active' | 'completed' | 'archived' | 'on-hold'
  updated_at: string
  user_id: number
  user_avatar?: string
  user_name?: string
}

// ------
// Payload types for creating and updating projects
// ------

export type CreateProjectPayload = {
  company?: string
  description?: string
  name: string
  tags?: Tag[]
  status?: 'active' | 'completed' | 'archived' | 'on-hold'
}

export type UpdateProjectPayload = {
  company?: string
  description?: string
  endDate?: string
  id: number
  name?: string
  slug?: string
  startDate?: string
  status?: 'active' | 'completed' | 'archived' | 'on-hold'
  tags?: Tag[]
}
