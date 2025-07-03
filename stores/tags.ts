import { defineStore } from 'pinia'
import type { ApiTag } from '~/types/tag'

export const useTagsStore = defineStore('tags', () => {
  // State
  const tags = ref<ApiTag[]>([])
  const isLoading = ref(false)
  const error = ref<string | null>(null)
  const lastFetchTime = ref<Date | null>(null)

  // Cache management (5 minutes)
  const cacheTimeout = 5 * 60 * 1000
  const isCacheValid = computed(() => {
    if (!lastFetchTime.value) return false
    return Date.now() - lastFetchTime.value.getTime() < cacheTimeout
  })

  // Getters
  const allTags = computed(() => tags.value)
  const tagsByCategory = computed(() => {
    const grouped: Record<string, ApiTag[]> = {}
    tags.value.forEach(tag => {
      const category = tag.category || 'general'
      if (!grouped[category]) grouped[category] = []
      grouped[category].push(tag)
    })
    return grouped
  })

  // Actions
  const fetchTags = async (force = false) => {
    // Return cached data if valid and not forced
    if (!force && isCacheValid.value && tags.value.length > 0) {
      return tags.value
    }

    isLoading.value = true
    error.value = null
    
    try {
      const fetchedTags = await $fetch<ApiTag[]>('/api/tags')
      tags.value = fetchedTags
      lastFetchTime.value = new Date()
      error.value = null
      return fetchedTags
    } catch (e: any) {
      error.value = e?.message || 'Failed to load tags'
      throw e
    } finally {
      isLoading.value = false
    }
  }

  const createTag = async (name: string, category = 'general') => {
    try {
      const tag = await $fetch<ApiTag | null>('/api/tags', {
        method: 'POST',
        body: { name, category }
      })
      
      if (tag) {
        // Add to local state
        tags.value.push(tag)
        // Update cache timestamp
        lastFetchTime.value = new Date()
      }
      
      return tag
    } catch (e: any) {
      error.value = e?.message || 'Failed to create tag'
      throw e
    }
  }

  const updateTag = async (id: number, name: string, category = 'general') => {
    try {
      const tag = await $fetch<ApiTag | null>(`/api/tags/${id}`, {
        method: 'PUT',
        body: { name, category }
      })
      
      if (tag) {
        // Update local state
        const idx = tags.value.findIndex((t: ApiTag) => t.id === id)
        if (idx !== -1) {
          tags.value[idx] = tag
        }
        // Update cache timestamp
        lastFetchTime.value = new Date()
      }
      
      return tag
    } catch (e: any) {
      error.value = e?.message || 'Failed to update tag'
      throw e
    }
  }

  const deleteTag = async (id: number) => {
    try {
      await $fetch(`/api/tags/${id}`, { method: 'DELETE' })
      
      // Remove from local state
      tags.value = tags.value.filter((t: ApiTag) => t.id !== id)
      // Update cache timestamp
      lastFetchTime.value = new Date()
    } catch (e: any) {
      error.value = e?.message || 'Failed to delete tag'
      throw e
    }
  }

  // Project-related tag operations
  const fetchProjectTags = async (projectId: number) => {
    try {
      return await $fetch<ApiTag[]>(`/api/projects/${projectId}/tags`)
    } catch (e: any) {
      error.value = e?.message || 'Failed to fetch project tags'
      throw e
    }
  }

  const assignProjectTags = async (projectId: number, tagIds: number[]) => {
    try {
      return await $fetch<ApiTag[]>(`/api/projects/${projectId}/tags`, {
        method: 'POST',
        body: { tagIds }
      })
    } catch (e: any) {
      error.value = e?.message || 'Failed to assign project tags'
      throw e
    }
  }

  // Post-related tag operations
  const fetchPostTags = async (postId: number) => {
    try {
      return await $fetch<ApiTag[]>(`/api/posts/${postId}/tags`)
    } catch (e: any) {
      error.value = e?.message || 'Failed to fetch post tags'
      throw e
    }
  }

  const assignPostTags = async (postId: number, tagIds: number[]) => {
    try {
      return await $fetch<ApiTag[]>(`/api/posts/${postId}/tags`, {
        method: 'POST',
        body: { tagIds }
      })
    } catch (e: any) {
      error.value = e?.message || 'Failed to assign post tags'
      throw e
    }
  }

  // Utility methods
  const findTagById = (id: number) => {
    return tags.value.find(tag => tag.id === id)
  }

  const findTagByName = (name: string) => {
    return tags.value.find(tag => tag.name.toLowerCase() === name.toLowerCase())
  }

  const searchTags = (query: string) => {
    if (!query.trim()) return tags.value
    const normalizedQuery = query.toLowerCase()
    return tags.value.filter(tag => 
      tag.name.toLowerCase().includes(normalizedQuery) ||
      tag.category.toLowerCase().includes(normalizedQuery)
    )
  }

  // Clear cache (useful for testing or manual refresh)
  const clearCache = () => {
    lastFetchTime.value = null
    error.value = null
  }

  // Initialize store (fetch tags on first access)
  const initialize = async () => {
    if (tags.value.length === 0 && !isLoading.value) {
      await fetchTags()
    }
  }

  return {
    // State
    tags: readonly(tags),
    isLoading: readonly(isLoading),
    error: readonly(error),
    lastFetchTime: readonly(lastFetchTime),
    
    // Getters
    allTags,
    tagsByCategory,
    isCacheValid,
    
    // Actions
    fetchTags,
    createTag,
    updateTag,
    deleteTag,
    fetchProjectTags,
    assignProjectTags,
    fetchPostTags,
    assignPostTags,
    
    // Utilities
    findTagById,
    findTagByName,
    searchTags,
    clearCache,
    initialize
  }
})
