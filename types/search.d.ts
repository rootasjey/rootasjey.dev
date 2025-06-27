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
