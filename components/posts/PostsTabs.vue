<template>
  <div class="w-full max-w-4xl mx-auto">
    <!-- Tabs Navigation -->
    <UTabs
      :default-value="defaultTab"
      :model-value="activeTab"
      @update:model-value="handleTabChange"
      class="w-full"
    >
      <UTabsList class="grid grid-cols-3 mb-6">
        <UTabsTrigger
          value="published"
          :leading="publishedIcon"
          :class="publishedDropZoneClasses"
          @dragover="handlePublishedDragOver"
          @dragenter="handlePublishedDragEnter"
          @dragleave="handlePublishedDragLeave"
          @drop="handlePublishedDrop"
        >
          Published
          <UBadge
            v-if="publishedCount > 0"
            variant="soft"
            color="blue"
            size="xs"
            class="ml-2"
          >
            {{ publishedCount }}
          </UBadge>
        </UTabsTrigger>

        <UTabsTrigger
          v-if="loggedIn"
          value="drafts"
          :leading="draftsIcon"
          :class="draftsDropZoneClasses"
          @dragover="handleDraftsDragOver"
          @dragenter="handleDraftsDragEnter"
          @dragleave="handleDraftsDragLeave"
          @drop="handleDraftsDrop"
        >
          Drafts
          <UBadge
            v-if="draftsCount > 0"
            variant="soft"
            color="lime"
            size="xs"
            class="ml-2"
          >
            {{ draftsCount }}
          </UBadge>
        </UTabsTrigger>

        <UTabsTrigger
          v-if="loggedIn"
          value="archived"
          :leading="archivedIcon"
          :class="archivedDropZoneClasses"
          @dragover="handleArchivedDragOver"
          @dragenter="handleArchivedDragEnter"
          @dragleave="handleArchivedDragLeave"
          @drop="handleArchivedDrop"
        >
          Archived
          <UBadge
            v-if="archivedCount > 0"
            variant="soft"
            color="gray"
            size="xs"
            class="ml-2"
          >
            {{ archivedCount }}
          </UBadge>
        </UTabsTrigger>
      </UTabsList>

      <!-- Published Posts Tab -->
      <UTabsContent value="published">
        <PostsTabContent
          :posts="publishedPosts"
          :is-loading="isPublishedLoading"
          :error="publishedError"
          title="Published Posts"
          empty-title="No published posts yet"
          empty-description="Your published posts will appear here once you start sharing your thoughts with the world."
          empty-action-text="Publish First Post"
          empty-action-icon="i-lucide-send"
          @refresh="$emit('refresh-published')"
          @retry="$emit('retry-published')"
          @empty-action="$emit('create-post')"
          @edit="$emit('edit', $event)"
          @delete="$emit('delete', $event)"
          @unpublish="$emit('unpublish', $event)"
          @duplicate="$emit('duplicate', $event)"
          @archive="$emit('archive', $event)"
          @share="$emit('share', $event)"
          @export="$emit('export', $event)"
          @view-stats="$emit('view-stats', $event)"
          @drag-start="() => {}"
          @drag-end="() => {}"
        >
          <template #actions>
            <div class="flex items-center gap-2">
              <UButton
                btn="soft-gray"
                size="xs"
                class="dark:color-#3b82f6"
                :loading="isPublishedLoading"
                @click="$emit('refresh-published')"
              >
                <UIcon name="i-ph-arrows-counter-clockwise-duotone" />
                <span>Refresh</span>
              </UButton>

              <UButton
                v-if="publishedPosts.length > 0"
                btn="soft-gray"
                size="xs"
                class="dark:color-#3b82f6"
                @click="$emit('bulk-export')"
              >
                <UIcon name="i-lucide-download" />
                <span>Export All</span>
              </UButton>

              <UButton
                v-if="loggedIn"
                btn="soft-gray"
                size="xs"
                class="dark:color-#3b82f6"
                @click="$emit('manage-tags')"
              >
                <UIcon name="i-lucide-tags" />
                <span>Manage Tags</span>
              </UButton>
            </div>
          </template>
        </PostsTabContent>
      </UTabsContent>

      <!-- Drafts Tab -->
      <UTabsContent v-if="loggedIn" value="drafts">
        <PostsTabContent
          :posts="draftPosts"
          :is-loading="isDraftsLoading"
          :error="draftsError"
          title="Draft Posts"
          empty-title="No drafts yet"
          empty-description="Start writing a new post to create your first draft."
          empty-action-text="Write New Post"
          empty-action-icon="i-lucide-pen-tool"
          @refresh="$emit('refresh-drafts')"
          @retry="$emit('retry-drafts')"
          @empty-action="$emit('create-post')"
          @edit="$emit('edit', $event)"
          @delete="$emit('delete', $event)"
          @publish="$emit('publish', $event)"
          @duplicate="$emit('duplicate', $event)"
          @drag-start="() => {}"
          @drag-end="() => {}"
        >
          <template #actions>
            <div class="flex items-center gap-2">
              <UButton
                size="xs"
                btn="soft-gray"
                class="dark:color-#f59e0b"
                :loading="isDraftsLoading"
                @click="$emit('refresh-drafts')"
              >
                <UIcon name="i-ph-arrows-counter-clockwise-duotone" />
                <span>Refresh</span>
              </UButton>

              <UButton
                size="xs"
                btn="soft-gray"
                class="dark:color-#f59e0b"
                @click="$emit('create-post')"
              >
                <UIcon name="i-lucide-pen-tool" />
                <span>New Draft</span>
              </UButton>

              <UButton
                v-if="draftPosts.length > 0"
                size="xs"
                btn="soft-gray"
                class="dark:color-#f59e0b"
                @click="$emit('bulk-archive-drafts')"
              >
                <UIcon name="i-lucide-archive" />
                <span>Archive</span>
              </UButton>
            </div>
          </template>
        </PostsTabContent>
      </UTabsContent>

      <!-- Archived Posts Tab -->
      <UTabsContent v-if="loggedIn" value="archived">
        <PostsTabContent
          :posts="archivedPosts"
          :is-loading="isArchivedLoading"
          :error="archivedError"
          title="Archived Posts"
          empty-title="No archived posts yet"
          empty-description="Posts you archive will appear here. They remain private and can be restored anytime."
          empty-action-text="View Published Posts"
          empty-action-icon="i-lucide-eye"
          @refresh="$emit('refresh-archived')"
          @retry="$emit('retry-archived')"
          @empty-action="() => handleTabChange('published')"
          @edit="$emit('edit', $event)"
          @delete="$emit('delete', $event)"
          @publish="$emit('publish', $event)"
          @duplicate="$emit('duplicate', $event)"
          @unarchive="$emit('unarchive', $event)"
          @drag-start="() => {}"
          @drag-end="() => {}"
        >
          <template #actions>
            <div class="flex items-center gap-2">
              <UButton
                size="xs"
                btn="soft-gray"
                class="dark:color-#6b7280"
                :loading="isArchivedLoading"
                @click="$emit('refresh-archived')"
              >
                <UIcon name="i-ph-arrows-counter-clockwise-duotone" />
                <span>Refresh</span>
              </UButton>

              <UButton
                v-if="archivedPosts.length > 0"
                size="xs"
                btn="soft-gray"
                class="dark:color-#6b7280"
                @click="$emit('bulk-restore-archived')"
              >
                <UIcon name="i-lucide-archive-restore" />
                <span>Restore All</span>
              </UButton>
            </div>
          </template>
        </PostsTabContent>
      </UTabsContent>
    </UTabs>
  </div>
