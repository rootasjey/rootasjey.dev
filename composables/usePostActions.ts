import type { CreatePostType, PostType } from '~/types/post'

export function usePostActions(dependencies: {
  posts: ReturnType<typeof usePosts>
  drafts: ReturnType<typeof useDrafts>
  dialogs: ReturnType<typeof usePostDialogs>
  tags: ReturnType<typeof useTags>
}) {
  const { posts, drafts, dialogs, tags: tagManagement } = dependencies

  const handleAddTag = (newTag: string) => {
    const result = tagManagement.addTag(newTag)
    if (result.success) {
      toast({
        title: 'Tag added',
        description: `Added tag: ${result.tag}`,
        duration: 5000,
        showProgress: true,
        toast: 'soft-success',
      })
      return
    }

    // Handle error
    console.error(`Failed to add tag: ${result.error}`)
    toast({
      title: 'Failed to add tag',
      description: result.error,
      duration: 5000,
      showProgress: true,
      toast: 'soft-error'
    })
  }

  const handleCreatePost = async (postData: CreatePostType) => {
    try {
      const newPost = await posts.createPost(postData)
      
      // Track tag usage
      if (newPost && postData.tags && postData.tags.length > 0) {
        tagManagement.incrementPostTagsUsage(postData.tags)
      }
      
      if (newPost && newPost.status === 'draft') {
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
    tags: string[]
    status: 'draft' | 'published' | 'archived'
  }) => {
    try {
      // Get the original post to track tag usage changes
      const originalPost = posts.list.value.find(p => p.id === updateData.id) || 
                          drafts.list.value.find(p => p.id === updateData.id)

      const updatedPost = await posts.updatePost(updateData.id, updateData)
      if (!updatedPost) return

      // Handle tag usage tracking
      if (originalPost && originalPost.tags) {
        // Decrement usage for old tags
        tagManagement.decrementPostTagsUsage(originalPost.tags)
      }
      
      if (updatedPost.tags && updatedPost.tags.length > 0) {
        // Increment usage for new tags
        tagManagement.incrementPostTagsUsage(updatedPost.tags)
      }

      // Handle cross-composable state sync
      // Add/update in drafts, remove from posts (handled by postManagement)
      // Remove from drafts if published, add to posts (handled by postManagement)
      updateData.status === 'draft'
        ? drafts.updateDraft(updatedPost.id, updatedPost)
        : drafts.removeDraft(updatedPost.id)
      
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
      
      // Decrement tag usage when deleting post
      if (post.tags && post.tags.length > 0) {
        tagManagement.decrementPostTagsUsage(post.tags)
      }
      
      if (post.status === 'draft') {
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
        tags: post.tags ? [...post.tags] : [], // Copy tags array
        status: post.status,
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
        id: draft.id,
        name: draft.name,
        description: draft.description,
        tags: draft.tags || [],
        status: 'published',
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
        tags: post.tags || [],
        status: 'draft'
      })
      
      // Move from published to drafts
      drafts.addDraft({ ...post, status: 'draft' })
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
        tags: post.tags || [],
        status: 'archived',
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
    const url = `${window.location.origin}/posts/${post.slug}`
    
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
      tags: post.tags || [],
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
          tags: draft.tags || [],
          status: 'draft',
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
      tags: post.tags || [],
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
    navigateTo(`/posts/${post.slug}/stats`)
  }

  const handleRetryError = () => {
    if (posts.error.value) {
      posts.fetchPosts()
    }
    if (drafts.draftsError.value) {
      drafts.retryFetchDrafts()
    }
  }

  // Tag-specific utility functions
  const getPostPrimaryTag = (post: PostType): string | undefined => {
    return tagManagement.getPrimaryTag(post.tags)
  }

  const getPostSecondaryTags = (post: PostType): string[] => {
    return tagManagement.getSecondaryTags(post.tags)
  }

  const hasPostSecondaryTags = (post: PostType): boolean => {
    return tagManagement.hasSecondaryTags(post.tags)
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
    handleAddTag,
    handleRetryError,
    
    // Tag utilities
    getPostPrimaryTag,
    getPostSecondaryTags,
    hasPostSecondaryTags,
  }
}