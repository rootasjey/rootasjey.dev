import type { ApiTag, Tag } from './tag'

export type ProjectType = {
  article?: object
  /** Blob path to the article. */
  blob_path: string
  company: string
  created_at: string
  description: string
  end_date?: string
  id: number
  image: {
    alt: string
    ext: string
    src: string
  }
  image_alt?: string
  image_ext?: string
  image_src?: string
  isDeleteDialogOpen?: boolean
  links: ProjectLink[] & never[]
  metrics?: {
    comments: number
    likes: number
    views: number
  }
  metrics_comments?: number
  metrics_likes?: number
  metrics_views?: number
  name: string
  post?: string
  /** Computed property: first tag as primary tag */
  primaryTag?: ApiTag
  /** Computed property: remaining tags after primary */
  secondaryTags?: ApiTag[]
  slug: string
  start_date?: string
  status: 'active' | 'completed' | 'archived' | 'on-hold'
  tags: ApiTag[]
  updated_at: string
  user_id: number
  user?: {
    avatar?: string
    name?: string
  }
  user_avatar?: string
  user_name?: string
}

export type ProjectLink = {
  href: string
  name: string
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
