export type CreateProjectType = {
  category: string
  description: string
  name: string
}

export type ProjectType = {
  category: string
  company: string
  content?: object
  created_at: string
  description: string
  id: string
  image: {
    alt: string
    src: string
  }
  isDeleteDialogOpen?: boolean
  links: ProjectLinkType[] & never[]
  name: string
  post?: string
  slug: string
  updated_at: string
  user_id: string
  visibility: string
}

export type ProjectLinkType = {
  href: string
  name: string
}
