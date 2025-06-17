<template>
  <div class="w-[600px] rounded-xl p-8 pb-[38vh] flex flex-col transition-all duration-500 overflow-y-auto">
    <PostHeader
      :is-loading="isAnyLoading"
      :error="combinedErrorMessage"
      :categories="categories.allCategories.value"
      :show-dialogs="loggedIn"
      :create-dialog-model="dialogs.createDialogModel.value"
      :edit-dialog-model="dialogs.editDialogModel.value"
      :delete-dialog-model="dialogs.deleteDialogModel.value"
      :editing-post="dialogs.editingPost.value"
      :deleting-post="dialogs.deletingPost.value"
      @create-post="actions.handleCreatePost"
      @update-post="actions.handleUpdatePost"
      @delete-post="actions.handleDeletePost"
      @add-category="actions.handleAddCategory"
      @retry-error="actions.handleRetryError"
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
      menu-variant="minimal"
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

const categories = usePostCategories({
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

const actions = usePostActions({
  posts,
  drafts,
  dialogs,
  categories,
})

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
  return errors.length > 0 ? errors.join('; ') : null
})

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