</template>

<script setup lang="ts">
import type { Post } from '~/types/post'
import type { DragData } from '~/composables/useDragAndDrop'

interface PostsTabsProps {
  // Posts data
  publishedPosts: Post[]
  draftPosts: Post[]
  archivedPosts: Post[]
  
  // Loading states
  isPublishedLoading: boolean
  isDraftsLoading: boolean
  isArchivedLoading: boolean
  
  // Error states
  publishedError: string | null
  draftsError: string | null
  archivedError: string | null
  
  // User state
  loggedIn: boolean
  
  // Tab configuration
  defaultTab?: 'published' | 'drafts' | 'archived'
}

interface PostsTabsEmits {
  // Tab management
  (e: 'tab-change', tab: string): void
  
  // Post actions
  (e: 'create-post'): void
  (e: 'edit', post: Post): void
  (e: 'delete', post: Post): void
  (e: 'publish', post: Post): void
  (e: 'unpublish', post: Post): void
  (e: 'archive', post: Post): void
  (e: 'unarchive', post: Post): void
  (e: 'duplicate', post: Post): void
  (e: 'share', post: Post): void
  (e: 'export', post: Post): void
  (e: 'view-stats', post: Post): void
  
  // Refresh actions
  (e: 'refresh-published'): void
  (e: 'refresh-drafts'): void
  (e: 'refresh-archived'): void
  (e: 'retry-published'): void
  (e: 'retry-drafts'): void
  (e: 'retry-archived'): void
  
