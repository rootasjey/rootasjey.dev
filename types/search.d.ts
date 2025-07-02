export type SearchResult = {
  id: number
  name: string
  description: string
  tags: string[]
  slug: string
  created_at: string
  updated_at: string
  type: "post" | "project" | "experiment"
}

export type ExperimentSearchResult = Experiment & {
  created_at: string
  tags: string[]
  type: "experiment"
  updated_at: string
}
export type ProjectSearchResult = Project & { type: "project" }
export type PostSearchResult = Post & { type: "post" }

export type ApiSearchResult = PostSearchResult | ProjectSearchResult | ExperimentSearchResult
