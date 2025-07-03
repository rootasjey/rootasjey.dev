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

    <!-- Drafts Section -->
    <PostsSection
      v-if="loggedIn"
      class="w-[720px]"
      :posts="drafts.list.value"
      title="Drafts"
      section-type="Draft"
      icon="i-icon-park-outline:notebook-and-pen"
      icon-color="#f59e0b"
      menu-variant="minimal"
      :collapsible="true"
      :expanded="drafts.showDrafts.value"
      :is-loading="drafts.isFetchingDrafts.value"
      :error="drafts.draftsError.value"
      :show-draft-badge="true"
      :show-status-indicator="true"
      :show-refresh-action="true"
      :show-add-action="true"
      :show-primary-tag="true"
      :show-secondary-tags="true"
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
      @publish="actions.handlePublishDraft"
      @duplicate="actions.handleDuplicatePost"
    >
      <template #actions="{ posts: draftPosts, isLoading }">
        <div class="flex items-center gap-2">
          <UButton
            size="xs"
            btn="soft-gray"
            class="dark:color-#f59e0b"
            :loading="isLoading"
            @click="drafts.refreshDrafts"
          >
            <UIcon name="i-ph-arrows-counter-clockwise-duotone" />
            <span>Refresh</span>
          </UButton>
          
          <UButton
            size="xs"
            btn="soft-gray"
            class="dark:color-#f59e0b"
            @click="dialogs.openCreateDialog"
          >
            <UIcon name="i-lucide-pen-tool" />
            <span>New Draft</span>
          </UButton>

          <UButton
            v-if="draftPosts.length > 0"
            size="xs"
            btn="soft-gray"
            class="dark:color-#f59e0b"
            @click="actions.handleBulkArchiveDrafts"
          >
            <UIcon name="i-lucide-archive" />
            <span>Archive</span>
          </UButton>
        </div>
      </template>

      <template #footer="{ posts: draftPosts, totalCount }">
        <div v-if="totalCount > 0" class="text-xs text-gray-500 dark:text-gray-400 text-center">
          {{ totalCount }} draft{{ totalCount === 1 ? '' : 's' }} • 
          Last updated {{ actions.formatLastUpdated(draftPosts) }}
        </div>
      </template>
    </PostsSection>

    <!-- Published Posts Section -->
    <PostsSection
      :posts="posts.list.value"
      title="Published"
      section-type="Post"
      class="w-[720px]"
      icon="i-ph-article"
      icon-color="#3b82f6"
      menu-variant="minimal"
      :is-loading="posts.isLoading.value"
      :error="posts.error.value"
      :show-primary-tag="true"
      :show-secondary-tags="true"
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
      @unpublish="actions.handleUnpublishPost"
      @duplicate="actions.handleDuplicatePost"
      @archive="actions.handleArchivePost"
      @share="actions.handleSharePost"
      @export="actions.handleExportPost"
      @view-stats="actions.handleViewStats"
    >
      <template #actions="{ posts: publishedPosts }">
        <div class="flex items-center gap-2">
          <UButton
            btn="soft-gray"
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
            btn="soft-gray"
            size="xs"
            class="dark:color-#3b82f6"
            @click="actions.handleBulkExport"
          >
            <UIcon name="i-lucide-download" />
            <span>Export All</span>
          </UButton>

          <!-- Tag Management Button -->
          <UButton
            v-if="loggedIn"
            btn="soft-gray"
            size="xs"
            class="dark:color-#3b82f6"
            @click="showTagManagement = true"
          >
            <UIcon name="i-lucide-tags" />
            <span>Manage Tags</span>
          </UButton>
        </div>
      </template>

      <template #footer="{ totalCount }">
        <div v-if="totalCount > 0" class="text-xs text-gray-500 dark:text-gray-400 text-center">
          {{ totalCount }} published post{{ totalCount === 1 ? '' : 's' }}
          <span v-if="tagStats.total > 0" class="mx-2">•</span>
          <span v-if="tagStats.total > 0">
            {{ tagStats.total }} tag{{ tagStats.total === 1 ? '' : 's' }} available
          </span>
        </div>
      </template>
    </PostsSection>

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

// UI state
const showTagManagement = ref(false)

const hasAnyContent = computed(() => 
  posts.hasPosts.value || drafts.hasDrafts.value
)

const isAnyLoading = computed(() => 
  posts.isAnyLoading.value || drafts.isFetchingDrafts.value
)

const hasAnyError = computed(() => 
  posts.error.value || drafts.draftsError.value
)

const combinedErrorMessage = computed(() => {
  const errors = []
  if (posts.error.value) errors.push(posts.error.value)
  if (drafts.draftsError.value) errors.push(drafts.draftsError.value)
  return errors.length > 0 ? errors.join('; ') : undefined
})

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
