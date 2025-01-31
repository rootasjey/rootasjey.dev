export type CreatePostType = {
  category: string
  description: string
  name: string
}

export type PostType = {
  authors: string[]
  /** True if the user is the author of the post. */
  canEdit: boolean
  /** Post content in JSON format. */
  content?: string
  created_at: string
  description: string
  category: string
  id: string
  isDeleteDialogOpen?: boolean
  image: {
    alt: string
    src: string
  }
  language: string
  styles?: {
    meta?: {
      align: 'start' | 'center'
    }
  }
  links: PostLinkType[] & never[]
  metrics: {
    comments: number
    likes: number
    views: number
  }
  name: string
  slug: string
  tags: string[]
  updated_at: string
  user_id: string
  visibility: string
}

export type PostLinkType = {
  href: string
  name: string
}
