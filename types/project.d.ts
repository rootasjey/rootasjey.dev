export type CreateProjectType = {
  company?: string
  description?: string
  name: string
  tags?: string[]
  status?: 'active' | 'completed' | 'archived' | 'on-hold'
}

export type ProjectType = {
  article?: object
  /** Blob path to the article. */
  blob_path: string
  company: string
  created_at: string
  description: string
  id: string
  image: {
    alt: string
    ext: string
    src: string
  }
  image_alt?: string
  image_ext?: string
  image_src?: string
  isDeleteDialogOpen?: boolean
  links: ProjectLinkType[] & never[]
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
  primaryTag?: string
  /** Computed property: remaining tags after primary */
  secondaryTags?: string[]
  slug: string
  status: 'active' | 'completed' | 'archived' | 'on-hold'
  tags: string[]
  updated_at: string
  user_id: number
  user?: {
    avatar?: string
    name?: string
  }
  user_avatar?: string
  user_name?: string
}

export type ProjectLinkType = {
  href: string
  name: string
}
