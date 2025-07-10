<template>
  <div class="w-full flex flex-col items-center min-h-screen">
    <PostsHeader
      :is-loading="isAnyLoading"
      :error="combinedErrorMessage"
      :show-dialogs="loggedIn"
      :create-dialog-model="dialogs.createDialogModel.value"
      :edit-dialog-model="dialogs.editDialogModel.value"
      :delete-dialog-model="dialogs.deleteDialogModel.value"
      :editing-post="dialogs.editingPost.value"
      :deleting-post="dialogs.deletingPost.value"
      @create-post="actions.handleCreatePost"
      @update-post="actions.handleUpdatePost"
      @delete-post="actions.handleDeletePost"
      @retry-error="actions.handleRetryError"
      @update:create-dialog-model="dialogs.createDialogModel.value = $event"
      @update:edit-dialog-model="dialogs.editDialogModel.value = $event"
      @update:delete-dialog-model="dialogs.deleteDialogModel.value = $event"
    />

    <!-- Posts Tabs Interface -->
    <PostsTabs
      :published-posts="posts.list.value"
      :draft-posts="drafts.list.value"
      :archived-posts="archivedPosts.list.value"
      :is-published-loading="posts.isLoading.value"
      :is-drafts-loading="drafts.isFetchingDrafts.value"
      :is-archived-loading="archivedPosts.isFetchingArchived.value"
      :published-error="posts.error.value"
      :drafts-error="drafts.draftsError.value"
      :archived-error="archivedPosts.archivedError.value"
      :logged-in="loggedIn"
      :default-tab="defaultTab"
      @tab-change="handleTabChange"
      @create-post="dialogs.openCreateDialog"
      @edit="dialogs.openEditDialog"
      @delete="dialogs.openDeleteDialog"
      @publish="actions.handlePublishDraft"
      @unpublish="actions.handleUnpublishPost"
      @archive="actions.handleArchivePost"
      @unarchive="handleUnarchivePost"
      @duplicate="actions.handleDuplicatePost"
      @share="actions.handleSharePost"
      @export="actions.handleExportPost"
      @view-stats="actions.handleViewStats"
      @refresh-published="posts.fetchPosts"
      @refresh-drafts="drafts.refreshDrafts"
      @refresh-archived="archivedPosts.refreshArchived"
      @retry-published="posts.fetchPosts"
      @retry-drafts="drafts.retryFetchDrafts"
      @retry-archived="archivedPosts.retryFetchArchived"
      @bulk-export="actions.handleBulkExport"
      @bulk-archive-drafts="actions.handleBulkArchiveDrafts"
      @bulk-restore-archived="handleBulkRestoreArchived"
      @manage-tags="showTagManagement = true"
      @post-status-change="handlePostStatusChange"
    />

    <!-- Empty State (shown when no content in any tab) -->
    <PostsEmptyState v-if="!hasAnyContent && !isAnyLoading" class="w-3xl mt-12" />

    <!-- Tag Management Modal -->
    <UDialog v-model:open="showTagManagement" title="Tag Management" description="Manage your post tags">
      <div class="space-y-4">
        <!-- Tag Statistics -->
        <div class="grid grid-cols-2 gap-4">
          <div class="bg-gray-50 dark:bg-gray-800 p-3 rounded-lg">
            <div class="text-sm font-medium text-gray-700 dark:text-gray-300">Total Tags</div>
            <div class="text-2xl font-bold text-gray-900 dark:text-white">{{ tagStats.total }}</div>
          </div>
          <div class="bg-gray-50 dark:bg-gray-800 p-3 rounded-lg">
            <div class="text-sm font-medium text-gray-700 dark:text-gray-300">Custom Tags</div>
            <div class="text-2xl font-bold text-gray-900 dark:text-white">{{ tagStats.custom }}</div>
          </div>
        </div>

        <!-- Popular Tags -->
        <div v-if="popularTags.length > 0">
          <h4 class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Popular Tags</h4>
          <div class="flex flex-wrap gap-2">
            <UBadge
              v-for="tag in popularTags.slice(0, 10)"
              :key="tag.name"
              :label="`${tag} (${getTagUsage(tag)})`"
              color="blue"
              variant="outline"
              size="sm"
            />
          </div>
        </div>

        <!-- Unused Tags -->
        <div v-if="unusedTags.length > 0">
          <h4 class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Unused Tags</h4>
          <div class="flex flex-wrap gap-2">
            <UBadge
              v-for="tag in unusedTags.slice(0, 10)"
              :key="tag.name"
              :label="tag.name"
              color="gray"
              variant="outline"
              size="sm"
            />
          </div>
          <UButton
            v-if="unusedTags.length > 0"
            btn="outline"
            size="xs"
            class="mt-2"
            @click="handleClearUnusedTags"
          >
            Clear Unused Tags
          </UButton>
        </div>
      </div>

      <template #footer>
        <div class="flex gap-2 justify-end">
          <UButton 
            @click="showTagManagement = false" 
            btn="outline" 
            label="Close"
          />
          <UButton 
            @click="handleExportTags" 
            btn="soft"
            label="Export Tags" 
          />
        </div>
      </template>
    </UDialog>

    <Footer class="mt-24 mb-36 w-[720px] mx-auto" />
  </div>
