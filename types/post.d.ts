import type { ApiTag, Tag } from "./tag"

export type PostType = {
  /** Post article in JSON format. */
  article?: object
  /** Blob path to the article. */
  blob_path?: string
  /** True if the user is the author of the post. */
  canEdit?: boolean
  created_at: string
  description: string
  id: number
  isDeleteDialogOpen?: boolean
  image: {
    alt: string
    ext: string
    src: string
  }
  image_alt?: string
  image_ext?: string
  image_src?: string
  language: string
  styles?: {
    meta?: {
      align: 'start' | 'center'
    }
  }
  links: PostLink[]
  metrics: {
    comments: number
    likes: number
    views: number
  }
  metrics_comments?: number
  metrics_likes?: number
  metrics_views?: number
  name: string
  /** Computed property: first tag as primary tag */
  primaryTag?: ApiTag
  published_at?: string
  /** Computed property: remaining tags after primary */
  secondaryTags?: ApiTag[]
  slug: string
  status: 'draft' | 'published' | 'archived'
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

export type PostLink = {
  href: string
  name: string
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

interface UpdatePostPayload {
  description: string
  id: number
  name: string
  slug?: string
  status?: 'draft' | 'published' | 'archived'
  tags?: Tag[]
}

