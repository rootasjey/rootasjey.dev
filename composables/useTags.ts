interface UseTagsOptions {
  defaultTags?: string[]
  storageKey?: string
  autoSave?: boolean
  caseSensitive?: boolean
}

export const useTags = (options: UseTagsOptions = {}) => {
  const {
    defaultTags = [
      "JavaScript",
      "TypeScript", 
      "Vue",
      "Nuxt",
      "CSS",
      "HTML",
      "Node.js",
      "Tutorial",
      "Tips",
      "Review"
    ],
    storageKey = 'post_tags',
    autoSave = true,
    caseSensitive = false
  } = options

  // State
  const tags = ref<string[]>([...defaultTags])
  const customTags = ref<string[]>([])
  const tagUsage = ref<Record<string, number>>({})
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  // Computed properties
  const allTags = computed(() => {
    const combined = [...tags.value, ...customTags.value]
    return [...new Set(combined)].sort((a, b) => {
      // Sort by usage count (descending), then alphabetically
      const usageA = tagUsage.value[a] || 0
      const usageB = tagUsage.value[b] || 0
      
      if (usageA !== usageB) {
        return usageB - usageA
      }
      
      return caseSensitive ? a.localeCompare(b) : a.toLowerCase().localeCompare(b.toLowerCase())
    })
  })

  const popularTags = computed(() => {
    return allTags.value
      .filter(tag => (tagUsage.value[tag] || 0) > 0)
      .slice(0, 10)
  })

  const unusedTags = computed(() => {
    return allTags.value.filter(tag => !(tagUsage.value[tag] > 0))
  })

  const totalTags = computed(() => allTags.value.length)
  const totalCustomTags = computed(() => customTags.value.length)

  // Tag utilities for primary/secondary tags
  const getPrimaryTag = (postTags: string[]): string | undefined => {
    return postTags && postTags.length > 0 ? postTags[0] : undefined
  }

  const getSecondaryTags = (postTags: string[]): string[] => {
    return postTags && postTags.length > 1 ? postTags.slice(1) : []
  }

  const hasSecondaryTags = (postTags: string[]): boolean => {
    return postTags && postTags.length > 1
  }

  const getAllTagsFromPost = (postTags: string[]): string[] => {
    return postTags || []
  }

  // Tag statistics
  const getTagStats = () => {
    const stats = {
      total: totalTags.value,
      custom: totalCustomTags.value,
      default: defaultTags.length,
      mostUsed: '',
      leastUsed: '',
      totalUsage: 0
    }

    const usageEntries = Object.entries(tagUsage.value)
    if (usageEntries.length > 0) {
      const sortedByUsage = usageEntries.sort(([,a], [,b]) => b - a)
      stats.mostUsed = sortedByUsage[0]?.[0] || ''
      stats.leastUsed = sortedByUsage[sortedByUsage.length - 1]?.[0] || ''
      stats.totalUsage = usageEntries.reduce((sum, [, count]) => sum + count, 0)
    }

    return stats
  }

  // Storage management
  const loadTagsFromStorage = () => {
    if (typeof window === 'undefined') return

    try {
      const stored = localStorage.getItem(storageKey)
      if (stored) {
        const data = JSON.parse(stored)
        if (data.customTags && Array.isArray(data.customTags)) {
          customTags.value = data.customTags
        }
        if (data.tagUsage && typeof data.tagUsage === 'object') {
          tagUsage.value = data.tagUsage
        }
      }
    } catch (error) {
      console.warn('Failed to load tags from localStorage:', error)
    }
  }

  const saveTagsToStorage = () => {
    if (typeof window === 'undefined' || !autoSave) return

    try {
      const data = {
        customTags: customTags.value,
        tagUsage: tagUsage.value,
        lastUpdated: new Date().toISOString()
      }
      localStorage.setItem(storageKey, JSON.stringify(data))
    } catch (error) {
      console.warn('Failed to save tags to localStorage:', error)
    }
  }

  // Tag validation
  const validateTag = (tag: string): { isValid: boolean; error?: string } => {
    if (!tag || typeof tag !== 'string') {
      return { isValid: false, error: 'Tag name is required' }
    }

    const trimmed = tag.trim()
    if (trimmed.length === 0) {
      return { isValid: false, error: 'Tag name cannot be empty' }
    }

    if (trimmed.length < 2) {
      return { isValid: false, error: 'Tag name must be at least 2 characters' }
    }

    if (trimmed.length > 30) {
      return { isValid: false, error: 'Tag name must be less than 30 characters' }
    }

    // Check for invalid characters (tags are usually more restrictive)
    const invalidChars = /[<>:"\/\\|?*\x00-\x1f,;]/
    if (invalidChars.test(trimmed)) {
      return { isValid: false, error: 'Tag name contains invalid characters' }
    }

    return { isValid: true }
  }

  const sanitizeTag = (tag: string): string => {
    return tag
      .trim()
      .replace(/\s+/g, ' ') // Replace multiple spaces with single space
      .replace(/[<>:"\/\\|?*\x00-\x1f,;]/g, '') // Remove invalid characters
  }

  const normalizeTag = (tag: string): string => {
    const sanitized = sanitizeTag(tag)
    return caseSensitive ? sanitized : sanitized.toLowerCase()
  }

  // Tag management
  const tagExists = (tag: string): boolean => {
    const normalized = normalizeTag(tag)
    return allTags.value.some(t => 
      normalizeTag(t) === normalized
    )
  }

  const addTag = (tag: string): { success: boolean; error?: string; tag?: string } => {
    const validation = validateTag(tag)
    if (!validation.isValid) {
      return { success: false, error: validation.error }
    }

    const sanitized = sanitizeTag(tag)
    
    if (tagExists(sanitized)) {
      return { success: false, error: 'Tag already exists' }
    }

    // Add to custom tags if not in defaults
    const isDefault = defaultTags.some(t => 
      normalizeTag(t) === normalizeTag(sanitized)
    )

    if (!isDefault) {
      customTags.value.push(sanitized)
      saveTagsToStorage()
    }

    return { success: true, tag: sanitized }
  }

  const removeTag = (tag: string): { success: boolean; error?: string } => {
    // Don't allow removing default tags
    const isDefault = defaultTags.some(t => 
      normalizeTag(t) === normalizeTag(tag)
    )

    if (isDefault) {
      return { success: false, error: 'Cannot remove default tag' }
    }

    const index = customTags.value.findIndex(t => 
      normalizeTag(t) === normalizeTag(tag)
    )

    if (index === -1) {
      return { success: false, error: 'Tag not found' }
    }

    customTags.value.splice(index, 1)
    
    // Remove from usage stats
    delete tagUsage.value[tag]
    
    saveTagsToStorage()
    return { success: true }
  }

  const renameTag = (oldName: string, newName: string): { success: boolean; error?: string } => {
    const validation = validateTag(newName)
    if (!validation.isValid) {
      return { success: false, error: validation.error }
    }

    const sanitizedNew = sanitizeTag(newName)
    
    if (tagExists(sanitizedNew) && normalizeTag(oldName) !== normalizeTag(sanitizedNew)) {
      return { success: false, error: 'New tag name already exists' }
    }

    // Don't allow renaming default tags
    const isDefault = defaultTags.some(t => 
      normalizeTag(t) === normalizeTag(oldName)
    )

    if (isDefault) {
      return { success: false, error: 'Cannot rename default tag' }
    }

    const index = customTags.value.findIndex(t => 
      normalizeTag(t) === normalizeTag(oldName)
    )

    if (index === -1) {
      return { success: false, error: 'Tag not found' }
    }

    customTags.value[index] = sanitizedNew
    
    // Update usage stats
    if (tagUsage.value[oldName]) {
      tagUsage.value[sanitizedNew] = tagUsage.value[oldName]
      delete tagUsage.value[oldName]
    }
    
    saveTagsToStorage()
    return { success: true }
  }

  // Usage tracking
  const incrementTagUsage = (tag: string) => {
    if (!tag) return

    const existing = allTags.value.find(t => 
      normalizeTag(t) === normalizeTag(tag)
    )

    if (existing) {
      tagUsage.value[existing] = (tagUsage.value[existing] || 0) + 1
      saveTagsToStorage()
    }
  }

  const decrementTagUsage = (tag: string) => {
    if (!tag) return

    const existing = allTags.value.find(t => 
      normalizeTag(t) === normalizeTag(tag)
    )

    if (existing && tagUsage.value[existing]) {
      tagUsage.value[existing] = Math.max(0, tagUsage.value[existing] - 1)
      saveTagsToStorage()
    }
  }

  const getTagUsage = (tag: string): number => {
    return tagUsage.value[tag] || 0
  }

  // Batch operations for post tags
  const incrementPostTagsUsage = (postTags: string[]) => {
    postTags.forEach(tag => incrementTagUsage(tag))
  }

  const decrementPostTagsUsage = (postTags: string[]) => {
    postTags.forEach(tag => decrementTagUsage(tag))
  }

  // Batch operations
  const addMultipleTags = (tags: string[]): { 
    success: string[]
    failed: Array<{ tag: string; error: string }> 
  } => {
    const success: string[] = []
    const failed: Array<{ tag: string; error: string }> = []

    tags.forEach(tag => {
      const result = addTag(tag)
      if (result.success && result.tag) {
        success.push(result.tag)
      } else {
        failed.push({ tag, error: result.error || 'Unknown error' })
      }
    })

    return { success, failed }
  }

  const clearUnusedTags = (): string[] => {
    const removed = unusedTags.value.filter(tag => 
      !defaultTags.some(def => normalizeTag(def) === normalizeTag(tag))
    )

    removed.forEach(tag => {
      removeTag(tag)
    })

    return removed
  }

  const resetTags = () => {
    customTags.value = []
    tagUsage.value = {}
    saveTagsToStorage()
  }

  const exportTags = () => {
    return {
      defaultTags: [...defaultTags],
      customTags: [...customTags.value],
      tagUsage: { ...tagUsage.value },
      exportedAt: new Date().toISOString()
    }
  }

  const importTags = (data: {
    customTags?: string[]
    tagUsage?: Record<string, number>
  }): { success: boolean; error?: string } => {
    try {
      if (data.customTags && Array.isArray(data.customTags)) {
        // Validate all tags before importing
        const validationResults = data.customTags.map(tag => ({
          tag: tag,
          validation: validateTag(tag)
        }))

        const invalid = validationResults.filter(r => !r.validation.isValid)
        if (invalid.length > 0) {
          return { 
            success: false, 
            error: `Invalid tags: ${invalid.map(i => i.tag).join(', ')}` 
          }
        }

        customTags.value = data.customTags.map(sanitizeTag)
      }

      if (data.tagUsage && typeof data.tagUsage === 'object') {
        tagUsage.value = { ...data.tagUsage }
      }

      saveTagsToStorage()
      return { success: true }
    } catch (error) {
      return { success: false, error: 'Failed to import tags' }
    }
  }

  // Search and filtering
  const searchTags = (query: string): string[] => {
    if (!query.trim()) return allTags.value

    const normalizedQuery = query.toLowerCase()
    return allTags.value.filter(tag =>
      tag.toLowerCase().includes(normalizedQuery)
    )
  }

  const getTagsByUsage = (minUsage = 1): string[] => {
    return allTags.value.filter(tag => 
      getTagUsage(tag) >= minUsage
    )
  }

  // Suggestions
  const getSuggestedTags = (input: string, limit = 5): string[] => {
    if (!input.trim()) return popularTags.value.slice(0, limit)

    const query = input.toLowerCase()
    const matches = allTags.value.filter(tag =>
      tag.toLowerCase().startsWith(query)
    )

    return matches.slice(0, limit)
  }

  // Watchers for auto-save
  watch([customTags, tagUsage], () => {
    if (autoSave) {
      saveTagsToStorage()
    }
  }, { deep: true })

  // Initialize
  const initializeTags = () => {
    loadTagsFromStorage()
  }

  // Auto-initialize
  if (typeof window !== 'undefined') {
    initializeTags()
  }

  return {
    // State (readonly)
    tags: readonly(tags),
    customTags: readonly(customTags),
    tagUsage: readonly(tagUsage),
    isLoading: readonly(isLoading),
    error: readonly(error),

    // Computed
    allTags,
    popularTags,
    unusedTags,
    totalTags,
    totalCustomTags,

    // Primary/Secondary tag utilities
    getPrimaryTag,
    getSecondaryTags,
    hasSecondaryTags,
    getAllTagsFromPost,

    // Tag management
    addTag,
    removeTag,
    renameTag,
    tagExists,
    
    // Validation
    validateTag,
    sanitizeTag,
    normalizeTag,

    // Usage tracking
    incrementTagUsage,
    decrementTagUsage,
    getTagUsage,
    incrementPostTagsUsage,
    decrementPostTagsUsage,

    // Batch operations
    addMultipleTags,
    clearUnusedTags,
    resetTags,

    // Import/Export
    exportTags,
    importTags,

    // Search and filtering
    searchTags,
    getTagsByUsage,
    getSuggestedTags,

    // Statistics
    getTagStats,

    // Storage
    saveTagsToStorage,
    loadTagsFromStorage,
    initializeTags,
  }
}

// Type for the composable return value
export type TagsComposable = ReturnType<typeof useTags>