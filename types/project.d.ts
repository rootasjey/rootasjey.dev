export type CreateProjectType = {
  category: string
  description: string
  name: string
}

export type ProjectType = {
  article?: object
  /** Blob path to the article. */
  blob_path: string
  category: string
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
  slug: string
  technologies: string[]
  updated_at: string
  user_id: number
  visibility: string
}

export type ProjectLinkType = {
  href: string
  name: string
}
