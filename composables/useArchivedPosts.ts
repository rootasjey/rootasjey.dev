import type { Post } from '~/types/post'

interface UseArchivedPostsOptions {
  autoFetch?: boolean
  /** Disable the composable if the user is not logged in. */
  disabled?: boolean
}

export const useArchivedPosts = (options: UseArchivedPostsOptions = {}) => {
  const {
    autoFetch = false,
    disabled = false,
  } = options

  // State
  const list = ref<Post[]>([])
  const isFetchingArchived = ref(false)
  const archivedError = ref<string | null>(null)
  const lastFetchTime = ref<Date | null>(null)

  // Cache management
  const cacheTimeout = 1 * 60 * 1000 // 1 minutes
  const isArchivedCacheValid = computed(() => {
    if (!lastFetchTime.value) return false
    return Date.now() - lastFetchTime.value.getTime() < cacheTimeout
  })

  // Computed properties
  const archivedCount = computed(() => list.value.length)
  const hasArchived = computed(() => archivedCount.value > 0)

  // Archived posts fetching
  const fetchArchivedPosts = async (force = false) => {
    if (disabled) {
      console.warn('No user is logged in so the fetching of archived posts is skipped.')
      return list.value
    }

    // Skip if already fetching
    if (isFetchingArchived.value) return list.value

    // Skip if cache is valid and not forcing
    if (!force && isArchivedCacheValid.value) return list.value

    isFetchingArchived.value = true
    archivedError.value = null

    try {
      const data = await $fetch('/api/posts/archived')
      list.value = (data as Post[]) ?? []
      lastFetchTime.value = new Date()
      return list.value
    } catch (error) {
      console.error('Failed to fetch archived posts:', error)
      archivedError.value = 'Failed to load archived posts. Please try again.'
      throw error
    } finally {
      isFetchingArchived.value = false
    }
  }

  // Archived post management utilities
  const addArchivedPost = (post: Post) => {
    // Add to beginning of array (most recent first)
    list.value.unshift(post)
  }

  const updateArchivedPost = (postId: number, updates: Partial<Post>) => {
    const index = list.value.findIndex(p => p.id === postId)
    if (index !== -1) {
      list.value[index] = { ...list.value[index], ...updates }
    }
  }

  const removeArchivedPost = (postId: number) => {
    const index = list.value.findIndex(p => p.id === postId)
    if (index !== -1) {
      list.value.splice(index, 1)
    }
  }

  const findArchivedPostById = (postId: string | number): Post | undefined => {
    return list.value.find(p => p.id === postId)
  }

  // Move archived post to other status
  const moveArchivedPostTo = (postId: string | number, newStatus: 'draft' | 'published'): Post | null => {
    const index = list.value.findIndex(p => p.id === postId)
    if (index !== -1) {
      const [post] = list.value.splice(index, 1)
      return { ...post, status: newStatus }
    }
    return null
  }

  // Batch operations
  const clearAllArchived = () => {
    list.value = []
    lastFetchTime.value = null
  }

  const refreshArchived = async () => {
    return await fetchArchivedPosts(true)
  }

  // Archived post statistics
  const getArchivedStats = () => {
    const now = new Date()
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate())
    const thisWeek = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000)
    const thisMonth = new Date(now.getFullYear(), now.getMonth(), 1)

    return {
      total: archivedCount.value,
      archivedToday: list.value.filter(p => 
        new Date(p.updatedAt) >= today
      ).length,
      archivedThisWeek: list.value.filter(p => 
        new Date(p.updatedAt) >= thisWeek
      ).length,
      archivedThisMonth: list.value.filter(p => 
        new Date(p.updatedAt) >= thisMonth
      ).length,
      lastUpdated: list.value.length > 0 
        ? Math.max(...list.value.map(p => new Date(p.updatedAt).getTime()))
        : null
    }
  }

  // Auto-initialization
  const initializeArchived = async () => {
    // Auto-fetch if enabled
    if (autoFetch) {
      await fetchArchivedPosts()
    }
  }

  // Error handling
  const clearArchivedError = () => {
    archivedError.value = null
  }

  const retryFetchArchived = async () => {
    clearArchivedError()
    return await fetchArchivedPosts(true)
  }

  // Cleanup
  const cleanup = () => {
    clearAllArchived()
    clearArchivedError()
  }

  // Initialize on composable creation
  if (typeof window !== 'undefined') {
    initializeArchived()
  }

  return {
    // State (readonly)
    list,
    isFetchingArchived: readonly(isFetchingArchived),
    archivedError: readonly(archivedError),
    lastFetchTime: readonly(lastFetchTime),

    // Computed
    archivedCount,
    hasArchived,
    isArchivedCacheValid,

    // Archived post fetching
    fetchArchivedPosts,
    refreshArchived,
    retryFetchArchived,

    // Archived post management
    addArchivedPost,
    updateArchivedPost,
    removeArchivedPost,
    findArchivedPostById,
    moveArchivedPostTo,
    clearAllArchived,

    // Utilities
    getArchivedStats,
    clearArchivedError,
    initializeArchived,
    cleanup,
  }
}

// Type for the composable return value
export type ArchivedPostsComposable = ReturnType<typeof useArchivedPosts>
