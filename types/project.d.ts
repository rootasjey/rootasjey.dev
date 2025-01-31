export type CreateProjectType = {
  category: string
  description: string
  name: string
}

export type ProjectType = {
  category: string
  company: string
  created_at: string
  description: string
  has_post: boolean
  id: string
  isDeleteDialogOpen?: boolean
  links: ProjectLinkType[] & never[]
  name: string
  post_id?: string
  slug: string
  updated_at: string
  user_id: string
  visibility: string
}

export type ProjectLinkType = {
  href: string
  name: string
}
