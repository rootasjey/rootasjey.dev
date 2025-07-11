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

    <PostsEmptyState v-if="!hasAnyContent && !isAnyLoading" class="w-3xl mt-12" />

    <TagManagementModal
      v-model:open="showTagManagement"
      :posts="allPosts"
      @tags-updated="handleTagsUpdated"
    />

    <Footer class="mt-24 mb-36 w-[720px] mx-auto" />
  </div>
</template>

<script lang="ts" setup>
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

  if (typeof window !== 'undefined') {
    try {
      localStorage.setItem(POSTS_TAB_STORAGE_KEY, tabValue)
    } catch (error) {
      console.warn('Failed to save tab state to localStorage:', error)
    }
  }
}

const tagsStore = useTagStore()
await tagsStore.fetchTags()

const allPosts = computed(() => [
  ...posts.list.value,
  ...drafts.list.value,
  ...archivedPosts.list.value
])

const handleTagsUpdated = async () => {
  await tagsStore.fetchTags()
}

const actions = usePostActions({
  posts,
  drafts,
  dialogs,
  tags: tagsStore,
})

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
