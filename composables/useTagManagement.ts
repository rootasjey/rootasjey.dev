import type { ApiTag } from '~/types/tag'
import type { Post } from '~/types/post'

export interface TagWithUsage extends ApiTag {
  count: number
  isUsed: boolean
}

export interface TagStats {
  total: number
  custom: number
}

export interface CategoryOption {
  label: string
  value: string
  class?: string
}

export function useTagManagement(posts: Ref<Post[]>) {
  const tagStore = useTagsStore()

  // State for tag creation
  const newTagName = ref('')
  const newTagCategory = ref<CategoryOption>({ label: 'General', value: 'general' })
  const isCreatingTag = ref(false)

  // State for tag editing
  const editingTag = ref<ApiTag | null>(null)
  const editingTagName = ref('')
  const editingTagCategory = ref('')
  const isUpdatingTag = ref(false)

  // State for tag deletion
  const deletingTag = ref<ApiTag | null>(null)
  const isDeletingTag = ref(false)

  // State for bulk operations
  const isClearingUnused = ref(false)
  const isExporting = ref(false)

  // Category management
  const customCategories = ref<CategoryOption[]>([])
  const baseCategoryOptions: CategoryOption[] = [
    { label: 'General', value: 'general' },
    { label: 'Custom', value: 'custom' },
    { label: 'Primary', value: 'primary' },
    { label: 'Technology', value: 'technology' },
    { label: 'Design', value: 'design' },
    { label: 'Business', value: 'business' }
  ]

  // Computed properties
  const tagStats = computed<TagStats>(() => {
    const all = tagStore.allTags
    return {
      total: all.length,
      custom: all.filter(t => t.category === 'custom').length,
    }
  })

  const tagsWithUsage = computed<TagWithUsage[]>(() => {
    // Count tag usage in all posts
    const tagCounts: Record<number, number> = {}
    posts.value.forEach(post => {
      post.tags?.forEach(tag => {
        tagCounts[tag.id] = (tagCounts[tag.id] || 0) + 1
      })
    })

    // Return all tags with usage information
    return tagStore.allTags
      .map(tag => {
        const count = tagCounts[tag.id] || 0
        return {
          ...tag,
          count,
          isUsed: count > 0
        }
      })
      .sort((a, b) => {
        // Sort by usage (used tags first), then by count (descending), then by name
        if (a.isUsed && !b.isUsed) return -1
        if (!a.isUsed && b.isUsed) return 1
        if (a.isUsed && b.isUsed) return b.count - a.count
        return a.name.localeCompare(b.name)
      })
  })

  const categoryOptions = computed<CategoryOption[]>(() => [
    ...baseCategoryOptions,
    ...customCategories.value,
    { label: '+ Add New Category', value: '__add_new__', class: 'text-blue-600 dark:text-blue-400 font-medium' }
  ])

  const deletingTagUsage = computed(() => {
    if (!deletingTag.value) return 0
    return getTagUsage(deletingTag.value)
  })

  // Utility methods
  const getTagUsage = (tag: ApiTag): number => {
    return posts.value.reduce((acc, post) => acc + (post.tags?.some(t => t.id === tag.id) ? 1 : 0), 0)
  }

  const resetTagCreationForm = () => {
    newTagName.value = ''
    newTagCategory.value = { label: 'General', value: 'general' }
  }

  const resetTagEditingState = () => {
    editingTag.value = null
    editingTagName.value = ''
    editingTagCategory.value = ''
  }

  const resetTagDeletionState = () => {
    deletingTag.value = null
  }

  // Tag CRUD operations
  const createTag = async (): Promise<boolean> => {
    if (!newTagName.value.trim()) return false

    isCreatingTag.value = true
    try {
      await tagStore.createTag(newTagName.value.trim(), newTagCategory.value.value)
      resetTagCreationForm()
      toast({
        title: 'Tag created successfully',
        description: `Created tag: ${newTagName.value}`,
        duration: 3000,
        showProgress: true,
        toast: 'soft-success'
      })
      return true
    } catch (error: any) {
      toast({
        title: 'Failed to create tag',
        description: error?.message || 'Unknown error occurred',
        duration: 5000,
        showProgress: true,
        toast: 'soft-error'
      })
      return false
    } finally {
      isCreatingTag.value = false
    }
  }

  const startEditingTag = (tag: ApiTag) => {
    editingTag.value = tag
    editingTagName.value = tag.name
    editingTagCategory.value = tag.category
  }

  const updateTag = async (): Promise<boolean> => {
    if (!editingTag.value || !editingTagName.value.trim()) return false

    isUpdatingTag.value = true
    try {
      await tagStore.updateTag(editingTag.value.id, editingTagName.value.trim(), editingTagCategory.value)
      resetTagEditingState()
      toast({
        title: 'Tag updated successfully',
        description: `Updated tag: ${editingTagName.value}`,
        duration: 3000,
        showProgress: true,
        toast: 'soft-success'
      })
      return true
    } catch (error: any) {
      toast({
        title: 'Failed to update tag',
        description: error?.message || 'Unknown error occurred',
        duration: 5000,
        showProgress: true,
        toast: 'soft-error'
      })
      return false
    } finally {
      isUpdatingTag.value = false
    }
  }

  const startDeletingTag = (tag: ApiTag) => {
    deletingTag.value = tag
  }

  const deleteTag = async (): Promise<boolean> => {
    if (!deletingTag.value) return false

    isDeletingTag.value = true
    try {
      await tagStore.deleteTag(deletingTag.value.id)
      resetTagDeletionState()
      toast({
        title: 'Tag deleted successfully',
        description: 'Tag has been removed',
        duration: 3000,
        showProgress: true,
        toast: 'soft-success'
      })
      return true
    } catch (error: any) {
      toast({
        title: 'Failed to delete tag',
        description: error?.message || 'Unknown error occurred',
        duration: 5000,
        showProgress: true,
        toast: 'soft-error'
      })
      return false
    } finally {
      isDeletingTag.value = false
    }
  }

  // Bulk operations
  const clearUnusedTags = async (): Promise<boolean> => {
    const confirmClear = confirm('Remove all unused tags? This action cannot be undone.')
    if (!confirmClear) return false

    isClearingUnused.value = true
    const unused = tagsWithUsage.value.filter(tag => !tag.isUsed)

    try {
      for (const tag of unused) {
        await tagStore.deleteTag(tag.id)
      }
      toast({
        title: 'Unused tags cleared',
        description: `Removed ${unused.length} unused tags`,
        duration: 3000,
        showProgress: true,
        toast: 'soft-success'
      })
      return true
    } catch (error: any) {
      toast({
        title: 'Failed to clear unused tags',
        description: error?.message || 'Unknown error occurred',
        duration: 5000,
        showProgress: true,
        toast: 'soft-error'
      })
      return false
    } finally {
      isClearingUnused.value = false
    }
  }

  const exportTags = async (): Promise<boolean> => {
    isExporting.value = true
    try {
      const exportData = tagStore.allTags
      const blob = new Blob([JSON.stringify(exportData, null, 2)], {
        type: 'application/json'
      })
      const url = URL.createObjectURL(blob)
      const a = document.createElement('a')
      a.href = url
      a.download = `tags-export-${new Date().toISOString().split('T')[0]}.json`
      document.body.appendChild(a)
      a.click()
      document.body.removeChild(a)
      URL.revokeObjectURL(url)
      
      toast({
        title: 'Tags exported successfully',
        description: 'Tags have been downloaded as JSON file',
        duration: 3000,
        showProgress: true,
        toast: 'soft-success'
      })
      return true
    } catch (error: any) {
      toast({
        title: 'Failed to export tags',
        description: error?.message || 'Unknown error occurred',
        duration: 5000,
        showProgress: true,
        toast: 'soft-error'
      })
      return false
    } finally {
      isExporting.value = false
    }
  }

  // Category management
  const addCustomCategory = (category: CategoryOption) => {
    if (!customCategories.value.some(c => c.value === category.value)) {
      customCategories.value.push(category)
    }
  }

  return {
    // State
    newTagName,
    newTagCategory,
    isCreatingTag,
    editingTag,
    editingTagName,
    editingTagCategory,
    isUpdatingTag,
    deletingTag,
    isDeletingTag,
    isClearingUnused,
    isExporting,
    customCategories,

    // Computed
    tagStats,
    tagsWithUsage,
    categoryOptions,
    deletingTagUsage,

    // Methods
    getTagUsage,
    resetTagCreationForm,
    resetTagEditingState,
    resetTagDeletionState,
    createTag,
    startEditingTag,
    updateTag,
    startDeletingTag,
    deleteTag,
    clearUnusedTags,
    exportTags,
    addCustomCategory
  }
}
