<template>
  <div class="w-[600px] rounded-xl p-8 pb-[38vh] flex flex-col transition-all duration-500 overflow-y-auto">
    <PostHeader
      :is-loading="isAnyLoading"
      :error="combinedErrorMessage"
      :categories="categoryManagement.allCategories.value"
      :show-dialogs="loggedIn"
      :create-dialog-model="dialogs.createDialogModel.value"
      :edit-dialog-model="dialogs.editDialogModel.value"
      :delete-dialog-model="dialogs.deleteDialogModel.value"
      :editing-post="dialogs.editingPost.value"
      :deleting-post="dialogs.deletingPost.value"
      @create-post="handleCreatePost"
      @update-post="handleUpdatePost"
      @delete-post="handleDeletePost"
      @add-category="handleAddCategory"
      @retry-error="handleRetryError"
      @update:create-dialog-model="dialogs.createDialogModel.value = $event"
      @update:edit-dialog-model="dialogs.editDialogModel.value = $event"
      @update:delete-dialog-model="dialogs.deleteDialogModel.value = $event"
    />

    <!-- Drafts Section -->
    <PostSection
      v-if="loggedIn"
      :posts="drafts.list.value"
      title="Drafts"
      section-type="Draft"
      icon="i-icon-park-outline:notebook-and-pen"
      icon-color="#f59e0b"
      :collapsible="true"
      :expanded="drafts.showDrafts.value"
      :is-loading="drafts.isFetchingDrafts.value"
      :error="drafts.draftsError.value"
      :show-draft-badge="true"
      :show-status-indicator="true"
      :show-refresh-action="true"
      :show-add-action="true"
      empty-state-title="No drafts yet"
      empty-state-description="Start writing a new post to create your first draft."
      empty-action-text="Write New Post"
      empty-action-icon="i-lucide-pen-tool"
      @toggle="drafts.toggleDrafts"
      @refresh="drafts.refreshDrafts"
      @add="dialogs.openCreateDialog"
      @retry="drafts.retryFetchDrafts"
      @empty-action="dialogs.openCreateDialog"
      @edit="dialogs.openEditDialog"
      @delete="dialogs.openDeleteDialog"
      @publish="handlePublishDraft"
      @duplicate="handleDuplicatePost"
    >
      <template #actions="{ posts: draftPosts, isLoading }">
        <div class="flex items-center gap-2">
          <UButton
            size="xs"
            btn="ghost dark:soft-gray"
            class="dark:color-#f59e0b"
            :loading="isLoading"
            @click="drafts.refreshDrafts"
          >
            <UIcon name="i-ph-arrows-counter-clockwise-duotone" />
            <span>Refresh</span>
          </UButton>
          
          <UButton
            size="xs"
            btn="ghost dark:soft-gray"
            class="dark:color-#f59e0b"
            @click="dialogs.openCreateDialog"
          >
            <UIcon name="i-lucide-pen-tool" />
            <span>New Draft</span>
          </UButton>

          <UButton
            v-if="draftPosts.length > 0"
            size="xs"
            btn="ghost dark:soft-gray"
            class="dark:color-#f59e0b"
            @click="handleBulkArchiveDrafts"
          >
            <UIcon name="i-lucide-archive" />
            <span>Archive</span>
          </UButton>
        </div>
      </template>

      <template #footer="{ posts: draftPosts, totalCount }">
        <div v-if="totalCount > 0" class="text-xs text-gray-500 dark:text-gray-400 text-center">
          {{ totalCount }} draft{{ totalCount === 1 ? '' : 's' }} • 
          Last updated {{ formatLastUpdated(draftPosts) }}
        </div>
      </template>
    </PostSection>

    <!-- Published Posts Section -->
    <PostSection
      :posts="posts.list.value"
      title="Published"
      section-type="Post"
      icon="i-ph-article"
      icon-color="#3b82f6"
      :is-loading="posts.isLoading.value"
      :error="posts.error.value"
      :show-category="true"
      :show-word-count="true"
      :show-draft-badge="false"
      :show-refresh-action="true"
      empty-state-title="No published posts yet"
      empty-state-description="Your published posts will appear here once you start sharing your thoughts with the world."
      empty-action-text="Publish First Post"
      empty-action-icon="i-lucide-send"
      @refresh="posts.fetchPosts"
      @retry="posts.fetchPosts"
      @empty-action="dialogs.openCreateDialog"
      @edit="dialogs.openEditDialog"
      @delete="dialogs.openDeleteDialog"
      @unpublish="handleUnpublishPost"
      @duplicate="handleDuplicatePost"
      @archive="handleArchivePost"
      @share="handleSharePost"
      @export="handleExportPost"
      @view-stats="handleViewStats"
    >
      <template #actions="{ posts: publishedPosts }">
        <div class="flex items-center gap-2">
          <UButton
            btn="ghost dark:soft-gray"
            size="xs"
            class="dark:color-#3b82f6"
            :loading="posts.isLoading.value"
            @click="posts.fetchPosts"
          >
            <UIcon name="i-ph-arrows-counter-clockwise-duotone" />
            <span>Refresh</span>
          </UButton>

          <UButton
            v-if="publishedPosts.length > 0"
            btn="ghost dark:soft-gray"
            size="xs"
            class="dark:color-#3b82f6"
            @click="handleBulkExport"
          >
            <UIcon name="i-lucide-download" />
            <span>Export All</span>
          </UButton>
        </div>
      </template>

      <template #footer="{ totalCount }">
        <div v-if="totalCount > 0" class="text-xs text-gray-500 dark:text-gray-400 text-center">
          {{ totalCount }} published post{{ totalCount === 1 ? '' : 's' }}
        </div>
      </template>
    </PostSection>

    <PostEmptyState v-if="!hasAnyContent && !isAnyLoading" />

    <Footer>
      <template #links>
        <ULink to="/projects" class="footer-button flex items-center gap-2 text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200 transition-colors">
          <span class="i-ph-app-window text-size-3 -mt-1"></span>
          <span class="font-500 text-size-3 relative -top-0.5">See projects</span>
        </ULink>
      </template>
    </Footer>
  </div>