</template>

<script lang="ts" setup>
import type { ApiTag } from '~/types/tag'
import type { Post } from '~/types/post'

useHead({
  title: "root • posts",
  meta: [
    {
      name: 'description',
      content: "A space for thoughts and insights",
    },
  ],
})

const { loggedIn } = useUserSession()
const dialogs = usePostDialogs()
const drafts = useDrafts({ autoFetch: loggedIn.value, disabled: !loggedIn.value })
const posts = usePosts()
const archivedPosts = useArchivedPosts({ autoFetch: loggedIn.value, disabled: !loggedIn.value })

// Tab management with persistence
const POSTS_TAB_STORAGE_KEY = 'posts-selected-tab'

// Initialize tab state with persistence
const getStoredTab = (): 'published' | 'drafts' | 'archived' => {
  if (typeof window !== 'undefined') {
    try {
      const stored = localStorage.getItem(POSTS_TAB_STORAGE_KEY)
      if (stored && ['published', 'drafts', 'archived'].includes(stored)) {
        return stored as 'published' | 'drafts' | 'archived'
      }
    } catch (error) {
      console.warn('Failed to read tab state from localStorage:', error)
    }
  }
  return 'published' // Default fallback
}

const defaultTab = ref<'published' | 'drafts' | 'archived'>('published')

// Restore tab state on client-side mount
onMounted(() => {
  const storedTab = getStoredTab()
  defaultTab.value = storedTab
})

const handleTabChange = (tab: string) => {
  const tabValue = tab as 'published' | 'drafts' | 'archived'
  defaultTab.value = tabValue

  // Persist tab selection to localStorage
  if (typeof window !== 'undefined') {
    try {
      localStorage.setItem(POSTS_TAB_STORAGE_KEY, tabValue)
    } catch (error) {
      console.warn('Failed to save tab state to localStorage:', error)
    }
  }
}

const tagsStore = useTagsStore()
await tagsStore.fetchTags()

// Tag statistics and helpers for API-driven tags
const tagStats = computed(() => {
  const all = tagsStore.allTags
  return {
    total: all.length,
    custom: all.filter(t => t.category === 'custom').length,
  }
})

const popularTags = computed(() => {
  // Count tag usage in all posts
  const tagCounts: Record<number, number> = {}
  posts.list.value.forEach(post => {
    post.tags?.forEach(tag => {
      tagCounts[tag.id] = (tagCounts[tag.id] || 0) + 1
    })
  })
  // Sort tags by usage
  return tagsStore.allTags
    .map(tag => ({ ...tag, count: tagCounts[tag.id] || 0 }))
    .sort((a, b) => b.count - a.count)
    .filter(t => t.count > 0)
})

