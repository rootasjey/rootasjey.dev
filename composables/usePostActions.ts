import type { CreatePostType, PostType } from '~/types/post'

export function usePostActions(dependencies: {
  posts: ReturnType<typeof usePosts>
  drafts: ReturnType<typeof useDrafts>
  dialogs: ReturnType<typeof usePostDialogs>
  categories: ReturnType<typeof usePostCategories>
}) {
  const { posts, drafts, dialogs, categories: categoryManagement } = dependencies

  const handleAddCategory = (newCategory: string) => {
    const result = categoryManagement.addCategory(newCategory)
    if (result.success) {
      toast({
        title: 'Category added',
        description: `Added category: ${result.category}`,
        duration: 5000,
        showProgress: true,
        toast: 'soft-success',
      })
      return
    }

    // Handle error
    console.error(`Failed to add category: ${result.error}`)
    toast({
      title: 'Failed to add category',
      description: result.error,
      duration: 5000,
      showProgress: true,
      toast: 'soft-error'
    })
  }

  const handleCreatePost = async (postData: CreatePostType) => {
    try {
      const newPost = await posts.createPost(postData)
      
      // Track category usage
      if (newPost && postData.category) {
        categoryManagement.incrementCategoryUsage(postData.category)
      }
      
      if (newPost && newPost.visibility === 'draft') {
        drafts.addDraft(newPost)
      }
    } catch (error: any) {
      console.error('Create post failed:', error)
      toast({
        title: 'Failed to create post',
        description: error && error.message ? error.message : 'Unknown error',
        duration: 5000,
        showProgress: true,
        toast: 'soft-error'
      })
    }
  }

  const handleUpdatePost = async (updateData: { 
    id: number
    name: string
    description: string
    category: string
    visibility: string
  }) => {
    try {
      const updatedPost = await posts.updatePost(updateData.id, updateData)

      if (updatedPost) {
        // Handle cross-composable state sync
        if (updateData.visibility === 'draft') {
          // Add/update in drafts, remove from posts (handled by postManagement)
          drafts.updateDraft(updatedPost.id, updatedPost)
        } else {
          // Remove from drafts if published, add to posts (handled by postManagement)
          drafts.removeDraft(updatedPost.id)
        }
        
        if (updatedPost.category) {
          categoryManagement.incrementCategoryUsage(updatedPost.category)
        }
      }
    } catch (error: any) {
      console.error('Update post failed:', error)
      toast({
        title: 'Failed to update post',
        description: error && error.message ? error.message : 'Unknown error',
        duration: 5000,
        showProgress: true,
        toast: 'soft-error'
      })
    }
  }

  const handleDeletePost = async (post: PostType) => {
    try {
      await posts.deletePost(post.id as number)
      
      // Remove from drafts if it was a draft
      if (post.visibility === 'draft') {
        drafts.removeDraft(post.id)
      }
    } catch (error: any) {
      console.error('Delete post failed:', error)
      toast({
        title: 'Failed to delete post',
        description: error && error.message ? error.message : 'Unknown error',
        duration: 5000,
        showProgress: true,
        toast: 'soft-error'
      })
    }
  }

  const handleDuplicatePost = async (post: PostType) => {
    try {
      await handleCreatePost({
        name: `${post.name} (Copy-${new Date().getTime()})`,
        description: post.description,
        category: post.category,
      })
    } catch (error: any) {
      console.error('Failed to duplicate post:', error)
      toast({
        title: 'Failed to duplicate post',
        description: error && error.message ? error.message : 'Unknown error',
        duration: 5000,
        showProgress: true,
        toast: 'soft-error'
      })
    }
  }

  const handlePublishDraft = async (draft: PostType) => {
    try {
      await handleUpdatePost({
        id: draft.id as number,
        name: draft.name,
        description: draft.description,
        category: draft.category,
        visibility: 'public'
      })
    } catch (error: any) {
      console.error('Failed to publish draft:', error)
      toast({
        title: 'Failed to publish draft',
        description: error && error.message ? error.message : 'Unknown error',
        duration: 5000,
        showProgress: true,
        toast: 'soft-error'
      })
    }
  }

  const handleUnpublishPost = async (post: PostType) => {
    try {
      await handleUpdatePost({
        id: post.id,
        name: post.name,
        description: post.description,
        category: post.category,
        visibility: 'draft'
      })
      
      // Move from published to drafts
      drafts.addDraft({ ...post, visibility: 'draft' })
    } catch (error: any) {
      console.error('Failed to unpublish post:', error)
      toast({
        title: 'Failed to unpublish post',
        description: error && error.message ? error.message : 'Unknown error',
        duration: 5000,
        showProgress: true,
        toast: 'soft-error'
      })
    }
  }

  const handleArchivePost = async (post: PostType) => {
    try {
      await handleUpdatePost({
        id: post.id,
        name: post.name,
        description: post.description,
        category: post.category,
        visibility: 'archive',
      })
    } catch (error: any) {
      console.error('Failed to archive post:', error)
      toast({
        title: 'Failed to archive post',
        description: error && error.message ? error.message : 'Unknown error',
        duration: 5000,
        showProgress: true,
        toast: 'soft-error'
      })
    }
  }

  const handleSharePost = (post: PostType) => {
    const url = `${window.location.origin}/reflexions/${post.slug}`
    
    if (navigator.share) {
      navigator.share({
        title: post.name,
        text: post.description,
        url: url
      })
      return
    }

    // Fallback: copy to clipboard
    navigator.clipboard.writeText(url).then(() => {
      toast({
        title: 'Link copied to clipboard',
        duration: 5000,
        showProgress: true,
        toast: 'soft-success'
      })
    })
  }

  const handleExportPost = (post: PostType) => {
    const exportData = {
      name: post.name,
      description: post.description,
      category: post.category,
      content: post.article,
      created_at: post.created_at,
      updated_at: post.updated_at
    }
    
    const blob = new Blob([JSON.stringify(exportData, null, 2)], {
      type: 'application/json'
    })
    
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `${post.slug || post.id}-export.json`
    document.body.appendChild(a)
    a.click()
    document.body.removeChild(a)
    URL.revokeObjectURL(url)

    toast({
      title: 'Post exported',
      duration: 5000,
      showProgress: true,
      toast: 'soft-success'
    })
  }

  const handleBulkArchiveDrafts = async () => {
    const confirmArchive = confirm('Archive all drafts? This will make them private.')
    if (!confirmArchive) return
    
    try {
      for (const draft of drafts.list.value) {
        await handleUpdatePost({
          id: draft.id,
          name: draft.name,
          description: draft.description,
          category: draft.category,
          visibility: 'private',
        })
      }
      
      // Clear drafts after archiving
      drafts.clearAllDrafts()
    } catch (error) {
      console.error('Failed to archive drafts:', error)
    }
  }

  const handleBulkExport = () => {
    const exportData = posts.list.value.map(post => ({
      name: post.name,
      description: post.description,
      category: post.category,
      content: post.article,
      created_at: post.created_at,
      updated_at: post.updated_at
    }))
    
    const blob = new Blob([JSON.stringify(exportData, null, 2)], {
      type: 'application/json'
    })
    
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `all-posts-export-${new Date().toISOString().split('T')[0]}.json`
    document.body.appendChild(a)
    a.click()
    document.body.removeChild(a)
    URL.revokeObjectURL(url)
  }

  const formatLastUpdated = (posts: PostType[]) => {
    if (posts.length === 0) return 'never'
    
    const latestUpdate = Math.max(...posts.map(p => new Date(p.updated_at).getTime()))
    const date = new Date(latestUpdate)
    const now = new Date()
    const diffInHours = (now.getTime() - date.getTime()) / (1000 * 60 * 60)
    
    if (diffInHours < 1) return 'just now'
    if (diffInHours < 24) return `${Math.floor(diffInHours)}h ago`
    if (diffInHours < 24 * 7) return `${Math.floor(diffInHours / 24)}d ago`
    
    return date.toLocaleDateString()
  }

  const handleViewStats = (post: PostType) => {
    // Navigate to stats page or open stats modal
    navigateTo(`/reflexions/${post.slug}/stats`)
  }

  const handleRetryError = () => {
    if (posts.error.value) {
      posts.fetchPosts()
    }
    if (drafts.draftsError.value) {
      drafts.retryFetchDrafts()
    }
  }

  return {
    // CRUD operations
    handleCreatePost,
    handleUpdatePost,
    handleDeletePost,
    
    // State transitions
    handlePublishDraft,
    handleUnpublishPost,
    handleArchivePost,
    
    // Utility actions
    handleDuplicatePost,
    handleSharePost,
    handleExportPost,
    
    // Bulk operations
    handleBulkArchiveDrafts,
    handleBulkExport,
    
    // Helpers
    formatLastUpdated,
    handleViewStats,
    handleAddCategory,
    handleRetryError,
  }
}