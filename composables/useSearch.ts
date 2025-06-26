import { ref } from "vue"

type SearchResult = {
  id: number
  name: string
  description: string
  tags: string[]
  slug: string
  created_at: string
  updated_at: string
  type: "post" | "project"
}

export function useSearch() {
  const results = ref<SearchResult[]>([])
  const total = ref(0)
  const loading = ref(false)
  const error = ref<string | null>(null)

  async function search(query: string) {
    if (!query.trim()) {
      results.value = []
      total.value = 0
      return
    }
    loading.value = true
    error.value = null
    try {
      const { data, error: fetchError } = await useFetch("/api/search", {
        params: { q: query },
      })
      if (fetchError.value) throw fetchError.value
      results.value = data.value?.results || []
      total.value = data.value?.total || 0
    } catch (err: any) {
      error.value = err.message || "Search failed"
    } finally {
      loading.value = false
    }
  }

  return { results, total, loading, error, search }
}
