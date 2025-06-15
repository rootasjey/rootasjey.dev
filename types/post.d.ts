export type CreatePostType = {
  category: string
  description: string
  name: string
}

export type PostType = {
  author: RecordId
  /** True if the user is the author of the post. */
  canEdit: boolean
  /** Post article in JSON format. */
  article?: object
  created_at: string
  description: string
  category: string
  id: string | RecordId
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
  user_id: number
  visibility: string
}

export type PostLinkType = {
  href: string
  name: string
}