  // Bulk actions
  (e: 'bulk-export'): void
  (e: 'bulk-archive-drafts'): void
  (e: 'bulk-restore-archived'): void
  (e: 'manage-tags'): void

  // Drag and drop actions
  (e: 'post-status-change', post: Post, newStatus: 'draft' | 'published' | 'archived'): void
}

const props = withDefaults(defineProps<PostsTabsProps>(), {
  defaultTab: 'published'
})

const emit = defineEmits<PostsTabsEmits>()

// Tab state
const activeTab = ref(props.defaultTab)

// Computed counts
const publishedCount = computed(() => props.publishedPosts.length)
const draftsCount = computed(() => props.draftPosts.length)
const archivedCount = computed(() => props.archivedPosts.length)

// Tab styling
const publishedIcon = 'i-ph-newspaper-clipping-duotone'
const draftsIcon = 'i-ph-toilet-paper-duotone'
const archivedIcon = 'i-ph-archive-duotone'

// Tab change handler
const handleTabChange = (tab: string | number) => {
  const tabValue = String(tab) as 'published' | 'drafts' | 'archived'
  activeTab.value = tabValue
  emit('tab-change', tabValue)
}

// Watch for prop changes to update active tab
watch(() => props.defaultTab, (newTab) => {
  activeTab.value = newTab
})

// Drag and drop functionality
const { dragOverTarget, handleDragOver, handleDragEnter, handleDragLeave, handleDrop, getTargetStatus } = useDragAndDrop({
  onDrop: async (data: DragData, targetTab: string) => {
    const newStatus = getTargetStatus(targetTab)
    emit('post-status-change', data.post, newStatus)
  }
})

// Drop zone handlers for each tab
const handlePublishedDragOver = (event: DragEvent) => handleDragOver(event, 'published')
const handlePublishedDragEnter = (event: DragEvent) => handleDragEnter(event, 'published')
const handlePublishedDragLeave = (event: DragEvent) => handleDragLeave(event, 'published')
const handlePublishedDrop = (event: DragEvent) => handleDrop(event, 'published')

const handleDraftsDragOver = (event: DragEvent) => handleDragOver(event, 'drafts')
const handleDraftsDragEnter = (event: DragEvent) => handleDragEnter(event, 'drafts')
const handleDraftsDragLeave = (event: DragEvent) => handleDragLeave(event, 'drafts')
const handleDraftsDrop = (event: DragEvent) => handleDrop(event, 'drafts')

const handleArchivedDragOver = (event: DragEvent) => handleDragOver(event, 'archived')
const handleArchivedDragEnter = (event: DragEvent) => handleDragEnter(event, 'archived')
const handleArchivedDragLeave = (event: DragEvent) => handleDragLeave(event, 'archived')
const handleArchivedDrop = (event: DragEvent) => handleDrop(event, 'archived')

// Computed classes for drop zone highlighting
const publishedDropZoneClasses = computed(() => ({
  'ring-2 ring-blue-400 ring-opacity-50 bg-blue-50 dark:bg-blue-900/20': dragOverTarget.value === 'published'
}))

const draftsDropZoneClasses = computed(() => ({
  'ring-2 ring-lime-400 ring-opacity-50 bg-amber-50 dark:bg-amber-900/20': dragOverTarget.value === 'drafts'
}))

const archivedDropZoneClasses = computed(() => ({
  'ring-2 ring-gray-400 ring-opacity-50 bg-gray-50 dark:bg-gray-900/20': dragOverTarget.value === 'archived'
}))
</script>
