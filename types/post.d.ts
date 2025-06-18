export type CreatePostType = {
  category: string
  description: string
  name: string
  visibility?: 'public' | 'private' | 'archive'
  tags?: string[]
}

export type PostType = {
  /** Post article in JSON format. */
  article?: object
  /** Blob path to the article. */
  blob_path?: string
  /** True if the user is the author of the post. */
  canEdit?: boolean
  created_at: string
  description: string
  category: string
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
  links: PostLinkType[]
  metrics: {
    comments: number
    likes: number
    views: number
  }
  name: string
  slug: string
  tags: string[]
  updated_at: string
  user_id: number
  visibility: 'public' | 'private' | 'archive'
}

export type PostLinkType = {
  href: string
  name: string
}