const unusedTags = computed(() => {
  const usedTagIds = new Set(posts.list.value.flatMap(post => post.tags?.map(t => t.id) || []))
  return tagsStore.allTags.filter(tag => !usedTagIds.has(tag.id))
})

const getTagUsage = (tag: ApiTag) => {
  return posts.list.value.reduce((acc, post) => acc + (post.tags?.some(t => t.id === tag.id) ? 1 : 0), 0)
}

const actions = usePostActions({
  posts,
  drafts,
  dialogs,
  tags: tagsStore,
})

// Additional action handlers for archived posts
const handleUnarchivePost = async (post: Post) => {
  try {
    await actions.handleUpdatePost({
      id: post.id,
      name: post.name,
      description: post.description,
      tags: post.tags || [],
      slug: post.slug || '',
      status: 'draft'
    })

    // Move from archived to drafts
    archivedPosts.removeArchivedPost(post.id)
    drafts.addDraft({ ...post, status: 'draft' })
  } catch (error: any) {
    console.error('Failed to unarchive post:', error)
  }
}

const handleBulkRestoreArchived = async () => {
  const confirmRestore = confirm('Restore all archived posts to drafts?')
  if (!confirmRestore) return

  try {
    for (const post of archivedPosts.list.value) {
      await handleUnarchivePost(post)
    }
  } catch (error) {
    console.error('Failed to restore archived posts:', error)
  }
}

// UI state
const showTagManagement = ref(false)

const hasAnyContent = computed(() =>
  posts.hasPosts.value || drafts.hasDrafts.value || archivedPosts.hasArchived.value
)

const isAnyLoading = computed(() =>
  posts.isAnyLoading.value || drafts.isFetchingDrafts.value || archivedPosts.isFetchingArchived.value
)

const combinedErrorMessage = computed(() => {
  const errors = []
  if (posts.error.value) errors.push(posts.error.value)
  if (drafts.draftsError.value) errors.push(drafts.draftsError.value)
  return errors.length > 0 ? errors.join('; ') : undefined
})

// Drag and drop handler
const handlePostStatusChange = async (post: Post, newStatus: 'draft' | 'published' | 'archived') => {
  try {
    await actions.handleUpdatePost({
      id: post.id,
      name: post.name,
      description: post.description,
      tags: post.tags || [],
      slug: post.slug || '',
      status: newStatus
    })

    // Refresh the appropriate lists
    if (newStatus === 'published' || post.status === 'published') {
      posts.fetchPosts()
    }
    if (newStatus === 'draft' || post.status === 'draft') {
      drafts.refreshDrafts()
    }
    if (newStatus === 'archived' || post.status === 'archived') {
      archivedPosts.refreshArchived()
    }
  } catch (error: any) {
    console.error('Failed to update post status via drag and drop:', error)
    toast({
      title: 'Failed to update post status',
      description: error?.message || 'Unknown error occurred',
      duration: 5000,
      showProgress: true,
      toast: 'soft-error'
    })
  }
}

// Tag management methods
const handleClearUnusedTags = async () => {
  const confirmClear = confirm('Remove all unused tags? This action cannot be undone.')
  if (!confirmClear) return
  const unused = unusedTags.value
  for (const tag of unused) {
    await tagsStore.deleteTag(tag.id)
  }
  tagsStore.fetchTags()
  toast({
    title: 'Unused tags cleared',
    description: `Removed ${unused.length} unused tags`,
    duration: 5000,
    showProgress: true,
    toast: 'soft-success'
  })
}

const handleExportTags = () => {
  const exportData = tagsStore.allTags
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
    title: 'Tags exported',
    duration: 5000,
    showProgress: true,
    toast: 'soft-success'
  })
}

onBeforeRouteLeave(() => {
  if (dialogs.hasOpenDialog.value) {
    dialogs.closeAllDialogs()
  }
})

onBeforeRouteLeave(() => {
  if (dialogs.hasOpenDialog.value) {
    const answer = window.confirm(
      'You have an open dialog. Are you sure you want to leave?'
    )
    // cancel the navigation and stay on the same page
    if (!answer) return false
  }
})
</script>
