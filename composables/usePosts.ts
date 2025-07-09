import type { CreatePostPayload, Post, UpdatePostPayload } from '~/types/post'

interface UsePostManagementOptions {
  autoFetch?: boolean
}

export const usePosts = (options: UsePostManagementOptions = {}) => {
  const { autoFetch = true } = options

  /** List of published posts. */
  const list = ref<Post[]>([])
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  // Loading states for individual operations
  const isCreating = ref(false)
  const isUpdating = ref(false)
  const isDeleting = ref(false)

  // Utility function for error handling
  const handleError = (operation: string, err: any) => {
    console.error(`Failed to ${operation}:`, err)
    error.value = `Failed to ${operation}. Please try again.`
    
    // Clear error after 5 seconds
    setTimeout(() => {
      error.value = null
    }, 5000)
    
    throw err
  }

  // Fetch published posts only
  const fetchPosts = async () => {
    if (isLoading.value) return list.value

    isLoading.value = true
    error.value = null

    try {
      const data = await $fetch("/api/posts")
      list.value = data as unknown as Post[] ?? []
      return list.value
    } catch (err) {
      handleError('fetch posts', err)
      return []
    } finally {
      isLoading.value = false
    }
  }

  const createPost = async (payload: CreatePostPayload) => {
    if (isCreating.value) return

    isCreating.value = true
    error.value = null

    try {
      const newPost = await $fetch('/api/posts', {
        method: 'POST',
        body: payload,
      })

      // Only add to posts array if it's published (not draft)
      if (newPost.status !== 'draft') {
        list.value.unshift(newPost as Post)
      }

      return newPost
    } catch (err) {
      handleError('create post', err)
    } finally {
      isCreating.value = false
    }
  }

  const updatePost = async (payload: UpdatePostPayload) => {
    if (isUpdating.value) return

    isUpdating.value = true
    error.value = null

    try {
      const { post: updatedPost } = await $fetch<{ post: Post }>(`/api/posts/${payload.id}`, {
        method: "PUT",
        body: payload,
      })

      // Handle status changes
      const postIndex = list.value.findIndex(p => p.id === payload.id)

      // Remove from published posts if changed to draft or archived
      if ((updatedPost.status === 'draft' || updatedPost.status === 'archived') && postIndex !== -1) {
        list.value.splice(postIndex, 1)
      } else if (updatedPost.status === 'published') {
        postIndex !== -1
          // Update existing published post
          ? list.value[postIndex] = { ...list.value[postIndex], ...updatedPost }
          : list.value.unshift(updatedPost) // Was a draft/archived, now published - add to published posts
      }

      return updatedPost
    } catch (err) {
      handleError('update post', err)
    } finally {
      isUpdating.value = false
    }
  }

  const deletePost = async (postSlug: string) => {
    if (isDeleting.value) return

    isDeleting.value = true
    error.value = null

    try {
      await $fetch(`/api/posts/${postSlug}`, {
        method: 'DELETE' as any,
      })

      // Remove from published posts
      const postIndex = list.value.findIndex(p => p.slug === postSlug)
      if (postIndex !== -1) {
        list.value.splice(postIndex, 1)
      }

      return true
    } catch (err) {
      handleError('delete post', err)
      return false
    } finally {
      isDeleting.value = false
    }
  }

  // Utility functions
  const findPostBySlug = (postSlug: string): Post | undefined => {
    return list.value.find(p => p.slug === postSlug)
  }

  const refreshPosts = async () => {
    await fetchPosts()
  }

  // Optimistic updates for better UX
  const addPostOptimistically = (post: Post) => {
    if (post.status !== 'draft') {
      list.value.unshift(post)
    }
  }

  const removePostOptimistically = (postSlug: string) => {
    const postIndex = list.value.findIndex(p => p.slug === postSlug)
    if (postIndex !== -1) {
      list.value.splice(postIndex, 1)
    }
  }

  const updatePostOptimistically = (postSlug: string, updateData: Partial<Post>) => {
    const postIndex = list.value.findIndex(p => p.slug === postSlug)
    if (postIndex !== -1) {
      list.value[postIndex] = { ...list.value[postIndex], ...updateData }
    }
  }

  // Computed properties
  const totalPosts = computed(() => list.value.length)
  const hasPosts = computed(() => totalPosts.value > 0)
  const isAnyLoading = computed(() => 
    isLoading.value || isCreating.value || isUpdating.value || isDeleting.value
  )

  // Auto-fetch on composable initialization
  if (autoFetch) {
    fetchPosts()
  }

  return {
    // State (readonly)
    list,
    error: readonly(error),
    
    // Loading states
    isLoading: readonly(isLoading),
    isCreating: readonly(isCreating),
    isUpdating: readonly(isUpdating),
    isDeleting: readonly(isDeleting),
    isAnyLoading,

    // Computed
    totalPosts,
    hasPosts,

    // Methods
    fetchPosts,
    createPost,
    updatePost,
    deletePost,
    refreshPosts,

    // Utilities
    findPostBySlug,
    addPostOptimistically,
    removePostOptimistically,
    updatePostOptimistically,
  }
}

// Type for the composable return value
export type PostsComposable = ReturnType<typeof usePosts>