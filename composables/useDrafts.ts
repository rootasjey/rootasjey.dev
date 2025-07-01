import type { Post } from '~/types/post'

interface UseDraftsOptions {
  autoFetch?: boolean
  storageKey?: string
  /** Disable the composable if the user is not logged in. */
  disabled?: boolean
}

export const useDrafts = (options: UseDraftsOptions = {}) => {
  const { 
    autoFetch = false, 
    storageKey = 'show_drafts',
    disabled = false,
  } = options

  // State
  const showDrafts = ref(false)
  const list = ref<Post[]>([])
  const isFetchingDrafts = ref(false)
  const draftsError = ref<string | null>(null)
  const lastFetchTime = ref<Date | null>(null)

  // Cache management
  const cacheTimeout = 5 * 60 * 1000 // 5 minutes
  const isDraftsCacheValid = computed(() => {
    if (!lastFetchTime.value) return false
    return Date.now() - lastFetchTime.value.getTime() < cacheTimeout
  })

  // Computed properties
  const draftCount = computed(() => list.value.length)
  const hasDrafts = computed(() => draftCount.value > 0)
  const shouldShowDraftsSection = computed(() => showDrafts.value && hasDrafts.value)
  const isDraftsEmpty = computed(() => showDrafts.value && !hasDrafts.value && !isFetchingDrafts.value)

  // Draft status status for UI
  const draftsVisibilityStatus = computed(() => {
    if (!showDrafts.value) return 'hidden'
    if (isFetchingDrafts.value) return 'loading'
    if (hasDrafts.value) return 'visible'
    return 'empty'
  })

  // Storage management
  const loadDraftPreferences = () => {
    if (typeof window === 'undefined') return false
    
    try {
      const stored = localStorage.getItem(storageKey)
      return stored === 'true'
    } catch (error) {
      console.warn('Failed to load draft preferences from localStorage:', error)
      return false
    }
  }

  const saveDraftPreferences = (visible: boolean) => {
    if (typeof window === 'undefined') return
    
    try {
      localStorage.setItem(storageKey, visible.toString())
    } catch (error) {
      console.warn('Failed to save draft preferences to localStorage:', error)
    }
  }

  // Draft fetching
  const fetchDrafts = async (force = false) => {
    if (disabled) { 
      console.warn('No user is logged in so the fetching of drafts is skipped.')
      return list.value 
    }

    // Skip if already fetching
    if (isFetchingDrafts.value) return list.value

    // Skip if cache is valid and not forcing
    if (!force && isDraftsCacheValid.value) return list.value

    // Skip if drafts are hidden (unless forcing)
    if (!force && !showDrafts.value) return list.value

    isFetchingDrafts.value = true
    draftsError.value = null

    try {
      const data = await $fetch('/api/posts/drafts')
      list.value = (data as Post[]) ?? []
      lastFetchTime.value = new Date()
      return list.value
    } catch (error) {
      console.error('Failed to fetch drafts:', error)
      draftsError.value = 'Failed to load drafts. Please try again.'
      throw error
    } finally {
      isFetchingDrafts.value = false
    }
  }

  // Draft status management
  const toggleDrafts = async () => {
    const newStatus = !showDrafts.value
    showDrafts.value = newStatus
    saveDraftPreferences(newStatus)

    // Fetch drafts when showing them
    if (newStatus) {
      await fetchDrafts()
    }
  }

  const showDraftsSection = async () => {
    if (showDrafts.value) return
    
    showDrafts.value = true
    saveDraftPreferences(true)
    await fetchDrafts()
  }

  const hideDraftsSection = () => {
    showDrafts.value = false
    saveDraftPreferences(false)
  }

  // Draft management utilities
  const addDraft = (draft: Post) => {
    // Add to beginning of array (most recent first)
    list.value.unshift(draft)
  }

  const updateDraft = (draftId: number, updates: Partial<Post>) => {
    const index = list.value.findIndex(d => d.id === draftId)
    if (index !== -1) {
      list.value[index] = { ...list.value[index], ...updates }
    }
  }

  const removeDraft = (draftId: number) => {
    const index = list.value.findIndex(d => d.id === draftId)
    if (index !== -1) {
      list.value.splice(index, 1)
    }
  }

  const findDraftById = (draftId: string | number): Post | undefined => {
    return list.value.find(d => d.id === draftId)
  }

  // Move draft to published (when publishing)
  const moveDraftToPublished = (draftId: string | number): Post | null => {
    const index = list.value.findIndex(d => d.id === draftId)
    if (index !== -1) {
      const [draft] = list.value.splice(index, 1)
      return { ...draft, status: 'published' }
    }
    return null
  }

  // Batch operations
  const clearAllDrafts = () => {
    list.value = []
    lastFetchTime.value = null
  }

  const refreshDrafts = async () => {
    return await fetchDrafts(true)
  }

  // Draft statistics
  const getDraftStats = () => {
    const now = new Date()
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate())
    const thisWeek = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000)
    const thisMonth = new Date(now.getFullYear(), now.getMonth(), 1)

    return {
      total: draftCount.value,
      createdToday: list.value.filter(d => 
        new Date(d.createdAt) >= today
      ).length,
      createdThisWeek: list.value.filter(d => 
        new Date(d.createdAt) >= thisWeek
      ).length,
      createdThisMonth: list.value.filter(d => 
        new Date(d.createdAt) >= thisMonth
      ).length,
      lastUpdated: list.value.length > 0 
        ? Math.max(...list.value.map(d => new Date(d.updatedAt).getTime()))
        : null
    }
  }

  // Auto-initialization
  const initializeDrafts = async () => {
    // Load preferences from localStorage
    showDrafts.value = loadDraftPreferences()

    // Auto-fetch if enabled and drafts should be visible
    if (autoFetch && showDrafts.value) {
      await fetchDrafts()
    }
  }

  // Watchers
  watch(showDrafts, (newValue) => {
    saveDraftPreferences(newValue)
    
    // Fetch drafts when showing them
    if (newValue && !isDraftsCacheValid.value) {
      fetchDrafts()
    }
  })

  // Error handling
  const clearDraftsError = () => {
    draftsError.value = null
  }

  const retryFetchDrafts = async () => {
    clearDraftsError()
    return await fetchDrafts(true)
  }

  // Cleanup
  const cleanup = () => {
    clearAllDrafts()
    clearDraftsError()
  }

  // Initialize on composable creation
  if (typeof window !== 'undefined') {
    initializeDrafts()
  }

  return {
    // State (readonly)
    showDrafts: readonly(showDrafts),
    list,
    isFetchingDrafts: readonly(isFetchingDrafts),
    draftsError: readonly(draftsError),
    lastFetchTime: readonly(lastFetchTime),

    // Computed
    draftCount,
    hasDrafts,
    shouldShowDraftsSection,
    isDraftsEmpty,
    draftsVisibilityStatus,
    isDraftsCacheValid,

    // Visibility management
    toggleDrafts,
    showDraftsSection,
    hideDraftsSection,

    // Draft fetching
    fetchDrafts,
    refreshDrafts,
    retryFetchDrafts,

    // Draft management
    addDraft,
    updateDraft,
    removeDraft,
    findDraftById,
    moveDraftToPublished,
    clearAllDrafts,

    // Utilities
    getDraftStats,
    clearDraftsError,
    initializeDrafts,
    cleanup,

    // For v-model binding
    draftsVisibilityModel: computed({
      get: () => showDrafts.value,
      set: (value: boolean) => {
        if (value) showDraftsSection()
        else hideDraftsSection()
      }
    }),
  }
}

// Type for the composable return value
export type DraftsComposable = ReturnType<typeof useDrafts>