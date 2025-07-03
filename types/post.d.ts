import type { ApiTag, Tag } from "./tag"

/**
 * Post structure used in the application.
 * This type is used for displaying posts in the UI.
 */
export type Post = {
  /** Post article in JSON format. */
  article?: object
  /** Blob path to the article. */
  blobPath?: string
  /** True if the user is the author of the post. */
  canEdit?: boolean
  createdAt: string
  description: string
  id: number
  image: {
    alt: string
    ext: string
    src: string
  }
  isDeleteDialogOpen?: boolean
  language: string
  links: PostLink[]
  metrics: {
    comments: number
    likes: number
    views: number
  }
  name: string
  publishedAt?: string
  slug: string
  status: 'draft' | 'published' | 'archived'
  tags: ApiTag[]
  updatedAt: string
  user?: {
    id?: number
    avatar?: string
    name?: string
  }
}

export type PostLink = {
  href: string
  name: string
}

/**
 * Post structure used in the API and database.
 */
export type ApiPost = {
  id: number
  blob_path: string | null
  created_at: string
  description: string | null
  image_alt: string | null
  image_ext: string | null
  image_src: string | null
  language: 'en' | 'fr' | 'es' | 'de' | 'it'
  links: string // JSON string in DB
  metrics_comments: number
  metrics_likes: number
  metrics_views: number
  name: string
  published_at: string | null
  slug: string
  status: 'draft' | 'published' | 'archived'
  updated_at: string
  user_id: number
}

// ------
// Payload types for creating and updating posts
// ------

export type CreatePostPayload = {
  description: string
  name: string
  status?: 'draft' | 'published' | 'archived'
  tags?: Tag[]
}

export type UpdatePostPayload = {
  description: string
  id: number
  name: string
  slug?: string
  status?: 'draft' | 'published' | 'archived'
  tags?: Tag[]
}

