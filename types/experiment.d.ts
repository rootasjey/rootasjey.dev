export type ExperimentType = {
  id: number
  name: string
  description: string
  slug: string
}

export type ExperimentSearchType = {
  id: string
  name: string
  description: string
  tags: string[]
  slug: string
  created_at: string
  updated_at: string
  type: "experiment"
}