export type CreateProjectType = {
  company?: string
  description?: string
  name: string
  tags?: string[]
  visibility?: "public" | "private"
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
  name: string
  post?: string
  /** Computed property: first tag as primary tag */
  primaryTag?: string
  /** Computed property: remaining tags after primary */
  secondaryTags?: string[]
  slug: string
  tags: string[]
  updated_at: string
  user_id: number
  visibility: string
}

export type ProjectLinkType = {
  href: string
  name: string
}
