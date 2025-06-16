interface UsePostCategoriesOptions {
  defaultCategories?: string[]
  storageKey?: string
  autoSave?: boolean
  caseSensitive?: boolean
}

export const usePostCategories = (options: UsePostCategoriesOptions = {}) => {
  const {
    defaultCategories = [
      "Tech",
      "Development", 
      "Cinema",
      "Literature",
      "Music"
    ],
    storageKey = 'post_categories',
    autoSave = true,
    caseSensitive = false
  } = options

  // State
  const categories = ref<string[]>([...defaultCategories])
  const customCategories = ref<string[]>([])
  const categoryUsage = ref<Record<string, number>>({})
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  // Computed properties
  const allCategories = computed(() => {
    const combined = [...categories.value, ...customCategories.value]
    return [...new Set(combined)].sort((a, b) => {
      // Sort by usage count (descending), then alphabetically
      const usageA = categoryUsage.value[a] || 0
      const usageB = categoryUsage.value[b] || 0
      
      if (usageA !== usageB) {
        return usageB - usageA
      }
      
      return caseSensitive ? a.localeCompare(b) : a.toLowerCase().localeCompare(b.toLowerCase())
    })
  })

  const popularCategories = computed(() => {
    return allCategories.value
      .filter(cat => (categoryUsage.value[cat] || 0) > 0)
      .slice(0, 5)
  })

  const unusedCategories = computed(() => {
    return allCategories.value.filter(cat => !(categoryUsage.value[cat] > 0))
  })

  const totalCategories = computed(() => allCategories.value.length)
  const totalCustomCategories = computed(() => customCategories.value.length)

  // Category statistics
  const getCategoryStats = () => {
    const stats = {
      total: totalCategories.value,
      custom: totalCustomCategories.value,
      default: defaultCategories.length,
      mostUsed: '',
      leastUsed: '',
      totalUsage: 0
    }

    const usageEntries = Object.entries(categoryUsage.value)
    if (usageEntries.length > 0) {
      const sortedByUsage = usageEntries.sort(([,a], [,b]) => b - a)
      stats.mostUsed = sortedByUsage[0]?.[0] || ''
      stats.leastUsed = sortedByUsage[sortedByUsage.length - 1]?.[0] || ''
      stats.totalUsage = usageEntries.reduce((sum, [, count]) => sum + count, 0)
    }

    return stats
  }

  // Storage management
  const loadCategoriesFromStorage = () => {
    if (typeof window === 'undefined') return

    try {
      const stored = localStorage.getItem(storageKey)
      if (stored) {
        const data = JSON.parse(stored)
        if (data.customCategories && Array.isArray(data.customCategories)) {
          customCategories.value = data.customCategories
        }
        if (data.categoryUsage && typeof data.categoryUsage === 'object') {
          categoryUsage.value = data.categoryUsage
        }
      }
    } catch (error) {
      console.warn('Failed to load categories from localStorage:', error)
    }
  }

  const saveCategoriesToStorage = () => {
    if (typeof window === 'undefined' || !autoSave) return

    try {
      const data = {
        customCategories: customCategories.value,
        categoryUsage: categoryUsage.value,
        lastUpdated: new Date().toISOString()
      }
      localStorage.setItem(storageKey, JSON.stringify(data))
    } catch (error) {
      console.warn('Failed to save categories to localStorage:', error)
    }
  }

  // Category validation
  const validateCategory = (category: string): { isValid: boolean; error?: string } => {
    if (!category || typeof category !== 'string') {
      return { isValid: false, error: 'Category name is required' }
    }

    const trimmed = category.trim()
    if (trimmed.length === 0) {
      return { isValid: false, error: 'Category name cannot be empty' }
    }

    if (trimmed.length < 2) {
      return { isValid: false, error: 'Category name must be at least 2 characters' }
    }

    if (trimmed.length > 50) {
      return { isValid: false, error: 'Category name must be less than 50 characters' }
    }

    // Check for invalid characters
    const invalidChars = /[<>:"\/\\|?*\x00-\x1f]/
    if (invalidChars.test(trimmed)) {
      return { isValid: false, error: 'Category name contains invalid characters' }
    }

    return { isValid: true }
  }

  const sanitizeCategory = (category: string): string => {
    return category
      .trim()
      .replace(/\s+/g, ' ') // Replace multiple spaces with single space
      .replace(/[<>:"\/\\|?*\x00-\x1f]/g, '') // Remove invalid characters
  }

  const normalizeCategory = (category: string): string => {
    const sanitized = sanitizeCategory(category)
    return caseSensitive ? sanitized : sanitized.toLowerCase()
  }

  // Category management
  const categoryExists = (category: string): boolean => {
    const normalized = normalizeCategory(category)
    return allCategories.value.some(cat => 
      normalizeCategory(cat) === normalized
    )
  }

  const addCategory = (category: string): { success: boolean; error?: string; category?: string } => {
    const validation = validateCategory(category)
    if (!validation.isValid) {
      return { success: false, error: validation.error }
    }

    const sanitized = sanitizeCategory(category)
    
    if (categoryExists(sanitized)) {
      return { success: false, error: 'Category already exists' }
    }

    // Add to custom categories if not in defaults
    const isDefault = defaultCategories.some(cat => 
      normalizeCategory(cat) === normalizeCategory(sanitized)
    )

    if (!isDefault) {
      customCategories.value.push(sanitized)
      saveCategoriesToStorage()
    }

    return { success: true, category: sanitized }
  }

  const removeCategory = (category: string): { success: boolean; error?: string } => {
    // Don't allow removing default categories
    const isDefault = defaultCategories.some(cat => 
      normalizeCategory(cat) === normalizeCategory(category)
    )

    if (isDefault) {
      return { success: false, error: 'Cannot remove default category' }
    }

    const index = customCategories.value.findIndex(cat => 
      normalizeCategory(cat) === normalizeCategory(category)
    )

    if (index === -1) {
      return { success: false, error: 'Category not found' }
    }

    customCategories.value.splice(index, 1)
    
    // Remove from usage stats
    delete categoryUsage.value[category]
    
    saveCategoriesToStorage()
    return { success: true }
  }

  const renameCategory = (oldName: string, newName: string): { success: boolean; error?: string } => {
    const validation = validateCategory(newName)
    if (!validation.isValid) {
      return { success: false, error: validation.error }
    }

    const sanitizedNew = sanitizeCategory(newName)
    
    if (categoryExists(sanitizedNew) && normalizeCategory(oldName) !== normalizeCategory(sanitizedNew)) {
      return { success: false, error: 'New category name already exists' }
    }

    // Don't allow renaming default categories
    const isDefault = defaultCategories.some(cat => 
      normalizeCategory(cat) === normalizeCategory(oldName)
    )

    if (isDefault) {
      return { success: false, error: 'Cannot rename default category' }
    }

    const index = customCategories.value.findIndex(cat => 
      normalizeCategory(cat) === normalizeCategory(oldName)
    )

    if (index === -1) {
      return { success: false, error: 'Category not found' }
    }

    customCategories.value[index] = sanitizedNew
    
    // Update usage stats
    if (categoryUsage.value[oldName]) {
      categoryUsage.value[sanitizedNew] = categoryUsage.value[oldName]
      delete categoryUsage.value[oldName]
    }
    
    saveCategoriesToStorage()
    return { success: true }
  }

  // Usage tracking
  const incrementCategoryUsage = (category: string) => {
    if (!category) return

    const existing = allCategories.value.find(cat => 
      normalizeCategory(cat) === normalizeCategory(category)
    )

    if (existing) {
      categoryUsage.value[existing] = (categoryUsage.value[existing] || 0) + 1
      saveCategoriesToStorage()
    }
  }

  const decrementCategoryUsage = (category: string) => {
    if (!category) return

    const existing = allCategories.value.find(cat => 
      normalizeCategory(cat) === normalizeCategory(category)
    )

    if (existing && categoryUsage.value[existing]) {
      categoryUsage.value[existing] = Math.max(0, categoryUsage.value[existing] - 1)
      saveCategoriesToStorage()
    }
  }

  const getCategoryUsage = (category: string): number => {
    return categoryUsage.value[category] || 0
  }

  // Batch operations
  const addMultipleCategories = (categories: string[]): { 
    success: string[]
    failed: Array<{ category: string; error: string }> 
  } => {
    const success: string[] = []
    const failed: Array<{ category: string; error: string }> = []

    categories.forEach(category => {
      const result = addCategory(category)
      if (result.success && result.category) {
        success.push(result.category)
      } else {
        failed.push({ category, error: result.error || 'Unknown error' })
      }
    })

    return { success, failed }
  }

  const clearUnusedCategories = (): string[] => {
    const removed = unusedCategories.value.filter(cat => 
      !defaultCategories.some(def => normalizeCategory(def) === normalizeCategory(cat))
    )

    removed.forEach(category => {
      removeCategory(category)
    })

    return removed
  }

  const resetCategories = () => {
    customCategories.value = []
    categoryUsage.value = {}
    saveCategoriesToStorage()
  }

  const exportCategories = () => {
    return {
      defaultCategories: [...defaultCategories],
      customCategories: [...customCategories.value],
      categoryUsage: { ...categoryUsage.value },
      exportedAt: new Date().toISOString()
    }
  }

  const importCategories = (data: {
    customCategories?: string[]
    categoryUsage?: Record<string, number>
  }): { success: boolean; error?: string } => {
    try {
      if (data.customCategories && Array.isArray(data.customCategories)) {
        // Validate all categories before importing
        const validationResults = data.customCategories.map(cat => ({
          category: cat,
          validation: validateCategory(cat)
        }))

        const invalid = validationResults.filter(r => !r.validation.isValid)
        if (invalid.length > 0) {
          return { 
            success: false, 
            error: `Invalid categories: ${invalid.map(i => i.category).join(', ')}` 
          }
        }

        customCategories.value = data.customCategories.map(sanitizeCategory)
      }

      if (data.categoryUsage && typeof data.categoryUsage === 'object') {
        categoryUsage.value = { ...data.categoryUsage }
      }

      saveCategoriesToStorage()
      return { success: true }
    } catch (error) {
      return { success: false, error: 'Failed to import categories' }
    }
  }

  // Search and filtering
  const searchCategories = (query: string): string[] => {
    if (!query.trim()) return allCategories.value

    const normalizedQuery = query.toLowerCase()
    return allCategories.value.filter(category =>
      category.toLowerCase().includes(normalizedQuery)
    )
  }

  const getCategoriesByUsage = (minUsage = 1): string[] => {
    return allCategories.value.filter(cat => 
      getCategoryUsage(cat) >= minUsage
    )
  }

  // Suggestions
  const getSuggestedCategories = (input: string, limit = 5): string[] => {
    if (!input.trim()) return popularCategories.value.slice(0, limit)

    const query = input.toLowerCase()
    const matches = allCategories.value.filter(cat =>
      cat.toLowerCase().startsWith(query)
    )

    return matches.slice(0, limit)
  }

  // Watchers for auto-save
  watch([customCategories, categoryUsage], () => {
    if (autoSave) {
      saveCategoriesToStorage()
    }
  }, { deep: true })

  // Initialize
  const initializeCategories = () => {
    loadCategoriesFromStorage()
  }

  // Auto-initialize
  if (typeof window !== 'undefined') {
    initializeCategories()
  }

  return {
    // State (readonly)
    categories: readonly(categories),
    customCategories: readonly(customCategories),
    categoryUsage: readonly(categoryUsage),
    isLoading: readonly(isLoading),
    error: readonly(error),

    // Computed
    allCategories,
    popularCategories,
    unusedCategories,
    totalCategories,
    totalCustomCategories,

    // Category management
    addCategory,
    removeCategory,
    renameCategory,
    categoryExists,
    
    // Validation
    validateCategory,
    sanitizeCategory,
    normalizeCategory,

    // Usage tracking
    incrementCategoryUsage,
    decrementCategoryUsage,
    getCategoryUsage,

    // Batch operations
    addMultipleCategories,
    clearUnusedCategories,
    resetCategories,

    // Import/Export
    exportCategories,
    importCategories,

    // Search and filtering
    searchCategories,
    getCategoriesByUsage,
    getSuggestedCategories,

    // Statistics
    getCategoryStats,

    // Storage
    saveCategoriesToStorage,
    loadCategoriesFromStorage,
    initializeCategories,
  }
}

// Type for the composable return value
export type PostCategoriesComposable = ReturnType<typeof usePostCategories>