</template>

<script lang="ts" setup>
useHead({
  title: "rootasjey • reflexions",
  meta: [
    {
      name: 'description',
      content: "A space for thoughts and insights",
    },
  ],
})

import type { CreatePostType, PostType } from '~/types/post'

const { loggedIn } = useUserSession()
const dialogs = usePostDialogs()
const drafts = useDrafts({ autoFetch: true })
const posts = usePosts()

const hasAnyContent = computed(() => 
  posts.hasPosts.value || drafts.hasDrafts.value
)

const isAnyLoading = computed(() => 
  posts.isAnyLoading.value || drafts.isFetchingDrafts.value
)

const hasAnyError = computed(() => 
  posts.error.value || drafts.draftsError.value
)

const categoryManagement = usePostCategories({
  defaultCategories: [
    "Tech",
    "Development",
    "Cinema", 
    "Literature",
    "Music",
  ],
  autoSave: true,
  caseSensitive: false
})

const combinedErrorMessage = computed(() => {
  const errors = []
  if (posts.error.value) errors.push(posts.error.value)
  if (drafts.draftsError.value) errors.push(drafts.draftsError.value)
  return errors.length > 0 ? errors.join('; ') : null
})

const handleRetryError = () => {
  if (posts.error.value) {
    posts.fetchPosts()
  }
  if (drafts.draftsError.value) {
    drafts.retryFetchDrafts()
  }
}

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

    // Track category usage
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
    handleCreatePost({
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
    handleUpdatePost({
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
      handleUpdatePost({
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

onBeforeRouteLeave(() => {
  if (dialogs.hasOpenDialog.value) {
    dialogs.closeAllDialogs()
  }
})

onBeforeRouteLeave((leaveGuard) => {
  if (dialogs.hasOpenDialog.value) {
    const answer = window.confirm(
      'You have an open dialog. Are you sure you want to leave?'
    )
    // cancel the navigation and stay on the same page
    if (!answer) return false
  }
})
</script>
