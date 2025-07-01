export type Experiment = {
  id: number
  name: string
  description: string
  slug: string
}

export type ExperimentSearchResult = {
  id: string
  name: string
  description: string
  tags: string[]
  slug: string
  created_at: string
  updated_at: string
  type: "experiment"
}