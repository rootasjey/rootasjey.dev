import { ref } from 'vue'
import type { ApiTag } from '~/types/post'

export function useApiTags() {
  const tags = ref<ApiTag[]>([])
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  // Fetch all tags
  const fetchTags = async () => {
    isLoading.value = true
    try {
      tags.value = await $fetch<ApiTag[]>('/api/tags')
      error.value = null
    } catch (e) {
      error.value = 'Failed to load tags'
    } finally {
      isLoading.value = false
    }
  }

  // Create a tag
  const createTag = async (name: string, category = 'general') => {
    try {
      const tag = await $fetch<ApiTag | null>('/api/tags', {
        method: 'POST',
        body: { name, category }
      })
      if (tag) tags.value.push(tag)
      return tag
    } catch (e: any) {
      throw e
    }
  }

  // Update a tag
  const updateTag = async (id: number, name: string, category = 'general') => {
    try {
      const tag = await $fetch<ApiTag | null>(`/api/tags/${id}`, {
        method: 'PUT',
        body: { name, category }
      })
      if (tag) {
        const idx = tags.value.findIndex((t: ApiTag) => t.id === id)
        if (idx !== -1) tags.value[idx] = tag
      }
      return tag
    } catch (e: any) {
      throw e
    }
  }

  // Delete a tag
  const deleteTag = async (id: number) => {
    try {
      await $fetch(`/api/tags/${id}`, { method: 'DELETE' })
      tags.value = tags.value.filter((t: ApiTag) => t.id !== id)
    } catch (e: any) {
      throw e
    }
  }

  // Get tags for a project
  const fetchProjectTags = async (projectId: number) => {
    return await $fetch<ApiTag[]>(`/api/projects/${projectId}/tags`)
  }

  // Assign tags to a project
  const assignProjectTags = async (projectId: number, tagIds: number[]) => {
    return await $fetch<ApiTag[]>(`/api/projects/${projectId}/tags`, {
      method: 'POST',
      body: { tagIds }
    })
  }

  // Get tags for a post
  const fetchPostTags = async (postId: number) => {
    return await $fetch<ApiTag[]>(`/api/posts/${postId}/tags`)
  }

  // Assign tags to a post
  const assignPostTags = async (postId: number, tagIds: number[]) => {
    return await $fetch<ApiTag[]>(`/api/posts/${postId}/tags`, {
      method: 'POST',
      body: { tagIds }
    })
  }

  return {
    tags,
    isLoading,
    error,
    fetchTags,
    createTag,
    updateTag,
    deleteTag,
    fetchProjectTags,
    assignProjectTags,
    fetchPostTags,
    assignPostTags
  }
}
