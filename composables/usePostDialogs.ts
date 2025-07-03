import type { Post } from '~/types/post'

export const usePostDialogs = () => {
  // Dialog open/close states
  const isCreateDialogOpen = ref(false)
  const isEditDialogOpen = ref(false)
  const isDeleteDialogOpen = ref(false)

  // Post references for edit/delete operations
  const editingPost = ref<Post | undefined>(undefined)
  const deletingPost = ref<Post | undefined>(undefined)

  // Dialog history for navigation (optional feature)
  const dialogHistory = ref<string[]>([])

  // Computed properties
  const hasOpenDialog = computed(() => 
    isCreateDialogOpen.value || isEditDialogOpen.value || isDeleteDialogOpen.value
  )

  const currentDialog = computed(() => {
    if (isCreateDialogOpen.value) return 'create'
    if (isEditDialogOpen.value) return 'edit'
    if (isDeleteDialogOpen.value) return 'delete'
    return null
  })

  // Create dialog methods
  const openCreateDialog = () => {
    closeAllDialogs()
    isCreateDialogOpen.value = true
    addToHistory('create')
  }

  const closeCreateDialog = () => {
    isCreateDialogOpen.value = false
    removeFromHistory('create')
  }

  // Edit dialog methods
  const openEditDialog = (post: Post) => {
    if (!post) {
      console.warn('Cannot open edit dialog: post is required')
      return
    }

    closeAllDialogs()
    editingPost.value = post
    isEditDialogOpen.value = true
    addToHistory('edit')
  }

  const closeEditDialog = () => {
    isEditDialogOpen.value = false
    editingPost.value = undefined
    removeFromHistory('edit')
  }

  // Delete dialog methods
  const openDeleteDialog = (post: Post) => {
    if (!post) {
      console.warn('Cannot open delete dialog: post is required')
      return
    }

    closeAllDialogs()
    deletingPost.value = post
    isDeleteDialogOpen.value = true
    addToHistory('delete')
  }

  const closeDeleteDialog = () => {
    isDeleteDialogOpen.value = false
    deletingPost.value = undefined
    removeFromHistory('delete')
  }

  // Utility methods
  const closeAllDialogs = () => {
    isCreateDialogOpen.value = false
    isEditDialogOpen.value = false
    isDeleteDialogOpen.value = false
    editingPost.value = undefined
    deletingPost.value = undefined
    dialogHistory.value = []
  }

  const closeCurrentDialog = () => {
    switch (currentDialog.value) {
      case 'create':
        closeCreateDialog()
        break
      case 'edit':
        closeEditDialog()
        break
      case 'delete':
        closeDeleteDialog()
        break
    }
  }

  // Dialog history management (for potential back/forward navigation)
  const addToHistory = (dialogType: string) => {
    dialogHistory.value.push(dialogType)
  }

  const removeFromHistory = (dialogType: string) => {
    const index = dialogHistory.value.lastIndexOf(dialogType)
    if (index > -1) {
      dialogHistory.value.splice(index, 1)
    }
  }

  const goBackInHistory = () => {
    if (dialogHistory.value.length > 1) {
      // Remove current dialog
      dialogHistory.value.pop()
      
      // Open previous dialog
      const previousDialog = dialogHistory.value[dialogHistory.value.length - 1]
      closeAllDialogs()
      
      switch (previousDialog) {
        case 'create':
          isCreateDialogOpen.value = true
          break
        case 'edit':
          // Note: This would need the previous post reference
          // For now, just close all dialogs
          break
        case 'delete':
          // Note: This would need the previous post reference
          // For now, just close all dialogs
          break
      }
    }
  }

  // Keyboard shortcuts
  const handleGlobalKeydown = (event: KeyboardEvent) => {
    // ESC to close current dialog
    if (event.key === 'Escape' && hasOpenDialog.value) {
      event.preventDefault()
      closeCurrentDialog()
    }

    // Prevent background scrolling when dialog is open
    if (hasOpenDialog.value && (event.key === 'ArrowUp' || event.key === 'ArrowDown')) {
      const activeElement = document.activeElement
      const isInDialog = activeElement?.closest('[role="dialog"]')
      if (!isInDialog) {
        event.preventDefault()
      }
    }
  }

  // Dialog state validation
  const validateDialogState = () => {
    // Ensure edit dialog has a post
    if (isEditDialogOpen.value && !editingPost.value) {
      console.warn('Edit dialog is open but no post is set for editing')
      closeEditDialog()
    }

    // Ensure delete dialog has a post
    if (isDeleteDialogOpen.value && !deletingPost.value) {
      console.warn('Delete dialog is open but no post is set for deletion')
      closeDeleteDialog()
    }
  }

  // Watchers for validation and cleanup
  watch([isEditDialogOpen, isDeleteDialogOpen], () => {
    nextTick(() => {
      validateDialogState()
    })
  })

  // Cleanup when component unmounts
  const cleanup = () => {
    closeAllDialogs()
    document.removeEventListener('keydown', handleGlobalKeydown)
  }

  // Auto-setup keyboard listeners
  onMounted(() => {
    document.addEventListener('keydown', handleGlobalKeydown)
  })

  onUnmounted(() => {
    cleanup()
  })

  // Dialog transition helpers
  const transitionFromCreateToEdit = (post: Post) => {
    closeCreateDialog()
    openEditDialog(post)
  }

  const transitionFromEditToDelete = () => {
    if (editingPost.value) {
      const post = editingPost.value
      closeEditDialog()
      openDeleteDialog(post)
    }
  }

  // Batch operations for multiple dialogs
  const openDialogSequence = (sequence: Array<{ type: 'create' | 'edit' | 'delete', post?: Post }>) => {
    if (sequence.length === 0) return

    const [first, ...rest] = sequence
    
    switch (first.type) {
      case 'create':
        openCreateDialog()
        break
      case 'edit':
        if (first.post) openEditDialog(first.post)
        break
      case 'delete':
        if (first.post) openDeleteDialog(first.post)
        break
    }

    // Store remaining sequence for potential chaining
    // This could be used for complex workflows
  }

  return {
    // State (readonly)
    isCreateDialogOpen: readonly(isCreateDialogOpen),
    isEditDialogOpen: readonly(isEditDialogOpen),
    isDeleteDialogOpen: readonly(isDeleteDialogOpen),
    editingPost,
    deletingPost,

    // Computed
    hasOpenDialog,
    currentDialog,

    // Create dialog
    openCreateDialog,
    closeCreateDialog,

    // Edit dialog
    openEditDialog,
    closeEditDialog,

    // Delete dialog
    openDeleteDialog,
    closeDeleteDialog,

    // Utilities
    closeAllDialogs,
    closeCurrentDialog,

    // Advanced features
    transitionFromCreateToEdit,
    transitionFromEditToDelete,
    openDialogSequence,
    goBackInHistory,

    // Cleanup
    cleanup,

    // For v-model binding (writable computed)
    createDialogModel: computed({
      get: () => isCreateDialogOpen.value,
      set: (value: boolean) => {
        if (value) openCreateDialog()
        else closeCreateDialog()
      }
    }),

    editDialogModel: computed({
      get: () => isEditDialogOpen.value,
      set: (value: boolean) => {
        if (value && editingPost.value) {
          // Dialog is being opened externally, keep current editing post
        } else if (!value) {
          closeEditDialog()
        }
      }
    }),

    deleteDialogModel: computed({
      get: () => isDeleteDialogOpen.value,
      set: (value: boolean) => {
        if (value && deletingPost.value) {
          // Dialog is being opened externally, keep current deleting post
        } else if (!value) {
          closeDeleteDialog()
        }
      }
    }),
  }
}

// Type for the composable return value
export type PostDialogs = ReturnType<typeof usePostDialogs>